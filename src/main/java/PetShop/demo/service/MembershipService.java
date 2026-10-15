package PetShop.demo.service;

import PetShop.demo.model.enity.ChuNuoi;
import PetShop.demo.model.enity.Customer;
import PetShop.demo.model.enity.Order;
import PetShop.demo.model.enity.PhieuDichVuChamSoc;
import PetShop.demo.repository.ChuNuoiRepository;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.repository.OrderRepository;
import PetShop.demo.repository.PhieuDichVuChamSocRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Optional;

@Service
public class MembershipService {

    public static final BigDecimal BASE_UNIT = new BigDecimal("100000"); // 100.000VND = 1 Điểm

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private ChuNuoiRepository chuNuoiRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private PhieuDichVuChamSocRepository phieuRepository;

    /**
     * Tính điểm tích lũy dựa trên số tiền thanh toán thực tế:
     * Cứ mỗi 100.000VND = 1 điểm.
     */
    public int calculatePoints(BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return 0;
        }
        return amount.divideToIntegralValue(BASE_UNIT).intValue();
    }

    /**
     * Xác định hạng thành viên theo số điểm tích lũy:
     * - Dưới 50 điểm: Tiêu chuẩn
     * - Từ 50 - 199 điểm: Thân thiết
     * - Từ 200 - 499 điểm: VIP
     * - Từ 500 điểm trở lên: VVIP
     */
    public String determineTier(int points) {
        if (points >= 500) {
            return "VVIP";
        } else if (points >= 200) {
            return "VIP";
        } else if (points >= 50) {
            return "Thân thiết";
        } else {
            return "Tiêu chuẩn";
        }
    }

    /**
     * Lấy % giảm giá ưu đãi tương ứng với từng hạng:
     * - Tiêu chuẩn: 0%
     * - Thân thiết: 5%
     * - VIP: 10%
     * - VVIP: 15%
     */
    public BigDecimal getDiscountPercentage(String tier) {
        if (tier == null) return BigDecimal.ZERO;
        String t = tier.trim().toUpperCase();
        if (t.equals("VVIP")) {
            return new BigDecimal("15");
        } else if (t.equals("VIP")) {
            return new BigDecimal("10");
        } else if (t.contains("THÂN THIẾT") || t.contains("THAN THIET")) {
            return new BigDecimal("5");
        }
        return BigDecimal.ZERO;
    }

    /**
     * Tính số tiền giảm giá ưu đãi theo hạng thành viên.
     */
    public BigDecimal calculateTierDiscount(BigDecimal totalAmount, String tier) {
        if (totalAmount == null || totalAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        BigDecimal pct = getDiscountPercentage(tier);
        if (pct.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        return totalAmount.multiply(pct).divide(new BigDecimal("100"), 0, RoundingMode.HALF_UP);
    }

    /**
     * Tích điểm và thăng hạng khi hoàn tất đơn hàng mua sản phẩm.
     */
    @Transactional
    public void processOrderPoints(Order order) {
        if (order == null || Boolean.TRUE.equals(order.getDaCongDiem()) || !Boolean.TRUE.equals(order.getDaThanhToan())) {
            return;
        }

        int pointsToAdd = calculatePoints(order.getTongTien());
        if (pointsToAdd > 0 && order.getMaKH() != null) {
            Optional<Customer> customerOpt = customerRepository.findById(order.getMaKH());
            if (customerOpt.isPresent()) {
                Customer customer = customerOpt.get();
                int currentPoints = customer.getDiemTichLuy() != null ? customer.getDiemTichLuy() : 0;
                int newPoints = currentPoints + pointsToAdd;
                customer.setDiemTichLuy(newPoints);
                customer.setHangThanhVien(determineTier(newPoints));
                customerRepository.save(customer);

                // Đồng bộ sang bảng ChuNuoi nếu đã tồn tại chủ nuôi tương ứng
                syncToChuNuoi(customer);
            }
        }

        order.setDaCongDiem(true);
        orderRepository.save(order);
    }

    /**
     * Tích điểm và thăng hạng khi hoàn tất/thanh toán phiếu dịch vụ chăm sóc.
     */
    @Transactional
    public void processCareTicketPoints(PhieuDichVuChamSoc ticket) {
        if (ticket == null || Boolean.TRUE.equals(ticket.getDaCongDiem())) {
            return;
        }

        boolean isPaidOrCompleted = "Đã thanh toán".equalsIgnoreCase(ticket.getTrangThaiThanhToan())
                || "Hoàn thành chăm sóc".equalsIgnoreCase(ticket.getTrangThaiDichVu())
                || "Đã bàn giao thú cưng".equalsIgnoreCase(ticket.getTrangThaiDichVu());

        if (!isPaidOrCompleted) {
            return;
        }

        int pointsToAdd = calculatePoints(ticket.getThanhToan());
        if (pointsToAdd > 0 && ticket.getMaChuNuoi() != null) {
            Optional<ChuNuoi> ownerOpt = chuNuoiRepository.findById(ticket.getMaChuNuoi());
            if (ownerOpt.isPresent()) {
                ChuNuoi owner = ownerOpt.get();
                int currentPoints = owner.getDiemTichLuy() != null ? owner.getDiemTichLuy() : 0;
                int newPoints = currentPoints + pointsToAdd;
                owner.setDiemTichLuy(newPoints);
                owner.setLoaiChuNuoi(determineTier(newPoints));
                chuNuoiRepository.save(owner);

                // Đồng bộ sang tài khoản Customer nếu có liên kết
                syncToCustomer(owner);
            }
        }

        ticket.setDaCongDiem(true);
        phieuRepository.save(ticket);
    }

    /**
     * Cập nhật thông tin hạng và điểm vào session sau khi đăng nhập hoặc sau khi mua sắm.
     */
    public void updateSessionMembership(HttpSession session, Customer customer) {
        if (session != null && customer != null) {
            session.setAttribute("hangThanhVien", customer.getHangThanhVien());
            session.setAttribute("diemTichLuy", customer.getDiemTichLuy());
            session.setAttribute("phanTramGiamHang", getDiscountPercentage(customer.getHangThanhVien()));
        }
    }

    private void syncToChuNuoi(Customer customer) {
        try {
            Optional<ChuNuoi> ownerOpt = Optional.empty();
            if (customer.getMaKH() != null) {
                ownerOpt = chuNuoiRepository.findFirstByMaKH(customer.getMaKH());
            }
            if (ownerOpt.isEmpty() && customer.getDienThoai() != null && !customer.getDienThoai().isBlank()) {
                ownerOpt = chuNuoiRepository.findFirstBySoDienThoai(customer.getDienThoai().trim());
            }

            if (ownerOpt.isPresent()) {
                ChuNuoi owner = ownerOpt.get();
                owner.setDiemTichLuy(customer.getDiemTichLuy());
                owner.setLoaiChuNuoi(customer.getHangThanhVien());
                if (owner.getMaKH() == null) {
                    owner.setMaKH(customer.getMaKH());
                }
                chuNuoiRepository.save(owner);
            }
        } catch (Exception ignored) {
        }
    }

    private void syncToCustomer(ChuNuoi owner) {
        try {
            Optional<Customer> customerOpt = Optional.empty();
            if (owner.getMaKH() != null) {
                customerOpt = customerRepository.findById(owner.getMaKH());
            }
            if (customerOpt.isEmpty() && owner.getSoDienThoai() != null && !owner.getSoDienThoai().isBlank()) {
                customerOpt = customerRepository.findByDienThoai(owner.getSoDienThoai().trim());
            }

            if (customerOpt.isPresent()) {
                Customer customer = customerOpt.get();
                customer.setDiemTichLuy(owner.getDiemTichLuy());
                customer.setHangThanhVien(owner.getLoaiChuNuoi());
                customerRepository.save(customer);
            }
        } catch (Exception ignored) {
        }
    }
}

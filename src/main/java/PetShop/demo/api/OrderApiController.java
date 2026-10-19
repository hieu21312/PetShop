package PetShop.demo.api;

import PetShop.demo.model.enity.Order;
import PetShop.demo.model.enity.OrderDetail;
import PetShop.demo.model.enity.OrderDetailId;
import PetShop.demo.model.enity.Product;
import PetShop.demo.repository.OrderDetailRepository;
import PetShop.demo.repository.OrderRepository;
import PetShop.demo.repository.ProductRepository;
import PetShop.demo.service.MembershipService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

import org.springframework.http.MediaType;

@RestController
@RequestMapping(value = "/api/orders", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
@CrossOrigin(origins = "*")
public class OrderApiController {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderDetailRepository orderDetailRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private MembershipService membershipService;

    @Autowired
    private PetShop.demo.service.ThongBaoService thongBaoService;

    @Autowired
    private PetShop.demo.repository.VoucherRepository voucherRepository;

    @Autowired
    private PetShop.demo.repository.CustomerRepository customerRepository;

    // Xem danh sách đơn hàng của khách
    @GetMapping("/my")
    public ResponseEntity<?> getMyOrders(@RequestParam Integer maKH) {
        List<Order> orders = orderRepository.findByMaKHOrderByNgayLapDesc(maKH);
        List<Map<String, Object>> list = new ArrayList<>();
        for (Order o : orders) {
            Map<String, Object> m = new HashMap<>();
            m.put("maHD", o.getMaHD());
            m.put("ngayLap", o.getNgayLap() != null ? o.getNgayLap().toString() : "");
            m.put("tongTien", o.getTongTien());
            m.put("tinhTrang", o.getTinhTrang());
            m.put("tinhTrangText", o.getOrderStatus() != null ? o.getOrderStatus().getTinhTrangDonHang() : "Đang xử lý");
            m.put("daThanhToan", o.getDaThanhToan());
            m.put("diaChiGiaoHang", o.getDiaChiGiaoHang());
            m.put("hinhThucThanhToan", o.getHinhThucThanhToan());
            list.add(m);
        }
        return ResponseEntity.ok(list);
    }

    // Xem chi tiết đơn hàng
    @GetMapping("/{id}")
    public ResponseEntity<?> getOrderDetail(@PathVariable Integer id) {
        Optional<Order> orderOpt = orderRepository.findById(id);
        if (orderOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Order o = orderOpt.get();
        Map<String, Object> res = new HashMap<>();
        res.put("maHD", o.getMaHD());
        res.put("ngayLap", o.getNgayLap() != null ? o.getNgayLap().toString() : "");
        res.put("tongTien", o.getTongTien());
        res.put("tienGiam", o.getTienGiam());
        res.put("maGiamGia", o.getMaGiamGia());
        res.put("tinhTrang", o.getTinhTrang());
        res.put("tinhTrangText", o.getOrderStatus() != null ? o.getOrderStatus().getTinhTrangDonHang() : "Đang xử lý");
        res.put("daThanhToan", o.getDaThanhToan());
        res.put("diaChiGiaoHang", o.getDiaChiGiaoHang());
        res.put("hinhThucThanhToan", o.getHinhThucThanhToan());

        List<OrderDetail> details = orderDetailRepository.findById_MaHD(o.getMaHD());
        List<Map<String, Object>> itemList = new ArrayList<>();
        for (OrderDetail d : details) {
            Map<String, Object> im = new HashMap<>();
            im.put("maSP", d.getId().getMaSP());
            im.put("soLuong", d.getSoLuong());
            im.put("giaBan", d.getGiaBan());
            if (d.getProduct() != null) {
                im.put("tenSP", d.getProduct().getTenSP());
                im.put("anhDaiDien", d.getProduct().getAnhDaiDien());
            }
            itemList.add(im);
        }
        res.put("items", itemList);

        return ResponseEntity.ok(res);
    }

    // Đặt hàng từ Mobile
    @PostMapping
    public ResponseEntity<?> createOrder(@RequestBody Map<String, Object> payload) {
        Integer maKH = payload.get("maKH") != null ? Integer.parseInt(payload.get("maKH").toString()) : null;
        String diaChi = (String) payload.get("diaChiGiaoHang");
        String rawMaGiamGia = (String) payload.get("maGiamGia");
        String rawHinhThuc = (String) payload.get("hinhThucThanhToan");
        String hinhThuc = (rawHinhThuc != null && !rawHinhThuc.trim().isEmpty()) ? rawHinhThuc.trim() : "COD";
        List<Map<String, Object>> items = (List<Map<String, Object>>) payload.get("items");

        if (maKH == null || diaChi == null || items == null || items.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Thông tin đơn hàng không hợp lệ"));
        }

        BigDecimal subtotal = BigDecimal.ZERO;
        List<OrderDetail> detailList = new ArrayList<>();

        for (Map<String, Object> itemMap : items) {
            int maSP = Integer.parseInt(itemMap.get("maSP").toString());
            int soLuong = Integer.parseInt(itemMap.get("soLuong").toString());
            Optional<Product> pOpt = productRepository.findById(maSP);
            if (pOpt.isPresent()) {
                Product p = pOpt.get();
                BigDecimal itemPrice = p.getGiaBan() != null ? p.getGiaBan() : BigDecimal.ZERO;
                subtotal = subtotal.add(itemPrice.multiply(BigDecimal.valueOf(soLuong)));

                OrderDetail d = new OrderDetail();
                d.setId(new OrderDetailId(null, maSP));
                d.setProduct(p);
                d.setSoLuong(soLuong);
                d.setGiaBan(itemPrice);
                detailList.add(d);
            }
        }

        // Xử lý mã giảm giá an toàn: kiểm tra có trong tblMaGiamGia hay không
        String cleanMaGiamGia = (rawMaGiamGia != null && !rawMaGiamGia.trim().isEmpty()) ? rawMaGiamGia.trim().toUpperCase() : null;
        BigDecimal discount = BigDecimal.ZERO;

        if (cleanMaGiamGia != null) {
            var vOpt = voucherRepository.findById(cleanMaGiamGia);
            if (vOpt.isEmpty()) {
                cleanMaGiamGia = null; // Bỏ qua mã nếu không có trong database để không vi phạm FK_tblHoaDon_tblMaGiamGia
            } else {
                PetShop.demo.model.enity.Voucher v = vOpt.get();
                if (v.getPhanTramGiam() != null && v.getPhanTramGiam().compareTo(BigDecimal.ZERO) > 0) {
                    BigDecimal calcDiscount = subtotal.multiply(v.getPhanTramGiam()).divide(BigDecimal.valueOf(100));
                    if (v.getSoTienGiamToiDa() != null && calcDiscount.compareTo(v.getSoTienGiamToiDa()) > 0) {
                        calcDiscount = v.getSoTienGiamToiDa();
                    }
                    discount = calcDiscount;
                }
            }
        }

        // Áp dụng thêm ưu đãi thành viên nếu có
        Optional<PetShop.demo.model.enity.Customer> custOpt = customerRepository.findById(maKH);
        if (custOpt.isPresent()) {
            PetShop.demo.model.enity.Customer c = custOpt.get();
            String tier = c.getHangThanhVien() != null ? c.getHangThanhVien() : membershipService.determineTier(c.getDiemTichLuy() != null ? c.getDiemTichLuy() : 0);
            BigDecimal memberDiscount = membershipService.calculateTierDiscount(subtotal, tier);
            if (memberDiscount != null && memberDiscount.compareTo(discount) > 0) {
                discount = memberDiscount;
            }
        }

        BigDecimal finalTotal = subtotal.subtract(discount).max(BigDecimal.ZERO);

        try {
            Order order = new Order();
            order.setMaKH(maKH);
            order.setNgayLap(LocalDateTime.now());
            order.setDiaChiGiaoHang(diaChi.trim());
            order.setMaGiamGia(cleanMaGiamGia); // null nếu không có mã hoặc mã rỗng
            order.setTienGiam(discount);
            order.setTongTien(finalTotal);
            order.setTinhTrang(1); // 1 = Đang xử lý
            order.setDaThanhToan(false);
            order.setHinhThucThanhToan(hinhThuc);

            Order saved = orderRepository.save(order);

            for (OrderDetail d : detailList) {
                d.getId().setMaHD(saved.getMaHD());
                d.setOrder(saved);
                orderDetailRepository.save(d);
            }

            thongBaoService.taoThongBaoDatLich(
                    maKH,
                    "📦 Đặt hàng thành công #" + saved.getMaHD(),
                    "Đơn hàng #" + saved.getMaHD() + " gồm " + detailList.size() + " món với tổng tiền " + finalTotal + " đ đã được tạo thành công.",
                    LocalDateTime.now(),
                    "DonHang",
                    "/DonHang/ChiTiet/" + saved.getMaHD()
            );

            // Tạo thông báo cho thu ngân và admin
            try {
                String custName = custOpt.map(PetShop.demo.model.enity.Customer::getTenKH).orElse("Khách hàng");
                String staffTitle = "BankTransfer".equalsIgnoreCase(hinhThuc)
                        ? "💳 Chờ xác nhận chuyển khoản đơn hàng #" + saved.getMaHD()
                        : "🛒 Đơn hàng mới #" + saved.getMaHD();
                String staffContent = "Khách hàng " + custName + " vừa đặt đơn hàng #" + saved.getMaHD()
                        + " với tổng tiền " + String.format("%,d", finalTotal.longValue()) + "đ (" + hinhThuc + "). "
                        + ("BankTransfer".equalsIgnoreCase(hinhThuc) ? "Vui lòng kiểm tra chuyển khoản và xác nhận thanh toán." : "Vui lòng xử lý đơn hàng.");

                thongBaoService.taoThongBaoStaff(
                        staffTitle,
                        staffContent,
                        "XacNhanThanhToan",
                        "/admin/thu-ngan?tab=orders"
                );
            } catch (Exception ignored) {}

            Map<String, Object> respMap = new HashMap<>();
            respMap.put("success", true);
            respMap.put("message", "Đặt hàng thành công!");
            respMap.put("maHD", saved.getMaHD());
            respMap.put("tongTien", finalTotal);
            respMap.put("hinhThucThanhToan", hinhThuc);
            return ResponseEntity.ok(respMap);
        } catch (Exception ex) {
            return ResponseEntity.status(500).body(Map.of(
                    "success", false,
                    "message", "Lỗi tạo đơn hàng: " + ex.getMessage()
            ));
        }
    }

    // Hủy đơn hàng từ Mobile
    @PostMapping("/{id}/cancel")
    public ResponseEntity<?> cancelOrder(@PathVariable Integer id, @RequestParam Integer maKH) {
        Optional<Order> orderOpt = orderRepository.findById(id);
        if (orderOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Order o = orderOpt.get();
        if (!maKH.equals(o.getMaKH())) {
            return ResponseEntity.status(403).body(Map.of("success", false, "message", "Bạn không có quyền hủy đơn hàng này"));
        }

        if (o.getTinhTrang() != null && o.getTinhTrang() == 1) {
            o.setTinhTrang(5); // 5 = Đã hủy
            orderRepository.save(o);

            thongBaoService.taoThongBaoDatLich(
                    maKH,
                    "❌ Đơn hàng #" + id + " đã được hủy",
                    "Bạn đã hủy đơn hàng #" + id + " thành công.",
                    LocalDateTime.now(),
                    "HuyDon",
                    "/DonHang/ChiTiet/" + id
            );

            return ResponseEntity.ok(Map.of("success", true, "message", "Đã hủy đơn hàng #" + id));
        }

        return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Không thể hủy đơn này vì đã được xử lý"));
    }
}

package PetShop.demo.service;

import PetShop.demo.model.enity.*;
import PetShop.demo.model.dto.CartItemDTO;
import PetShop.demo.repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class OrderService {
    @Autowired private OrderRepository orderRepository;
    @Autowired private OrderDetailRepository orderDetailRepository;
    @Autowired private VoucherRepository voucherRepository;
    @Autowired private CartService cartService;
    @Autowired private ProductRepository productRepository;
    @Autowired private InventoryRepository inventoryRepository;

    @Transactional
    public Order createOrder(String diaChiGiaoHang, Boolean daThanhToan, String maGiamGia, BigDecimal tienGiam, String hinhThuc, HttpSession session) {
        Integer maKH = (Integer) session.getAttribute("maKH");
        if (maKH == null) return null;

        List<CartItemDTO> cart = cartService.getCart(session);
        if (cart.isEmpty()) return null;

        // 1. Kiểm tra tồn kho trước khi đặt hàng
        for (CartItemDTO item : cart) {
            Product product = productRepository.findById(item.getMaSP())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm với ID: " + item.getMaSP()));
            var invOpt = inventoryRepository.findById(item.getMaSP());
            if (invOpt.isPresent()) {
                Inventory inv = invOpt.get();
                if (inv.getSoLuongTon() != null && inv.getSoLuongTon() < item.getSoLuong()) {
                    throw new RuntimeException("Sản phẩm '" + product.getTenSP() + "' chỉ còn " + inv.getSoLuongTon() + " trong kho, không đủ số lượng bạn đặt (" + item.getSoLuong() + ")!");
                }
            }
        }

        BigDecimal tongTien = cartService.getTotalPrice(session);
        BigDecimal cleanTienGiam = (tienGiam != null && tienGiam.compareTo(BigDecimal.ZERO) > 0) ? tienGiam : null;
        BigDecimal tongSauGiam = tongTien.subtract(cleanTienGiam != null ? cleanTienGiam : BigDecimal.ZERO);
        if (tongSauGiam.compareTo(BigDecimal.ZERO) < 0) {
            tongSauGiam = BigDecimal.ZERO;
        }

        String cleanMaGiamGia = (maGiamGia != null && !maGiamGia.trim().isEmpty()) ? maGiamGia.trim() : null;
        if (cleanMaGiamGia != null) {
            var vOpt = voucherRepository.findById(cleanMaGiamGia);
            if (vOpt.isEmpty()) {
                cleanMaGiamGia = null;
            }
        }

        Order order = new Order();
        order.setMaKH(maKH);
        order.setNgayLap(LocalDateTime.now());
        order.setDiaChiGiaoHang(diaChiGiaoHang);
        order.setTinhTrang(1);
        order.setMaGiamGia(cleanMaGiamGia);
        order.setTienGiam(cleanTienGiam);
        order.setTongTien(tongSauGiam);
        order.setDaThanhToan(daThanhToan);
        order.setHinhThucThanhToan(hinhThuc);
        order = orderRepository.save(order);

        for (CartItemDTO item : cart) {
            OrderDetail detail = new OrderDetail();

            // 1. Tạo OrderDetailId và set giá trị
            OrderDetailId id = new OrderDetailId(order.getMaHD(), item.getMaSP());
            detail.setId(id);

            // 2. Set order
            detail.setOrder(order);

            // 3. Lấy Product từ database
            Product product = productRepository.findById(item.getMaSP())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm với ID: " + item.getMaSP()));
            detail.setProduct(product);
            detail.setSoLuong(item.getSoLuong());
            detail.setGiaBan(item.getGiaBan());

            orderDetailRepository.save(detail);

            // Trừ số lượng tồn kho thực tế trong tblTonKho
            inventoryRepository.findById(item.getMaSP()).ifPresent(inv -> {
                if (inv.getSoLuongTon() != null) {
                    inv.setSoLuongTon(Math.max(0, inv.getSoLuongTon() - item.getSoLuong()));
                    inventoryRepository.save(inv);
                }
            });
        }

        // Giảm số lượng voucher
        if (cleanMaGiamGia != null) {
            voucherRepository.findById(cleanMaGiamGia).ifPresent(v -> {
                if (v.getSoLuong() != null && v.getSoLuong() > 0) {
                    v.setSoLuong(v.getSoLuong() - 1);
                    voucherRepository.save(v);
                }
            });
        }

        cartService.clearCart(session);
        return order;
    }

    // Hoàn trả số lượng tồn kho và hoàn voucher khi hủy đơn hàng
    @Transactional
    public void cancelOrderAndRestoreStock(Order order) {
        if (order == null) return;
        List<OrderDetail> details = orderDetailRepository.findById_MaHD(order.getMaHD());
        for (OrderDetail d : details) {
            if (d.getId() != null && d.getId().getMaSP() != null && d.getSoLuong() != null) {
                inventoryRepository.findById(d.getId().getMaSP()).ifPresent(inv -> {
                    if (inv.getSoLuongTon() != null) {
                        inv.setSoLuongTon(inv.getSoLuongTon() + d.getSoLuong());
                        inventoryRepository.save(inv);
                    }
                });
            }
        }

        // Hoàn lại voucher nếu có
        if (order.getMaGiamGia() != null && !order.getMaGiamGia().isEmpty()) {
            voucherRepository.findById(order.getMaGiamGia()).ifPresent(v -> {
                v.setSoLuong(v.getSoLuong() + 1);
                voucherRepository.save(v);
            });
        }
    }
}
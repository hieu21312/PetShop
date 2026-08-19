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
    @Transactional
    public Order createOrder(String diaChiGiaoHang, Boolean daThanhToan, String maGiamGia, BigDecimal tienGiam,String hinhThuc, HttpSession session) {
        Integer maKH = (Integer) session.getAttribute("maKH");
        if (maKH == null) return null;

        List<CartItemDTO> cart = cartService.getCart(session);
        if (cart.isEmpty()) return null;

        BigDecimal tongTien = cartService.getTotalPrice(session);
        BigDecimal tongSauGiam = tongTien.subtract(tienGiam != null ? tienGiam : BigDecimal.ZERO);

        Order order = new Order();
        order.setMaKH(maKH);
        order.setNgayLap(LocalDateTime.now());
        order.setDiaChiGiaoHang(diaChiGiaoHang);
        order.setTinhTrang(1);
        order.setMaGiamGia(maGiamGia);
        order.setTienGiam(tienGiam);
        order.setTongTien(tongSauGiam);
        order.setDaThanhToan(daThanhToan);
        order.setHinhThucThanhToan(hinhThuc);
        order = orderRepository.save(order);

        for (CartItemDTO item : cart) {
            OrderDetail detail = new OrderDetail();

            // 1. Tạo OrderDetailId và set giá trị
            OrderDetailId id = new OrderDetailId(order.getMaHD(), item.getMaSP());
            detail.setId(id);

            // 2. Set order (quan hệ ManyToOne)
            detail.setOrder(order);

            // 3. Lấy Product từ database (quan trọng: không tạo mới)
            Product product = productRepository.findById(item.getMaSP())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm với ID: " + item.getMaSP()));
            detail.setProduct(product);

            detail.setSoLuong(item.getSoLuong());
            detail.setGiaBan(item.getGiaBan());

            orderDetailRepository.save(detail);
        }

        // Giảm số lượng voucher
        if (maGiamGia != null && !maGiamGia.isEmpty()) {
            voucherRepository.findById(maGiamGia).ifPresent(v -> {
                v.setSoLuong(v.getSoLuong() - 1);
                voucherRepository.save(v);
            });
        }

        cartService.clearCart(session);
        return order;
    }
}
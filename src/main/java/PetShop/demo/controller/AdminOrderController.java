package PetShop.demo.controller;

import PetShop.demo.model.enity.Order;
import PetShop.demo.repository.OrderRepository;
import PetShop.demo.repository.OrderStatusRepository;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/orders")
public class AdminOrderController {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderStatusRepository orderStatusRepository;

    @Autowired
    private AuthService authService;

    @Autowired
    private PetShop.demo.service.MembershipService membershipService;

    // Danh sách đơn hàng
    @GetMapping
    public String listOrders(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        List<Order> orders = orderRepository.findAllByOrderByNgayLapDesc();
        model.addAttribute("orders", orders);
        return "admin/orders";
    }

    // Xem chi tiết đơn hàng
    @GetMapping("/detail/{id}")
    public String orderDetail(@PathVariable Integer id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Order order = orderRepository.findById(id).orElse(null);
        if (order == null) return "redirect:/admin/orders";
        model.addAttribute("order", order);
        model.addAttribute("statuses", orderStatusRepository.findAll());
        int pointsEarned = membershipService.calculatePoints(order.getTongTien());
        model.addAttribute("pointsEarned", pointsEarned);
        return "admin/order-detail";
    }

    // Cập nhật đơn hàng (tình trạng, địa chỉ, thanh toán)
    @PostMapping("/update")
    public String updateOrder(@ModelAttribute Order updatedOrder,
                              @RequestParam Integer maHD,
                              HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Order order = orderRepository.findById(maHD).orElse(null);
        if (order == null) return "redirect:/admin/orders";
        order.setTinhTrang(updatedOrder.getTinhTrang());
        order.setDiaChiGiaoHang(updatedOrder.getDiaChiGiaoHang());
        order.setDaThanhToan(updatedOrder.getDaThanhToan());
        orderRepository.save(order);

        // Tự động tích điểm và nâng hạng nếu đơn hàng đã thanh toán
        if (Boolean.TRUE.equals(order.getDaThanhToan())) {
            membershipService.processOrderPoints(order);
        }

        return "redirect:/admin/orders/detail/" + maHD;
    }
}
package PetShop.demo.controller;

import PetShop.demo.model.enity.Order;
import PetShop.demo.repository.OrderDetailRepository;
import PetShop.demo.repository.OrderRepository;
import PetShop.demo.repository.OrderStatusRepository;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/DonHang")
public class OrderController {
    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderDetailRepository orderDetailRepository;

    @Autowired
    private OrderStatusRepository orderStatusRepository;

    @Autowired
    private AuthService authService;

    @GetMapping("/CuaToi")
    public String myOrders(Model model, HttpSession session) {
        if (!authService.isLoggedIn(session)) {
            return "redirect:/DangNhap?returnUrl=/DonHang/CuaToi";
        }
        Integer maKH = (Integer) session.getAttribute("maKH");
        if (maKH == null) {
            return "redirect:/DangNhap";
        }
        var orders = orderRepository.findByMaKHOrderByNgayLapDesc(maKH);
        model.addAttribute("orders", orders);
        return "my-orders";
    }

    @GetMapping("/ChiTiet/{id}")
    public String customerOrderDetail(@PathVariable Integer id, Model model, HttpSession session) {
        if (!authService.isLoggedIn(session)) {
            return "redirect:/DangNhap";
        }
        Integer maKH = (Integer) session.getAttribute("maKH");
        var orderOpt = orderRepository.findById(id);
        if (orderOpt.isEmpty()) {
            return "redirect:/DonHang/CuaToi";
        }
        Order order = orderOpt.get();

        if (!authService.isAdmin(session) && (maKH == null || !maKH.equals(order.getMaKH()))) {
            return "redirect:/DonHang/CuaToi";
        }
        var details = orderDetailRepository.findById_MaHD(order.getMaHD());
        model.addAttribute("order", order);
        model.addAttribute("details", details);
        return "my-order-detail";
    }

    @PostMapping("/Huy/{id}")
    public String cancelOrder(@PathVariable Integer id,
                              HttpSession session,
                              org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        if (!authService.isLoggedIn(session)) {
            return "redirect:/DangNhap";
        }
        Integer maKH = (Integer) session.getAttribute("maKH");
        var orderOpt = orderRepository.findById(id);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            if (maKH != null && maKH.equals(order.getMaKH())) {
                if (order.getTinhTrang() != null && order.getTinhTrang() == 1) {
                    order.setTinhTrang(5);
                    orderRepository.save(order);
                    redirectAttributes.addFlashAttribute("successMessage", "Hủy đơn hàng #" + id + " thành công!");
                } else {
                    redirectAttributes.addFlashAttribute("errorMessage", "Không thể hủy đơn do đơn đã được tiếp nhận xử lý hoặc đang giao!");
                }
            }
        }
        return "redirect:/DonHang/ChiTiet/" + id;
    }

    @GetMapping("/Index")
    public String listOrders(Model model) {
        var orders = orderRepository.findAllByOrderByNgayLapDesc();
        model.addAttribute("orders", orders);
        return "order-list";
    }

    @GetMapping("/CapNhat")
    public String editOrder(@RequestParam int id, Model model) {
        var orderOpt = orderRepository.findById(id);
        if (orderOpt.isEmpty()) {
            return "redirect:/DonHang/Index";
        }
        Order order = orderOpt.get();
        model.addAttribute("order", order);
        model.addAttribute("statusList", orderStatusRepository.findAll());
        return "order-edit";
    }

    @PostMapping("/CapNhat")
    public String updateOrder(@ModelAttribute Order order,
                              @RequestParam int TinhTrang,
                              @RequestParam(required = false) Boolean DaThanhToan,
                              @RequestParam String DiaChiGiaoHang) {
        var existing = orderRepository.findById(order.getMaHD());
        if (existing.isPresent()) {
            Order o = existing.get();
            o.setTinhTrang(TinhTrang);
            o.setDaThanhToan(DaThanhToan != null ? DaThanhToan : false);
            o.setDiaChiGiaoHang(DiaChiGiaoHang);
            orderRepository.save(o);
        }
        return "redirect:/DonHang/Index";
    }
}

package PetShop.demo.controller;

import PetShop.demo.model.enity.Order;
import PetShop.demo.repository.OrderRepository;
import PetShop.demo.repository.OrderStatusRepository;
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
    private OrderStatusRepository orderStatusRepository;

    // Danh sách đơn hàng (Admin)
    @GetMapping("/Index")
    public String listOrders(Model model) {
        var orders = orderRepository.findAllByOrderByNgayLapDesc();
        model.addAttribute("orders", orders);
        return "order-list";
    }

    // Trang cập nhật đơn hàng
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

    // Lưu cập nhật đơn hàng
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
package PetShop.demo.controller;

import PetShop.demo.model.enity.Customer;
import PetShop.demo.model.enity.Order;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.repository.OrderRepository;
import PetShop.demo.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin/customers")
public class AdminCustomerController {

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private AuthService authService;

    // Danh sách khách hàng
    @GetMapping
    public String listCustomers(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        List<Customer> customers = customerRepository.findAll();
        model.addAttribute("customers", customers);
        return "admin/customers";
    }

    // Xem đơn hàng của khách hàng
    @GetMapping("/orders/{id}")
    public String viewOrders(@PathVariable Integer id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Customer customer = customerRepository.findById(id).orElse(null);
        if (customer == null) return "redirect:/admin/customers";
        List<Order> orders = orderRepository.findByMaKHOrderByNgayLapDesc(id);
        model.addAttribute("customer", customer);
        model.addAttribute("orders", orders);
        return "admin/customer-orders";
    }
}
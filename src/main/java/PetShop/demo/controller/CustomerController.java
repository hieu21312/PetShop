package PetShop.demo.controller;

import PetShop.demo.model.enity.Customer;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/QLKhachHang")
public class CustomerController {

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private OrderRepository orderRepository;

    @GetMapping("/Index")
    public String listCustomers(Model model) {
        model.addAttribute("customers", customerRepository.findAll());
        return "customer-list";
    }

    @GetMapping("/XemDonHang/{id}")
    public String viewOrders(@PathVariable int id, Model model) {
        Customer customer = customerRepository.findById(id).orElse(null);
        if (customer == null) {
            return "redirect:/QLKhachHang/Index";
        }
        var orders = orderRepository.findByMaKHOrderByNgayLapDesc(id);
        model.addAttribute("customer", customer);
        model.addAttribute("orders", orders);
        return "customer-orders";
    }
}
package PetShop.demo.controller;

import PetShop.demo.model.enity.Order;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.StatisticService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/ThongKe")
public class StatisticController {

    @Autowired
    private StatisticService statisticService;

    @Autowired
    private AuthService authService;

    @GetMapping("/Index")
    public String index(@RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
                        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
                        Model model, HttpSession session) {
        if (!authService.isAdmin(session)) {
            return "redirect:/DangNhap";
        }
        if (from == null) from = LocalDate.now();
        if (to == null) to = LocalDate.now();
        model.addAttribute("from", from);
        model.addAttribute("to", to);

        BigDecimal totalRevenue = statisticService.getTotalRevenue(from, to);
        model.addAttribute("tongDoanhThu", totalRevenue);

        List<Order> orders = statisticService.getCompletedOrdersBetween(from, to);
        model.addAttribute("orders", orders);

        return "statistic";
    }
}
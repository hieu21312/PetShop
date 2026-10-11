package PetShop.demo.controller;

import PetShop.demo.model.dto.RevenueReportDTO;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.RevenueReportService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;

@Controller
@RequestMapping("/admin/reports")
public class AdminRevenueReportController {

    @Autowired
    private RevenueReportService revenueReportService;

    @Autowired
    private AuthService authService;

    @GetMapping
    public String viewReport(@RequestParam(value = "type", defaultValue = "week") String type,
                             @RequestParam(value = "date", required = false) String date,
                             @RequestParam(value = "month", required = false) String month,
                             @RequestParam(value = "year", required = false) Integer year,
                             @RequestParam(value = "from", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
                             @RequestParam(value = "to", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
                             Model model, HttpSession session) {
        if (!authService.isAdmin(session)) {
            return "redirect:/DangNhap";
        }

        RevenueReportDTO report = revenueReportService.generateReport(type, date, month, year, from, to);
        model.addAttribute("report", report);
        return "admin/revenue-report";
    }
}

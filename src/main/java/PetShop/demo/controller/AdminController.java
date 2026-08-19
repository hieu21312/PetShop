package PetShop.demo.controller;

import PetShop.demo.service.AdminService;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private AuthService authService;

    // Dashboard Admin
    @GetMapping("/index")
    public String index(Model model, HttpSession session) {
        // Kiểm tra quyền Admin
        if (!authService.isAdmin(session)) {
            return "redirect:/DangNhap";
        }
        model.addAttribute("dashboard", adminService.getDashboardData());
        return "admin/index";
    }
}
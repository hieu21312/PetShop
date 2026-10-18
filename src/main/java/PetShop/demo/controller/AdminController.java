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

    // Điều hướng trang quản trị theo vai trò
    @GetMapping({"", "/"})
    public String adminRoot(HttpSession session) {
        if (!authService.isLoggedIn(session)) {
            return "redirect:/DangNhap";
        }
        if (authService.isAdmin(session)) {
            return "redirect:/admin/index";
        }
        if (authService.isDoctor(session)) {
            return "redirect:/admin/doctor/treatment";
        }
        if (authService.isCashier(session)) {
            return "redirect:/admin/thu-ngan";
        }
        if (session.getAttribute("maNV") != null) {
            return "redirect:/staff/my-tasks";
        }
        return "redirect:/DangNhap";
    }

    // Dashboard Admin
    @GetMapping("/index")
    public String index(Model model, HttpSession session) {
        if (!authService.isLoggedIn(session)) {
            return "redirect:/DangNhap";
        }
        // Kiểm tra quyền Admin, nếu là nhân sự khác thì điều hướng về trang phù hợp
        if (!authService.isAdmin(session)) {
            if (authService.isDoctor(session)) {
                return "redirect:/admin/doctor/treatment";
            }
            if (authService.isCashier(session)) {
                return "redirect:/admin/thu-ngan";
            }
            if (session.getAttribute("maNV") != null) {
                return "redirect:/staff/my-tasks";
            }
            return "redirect:/DangNhap";
        }
        model.addAttribute("dashboard", adminService.getDashboardData());
        return "admin/index";
    }

    // Chuyển tiếp lịch làm việc của nhân viên
    @GetMapping("/my-tasks")
    public String myTasksRedirect() {
        return "redirect:/staff/my-tasks";
    }
}
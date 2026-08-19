package PetShop.demo.controller;

import PetShop.demo.model.enity.Customer;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    @Autowired
    private AuthService authService;

    @Autowired
    private CustomerRepository customerRepository;

    // Hiển thị trang đăng nhập
    @GetMapping("/DangNhap")
    public String loginPage(@RequestParam(required = false) String returnUrl, Model model) {
        model.addAttribute("url", returnUrl != null ? returnUrl : "/");
        return "login";
    }

    // Xử lý đăng nhập (khách hàng + nhân viên)
    @PostMapping("/XuLyDN")
    public String processLogin(@RequestParam String email,
                               @RequestParam String password,
                               @RequestParam(required = false) String url,
                               HttpSession session) {
        // 1. Thử đăng nhập với tư cách khách hàng
        Customer customer = authService.loginCustomer(email, password, session);
        if (customer != null) {
            return "redirect:" + (url != null && !url.isEmpty() ? url : "/");
        }

        // 2. Thử đăng nhập với tư cách nhân viên (mã nhân viên là số)
        try {
            int maNV = Integer.parseInt(email);
            var employee = authService.loginEmployee(maNV, password, session);
            if (employee != null) {
                if (authService.isAdmin(session)) {
                    return "redirect:/admin/index";
                }
                return "redirect:/";
            }
        } catch (NumberFormatException ignored) {
            // Không phải số thì bỏ qua
        }

        // 3. Sai cả hai
        session.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng!");
        return "redirect:/DangNhap?url=" + (url != null ? url : "/");
    }

    // Hiển thị trang đăng ký
    @GetMapping("/DangKy")
    public String registerPage() {
        return "register";
    }

    // Xử lý đăng ký khách hàng mới
    @PostMapping("/XuLyDangKy")
    public String processRegister(Customer customer,
                                  @RequestParam String ReMatKhau,
                                  HttpSession session) {
        // Kiểm tra email đã tồn tại chưa
        if (customerRepository.findByEmail(customer.getEmail()).isPresent()) {
            session.setAttribute("error", "Email đã tồn tại!");
            return "redirect:/DangKy";
        }

        // Kiểm tra mật khẩu nhập lại
        if (!customer.getMatKhau().equals(ReMatKhau)) {
            session.setAttribute("error", "Mật khẩu nhập lại không khớp!");
            return "redirect:/DangKy";
        }

        // Mã hóa mật khẩu
        customer.setMatKhau(authService.hashPassword(customer.getMatKhau()));
        customerRepository.save(customer);

        // Tự động đăng nhập sau khi đăng ký
        session.setAttribute("maKH", customer.getMaKH());
        session.setAttribute("tenKH", customer.getTenKH());
        session.setAttribute("email", customer.getEmail());
        session.setAttribute("role", "KhachHang");

        return "redirect:/";
    }

    // Đăng xuất
    @GetMapping("/DangNhap/Logout")
    public String logout(HttpSession session) {
        authService.logout(session);
        return "redirect:/";
    }
}
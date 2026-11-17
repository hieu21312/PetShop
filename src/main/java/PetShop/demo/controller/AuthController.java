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

    @Autowired
    private PetShop.demo.repository.ChuNuoiRepository chuNuoiRepository;

    @GetMapping("/DangNhap")
    public String loginPage(@RequestParam(required = false) String returnUrl, Model model) {
        model.addAttribute("url", returnUrl != null ? returnUrl : "/");
        return "login";
    }

    @PostMapping("/XuLyDN")
    public String processLogin(@RequestParam String email,
                               @RequestParam String password,
                               @RequestParam(required = false) String url,
                               HttpSession session) {
        Customer customer = authService.loginCustomer(email, password, session);
        if (customer != null) {
            return "redirect:" + (url != null && !url.isEmpty() ? url : "/");
        }

        try {
            int maNV = Integer.parseInt(email);
            var employee = authService.loginEmployee(maNV, password, session);
            if (employee != null) {
                if (authService.isAdmin(session)) {
                    return "redirect:/admin/index";
                }
                if (authService.isDoctor(session)) {
                    return "redirect:/admin/doctor/treatment";
                }
                if (authService.isCashier(session)) {
                    return "redirect:/admin/thu-ngan";
                }
                return "redirect:/staff/my-tasks";
            }
        } catch (NumberFormatException ignored) {
        }

        session.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng!");
        return "redirect:/DangNhap?url=" + (url != null ? url : "/");
    }

    @GetMapping("/DangKy")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/XuLyDangKy")
    public String processRegister(Customer customer,
                                  @RequestParam String ReMatKhau,
                                  HttpSession session) {
        if (customerRepository.findByEmail(customer.getEmail()).isPresent()) {
            session.setAttribute("error", "Email đã tồn tại!");
            return "redirect:/DangKy";
        }

        if (!customer.getMatKhau().equals(ReMatKhau)) {
            session.setAttribute("error", "Mật khẩu nhập lại không khớp!");
            return "redirect:/DangKy";
        }

        customer.setMatKhau(authService.hashPassword(customer.getMatKhau()));
        customer.setHangThanhVien("Tiêu chuẩn");
        customer.setDiemTichLuy(0);
        customerRepository.save(customer);

        var existingChuNuoiOpt = chuNuoiRepository.findFirstBySoDienThoaiOrEmail(customer.getDienThoai(), customer.getEmail());
        if (existingChuNuoiOpt.isPresent()) {
            PetShop.demo.model.enity.ChuNuoi chuNuoi = existingChuNuoiOpt.get();
            chuNuoi.setMaKH(customer.getMaKH());
            chuNuoiRepository.save(chuNuoi);
        } else {
            PetShop.demo.model.enity.ChuNuoi newChuNuoi = new PetShop.demo.model.enity.ChuNuoi();
            newChuNuoi.setMaKH(customer.getMaKH());
            newChuNuoi.setHoTenChuNuoi(customer.getTenKH());
            newChuNuoi.setSoDienThoai(customer.getDienThoai() != null ? customer.getDienThoai() : "");
            newChuNuoi.setEmail(customer.getEmail());
            newChuNuoi.setGioiTinh(customer.getGioiTinh());
            chuNuoiRepository.save(newChuNuoi);
        }

        session.setAttribute("maKH", customer.getMaKH());
        session.setAttribute("tenKH", customer.getTenKH());
        session.setAttribute("email", customer.getEmail());
        session.setAttribute("role", "KhachHang");
        session.setAttribute("hangThanhVien", "Tiêu chuẩn");
        session.setAttribute("diemTichLuy", 0);
        session.setAttribute("phanTramGiamHang", java.math.BigDecimal.ZERO);

        return "redirect:/";
    }

    @GetMapping("/DangNhap/Logout")
    public String logout(HttpSession session) {
        authService.logout(session);
        return "redirect:/";
    }

    @GetMapping("/DoiMatKhau")
    public String changePasswordPage(HttpSession session) {
        if (!authService.isLoggedIn(session)) {
            return "redirect:/DangNhap?returnUrl=/DoiMatKhau";
        }
        return "change-password";
    }

    @PostMapping("/DoiMatKhau")
    public String processChangePassword(@RequestParam String oldPassword,
                                        @RequestParam String newPassword,
                                        @RequestParam String confirmPassword,
                                        HttpSession session,
                                        org.springframework.web.servlet.mvc.support.RedirectAttributes ra) {
        if (!authService.isLoggedIn(session)) {
            return "redirect:/DangNhap";
        }

        if (newPassword == null || newPassword.trim().length() < 4) {
            ra.addFlashAttribute("error", "Mật khẩu mới phải có ít nhất 4 ký tự!");
            return "redirect:/DoiMatKhau";
        }

        if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("error", "Xác nhận mật khẩu mới không khớp!");
            return "redirect:/DoiMatKhau";
        }

        Integer maKH = (Integer) session.getAttribute("maKH");
        Integer maNV = (Integer) session.getAttribute("maNV");
        boolean success = false;

        if (maKH != null) {
            success = authService.changeCustomerPassword(maKH, oldPassword, newPassword);
        } else if (maNV != null) {
            success = authService.changeEmployeePassword(maNV, oldPassword, newPassword);
        }

        if (success) {
            ra.addFlashAttribute("success", "Đổi mật khẩu thành công! Vui lòng sử dụng mật khẩu mới cho các lần đăng nhập tiếp theo.");
        } else {
            ra.addFlashAttribute("error", "Mật khẩu hiện tại không chính xác!");
        }

        return "redirect:/DoiMatKhau";
    }
}

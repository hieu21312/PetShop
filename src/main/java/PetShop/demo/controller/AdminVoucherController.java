package PetShop.demo.controller;

import PetShop.demo.model.enity.Voucher;
import PetShop.demo.repository.VoucherRepository;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/vouchers")
public class AdminVoucherController {

    @Autowired
    private VoucherRepository voucherRepository;

    @Autowired
    private AuthService authService;

    // Danh sách mã giảm giá
    @GetMapping
    public String listVouchers(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        List<Voucher> vouchers = voucherRepository.findAll();
        model.addAttribute("vouchers", vouchers);
        return "admin/vouchers";
    }

    // Form thêm mới
    @GetMapping("/create")
    public String createForm(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        model.addAttribute("voucher", new Voucher());
        return "admin/voucher-form";
    }

    // Xử lý thêm mới
    @PostMapping("/create")
    public String createVoucher(@ModelAttribute Voucher voucher, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        if (voucherRepository.existsById(voucher.getMaGiamGia())) {
            // Xử lý lỗi trùng mã (có thể dùng flash attribute)
            return "redirect:/admin/vouchers/create?error=duplicate";
        }
        voucherRepository.save(voucher);
        return "redirect:/admin/vouchers";
    }

    // Form sửa
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable String id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Voucher voucher = voucherRepository.findById(id).orElse(null);
        if (voucher == null) return "redirect:/admin/vouchers";
        model.addAttribute("voucher", voucher);
        return "admin/voucher-form";
    }

    // Xử lý cập nhật
    @PostMapping("/edit/{id}")
    public String updateVoucher(@PathVariable String id, @ModelAttribute Voucher voucher, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Voucher existing = voucherRepository.findById(id).orElse(null);
        if (existing == null) return "redirect:/admin/vouchers";
        existing.setPhanTramGiam(voucher.getPhanTramGiam());
        existing.setSoTienGiamToiDa(voucher.getSoTienGiamToiDa());
        existing.setNgayBatDau(voucher.getNgayBatDau());
        existing.setNgayKetThuc(voucher.getNgayKetThuc());
        existing.setSoLuong(voucher.getSoLuong());
        voucherRepository.save(existing);
        return "redirect:/admin/vouchers";
    }

    // Xóa
    @GetMapping("/delete/{id}")
    public String deleteVoucher(@PathVariable String id, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        voucherRepository.deleteById(id);
        return "redirect:/admin/vouchers";
    }
}
package PetShop.demo.controller;

import PetShop.demo.model.enity.Supplier;
import PetShop.demo.repository.SupplierRepository;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/suppliers")
public class AdminSupplierController {

    @Autowired
    private SupplierRepository supplierRepository;

    @Autowired
    private AuthService authService;

    @GetMapping
    public String listSuppliers(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        model.addAttribute("suppliers", supplierRepository.findAll());
        return "admin/suppliers";
    }

    @GetMapping("/create")
    public String createForm(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        model.addAttribute("supplier", new Supplier());
        return "admin/supplier-form";
    }

    @PostMapping("/create")
    public String createSupplier(@ModelAttribute Supplier supplier,
                                 RedirectAttributes ra,
                                 HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        supplierRepository.save(supplier);
        ra.addFlashAttribute("success", "Thêm nhà cung cấp thành công!");
        return "redirect:/admin/suppliers";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Supplier supplier = supplierRepository.findById(id).orElse(null);
        if (supplier == null) return "redirect:/admin/suppliers";
        model.addAttribute("supplier", supplier);
        return "admin/supplier-form";
    }

    @PostMapping("/edit/{id}")
    public String updateSupplier(@PathVariable Integer id,
                                 @ModelAttribute Supplier supplier,
                                 RedirectAttributes ra,
                                 HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Supplier existing = supplierRepository.findById(id).orElse(null);
        if (existing == null) return "redirect:/admin/suppliers";
        existing.setTenNCC(supplier.getTenNCC());
        existing.setDiaChi(supplier.getDiaChi());
        existing.setDienThoai(supplier.getDienThoai());
        supplierRepository.save(existing);
        ra.addFlashAttribute("success", "Cập nhật nhà cung cấp thành công!");
        return "redirect:/admin/suppliers";
    }

    @GetMapping("/delete/{id}")
    public String deleteSupplier(@PathVariable Integer id,
                                 RedirectAttributes ra,
                                 HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Supplier sup = supplierRepository.findById(id).orElse(null);
        if (sup != null && !sup.getProducts().isEmpty()) {
            ra.addFlashAttribute("error", "Nhà cung cấp đang có sản phẩm, không thể xóa!");
        } else {
            supplierRepository.deleteById(id);
            ra.addFlashAttribute("success", "Xóa nhà cung cấp thành công!");
        }
        return "redirect:/admin/suppliers";
    }
}
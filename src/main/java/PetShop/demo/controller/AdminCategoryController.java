package PetShop.demo.controller;

import PetShop.demo.model.enity.Category;
import PetShop.demo.repository.CategoryRepository;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/categories")
public class AdminCategoryController {

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private AuthService authService;

    // Danh sách danh mục
    @GetMapping
    public String listCategories(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        model.addAttribute("categories", categoryRepository.findAll());
        return "admin/categories";
    }

    // Form thêm mới
    @GetMapping("/create")
    public String createForm(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        model.addAttribute("category", new Category());
        return "admin/category-form";
    }

    // Xử lý thêm
    @PostMapping("/create")
    public String createCategory(@ModelAttribute Category category,
                                 RedirectAttributes ra,
                                 HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        categoryRepository.save(category);
        ra.addFlashAttribute("success", "Thêm danh mục thành công!");
        return "redirect:/admin/categories";
    }

    // Form sửa
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Category category = categoryRepository.findById(id).orElse(null);
        if (category == null) return "redirect:/admin/categories";
        model.addAttribute("category", category);
        return "admin/category-form";
    }

    // Xử lý sửa
    @PostMapping("/edit/{id}")
    public String updateCategory(@PathVariable Integer id,
                                 @ModelAttribute Category category,
                                 RedirectAttributes ra,
                                 HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Category existing = categoryRepository.findById(id).orElse(null);
        if (existing == null) return "redirect:/admin/categories";
        existing.setTenDanhMuc(category.getTenDanhMuc());
        existing.setGhiChu(category.getGhiChu());
        categoryRepository.save(existing);
        ra.addFlashAttribute("success", "Cập nhật danh mục thành công!");
        return "redirect:/admin/categories";
    }

    // Xóa
    @GetMapping("/delete/{id}")
    public String deleteCategory(@PathVariable Integer id,
                                 RedirectAttributes ra,
                                 HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        // Kiểm tra xem danh mục có sản phẩm nào không? Nếu có, không cho xóa
        Category cat = categoryRepository.findById(id).orElse(null);
        if (cat != null && !cat.getProducts().isEmpty()) {
            ra.addFlashAttribute("error", "Danh mục đang có sản phẩm, không thể xóa!");
        } else {
            categoryRepository.deleteById(id);
            ra.addFlashAttribute("success", "Xóa danh mục thành công!");
        }
        return "redirect:/admin/categories";
    }
}
package PetShop.demo.controller;

import PetShop.demo.model.enity.Inventory;
import PetShop.demo.model.enity.Product;
import PetShop.demo.repository.InventoryRepository;
import PetShop.demo.repository.ProductRepository;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/inventory")
public class AdminInventoryController {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private InventoryRepository inventoryRepository;

    @Autowired
    private AuthService authService;

    // Danh sách sản phẩm Accessory và tồn kho
    @GetMapping
    public String listInventory(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        List<Product> accessories = productRepository.findByLoaiSanPham("Accessory");
        // Lấy tồn kho cho từng sản phẩm
        for (Product p : accessories) {
            Inventory inv = inventoryRepository.findById(p.getMaSP()).orElse(null);
            if (inv == null) {
                // Tạo mới nếu chưa có
                inv = new Inventory();
                inv.setMaSP(p.getMaSP());
                inv.setSoLuongTon(0);
                inventoryRepository.save(inv);
            }
            p.setInventory(inv);
        }
        model.addAttribute("products", accessories);
        return "admin/inventory";
    }

    // Cập nhật tồn kho cho một sản phẩm
    @PostMapping("/update")
    public String updateInventory(@RequestParam Integer maSP,
                                  @RequestParam Integer soLuongTon,
                                  RedirectAttributes ra,
                                  HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Inventory inv = inventoryRepository.findById(maSP).orElse(null);
        if (inv != null) {
            inv.setSoLuongTon(soLuongTon);
            inventoryRepository.save(inv);
            ra.addFlashAttribute("success", "Cập nhật tồn kho thành công!");
        } else {
            ra.addFlashAttribute("error", "Không tìm thấy sản phẩm!");
        }
        return "redirect:/admin/inventory";
    }
}
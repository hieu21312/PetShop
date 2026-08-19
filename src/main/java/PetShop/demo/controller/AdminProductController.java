package PetShop.demo.controller;

import PetShop.demo.model.enity.Product;
import PetShop.demo.model.enity.Inventory;
import PetShop.demo.repository.ProductRepository;
import PetShop.demo.repository.CategoryRepository;
import PetShop.demo.repository.SupplierRepository;
import PetShop.demo.repository.InventoryRepository;
import PetShop.demo.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/admin/products")
public class AdminProductController {

    @Autowired private ProductRepository productRepository;
    @Autowired private CategoryRepository categoryRepository;
    @Autowired private SupplierRepository supplierRepository;
    @Autowired private InventoryRepository inventoryRepository;
    @Autowired private AuthService authService;

    private static final String UPLOAD_DIR = "src/main/webapp/Content/HinhAnh/";

    // Danh sách sản phẩm
    @GetMapping
    public String listProducts(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        List<Product> products = productRepository.findAll();
        model.addAttribute("products", products);
        return "admin/products";
    }

    // Form thêm sản phẩm
    @GetMapping("/create")
    public String createForm(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        model.addAttribute("product", new Product());
        model.addAttribute("categories", categoryRepository.findAll());
        model.addAttribute("suppliers", supplierRepository.findAll());
        return "admin/product-form";
    }

    // Xử lý thêm sản phẩm
    @PostMapping("/create")
    public String createProduct(@ModelAttribute Product product,
                                @RequestParam("fileImage") MultipartFile file,
                                HttpSession session) throws IOException {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        
        if (file.isEmpty()) {
            session.setAttribute("error", "Vui lòng chọn ảnh đại diện cho sản phẩm.");
            return "redirect:/admin/products/create";
        }

        String fileName = saveFile(file);
        product.setAnhDaiDien(fileName);
        Product saved = productRepository.save(product);
        if ("Accessory".equals(product.getLoaiSanPham())) {
            Inventory inv = new Inventory();
            inv.setMaSP(saved.getMaSP());
            inv.setSoLuongTon(0);
            inventoryRepository.save(inv);
        }

        return "redirect:/admin/products";
    }

    // Form sửa sản phẩm
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Product product = productRepository.findById(id).orElse(null);
        if (product == null) return "redirect:/admin/products";
        model.addAttribute("product", product);
        model.addAttribute("categories", categoryRepository.findAll());
        model.addAttribute("suppliers", supplierRepository.findAll());
        return "admin/product-form";
    }

    // Xử lý sửa sản phẩm
    @PostMapping("/edit/{id}")
    public String updateProduct(@PathVariable Integer id,
                                @ModelAttribute Product product,
                                @RequestParam(value = "fileImage", required = false) MultipartFile file,
                                HttpSession session) throws IOException {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Product existing = productRepository.findById(id).orElse(null);
        if (existing == null) return "redirect:/admin/products";
        existing.setTenSP(product.getTenSP());
        existing.setLoaiSanPham(product.getLoaiSanPham());
        existing.setGiaBan(product.getGiaBan());
        existing.setMoTa(product.getMoTa());
        existing.setGioiTinh(product.getGioiTinh());
        existing.setNgaySinh(product.getNgaySinh());
        existing.setMauSac(product.getMauSac());
        existing.setTinhTrangSucKhoe(product.getTinhTrangSucKhoe());
        existing.setTienSuBenh(product.getTienSuBenh());
        existing.setMaDanhMuc(product.getMaDanhMuc());
        existing.setMaNCC(product.getMaNCC());
        if (file != null && !file.isEmpty()) {
            if (existing.getAnhDaiDien() != null) deleteFile(existing.getAnhDaiDien());
            String fileName = saveFile(file);
            existing.setAnhDaiDien(fileName);
        }
        productRepository.save(existing);
        return "redirect:/admin/products";
    }

    // Xóa sản phẩm
    @GetMapping("/delete/{id}")
    public String deleteProduct(@PathVariable Integer id, HttpSession session) throws IOException {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Product product = productRepository.findById(id).orElse(null);
        if (product != null) {
            if (product.getAnhDaiDien() != null) deleteFile(product.getAnhDaiDien());
            productRepository.deleteById(id);
        }
        return "redirect:/admin/products";
    }

    private String saveFile(MultipartFile file) throws IOException {
        String originalName = file.getOriginalFilename();
        String extension = originalName.substring(originalName.lastIndexOf("."));
        String newFileName = UUID.randomUUID().toString() + extension;
        Path path = Paths.get(UPLOAD_DIR + newFileName);
        Files.createDirectories(path.getParent());
        Files.write(path, file.getBytes());
        return newFileName;
    }

    private void deleteFile(String fileName) throws IOException {
        Path path = Paths.get(UPLOAD_DIR + fileName);
        Files.deleteIfExists(path);
    }
}
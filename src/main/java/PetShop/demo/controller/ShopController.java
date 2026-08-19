package PetShop.demo.controller;

import PetShop.demo.model.enity.PetService;
import PetShop.demo.model.enity.Product;
import PetShop.demo.repository.PetServiceRepository;
import PetShop.demo.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class ShopController {

    @Autowired
    private ProductService productService;

    @Autowired
    private PetServiceRepository petServiceRepository;

    // Trang chủ sản phẩm (hiển thị danh sách theo loại, tìm kiếm và sắp xếp)
    @GetMapping("/SanPham")
    public String shop(@RequestParam(required = false) String loai,
                       @RequestParam(required = false) String searchString,
                       @RequestParam(required = false, defaultValue = "default") String sort,
                       Model model) {
        List<Product> allProducts = productService.getAllProducts();

        // Tìm kiếm nâng cao (bỏ dấu, nhiều từ khóa)
        if (searchString != null && !searchString.isEmpty()) {
            String keyword = removeVietnamese(searchString).toLowerCase();
            String[] words = keyword.split(" ");
            allProducts = allProducts.stream()
                    .filter(p -> {
                        String name = removeVietnamese(p.getTenSP()).toLowerCase();
                        String desc = removeVietnamese(p.getMoTa() != null ? p.getMoTa() : "").toLowerCase();
                        String type = removeVietnamese(p.getLoaiSanPham()).toLowerCase();
                        return java.util.Arrays.stream(words).allMatch(w ->
                                name.contains(w) || desc.contains(w) || type.contains(w));
                    })
                    .collect(Collectors.toList());
        }

        // Lọc theo danh mục (Chó, Mèo, Phụ kiện...)
        if (loai != null && !loai.isEmpty()) {
            allProducts = filterByCategory(allProducts, loai);
        }

        // Sắp xếp theo giá
        if ("asc".equals(sort)) {
            allProducts.sort(Comparator.comparing(Product::getGiaBan));
        } else if ("desc".equals(sort)) {
            allProducts.sort(Comparator.comparing(Product::getGiaBan).reversed());
        }
        // sort = default thì giữ nguyên thứ tự (không sắp xếp)

        // Phân loại sản phẩm
        List<Product> pets = allProducts.stream()
                .filter(p -> "Pet".equals(p.getLoaiSanPham()))
                .collect(Collectors.toList());
        List<Product> accessories = allProducts.stream()
                .filter(p -> "Accessory".equals(p.getLoaiSanPham()))
                .collect(Collectors.toList());
        List<Product> services = allProducts.stream()
                .filter(p -> "Service".equals(p.getLoaiSanPham()))
                .collect(Collectors.toList());

        model.addAttribute("pets", pets);
        model.addAttribute("accessories", accessories);
        model.addAttribute("services", services);
        model.addAttribute("currentCategory", loai);
        model.addAttribute("searchString", searchString);
        model.addAttribute("sort", sort); // gửi giá trị sort xuống view để active menu

        return "shop";
    }

    // Trang dịch vụ riêng
    @GetMapping("/DichVu")
    public String dichVu(Model model) {
        List<PetService> services = petServiceRepository.findAll();
        model.addAttribute("services", services);
        return "DichVu";
    }

    // Trang giới thiệu
    @GetMapping("/About")
    public String about() {
        return "about";
    }

    // Trang liên hệ
    @GetMapping("/Contact")
    public String contact() {
        return "contact";
    }

    private List<Product> filterByCategory(List<Product> products, String loai) {
        switch (loai.toLowerCase()) {
            case "cho":
                return products.stream()
                        .filter(p -> "Pet".equals(p.getLoaiSanPham()) && p.getTenSP().toLowerCase().contains("chó"))
                        .collect(Collectors.toList());
            case "meo":
                return products.stream()
                        .filter(p -> "Pet".equals(p.getLoaiSanPham()) && p.getTenSP().toLowerCase().contains("mèo"))
                        .collect(Collectors.toList());
            case "thucancho":
                return products.stream()
                        .filter(p -> "Accessory".equals(p.getLoaiSanPham()) &&
                                p.getTenSP().toLowerCase().contains("thức ăn") && p.getTenSP().toLowerCase().contains("chó"))
                        .collect(Collectors.toList());
            case "thucanmeo":
                return products.stream()
                        .filter(p -> "Accessory".equals(p.getLoaiSanPham()) &&
                                p.getTenSP().toLowerCase().contains("thức ăn") && p.getTenSP().toLowerCase().contains("mèo"))
                        .collect(Collectors.toList());
            case "pate":
                return products.stream()
                        .filter(p -> "Accessory".equals(p.getLoaiSanPham()) && p.getTenSP().toLowerCase().contains("pate"))
                        .collect(Collectors.toList());
            case "docho":
                return products.stream()
                        .filter(p -> "Accessory".equals(p.getLoaiSanPham()) &&
                                (p.getTenSP().toLowerCase().contains("đồ chơi") ||
                                        p.getTenSP().toLowerCase().contains("bóng") ||
                                        p.getTenSP().toLowerCase().contains("gặm")))
                        .collect(Collectors.toList());
            case "daydat":
                return products.stream()
                        .filter(p -> "Accessory".equals(p.getLoaiSanPham()) &&
                                (p.getTenSP().toLowerCase().contains("dây") ||
                                        p.getTenSP().toLowerCase().contains("dắt") ||
                                        p.getTenSP().toLowerCase().contains("vòng")))
                        .collect(Collectors.toList());
            case "quanao":
                return products.stream()
                        .filter(p -> "Accessory".equals(p.getLoaiSanPham()) &&
                                (p.getTenSP().toLowerCase().contains("áo") || p.getTenSP().toLowerCase().contains("quần")))
                        .collect(Collectors.toList());
            case "chuongngu":
                return products.stream()
                        .filter(p -> "Accessory".equals(p.getLoaiSanPham()) &&
                                (p.getTenSP().toLowerCase().contains("chuồng") ||
                                        p.getTenSP().toLowerCase().contains("nệm") ||
                                        p.getTenSP().toLowerCase().contains("ngủ")))
                        .collect(Collectors.toList());
            case "dichvu":
                return products.stream()
                        .filter(p -> "Service".equals(p.getLoaiSanPham()))
                        .collect(Collectors.toList());
            default:
                return products;
        }
    }

    private String removeVietnamese(String str) {
        if (str == null) return "";
        str = str.toLowerCase();
        String[] signs = {
                "aáàảạãăắằẳẵặâấầẩẫậ",
                "eéèẻẽẹêếềểễệ",
                "iíìỉĩị",
                "oóòỏõọôốồổỗộơớờởỡợ",
                "uúùủũụưứừửữự",
                "yýỳỷỹỵ",
                "dđ"
        };
        String[] replaces = {"a", "e", "i", "o", "u", "y", "d"};
        for (int i = 0; i < signs.length; i++) {
            for (char c : signs[i].toCharArray()) {
                str = str.replace(c, replaces[i].charAt(0));
            }
        }
        return str;
    }
}
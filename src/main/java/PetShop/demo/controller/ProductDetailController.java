package PetShop.demo.controller;

import PetShop.demo.model.enity.Product;
import PetShop.demo.model.enity.ProductImage;
import PetShop.demo.model.enity.Review;
import PetShop.demo.repository.ProductImageRepository;
import PetShop.demo.repository.ReviewRepository;
import PetShop.demo.service.ProductService;
import jakarta.servlet.http.HttpSession;    // ← THÊM DÒNG NÀY
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class ProductDetailController {

    @Autowired
    private ProductService productService;

    @Autowired
    private ProductImageRepository productImageRepository;

    @Autowired
    private ReviewRepository reviewRepository;

    @GetMapping("/ChiTiet")
    public String productDetail(@RequestParam int masp, Model model) {
        var productOpt = productService.getProductById(masp);
        if (productOpt.isEmpty()) {
            return "redirect:/SanPham";
        }
        Product product = productOpt.get();

        List<ProductImage> images = productImageRepository.findByMaSP(masp);
        List<Review> reviews = reviewRepository.findByMaSPOrderByNgayDesc(masp);

        List<Product> relatedProducts = productService.getAllProducts().stream()
                .filter(p -> p.getMaDanhMuc() != null && p.getMaDanhMuc().equals(product.getMaDanhMuc()) && !p.getMaSP().equals(masp))
                .limit(4)
                .collect(Collectors.toList());

        List<Product> sameSupplier = productService.getAllProducts().stream()
                .filter(p -> p.getMaNCC() != null && p.getMaNCC().equals(product.getMaNCC()) && !p.getMaSP().equals(masp))
                .limit(4)
                .collect(Collectors.toList());

        model.addAttribute("product", product);
        model.addAttribute("images", images);
        model.addAttribute("reviews", reviews);
        model.addAttribute("relatedProducts", relatedProducts);
        model.addAttribute("sameSupplier", sameSupplier);

        return "product-detail";
    }

    @PostMapping("/GuiBinhLuan")
    public String addReview(@RequestParam Integer maSP,
                            @RequestParam String hoTen,
                            @RequestParam Integer soSao,
                            @RequestParam String noiDung,
                            HttpSession session) {
        // Nếu đã đăng nhập, ưu tiên lấy tên từ session
        String tenKH = (String) session.getAttribute("tenKH");
        if (tenKH != null && !tenKH.isEmpty()) {
            hoTen = tenKH;
        }

        Review review = new Review();
        review.setMaSP(maSP);
        review.setHoTen(hoTen);
        review.setSoSao(soSao);
        review.setNoiDung(noiDung);
        review.setNgay(LocalDateTime.now());
        review.setDaDuyet(false);   // mặc định chưa duyệt

        reviewRepository.save(review);
        return "redirect:/ChiTiet?masp=" + maSP;
    }
}
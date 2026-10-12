package PetShop.demo.api;

import PetShop.demo.model.enity.Category;
import PetShop.demo.model.enity.Product;
import PetShop.demo.model.enity.Review;
import PetShop.demo.repository.CategoryRepository;
import PetShop.demo.repository.ReviewRepository;
import PetShop.demo.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@CrossOrigin(origins = "*")
public class ProductApiController {

    @Autowired
    private ProductService productService;

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    // Lấy danh mục sản phẩm từ tblDanhMuc
    @GetMapping(value = "/api/categories", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
    public ResponseEntity<?> getCategories() {
        List<Category> categories = categoryRepository.findAll();
        List<Map<String, Object>> result = new ArrayList<>();
        for (Category c : categories) {
            Map<String, Object> map = new HashMap<>();
            map.put("maDanhMuc", c.getMaDanhMuc());
            map.put("tenDanhMuc", c.getTenDanhMuc());
            map.put("ghiChu", c.getGhiChu());
            result.add(map);
        }
        return ResponseEntity.ok(result);
    }

    // Lấy danh sách sản phẩm (có tìm kiếm, lọc theo loại / danh mục, sắp xếp)
    @GetMapping(value = "/api/products", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
    public ResponseEntity<?> getProducts(@RequestParam(required = false) String search,
                                         @RequestParam(required = false) String type,
                                         @RequestParam(required = false) Integer categoryId,
                                         @RequestParam(required = false) String loai,
                                         @RequestParam(required = false) String sort) {
        List<Product> products = productService.getAllProducts();

        if (search != null && !search.isBlank()) {
            String kw = search.trim().toLowerCase();
            products = products.stream()
                    .filter(p -> (p.getTenSP() != null && p.getTenSP().toLowerCase().contains(kw))
                            || (p.getMoTa() != null && p.getMoTa().toLowerCase().contains(kw))
                            || (p.getCategory() != null && p.getCategory().getTenDanhMuc() != null
                                    && p.getCategory().getTenDanhMuc().toLowerCase().contains(kw)))
                    .collect(Collectors.toList());
        }

        if (loai != null && !loai.isBlank()) {
            String l = loai.trim().toLowerCase();
            if ("cho".equals(l)) {
                // Chỉ bao gồm thú cưng Chó (loại Pet, không có thức ăn hay phụ kiện)
                products = products.stream()
                        .filter(p -> "Pet".equalsIgnoreCase(p.getLoaiSanPham()) &&
                                ((p.getTenSP() != null && p.getTenSP().toLowerCase().contains("chó"))
                                        || (p.getMaDanhMuc() != null && p.getMaDanhMuc() == 1)))
                        .collect(Collectors.toList());
            } else if ("meo".equals(l)) {
                // Chỉ bao gồm thú cưng Mèo (loại Pet, không có thức ăn hay phụ kiện)
                products = products.stream()
                        .filter(p -> "Pet".equalsIgnoreCase(p.getLoaiSanPham()) &&
                                ((p.getTenSP() != null && p.getTenSP().toLowerCase().contains("mèo"))
                                        || (p.getMaDanhMuc() != null && p.getMaDanhMuc() == 2)))
                        .collect(Collectors.toList());
            } else if ("thucan".equals(l)) {
                // Thức ăn cho chó & mèo (pate, thức ăn hạt...)
                products = products.stream()
                        .filter(p -> {
                            if (p.getMaDanhMuc() != null && (p.getMaDanhMuc() == 3 || p.getMaDanhMuc() == 4)) return true;
                            String name = p.getTenSP() != null ? p.getTenSP().toLowerCase() : "";
                            return name.contains("thức ăn") || name.contains("pate") || name.contains("hạt");
                        })
                        .collect(Collectors.toList());
            } else if ("phukien".equals(l)) {
                // Phụ kiện thú cưng (đồ chơi, vòng cổ, chuồng, sữa tắm... không bao gồm thức ăn)
                products = products.stream()
                        .filter(p -> {
                            if (!"Accessory".equalsIgnoreCase(p.getLoaiSanPham())) return false;
                            if (p.getMaDanhMuc() != null && (p.getMaDanhMuc() == 3 || p.getMaDanhMuc() == 4)) return false;
                            String name = p.getTenSP() != null ? p.getTenSP().toLowerCase() : "";
                            return !name.contains("thức ăn") && !name.contains("pate") && !name.contains("hạt");
                        })
                        .collect(Collectors.toList());
            }
        } else if (categoryId != null && categoryId > 0) {
            products = products.stream()
                    .filter(p -> p.getMaDanhMuc() != null && p.getMaDanhMuc().equals(categoryId))
                    .collect(Collectors.toList());
        } else if (type != null && !type.isBlank()) {
            String t = type.trim();
            products = products.stream()
                    .filter(p -> p.getLoaiSanPham() != null && p.getLoaiSanPham().equalsIgnoreCase(t))
                    .collect(Collectors.toList());
        }

        if ("asc".equalsIgnoreCase(sort)) {
            products.sort(Comparator.comparing(Product::getGiaBan, Comparator.nullsLast(Comparator.naturalOrder())));
        } else if ("desc".equalsIgnoreCase(sort)) {
            products.sort(Comparator.comparing(Product::getGiaBan, Comparator.nullsLast(Comparator.reverseOrder())));
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (Product p : products) {
            Map<String, Object> map = new HashMap<>();
            map.put("maSP", p.getMaSP());
            map.put("tenSP", p.getTenSP());
            map.put("loaiSanPham", p.getLoaiSanPham());
            map.put("maDanhMuc", p.getMaDanhMuc());
            map.put("tenDanhMuc", p.getCategory() != null ? p.getCategory().getTenDanhMuc() : (p.getLoaiSanPham() != null && p.getLoaiSanPham().equalsIgnoreCase("Pet") ? "Thú cưng" : "Phụ kiện"));
            map.put("giaBan", p.getGiaBan());
            map.put("anhDaiDien", p.getAnhDaiDien());
            map.put("mauSac", p.getMauSac());
            map.put("gioiTinh", p.getGioiTinh());
            map.put("tinhTrangSucKhoe", p.getTinhTrangSucKhoe());
            map.put("moTa", p.getMoTa());
            map.put("soLuongTon", p.getInventory() != null ? p.getInventory().getSoLuongTon() : null);
            map.put("trangThaiTonKho", p.getInventory() != null ? p.getInventory().getTrangThai() : null);
            result.add(map);
        }

        return ResponseEntity.ok(result);
    }

    // Chi tiết sản phẩm kèm đánh giá
    @GetMapping(value = "/api/products/{id}", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
    public ResponseEntity<?> getProductDetail(@PathVariable int id) {
        Product p = productService.getProductById(id).orElse(null);
        if (p == null) {
            return ResponseEntity.notFound().build();
        }

        Map<String, Object> map = new HashMap<>();
        map.put("maSP", p.getMaSP());
        map.put("tenSP", p.getTenSP());
        map.put("loaiSanPham", p.getLoaiSanPham());
        map.put("maDanhMuc", p.getMaDanhMuc());
        map.put("tenDanhMuc", p.getCategory() != null ? p.getCategory().getTenDanhMuc() : (p.getLoaiSanPham() != null && p.getLoaiSanPham().equalsIgnoreCase("Pet") ? "Thú cưng" : "Phụ kiện"));
        map.put("giaBan", p.getGiaBan());
        map.put("anhDaiDien", p.getAnhDaiDien());
        map.put("mauSac", p.getMauSac());
        map.put("gioiTinh", p.getGioiTinh());
        map.put("tinhTrangSucKhoe", p.getTinhTrangSucKhoe());
        map.put("tienSuBenh", p.getTienSuBenh());
        map.put("moTa", p.getMoTa());
        map.put("soLuongTon", p.getInventory() != null ? p.getInventory().getSoLuongTon() : null);
        map.put("trangThaiTonKho", p.getInventory() != null ? p.getInventory().getTrangThai() : null);

        List<Review> reviews = reviewRepository.findByMaSPOrderByNgayDesc(id);
        List<Map<String, Object>> reviewList = new ArrayList<>();
        for (Review r : reviews) {
            Map<String, Object> rm = new HashMap<>();
            rm.put("id", r.getId());
            rm.put("hoTen", r.getHoTen());
            rm.put("soSao", r.getSoSao());
            rm.put("noiDung", r.getNoiDung());
            rm.put("ngay", r.getNgay());
            reviewList.add(rm);
        }
        map.put("reviews", reviewList);

        return ResponseEntity.ok(map);
    }
}

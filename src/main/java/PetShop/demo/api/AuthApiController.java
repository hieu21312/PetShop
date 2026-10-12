package PetShop.demo.api;

import PetShop.demo.model.enity.ChuNuoi;
import PetShop.demo.model.enity.Customer;
import PetShop.demo.repository.ChuNuoiRepository;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.MembershipService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.http.MediaType;

@RestController
@RequestMapping(value = "/api/auth", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
@CrossOrigin(origins = "*")
public class AuthApiController {

    @Autowired
    private AuthService authService;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private ChuNuoiRepository chuNuoiRepository;

    @Autowired
    private MembershipService membershipService;

    private Customer syncCustomerWithChuNuoi(Customer c) {
        if (c == null) return null;
        try {
            Optional<ChuNuoi> ownerOpt = Optional.empty();
            if (c.getMaKH() != null) {
                ownerOpt = chuNuoiRepository.findFirstByMaKH(c.getMaKH());
            }
            if (ownerOpt.isEmpty() && c.getDienThoai() != null && !c.getDienThoai().isBlank()) {
                ownerOpt = chuNuoiRepository.findFirstBySoDienThoai(c.getDienThoai().trim());
            }

            if (ownerOpt.isPresent()) {
                ChuNuoi owner = ownerOpt.get();
                int ownerPts = owner.getDiemTichLuy() != null ? owner.getDiemTichLuy() : 0;
                int custPts = c.getDiemTichLuy() != null ? c.getDiemTichLuy() : 0;
                int maxPts = Math.max(ownerPts, custPts);

                String tier = membershipService.determineTier(maxPts);
                if ("VIP".equalsIgnoreCase(owner.getLoaiChuNuoi()) || "VIP".equalsIgnoreCase(c.getHangThanhVien())) {
                    if (!"VVIP".equalsIgnoreCase(tier)) tier = "VIP";
                } else if ("VVIP".equalsIgnoreCase(owner.getLoaiChuNuoi()) || "VVIP".equalsIgnoreCase(c.getHangThanhVien())) {
                    tier = "VVIP";
                }

                c.setDiemTichLuy(maxPts);
                c.setHangThanhVien(tier);
                c = customerRepository.save(c);

                owner.setDiemTichLuy(maxPts);
                owner.setLoaiChuNuoi(tier);
                if (owner.getMaKH() == null) {
                    owner.setMaKH(c.getMaKH());
                }
                chuNuoiRepository.save(owner);
            } else if (c.getHangThanhVien() == null || c.getHangThanhVien().isBlank()) {
                c.setHangThanhVien(membershipService.determineTier(c.getDiemTichLuy() != null ? c.getDiemTichLuy() : 0));
                c = customerRepository.save(c);
            }
        } catch (Exception ignored) {
        }
        return c;
    }

    // Đăng nhập
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        String password = payload.get("password");

        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Vui lòng nhập email và mật khẩu"));
        }

        Optional<Customer> customerOpt = customerRepository.findByEmail(email.trim());
        if (customerOpt.isPresent()) {
            Customer c = customerOpt.get();
            if (password.trim().equals(c.getMatKhau())) {
                if (Boolean.TRUE.equals(c.getIsLocked())) {
                    return ResponseEntity.status(HttpStatus.FORBIDDEN)
                            .body(Map.of("success", false, "message", "Tài khoản của bạn đã bị khóa"));
                }

                c = syncCustomerWithChuNuoi(c);

                Map<String, Object> userData = new HashMap<>();
                userData.put("maKH", c.getMaKH());
                userData.put("tenKH", c.getTenKH());
                userData.put("email", c.getEmail());
                userData.put("dienThoai", c.getDienThoai());
                userData.put("diaChi", c.getDiaChi());
                userData.put("hangThanhVien", c.getHangThanhVien());
                userData.put("diemTichLuy", c.getDiemTichLuy());
                userData.put("discountPercent", membershipService.getDiscountPercentage(c.getHangThanhVien()));
                userData.put("role", "KhachHang");

                return ResponseEntity.ok(Map.of(
                        "success", true,
                        "message", "Đăng nhập thành công",
                        "user", userData
                ));
            }
        }

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(Map.of("success", false, "message", "Sai tài khoản hoặc mật khẩu"));
    }

    // Đăng ký
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Map<String, String> payload) {
        String tenKH = payload.get("tenKH");
        String email = payload.get("email");
        String password = payload.get("password");
        String dienThoai = payload.get("dienThoai");
        String diaChi = payload.get("diaChi");

        if (email == null || password == null || tenKH == null || email.isBlank() || password.isBlank() || tenKH.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Vui lòng điền đầy đủ thông tin bắt buộc"));
        }

        if (customerRepository.findByEmail(email.trim()).isPresent()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Email này đã được sử dụng"));
        }

        Customer c = new Customer();
        c.setTenKH(tenKH.trim());
        c.setEmail(email.trim());
        c.setMatKhau(password.trim());
        c.setDienThoai(dienThoai != null ? dienThoai.trim() : "");
        c.setDiaChi(diaChi != null ? diaChi.trim() : "");
        c.setHangThanhVien("Tiêu chuẩn");
        c.setDiemTichLuy(0);
        c.setIsLocked(false);
        customerRepository.save(c);

        return ResponseEntity.ok(Map.of("success", true, "message", "Đăng ký tài khoản thành công!"));
    }

    // Lấy thông tin cá nhân
    @GetMapping("/profile")
    public ResponseEntity<?> getProfile(@RequestParam Integer maKH) {
        Optional<Customer> customerOpt = customerRepository.findById(maKH);
        if (customerOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("success", false, "message", "Không tìm thấy khách hàng"));
        }

        Customer c = customerOpt.get();
        c = syncCustomerWithChuNuoi(c);

        Map<String, Object> userData = new HashMap<>();
        userData.put("maKH", c.getMaKH());
        userData.put("tenKH", c.getTenKH());
        userData.put("email", c.getEmail());
        userData.put("dienThoai", c.getDienThoai());
        userData.put("diaChi", c.getDiaChi());
        userData.put("gioiTinh", c.getGioiTinh());
        userData.put("namSinh", c.getNamSinh());
        userData.put("hangThanhVien", c.getHangThanhVien());
        userData.put("diemTichLuy", c.getDiemTichLuy());
        userData.put("discountPercent", membershipService.getDiscountPercentage(c.getHangThanhVien()));

        return ResponseEntity.ok(Map.of("success", true, "user", userData));
    }
}

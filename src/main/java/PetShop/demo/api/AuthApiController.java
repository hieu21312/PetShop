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

    @Autowired
    private PetShop.demo.repository.EmployeeRepository employeeRepository;

    // Đăng nhập
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        String password = payload.get("password");

        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Vui lòng nhập tài khoản/email và mật khẩu"));
        }

        String input = email.trim();
        String pwd = password.trim();
        String hashedPwd = authService.hashPassword(pwd);

        // 1. Kiểm tra tài khoản Khách hàng
        Optional<Customer> customerOpt = customerRepository.findByEmail(input);
        if (customerOpt.isEmpty()) {
            customerOpt = customerRepository.findByDienThoai(input);
        }

        // 2. Kiểm tra tài khoản Nhân viên / Admin
        Optional<PetShop.demo.model.enity.Employee> empOpt = Optional.empty();

        // 2a. Nếu nhập số ID nhân viên (MaNV)
        try {
            int maNV = Integer.parseInt(input);
            empOpt = employeeRepository.findById(maNV);
        } catch (NumberFormatException ignored) {}

        // 2b. Nếu nhập "admin"
        if (empOpt.isEmpty() && "admin".equalsIgnoreCase(input)) {
            // Tìm nhân viên vai trò Admin hoặc ID 1
            empOpt = employeeRepository.findById(1);
            if (empOpt.isEmpty()) {
                var admins = employeeRepository.findByVaiTro(1);
                if (!admins.isEmpty()) empOpt = Optional.of(admins.get(0));
            }
        }

        // 2c. Tìm theo email nhân viên
        if (empOpt.isEmpty()) {
            empOpt = employeeRepository.findFirstByEmail(input);
        }

        // Nếu không tìm thấy cả tài khoản khách hàng lẫn nhân viên -> Sai tài khoản
        if (customerOpt.isEmpty() && empOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "message", "Tài khoản không tồn tại trên hệ thống!"));
        }

        // Xử lý xác thực Khách hàng
        if (customerOpt.isPresent()) {
            Customer c = customerOpt.get();
            boolean custPwdMatch = pwd.equals(c.getMatKhau()) || (c.getMatKhau() != null && c.getMatKhau().equalsIgnoreCase(hashedPwd));
            if (custPwdMatch) {
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

        // Xử lý xác thực Nhân viên / Admin
        if (empOpt.isPresent()) {
            PetShop.demo.model.enity.Employee emp = empOpt.get();
            boolean pwdMatch = pwd.equals(emp.getMatKhau()) || (emp.getMatKhau() != null && emp.getMatKhau().equalsIgnoreCase(hashedPwd));
            if (pwdMatch) {
                if ("Tạm nghỉ".equalsIgnoreCase(emp.getTrangThai())) {
                    return ResponseEntity.status(HttpStatus.FORBIDDEN)
                            .body(Map.of("success", false, "message", "Tài khoản nhân viên đang tạm nghỉ hoặc đã bị khóa"));
                }

                String roleName = (emp.getRole() != null) ? emp.getRole().getTenVaiTro() : "NhanVien";
                String appRole = ("Admin".equalsIgnoreCase(roleName) || emp.getVaiTro() != null && emp.getVaiTro() == 1)
                        ? "Admin"
                        : "NhanVien";

                Map<String, Object> userData = new HashMap<>();
                userData.put("maNV", emp.getMaNV());
                userData.put("tenNV", emp.getTenNV());
                userData.put("tenKH", emp.getTenNV());
                userData.put("email", emp.getEmail() != null ? emp.getEmail() : (emp.getMaNV() + "@petshop.com"));
                userData.put("dienThoai", emp.getDienThoai());
                userData.put("chucVu", roleName);
                userData.put("chuyenMon", emp.getChuyenMon());
                userData.put("anhDaiDien", emp.getAnhDaiDien());
                userData.put("role", appRole);

                return ResponseEntity.ok(Map.of(
                        "success", true,
                        "message", "Đăng nhập thành công với vai trò " + (appRole.equals("Admin") ? "Quản trị viên" : roleName),
                        "user", userData
                ));
            }
        }

        // Tài khoản tồn tại nhưng mật khẩu không khớp -> Sai mật khẩu
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(Map.of("success", false, "message", "Mật khẩu không chính xác. Vui lòng thử lại!"));
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

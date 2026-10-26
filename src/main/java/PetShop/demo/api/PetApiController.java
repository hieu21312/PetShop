package PetShop.demo.api;

import PetShop.demo.model.enity.ChuNuoi;
import PetShop.demo.model.enity.Customer;
import PetShop.demo.model.enity.HoSoThuCung;
import PetShop.demo.repository.ChuNuoiRepository;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.repository.HoSoThuCungRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@RestController
@RequestMapping(value = "/api/pets", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
@CrossOrigin(origins = "*")
public class PetApiController {

    @Autowired
    private HoSoThuCungRepository hoSoThuCungRepository;

    @Autowired
    private ChuNuoiRepository chuNuoiRepository;

    @Autowired
    private CustomerRepository customerRepository;

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter DATETIME_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private Map<String, Object> mapPet(HoSoThuCung pet) {
        if (pet == null) return Collections.emptyMap();
        Map<String, Object> m = new HashMap<>();
        m.put("maThuCung", pet.getMaThuCung());
        m.put("maChuNuoi", pet.getMaChuNuoi());
        m.put("tenThuCung", pet.getTenThuCung() != null ? pet.getTenThuCung() : "");
        m.put("loaiThuCung", pet.getLoaiThuCung() != null ? pet.getLoaiThuCung() : "Chó");
        m.put("giongLoai", pet.getGiongLoai() != null ? pet.getGiongLoai() : "");
        m.put("gioiTinh", pet.getGioiTinh() != null ? pet.getGioiTinh() : "Đực");
        m.put("trietSan", pet.getTrietSan() != null ? pet.getTrietSan() : false);
        m.put("ngaySinh", pet.getNgaySinh() != null ? pet.getNgaySinh().format(DATE_FMT) : null);
        m.put("tuoiThang", pet.getTuoiThang() != null ? pet.getTuoiThang() : 0);
        m.put("mauSac", pet.getMauSac() != null ? pet.getMauSac() : "");
        m.put("canNang", pet.getCanNang() != null ? pet.getCanNang().doubleValue() : null);
        m.put("dacDiemNhanDang", pet.getDacDiemNhanDang() != null ? pet.getDacDiemNhanDang() : "");
        m.put("soMicrochip", pet.getSoMicrochip() != null ? pet.getSoMicrochip() : "");
        m.put("tinhTrangSucKhoeHienTai", pet.getTinhTrangSucKhoeHienTai() != null ? pet.getTinhTrangSucKhoeHienTai() : "Khỏe mạnh");
        m.put("tienSuBenhLy", pet.getTienSuBenhLy() != null ? pet.getTienSuBenhLy() : "");
        m.put("diUngThuocThucAn", pet.getDiUngThuocThucAn() != null ? pet.getDiUngThuocThucAn() : "");
        m.put("lichSuTiemChung", pet.getLichSuTiemChung() != null ? pet.getLichSuTiemChung() : "");
        m.put("hinhAnh", pet.getHinhAnh() != null ? pet.getHinhAnh() : "");
        m.put("trangThai", pet.getTrangThai() != null ? pet.getTrangThai() : "Đang nuôi");
        m.put("ghiChu", pet.getGhiChu() != null ? pet.getGhiChu() : "");
        m.put("ngayTaoHoSo", pet.getNgayTaoHoSo() != null ? pet.getNgayTaoHoSo().format(DATETIME_FMT) : null);
        return m;
    }

    // 1. Lấy danh sách thú cưng của khách hàng
    @GetMapping("/my")
    public ResponseEntity<?> getMyPets(@RequestParam Integer maKH) {
        if (maKH == null) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Mã khách hàng không hợp lệ"));
        }

        Customer customer = customerRepository.findById(maKH).orElse(null);
        if (customer == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("success", false, "message", "Không tìm thấy khách hàng"));
        }

        // Tìm ChuNuoi liên kết
        Optional<ChuNuoi> chuNuoiOpt = chuNuoiRepository.findFirstByMaKH(maKH);
        if (chuNuoiOpt.isEmpty() && customer.getDienThoai() != null && !customer.getDienThoai().isBlank()) {
            chuNuoiOpt = chuNuoiRepository.findFirstBySoDienThoai(customer.getDienThoai().trim());
        }

        if (chuNuoiOpt.isEmpty()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<HoSoThuCung> list = hoSoThuCungRepository.findByMaChuNuoi(chuNuoiOpt.get().getMaChuNuoi());
        List<Map<String, Object>> result = new ArrayList<>();
        for (HoSoThuCung pet : list) {
            result.add(mapPet(pet));
        }

        return ResponseEntity.ok(result);
    }

    // 2. Chi tiết 1 thú cưng
    @GetMapping("/{id}")
    public ResponseEntity<?> getPetDetail(@PathVariable Integer id) {
        Optional<HoSoThuCung> petOpt = hoSoThuCungRepository.findById(id);
        if (petOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("success", false, "message", "Không tìm thấy thú cưng"));
        }
        return ResponseEntity.ok(mapPet(petOpt.get()));
    }

    // 3. Khách hàng thêm mới thú cưng
    @PostMapping
    public ResponseEntity<?> createPet(@RequestBody Map<String, Object> payload) {
        try {
            Integer maKH = payload.get("maKH") != null ? Integer.valueOf(payload.get("maKH").toString()) : null;
            String tenThuCung = payload.get("tenThuCung") != null ? payload.get("tenThuCung").toString().trim() : null;
            String loaiThuCung = payload.get("loaiThuCung") != null ? payload.get("loaiThuCung").toString().trim() : null;

            if (maKH == null || tenThuCung == null || tenThuCung.isBlank() || loaiThuCung == null || loaiThuCung.isBlank()) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Vui lòng nhập tên và loài thú cưng"));
            }

            Customer customer = customerRepository.findById(maKH).orElse(null);
            if (customer == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("success", false, "message", "Không tìm thấy khách hàng"));
            }

            // Tìm hoặc tự tạo hồ sơ chủ nuôi cho khách hàng
            Optional<ChuNuoi> chuNuoiOpt = chuNuoiRepository.findFirstByMaKH(maKH);
            if (chuNuoiOpt.isEmpty() && customer.getDienThoai() != null && !customer.getDienThoai().isBlank()) {
                chuNuoiOpt = chuNuoiRepository.findFirstBySoDienThoai(customer.getDienThoai().trim());
            }

            ChuNuoi chuNuoi;
            if (chuNuoiOpt.isEmpty()) {
                chuNuoi = new ChuNuoi();
                chuNuoi.setHoTenChuNuoi(customer.getTenKH());
                chuNuoi.setSoDienThoai(customer.getDienThoai() != null ? customer.getDienThoai().trim() : "");
                chuNuoi.setEmail(customer.getEmail());
                chuNuoi.setDiaChi(customer.getDiaChi() != null ? customer.getDiaChi().trim() : "");
                chuNuoi.setMaKH(customer.getMaKH());
                chuNuoi = chuNuoiRepository.save(chuNuoi);
            } else {
                chuNuoi = chuNuoiOpt.get();
                if (chuNuoi.getMaKH() == null) {
                    chuNuoi.setMaKH(customer.getMaKH());
                    chuNuoiRepository.save(chuNuoi);
                }
            }

            HoSoThuCung pet = new HoSoThuCung();
            pet.setMaChuNuoi(chuNuoi.getMaChuNuoi());
            pet.setTenThuCung(tenThuCung);
            pet.setLoaiThuCung(loaiThuCung);

            if (payload.get("giongLoai") != null) pet.setGiongLoai(payload.get("giongLoai").toString().trim());
            if (payload.get("gioiTinh") != null) pet.setGioiTinh(payload.get("gioiTinh").toString().trim());
            if (payload.get("mauSac") != null) pet.setMauSac(payload.get("mauSac").toString().trim());
            if (payload.get("dacDiemNhanDang") != null) pet.setDacDiemNhanDang(payload.get("dacDiemNhanDang").toString().trim());
            if (payload.get("soMicrochip") != null) pet.setSoMicrochip(payload.get("soMicrochip").toString().trim());
            if (payload.get("tinhTrangSucKhoeHienTai") != null) pet.setTinhTrangSucKhoeHienTai(payload.get("tinhTrangSucKhoeHienTai").toString().trim());
            if (payload.get("tienSuBenhLy") != null) pet.setTienSuBenhLy(payload.get("tienSuBenhLy").toString().trim());
            if (payload.get("diUngThuocThucAn") != null) pet.setDiUngThuocThucAn(payload.get("diUngThuocThucAn").toString().trim());
            if (payload.get("lichSuTiemChung") != null) pet.setLichSuTiemChung(payload.get("lichSuTiemChung").toString().trim());
            if (payload.get("hinhAnh") != null) pet.setHinhAnh(payload.get("hinhAnh").toString().trim());
            if (payload.get("ghiChu") != null) pet.setGhiChu(payload.get("ghiChu").toString().trim());
            if (payload.get("trangThai") != null) pet.setTrangThai(payload.get("trangThai").toString().trim());

            if (payload.get("trietSan") != null) {
                pet.setTrietSan(Boolean.parseBoolean(payload.get("trietSan").toString()));
            }
            if (payload.get("tuoiThang") != null) {
                try { pet.setTuoiThang(Integer.parseInt(payload.get("tuoiThang").toString())); } catch (Exception ignored) {}
            }
            if (payload.get("canNang") != null) {
                try { pet.setCanNang(BigDecimal.valueOf(Double.parseDouble(payload.get("canNang").toString()))); } catch (Exception ignored) {}
            }
            if (payload.get("ngaySinh") != null && !payload.get("ngaySinh").toString().isBlank()) {
                try { pet.setNgaySinh(LocalDate.parse(payload.get("ngaySinh").toString().trim(), DATE_FMT)); } catch (Exception ignored) {}
            }

            pet.setNgayTaoHoSo(LocalDateTime.now());
            HoSoThuCung saved = hoSoThuCungRepository.save(pet);

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Thêm hồ sơ thú cưng thành công!",
                    "pet", mapPet(saved)
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Lỗi: " + e.getMessage()));
        }
    }

    // 4. Cập nhật hồ sơ thú cưng
    @PutMapping("/{id}")
    public ResponseEntity<?> updatePet(@PathVariable Integer id, @RequestBody Map<String, Object> payload) {
        try {
            Optional<HoSoThuCung> petOpt = hoSoThuCungRepository.findById(id);
            if (petOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("success", false, "message", "Không tìm thấy thú cưng"));
            }

            HoSoThuCung pet = petOpt.get();

            if (payload.get("tenThuCung") != null && !payload.get("tenThuCung").toString().isBlank()) {
                pet.setTenThuCung(payload.get("tenThuCung").toString().trim());
            }
            if (payload.get("loaiThuCung") != null && !payload.get("loaiThuCung").toString().isBlank()) {
                pet.setLoaiThuCung(payload.get("loaiThuCung").toString().trim());
            }
            if (payload.containsKey("giongLoai")) pet.setGiongLoai(payload.get("giongLoai") != null ? payload.get("giongLoai").toString().trim() : null);
            if (payload.containsKey("gioiTinh")) pet.setGioiTinh(payload.get("gioiTinh") != null ? payload.get("gioiTinh").toString().trim() : null);
            if (payload.containsKey("mauSac")) pet.setMauSac(payload.get("mauSac") != null ? payload.get("mauSac").toString().trim() : null);
            if (payload.containsKey("dacDiemNhanDang")) pet.setDacDiemNhanDang(payload.get("dacDiemNhanDang") != null ? payload.get("dacDiemNhanDang").toString().trim() : null);
            if (payload.containsKey("soMicrochip")) pet.setSoMicrochip(payload.get("soMicrochip") != null ? payload.get("soMicrochip").toString().trim() : null);
            if (payload.containsKey("tinhTrangSucKhoeHienTai")) pet.setTinhTrangSucKhoeHienTai(payload.get("tinhTrangSucKhoeHienTai") != null ? payload.get("tinhTrangSucKhoeHienTai").toString().trim() : null);
            if (payload.containsKey("tienSuBenhLy")) pet.setTienSuBenhLy(payload.get("tienSuBenhLy") != null ? payload.get("tienSuBenhLy").toString().trim() : null);
            if (payload.containsKey("diUngThuocThucAn")) pet.setDiUngThuocThucAn(payload.get("diUngThuocThucAn") != null ? payload.get("diUngThuocThucAn").toString().trim() : null);
            if (payload.containsKey("lichSuTiemChung")) pet.setLichSuTiemChung(payload.get("lichSuTiemChung") != null ? payload.get("lichSuTiemChung").toString().trim() : null);
            if (payload.containsKey("hinhAnh")) pet.setHinhAnh(payload.get("hinhAnh") != null ? payload.get("hinhAnh").toString().trim() : null);
            if (payload.containsKey("ghiChu")) pet.setGhiChu(payload.get("ghiChu") != null ? payload.get("ghiChu").toString().trim() : null);
            if (payload.containsKey("trangThai")) pet.setTrangThai(payload.get("trangThai") != null ? payload.get("trangThai").toString().trim() : "Đang nuôi");

            if (payload.containsKey("trietSan")) {
                pet.setTrietSan(payload.get("trietSan") != null && Boolean.parseBoolean(payload.get("trietSan").toString()));
            }
            if (payload.containsKey("tuoiThang")) {
                try {
                    pet.setTuoiThang(payload.get("tuoiThang") != null ? Integer.parseInt(payload.get("tuoiThang").toString()) : null);
                } catch (Exception ignored) {}
            }
            if (payload.containsKey("canNang")) {
                try {
                    pet.setCanNang(payload.get("canNang") != null ? BigDecimal.valueOf(Double.parseDouble(payload.get("canNang").toString())) : null);
                } catch (Exception ignored) {}
            }
            if (payload.containsKey("ngaySinh")) {
                try {
                    String ds = payload.get("ngaySinh") != null ? payload.get("ngaySinh").toString().trim() : null;
                    pet.setNgaySinh(ds != null && !ds.isBlank() ? LocalDate.parse(ds, DATE_FMT) : null);
                } catch (Exception ignored) {}
            }

            HoSoThuCung saved = hoSoThuCungRepository.save(pet);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Cập nhật hồ sơ thú cưng thành công!",
                    "pet", mapPet(saved)
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Lỗi: " + e.getMessage()));
        }
    }

    // 5. Xóa hồ sơ thú cưng
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePet(@PathVariable Integer id, @RequestParam(required = false) Integer maKH) {
        try {
            Optional<HoSoThuCung> petOpt = hoSoThuCungRepository.findById(id);
            if (petOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("success", false, "message", "Không tìm thấy thú cưng"));
            }

            // Nếu truyền maKH, kiểm tra quyền sở hữu
            if (maKH != null) {
                ChuNuoi owner = chuNuoiRepository.findById(petOpt.get().getMaChuNuoi()).orElse(null);
                if (owner != null && owner.getMaKH() != null && !owner.getMaKH().equals(maKH)) {
                    return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("success", false, "message", "Bạn không có quyền xóa thú cưng này"));
                }
            }

            hoSoThuCungRepository.deleteById(id);
            return ResponseEntity.ok(Map.of("success", true, "message", "Đã xóa hồ sơ thú cưng thành công!"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Lỗi: " + e.getMessage()));
        }
    }
}

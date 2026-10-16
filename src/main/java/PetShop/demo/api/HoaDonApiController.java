package PetShop.demo.api;

import PetShop.demo.model.dto.ChiTietDichVuItemDTO;
import PetShop.demo.model.dto.DichVuChoThanhToanDTO;
import PetShop.demo.model.dto.HoaDonRequestDTO;
import PetShop.demo.model.dto.ThanhToanRequestDTO;
import PetShop.demo.model.enity.ChiTietHoaDonDichVu;
import PetShop.demo.model.enity.ChiTietHoaDonDichVuId;
import PetShop.demo.model.enity.Customer;
import PetShop.demo.model.enity.Employee;
import PetShop.demo.model.enity.HoaDonDichVu;
import PetShop.demo.repository.ChiTietHoaDonDichVuRepository;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.repository.EmployeeRepository;
import PetShop.demo.repository.PetServiceRepository;
import PetShop.demo.service.HoaDonDichVuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;

@RestController
@RequestMapping(value = "/api/hoa-don", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
@CrossOrigin(origins = "*")
public class HoaDonApiController {

    @Autowired
    private HoaDonDichVuService hoaDonDichVuService;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private ChiTietHoaDonDichVuRepository chiTietHoaDonDichVuRepository;

    @Autowired
    private PetServiceRepository petServiceRepository;

    /**
     * 1. POST /api/hoa-don: Tạo một hóa đơn mới cho chức năng Thu ngân
     * Nhận vào: MaKH, MaNV, TongTien, GhiChu, PhuongThucThanhToan, Items (danh sách dịch vụ), MaPhieuDV, MaDatLich
     * Trả về: Mã hóa đơn vừa tạo (maHDDV / maHoaDon)
     */
    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> createHoaDon(@RequestBody HoaDonRequestDTO request) {
        if (request == null) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Dữ liệu yêu cầu không hợp lệ"
            ));
        }

        BigDecimal tongTien = request.getTongTien() != null ? request.getTongTien() : BigDecimal.ZERO;
        String phuongThuc = (request.getPhuongThucThanhToan() != null && !request.getPhuongThucThanhToan().isBlank())
                ? request.getPhuongThucThanhToan().trim()
                : "TienMat";

        HoaDonDichVu hoaDon;
        if (request.getMaPhieuDV() != null || request.getMaDatLich() != null) {
            hoaDon = hoaDonDichVuService.createHoaDon(
                    request.getMaKH(),
                    request.getMaNV(),
                    tongTien,
                    phuongThuc,
                    request.getGhiChu(),
                    request.getMaPhieuDV(),
                    request.getMaDatLich()
            );
        } else {
            hoaDon = hoaDonDichVuService.createHoaDon(
                    request.getMaKH(),
                    request.getMaNV(),
                    tongTien,
                    phuongThuc,
                    request.getGhiChu()
            );
        }

        // Lưu danh sách chi tiết dịch vụ vào tblChiTietHoaDonDichVu
        if (request.getItems() != null && !request.getItems().isEmpty()) {
            for (ChiTietDichVuItemDTO item : request.getItems()) {
                if (item != null && item.getMaDV() != null) {
                    ChiTietHoaDonDichVu ct = new ChiTietHoaDonDichVu();
                    ct.setId(new ChiTietHoaDonDichVuId(hoaDon.getMaHDDV(), item.getMaDV()));
                    ct.setHoaDonDichVu(hoaDon);
                    petServiceRepository.findById(item.getMaDV()).ifPresent(ct::setPetService);
                    ct.setSoLuong(item.getSoLuong() != null && item.getSoLuong() > 0 ? item.getSoLuong() : 1);
                    ct.setGiaDichVu(item.getGiaDichVu() != null ? item.getGiaDichVu() : BigDecimal.ZERO);
                    chiTietHoaDonDichVuRepository.save(ct);
                }
            }
        }

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("message", "Tạo hóa đơn thành công");
        response.put("maHDDV", hoaDon.getMaHDDV());
        response.put("maHoaDon", hoaDon.getMaHDDV());
        response.put("trangThai", hoaDon.getTrangThai());
        response.put("tongTien", hoaDon.getTongTien());
        response.put("phuongThucThanhToan", hoaDon.getPhuongThucThanhToan());
        response.put("ngaySuDung", hoaDon.getNgaySuDung() != null ? hoaDon.getNgaySuDung().toString() : "");
        response.put("maPhieuDV", hoaDon.getMaPhieuDV());
        response.put("maDatLich", hoaDon.getMaDatLich());

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * 2. GET /api/hoa-don/{id}: Lấy thông tin chi tiết hóa đơn
     */
    @GetMapping("/{id}")
    public ResponseEntity<?> getHoaDonDetail(@PathVariable("id") Integer id) {
        Optional<HoaDonDichVu> opt = hoaDonDichVuService.getHoaDonById(id);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of(
                    "success", false,
                    "message", "Không tìm thấy hóa đơn dịch vụ với mã: " + id
            ));
        }

        HoaDonDichVu hd = opt.get();
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("maHDDV", hd.getMaHDDV());
        res.put("maHoaDon", hd.getMaHDDV());
        res.put("maKH", hd.getMaKH());

        // Thông tin khách hàng
        if (hd.getMaKH() != null) {
            Optional<Customer> custOpt = customerRepository.findById(hd.getMaKH());
            if (custOpt.isPresent()) {
                Customer c = custOpt.get();
                res.put("tenKH", c.getTenKH());
                res.put("dienThoai", c.getDienThoai());
                res.put("email", c.getEmail());
            }
        }

        res.put("maNV", hd.getMaNV());
        // Thông tin nhân viên lập / thực hiện
        if (hd.getMaNV() != null) {
            Optional<Employee> empOpt = employeeRepository.findById(hd.getMaNV());
            if (empOpt.isPresent()) {
                res.put("tenNV", empOpt.get().getTenNV());
            }
        }

        res.put("ngaySuDung", hd.getNgaySuDung() != null ? hd.getNgaySuDung().toString() : "");
        res.put("tongTien", hd.getTongTien());
        res.put("ghiChu", hd.getGhiChu());
        res.put("trangThai", hd.getTrangThai());
        res.put("phuongThucThanhToan", hd.getPhuongThucThanhToan());
        res.put("maPhieuDV", hd.getMaPhieuDV());
        res.put("maDatLich", hd.getMaDatLich());

        // Danh sách dịch vụ chi tiết (nếu có)
        List<ChiTietHoaDonDichVu> details = chiTietHoaDonDichVuRepository.findById_MaHDDV(hd.getMaHDDV());
        List<Map<String, Object>> items = new ArrayList<>();
        for (ChiTietHoaDonDichVu ct : details) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("maDV", ct.getId() != null ? ct.getId().getMaDV() : null);
            item.put("soLuong", ct.getSoLuong());
            item.put("giaDichVu", ct.getGiaDichVu());
            if (ct.getPetService() != null) {
                item.put("tenDV", ct.getPetService().getTenDV());
            } else {
                item.put("tenDV", "Dịch vụ #" + (ct.getId() != null ? ct.getId().getMaDV() : ""));
            }
            BigDecimal itemTotal = (ct.getGiaDichVu() != null && ct.getSoLuong() != null)
                    ? ct.getGiaDichVu().multiply(BigDecimal.valueOf(ct.getSoLuong()))
                    : BigDecimal.ZERO;
            item.put("thanhTien", itemTotal);
            items.add(item);
        }
        res.put("items", items);

        return ResponseEntity.ok(res);
    }

    /**
     * 3. POST /api/hoa-don/{id}/thanh-toan: Xác nhận thanh toán (hỗ trợ cả Tiền mặt và VNPay)
     * Cập nhật trạng thái thành 'DaThanhToan' và tự động đồng bộ sang Phiếu chăm sóc/Lịch đặt.
     */
    @PostMapping(value = "/{id}/thanh-toan")
    public ResponseEntity<?> xacNhanThanhToan(
            @PathVariable("id") Integer id,
            @RequestBody(required = false) ThanhToanRequestDTO body,
            @RequestParam(name = "phuongThuc", required = false) String phuongThucParam) {

        Optional<HoaDonDichVu> opt = hoaDonDichVuService.getHoaDonById(id);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of(
                    "success", false,
                    "message", "Không tìm thấy hóa đơn dịch vụ với mã: " + id
            ));
        }

        // Lấy phương thức thanh toán từ Body hoặc RequestParam
        String phuongThuc = null;
        if (body != null && body.getPhuongThucThanhToan() != null && !body.getPhuongThucThanhToan().isBlank()) {
            phuongThuc = body.getPhuongThucThanhToan().trim();
        } else if (phuongThucParam != null && !phuongThucParam.isBlank()) {
            phuongThuc = phuongThucParam.trim();
        }

        HoaDonDichVu updated;
        if (phuongThuc != null) {
            updated = hoaDonDichVuService.xacNhanThanhToan(id, phuongThuc);
        } else {
            updated = hoaDonDichVuService.xacNhanThanhToan(id);
        }

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Xác nhận thanh toán thành công");
        res.put("maHDDV", updated.getMaHDDV());
        res.put("maHoaDon", updated.getMaHDDV());
        res.put("trangThai", updated.getTrangThai());
        res.put("phuongThucThanhToan", updated.getPhuongThucThanhToan());
        res.put("tongTien", updated.getTongTien());
        res.put("ngaySuDung", updated.getNgaySuDung() != null ? updated.getNgaySuDung().toString() : "");

        return ResponseEntity.ok(res);
    }

    /**
     * 4. GET /api/hoa-don/cho-thanh-toan: Lấy danh sách dịch vụ đã hoàn thành chờ thu ngân thanh toán
     */
    @GetMapping("/cho-thanh-toan")
    public ResponseEntity<?> getDanhSachChoThanhToan() {
        List<DichVuChoThanhToanDTO> list = hoaDonDichVuService.getDanhSachDichVuChoThanhToan();
        return ResponseEntity.ok(list);
    }

    /**
     * 5. GET /api/hoa-don/tra-cuu?maDichVu=...: Tra cứu dịch vụ chờ thanh toán theo mã dịch vụ (PDV-..., BK-..., ID)
     */
    @GetMapping("/tra-cuu")
    public ResponseEntity<?> traCuuDichVu(@RequestParam("maDichVu") String maDichVu) {
        Optional<DichVuChoThanhToanDTO> opt = hoaDonDichVuService.traCuuDichVuTheoMa(maDichVu);
        if (opt.isPresent()) {
            return ResponseEntity.ok(Map.of("success", true, "data", opt.get()));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of(
                    "success", false,
                    "message", "Không tìm thấy dịch vụ hoàn thành chờ thanh toán với mã: " + maDichVu
            ));
        }
    }

    /**
     * API hỗ trợ quầy Thu ngân: GET /api/hoa-don (Xem danh sách hóa đơn theo trạng thái)
     */
    @GetMapping
    public ResponseEntity<?> getAllHoaDon(@RequestParam(name = "trangThai", required = false) String trangThai) {
        List<HoaDonDichVu> list;
        if (trangThai != null && !trangThai.isBlank()) {
            list = hoaDonDichVuService.getHoaDonByTrangThai(trangThai.trim());
        } else {
            list = hoaDonDichVuService.getAllHoaDon();
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (HoaDonDichVu hd : list) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("maHDDV", hd.getMaHDDV());
            m.put("maHoaDon", hd.getMaHDDV());
            m.put("maKH", hd.getMaKH());
            m.put("maNV", hd.getMaNV());
            m.put("tongTien", hd.getTongTien());
            m.put("trangThai", hd.getTrangThai());
            m.put("phuongThucThanhToan", hd.getPhuongThucThanhToan());
            m.put("ngaySuDung", hd.getNgaySuDung() != null ? hd.getNgaySuDung().toString() : "");
            m.put("ghiChu", hd.getGhiChu());
            m.put("maPhieuDV", hd.getMaPhieuDV());
            m.put("maDatLich", hd.getMaDatLich());
            result.add(m);
        }

        return ResponseEntity.ok(result);
    }
}

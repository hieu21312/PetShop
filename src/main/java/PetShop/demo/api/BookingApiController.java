package PetShop.demo.api;

import PetShop.demo.model.enity.Booking;
import PetShop.demo.model.enity.DichVuChamSoc;
import PetShop.demo.repository.BookingRepository;
import PetShop.demo.repository.DichVuChamSocRepository;
import PetShop.demo.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

import org.springframework.http.MediaType;

@RestController
@RequestMapping(value = "/api/bookings", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
@CrossOrigin(origins = "*")
public class BookingApiController {

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private DichVuChamSocRepository dichVuChamSocRepository;

    @Autowired
    private PetShop.demo.service.ThongBaoService thongBaoService;

    // Lấy danh mục dịch vụ chăm sóc
    @GetMapping("/services")
    public ResponseEntity<?> getServices() {
        List<DichVuChamSoc> list = dichVuChamSocRepository.findAll();
        List<Map<String, Object>> result = new ArrayList<>();
        for (DichVuChamSoc dv : list) {
            Map<String, Object> m = new HashMap<>();
            m.put("maDV", dv.getMaDVCS());
            m.put("tenDV", dv.getTenDichVu());
            m.put("moTa", dv.getMoTaChiTiet());
            m.put("giaDichVu", dv.getGiaDichVu());
            result.add(m);
        }
        return ResponseEntity.ok(result);
    }

    // Lấy lịch hẹn của khách hàng
    @GetMapping("/my")
    public ResponseEntity<?> getMyBookings(@RequestParam Integer maKH) {
        List<Booking> bookings = bookingService.getBookingsByCustomer(maKH);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Booking b : bookings) {
            Map<String, Object> m = new HashMap<>();
            m.put("maDatLich", b.getMaDatLich());
            m.put("tenKhachHang", b.getTenKhachHang());
            m.put("soDienThoai", b.getSoDienThoai());
            m.put("ngayDat", b.getNgayDat() != null ? b.getNgayDat().toString() : "");
            m.put("gioDat", b.getGioDat() != null ? b.getGioDat().toString() : "");
            m.put("trangThai", b.getTrangThai());
            m.put("ghiChu", b.getGhiChu());
            m.put("maDV", b.getMaDV());
            if (b.getMaDV() != null) {
                dichVuChamSocRepository.findById(b.getMaDV()).ifPresent(dv -> m.put("tenDichVu", dv.getTenDichVu()));
            }
            result.add(m);
        }
        return ResponseEntity.ok(result);
    }

    // Tạo lịch hẹn mới từ Mobile
    @PostMapping
    public ResponseEntity<?> createBooking(@RequestBody Map<String, Object> payload) {
        String tenKhachHang = (String) payload.get("tenKhachHang");
        String soDienThoai = (String) payload.get("soDienThoai");
        String email = (String) payload.get("email");
        String ngayDatStr = (String) payload.get("ngayDat");
        String gioDatStr = (String) payload.get("gioDat");
        String ghiChu = (String) payload.get("ghiChu");
        Integer maKH = payload.get("maKH") != null ? Integer.parseInt(payload.get("maKH").toString()) : null;
        Integer maDV = payload.get("maDV") != null ? Integer.parseInt(payload.get("maDV").toString()) : null;

        if (tenKhachHang == null || soDienThoai == null || ngayDatStr == null || gioDatStr == null) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Thiếu thông tin đặt lịch bắt buộc"));
        }

        Booking b = new Booking();
        b.setTenKhachHang(tenKhachHang.trim());
        b.setSoDienThoai(soDienThoai.trim());
        b.setEmail(email != null ? email.trim() : "");
        b.setNgayDat(LocalDate.parse(ngayDatStr));
        b.setGioDat(LocalTime.parse(gioDatStr));
        b.setGhiChu(ghiChu);
        b.setMaKH(maKH);
        b.setMaDV(maDV);
        b.setTrangThai("Chờ xác nhận");
        b.setNgayTao(LocalDateTime.now());

        bookingRepository.save(b);

        if (maKH != null) {
            String dvName = "Dịch vụ chăm sóc";
            if (maDV != null) {
                var dvOpt = dichVuChamSocRepository.findById(maDV);
                if (dvOpt.isPresent()) dvName = dvOpt.get().getTenDichVu();
            }
            thongBaoService.taoThongBaoDatLich(
                    maKH,
                    "📅 Đặt lịch hẹn thành công!",
                    "Lịch hẹn " + dvName + " vào ngày " + ngayDatStr + " lúc " + gioDatStr + " đã được tiếp nhận.",
                    LocalDateTime.now(),
                    "DatLich"
            );
        }

        return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Đặt lịch hẹn thành công!",
                "maDatLich", b.getMaDatLich()
        ));
    }
}

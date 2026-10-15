package PetShop.demo.api;

import PetShop.demo.model.enity.Booking;
import PetShop.demo.model.enity.PhieuDichVuChamSoc;
import PetShop.demo.repository.BookingRepository;
import PetShop.demo.repository.DichVuChamSocRepository;
import PetShop.demo.repository.PhieuDichVuChamSocRepository;
import PetShop.demo.service.BookingService;
import PetShop.demo.service.ThongBaoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.*;

@RestController
@RequestMapping(value = "/api/staff", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
@CrossOrigin(origins = "*")
public class StaffApiController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private PhieuDichVuChamSocRepository phieuRepository;

    @Autowired
    private DichVuChamSocRepository dichVuChamSocRepository;

    @Autowired
    private ThongBaoService thongBaoService;

    // Lấy danh sách công việc / ca làm việc của nhân viên
    @GetMapping("/tasks")
    public ResponseEntity<?> getMyTasks(@RequestParam Integer maNV) {
        List<Booking> bookings = bookingService.getBookingsByStaff(maNV);
        List<PhieuDichVuChamSoc> careTickets = phieuRepository.findByMaNVThucHienOrderByNgayTiepNhanDesc(maNV);

        List<Map<String, Object>> bookingList = new ArrayList<>();
        for (Booking b : bookings) {
            Map<String, Object> m = new HashMap<>();
            m.put("maDatLich", b.getMaDatLich());
            m.put("tenKhachHang", b.getTenKhachHang());
            m.put("soDienThoai", b.getSoDienThoai());
            m.put("email", b.getEmail());
            m.put("ngayDat", b.getNgayDat() != null ? b.getNgayDat().toString() : "");
            m.put("gioDat", b.getGioDat() != null ? b.getGioDat().toString() : "");
            m.put("trangThai", b.getTrangThai());
            m.put("ghiChu", b.getGhiChu());
            m.put("maDV", b.getMaDV());
            if (b.getMaDV() != null) {
                dichVuChamSocRepository.findById(b.getMaDV()).ifPresent(dv -> m.put("tenDichVu", dv.getTenDichVu()));
            }
            bookingList.add(m);
        }

        List<Map<String, Object>> ticketList = new ArrayList<>();
        for (PhieuDichVuChamSoc t : careTickets) {
            Map<String, Object> m = new HashMap<>();
            m.put("maPhieuDV", t.getMaPhieuDV());
            m.put("soPhieu", t.getSoPhieu());
            m.put("ngayTiepNhan", t.getNgayTiepNhan() != null ? t.getNgayTiepNhan().toString() : "");
            m.put("ngayHenTra", t.getNgayHenTra() != null ? t.getNgayHenTra().toString() : "");
            m.put("ngayTraThucTe", t.getNgayTraThucTe() != null ? t.getNgayTraThucTe().toString() : "");
            m.put("trangThaiDichVu", t.getTrangThaiDichVu());
            m.put("tinhTrangBanDau", t.getTinhTrangBanDau());
            m.put("yeuCauCuaChuNuoi", t.getYeuCauCuaChuNuoi());
            m.put("ketQuaChamSoc", t.getKetQuaChamSoc());
            m.put("canNangTiepNhan", t.getCanNangTiepNhan());
            m.put("tongTien", t.getTongTien());
            m.put("thanhToan", t.getThanhToan());
            m.put("trangThaiThanhToan", t.getTrangThaiThanhToan());

            if (t.getThuCung() != null) {
                m.put("tenThuCung", t.getThuCung().getTenThuCung());
                m.put("loaiThuCung", t.getThuCung().getLoaiThuCung());
                m.put("giongLoai", t.getThuCung().getGiongLoai());
            }
            if (t.getChuNuoi() != null) {
                m.put("tenChuNuoi", t.getChuNuoi().getHoTenChuNuoi());
                m.put("soDienThoaiChu", t.getChuNuoi().getSoDienThoai());
            }

            ticketList.add(m);
        }

        Map<String, Object> response = new HashMap<>();
        response.put("bookings", bookingList);
        response.put("careTickets", ticketList);
        return ResponseEntity.ok(response);
    }

    // Cập nhật tiến độ lịch hẹn dịch vụ
    @PostMapping("/tasks/update-booking")
    public ResponseEntity<?> updateBookingProgress(@RequestBody Map<String, Object> payload) {
        Integer id = payload.get("id") != null ? Integer.parseInt(payload.get("id").toString()) : null;
        String trangThai = (String) payload.get("trangThai");
        String ghiChu = (String) payload.get("ghiChu");

        if (id == null || trangThai == null) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Thiếu ID hoặc trạng thái lịch hẹn"));
        }

        Booking booking = bookingService.getBookingById(id);
        if (booking == null) {
            return ResponseEntity.notFound().build();
        }

        bookingService.updateProgressAndNotes(id, trangThai, ghiChu);
        return ResponseEntity.ok(Map.of("success", true, "message", "Cập nhật tiến độ lịch hẹn #" + id + " thành công"));
    }

    // Cập nhật tiến độ phiếu dịch vụ chăm sóc thú cưng
    @PostMapping("/tasks/update-ticket")
    public ResponseEntity<?> updateTicketProgress(@RequestBody Map<String, Object> payload) {
        Integer id = payload.get("id") != null ? Integer.parseInt(payload.get("id").toString()) : null;
        String trangThaiDichVu = (String) payload.get("trangThaiDichVu");
        String ketQuaChamSoc = (String) payload.get("ketQuaChamSoc");

        if (id == null || trangThaiDichVu == null) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Thiếu ID hoặc trạng thái dịch vụ"));
        }

        var ticketOpt = phieuRepository.findById(id);
        if (ticketOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        PhieuDichVuChamSoc ticket = ticketOpt.get();
        ticket.setTrangThaiDichVu(trangThaiDichVu);
        if (ketQuaChamSoc != null) {
            ticket.setKetQuaChamSoc(ketQuaChamSoc);
        }
        if (("Hoàn thành chăm sóc".equalsIgnoreCase(trangThaiDichVu) || "Đã trả bé".equalsIgnoreCase(trangThaiDichVu))
                && ticket.getNgayTraThucTe() == null) {
            ticket.setNgayTraThucTe(LocalDateTime.now());
        }
        phieuRepository.save(ticket);

        // Gửi thông báo cho chủ nuôi nếu đã liên kết
        if (ticket.getChuNuoi() != null && ticket.getChuNuoi().getMaKH() != null) {
            String petName = ticket.getThuCung() != null ? ticket.getThuCung().getTenThuCung() : "Bé cưng";
            String msg = "Dịch vụ của bé " + petName + " (" + ticket.getSoPhieu() + ") đã chuyển sang trạng thái: " + trangThaiDichVu;
            thongBaoService.taoThongBaoNhacLich(ticket.getChuNuoi().getMaKH(), null, "Cập nhật tiến độ chăm sóc thú cưng", msg, null);
        }

        return ResponseEntity.ok(Map.of("success", true, "message", "Cập nhật phiếu chăm sóc " + ticket.getSoPhieu() + " thành công"));
    }
}

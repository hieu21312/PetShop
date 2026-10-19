package PetShop.demo.api;

import PetShop.demo.model.dto.DashboardDTO;
import PetShop.demo.model.enity.*;
import PetShop.demo.repository.*;
import PetShop.demo.service.AdminService;
import PetShop.demo.service.BookingService;
import PetShop.demo.service.MembershipService;
import PetShop.demo.service.OrderService;
import PetShop.demo.service.ThongBaoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping(value = "/api/admin", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
@CrossOrigin(origins = "*")
public class AdminApiController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderDetailRepository orderDetailRepository;

    @Autowired
    private OrderService orderService;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private PhieuDichVuChamSocRepository phieuRepository;

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private DichVuChamSocRepository dichVuChamSocRepository;

    @Autowired
    private MembershipService membershipService;

    @Autowired
    private ThongBaoService thongBaoService;

    @Autowired
    private PetShop.demo.service.RevenueReportService revenueReportService;

    // 1. Dashboard tổng quan
    @GetMapping("/dashboard")
    public ResponseEntity<?> getDashboard() {
        DashboardDTO dto = adminService.getDashboardData();
        return ResponseEntity.ok(dto);
    }

    // Báo cáo doanh thu theo ngày, tuần, tháng, năm
    @GetMapping("/revenue-report")
    public ResponseEntity<?> getRevenueReport(
            @RequestParam(defaultValue = "day") String type,
            @RequestParam(required = false) String date,
            @RequestParam(required = false) String month,
            @RequestParam(required = false) Integer year) {
        PetShop.demo.model.dto.RevenueReportDTO report = revenueReportService.generateReport(type, date, month, year, null, null);
        report.setOrders(null);
        report.setTickets(null);
        return ResponseEntity.ok(report);
    }

    // 2. Danh sách toàn bộ đơn hàng
    @GetMapping("/orders")
    public ResponseEntity<?> getOrders() {
        List<Order> orders = orderRepository.findAllByOrderByNgayLapDesc();
        List<Map<String, Object>> list = new ArrayList<>();
        for (Order o : orders) {
            Map<String, Object> m = new HashMap<>();
            m.put("maHD", o.getMaHD());
            m.put("ngayLap", o.getNgayLap() != null ? o.getNgayLap().toString() : "");
            m.put("tongTien", o.getTongTien());
            m.put("tienGiam", o.getTienGiam());
            m.put("tinhTrang", o.getTinhTrang());
            m.put("tinhTrangText", o.getOrderStatus() != null ? o.getOrderStatus().getTinhTrangDonHang() : "Đang xử lý");
            m.put("daThanhToan", o.getDaThanhToan());
            m.put("diaChiGiaoHang", o.getDiaChiGiaoHang());
            m.put("hinhThucThanhToan", o.getHinhThucThanhToan());
            m.put("maKH", o.getMaKH());

            if (o.getCustomer() != null) {
                m.put("tenKhachHang", o.getCustomer().getTenKH());
                m.put("emailKhachHang", o.getCustomer().getEmail());
                m.put("soDienThoai", o.getCustomer().getDienThoai());
            }

            list.add(m);
        }
        return ResponseEntity.ok(list);
    }

    // 3. Cập nhật trạng thái đơn hàng
    @PostMapping("/orders/update-status")
    public ResponseEntity<?> updateOrderStatus(@RequestBody Map<String, Object> payload) {
        Integer maHD = payload.get("maHD") != null ? Integer.parseInt(payload.get("maHD").toString()) : null;
        Integer tinhTrang = payload.get("tinhTrang") != null ? Integer.parseInt(payload.get("tinhTrang").toString()) : null;
        Boolean daThanhToan = payload.get("daThanhToan") != null ? Boolean.parseBoolean(payload.get("daThanhToan").toString()) : null;

        if (maHD == null) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Thiếu mã đơn hàng"));
        }

        Optional<Order> orderOpt = orderRepository.findById(maHD);
        if (orderOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Order order = orderOpt.get();
        Integer oldStatus = order.getTinhTrang();

        if (tinhTrang != null) {
            order.setTinhTrang(tinhTrang);
        }
        if (daThanhToan != null) {
            order.setDaThanhToan(daThanhToan);
        }
        orderRepository.save(order);

        // Khôi phục kho & voucher nếu đơn hủy
        if (tinhTrang != null && tinhTrang == 5 && (oldStatus == null || oldStatus != 5)) {
            orderService.cancelOrderAndRestoreStock(order);
        }

        // Tích điểm nếu đã thanh toán
        if (Boolean.TRUE.equals(order.getDaThanhToan())) {
            membershipService.processOrderPoints(order);
        }

        // Gửi thông báo cho khách
        if (order.getMaKH() != null && tinhTrang != null && !tinhTrang.equals(oldStatus)) {
            String statusText = "đã được cập nhật";
            if (tinhTrang == 2) statusText = "đã được XÁC NHẬN";
            else if (tinhTrang == 3) statusText = "đang được GIAO HÀNG";
            else if (tinhTrang == 4) statusText = "đã HOÀN THÀNH";
            else if (tinhTrang == 5) statusText = "đã bị HỦY";

            String tieuDe = "Cập nhật đơn hàng #" + order.getMaHD();
            String noiDung = "Đơn hàng #" + order.getMaHD() + " của bạn " + statusText + ". Cảm ơn bạn đã mua sắm tại PetShop!";
            thongBaoService.taoThongBaoDatLich(order.getMaKH(), tieuDe, noiDung, null, "DonHang", "/DonHang/ChiTiet/" + order.getMaHD());
        }

        return ResponseEntity.ok(Map.of("success", true, "message", "Cập nhật đơn hàng #" + maHD + " thành công"));
    }

    // 4. Danh sách toàn bộ phiếu dịch vụ chăm sóc thú cưng
    @GetMapping("/care-tickets")
    public ResponseEntity<?> getCareTickets() {
        List<PhieuDichVuChamSoc> tickets = phieuRepository.findByOrderByNgayTiepNhanDesc();
        List<Map<String, Object>> list = new ArrayList<>();
        for (PhieuDichVuChamSoc t : tickets) {
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
            if (t.getNvThucHien() != null) {
                m.put("maNVThucHien", t.getNvThucHien().getMaNV());
                m.put("tenNVThucHien", t.getNvThucHien().getTenNV());
            } else if (t.getMaNVThucHien() != null) {
                m.put("maNVThucHien", t.getMaNVThucHien());
            }

            list.add(m);
        }
        return ResponseEntity.ok(list);
    }

    // 5. Phân công nhân viên thực hiện phiếu chăm sóc
    @PostMapping("/care-tickets/assign")
    public ResponseEntity<?> assignCareTicketStaff(@RequestBody Map<String, Object> payload) {
        Integer maPhieuDV = payload.get("maPhieuDV") != null ? Integer.parseInt(payload.get("maPhieuDV").toString()) : null;
        Integer maNV = payload.get("maNV") != null ? Integer.parseInt(payload.get("maNV").toString()) : null;

        if (maPhieuDV == null || maNV == null) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Thiếu mã phiếu hoặc mã nhân viên"));
        }

        var opt = phieuRepository.findById(maPhieuDV);
        if (opt.isEmpty()) return ResponseEntity.notFound().build();

        PhieuDichVuChamSoc t = opt.get();
        t.setMaNVThucHien(maNV);
        phieuRepository.save(t);

        return ResponseEntity.ok(Map.of("success", true, "message", "Phân công nhân viên thành công"));
    }

    // 6. Danh sách toàn bộ lịch hẹn
    @GetMapping("/bookings")
    public ResponseEntity<?> getBookings() {
        List<Booking> bookings = bookingRepository.findAllByOrderByNgayTaoDesc();
        List<Map<String, Object>> list = new ArrayList<>();
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
            if (b.getEmployee() != null) {
                m.put("maNV", b.getEmployee().getMaNV());
                m.put("tenNV", b.getEmployee().getTenNV());
            } else if (b.getMaNV() != null) {
                m.put("maNV", b.getMaNV());
                employeeRepository.findById(b.getMaNV()).ifPresent(e -> m.put("tenNV", e.getTenNV()));
            }
            list.add(m);
        }
        return ResponseEntity.ok(list);
    }

    // 7. Phân công nhân viên phụ trách lịch hẹn
    @PostMapping("/bookings/assign")
    public ResponseEntity<?> assignBookingStaff(@RequestBody Map<String, Object> payload) {
        Integer maDatLich = payload.get("maDatLich") != null ? Integer.parseInt(payload.get("maDatLich").toString()) : null;
        Integer maNV = payload.get("maNV") != null ? Integer.parseInt(payload.get("maNV").toString()) : null;

        if (maDatLich == null || maNV == null) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Thiếu mã lịch hẹn hoặc mã nhân viên"));
        }

        bookingService.assignStaff(maDatLich, maNV);
        return ResponseEntity.ok(Map.of("success", true, "message", "Phân công nhân sự cho lịch hẹn thành công"));
    }

    // 8. Cập nhật trạng thái lịch hẹn
    @PostMapping("/bookings/update-status")
    public ResponseEntity<?> updateBookingStatus(@RequestBody Map<String, Object> payload) {
        Integer maDatLich = payload.get("maDatLich") != null ? Integer.parseInt(payload.get("maDatLich").toString()) : null;
        String trangThai = (String) payload.get("trangThai");

        if (maDatLich == null || trangThai == null) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Thiếu mã lịch hẹn hoặc trạng thái"));
        }

        bookingService.updateStatus(maDatLich, trangThai);
        return ResponseEntity.ok(Map.of("success", true, "message", "Cập nhật trạng thái lịch hẹn thành công"));
    }

    // 9. Danh sách nhân sự đang làm việc (để phân công)
    @GetMapping("/staff")
    public ResponseEntity<?> getStaffList() {
        List<Employee> allStaff = employeeRepository.findAll();
        List<Map<String, Object>> list = new ArrayList<>();
        for (Employee e : allStaff) {
            Map<String, Object> m = new HashMap<>();
            m.put("maNV", e.getMaNV());
            m.put("tenNV", e.getTenNV());
            m.put("email", e.getEmail());
            m.put("dienThoai", e.getDienThoai());
            m.put("chuyenMon", e.getChuyenMon());
            m.put("trangThai", e.getTrangThai());
            m.put("vaiTro", e.getVaiTro());
            m.put("tenVaiTro", e.getRole() != null ? e.getRole().getTenVaiTro() : "Nhân viên");
            list.add(m);
        }
        return ResponseEntity.ok(list);
    }
}

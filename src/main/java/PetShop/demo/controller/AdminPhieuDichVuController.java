package PetShop.demo.controller;

import PetShop.demo.model.enity.ChuNuoi;
import PetShop.demo.model.enity.DichVuChamSoc;
import PetShop.demo.model.enity.Employee;
import PetShop.demo.model.enity.HoSoThuCung;
import PetShop.demo.model.enity.PhieuDichVuChamSoc;
import PetShop.demo.model.enity.Booking;
import PetShop.demo.repository.BookingRepository;
import PetShop.demo.repository.ChuNuoiRepository;
import PetShop.demo.repository.DichVuChamSocRepository;
import PetShop.demo.repository.EmployeeRepository;
import PetShop.demo.repository.HoSoThuCungRepository;
import PetShop.demo.repository.PhieuDichVuChamSocRepository;
import PetShop.demo.model.enity.ChiTietDichVuChamSoc;
import PetShop.demo.repository.ChiTietDichVuChamSocRepository;
import PetShop.demo.model.enity.Customer;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.model.enity.Voucher;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.MembershipService;
import PetShop.demo.service.VoucherService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
@RequestMapping("/admin/care-tickets")
public class AdminPhieuDichVuController {

    @Autowired
    private PhieuDichVuChamSocRepository phieuRepository;

    @Autowired
    private HoSoThuCungRepository hoSoThuCungRepository;

    @Autowired
    private ChuNuoiRepository chuNuoiRepository;

    @Autowired
    private DichVuChamSocRepository dichVuChamSocRepository;

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private ChiTietDichVuChamSocRepository chiTietDichVuChamSocRepository;

    @Autowired
    private PetShop.demo.service.ThongBaoService thongBaoService;

    @Autowired
    private AuthService authService;

    @Autowired
    private MembershipService membershipService;

    @Autowired
    private VoucherService voucherService;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private CustomerRepository customerRepository;

    public static boolean isCareServiceStaff(Employee emp) {
        if (emp == null) return false;
        if (emp.getTrangThai() != null && !emp.getTrangThai().trim().equalsIgnoreCase("Đang làm việc")) {
            return false;
        }
        int roleId = emp.getVaiTro() != null ? emp.getVaiTro() : 0;
        String roleName = (emp.getRole() != null && emp.getRole().getTenVaiTro() != null) 
                ? emp.getRole().getTenVaiTro().trim() : "";

        // Các vai trò trực tiếp làm dịch vụ chăm sóc / y tế thú cưng từ CSDL (tblVaiTro):
        // 3: Bác sĩ thú y, 4: Nhân viên chăm sóc (hoặc Chăm sóc thú cưng)
        return roleId == 3 || roleId == 4 || roleId == 8 || roleId == 13
                || roleName.equalsIgnoreCase("Bác sĩ thú y") 
                || roleName.equalsIgnoreCase("Bác sĩ")
                || roleName.equalsIgnoreCase("Nhân viên chăm sóc")
                || roleName.equalsIgnoreCase("Chăm sóc thú cưng");
    }

    public static boolean isReceptionStaff(Employee emp) {
        if (emp == null) return false;
        if (emp.getTrangThai() != null && !emp.getTrangThai().trim().equalsIgnoreCase("Đang làm việc")) {
            return false;
        }
        int roleId = emp.getVaiTro() != null ? emp.getVaiTro() : 0;
        String roleName = (emp.getRole() != null && emp.getRole().getTenVaiTro() != null) 
                ? emp.getRole().getTenVaiTro().trim() : "";

        // Các vai trò phụ trách tiếp nhận khách tại quầy / tạo phiếu từ CSDL:
        // 5: Thu ngân, 1: Admin, 2: Quản lý cửa hàng (cũng hỗ trợ roleId 6 cũ nếu có)
        return roleId == 5 || roleId == 1 || roleId == 2 || roleId == 6
                || roleName.equalsIgnoreCase("Thu ngân")
                || roleName.equalsIgnoreCase("Nhân viên thu ngân")
                || roleName.equalsIgnoreCase("Quản lý cửa hàng")
                || roleName.equalsIgnoreCase("Quản lý")
                || roleName.equalsIgnoreCase("Admin");
    }

    public static boolean isEligibleForService(Employee emp, DichVuChamSoc s) {
        if (emp == null || s == null) return false;
        if (emp.getTrangThai() != null && !emp.getTrangThai().trim().equalsIgnoreCase("Đang làm việc")) {
            return false;
        }

        int roleId = emp.getVaiTro() != null ? emp.getVaiTro() : 0;
        String roleName = (emp.getRole() != null && emp.getRole().getTenVaiTro() != null) 
                ? emp.getRole().getTenVaiTro().trim() : "";
        String chuyenMon = emp.getChuyenMon() != null ? emp.getChuyenMon().trim().toLowerCase() : "";

        String nhom = s.getNhomDichVu() != null ? s.getNhomDichVu().trim().toLowerCase() : "";
        String name = s.getTenDichVu() != null ? s.getTenDichVu().trim().toLowerCase() : "";

        // 1. Nhóm Dịch vụ Y tế / Thú y & Khám chữa bệnh
        if (nhom.contains("thú y") || nhom.contains("khám") || nhom.contains("chữa") || nhom.contains("y tế")
                || name.contains("khám") || name.contains("tiêm") || name.contains("vắc xin") 
                || name.contains("thuốc") || name.contains("triệt sản") || name.contains("xét nghiệm") || name.contains("phẫu thuật")) {

            // Bắt buộc Bác sĩ thú y (Role 3)
            return roleId == 3 || roleName.equalsIgnoreCase("Bác sĩ thú y") || roleName.equalsIgnoreCase("Bác sĩ");
        }

        // 2. Nhóm Spa & Grooming (Tắm sấy, cắt tỉa lông, vệ sinh tai móng, cạo lông, gỡ rối)
        if (nhom.contains("spa") || nhom.contains("grooming")
                || name.contains("tắm") || name.contains("cắt tỉa") || name.contains("cạo lông") 
                || name.contains("vệ sinh") || name.contains("gỡ rối")) {
            // Chuyên viên Nhân viên chăm sóc (Role 4 hoặc Role 8 cũ)
            return roleId == 4 || roleId == 8 
                    || roleName.equalsIgnoreCase("Nhân viên chăm sóc") 
                    || roleName.equalsIgnoreCase("Chăm sóc thú cưng") 
                    || chuyenMon.contains("grooming") || chuyenMon.contains("spa");
        }

        // 3. Nhóm Khách sạn thú cưng / Trông giữ Lưu trú
        if (nhom.contains("khách sạn") || nhom.contains("lưu trú") || name.contains("khách sạn") || name.contains("bán trú") || name.contains("trông giữ")) {
            // Nhân viên chăm sóc (Role 4 hoặc Role 8)
            return roleId == 4 || roleId == 8
                    || roleName.equalsIgnoreCase("Nhân viên chăm sóc")
                    || roleName.equalsIgnoreCase("Chăm sóc thú cưng");
        }

        // Mặc định các dịch vụ khác: Nhân viên chăm sóc hoặc Bác sĩ
        return roleId == 4 || roleId == 3 
                || roleName.equalsIgnoreCase("Nhân viên chăm sóc")
                || roleName.equalsIgnoreCase("Bác sĩ thú y");
    }

    private boolean isMedicalService(DichVuChamSoc s) {
        if (s == null) return false;
        String group = s.getNhomDichVu() != null ? s.getNhomDichVu().trim().toLowerCase() : "";
        if (group.contains("thú y") || group.contains("khám") || group.contains("chữa")) {
            return true;
        }
        String name = s.getTenDichVu() != null ? s.getTenDichVu().trim().toLowerCase() : "";
        return name.contains("khám") || name.contains("tiêm") || name.contains("vắc xin") || name.contains("thuốc")
                || name.contains("triệt sản") || name.contains("xét nghiệm") || name.contains("phẫu thuật")
                || name.contains("điều trị");
    }

    public List<Map<String, Object>> getOptimizedStaffList(LocalDateTime start, LocalDateTime end, Integer excludeTicketId) {
        if (start == null) start = LocalDateTime.now();
        if (end == null) end = start.plusHours(1);

        LocalDate today = start.toLocalDate();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(23, 59, 59);

        List<Employee> allEmployees = employeeRepository.findAll();
        List<Map<String, Object>> result = new ArrayList<>();

        for (Employee emp : allEmployees) {
            // Chỉ lấy nhân sự thuộc chuyên môn dịch vụ thú y & chăm sóc thú cưng đang làm việc
            if (!isCareServiceStaff(emp)) {
                continue;
            }

            int roleId = emp.getVaiTro() != null ? emp.getVaiTro() : 0;
            String roleName = (emp.getRole() != null) ? emp.getRole().getTenVaiTro() : "";
            boolean isDoctor = roleId == 3 || "Bác sĩ thú y".equalsIgnoreCase(roleName) || "Bác sĩ".equalsIgnoreCase(roleName);
            boolean isCareStaff = roleId == 4 || roleId == 8 || "Nhân viên chăm sóc".equalsIgnoreCase(roleName) || "Chăm sóc thú cưng".equalsIgnoreCase(roleName);

            Map<String, Object> item = new HashMap<>();
            item.put("maNV", emp.getMaNV());
            item.put("tenNV", emp.getTenNV());
            item.put("roleId", roleId);
            item.put("roleName", roleName);
            item.put("chuyenMon", emp.getChuyenMon() != null ? emp.getChuyenMon() : roleName);
            item.put("isDoctor", isDoctor);
            item.put("isMedical", isDoctor);
            item.put("canDoDoctorOnly", isDoctor);
            item.put("canDoMedical", isDoctor);
            item.put("canDoSpa", isCareStaff);
            item.put("canDoHotel", isCareStaff);

            String conflict = checkScheduleConflict(emp.getMaNV(), start, end, excludeTicketId);
            boolean isAvailable = (conflict == null);
            item.put("available", isAvailable);
            item.put("conflictMsg", conflict);

            long careCount = phieuRepository.findByMaNVThucHienOrderByNgayTiepNhanDesc(emp.getMaNV())
                    .stream()
                    .filter(p -> p.getNgayTiepNhan() != null && !p.getNgayTiepNhan().isBefore(startOfDay) && !p.getNgayTiepNhan().isAfter(endOfDay))
                    .count();
            long bookingCount = bookingRepository.findByMaNVOrderByNgayTaoDesc(emp.getMaNV())
                    .stream()
                    .filter(b -> b.getNgayDat() != null && b.getNgayDat().isEqual(today))
                    .count();
            int tasksToday = (int) (careCount + bookingCount);
            item.put("tasksToday", tasksToday);

            // Điểm sắp xếp: Khả dụng (ưu tiên 0) + số ca hôm nay; Bận (ưu tiên 1000) + số ca
            item.put("sortScore", (isAvailable ? 0 : 1000) + tasksToday);

            String roleBadge = isDoctor ? "[Bác sĩ thú y] " : "[Nhân viên chăm sóc] ";

            String roleInfo = (emp.getChuyenMon() != null && !emp.getChuyenMon().trim().isEmpty()) 
                    ? " (" + emp.getChuyenMon().trim() + ")" 
                    : (!roleName.isEmpty() ? " (" + roleName + ")" : "");
            String label;
            if (isAvailable) {
                if (tasksToday == 0) {
                    label = roleBadge + emp.getTenNV() + roleInfo + " — Rảnh (0 ca)";
                } else {
                    label = roleBadge + emp.getTenNV() + roleInfo + " — Khả dụng (" + tasksToday + " ca hôm nay)";
                }
            } else {
                label = roleBadge + emp.getTenNV() + roleInfo + " — Đang bận / Trùng lịch";
            }
            item.put("displayText", label);

            result.add(item);
        }

        // Sắp xếp danh sách nhân viên theo thứ tự tối ưu
        result.sort(Comparator.comparingInt(m -> (Integer) m.get("sortScore")));
        return result;
    }

    private void populateFormModel(Model model, PhieuDichVuChamSoc ticket) {
        model.addAttribute("ticket", ticket);
        model.addAttribute("pets", hoSoThuCungRepository.findAll());
        model.addAttribute("owners", chuNuoiRepository.findAll());
        model.addAttribute("services", dichVuChamSocRepository.findAll());

        LocalDateTime start = (ticket != null && ticket.getNgayTiepNhan() != null) ? ticket.getNgayTiepNhan() : LocalDateTime.now();
        LocalDateTime end = (ticket != null && ticket.getNgayHenTra() != null) ? ticket.getNgayHenTra() : start.plusHours(1);
        Integer excludeId = (ticket != null) ? ticket.getMaPhieuDV() : null;
        model.addAttribute("employees", getOptimizedStaffList(start, end, excludeId));

        // Danh sách nhân sự phụ trách tiếp nhận khách tại quầy (Tư vấn viên, CSKH, Bán hàng, Quản lý)
        List<Employee> receptionStaff = employeeRepository.findAll().stream()
                .filter(AdminPhieuDichVuController::isReceptionStaff)
                .toList();
        model.addAttribute("receptionStaff", receptionStaff);
    }

    public String checkScheduleConflict(Integer maNV, LocalDateTime start, LocalDateTime end, Integer excludeTicketId) {
        if (maNV == null || end == null) return null;
        if (start == null) start = LocalDateTime.now();

        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
        String empName = employeeRepository.findById(maNV).map(Employee::getTenNV).orElse("nhân viên");

        // 1. Kiểm tra trùng lặp trong phiếu chăm sóc
        List<PhieuDichVuChamSoc> activeTickets = phieuRepository.findByMaNVThucHienAndTrangThaiDichVuIn(
                maNV, List.of("Chờ tiếp nhận", "Đang thực hiện")
        );
        for (PhieuDichVuChamSoc p : activeTickets) {
            if (excludeTicketId != null && p.getMaPhieuDV().equals(excludeTicketId)) continue;
            LocalDateTime pStart = p.getNgayTiepNhan() != null ? p.getNgayTiepNhan() : LocalDateTime.now();
            LocalDateTime pEnd = p.getNgayHenTra() != null ? p.getNgayHenTra() : pStart.plusHours(1);

            // Kiểm tra trùng lặp thời gian: [start, end] giao [pStart, pEnd]
            if (!start.isAfter(pEnd) && !end.isBefore(pStart)) {
                return "Trùng lịch làm việc: Nhân viên " + empName + " đang có lịch thực hiện phiếu chăm sóc " 
                        + p.getSoPhieu() + " (dự kiến đến " + pEnd.format(fmt) + "). Vui lòng chọn nhân sự hoặc thời gian khác.";
            }
        }

        // 2. Kiểm tra trùng lặp trong lịch hẹn đặt trước (tblDatLich)
        List<Booking> staffBookings = bookingRepository.findByMaNVOrderByNgayTaoDesc(maNV);
        for (Booking b : staffBookings) {
            String status = b.getTrangThai();
            if (status != null && (status.equalsIgnoreCase("Đã hủy") || status.equalsIgnoreCase("Hủy") || status.equalsIgnoreCase("Hoàn thành"))) {
                continue;
            }
            if (b.getNgayDat() != null && b.getGioDat() != null) {
                LocalDateTime bStart = LocalDateTime.of(b.getNgayDat(), b.getGioDat());
                LocalDateTime bEnd = bStart.plusHours(1);

                if (!start.isAfter(bEnd) && !end.isBefore(bStart)) {
                    return "Trùng lịch làm việc: Nhân viên " + empName + " đã có lịch hẹn chăm sóc #" 
                            + b.getMaDatLich() + " vào lúc " + bStart.format(fmt) + ". Vui lòng chọn nhân sự hoặc thời gian khác.";
                }
            }
        }

        return null;
    }

    // Endpoint kiểm tra trùng lịch và thời gian nhanh (AJAX)
    @GetMapping("/check-conflict")
    @ResponseBody
    public Map<String, Object> checkConflict(@RequestParam(value = "maNV", required = false) Integer maNV,
                                            @RequestParam(value = "ngayHenTra", required = false) String ngayHenTraStr,
                                            @RequestParam(value = "maThuCung", required = false) Integer maThuCung,
                                            @RequestParam(value = "hasMedicalService", required = false, defaultValue = "false") Boolean hasMedicalService) {
        Map<String, Object> res = new HashMap<>();
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime ngayHenTra = null;
        if (ngayHenTraStr != null && !ngayHenTraStr.trim().isEmpty()) {
            try {
                ngayHenTra = LocalDateTime.parse(ngayHenTraStr);
            } catch (Exception ignored) {}
        }

        if (ngayHenTra != null && ngayHenTra.isBefore(now)) {
            res.put("hasError", true);
            res.put("errorType", "PAST_DATE");
            res.put("message", "Ngày giờ không hợp lệ: Không thể chọn thời gian trước thời điểm hiện tại.");
            return res;
        }

        // Kiểm tra thẩm quyền y tế nếu dịch vụ có khám chữa bệnh / tiêm phòng / kê thuốc
        if (Boolean.TRUE.equals(hasMedicalService) && maNV != null) {
            Employee emp = employeeRepository.findById(maNV).orElse(null);
            if (emp != null) {
                String roleName = (emp.getRole() != null) ? emp.getRole().getTenVaiTro() : "";
                boolean isDoctor = "Bác sĩ thú y".equalsIgnoreCase(roleName) || "Bác sĩ".equalsIgnoreCase(roleName);
                if (!isDoctor) {
                    res.put("hasError", true);
                    res.put("errorType", "MEDICAL_ROLE_RESTRICTION");
                    res.put("message", "Quy định chuyên môn: Dịch vụ khám chữa bệnh / tiêm phòng / kê thuốc bắt buộc phải do Bác sĩ thú y thực hiện. Nhân sự '" 
                            + emp.getTenNV() + "' (" + (roleName.isEmpty() ? "Nhân viên" : roleName) + ") không có thẩm quyền y tế này!");
                    return res;
                }
            }
        }

        if (maNV != null && ngayHenTra != null) {
            String conflictMsg = checkScheduleConflict(maNV, now, ngayHenTra, null);
            if (conflictMsg != null) {
                res.put("hasError", true);
                res.put("errorType", "SCHEDULE_CONFLICT");
                res.put("message", conflictMsg);
                return res;
            }
        }

        if (maThuCung != null) {
            List<PhieuDichVuChamSoc> activePetTickets = phieuRepository.findByMaThuCungAndTrangThaiDichVuIn(
                    maThuCung, List.of("Chờ tiếp nhận", "Đang thực hiện")
            );
            if (!activePetTickets.isEmpty()) {
                res.put("hasError", true);
                res.put("errorType", "PET_BUSY");
                res.put("message", "Thú cưng này đang có phiếu dịch vụ đang thực hiện (" + activePetTickets.get(0).getSoPhieu() + ").");
                return res;
            }
        }

        res.put("hasError", false);
        return res;
    }

    // Endpoint lấy danh sách nhân viên đã được sắp xếp theo thứ tự tối ưu (Smart Scheduling)
    @GetMapping("/optimized-staff-list")
    @ResponseBody
    public List<Map<String, Object>> getOptimizedStaffListApi(
            @RequestParam(value = "ngayHenTra", required = false) String ngayHenTraStr,
            @RequestParam(value = "excludeTicketId", required = false) Integer excludeTicketId) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime ngayHenTra = null;
        if (ngayHenTraStr != null && !ngayHenTraStr.trim().isEmpty()) {
            try {
                ngayHenTra = LocalDateTime.parse(ngayHenTraStr);
            } catch (Exception ignored) {}
        }
        if (ngayHenTra == null) {
            ngayHenTra = now.plusHours(1);
        }
        return getOptimizedStaffList(now, ngayHenTra, excludeTicketId);
    }

    // Endpoint gợi ý nhân sự tự động thông minh (Smart Scheduling)
    @GetMapping("/suggest-staff")
    @ResponseBody
    public Map<String, Object> suggestStaff(@RequestParam(value = "ngayHenTra", required = false) String ngayHenTraStr,
                                            @RequestParam(value = "chuyenMon", required = false) String chuyenMon) {
        Map<String, Object> res = new HashMap<>();
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime ngayHenTra = null;
        if (ngayHenTraStr != null && !ngayHenTraStr.trim().isEmpty()) {
            try {
                ngayHenTra = LocalDateTime.parse(ngayHenTraStr);
            } catch (Exception ignored) {}
        }
        if (ngayHenTra == null) {
            ngayHenTra = now.plusHours(1);
        }

        List<Employee> allEmployees = employeeRepository.findAll().stream()
                .filter(AdminPhieuDichVuController::isCareServiceStaff)
                .toList();
        List<Employee> eligible = allEmployees.stream().filter(emp -> {
            if (chuyenMon != null && !chuyenMon.trim().isEmpty()) {
                String cm = emp.getChuyenMon() != null ? emp.getChuyenMon().toLowerCase() : "";
                return cm.contains(chuyenMon.toLowerCase());
            }
            return true;
        }).toList();

        if (eligible.isEmpty()) {
            eligible = allEmployees;
        }

        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(23, 59, 59);

        Employee bestCandidate = null;
        int minTasks = Integer.MAX_VALUE;
        String reason = "";

        for (Employee emp : eligible) {
            String conflict = checkScheduleConflict(emp.getMaNV(), now, ngayHenTra, null);
            if (conflict != null) {
                continue;
            }

            long careCount = phieuRepository.findByMaNVThucHienOrderByNgayTiepNhanDesc(emp.getMaNV())
                    .stream()
                    .filter(p -> p.getNgayTiepNhan() != null && !p.getNgayTiepNhan().isBefore(startOfDay) && !p.getNgayTiepNhan().isAfter(endOfDay))
                    .count();
            long bookingCount = bookingRepository.findByMaNVOrderByNgayTaoDesc(emp.getMaNV())
                    .stream()
                    .filter(b -> b.getNgayDat() != null && b.getNgayDat().isEqual(today))
                    .count();

            int totalTasksToday = (int) (careCount + bookingCount);
            if (totalTasksToday < minTasks) {
                minTasks = totalTasksToday;
                bestCandidate = emp;
                reason = "Khả dụng trong khung giờ và hiện có số ca ít nhất trong ngày (" + totalTasksToday + " ca).";
            }
        }

        if (bestCandidate != null) {
            res.put("success", true);
            res.put("maNV", bestCandidate.getMaNV());
            res.put("tenNV", bestCandidate.getTenNV());
            res.put("chuyenMon", bestCandidate.getChuyenMon());
            res.put("tasksToday", minTasks);
            res.put("reason", reason);
        } else {
            res.put("success", false);
            res.put("message", "Tất cả nhân sự phù hợp đều đang bận trong khung giờ này. Vui lòng chọn thời gian khác!");
        }
        return res;
    }

    // Endpoint tạo nhanh Chủ nuôi & Thú cưng trực tiếp từ modal tiếp nhận
    @PostMapping("/api/quick-create-pet")
    @ResponseBody
    public Map<String, Object> quickCreatePet(@RequestBody Map<String, String> payload) {
        Map<String, Object> res = new HashMap<>();
        try {
            String hoTenChu = payload.get("hoTenChuNuoi");
            String sdt = payload.get("soDienThoai");
            String diaChi = payload.get("diaChi");
            String tenPet = payload.get("tenThuCung");
            String loaiPet = payload.get("loaiThuCung");
            String giongLoai = payload.get("giongLoai");
            String gioiTinh = payload.get("gioiTinh");
            String canNangStr = payload.get("canNang");

            if (hoTenChu == null || hoTenChu.trim().isEmpty() || sdt == null || sdt.trim().isEmpty() 
                    || tenPet == null || tenPet.trim().isEmpty()) {
                res.put("success", false);
                res.put("message", "Vui lòng nhập đầy đủ tên chủ nuôi, số điện thoại và tên thú cưng.");
                return res;
            }

            // Tìm hoặc tạo mới ChuNuoi
            ChuNuoi owner = chuNuoiRepository.findAll().stream()
                    .filter(c -> c.getSoDienThoai() != null && c.getSoDienThoai().trim().equals(sdt.trim()))
                    .findFirst()
                    .orElse(null);

            if (owner == null) {
                owner = new ChuNuoi();
                owner.setHoTenChuNuoi(hoTenChu.trim());
                owner.setSoDienThoai(sdt.trim());
                owner.setDiaChi(diaChi != null ? diaChi.trim() : "");
                owner.setLoaiChuNuoi("Tiêu chuẩn");
                owner.setDiemTichLuy(0);
                owner.setNgayDangKy(LocalDateTime.now());

                // Tự động liên kết hoặc tạo Khách hàng trong tblKhachHang
                var custOpt = customerRepository.findFirstByDienThoaiOrEmail(sdt.trim(), null);
                if (custOpt.isPresent()) {
                    owner.setMaKH(custOpt.get().getMaKH());
                } else {
                    Customer newCust = new Customer();
                    newCust.setTenKH(hoTenChu.trim());
                    newCust.setDienThoai(sdt.trim());
                    newCust.setDiaChi(diaChi != null ? diaChi.trim() : "");
                    newCust.setMatKhau("123456");
                    newCust.setHangThanhVien("Tiêu chuẩn");
                    newCust.setDiemTichLuy(0);
                    newCust.setIsLocked(false);
                    newCust = customerRepository.save(newCust);
                    owner.setMaKH(newCust.getMaKH());
                }
                owner = chuNuoiRepository.save(owner);
            }

            // Tạo mới HoSoThuCung
            HoSoThuCung pet = new HoSoThuCung();
            pet.setMaChuNuoi(owner.getMaChuNuoi());
            pet.setTenThuCung(tenPet.trim());
            pet.setLoaiThuCung(loaiPet != null && !loaiPet.trim().isEmpty() ? loaiPet.trim() : "Chó");
            pet.setGiongLoai(giongLoai != null && !giongLoai.trim().isEmpty() ? giongLoai.trim() : "Chưa rõ giống");
            pet.setGioiTinh(gioiTinh != null && !gioiTinh.trim().isEmpty() ? gioiTinh.trim() : "Đực");
            pet.setHinhAnh("default-pet.jpg");
            if (canNangStr != null && !canNangStr.trim().isEmpty()) {
                try {
                    pet.setCanNang(new BigDecimal(canNangStr.trim()));
                } catch (Exception ignored) {}
            }
            pet = hoSoThuCungRepository.save(pet);

            Map<String, Object> petData = new HashMap<>();
            petData.put("id", pet.getMaThuCung());
            petData.put("petName", pet.getTenThuCung());
            petData.put("petType", pet.getLoaiThuCung());
            petData.put("breed", pet.getGiongLoai());
            petData.put("gender", pet.getGioiTinh());
            petData.put("weight", pet.getCanNang());
            petData.put("ownerId", owner.getMaChuNuoi());
            petData.put("ownerName", owner.getHoTenChuNuoi());
            petData.put("ownerPhone", owner.getSoDienThoai());
            petData.put("ownerTier", owner.getLoaiChuNuoi());

            res.put("success", true);
            res.put("message", "Đã khởi tạo thành công hồ sơ bé '" + pet.getTenThuCung() + "' cho chủ " + owner.getHoTenChuNuoi() + "!");
            res.put("pet", petData);
        } catch (Exception ex) {
            res.put("success", false);
            res.put("message", "Lỗi tạo hồ sơ nhanh: " + ex.getMessage());
        }
        return res;
    }

    // 1. Danh sách phiếu chăm sóc
    @GetMapping
    public String listTickets(@RequestParam(value = "status", required = false) String status,
                              @RequestParam(value = "keyword", required = false) String keyword,
                              Model model, HttpSession session) {
        if (!authService.canManageCareTickets(session)) return authService.redirectUnauthorized(session);

        List<PhieuDichVuChamSoc> tickets;
        String trimmedKeyword = (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : null;
        String targetStatus = (status != null && !status.trim().isEmpty() && !status.equals("All")) ? status.trim() : null;

        if (trimmedKeyword != null || targetStatus != null) {
            tickets = phieuRepository.searchTickets(targetStatus, trimmedKeyword);
        } else {
            tickets = phieuRepository.findByOrderByNgayTiepNhanDesc();
        }

        model.addAttribute("tickets", tickets);
        model.addAttribute("currentStatus", status);
        model.addAttribute("keyword", trimmedKeyword != null ? trimmedKeyword : "");
        return "admin/care-tickets";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model, HttpSession session) {
        if (!authService.canManageCareTickets(session)) return authService.redirectUnauthorized(session);

        PhieuDichVuChamSoc ticket = new PhieuDichVuChamSoc();
        String datePart = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String randPart = String.format("%04d", new Random().nextInt(10000));
        ticket.setSoPhieu("PDV-" + datePart + "-" + randPart);

        Integer currentMaNV = (Integer) session.getAttribute("maNV");
        if (currentMaNV != null) {
            ticket.setMaNVTiepNhan(currentMaNV);
        }

        populateFormModel(model, ticket);
        return "admin/care-ticket-form";
    }

    @PostMapping("/create")
    public String createTicket(@ModelAttribute("ticket") PhieuDichVuChamSoc ticket,
                               @RequestParam(value = "selectedServiceIds", required = false) List<Integer> selectedServiceIds,
                               @RequestParam(value = "serviceStaffIds", required = false) List<Integer> serviceStaffIds,
                               @RequestParam(value = "selectedServiceId", required = false) Integer selectedServiceId,
                               @RequestParam(value = "voucherCode", required = false) String voucherCode,
                               @RequestParam(value = "doDacGuiKem", required = false) List<String> doDacGuiKem,
                               @RequestParam(value = "thanNhiet", required = false) String thanNhiet,
                               @RequestParam(value = "tienDatCoc", required = false) BigDecimal tienDatCoc,
                               Model model,
                               HttpSession session) {
        if (!authService.canManageCareTickets(session)) return authService.redirectUnauthorized(session);

        LocalDateTime now = LocalDateTime.now();

        // 1. Kiểm tra ngày giờ không được trước hiện tại
        if (ticket.getNgayHenTra() != null && ticket.getNgayHenTra().isBefore(now)) {
            model.addAttribute("errorMessage", "Ngày giờ không hợp lệ: Không thể chọn thời gian trước thời điểm hiện tại.");
            populateFormModel(model, ticket);
            return "admin/care-ticket-form";
        }

        // 2. Kiểm tra trùng lịch làm việc của nhân viên tiếp nhận/phụ trách chính
        if (ticket.getMaNVThucHien() != null && ticket.getNgayHenTra() != null) {
            LocalDateTime start = ticket.getNgayTiepNhan() != null ? ticket.getNgayTiepNhan() : now;
            String conflictMsg = checkScheduleConflict(ticket.getMaNVThucHien(), start, ticket.getNgayHenTra(), null);
            if (conflictMsg != null) {
                model.addAttribute("errorMessage", conflictMsg);
                populateFormModel(model, ticket);
                return "admin/care-ticket-form";
            }
        }

        // 3. Kiểm tra nếu thú cưng đang có phiếu chăm sóc khác chưa hoàn tất
        if (ticket.getMaThuCung() != null) {
            List<PhieuDichVuChamSoc> activePetTickets = phieuRepository.findByMaThuCungAndTrangThaiDichVuIn(
                    ticket.getMaThuCung(), List.of("Chờ tiếp nhận", "Đang thực hiện")
            );
            if (!activePetTickets.isEmpty()) {
                model.addAttribute("errorMessage", "Thú cưng này đang có phiếu chăm sóc chưa hoàn tất (Phiếu: " 
                        + activePetTickets.get(0).getSoPhieu() + "). Vui lòng bàn giao hoặc hủy phiếu trước đó.");
                populateFormModel(model, ticket);
                return "admin/care-ticket-form";
            }
        }

        if (ticket.getNgayTiepNhan() == null) {
            ticket.setNgayTiepNhan(now);
        }

        if (ticket.getMaThuCung() != null && ticket.getMaChuNuoi() == null) {
            HoSoThuCung pet = hoSoThuCungRepository.findById(ticket.getMaThuCung()).orElse(null);
            if (pet != null) {
                ticket.setMaChuNuoi(pet.getMaChuNuoi());
            }
        }

        // Lấy danh sách dịch vụ được chọn
        List<DichVuChamSoc> chosenServices = new ArrayList<>();
        if (selectedServiceIds != null && !selectedServiceIds.isEmpty()) {
            chosenServices = dichVuChamSocRepository.findAllById(selectedServiceIds);
        } else if (selectedServiceId != null) {
            dichVuChamSocRepository.findById(selectedServiceId).ifPresent(chosenServices::add);
        }

        BigDecimal sumPrice = BigDecimal.ZERO;
        StringBuilder sb = new StringBuilder();

        // Kiểm tra từng dịch vụ và phân công nhân sự tương ứng
        for (int i = 0; i < chosenServices.size(); i++) {
            DichVuChamSoc s = chosenServices.get(i);
            if (s.getGiaDichVu() != null) {
                sumPrice = sumPrice.add(s.getGiaDichVu());
            }

            Integer assignedStaffId = (serviceStaffIds != null && serviceStaffIds.size() > i) 
                    ? serviceStaffIds.get(i) 
                    : ticket.getMaNVThucHien();

            Employee assignedEmp = (assignedStaffId != null) ? employeeRepository.findById(assignedStaffId).orElse(null) : null;
            String assignedEmpTitle = (assignedEmp != null) ? assignedEmp.getTenNV() : "Chưa phân công";

            // Ràng buộc quy định chuyên môn từ CSDL: mỗi dịch vụ chỉ có role tương ứng mới có thể phân công
            if (assignedEmp == null) {
                model.addAttribute("errorMessage", "Vui lòng phân công nhân sự phụ trách cho dịch vụ '" + s.getTenDichVu() + "'.");
                populateFormModel(model, ticket);
                return "admin/care-ticket-form";
            }

            if (!isEligibleForService(assignedEmp, s)) {
                String roleName = assignedEmp.getRole() != null ? assignedEmp.getRole().getTenVaiTro() : "Nhân viên";
                model.addAttribute("errorMessage", "Quy định chuyên môn: Dịch vụ '" + s.getTenDichVu() 
                        + "' không thuộc phạm vi vai trò '" + roleName + "' của nhân sự '" 
                        + assignedEmp.getTenNV() + "'. Vui lòng phân công đúng nhân sự phụ trách!");
                populateFormModel(model, ticket);
                return "admin/care-ticket-form";
            }

            String roleName = assignedEmp.getRole() != null ? assignedEmp.getRole().getTenVaiTro() : "";
            assignedEmpTitle = "[" + roleName + "] " + assignedEmp.getTenNV();

            if (sb.length() > 0) sb.append(", ");
            sb.append(s.getTenDichVu()).append(" (").append(assignedEmpTitle).append(")");
        }

        if (ticket.getTongTien() == null || ticket.getTongTien().compareTo(BigDecimal.ZERO) == 0) {
            ticket.setTongTien(sumPrice);
        }
        String oldReq = ticket.getYeuCauCuaChuNuoi();
        String prefix = "Dịch vụ: " + sb.toString();
        if (oldReq == null || oldReq.trim().isEmpty()) {
            ticket.setYeuCauCuaChuNuoi(prefix);
        } else if (!oldReq.contains(prefix)) {
            ticket.setYeuCauCuaChuNuoi(prefix + " | " + oldReq);
        }

        // Tự động gán nhân sự chính của phiếu nếu chưa có
        if (ticket.getMaNVThucHien() == null && serviceStaffIds != null && !serviceStaffIds.isEmpty() && serviceStaffIds.get(0) != null) {
            ticket.setMaNVThucHien(serviceStaffIds.get(0));
        }

        // Tự động tính giảm giá theo hạng thành viên nếu chưa có giảm giá
        if (ticket.getTongTien() != null && ticket.getTongTien().compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal giam = ticket.getTienGiamGia() != null ? ticket.getTienGiamGia() : BigDecimal.ZERO;
            if (giam.compareTo(BigDecimal.ZERO) == 0 && ticket.getMaChuNuoi() != null) {
                ChuNuoi owner = chuNuoiRepository.findById(ticket.getMaChuNuoi()).orElse(null);
                if (owner != null) {
                    giam = membershipService.calculateTierDiscount(ticket.getTongTien(), owner.getLoaiChuNuoi());
                    ticket.setTienGiamGia(giam);
                }
            }
        }

        // Xử lý áp dụng voucher nếu có
        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            Optional<Voucher> vOpt = voucherService.getVoucherByCode(voucherCode.trim().toUpperCase());
            if (vOpt.isPresent()) {
                Voucher v = vOpt.get();
                if (v.getSoLuong() != null && v.getSoLuong() > 0) {
                    v.setSoLuong(v.getSoLuong() - 1);
                    voucherService.saveVoucher(v);
                }
                String note = ticket.getGhiChu();
                String vNote = "Voucher: " + v.getMaGiamGia();
                ticket.setGhiChu(note != null && !note.isEmpty() ? note + " | " + vNote : vNote);
            }
        }

        // Ghi nhận thân nhiệt (nếu có)
        if (thanNhiet != null && !thanNhiet.trim().isEmpty()) {
            String tnStr = "Thân nhiệt: " + thanNhiet.trim() + "°C";
            String curInit = ticket.getTinhTrangBanDau();
            ticket.setTinhTrangBanDau(curInit != null && !curInit.trim().isEmpty() ? tnStr + " | " + curInit : tnStr);
        }

        // Ghi nhận đồ đạc phụ kiện gửi kèm
        if (doDacGuiKem != null && !doDacGuiKem.isEmpty()) {
            String doDacStr = "Đồ gửi kèm: " + String.join(", ", doDacGuiKem);
            String note = ticket.getGhiChu();
            ticket.setGhiChu(note != null && !note.isEmpty() ? note + " | " + doDacStr : doDacStr);
        }

        // Tiền đặt cọc (nếu có)
        if (tienDatCoc != null && tienDatCoc.compareTo(BigDecimal.ZERO) > 0) {
            ticket.setTrangThaiThanhToan("Đã đặt cọc");
            String cocStr = String.format("Đã cọc: %,.0fVND", tienDatCoc);
            String note = ticket.getGhiChu();
            ticket.setGhiChu(note != null && !note.isEmpty() ? note + " | " + cocStr : cocStr);
        } else {
            if (ticket.getTrangThaiThanhToan() == null || ticket.getTrangThaiThanhToan().isEmpty()) {
                ticket.setTrangThaiThanhToan("Chưa thanh toán");
            }
        }

        if (ticket.getTongTien() == null) ticket.setTongTien(BigDecimal.ZERO);
        if (ticket.getTienGiamGia() == null) ticket.setTienGiamGia(BigDecimal.ZERO);
        if (ticket.getThanhToan() == null) ticket.setThanhToan(ticket.getTongTien().subtract(ticket.getTienGiamGia()));
        if (ticket.getThanhToan().compareTo(BigDecimal.ZERO) < 0) ticket.setThanhToan(BigDecimal.ZERO);

        PhieuDichVuChamSoc savedTicket = phieuRepository.save(ticket);

        // Lưu chi tiết dịch vụ chăm sóc vào tblChiTietDichVuChamSoc cho từng mục
        for (int i = 0; i < chosenServices.size(); i++) {
            DichVuChamSoc s = chosenServices.get(i);
            Integer assignedStaffId = (serviceStaffIds != null && serviceStaffIds.size() > i) 
                    ? serviceStaffIds.get(i) 
                    : savedTicket.getMaNVThucHien();

            Employee assignedEmp = (assignedStaffId != null) ? employeeRepository.findById(assignedStaffId).orElse(null) : null;
            String staffDisplay = "Chưa phân công";
            if (assignedEmp != null) {
                String role = assignedEmp.getRole() != null ? assignedEmp.getRole().getTenVaiTro() : "";
                if ("Bác sĩ thú y".equalsIgnoreCase(role) || "Bác sĩ".equalsIgnoreCase(role)) {
                    staffDisplay = "BS. " + assignedEmp.getTenNV();
                } else if ("Kỹ thuật viên thú y".equalsIgnoreCase(role)) {
                    staffDisplay = "KTV. " + assignedEmp.getTenNV();
                } else {
                    staffDisplay = assignedEmp.getTenNV();
                }
            }

            ChiTietDichVuChamSoc ct = new ChiTietDichVuChamSoc();
            ct.setMaPhieuDV(savedTicket.getMaPhieuDV());
            ct.setMaDVCS(s.getMaDVCS());
            ct.setSoLuong(1);
            ct.setDonGia(s.getGiaDichVu() != null ? s.getGiaDichVu() : BigDecimal.ZERO);
            ct.setPhuPhi(BigDecimal.ZERO);
            ct.setThanhTien(s.getGiaDichVu() != null ? s.getGiaDichVu() : BigDecimal.ZERO);
            ct.setNhanVienPhuTrach(staffDisplay);
            ct.setGhiChuChiTiet(s.getTenDichVu());
            chiTietDichVuChamSocRepository.save(ct);
        }

        // Cập nhật lại cân nặng mới nhất vào hồ sơ thú cưng tblHoSoThuCung
        if (savedTicket.getMaThuCung() != null && savedTicket.getCanNangTiepNhan() != null) {
            hoSoThuCungRepository.findById(savedTicket.getMaThuCung()).ifPresent(p -> {
                p.setCanNang(savedTicket.getCanNangTiepNhan());
                hoSoThuCungRepository.save(p);
            });
        }

        return "redirect:/admin/care-tickets";
    }

    // 3.1. Endpoint kiểm tra voucher nhanh cho form tiếp nhận
    @PostMapping("/check-voucher")
    @ResponseBody
    public Map<String, Object> checkVoucher(@RequestParam("code") String code,
                                            @RequestParam(value = "amount", defaultValue = "0") BigDecimal amount) {
        Map<String, Object> res = new HashMap<>();
        if (code == null || code.trim().isEmpty()) {
            res.put("valid", false);
            res.put("message", "Vui lòng nhập mã voucher.");
            return res;
        }
        Optional<Voucher> opt = voucherService.getVoucherByCode(code.trim().toUpperCase());
        if (opt.isEmpty()) {
            res.put("valid", false);
            res.put("message", "Mã voucher không tồn tại.");
            return res;
        }
        Voucher v = opt.get();
        LocalDate now = LocalDate.now();
        if (v.getSoLuong() != null && v.getSoLuong() <= 0) {
            res.put("valid", false);
            res.put("message", "Mã voucher đã hết lượt sử dụng.");
            return res;
        }
        if (v.getNgayBatDau() != null && now.isBefore(v.getNgayBatDau())) {
            res.put("valid", false);
            res.put("message", "Mã voucher chưa đến thời gian áp dụng.");
            return res;
        }
        if (v.getNgayKetThuc() != null && now.isAfter(v.getNgayKetThuc())) {
            res.put("valid", false);
            res.put("message", "Mã voucher đã hết hạn sử dụng.");
            return res;
        }

        BigDecimal discount = BigDecimal.ZERO;
        if (v.getPhanTramGiam() != null && amount.compareTo(BigDecimal.ZERO) > 0) {
            discount = amount.multiply(v.getPhanTramGiam()).divide(BigDecimal.valueOf(100), 0, RoundingMode.HALF_UP);
            if (v.getSoTienGiamToiDa() != null && discount.compareTo(v.getSoTienGiamToiDa()) > 0) {
                discount = v.getSoTienGiamToiDa();
            }
        }

        res.put("valid", true);
        res.put("code", v.getMaGiamGia());
        res.put("discount", discount);
        res.put("percent", v.getPhanTramGiam());
        res.put("maxDiscount", v.getSoTienGiamToiDa());
        res.put("message", "Áp dụng voucher " + v.getMaGiamGia() + " thành công (-" + (v.getPhanTramGiam() != null ? v.getPhanTramGiam() : 0) + "%)");
        return res;
    }

    // 4. Xem chi tiết phiếu & cập nhật trạng thái
    @GetMapping("/detail/{id}")
    public String viewDetail(@PathVariable("id") Integer id, Model model, HttpSession session) {
        if (!authService.canManageCareTickets(session)) return authService.redirectUnauthorized(session);
        PhieuDichVuChamSoc ticket = phieuRepository.findById(id).orElse(null);
        if (ticket == null) return "redirect:/admin/care-tickets";

        model.addAttribute("ticket", ticket);
        List<Employee> careStaff = employeeRepository.findAll().stream()
                .filter(AdminPhieuDichVuController::isCareServiceStaff)
                .toList();
        model.addAttribute("employees", careStaff);

        List<ChiTietDichVuChamSoc> serviceDetails = chiTietDichVuChamSocRepository.findByMaPhieuDV(id);
        model.addAttribute("serviceDetails", serviceDetails);

        int pointsEarned = membershipService.calculatePoints(ticket.getThanhToan());
        model.addAttribute("pointsEarned", pointsEarned);
        return "admin/care-ticket-detail";
    }

    @PostMapping("/update-status/{id}")
    public String updateStatus(@PathVariable("id") Integer id,
                               @RequestParam("trangThaiDichVu") String trangThaiDichVu,
                               @RequestParam("trangThaiThanhToan") String trangThaiThanhToan,
                               @RequestParam(value = "hinhThucThanhToan", required = false) String hinhThucThanhToan,
                               @RequestParam(value = "ketQuaChamSoc", required = false) String ketQuaChamSoc,
                               @RequestParam(value = "voucherCode", required = false) String voucherCode,
                               HttpSession session) {
        if (!authService.canManageCareTickets(session)) return authService.redirectUnauthorized(session);

        PhieuDichVuChamSoc ticket = phieuRepository.findById(id).orElse(null);
        if (ticket != null) {
            String oldStatus = ticket.getTrangThaiDichVu();
            ticket.setTrangThaiDichVu(trangThaiDichVu);
            ticket.setTrangThaiThanhToan(trangThaiThanhToan);
            if (hinhThucThanhToan != null) ticket.setHinhThucThanhToan(hinhThucThanhToan);
            if (ketQuaChamSoc != null) ticket.setKetQuaChamSoc(ketQuaChamSoc);

            // Xử lý áp dụng voucher nếu có lúc thanh toán
            if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                Optional<Voucher> vOpt = voucherService.getVoucherByCode(voucherCode.trim().toUpperCase());
                if (vOpt.isPresent()) {
                    Voucher v = vOpt.get();
                    if (v.getSoLuong() != null && v.getSoLuong() > 0) {
                        v.setSoLuong(v.getSoLuong() - 1);
                        voucherService.saveVoucher(v);
                    }
                    BigDecimal amount = ticket.getTongTien() != null ? ticket.getTongTien() : BigDecimal.ZERO;
                    BigDecimal vDiscount = BigDecimal.ZERO;
                    if (v.getPhanTramGiam() != null && amount.compareTo(BigDecimal.ZERO) > 0) {
                        vDiscount = amount.multiply(v.getPhanTramGiam()).divide(BigDecimal.valueOf(100), 0, RoundingMode.HALF_UP);
                        if (v.getSoTienGiamToiDa() != null && vDiscount.compareTo(v.getSoTienGiamToiDa()) > 0) {
                            vDiscount = v.getSoTienGiamToiDa();
                        }
                    }
                    BigDecimal curDiscount = ticket.getTienGiamGia() != null ? ticket.getTienGiamGia() : BigDecimal.ZERO;
                    ticket.setTienGiamGia(curDiscount.add(vDiscount));
                    BigDecimal newPay = amount.subtract(ticket.getTienGiamGia());
                    ticket.setThanhToan(newPay.compareTo(BigDecimal.ZERO) > 0 ? newPay : BigDecimal.ZERO);

                    String note = ticket.getGhiChu();
                    String vNote = "Áp dụng Voucher: " + v.getMaGiamGia() + " (-" + vDiscount + "VND)";
                    ticket.setGhiChu(note != null && !note.isEmpty() ? note + " | " + vNote : vNote);
                }
            }

            if ("Đã bàn giao thú cưng".equals(trangThaiDichVu) || "Hoàn thành chăm sóc".equals(trangThaiDichVu)) {
                if (ticket.getNgayTraThucTe() == null) {
                    ticket.setNgayTraThucTe(LocalDateTime.now());
                }
            }
            phieuRepository.save(ticket);

            // Tự động tích lũy điểm và nâng hạng nếu phiếu đã hoàn tất hoặc thanh toán
            membershipService.processCareTicketPoints(ticket);

            // Phát thông báo đến chủ nuôi khi thay đổi trạng thái phiếu
            if (ticket.getMaChuNuoi() != null && (oldStatus == null || !oldStatus.equals(trangThaiDichVu))) {
                String tieuDe = "Cập nhật dịch vụ chăm sóc #" + ticket.getSoPhieu();
                String noiDung = "Phiếu dịch vụ chăm sóc cho thú cưng của bạn đã được cập nhật trạng thái: '" 
                        + trangThaiDichVu + "'. Vui lòng kiểm tra trên hệ thống!";
                thongBaoService.taoThongBaoNhacLich(ticket.getMaChuNuoi(), ticket.getMaThuCung(), tieuDe, noiDung, null);
            }
        }
        return "redirect:/admin/care-tickets/detail/" + id;
    }

    @GetMapping("/delete/{id}")
    public String deleteTicket(@PathVariable("id") Integer id, HttpSession session) {
        if (!authService.canManageCareTickets(session)) return authService.redirectUnauthorized(session);
        phieuRepository.deleteById(id);
        return "redirect:/admin/care-tickets";
    }
}

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
    private PetShop.demo.service.EmployeeService employeeService;

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

    public List<Map<String, Object>> getOptimizedStaffList(LocalDateTime start, LocalDateTime end, Integer excludeTicketId) {
        if (start == null) start = LocalDateTime.now();
        if (end == null) end = start.plusHours(1);

        LocalDate today = start.toLocalDate();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(23, 59, 59);

        List<Employee> allEmployees = employeeRepository.findAll();
        List<Map<String, Object>> result = new ArrayList<>();

        for (Employee emp : allEmployees) {
            Map<String, Object> item = new HashMap<>();
            item.put("maNV", emp.getMaNV());
            item.put("tenNV", emp.getTenNV());
            item.put("chuyenMon", emp.getChuyenMon() != null ? emp.getChuyenMon() : "Nhân viên");

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

            String roleInfo = (emp.getChuyenMon() != null && !emp.getChuyenMon().trim().isEmpty()) 
                    ? " (" + emp.getChuyenMon().trim() + ")" 
                    : "";
            String label;
            if (isAvailable) {
                if (tasksToday == 0) {
                    label = "⭐ " + emp.getTenNV() + roleInfo + " — Tối ưu nhất (Rảnh, 0 ca)";
                } else {
                    label = "✅ " + emp.getTenNV() + roleInfo + " — Khả dụng (" + tasksToday + " ca hôm nay)";
                }
            } else {
                label = "⚠️ " + emp.getTenNV() + roleInfo + " — Đang bận / Trùng lịch";
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
                                            @RequestParam(value = "maThuCung", required = false) Integer maThuCung) {
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

        List<Employee> allEmployees = employeeRepository.findAll();
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

    // 1. Danh sách phiếu chăm sóc
    @GetMapping
    public String listTickets(@RequestParam(value = "status", required = false) String status,
                              @RequestParam(value = "keyword", required = false) String keyword,
                              Model model, HttpSession session) {
        if (!authService.canManageCareTickets(session)) return "redirect:/DangNhap";

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
        if (!authService.canManageCareTickets(session)) return "redirect:/DangNhap";

        PhieuDichVuChamSoc ticket = new PhieuDichVuChamSoc();
        String datePart = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String randPart = String.format("%04d", new Random().nextInt(10000));
        ticket.setSoPhieu("PDV-" + datePart + "-" + randPart);


        model.addAttribute("ticket", ticket);
        model.addAttribute("pets", hoSoThuCungRepository.findAll());
        model.addAttribute("owners", chuNuoiRepository.findAll());
        model.addAttribute("services", dichVuChamSocRepository.findAll());
        model.addAttribute("employees", employeeService.getActiveEmployeesWithWorkload());

        populateFormModel(model, ticket);

        return "admin/care-ticket-form";
    }

    @PostMapping("/create")
    public String createTicket(@ModelAttribute("ticket") PhieuDichVuChamSoc ticket,
                               @RequestParam(value = "selectedServiceIds", required = false) List<Integer> selectedServiceIds,
                               @RequestParam(value = "selectedServiceId", required = false) Integer selectedServiceId,
                               @RequestParam(value = "voucherCode", required = false) String voucherCode,
                               Model model,
                               HttpSession session) {
        if (!authService.canManageCareTickets(session)) return "redirect:/DangNhap";

        LocalDateTime now = LocalDateTime.now();

        // 1. Kiểm tra ngày giờ không được trước hiện tại
        if (ticket.getNgayHenTra() != null && ticket.getNgayHenTra().isBefore(now)) {
            model.addAttribute("errorMessage", "Ngày giờ không hợp lệ: Không thể chọn thời gian trước thời điểm hiện tại.");
            populateFormModel(model, ticket);
            return "admin/care-ticket-form";
        }

        // 2. Kiểm tra trùng lịch làm việc của nhân viên
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

        // Xử lý nhiều dịch vụ được chọn
        if (selectedServiceIds != null && !selectedServiceIds.isEmpty()) {
            List<DichVuChamSoc> chosenServices = dichVuChamSocRepository.findAllById(selectedServiceIds);
            BigDecimal sumPrice = BigDecimal.ZERO;
            StringBuilder sb = new StringBuilder();
            for (DichVuChamSoc s : chosenServices) {
                if (s.getGiaDichVu() != null) {
                    sumPrice = sumPrice.add(s.getGiaDichVu());
                }
                if (sb.length() > 0) sb.append(", ");
                sb.append(s.getTenDichVu());
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
        } else if (selectedServiceId != null) {
            DichVuChamSoc s = dichVuChamSocRepository.findById(selectedServiceId).orElse(null);
            if (s != null) {
                if (ticket.getTongTien() == null || ticket.getTongTien().compareTo(BigDecimal.ZERO) == 0) {
                    ticket.setTongTien(s.getGiaDichVu() != null ? s.getGiaDichVu() : BigDecimal.ZERO);
                }
                String oldReq = ticket.getYeuCauCuaChuNuoi();
                String prefix = "Dịch vụ: " + s.getTenDichVu();
                if (oldReq == null || oldReq.trim().isEmpty()) {
                    ticket.setYeuCauCuaChuNuoi(prefix);
                } else if (!oldReq.contains(prefix)) {
                    ticket.setYeuCauCuaChuNuoi(prefix + " | " + oldReq);
                }
            }
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

        if (ticket.getTongTien() == null) ticket.setTongTien(BigDecimal.ZERO);
        if (ticket.getTienGiamGia() == null) ticket.setTienGiamGia(BigDecimal.ZERO);
        if (ticket.getThanhToan() == null) ticket.setThanhToan(ticket.getTongTien().subtract(ticket.getTienGiamGia()));
        if (ticket.getThanhToan().compareTo(BigDecimal.ZERO) < 0) ticket.setThanhToan(BigDecimal.ZERO);

        phieuRepository.save(ticket);
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
        if (!authService.canManageCareTickets(session)) return "redirect:/DangNhap";
        PhieuDichVuChamSoc ticket = phieuRepository.findById(id).orElse(null);
        if (ticket == null) return "redirect:/admin/care-tickets";

        model.addAttribute("ticket", ticket);

        model.addAttribute("employees", employeeService.getActiveEmployeesWithWorkload());

        model.addAttribute("employees", employeeRepository.findAll());
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
                               @RequestParam(value = "maNVThucHien", required = false) Integer maNVThucHien,
                               HttpSession session) {
        if (!authService.canManageCareTickets(session)) return "redirect:/DangNhap";

        PhieuDichVuChamSoc ticket = phieuRepository.findById(id).orElse(null);
        if (ticket != null) {
            String oldStatus = ticket.getTrangThaiDichVu();
            ticket.setTrangThaiDichVu(trangThaiDichVu);
            ticket.setTrangThaiThanhToan(trangThaiThanhToan);
            if (hinhThucThanhToan != null) ticket.setHinhThucThanhToan(hinhThucThanhToan);
            if (ketQuaChamSoc != null) ticket.setKetQuaChamSoc(ketQuaChamSoc);
            if (maNVThucHien != null) ticket.setMaNVThucHien(maNVThucHien);

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
        if (!authService.canManageCareTickets(session)) return "redirect:/DangNhap";
        phieuRepository.deleteById(id);
        return "redirect:/admin/care-tickets";
    }
}

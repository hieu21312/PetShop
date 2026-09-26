package PetShop.demo.controller;

import PetShop.demo.model.enity.Booking;
import PetShop.demo.model.enity.PetService;
import PetShop.demo.repository.PetServiceRepository;
import PetShop.demo.service.BookingService;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.EmployeeService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Controller
public class BookingController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private PetServiceRepository petServiceRepository;

    @Autowired
    private AuthService authService;

    // Hiển thị form đặt lịch cho một dịch vụ
    @GetMapping("/DatLich")
    public String showBookingForm(@RequestParam Integer maDV, Model model, HttpSession session) {
        PetService service = petServiceRepository.findById(maDV).orElse(null);
        if (service == null) return "redirect:/DichVu";

        model.addAttribute("service", service);
        model.addAttribute("booking", new Booking());

        // Nếu đã đăng nhập, tự động điền thông tin khách hàng
        if (authService.isLoggedIn(session)) {
            String tenKH = (String) session.getAttribute("tenKH");
            String email = (String) session.getAttribute("email");
            model.addAttribute("tenKH", tenKH);
            model.addAttribute("emailKH", email);
        }
        return "booking-form";
    }

    // Xử lý đặt lịch
    @PostMapping("/DatLich")
    public String placeBooking(@ModelAttribute Booking booking,
                               @RequestParam Integer maDV,
                               @RequestParam String tenKhachHang,
                               @RequestParam String soDienThoai,
                               @RequestParam String email,
                               @RequestParam String ngayDat,
                               @RequestParam String gioDat,
                               @RequestParam(required = false) String ghiChu,
                               HttpSession session,
                               RedirectAttributes ra) {
        // Kiểm tra ngày giờ hợp lệ (không được đặt quá khứ)
        LocalDate date = LocalDate.parse(ngayDat);
        LocalTime time = LocalTime.parse(gioDat);
        if (date.isBefore(LocalDate.now()) ||
                (date.equals(LocalDate.now()) && time.isBefore(LocalTime.now()))) {
            ra.addFlashAttribute("error", "Không thể đặt lịch vào thời điểm đã qua.");
            return "redirect:/DatLich?maDV=" + maDV;
        }

        // Kiểm tra khung giờ còn chỗ không (tối đa 3 khách/ca)
        if (!bookingService.isSlotAvailable(date, time)) {
            ra.addFlashAttribute("error", "Khung giờ này đã kín lịch (tối đa 3 khách/ca). Vui lòng chọn khung giờ khác.");
            return "redirect:/DatLich?maDV=" + maDV;
        }

        booking.setMaDV(maDV);
        booking.setTenKhachHang(tenKhachHang);
        booking.setSoDienThoai(soDienThoai);
        booking.setEmail(email);
        booking.setNgayDat(date);
        booking.setGioDat(time);
        booking.setGhiChu(ghiChu);

        // Nếu khách hàng đã đăng nhập, lưu mã KH
        Integer maKH = (Integer) session.getAttribute("maKH");
        if (maKH != null) booking.setMaKH(maKH);

        // Lưu SĐT vào session để khách vãng lai tự động xem lại lịch hẹn ở trang /LichSuDatLich
        if (soDienThoai != null && !soDienThoai.isBlank()) {
            session.setAttribute("bookingPhone", soDienThoai.trim());
        }

        bookingService.saveBooking(booking);
        ra.addFlashAttribute("success", "Đặt lịch dịch vụ thành công! Cảm ơn quý khách. Chúng tôi sẽ liên hệ qua SĐT (" + soDienThoai + ") để xác nhận sớm nhất.");

        return "redirect:/LichSuDatLich";
    }

    // KHACH HANG: Xem lịch sử đặt lịch cá nhân (Hỗ trợ cả Đã đăng nhập & Khách vãng lai qua SĐT)
    @GetMapping("/LichSuDatLich")
    public String myBookings(@RequestParam(required = false) String searchPhone, Model model, HttpSession session) {
        Integer maKH = (Integer) session.getAttribute("maKH");
        String email = (String) session.getAttribute("email");
        String phoneInSession = (String) session.getAttribute("bookingPhone");

        String phoneToSearch = (searchPhone != null && !searchPhone.isBlank()) ? searchPhone.trim() : phoneInSession;

        List<Booking> bookings = List.of();

        if (maKH != null) {
            bookings = bookingService.getBookingsForCustomer(maKH, phoneToSearch, email);
        } else if (phoneToSearch != null && !phoneToSearch.isBlank()) {
            bookings = bookingService.getBookingsByPhone(phoneToSearch);
            model.addAttribute("searchPhone", phoneToSearch);
        }

        model.addAttribute("bookings", bookings);
        return "my-bookings";
    }

    // KHACH HANG: Hủy lịch hẹn (khi còn ở trạng thái Chờ xác nhận)
    @PostMapping("/DatLich/Huy/{id}")
    public String cancelBooking(@PathVariable Integer id, HttpSession session, RedirectAttributes ra) {
        Integer maKH = (Integer) session.getAttribute("maKH");
        String phoneInSession = (String) session.getAttribute("bookingPhone");
        Booking b = bookingService.getBookingById(id);

        boolean isOwner = (b != null) && (
            (maKH != null && maKH.equals(b.getMaKH())) ||
            (phoneInSession != null && phoneInSession.equalsIgnoreCase(b.getSoDienThoai()))
        );

        if (isOwner) {
            if ("Chờ xác nhận".equals(b.getTrangThai())) {
                bookingService.updateStatus(id, "Đã hủy");
                ra.addFlashAttribute("success", "Đã hủy lịch hẹn thành công.");
            } else {
                ra.addFlashAttribute("error", "Không thể hủy lịch hẹn đã được xác nhận hoặc hoàn thành.");
            }
        } else {
            ra.addFlashAttribute("error", "Bạn không có quyền thao tác trên lịch hẹn này.");
        }
        return "redirect:/LichSuDatLich";
    }

    @Autowired
    private EmployeeService employeeService;

    // ADMIN: Xem danh sách lịch đặt
    @GetMapping("/admin/bookings")
    public String listBookings(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        List<Booking> bookings = bookingService.getAllBookings();
        model.addAttribute("bookings", bookings);
        model.addAttribute("employees", employeeService.getActiveEmployees());
        return "admin/bookings";
    }

    // ADMIN: Cập nhật trạng thái lịch đặt
    @PostMapping("/admin/bookings/updateStatus")
    public String updateStatus(@RequestParam Integer id, @RequestParam String status, HttpSession session, RedirectAttributes ra) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        bookingService.updateStatus(id, status);
        ra.addFlashAttribute("success", "Cập nhật trạng thái thành công.");
        return "redirect:/admin/bookings";
    }

    // ADMIN: Gán Bác sĩ / Nhân viên phụ trách
    @PostMapping("/admin/bookings/assignStaff")
    public String assignStaff(@RequestParam Integer id, @RequestParam(required = false) Integer maNV, HttpSession session, RedirectAttributes ra) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        Booking b = bookingService.getBookingById(id);
        if (b != null && maNV != null) {
            if (!bookingService.isStaffAvailable(maNV, b.getNgayDat(), b.getGioDat(), id)) {
                ra.addFlashAttribute("error", "Lưu ý: Nhân sự này đã có lịch hẹn khác trong cùng mốc " + b.getGioDat() + " ngày " + b.getNgayDat() + "!");
            } else {
                ra.addFlashAttribute("success", "Phân công nhân sự phụ trách thành công.");
            }
        } else {
            ra.addFlashAttribute("success", "Đã cập nhật phân công nhân sự.");
        }

        bookingService.assignStaff(id, maNV);
        return "redirect:/admin/bookings";
    }

    // ADMIN: Xóa lịch đặt
    @GetMapping("/admin/bookings/delete/{id}")
    public String deleteBooking(@PathVariable Integer id, HttpSession session, RedirectAttributes ra) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        bookingService.deleteBooking(id);
        ra.addFlashAttribute("success", "Xóa lịch đặt thành công.");
        return "redirect:/admin/bookings";
    }
}
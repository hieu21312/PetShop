package PetShop.demo.controller;

import PetShop.demo.model.enity.Booking;
import PetShop.demo.model.enity.PetService;
import PetShop.demo.repository.PetServiceRepository;
import PetShop.demo.service.BookingService;
import PetShop.demo.service.AuthService;
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

        bookingService.saveBooking(booking);
        ra.addFlashAttribute("success", "Đặt lịch thành công! Chúng tôi sẽ liên hệ xác nhận sớm nhất.");
        return "redirect:/DichVu";
    }

    // ADMIN: Xem danh sách lịch đặt
    @GetMapping("/admin/bookings")
    public String listBookings(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        List<Booking> bookings = bookingService.getAllBookings();
        model.addAttribute("bookings", bookings);
        return "admin/bookings";
    }

    // ADMIN: Cập nhật trạng thái lịch đặt
    @PostMapping("/admin/bookings/updateStatus")
    public String updateStatus(@RequestParam Integer id, @RequestParam String status, RedirectAttributes ra) {
        bookingService.updateStatus(id, status);
        ra.addFlashAttribute("success", "Cập nhật trạng thái thành công.");
        return "redirect:/admin/bookings";
    }

    // ADMIN: Xóa lịch đặt
    @GetMapping("/admin/bookings/delete/{id}")
    public String deleteBooking(@PathVariable Integer id, RedirectAttributes ra) {
        bookingService.deleteBooking(id);
        ra.addFlashAttribute("success", "Xóa lịch đặt thành công.");
        return "redirect:/admin/bookings";
    }
}
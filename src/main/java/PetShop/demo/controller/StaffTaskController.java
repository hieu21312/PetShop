package PetShop.demo.controller;

import PetShop.demo.model.enity.Booking;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.BookingService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/staff/my-tasks")
public class StaffTaskController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private AuthService authService;

    // Xem danh sách ca làm việc được phân công của Nhân sự / Bác sĩ đang đăng nhập
    @GetMapping
    public String myTasks(Model model, HttpSession session) {
        Integer maNV = (Integer) session.getAttribute("maNV");
        if (maNV == null && !authService.isLoggedIn(session)) {
            return "redirect:/DangNhap";
        }

        // Trường hợp admin xem tạm hoặc staff đăng nhập
        if (maNV == null) {
            maNV = (Integer) session.getAttribute("maNV");
        }

        List<Booking> myBookings = bookingService.getBookingsByStaff(maNV);
        model.addAttribute("myBookings", myBookings);
        return "staff/my-tasks";
    }

    // Cập nhật tiến độ ca làm việc & ghi chú kết quả khám / chăm sóc
    @PostMapping("/updateProgress")
    public String updateProgress(@RequestParam Integer id,
                                 @RequestParam String trangThai,
                                 @RequestParam(required = false) String ghiChu,
                                 HttpSession session,
                                 RedirectAttributes ra) {
        Integer maNV = (Integer) session.getAttribute("maNV");
        Booking booking = bookingService.getBookingById(id);

        if (booking != null) {
            bookingService.updateProgressAndNotes(id, trangThai, ghiChu);
            ra.addFlashAttribute("success", "Cập nhật tiến độ công việc thành công.");
        } else {
            ra.addFlashAttribute("error", "Không tìm thấy lịch hẹn.");
        }
        return "redirect:/staff/my-tasks";
    }
}

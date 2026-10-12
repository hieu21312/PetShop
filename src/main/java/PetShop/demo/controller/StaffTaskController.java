package PetShop.demo.controller;

import PetShop.demo.model.enity.Booking;
import PetShop.demo.model.enity.PhieuDichVuChamSoc;
import PetShop.demo.repository.PhieuDichVuChamSocRepository;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.BookingService;
import PetShop.demo.service.ThongBaoService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/staff/my-tasks")
public class StaffTaskController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private AuthService authService;

    @Autowired
    private PhieuDichVuChamSocRepository phieuRepository;

    @Autowired
    private ThongBaoService thongBaoService;

    // Xem danh sách ca làm việc được phân công của Nhân sự / Bác sĩ đang đăng nhập
    @GetMapping
    public String myTasks(Model model, HttpSession session) {
        Integer maNV = (Integer) session.getAttribute("maNV");
        if (maNV == null && !authService.isLoggedIn(session)) {
            return "redirect:/DangNhap";
        }

        List<Booking> myBookings = (maNV != null) ? bookingService.getBookingsByStaff(maNV) : List.of();
        List<PhieuDichVuChamSoc> myCareTickets = (maNV != null) 
                ? phieuRepository.findByMaNVThucHienOrderByNgayTiepNhanDesc(maNV)
                : phieuRepository.findByOrderByNgayTiepNhanDesc();

        model.addAttribute("myBookings", myBookings);
        model.addAttribute("myCareTickets", myCareTickets);
        return "staff/my-tasks";
    }

    // Cập nhật tiến độ ca làm việc lịch hẹn online (tblDatLich)
    @PostMapping("/updateProgress")
    public String updateProgress(@RequestParam Integer id,
                                 @RequestParam String trangThai,
                                 @RequestParam(required = false) String ghiChu,
                                 HttpSession session,
                                 RedirectAttributes ra) {
        Booking booking = bookingService.getBookingById(id);

        if (booking != null) {
            bookingService.updateProgressAndNotes(id, trangThai, ghiChu);
            ra.addFlashAttribute("success", "Cập nhật tiến độ lịch hẹn #" + id + " thành công.");
        } else {
            ra.addFlashAttribute("error", "Không tìm thấy lịch hẹn.");
        }
        return "redirect:/staff/my-tasks";
    }

    // Cập nhật tiến độ phiếu dịch vụ chăm sóc thú cưng nhận tại quầy (tblPhieuDichVuChamSoc)
    @PostMapping("/updateCareTicket")
    public String updateCareTicket(@RequestParam Integer id,
                                  @RequestParam String trangThaiDichVu,
                                  @RequestParam(required = false) String ketQuaChamSoc,
                                  RedirectAttributes ra) {
        var ticketOpt = phieuRepository.findById(id);
        if (ticketOpt.isPresent()) {
            PhieuDichVuChamSoc ticket = ticketOpt.get();
            ticket.setTrangThaiDichVu(trangThaiDichVu);
            if (ketQuaChamSoc != null) {
                ticket.setKetQuaChamSoc(ketQuaChamSoc);
            }
            if ("Hoàn thành chăm sóc".equalsIgnoreCase(trangThaiDichVu) && ticket.getNgayTraThucTe() == null) {
                ticket.setNgayTraThucTe(LocalDateTime.now());
            }
            phieuRepository.save(ticket);

            // Gửi thông báo cho chủ nuôi nếu đã liên kết tài khoản
            if (ticket.getChuNuoi() != null && ticket.getChuNuoi().getMaKH() != null) {
                String petName = ticket.getThuCung() != null ? ticket.getThuCung().getTenThuCung() : "Bé cưng";
                String msg = "Dịch vụ của bé " + petName + " (Phiếu " + ticket.getSoPhieu() + ") đã chuyển sang trạng thái: " + trangThaiDichVu;
                thongBaoService.taoThongBaoNhacLich(ticket.getChuNuoi().getMaKH(), null, "Cập nhật tiến độ chăm sóc thú cưng", msg, null);
            }

            ra.addFlashAttribute("success", "Cập nhật phiếu chăm sóc " + ticket.getSoPhieu() + " thành công!");
        } else {
            ra.addFlashAttribute("error", "Không tìm thấy phiếu dịch vụ chăm sóc.");
        }
        return "redirect:/staff/my-tasks";
    }
}

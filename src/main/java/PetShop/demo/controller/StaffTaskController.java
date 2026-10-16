package PetShop.demo.controller;

import PetShop.demo.model.enity.Booking;
import PetShop.demo.model.enity.PetService;
import PetShop.demo.model.enity.PhieuDichVuChamSoc;
import PetShop.demo.repository.BookingRepository;
import PetShop.demo.repository.PetServiceRepository;
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
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/staff/my-tasks")
public class StaffTaskController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private AuthService authService;

    @Autowired
    private PhieuDichVuChamSocRepository phieuRepository;

    @Autowired
    private PetServiceRepository petServiceRepository;

    @Autowired
    private ThongBaoService thongBaoService;

    // Xem danh sách ca làm việc được phân công của Nhân sự / Bác sĩ đang đăng nhập
    @GetMapping
    public String myTasks(Model model, HttpSession session) {
        Integer maNV = (Integer) session.getAttribute("maNV");
        if (maNV == null && !authService.isLoggedIn(session)) {
            return "redirect:/DangNhap";
        }

        // Lấy danh sách lịch đặt: các lịch phân công cho bác sĩ này hoặc chưa phân công
        List<Booking> myBookings = (maNV != null)
                ? bookingRepository.findStaffAndUnassignedBookings(maNV)
                : bookingRepository.findAllByOrderByNgayTaoDesc();

        // Lấy danh sách phiếu chăm sóc: các phiếu phân công cho bác sĩ này hoặc chưa phân công
        List<PhieuDichVuChamSoc> myCareTickets = (maNV != null) 
                ? phieuRepository.findStaffAndUnassignedTickets(maNV)
                : phieuRepository.findByOrderByNgayTiepNhanDesc();

        model.addAttribute("myBookings", myBookings);
        model.addAttribute("myCareTickets", myCareTickets);

        // Nạp danh sách tên dịch vụ để hiển thị an toàn
        Map<Integer, String> serviceNames = petServiceRepository.findAll().stream()
                .filter(s -> s.getMaDV() != null)
                .collect(Collectors.toMap(PetService::getMaDV, PetService::getTenDV, (v1, v2) -> v1));
        model.addAttribute("serviceNames", serviceNames);

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
            Integer currentMaNV = (Integer) session.getAttribute("maNV");
            if (booking.getMaNV() == null && currentMaNV != null) {
                booking.setMaNV(currentMaNV);
            }
            booking.setTrangThai(trangThai);
            if (ghiChu != null) {
                booking.setGhiChu(ghiChu.trim());
            }
            bookingRepository.save(booking);

            String extraMsg = "Hoàn thành".equalsIgnoreCase(trangThai) 
                    ? " Dịch vụ đã hoàn thành và được chuyển tự động sang quầy Thu ngân để sẵn sàng thanh toán & in hóa đơn."
                    : "";
            ra.addFlashAttribute("success", "Cập nhật tiến độ lịch hẹn #" + id + " thành công." + extraMsg);
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
                                  HttpSession session,
                                  RedirectAttributes ra) {
        var ticketOpt = phieuRepository.findById(id);
        if (ticketOpt.isPresent()) {
            PhieuDichVuChamSoc ticket = ticketOpt.get();
            Integer currentMaNV = (Integer) session.getAttribute("maNV");
            if (ticket.getMaNVThucHien() == null && currentMaNV != null) {
                ticket.setMaNVThucHien(currentMaNV);
            }
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

            String extraMsg = ("Hoàn thành chăm sóc".equalsIgnoreCase(trangThaiDichVu) || "Đã bàn giao thú cưng".equalsIgnoreCase(trangThaiDichVu))
                    ? " Dịch vụ đã hoàn thành và được chuyển tự động sang quầy Thu ngân với số tiền đúng đăng ký để thanh toán & in hóa đơn."
                    : "";

            ra.addFlashAttribute("success", "Cập nhật phiếu chăm sóc " + ticket.getSoPhieu() + " thành công!" + extraMsg);
        } else {
            ra.addFlashAttribute("error", "Không tìm thấy phiếu dịch vụ chăm sóc.");
        }
        return "redirect:/staff/my-tasks";
    }
}

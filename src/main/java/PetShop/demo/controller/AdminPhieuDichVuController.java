package PetShop.demo.controller;

import PetShop.demo.model.enity.ChuNuoi;
import PetShop.demo.model.enity.DichVuChamSoc;
import PetShop.demo.model.enity.Employee;
import PetShop.demo.model.enity.HoSoThuCung;
import PetShop.demo.model.enity.PhieuDichVuChamSoc;
import PetShop.demo.repository.ChuNuoiRepository;
import PetShop.demo.repository.DichVuChamSocRepository;
import PetShop.demo.repository.EmployeeRepository;
import PetShop.demo.repository.HoSoThuCungRepository;
import PetShop.demo.repository.PhieuDichVuChamSocRepository;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Random;

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
    private PetShop.demo.service.ThongBaoService thongBaoService;

    @Autowired
    private AuthService authService;

    // 1. Danh sách phiếu chăm sóc
    @GetMapping
    public String listTickets(@RequestParam(value = "status", required = false) String status,
                              Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        List<PhieuDichVuChamSoc> tickets;
        if (status != null && !status.trim().isEmpty() && !status.equals("All")) {
            tickets = phieuRepository.findByTrangThaiDichVu(status.trim());
        } else {
            tickets = phieuRepository.findByOrderByNgayTiepNhanDesc();
        }

        model.addAttribute("tickets", tickets);
        model.addAttribute("currentStatus", status);
        return "admin/care-tickets";
    }

    // 2. Form lập phiếu tiếp nhận chăm sóc thú cưng
    @GetMapping("/create")
    public String showCreateForm(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        PhieuDichVuChamSoc ticket = new PhieuDichVuChamSoc();
        String datePart = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String randPart = String.format("%04d", new Random().nextInt(10000));
        ticket.setSoPhieu("PDV-" + datePart + "-" + randPart);

        model.addAttribute("ticket", ticket);
        model.addAttribute("pets", hoSoThuCungRepository.findAll());
        model.addAttribute("owners", chuNuoiRepository.findAll());
        model.addAttribute("services", dichVuChamSocRepository.findAll());
        model.addAttribute("employees", employeeRepository.findAll());
        return "admin/care-ticket-form";
    }

    // 3. Xử lý lưu phiếu tiếp nhận mới
    @PostMapping("/create")
    public String createTicket(@ModelAttribute("ticket") PhieuDichVuChamSoc ticket,
                               @RequestParam(value = "selectedServiceId", required = false) Integer selectedServiceId,
                               HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        if (ticket.getMaThuCung() != null && ticket.getMaChuNuoi() == null) {
            HoSoThuCung pet = hoSoThuCungRepository.findById(ticket.getMaThuCung()).orElse(null);
            if (pet != null) {
                ticket.setMaChuNuoi(pet.getMaChuNuoi());
            }
        }

        if (selectedServiceId != null) {
            DichVuChamSoc s = dichVuChamSocRepository.findById(selectedServiceId).orElse(null);
            if (s != null) {
                ticket.setTongTien(s.getGiaDichVu() != null ? s.getGiaDichVu() : BigDecimal.ZERO);
                BigDecimal giam = ticket.getTienGiamGia() != null ? ticket.getTienGiamGia() : BigDecimal.ZERO;
                ticket.setThanhToan(ticket.getTongTien().subtract(giam));
            }
        }

        if (ticket.getTongTien() == null) ticket.setTongTien(BigDecimal.ZERO);
        if (ticket.getTienGiamGia() == null) ticket.setTienGiamGia(BigDecimal.ZERO);
        if (ticket.getThanhToan() == null) ticket.setThanhToan(ticket.getTongTien().subtract(ticket.getTienGiamGia()));

        phieuRepository.save(ticket);
        return "redirect:/admin/care-tickets";
    }

    // 4. Xem chi tiết phiếu & cập nhật trạng thái
    @GetMapping("/detail/{id}")
    public String viewDetail(@PathVariable("id") Integer id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        PhieuDichVuChamSoc ticket = phieuRepository.findById(id).orElse(null);
        if (ticket == null) return "redirect:/admin/care-tickets";

        model.addAttribute("ticket", ticket);
        model.addAttribute("employees", employeeRepository.findAll());
        return "admin/care-ticket-detail";
    }

    // 5. Cập nhật tiến độ / hoàn tất thanh toán
    @PostMapping("/update-status/{id}")
    public String updateStatus(@PathVariable("id") Integer id,
                               @RequestParam("trangThaiDichVu") String trangThaiDichVu,
                               @RequestParam("trangThaiThanhToan") String trangThaiThanhToan,
                               @RequestParam(value = "hinhThucThanhToan", required = false) String hinhThucThanhToan,
                               @RequestParam(value = "ketQuaChamSoc", required = false) String ketQuaChamSoc,
                               HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        PhieuDichVuChamSoc ticket = phieuRepository.findById(id).orElse(null);
        if (ticket != null) {
            String oldStatus = ticket.getTrangThaiDichVu();
            ticket.setTrangThaiDichVu(trangThaiDichVu);
            ticket.setTrangThaiThanhToan(trangThaiThanhToan);
            if (hinhThucThanhToan != null) ticket.setHinhThucThanhToan(hinhThucThanhToan);
            if (ketQuaChamSoc != null) ticket.setKetQuaChamSoc(ketQuaChamSoc);

            if ("Đã bàn giao thú cưng".equals(trangThaiDichVu) || "Hoàn thành chăm sóc".equals(trangThaiDichVu)) {
                if (ticket.getNgayTraThucTe() == null) {
                    ticket.setNgayTraThucTe(LocalDateTime.now());
                }
            }
            phieuRepository.save(ticket);

            // Gửi thông báo tự động cho chủ nuôi khi trạng thái dịch vụ được cập nhật
            if (ticket.getMaChuNuoi() != null && (oldStatus == null || !oldStatus.equals(trangThaiDichVu))) {
                String tieuDe = "Cập nhật dịch vụ chăm sóc #" + ticket.getSoPhieu();
                String noiDung = "Phiếu dịch vụ chăm sóc cho thú cưng của bạn đã được cập nhật trạng thái: '" 
                        + trangThaiDichVu + "'. Vui lòng kiểm tra trên hệ thống!";
                thongBaoService.taoThongBaoNhacLich(ticket.getMaChuNuoi(), ticket.getMaThuCung(), tieuDe, noiDung, null);
            }
        }
        return "redirect:/admin/care-tickets/detail/" + id;
    }

    // 6. Xóa phiếu
    @GetMapping("/delete/{id}")
    public String deleteTicket(@PathVariable("id") Integer id, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        phieuRepository.deleteById(id);
        return "redirect:/admin/care-tickets";
    }
}

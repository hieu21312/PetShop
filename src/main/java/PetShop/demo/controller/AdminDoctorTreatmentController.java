package PetShop.demo.controller;

import PetShop.demo.model.enity.Employee;
import PetShop.demo.model.enity.HoSoThuCung;
import PetShop.demo.model.enity.NhatKyDieuTri;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.NhatKyDieuTriService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin/doctor/treatment")
public class AdminDoctorTreatmentController {

    @Autowired
    private NhatKyDieuTriService nhatKyDieuTriService;

    @Autowired
    private AuthService authService;

    // 1. Xem danh sách thú cưng đang điều trị
    @GetMapping
    public String listPetsInTreatment(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        List<HoSoThuCung> pets = nhatKyDieuTriService.getDanhSachThuCungDangDieuTri();
        model.addAttribute("pets", pets);
        return "admin/doctor-treatment-list";
    }

    // 2. Chọn thú cưng -> Lấy hồ sơ & Xem Nhật ký điều trị
    @GetMapping("/{maThuCung}")
    public String viewTreatmentRecord(@PathVariable("maThuCung") Integer maThuCung, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        HoSoThuCung pet = nhatKyDieuTriService.getHoSoThuCung(maThuCung)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy hồ sơ thú cưng #" + maThuCung));

        List<NhatKyDieuTri> treatmentLogs = nhatKyDieuTriService.getLichSuDieuTriByThuCung(maThuCung);

        model.addAttribute("pet", pet);
        model.addAttribute("treatmentLogs", treatmentLogs);
        return "admin/doctor-treatment-detail";
    }

    // 3. Cập nhật điều trị mới + Lên lịch tái khám nếu cần
    @PostMapping("/{maThuCung}/add-log")
    public String addTreatmentLog(@PathVariable("maThuCung") Integer maThuCung,
                                  @RequestParam("chuanDoan") String chuanDoan,
                                  @RequestParam(value = "phuongPhapDieuTri", required = false) String phuongPhapDieuTri,
                                  @RequestParam(value = "thuocSuDung", required = false) String thuocSuDung,
                                  @RequestParam(value = "canNang", required = false) BigDecimal canNang,
                                  @RequestParam(value = "nhietDo", required = false) BigDecimal nhietDo,
                                  @RequestParam(value = "trangThaiSucKhoe", required = false) String trangThaiSucKhoe,
                                  @RequestParam(value = "canTaiKham", required = false, defaultValue = "false") Boolean canTaiKham,
                                  @RequestParam(value = "ngayTaiKham", required = false) 
                                  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime ngayTaiKham,
                                  @RequestParam(value = "ghiChu", required = false) String ghiChu,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        Employee loggedInStaff = (Employee) session.getAttribute("employeeSession");
        Integer maBacSi = (loggedInStaff != null) ? loggedInStaff.getMaNV() : 1; // Fallback bác sĩ ID 1

        NhatKyDieuTri log = new NhatKyDieuTri();
        log.setMaThuCung(maThuCung);
        log.setMaBacSi(maBacSi);
        log.setChuanDoan(chuanDoan);
        log.setPhuongPhapDieuTri(phuongPhapDieuTri);
        log.setThuocSuDung(thuocSuDung);
        log.setCanNang(canNang);
        log.setNhietDo(nhietDo);
        log.setTrangThaiSucKhoe(trangThaiSucKhoe != null ? trangThaiSucKhoe : "Đang điều trị");
        log.setCanTaiKham(canTaiKham);
        log.setNgayTaiKham(ngayTaiKham);
        log.setGhiChu(ghiChu);
        log.setNgayKham(LocalDateTime.now());

        nhatKyDieuTriService.taoNhatKyDieuTri(log);

        if (Boolean.TRUE.equals(canTaiKham)) {
            redirectAttributes.addFlashAttribute("successMsg", "Đã cập nhật nhật ký điều trị và tự động gửi thông báo nhắc lịch tái khám tới khách hàng!");
        } else {
            redirectAttributes.addFlashAttribute("successMsg", "Đã cập nhật nhật ký điều trị mới thành công!");
        }

        return "redirect:/admin/doctor/treatment/" + maThuCung;
    }
}

package PetShop.demo.controller;

import PetShop.demo.model.enity.ChuNuoi;
import PetShop.demo.model.enity.Customer;
import PetShop.demo.model.enity.HoSoThuCung;
import PetShop.demo.repository.ChuNuoiRepository;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.repository.HoSoThuCungRepository;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.MembershipService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Controller
public class CustomerProfileController {

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private ChuNuoiRepository chuNuoiRepository;

    @Autowired
    private HoSoThuCungRepository hoSoThuCungRepository;

    @Autowired
    private AuthService authService;

    @Autowired
    private MembershipService membershipService;

    // Xem thông tin cá nhân & thú cưng
    @GetMapping("/ThongTinCaNhan")
    public String viewProfile(Model model, HttpSession session) {
        if (!authService.isLoggedIn(session)) {
            return "redirect:/DangNhap?returnUrl=/ThongTinCaNhan";
        }

        Integer maKH = (Integer) session.getAttribute("maKH");
        if (maKH == null) {
            return "redirect:/DangNhap";
        }

        Customer customer = customerRepository.findById(maKH).orElse(null);
        if (customer == null) {
            return "redirect:/DangNhap";
        }

        model.addAttribute("customer", customer);

        // Tìm hồ sơ chủ nuôi liên kết
        Optional<ChuNuoi> chuNuoiOpt = chuNuoiRepository.findFirstByMaKH(maKH);
        if (chuNuoiOpt.isEmpty() && customer.getDienThoai() != null && !customer.getDienThoai().isBlank()) {
            chuNuoiOpt = chuNuoiRepository.findFirstBySoDienThoai(customer.getDienThoai().trim());
        }

        List<HoSoThuCung> myPets = Collections.emptyList();
        if (chuNuoiOpt.isPresent()) {
            model.addAttribute("chuNuoi", chuNuoiOpt.get());
            myPets = hoSoThuCungRepository.findByMaChuNuoi(chuNuoiOpt.get().getMaChuNuoi());
        }
        model.addAttribute("myPets", myPets);

        // Hạng thành viên & quyền lợi
        model.addAttribute("hangThanhVien", customer.getHangThanhVien());
        model.addAttribute("diemTichLuy", customer.getDiemTichLuy());
        model.addAttribute("discountPercent", membershipService.getDiscountPercentage(customer.getHangThanhVien()));

        return "profile";
    }

    // Cập nhật thông tin cá nhân
    @PostMapping("/ThongTinCaNhan/CapNhat")
    public String updateProfile(@RequestParam String tenKH,
                                @RequestParam(required = false) String dienThoai,
                                @RequestParam(required = false) String diaChi,
                                @RequestParam(required = false) String gioiTinh,
                                @RequestParam(required = false) Integer namSinh,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        if (!authService.isLoggedIn(session)) {
            return "redirect:/DangNhap";
        }

        Integer maKH = (Integer) session.getAttribute("maKH");
        if (maKH == null) {
            return "redirect:/DangNhap";
        }

        Customer customer = customerRepository.findById(maKH).orElse(null);
        if (customer != null) {
            customer.setTenKH(tenKH.trim());
            customer.setDienThoai(dienThoai != null ? dienThoai.trim() : null);
            customer.setDiaChi(diaChi != null ? diaChi.trim() : null);
            customer.setGioiTinh(gioiTinh);
            customer.setNamSinh(namSinh);
            customerRepository.save(customer);

            // Cập nhật session
            session.setAttribute("tenKH", customer.getTenKH());

            // Tự động đồng bộ hồ sơ chủ nuôi nếu đã có
            Optional<ChuNuoi> chuNuoiOpt = chuNuoiRepository.findFirstByMaKH(maKH);
            if (chuNuoiOpt.isPresent()) {
                ChuNuoi cn = chuNuoiOpt.get();
                cn.setHoTenChuNuoi(customer.getTenKH());
                cn.setSoDienThoai(customer.getDienThoai());
                cn.setDiaChi(customer.getDiaChi());
                chuNuoiRepository.save(cn);
            }

            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông tin cá nhân thành công!");
        }

        return "redirect:/ThongTinCaNhan";
    }

    // Khách hàng tự thêm thú cưng của mình
    @PostMapping("/ThongTinCaNhan/ThemThuCung")
    public String addPet(@RequestParam String tenThuCung,
                         @RequestParam String loaiThuCung,
                         @RequestParam(required = false) String giongLoai,
                         @RequestParam(required = false) String gioiTinh,
                         @RequestParam(required = false) Double canNang,
                         @RequestParam(required = false) String mauSac,
                         @RequestParam(required = false) String ghiChu,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        if (!authService.isLoggedIn(session)) {
            return "redirect:/DangNhap";
        }

        Integer maKH = (Integer) session.getAttribute("maKH");
        Customer customer = customerRepository.findById(maKH).orElse(null);
        if (customer == null) {
            return "redirect:/DangNhap";
        }

        // Tìm hoặc tạo mới chủ nuôi liên kết
        Optional<ChuNuoi> chuNuoiOpt = chuNuoiRepository.findFirstByMaKH(maKH);
        ChuNuoi chuNuoi;
        if (chuNuoiOpt.isEmpty()) {
            chuNuoi = new ChuNuoi();
            chuNuoi.setHoTenChuNuoi(customer.getTenKH());
            chuNuoi.setSoDienThoai(customer.getDienThoai() != null ? customer.getDienThoai() : "");
            chuNuoi.setEmail(customer.getEmail());
            chuNuoi.setDiaChi(customer.getDiaChi() != null ? customer.getDiaChi() : "");
            chuNuoi.setMaKH(customer.getMaKH());
            chuNuoi = chuNuoiRepository.save(chuNuoi);
        } else {
            chuNuoi = chuNuoiOpt.get();
        }

        HoSoThuCung pet = new HoSoThuCung();
        pet.setMaChuNuoi(chuNuoi.getMaChuNuoi());
        pet.setTenThuCung(tenThuCung.trim());
        pet.setLoaiThuCung(loaiThuCung.trim());
        pet.setGiongLoai(giongLoai != null ? giongLoai.trim() : null);
        pet.setGioiTinh(gioiTinh);
        pet.setCanNang(canNang != null ? java.math.BigDecimal.valueOf(canNang) : null);
        pet.setMauSac(mauSac != null ? mauSac.trim() : null);
        pet.setDacDiemNhanDang(ghiChu != null ? ghiChu.trim() : null);
        hoSoThuCungRepository.save(pet);

        redirectAttributes.addFlashAttribute("successMessage", "Thêm hồ sơ thú cưng thành công!");
        return "redirect:/ThongTinCaNhan";
    }
}

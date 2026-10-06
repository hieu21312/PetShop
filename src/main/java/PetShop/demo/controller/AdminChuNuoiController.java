package PetShop.demo.controller;

import PetShop.demo.model.enity.ChuNuoi;
import PetShop.demo.model.enity.HoSoThuCung;
import PetShop.demo.repository.ChuNuoiRepository;
import PetShop.demo.repository.HoSoThuCungRepository;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/owners")
public class AdminChuNuoiController {

    @Autowired
    private ChuNuoiRepository chuNuoiRepository;

    @Autowired
    private HoSoThuCungRepository hoSoThuCungRepository;

    @Autowired
    private PetShop.demo.repository.CustomerRepository customerRepository;

    @Autowired
    private AuthService authService;

    // 1. Danh sách chủ nuôi
    @GetMapping
    public String listOwners(@RequestParam(value = "keyword", required = false) String keyword,
                             Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        List<ChuNuoi> owners;
        if (keyword != null && !keyword.trim().isEmpty()) {
            owners = chuNuoiRepository.findByHoTenChuNuoiContainingIgnoreCaseOrSoDienThoaiContaining(keyword.trim(), keyword.trim());
        } else {
            owners = chuNuoiRepository.findAll();
        }
        model.addAttribute("owners", owners);
        model.addAttribute("keyword", keyword);
        return "admin/owners";
    }

    // 2. Form thêm mới chủ nuôi
    @GetMapping("/create")
    public String showCreateForm(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        model.addAttribute("owner", new ChuNuoi());
        return "admin/owner-form";
    }

    // 3. Xử lý thêm mới (Tự động liên kết tài khoản Khách hàng nếu khớp SĐT hoặc Email)
    @PostMapping("/create")
    public String createOwner(@ModelAttribute("owner") ChuNuoi owner, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        if (owner.getMaKH() == null) {
            customerRepository.findFirstByDienThoaiOrEmail(owner.getSoDienThoai(), owner.getEmail())
                    .ifPresent(c -> owner.setMaKH(c.getMaKH()));
        }

        chuNuoiRepository.save(owner);
        return "redirect:/admin/owners";
    }

    // 4. Form sửa chủ nuôi
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        ChuNuoi owner = chuNuoiRepository.findById(id).orElse(null);
        if (owner == null) return "redirect:/admin/owners";
        model.addAttribute("owner", owner);
        return "admin/owner-form";
    }

    // 5. Xử lý cập nhật (Tự động cập nhật liên kết MaKH)
    @PostMapping("/edit/{id}")
    public String updateOwner(@PathVariable("id") Integer id, @ModelAttribute("owner") ChuNuoi ownerForm, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        ChuNuoi owner = chuNuoiRepository.findById(id).orElse(null);
        if (owner != null) {
            owner.setHoTenChuNuoi(ownerForm.getHoTenChuNuoi());
            owner.setSoDienThoai(ownerForm.getSoDienThoai());
            owner.setEmail(ownerForm.getEmail());
            owner.setSoCCCD(ownerForm.getSoCCCD());
            owner.setDiaChi(ownerForm.getDiaChi());
            owner.setGioiTinh(ownerForm.getGioiTinh());
            owner.setNgaySinh(ownerForm.getNgaySinh());
            owner.setSoDienThoaiKhanCap(ownerForm.getSoDienThoaiKhanCap());
            owner.setNguoiLienHeKhanCap(ownerForm.getNguoiLienHeKhanCap());
            owner.setLoaiChuNuoi(ownerForm.getLoaiChuNuoi());
            owner.setGhiChu(ownerForm.getGhiChu());
            owner.setTrangThai(ownerForm.getTrangThai());

            if (owner.getMaKH() == null) {
                customerRepository.findFirstByDienThoaiOrEmail(owner.getSoDienThoai(), owner.getEmail())
                        .ifPresent(c -> owner.setMaKH(c.getMaKH()));
            }

            chuNuoiRepository.save(owner);
        }
        return "redirect:/admin/owners";
    }

    // 6. Xóa chủ nuôi
    @GetMapping("/delete/{id}")
    public String deleteOwner(@PathVariable("id") Integer id, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        chuNuoiRepository.deleteById(id);
        return "redirect:/admin/owners";
    }

    // 7. Xem danh sách thú cưng của chủ nuôi
    @GetMapping("/{id}/pets")
    public String viewOwnerPets(@PathVariable("id") Integer id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        ChuNuoi owner = chuNuoiRepository.findById(id).orElse(null);
        if (owner == null) return "redirect:/admin/owners";
        List<HoSoThuCung> pets = hoSoThuCungRepository.findByMaChuNuoi(id);
        model.addAttribute("owner", owner);
        model.addAttribute("pets", pets);
        return "admin/pets";
    }
}

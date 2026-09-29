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
@RequestMapping("/admin/pets")
public class AdminHoSoThuCungController {

    @Autowired
    private HoSoThuCungRepository hoSoThuCungRepository;

    @Autowired
    private ChuNuoiRepository chuNuoiRepository;

    @Autowired
    private AuthService authService;

    // 1. Danh sách hồ sơ thú cưng
    @GetMapping
    public String listPets(@RequestParam(value = "keyword", required = false) String keyword,
                           @RequestParam(value = "loai", required = false) String loai,
                           Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        List<HoSoThuCung> pets;
        if (keyword != null && !keyword.trim().isEmpty()) {
            pets = hoSoThuCungRepository.findByTenThuCungContainingIgnoreCaseOrGiongLoaiContainingIgnoreCase(keyword.trim(), keyword.trim());
        } else if (loai != null && !loai.trim().isEmpty() && !loai.equals("All")) {
            pets = hoSoThuCungRepository.findByLoaiThuCung(loai.trim());
        } else {
            pets = hoSoThuCungRepository.findAll();
        }

        model.addAttribute("pets", pets);
        model.addAttribute("keyword", keyword);
        model.addAttribute("currentLoai", loai);
        return "admin/pets";
    }

    // 2. Form thêm mới thú cưng
    @GetMapping("/create")
    public String showCreateForm(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        model.addAttribute("pet", new HoSoThuCung());
        model.addAttribute("owners", chuNuoiRepository.findAll());
        return "admin/pet-form";
    }

    // 3. Xử lý thêm mới thú cưng
    @PostMapping("/create")
    public String createPet(@ModelAttribute("pet") HoSoThuCung pet, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        hoSoThuCungRepository.save(pet);
        return "redirect:/admin/pets";
    }

    // 4. Form sửa thú cưng
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        HoSoThuCung pet = hoSoThuCungRepository.findById(id).orElse(null);
        if (pet == null) return "redirect:/admin/pets";
        model.addAttribute("pet", pet);
        model.addAttribute("owners", chuNuoiRepository.findAll());
        return "admin/pet-form";
    }

    // 5. Xử lý cập nhật thú cưng
    @PostMapping("/edit/{id}")
    public String updatePet(@PathVariable("id") Integer id, @ModelAttribute("pet") HoSoThuCung petForm, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        HoSoThuCung pet = hoSoThuCungRepository.findById(id).orElse(null);
        if (pet != null) {
            pet.setMaChuNuoi(petForm.getMaChuNuoi());
            pet.setTenThuCung(petForm.getTenThuCung());
            pet.setLoaiThuCung(petForm.getLoaiThuCung());
            pet.setGiongLoai(petForm.getGiongLoai());
            pet.setGioiTinh(petForm.getGioiTinh());
            pet.setTrietSan(petForm.getTrietSan());
            pet.setNgaySinh(petForm.getNgaySinh());
            pet.setTuoiThang(petForm.getTuoiThang());
            pet.setMauSac(petForm.getMauSac());
            pet.setCanNang(petForm.getCanNang());
            pet.setDacDiemNhanDang(petForm.getDacDiemNhanDang());
            pet.setSoMicrochip(petForm.getSoMicrochip());
            pet.setTinhTrangSucKhoeHienTai(petForm.getTinhTrangSucKhoeHienTai());
            pet.setTienSuBenhLy(petForm.getTienSuBenhLy());
            pet.setDiUngThuocThucAn(petForm.getDiUngThuocThucAn());
            pet.setLichSuTiemChung(petForm.getLichSuTiemChung());
            pet.setTrangThai(petForm.getTrangThai());
            pet.setGhiChu(petForm.getGhiChu());
            hoSoThuCungRepository.save(pet);
        }
        return "redirect:/admin/pets";
    }

    // 6. Xóa hồ sơ thú cưng
    @GetMapping("/delete/{id}")
    public String deletePet(@PathVariable("id") Integer id, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        hoSoThuCungRepository.deleteById(id);
        return "redirect:/admin/pets";
    }
}

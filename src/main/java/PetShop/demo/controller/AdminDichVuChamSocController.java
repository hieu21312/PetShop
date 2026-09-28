package PetShop.demo.controller;

import PetShop.demo.model.enity.DichVuChamSoc;
import PetShop.demo.repository.DichVuChamSocRepository;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/care-services")
public class AdminDichVuChamSocController {

    @Autowired
    private DichVuChamSocRepository dichVuChamSocRepository;

    @Autowired
    private AuthService authService;

    // 1. Danh sách dịch vụ chăm sóc
    @GetMapping
    public String listCareServices(@RequestParam(value = "nhom", required = false) String nhom,
                                   Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        List<DichVuChamSoc> services;
        if (nhom != null && !nhom.trim().isEmpty() && !nhom.equals("All")) {
            services = dichVuChamSocRepository.findByNhomDichVu(nhom.trim());
        } else {
            services = dichVuChamSocRepository.findAll();
        }

        model.addAttribute("services", services);
        model.addAttribute("currentNhom", nhom);
        return "admin/care-services";
    }

    // 2. Form thêm mới
    @GetMapping("/create")
    public String showCreateForm(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        model.addAttribute("service", new DichVuChamSoc());
        return "admin/care-service-form";
    }

    // 3. Xử lý thêm mới
    @PostMapping("/create")
    public String createCareService(@ModelAttribute("service") DichVuChamSoc service, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        dichVuChamSocRepository.save(service);
        return "redirect:/admin/care-services";
    }

    // 4. Form sửa
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        DichVuChamSoc service = dichVuChamSocRepository.findById(id).orElse(null);
        if (service == null) return "redirect:/admin/care-services";
        model.addAttribute("service", service);
        return "admin/care-service-form";
    }

    // 5. Xử lý cập nhật
    @PostMapping("/edit/{id}")
    public String updateCareService(@PathVariable("id") Integer id, @ModelAttribute("service") DichVuChamSoc serviceForm, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        DichVuChamSoc service = dichVuChamSocRepository.findById(id).orElse(null);
        if (service != null) {
            service.setTenDichVu(serviceForm.getTenDichVu());
            service.setNhomDichVu(serviceForm.getNhomDichVu());
            service.setDoiTuongApDung(serviceForm.getDoiTuongApDung());
            service.setGiaDichVu(serviceForm.getGiaDichVu());
            service.setThoiGianThucHien(serviceForm.getThoiGianThucHien());
            service.setMoTaChiTiet(serviceForm.getMoTaChiTiet());
            service.setTrangThai(serviceForm.getTrangThai());
            dichVuChamSocRepository.save(service);
        }
        return "redirect:/admin/care-services";
    }

    // 6. Xóa dịch vụ
    @GetMapping("/delete/{id}")
    public String deleteCareService(@PathVariable("id") Integer id, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        dichVuChamSocRepository.deleteById(id);
        return "redirect:/admin/care-services";
    }
}

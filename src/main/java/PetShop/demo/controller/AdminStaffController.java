package PetShop.demo.controller;

import PetShop.demo.model.enity.Employee;
import PetShop.demo.model.enity.Role;
import PetShop.demo.repository.RoleRepository;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.EmployeeService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/staff")
public class AdminStaffController {

    @Autowired
    private EmployeeService employeeService;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private AuthService authService;

    // Hiển thị danh sách Bác sĩ thú y & Nhân viên chăm sóc (Hỗ trợ lọc roleFilter)
    @GetMapping
    public String listStaff(@RequestParam(required = false) String roleFilter, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        List<Employee> staffList = employeeService.getAllEmployees();

        if ("vet".equalsIgnoreCase(roleFilter)) {
            staffList = staffList.stream()
                    .filter(e -> e.getRole() != null && "Bác sĩ thú y".equalsIgnoreCase(e.getRole().getTenVaiTro()))
                    .toList();
        } else if ("care".equalsIgnoreCase(roleFilter)) {
            staffList = staffList.stream()
                    .filter(e -> e.getRole() == null || !"Bác sĩ thú y".equalsIgnoreCase(e.getRole().getTenVaiTro()))
                    .toList();
        }

        List<Role> roles = roleRepository.findAll();

        model.addAttribute("staffList", staffList);
        model.addAttribute("roles", roles);
        model.addAttribute("currentFilter", roleFilter != null ? roleFilter : "all");
        return "admin/staff";
    }

    // Trang form thêm mới nhân sự
    @GetMapping("/add")
    public String showAddForm(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        model.addAttribute("employee", new Employee());
        model.addAttribute("roles", roleRepository.findAll());
        return "admin/staff-form";
    }

    // Trang form sửa thông tin nhân sự
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        Optional<Employee> empOpt = employeeService.getEmployeeById(id);
        if (empOpt.isEmpty()) return "redirect:/admin/staff";

        model.addAttribute("employee", empOpt.get());
        model.addAttribute("roles", roleRepository.findAll());
        return "admin/staff-form";
    }

    // Xử lý lưu thông tin nhân sự (thêm/sửa)
    @PostMapping("/save")
    public String saveStaff(@ModelAttribute Employee employee, RedirectAttributes ra, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        // Nếu sửa, giữ nguyên mật khẩu cũ nếu không nhập mật khẩu mới
        if (employee.getMaNV() != null) {
            Optional<Employee> existing = employeeService.getEmployeeById(employee.getMaNV());
            if (existing.isPresent() && (employee.getMatKhau() == null || employee.getMatKhau().isBlank())) {
                employee.setMatKhau(existing.get().getMatKhau());
            }
        }

        employeeService.saveEmployee(employee);
        ra.addFlashAttribute("success", "Lưu thông tin nhân sự thành công!");
        return "redirect:/admin/staff";
    }

    // Bật / Tắt trạng thái làm việc (Đang làm việc <-> Tạm nghỉ)
    @PostMapping("/toggleStatus/{id}")
    public String toggleStatus(@PathVariable Integer id, RedirectAttributes ra, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        employeeService.toggleStatus(id);
        ra.addFlashAttribute("success", "Cập nhật trạng thái làm việc thành công!");
        return "redirect:/admin/staff";
    }

    // Reset mật khẩu nhân sự về mặc định 123456
    @PostMapping("/resetPassword/{id}")
    public String resetPassword(@PathVariable Integer id, RedirectAttributes ra, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        employeeService.resetPassword(id, "123456");
        ra.addFlashAttribute("success", "Đã reset mật khẩu nhân sự về mặc định (123456).");
        return "redirect:/admin/staff";
    }

    // Xóa hồ sơ nhân sự
    @GetMapping("/delete/{id}")
    public String deleteStaff(@PathVariable Integer id, RedirectAttributes ra, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        employeeService.deleteEmployee(id);
        ra.addFlashAttribute("success", "Đã xóa hồ sơ nhân sự.");
        return "redirect:/admin/staff";
    }
}

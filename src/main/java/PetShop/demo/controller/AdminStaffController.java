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

    // Hiển thị danh sách Bác sĩ thú y & Nhân viên chăm sóc (Hỗ trợ lọc roleFilter và statusFilter)
    @GetMapping
    public String listStaff(
            @RequestParam(required = false) String roleFilter,
            @RequestParam(required = false) String statusFilter,
            Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        List<Employee> allStaff = employeeService.getAllEmployees();

        // Thống kê tổng số lượng nhân sự
        long totalCount = allStaff.size();
        long workingCount = allStaff.stream()
                .filter(e -> e.getTrangThai() == null || "Đang làm việc".equalsIgnoreCase(e.getTrangThai()))
                .count();
        long leaveCount = allStaff.stream()
                .filter(e -> "Tạm nghỉ".equalsIgnoreCase(e.getTrangThai()))
                .count();

        List<Employee> filteredList = allStaff;

        // 1. Lọc theo vai trò (roleFilter)
        if ("admin".equalsIgnoreCase(roleFilter)) {
            filteredList = filteredList.stream()
                    .filter(e -> e.getRole() != null && "Admin".equalsIgnoreCase(e.getRole().getTenVaiTro()))
                    .toList();
            roleFilter = "admin";
        } else if ("vet".equalsIgnoreCase(roleFilter)) {
            filteredList = filteredList.stream()
                    .filter(e -> e.getRole() != null && "Bác sĩ thú y".equalsIgnoreCase(e.getRole().getTenVaiTro()))
                    .toList();
            roleFilter = "vet";
        } else if ("consultant".equalsIgnoreCase(roleFilter)) {
            filteredList = filteredList.stream()
                    .filter(e -> e.getRole() != null && (
                            "Tư vấn viên".equalsIgnoreCase(e.getRole().getTenVaiTro()) ||
                            "Tư vấn".equalsIgnoreCase(e.getRole().getTenVaiTro()) ||
                            "Nhân viên tư vấn".equalsIgnoreCase(e.getRole().getTenVaiTro()) ||
                            "Tư vấn viên".contains(e.getRole().getTenVaiTro())
                    ))
                    .toList();
            roleFilter = "consultant";
        } else if ("care".equalsIgnoreCase(roleFilter)) {
            filteredList = filteredList.stream()
                    .filter(e -> e.getRole() == null || (!"Admin".equalsIgnoreCase(e.getRole().getTenVaiTro()) && !"Bác sĩ thú y".equalsIgnoreCase(e.getRole().getTenVaiTro())))
                    .toList();
            roleFilter = "care";
        } else {
            roleFilter = "all";
        }

        // 2. Lọc theo trạng thái làm việc (statusFilter)
        if ("active".equalsIgnoreCase(statusFilter) || "working".equalsIgnoreCase(statusFilter) || "Đang làm việc".equalsIgnoreCase(statusFilter)) {
            filteredList = filteredList.stream()
                    .filter(e -> e.getTrangThai() == null || "Đang làm việc".equalsIgnoreCase(e.getTrangThai()))
                    .toList();
            statusFilter = "active";
        } else if ("leave".equalsIgnoreCase(statusFilter) || "inactive".equalsIgnoreCase(statusFilter) || "Tạm nghỉ".equalsIgnoreCase(statusFilter)) {
            filteredList = filteredList.stream()
                    .filter(e -> "Tạm nghỉ".equalsIgnoreCase(e.getTrangThai()))
                    .toList();
            statusFilter = "leave";
        } else {
            statusFilter = "all";
        }

        List<Role> roles = roleRepository.findAll();

        model.addAttribute("staffList", filteredList);
        model.addAttribute("roles", roles);
        model.addAttribute("currentRoleFilter", (roleFilter != null && !roleFilter.isBlank()) ? roleFilter : "all");
        model.addAttribute("currentStatusFilter", statusFilter);
        model.addAttribute("currentFilter", (roleFilter != null && !roleFilter.isBlank()) ? roleFilter : "all");

        model.addAttribute("totalCount", totalCount);
        model.addAttribute("workingCount", workingCount);
        model.addAttribute("leaveCount", leaveCount);

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
    public String toggleStatus(
            @PathVariable Integer id,
            @RequestParam(required = false) String roleFilter,
            @RequestParam(required = false) String statusFilter,
            RedirectAttributes ra, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";

        employeeService.toggleStatus(id);
        ra.addFlashAttribute("success", "Cập nhật trạng thái làm việc thành công!");

        StringBuilder redirectUrl = new StringBuilder("redirect:/admin/staff?");
        if (roleFilter != null && !roleFilter.isBlank() && !"all".equalsIgnoreCase(roleFilter)) {
            redirectUrl.append("roleFilter=").append(roleFilter).append("&");
        }
        if (statusFilter != null && !statusFilter.isBlank() && !"all".equalsIgnoreCase(statusFilter)) {
            redirectUrl.append("statusFilter=").append(statusFilter).append("&");
        }
        String res = redirectUrl.toString();
        if (res.endsWith("?") || res.endsWith("&")) {
            res = res.substring(0, res.length() - 1);
        }
        return res;
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

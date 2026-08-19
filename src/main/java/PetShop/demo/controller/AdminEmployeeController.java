package PetShop.demo.controller;

import PetShop.demo.model.enity.Employee;
import PetShop.demo.repository.EmployeeRepository;
import PetShop.demo.repository.RoleRepository;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/employees")
public class AdminEmployeeController {

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private AuthService authService;

    // Danh sách nhân viên
    @GetMapping
    public String listEmployees(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        List<Employee> employees = employeeRepository.findAll();
        model.addAttribute("employees", employees);
        return "admin/employees";
    }

    // Form thêm nhân viên
    @GetMapping("/create")
    public String createForm(Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        model.addAttribute("employee", new Employee());
        model.addAttribute("roles", roleRepository.findAll());
        return "admin/employee-form";
    }

    // Xử lý thêm nhân viên
    @PostMapping("/create")
    public String createEmployee(@ModelAttribute Employee employee,
                                 @RequestParam String password,
                                 HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        employee.setMatKhau(password); // plain text
        employeeRepository.save(employee);
        return "redirect:/admin/employees";
    }

    // Form sửa nhân viên (chỉ sửa vai trò, tên, giới tính,...)
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Employee employee = employeeRepository.findById(id).orElse(null);
        if (employee == null) return "redirect:/admin/employees";
        model.addAttribute("employee", employee);
        model.addAttribute("roles", roleRepository.findAll());
        return "admin/employee-form";
    }

    // Xử lý sửa nhân viên
    @PostMapping("/edit/{id}")
    public String updateEmployee(@PathVariable Integer id,
                                 @ModelAttribute Employee updatedEmployee,
                                 @RequestParam(required = false) String password,
                                 HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        Employee existing = employeeRepository.findById(id).orElse(null);
        if (existing == null) return "redirect:/admin/employees";
        existing.setTenNV(updatedEmployee.getTenNV());
        existing.setGioiTinh(updatedEmployee.getGioiTinh());
        existing.setNamSinh(updatedEmployee.getNamSinh());
        existing.setVaiTro(updatedEmployee.getVaiTro());
        if (password != null && !password.isEmpty()) {
            existing.setMatKhau(password);
        }
        employeeRepository.save(existing);
        return "redirect:/admin/employees";
    }

    // Xóa nhân viên
    @GetMapping("/delete/{id}")
    public String deleteEmployee(@PathVariable Integer id, HttpSession session) {
        if (!authService.isAdmin(session)) return "redirect:/DangNhap";
        employeeRepository.deleteById(id);
        return "redirect:/admin/employees";
    }
}
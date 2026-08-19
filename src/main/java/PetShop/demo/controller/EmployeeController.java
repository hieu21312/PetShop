package PetShop.demo.controller;

import PetShop.demo.model.enity.Employee;
import PetShop.demo.repository.EmployeeRepository;
import PetShop.demo.repository.RoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/QLNhanVien")
public class EmployeeController {

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private RoleRepository roleRepository;

    @GetMapping("/Index")
    public String listEmployees(Model model) {
        model.addAttribute("employees", employeeRepository.findAll());
        return "employee-list";
    }

    @GetMapping("/Create")
    public String createForm(Model model) {
        model.addAttribute("employee", new Employee());
        model.addAttribute("roles", roleRepository.findAll());
        return "employee-create";
    }

    @PostMapping("/Create")
    public String createEmployee(Employee employee) {
        employeeRepository.save(employee);
        return "redirect:/QLNhanVien/Index";
    }

    @GetMapping("/Edit/{id}")
    public String editForm(@PathVariable int id, Model model) {
        var empOpt = employeeRepository.findById(id);
        if (empOpt.isEmpty()) return "redirect:/QLNhanVien/Index";
        model.addAttribute("employee", empOpt.get());
        model.addAttribute("roles", roleRepository.findAll());
        return "employee-edit";
    }

    @PostMapping("/Edit")
    public String updateEmployee(@RequestParam int MaNV, @RequestParam int VaiTro) {
        var empOpt = employeeRepository.findById(MaNV);
        if (empOpt.isPresent()) {
            Employee e = empOpt.get();
            e.setVaiTro(VaiTro);
            employeeRepository.save(e);
        }
        return "redirect:/QLNhanVien/Index";
    }

    @GetMapping("/Delete/{id}")
    public String deleteForm(@PathVariable int id, Model model) {
        var empOpt = employeeRepository.findById(id);
        if (empOpt.isEmpty()) return "redirect:/QLNhanVien/Index";
        model.addAttribute("employee", empOpt.get());
        return "employee-delete";
    }

    @PostMapping("/Delete")
    public String deleteEmployee(@RequestParam int MaNV) {
        employeeRepository.deleteById(MaNV);
        return "redirect:/QLNhanVien/Index";
    }
}
package PetShop.demo.service;

import PetShop.demo.model.enity.Employee;
import PetShop.demo.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    public List<Employee> getAllEmployees() {
        return employeeRepository.findAll();
    }

    public List<Employee> getEmployeesByRole(Integer vaiTro) {
        return employeeRepository.findByVaiTro(vaiTro);
    }

    public List<Employee> getActiveEmployees() {
        return employeeRepository.findByTrangThai("Đang làm việc");
    }

    public Optional<Employee> getEmployeeById(Integer id) {
        return employeeRepository.findById(id);
    }

    public Employee saveEmployee(Employee employee) {
        if (employee.getTrangThai() == null || employee.getTrangThai().isBlank()) {
            employee.setTrangThai("Đang làm việc");
        }
        if (employee.getMatKhau() == null || employee.getMatKhau().isBlank()) {
            employee.setMatKhau("123456"); // Mật khẩu mặc định khi tạo mới
        }
        return employeeRepository.save(employee);
    }

    public void toggleStatus(Integer id) {
        Optional<Employee> empOpt = employeeRepository.findById(id);
        if (empOpt.isPresent()) {
            Employee emp = empOpt.get();
            if ("Tạm nghỉ".equals(emp.getTrangThai())) {
                emp.setTrangThai("Đang làm việc");
            } else {
                emp.setTrangThai("Tạm nghỉ");
            }
            employeeRepository.save(emp);
        }
    }

    public void resetPassword(Integer id, String newPassword) {
        Optional<Employee> empOpt = employeeRepository.findById(id);
        if (empOpt.isPresent()) {
            Employee emp = empOpt.get();
            emp.setMatKhau(newPassword);
            employeeRepository.save(emp);
        }
    }

    public void deleteEmployee(Integer id) {
        employeeRepository.deleteById(id);
    }
}
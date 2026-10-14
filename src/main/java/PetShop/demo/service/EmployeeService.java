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

    @Autowired
    private PetShop.demo.repository.BookingRepository bookingRepository;

    @Autowired
    private PetShop.demo.repository.PhieuDichVuChamSocRepository phieuRepository;

    public List<Employee> getAllEmployees() {
        return employeeRepository.findAll();
    }

    public List<Employee> getEmployeesByRole(Integer vaiTro) {
        return employeeRepository.findByVaiTro(vaiTro);
    }

    public List<Employee> getActiveEmployees() {
        return employeeRepository.findAll().stream()
                .filter(e -> e.getTrangThai() == null || !"Tạm nghỉ".equalsIgnoreCase(e.getTrangThai()))
                .toList();
    }

    public List<Employee> getActiveEmployeesWithWorkload() {
        List<Employee> list = getActiveEmployees();
        List<String> activeBookingStatuses = List.of("Đã xác nhận", "Đang thực hiện");
        List<String> activeCareStatuses = List.of("Chờ tiếp nhận", "Đang thực hiện");

        for (Employee e : list) {
            long bookingCount = bookingRepository.countByMaNVAndTrangThaiIn(e.getMaNV(), activeBookingStatuses);
            long careCount = phieuRepository.countByMaNVThucHienAndTrangThaiDichVuIn(e.getMaNV(), activeCareStatuses);
            int total = (int) (bookingCount + careCount);
            e.setSoCaDangLam(total);
            if (total == 0) {
                e.setTrangThaiLamViec("Đang rảnh");
            } else {
                e.setTrangThaiLamViec("Đang làm");
            }
        }
        return list;
    }

    public List<Employee> getAllEmployeesWithWorkload() {
        List<Employee> list = getAllEmployees();
        List<String> activeBookingStatuses = List.of("Đã xác nhận", "Đang thực hiện");
        List<String> activeCareStatuses = List.of("Chờ tiếp nhận", "Đang thực hiện");

        for (Employee e : list) {
            long bookingCount = bookingRepository.countByMaNVAndTrangThaiIn(e.getMaNV(), activeBookingStatuses);
            long careCount = phieuRepository.countByMaNVThucHienAndTrangThaiDichVuIn(e.getMaNV(), activeCareStatuses);
            int total = (int) (bookingCount + careCount);
            e.setSoCaDangLam(total);
            if (total == 0) {
                e.setTrangThaiLamViec("Đang rảnh");
            } else {
                e.setTrangThaiLamViec("Đang làm");
            }
        }
        return list;
    }

    public java.util.Map<String, Long> getStaffWorkloadStats(List<Employee> employees) {
        long vetFree = employees.stream()
                .filter(e -> e.getRole() != null && "Bác sĩ thú y".equalsIgnoreCase(e.getRole().getTenVaiTro()) && e.getSoCaDangLam() == 0)
                .count();
        long vetBusy = employees.stream()
                .filter(e -> e.getRole() != null && "Bác sĩ thú y".equalsIgnoreCase(e.getRole().getTenVaiTro()) && e.getSoCaDangLam() > 0)
                .count();
        long careFree = employees.stream()
                .filter(e -> (e.getRole() == null || !"Bác sĩ thú y".equalsIgnoreCase(e.getRole().getTenVaiTro())) && e.getSoCaDangLam() == 0)
                .count();
        long careBusy = employees.stream()
                .filter(e -> (e.getRole() == null || !"Bác sĩ thú y".equalsIgnoreCase(e.getRole().getTenVaiTro())) && e.getSoCaDangLam() > 0)
                .count();

        java.util.Map<String, Long> stats = new java.util.HashMap<>();
        stats.put("vetFree", vetFree);
        stats.put("vetBusy", vetBusy);
        stats.put("careFree", careFree);
        stats.put("careBusy", careBusy);
        return stats;
    }

    public Optional<Employee> getEmployeeById(Integer id) {
        return employeeRepository.findById(id);
    }

    public Employee saveEmployee(Employee employee) {
        if (employee.getTrangThai() == null || employee.getTrangThai().isBlank()) {
            employee.setTrangThai("Đang làm việc");
        }
        if (employee.getMatKhau() == null || employee.getMatKhau().isBlank()) {
            employee.setMatKhau("123456");
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
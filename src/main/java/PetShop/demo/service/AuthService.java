package PetShop.demo.service;

import PetShop.demo.model.enity.Customer;
import PetShop.demo.model.enity.Employee;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.repository.EmployeeRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@Service
public class AuthService {
    @Autowired private CustomerRepository customerRepository;
    @Autowired private EmployeeRepository employeeRepository;
    @Autowired @org.springframework.context.annotation.Lazy private MembershipService membershipService;

    public String hashPassword(String password) {
        if (password == null) return null;
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return password;
        }
    }

    public Customer loginCustomer(String email, String password, HttpSession session) {
        // Hỗ trợ cả mật khẩu nguyên bản (dữ liệu cũ) và mật khẩu băm SHA-256
        var customerOpt = customerRepository.findFirstByEmailAndMatKhau(email, password);
        if (customerOpt.isEmpty()) {
            String hashed = hashPassword(password);
            customerOpt = customerRepository.findFirstByEmailAndMatKhau(email, hashed);
        }

        if (customerOpt.isPresent()) {
            Customer c = customerOpt.get();
            session.setAttribute("maKH", c.getMaKH());
            session.setAttribute("tenKH", c.getTenKH());
            session.setAttribute("email", c.getEmail());
            session.setAttribute("role", "KhachHang");
            membershipService.updateSessionMembership(session, c);
            return c;
        }
        return null;
    }

    public Employee loginEmployee(Integer maNV, String password, HttpSession session) {
        var empOpt = employeeRepository.findByMaNVAndMatKhau(maNV, password);
        if (empOpt.isEmpty()) {
            String hashed = hashPassword(password);
            empOpt = employeeRepository.findByMaNVAndMatKhau(maNV, hashed);
        }

        if (empOpt.isPresent()) {
            Employee e = empOpt.get();
            session.setAttribute("maNV", e.getMaNV());
            session.setAttribute("tenNV", e.getTenNV());
            String roleName = (e.getRole() != null) ? e.getRole().getTenVaiTro() : "NhanVien";
            session.setAttribute("role", roleName);
            return e;
        }
        return null;
    }

    public boolean changeCustomerPassword(Integer maKH, String oldPassword, String newPassword) {
        if (maKH == null || oldPassword == null || newPassword == null) return false;
        var custOpt = customerRepository.findById(maKH);
        if (custOpt.isEmpty()) return false;
        Customer c = custOpt.get();
        String currentStored = c.getMatKhau();
        String hashedOld = hashPassword(oldPassword);
        boolean matches = (currentStored != null) && (currentStored.equals(oldPassword) || currentStored.equalsIgnoreCase(hashedOld));
        if (!matches) {
            return false;
        }
        c.setMatKhau(hashPassword(newPassword));
        customerRepository.save(c);
        return true;
    }

    public boolean changeEmployeePassword(Integer maNV, String oldPassword, String newPassword) {
        if (maNV == null || oldPassword == null || newPassword == null) return false;
        var empOpt = employeeRepository.findById(maNV);
        if (empOpt.isEmpty()) return false;
        Employee e = empOpt.get();
        String currentStored = e.getMatKhau();
        String hashedOld = hashPassword(oldPassword);
        boolean matches = (currentStored != null) && (currentStored.equals(oldPassword) || currentStored.equalsIgnoreCase(hashedOld));
        if (!matches) {
            return false;
        }
        e.setMatKhau(hashPassword(newPassword));
        employeeRepository.save(e);
        return true;
    }

    public void logout(HttpSession session) {
        session.invalidate();
    }

    public boolean isAdmin(HttpSession session) {
        Object role = session.getAttribute("role");
        return role != null && role.toString().equals("Admin");
    }

    public boolean isDoctor(HttpSession session) {
        Object role = session.getAttribute("role");
        if (role == null) return false;
        String roleStr = role.toString().trim();
        return "Bác sĩ thú y".equalsIgnoreCase(roleStr) || "Bác sĩ".equalsIgnoreCase(roleStr) || "Doctor".equalsIgnoreCase(roleStr);
    }

    public boolean isCashier(HttpSession session) {
        Object role = session.getAttribute("role");
        if (role == null) return false;
        String roleStr = role.toString().trim();
        return "Thu ngân".equalsIgnoreCase(roleStr) || 
               "Nhân viên thu ngân".equalsIgnoreCase(roleStr) || 
               "Nhân viên bán hàng".equalsIgnoreCase(roleStr) || 
               "Cashier".equalsIgnoreCase(roleStr);
    }

    public boolean canManageCareTickets(HttpSession session) {
        return isAdmin(session) || isCashier(session);
    }

    public boolean canViewTreatment(HttpSession session) {
        return isAdmin(session) || isDoctor(session);
    }

    public boolean isLoggedIn(HttpSession session) {
        return session.getAttribute("role") != null;
    }
}
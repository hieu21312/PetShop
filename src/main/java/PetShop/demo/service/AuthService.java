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

    public String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    public Customer loginCustomer(String email, String password, HttpSession session) {

        var customerOpt = customerRepository.findFirstByEmailAndMatKhau(email, password);
        if (customerOpt.isPresent()) {
            Customer c = customerOpt.get();
            session.setAttribute("maKH", c.getMaKH());
            session.setAttribute("tenKH", c.getTenKH());
            session.setAttribute("email", c.getEmail());
            session.setAttribute("role", "KhachHang");
            return c;
        }
        return null;
    }

    public Employee loginEmployee(Integer maNV, String password, HttpSession session) {
        var empOpt = employeeRepository.findByMaNVAndMatKhau(maNV, password);
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

    public void logout(HttpSession session) {
        session.invalidate();
    }

    public boolean isAdmin(HttpSession session) {
        Object role = session.getAttribute("role");
        return role != null && role.toString().equals("Admin");
    }

    public boolean isLoggedIn(HttpSession session) {
        return session.getAttribute("role") != null;
    }
}
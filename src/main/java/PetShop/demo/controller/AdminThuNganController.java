package PetShop.demo.controller;

import PetShop.demo.model.enity.ChiTietHoaDonDichVu;
import PetShop.demo.model.enity.Customer;
import PetShop.demo.model.enity.Employee;
import PetShop.demo.model.enity.HoaDonDichVu;
import PetShop.demo.model.enity.PetService;
import PetShop.demo.repository.ChiTietHoaDonDichVuRepository;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.repository.EmployeeRepository;
import PetShop.demo.repository.HoaDonDichVuRepository;
import PetShop.demo.repository.PetServiceRepository;
import PetShop.demo.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/thu-ngan")
public class AdminThuNganController {

    @Autowired
    private PetServiceRepository petServiceRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private HoaDonDichVuRepository hoaDonDichVuRepository;

    @Autowired
    private ChiTietHoaDonDichVuRepository chiTietHoaDonDichVuRepository;

    @Autowired
    private AuthService authService;

    /**
     * Màn hình Quầy Thu ngân - Bán dịch vụ & POS
     */
    @GetMapping
    public String showCashierScreen(Model model, HttpSession session) {
        // Kiểm tra quyền: Admin hoặc Thu ngân / Nhân viên bán hàng
        if (!authService.isLoggedIn(session) || (!authService.isAdmin(session) && !authService.isCashier(session))) {
            return "redirect:/DangNhap";
        }

        // Lấy danh sách dịch vụ đang cung cấp
        List<PetService> services = petServiceRepository.findAll();
        model.addAttribute("services", services);

        // Lấy danh sách khách hàng để chọn nhanh
        List<Customer> customers = customerRepository.findAll();
        model.addAttribute("customers", customers);

        // Lấy danh sách nhân viên phục vụ / thu ngân
        List<Employee> employees = employeeRepository.findAll();
        model.addAttribute("employees", employees);

        // Lấy danh sách hóa đơn gần đây
        List<HoaDonDichVu> recentInvoices = hoaDonDichVuRepository.findAllByOrderByNgaySuDungDesc();
        if (recentInvoices.size() > 10) {
            recentInvoices = recentInvoices.subList(0, 10);
        }
        model.addAttribute("recentInvoices", recentInvoices);

        // Thông tin nhân viên hiện tại đang trực thu ngân
        Integer currentMaNV = (Integer) session.getAttribute("maNV");
        String currentTenNV = (String) session.getAttribute("tenNV");
        model.addAttribute("currentMaNV", currentMaNV);
        model.addAttribute("currentTenNV", currentTenNV != null ? currentTenNV : "Thu ngân trực ca");

        return "admin/thu-ngan";
    }

    /**
     * Màn hình Xuất & In Hóa Đơn Dịch Vụ
     * GET /admin/thu-ngan/hoa-don/{id}
     */
    @GetMapping("/hoa-don/{id}")
    public String viewInvoiceDetail(@PathVariable("id") Integer id, Model model, HttpSession session) {
        if (!authService.isLoggedIn(session) || (!authService.isAdmin(session) && !authService.isCashier(session))) {
            return "redirect:/DangNhap";
        }

        Optional<HoaDonDichVu> hdOpt = hoaDonDichVuRepository.findById(id);
        if (hdOpt.isEmpty()) {
            return "redirect:/admin/thu-ngan";
        }

        HoaDonDichVu hd = hdOpt.get();
        model.addAttribute("hoaDon", hd);

        boolean isDaThanhToan = HoaDonDichVu.TRANG_THAI_DA_THANH_TOAN.equalsIgnoreCase(hd.getTrangThai());
        model.addAttribute("isDaThanhToan", isDaThanhToan);

        // Thông tin khách hàng
        if (hd.getMaKH() != null) {
            customerRepository.findById(hd.getMaKH()).ifPresent(c -> model.addAttribute("customer", c));
        }

        // Thông tin nhân viên thực hiện / lập phiếu
        if (hd.getMaNV() != null) {
            employeeRepository.findById(hd.getMaNV()).ifPresent(e -> model.addAttribute("employee", e));
        }

        // Danh sách dịch vụ chi tiết trong hóa đơn
        List<ChiTietHoaDonDichVu> details = chiTietHoaDonDichVuRepository.findById_MaHDDV(hd.getMaHDDV());
        model.addAttribute("details", details);

        return "admin/hoa-don-detail";
    }

    /**
     * Xác nhận thanh toán trực tiếp từ trang chi tiết hóa đơn (cho các đơn Chưa thanh toán)
     * POST /admin/thu-ngan/hoa-don/{id}/xac-nhan
     */
    @PostMapping("/hoa-don/{id}/xac-nhan")
    public String confirmPaymentFromDetail(@PathVariable("id") Integer id,
                                           @RequestParam(name = "phuongThuc", required = false, defaultValue = "TienMat") String phuongThuc,
                                           HttpSession session) {
        if (!authService.isLoggedIn(session) || (!authService.isAdmin(session) && !authService.isCashier(session))) {
            return "redirect:/DangNhap";
        }

        Optional<HoaDonDichVu> hdOpt = hoaDonDichVuRepository.findById(id);
        if (hdOpt.isPresent()) {
            HoaDonDichVu hd = hdOpt.get();
            hd.setTrangThai(HoaDonDichVu.TRANG_THAI_DA_THANH_TOAN);
            if (hd.getPhuongThucThanhToan() == null || hd.getPhuongThucThanhToan().isBlank()) {
                hd.setPhuongThucThanhToan(phuongThuc);
            }
            // Gán nhân viên thu ngân xác nhận nếu chưa có
            if (hd.getMaNV() == null) {
                Integer currentMaNV = (Integer) session.getAttribute("maNV");
                if (currentMaNV != null) {
                    hd.setMaNV(currentMaNV);
                }
            }
            hoaDonDichVuRepository.save(hd);
        }

        return "redirect:/admin/thu-ngan/hoa-don/" + id;
    }
}

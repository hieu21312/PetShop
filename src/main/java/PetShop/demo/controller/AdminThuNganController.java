package PetShop.demo.controller;

import PetShop.demo.model.dto.DichVuChoThanhToanDTO;
import PetShop.demo.model.enity.ChiTietHoaDonDichVu;
import PetShop.demo.model.enity.Customer;
import PetShop.demo.model.enity.Employee;
import PetShop.demo.model.enity.HoaDonDichVu;
import PetShop.demo.model.enity.Order;
import PetShop.demo.model.enity.PetService;
import PetShop.demo.repository.ChiTietHoaDonDichVuRepository;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.repository.EmployeeRepository;
import PetShop.demo.repository.HoaDonDichVuRepository;
import PetShop.demo.repository.OrderRepository;
import PetShop.demo.repository.PetServiceRepository;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.HoaDonDichVuService;
import PetShop.demo.service.MembershipService;
import PetShop.demo.service.ThongBaoService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
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
    private HoaDonDichVuService hoaDonDichVuService;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private ThongBaoService thongBaoService;

    @Autowired
    private MembershipService membershipService;

    @Autowired
    private AuthService authService;

    /**
     * Màn hình Quầy Thu ngân - Bán dịch vụ & POS & Xác nhận đơn hàng online
     */
    @GetMapping
    public String showCashierScreen(Model model, HttpSession session) {
        // Kiểm tra quyền: Admin hoặc Thu ngân / Nhân viên bán hàng
        if (!authService.isLoggedIn(session) || (!authService.isAdmin(session) && !authService.isCashier(session))) {
            return authService.redirectUnauthorized(session);
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

        // THÔNG SUỐT DỊCH VỤ: Danh sách dịch vụ bác sĩ/nhân viên chăm sóc đã hoàn thành chờ thu ngân thanh toán
        List<DichVuChoThanhToanDTO> pendingServices = hoaDonDichVuService.getDanhSachDichVuChoThanhToan();
        model.addAttribute("pendingServices", pendingServices);
        model.addAttribute("pendingCount", pendingServices.size());

        // ĐƠN HÀNG ONLINE CHỜ XÁC NHẬN THANH TOÁN (Chuyển khoản BankTransfer / Đơn hàng mới)
        List<Order> pendingOrders = orderRepository.findPendingPaymentOrders();
        model.addAttribute("pendingOrders", pendingOrders);
        model.addAttribute("pendingOrdersCount", pendingOrders.size());

        // Thông tin nhân viên hiện tại đang trực thu ngân
        Integer currentMaNV = (Integer) session.getAttribute("maNV");
        String currentTenNV = (String) session.getAttribute("tenNV");
        model.addAttribute("currentMaNV", currentMaNV);
        model.addAttribute("currentTenNV", currentTenNV != null ? currentTenNV : "Thu ngân trực ca");

        return "admin/thu-ngan";
    }

    /**
     * Xác nhận thanh toán đơn hàng online (Chuyển khoản / Đơn hàng chờ thanh toán)
     * POST /admin/thu-ngan/don-hang/{id}/xac-nhan-thanh-toan
     */
    @PostMapping("/don-hang/{id}/xac-nhan-thanh-toan")
    public String confirmOrderPayment(@PathVariable("id") Integer id,
                                      HttpSession session,
                                      RedirectAttributes ra) {
        if (!authService.isLoggedIn(session) || (!authService.isAdmin(session) && !authService.isCashier(session))) {
            return authService.redirectUnauthorized(session);
        }

        var orderOpt = orderRepository.findById(id);
        if (orderOpt.isEmpty()) {
            ra.addFlashAttribute("error", "Không tìm thấy đơn hàng #" + id);
            return "redirect:/admin/thu-ngan?tab=orders";
        }

        Order order = orderOpt.get();
        order.setDaThanhToan(true);
        if (order.getTinhTrang() == null || order.getTinhTrang() == 1) {
            order.setTinhTrang(2); // 2 = Đã xác nhận / Chuẩn bị giao hàng
        }
        orderRepository.save(order);

        // Tự động tích điểm thành viên
        try {
            membershipService.processOrderPoints(order);
        } catch (Exception ignored) {}

        // Gửi thông báo cho khách hàng
        if (order.getMaKH() != null) {
            String formattedTotal = (order.getTongTien() != null) ? String.format("%,d", order.getTongTien().longValue()) : "0";
            thongBaoService.taoThongBaoDatLich(
                    order.getMaKH(),
                    "🎉 Xác nhận thanh toán thành công đơn hàng #" + order.getMaHD(),
                    "Thu ngân đã nhận được tiền chuyển khoản (" + formattedTotal + "đ) và xác nhận đơn hàng #" + order.getMaHD() + " thành công. Cửa hàng đang chuẩn bị sản phẩm để giao đến bạn sớm nhất!",
                    LocalDateTime.now(),
                    "DonHang",
                    "/DonHang/ChiTiet/" + order.getMaHD()
            );
        }

        ra.addFlashAttribute("success", "Đã xác nhận thanh toán thành công cho đơn hàng #" + id);
        return "redirect:/admin/thu-ngan?tab=orders";
    }

    /**
     * Màn hình Xuất & In Hóa Đơn Dịch Vụ
     * GET /admin/thu-ngan/hoa-don/{id}
     */
    @GetMapping("/hoa-don/{id}")
    public String viewInvoiceDetail(@PathVariable("id") Integer id, Model model, HttpSession session) {
        if (!authService.isLoggedIn(session) || (!authService.isAdmin(session) && !authService.isCashier(session))) {
            return authService.redirectUnauthorized(session);
        }

        Optional<HoaDonDichVu> hdOpt = hoaDonDichVuRepository.findById(id);
        if (hdOpt.isEmpty()) {
            return "redirect:/admin/thu-ngan";
        }

        HoaDonDichVu hd = hdOpt.get();
        model.addAttribute("hoaDon", hd);

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
            return authService.redirectUnauthorized(session);
        }

        hoaDonDichVuService.xacNhanThanhToan(id, phuongThuc);

        return "redirect:/admin/thu-ngan/hoa-don/" + id;
    }
}

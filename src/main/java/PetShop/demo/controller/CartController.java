package PetShop.demo.controller;

import PetShop.demo.model.enity.Voucher;
import PetShop.demo.repository.VoucherRepository;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.CartService;
import PetShop.demo.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import PetShop.demo.model.enity.Order;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@Controller
public class CartController {

    @Autowired
    private CartService cartService;

    @Autowired
    private AuthService authService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private VoucherRepository voucherRepository;

    @Autowired
    private PetShop.demo.service.BookingService bookingService;

    @Autowired
    private PetShop.demo.repository.PhieuDichVuChamSocRepository phieuDichVuChamSocRepository;

    @Autowired
    private PetShop.demo.service.ThongBaoService thongBaoService;

    // Thêm vào giỏ hàng
    @GetMapping("/ThemGioHang")
    public String addToCart(@RequestParam int iMaSP,
                            @RequestParam(required = false, defaultValue = "/") String strURL,
                            HttpSession session) {
        // Kiểm tra đăng nhập
        if (session.getAttribute("role") == null) {
            return "redirect:/DangNhap?returnUrl=" + strURL;
        }
        // Thêm vào giỏ
        cartService.addToCart(iMaSP, session);
        return "redirect:" + strURL;
    }

    // Xem giỏ hàng
    @GetMapping("/GioHang")
    public String viewCart(@RequestParam(value = "tab", required = false, defaultValue = "products") String activeTab,
                           Model model, HttpSession session) {
        model.addAttribute("cart", cartService.getCart(session));
        model.addAttribute("tongSoLuong", cartService.getTotalQuantity(session));
        model.addAttribute("tongTien", cartService.getTotalPrice(session));
        model.addAttribute("activeTab", activeTab);

        Integer customerId = (Integer) session.getAttribute("maKH");
        if (customerId != null) {
            // Load danh sách lịch đặt & phiếu dịch vụ của khách hàng
            model.addAttribute("userBookings", bookingService.getBookingsByCustomer(customerId));
            model.addAttribute("userCareTickets", phieuDichVuChamSocRepository.findByMaChuNuoi(customerId));

            // Populate thông báo vào Session để header.html hiển thị
            session.setAttribute("unreadNotifications", thongBaoService.demThongBaoChuaDoc(customerId));
            session.setAttribute("notificationList", thongBaoService.getThongBaoByCustomer(customerId));
        }

        return "cart";
    }

    // Xóa sản phẩm khỏi giỏ
    @GetMapping("/XoaGioHang")
    public String removeFromCart(@RequestParam int iMaSP, HttpSession session) {
        cartService.removeFromCart(iMaSP, session);
        return "redirect:/GioHang";
    }

    // Tăng số lượng
    @GetMapping("/TangSoLuong")
    public String increaseQuantity(@RequestParam int iMaSP, HttpSession session) {
        cartService.updateQuantity(iMaSP, 1, session);
        return "redirect:/GioHang";
    }

    // Giảm số lượng
    @GetMapping("/GiamSoLuong")
    public String decreaseQuantity(@RequestParam int iMaSP, HttpSession session) {
        cartService.updateQuantity(iMaSP, -1, session);
        return "redirect:/GioHang";
    }

    // Partial view cho số lượng giỏ hàng (hiển thị trên header)
    @GetMapping("/GioHangPartial")
    @ResponseBody
    public String cartPartial(HttpSession session) {
        return String.valueOf(cartService.getTotalQuantity(session));
    }

    // Trang thanh toán
    @GetMapping("/DatHang")
    public String checkoutPage(Model model, HttpSession session) {
        if (!authService.isLoggedIn(session)) {
            return "redirect:/DangNhap";
        }
        var cart = cartService.getCart(session);
        if (cart.isEmpty()) {
            return "redirect:/";
        }
        model.addAttribute("cart", cart);
        model.addAttribute("tongSoLuong", cartService.getTotalQuantity(session));
        model.addAttribute("tongTien", cartService.getTotalPrice(session));
        return "checkout";
    }

    // Kiểm tra mã giảm giá (AJAX)
    @PostMapping("/KiemTraMaGiamGia")
    @ResponseBody
    public Map<String, Object> checkVoucher(@RequestParam String maGiamGia, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        var voucherOpt = voucherRepository.findById(maGiamGia);
        if (voucherOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Mã giảm giá không tồn tại.");
            return response;
        }
        Voucher v = voucherOpt.get();
        LocalDate now = LocalDate.now();
        if (v.getSoLuong() <= 0) {
            response.put("success", false);
            response.put("message", "Mã giảm giá đã hết lượt sử dụng.");
        } else if (now.isBefore(v.getNgayBatDau()) || now.isAfter(v.getNgayKetThuc())) {
            response.put("success", false);
            response.put("message", "Mã giảm giá đã hết hạn hoặc chưa đến thời gian sử dụng.");
        } else {
            BigDecimal tongTien = cartService.getTotalPrice(session);
            BigDecimal phanTram = v.getPhanTramGiam().divide(BigDecimal.valueOf(100));
            BigDecimal soTienGiam = tongTien.multiply(phanTram);
            if (v.getSoTienGiamToiDa() != null && soTienGiam.compareTo(v.getSoTienGiamToiDa()) > 0) {
                soTienGiam = v.getSoTienGiamToiDa();
            }
            response.put("success", true);
            response.put("soTienGiam", soTienGiam);
            response.put("message", "Áp dụng mã thành công!");
            response.put("maGiamGia", v.getMaGiamGia());
        }
        return response;
    }

    // Xử lý đặt hàng
    @PostMapping("/DatHang")
    public String placeOrder(@RequestParam String DiaChiGiaoHang,
                             @RequestParam(value = "HinhThucThanhToan", defaultValue = "COD") String hinhThuc,
                             @RequestParam(required = false) String MaGiamGiaInput,
                             @RequestParam(required = false) BigDecimal TienGiamInput,
                             HttpSession session,
                             RedirectAttributes ra) {
        if (!authService.isLoggedIn(session)) return "redirect:/DangNhap";


        boolean daThanhToan = false;

        Order order = orderService.createOrder(DiaChiGiaoHang, daThanhToan,
                MaGiamGiaInput, TienGiamInput,
                hinhThuc, session);
        if (order == null) return "redirect:/GioHang";

        ra.addFlashAttribute("orderId", order.getMaHD());
        ra.addFlashAttribute("hinhThuc", hinhThuc);
        ra.addFlashAttribute("tongTien", order.getTongTien());
        return "redirect:/XacNhanDonHang";
    }

    // Xác nhận đơn hàng thành công
    @GetMapping("/XacNhanDonHang")
    public String orderConfirmation(@ModelAttribute("orderId") Integer orderId,
                                    @ModelAttribute("hinhThuc") String hinhThuc,
                                    @ModelAttribute("tongTien") BigDecimal tongTien,
                                    Model model) {
        model.addAttribute("orderId", orderId);
        model.addAttribute("hinhThuc", hinhThuc);
        model.addAttribute("tongTien", tongTien);
        return "order-confirmation";
    }
}
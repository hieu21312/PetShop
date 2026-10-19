package PetShop.demo.config;

import PetShop.demo.repository.OrderRepository;
import PetShop.demo.service.BookingService;
import PetShop.demo.service.ThongBaoService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.ui.Model;

@ControllerAdvice
public class GlobalModelAdvice {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private ThongBaoService thongBaoService;

    @Autowired
    private OrderRepository orderRepository;

    @ModelAttribute
    public void populateGlobalAttributes(Model model, HttpSession session) {
        // Tự động nạp số lượng lịch hẹn chờ xác nhận cho Admin trên mọi trang
        try {
            long pendingCount = bookingService.countPendingBookings();
            model.addAttribute("pendingBookingCount", pendingCount);
            session.setAttribute("pendingBookingCount", pendingCount);
        } catch (Exception e) {
            // Không làm gián đoạn request nếu DB đang khởi tạo
        }

        // Tự động nạp số lượng đơn hàng chờ thanh toán / chờ xác nhận cho Thu ngân và Admin
        try {
            long pendingOrders = orderRepository.countPendingPaymentOrders();
            model.addAttribute("pendingOrdersCount", pendingOrders);
            session.setAttribute("pendingOrdersCount", pendingOrders);
        } catch (Exception e) {
            // Không làm gián đoạn request
        }

        // Tự động đồng bộ số thông báo chưa đọc cho khách hàng hoặc nhân sự đã đăng nhập
        try {
            Integer customerId = (Integer) session.getAttribute("maKH");
            Integer employeeId = (Integer) session.getAttribute("maNV");

            if (customerId != null) {
                long unreadCount = thongBaoService.demThongBaoChuaDoc(customerId);
                model.addAttribute("unreadNotifications", unreadCount);
                session.setAttribute("unreadNotifications", unreadCount);
                session.setAttribute("notificationList", thongBaoService.getThongBaoByCustomer(customerId));
            } else if (employeeId != null) {
                long unreadCount = thongBaoService.demThongBaoStaffChuaDoc(employeeId);
                model.addAttribute("unreadNotifications", unreadCount);
                session.setAttribute("unreadNotifications", unreadCount);
                session.setAttribute("notificationList", thongBaoService.getThongBaoStaff(employeeId));
            }
        } catch (Exception e) {
            // Không làm gián đoạn request
        }
    }
}

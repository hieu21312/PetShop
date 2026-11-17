package PetShop.demo.config;

import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.repository.OrderRepository;
import PetShop.demo.service.BookingService;
import PetShop.demo.service.MembershipService;
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

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private MembershipService membershipService;

    @ModelAttribute
    public void populateGlobalAttributes(Model model, HttpSession session) {
        try {
            long pendingCount = bookingService.countPendingBookings();
            model.addAttribute("pendingBookingCount", pendingCount);
            session.setAttribute("pendingBookingCount", pendingCount);
        } catch (Exception e) {
        }

        try {
            long pendingOrders = orderRepository.countPendingPaymentOrders();
            model.addAttribute("pendingOrdersCount", pendingOrders);
            session.setAttribute("pendingOrdersCount", pendingOrders);
        } catch (Exception e) {
        }

        try {
            Integer customerId = (Integer) session.getAttribute("maKH");
            Integer employeeId = (Integer) session.getAttribute("maNV");

            if (customerId != null) {
                customerRepository.findById(customerId).ifPresent(c -> {
                    membershipService.updateSessionMembership(session, c);
                    model.addAttribute("currentCustomer", c);
                    model.addAttribute("hangThanhVien", c.getHangThanhVien());
                    model.addAttribute("diemTichLuy", c.getDiemTichLuy());
                    model.addAttribute("phanTramGiamHang", membershipService.getDiscountPercentage(c.getHangThanhVien()));
                });

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
        }
    }
}

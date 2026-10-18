package PetShop.demo.controller;

import PetShop.demo.service.ThongBaoService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ThongBaoController {

    @Autowired
    private ThongBaoService thongBaoService;

    @GetMapping("/ThongBao/xem/{id}")
    public String xemThongBao(@PathVariable Integer id,
                              @RequestParam(required = false, defaultValue = "/GioHang?tab=services") String redirect,
                              HttpSession session) {
        thongBaoService.danhDauDaDoc(id);

        if (session != null) {
            Integer customerId = (Integer) session.getAttribute("maKH");
            if (customerId != null) {
                long unreadCount = thongBaoService.demThongBaoChuaDoc(customerId);
                session.setAttribute("unreadNotifications", unreadCount);
                session.setAttribute("notificationList", thongBaoService.getThongBaoByCustomer(customerId));
            }
        }

        // Đảm bảo redirect URL an toàn (bắt đầu bằng /)
        if (redirect == null || !redirect.startsWith("/")) {
            redirect = "/GioHang?tab=services";
        }
        return "redirect:" + redirect;
    }
}

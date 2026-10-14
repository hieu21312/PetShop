package PetShop.demo.controller;

import PetShop.demo.service.ThongBaoService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
public class ThongBaoController {

    @Autowired
    private ThongBaoService thongBaoService;

    @GetMapping("/ThongBao/Doc/{id}")
    public String markAsReadAndRedirect(@PathVariable Integer id,
                                        @RequestParam(required = false) String target,
                                        HttpSession session) {
        thongBaoService.danhDauDaDoc(id);
        Integer customerId = (Integer) session.getAttribute("maKH");
        if (customerId != null) {
            long unreadCount = thongBaoService.demThongBaoChuaDoc(customerId);
            session.setAttribute("unreadNotifications", unreadCount);
            session.setAttribute("notificationList", thongBaoService.getThongBaoByCustomer(customerId));
        }

        if (target != null && !target.isBlank()) {
            return "redirect:" + target;
        }
        return "redirect:/GioHang?tab=services";
    }

    @GetMapping("/ThongBao/DocTatCa")
    public String markAllAsReadAndRedirect(@RequestParam(required = false) String target,
                                          HttpSession session) {
        Integer customerId = (Integer) session.getAttribute("maKH");
        if (customerId != null) {
            thongBaoService.danhDauTatCaDaDoc(customerId);
            session.setAttribute("unreadNotifications", 0L);
            session.setAttribute("notificationList", thongBaoService.getThongBaoByCustomer(customerId));
        }

        if (target != null && !target.isBlank()) {
            return "redirect:" + target;
        }
        return "redirect:/GioHang?tab=services";
    }

    @PostMapping("/api/thongbao/doc/{id}")
    @ResponseBody
    public Map<String, Object> markAsReadApi(@PathVariable Integer id, HttpSession session) {
        thongBaoService.danhDauDaDoc(id);
        Integer customerId = (Integer) session.getAttribute("maKH");
        long unreadCount = 0;
        if (customerId != null) {
            unreadCount = thongBaoService.demThongBaoChuaDoc(customerId);
            session.setAttribute("unreadNotifications", unreadCount);
            session.setAttribute("notificationList", thongBaoService.getThongBaoByCustomer(customerId));
        }
        return Map.of("success", true, "unreadCount", unreadCount);
    }

    @PostMapping("/api/thongbao/doc-tat-ca")
    @ResponseBody
    public Map<String, Object> markAllAsReadApi(HttpSession session) {
        Integer customerId = (Integer) session.getAttribute("maKH");
        if (customerId != null) {
            thongBaoService.danhDauTatCaDaDoc(customerId);
            session.setAttribute("unreadNotifications", 0L);
            session.setAttribute("notificationList", thongBaoService.getThongBaoByCustomer(customerId));
        }
        return Map.of("success", true, "unreadCount", 0);
    }
}

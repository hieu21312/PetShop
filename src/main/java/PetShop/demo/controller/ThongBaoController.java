package PetShop.demo.controller;

import PetShop.demo.model.enity.ThongBao;
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
                              @RequestParam(required = false) String redirect,
                              HttpSession session) {
        ThongBao tb = thongBaoService.danhDauDaDoc(id);

        if (session != null) {
            Integer customerId = (Integer) session.getAttribute("maKH");
            Integer employeeId = (Integer) session.getAttribute("maNV");
            if (customerId != null) {
                long unreadCount = thongBaoService.demThongBaoChuaDoc(customerId);
                session.setAttribute("unreadNotifications", unreadCount);
                session.setAttribute("notificationList", thongBaoService.getThongBaoByCustomer(customerId));
            } else if (employeeId != null) {
                long unreadCount = thongBaoService.demThongBaoStaffChuaDoc(employeeId);
                session.setAttribute("unreadNotifications", unreadCount);
                session.setAttribute("notificationList", thongBaoService.getThongBaoStaff(employeeId));
            }
        }

        String targetUrl = redirect;
        boolean isDefaultFallback = (targetUrl == null || targetUrl.trim().isEmpty() || !targetUrl.startsWith("/") || targetUrl.equals("/GioHang?tab=services"));

        // Nếu thông báo có link riêng hợp lệ thì luôn ưu tiên link của thông báo
        if (tb != null && tb.getLienKet() != null && !tb.getLienKet().trim().isEmpty()) {
            targetUrl = tb.getLienKet();
        } else if (isDefaultFallback) {
            boolean isOrder = tb != null && ("DonHang".equalsIgnoreCase(tb.getLoaiThongBao())
                    || "HuyDon".equalsIgnoreCase(tb.getLoaiThongBao())
                    || (tb.getTieuDe() != null && (tb.getTieuDe().toLowerCase().contains("đơn hàng") || tb.getTieuDe().toLowerCase().contains("don hang"))));

            if (isOrder) {
                Integer orderId = null;
                if (tb.getTieuDe() != null && tb.getTieuDe().contains("#")) {
                    try {
                        String s = tb.getTieuDe().substring(tb.getTieuDe().indexOf("#") + 1).replaceAll("[^0-9]", " ").trim();
                        if (!s.isEmpty()) {
                            orderId = Integer.parseInt(s.split("\s+")[0]);
                        }
                    } catch (Exception ignored) {}
                }
                targetUrl = (orderId != null) ? ("/DonHang/ChiTiet/" + orderId) : "/DonHang/CuaToi";
            } else if (session != null && session.getAttribute("maNV") != null) {
                targetUrl = "/admin/thu-ngan?tab=orders";
            } else {
                targetUrl = "/GioHang?tab=services";
            }
        }
        return "redirect:" + targetUrl;
    }
}

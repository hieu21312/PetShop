package PetShop.demo.api;

import PetShop.demo.model.enity.ThongBao;
import PetShop.demo.service.ThongBaoService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@RestController
@RequestMapping(value = "/api/notifications", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
@CrossOrigin(origins = "*")
public class NotificationApiController {

    @Autowired
    private ThongBaoService thongBaoService;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    // Lấy danh sách thông báo của khách hàng hoặc nhân viên
    @GetMapping
    public ResponseEntity<?> getNotifications(@RequestParam(required = false) Integer maKH, HttpSession session) {
        Integer employeeId = (session != null) ? (Integer) session.getAttribute("maNV") : null;
        if (maKH == null && session != null) {
            maKH = (Integer) session.getAttribute("maKH");
        }

        List<ThongBao> list;
        if (maKH != null) {
            list = thongBaoService.getThongBaoByCustomer(maKH);
            // Nếu khách chưa có thông báo nào, tự động tạo 1 thông báo chào mừng & ưu đãi
            if (list.isEmpty()) {
                thongBaoService.taoThongBaoDatLich(
                        maKH,
                        "🎉 Chào mừng bạn đến với PetShop!",
                        "Cảm ơn bạn đã sử dụng ứng dụng PetShop Mobile. Nhận ngay ưu đãi tích điểm cho mỗi đơn hàng!",
                        LocalDateTime.now(),
                        "KhuyenMai"
                );
                list = thongBaoService.getThongBaoByCustomer(maKH);
            }
        } else if (employeeId != null) {
            list = thongBaoService.getThongBaoStaff(employeeId);
        } else {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (ThongBao tb : list) {
            Map<String, Object> map = new HashMap<>();
            map.put("maThongBao", tb.getMaThongBao());
            map.put("tieuDe", tb.getTieuDe());
            map.put("noiDung", tb.getNoiDung());
            map.put("loaiThongBao", tb.getLoaiThongBao());
            map.put("lienKet", tb.getLienKet());
            map.put("ngayTao", tb.getNgayTao() != null ? tb.getNgayTao().format(FORMATTER) : "");
            map.put("ngayHen", tb.getNgayHen() != null ? tb.getNgayHen().format(FORMATTER) : null);
            map.put("trangThai", tb.getTrangThai());
            map.put("isRead", "Đã đọc".equalsIgnoreCase(tb.getTrangThai()));
            result.add(map);
        }

        return ResponseEntity.ok(result);
    }

    // Đếm số thông báo chưa đọc
    @GetMapping("/unread-count")
    public ResponseEntity<?> getUnreadCount(@RequestParam(required = false) Integer maKH, HttpSession session) {
        Integer employeeId = (session != null) ? (Integer) session.getAttribute("maNV") : null;
        if (maKH == null && session != null) {
            maKH = (Integer) session.getAttribute("maKH");
        }
        long count = 0;
        if (maKH != null) {
            count = thongBaoService.demThongBaoChuaDoc(maKH);
        } else if (employeeId != null) {
            count = thongBaoService.demThongBaoStaffChuaDoc(employeeId);
        }
        return ResponseEntity.ok(Map.of("unreadCount", count));
    }

    // Đánh dấu 1 thông báo đã đọc
    @RequestMapping(value = "/{id}/read", method = {RequestMethod.POST, RequestMethod.GET})
    public ResponseEntity<?> markAsRead(@PathVariable Integer id, HttpSession session) {
        thongBaoService.danhDauDaDoc(id);

        long unreadCount = 0;
        if (session != null) {
            Integer customerId = (Integer) session.getAttribute("maKH");
            Integer employeeId = (Integer) session.getAttribute("maNV");
            if (customerId != null) {
                unreadCount = thongBaoService.demThongBaoChuaDoc(customerId);
                session.setAttribute("unreadNotifications", unreadCount);
                session.setAttribute("notificationList", thongBaoService.getThongBaoByCustomer(customerId));
            } else if (employeeId != null) {
                unreadCount = thongBaoService.demThongBaoStaffChuaDoc(employeeId);
                session.setAttribute("unreadNotifications", unreadCount);
                session.setAttribute("notificationList", thongBaoService.getThongBaoStaff(employeeId));
            }
        }

        return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Đã đánh dấu đã đọc",
                "unreadCount", unreadCount
        ));
    }

    // Đánh dấu tất cả đã đọc
    @PostMapping("/read-all")
    public ResponseEntity<?> markAllAsRead(@RequestParam(required = false) Integer maKH, HttpSession session) {
        Integer employeeId = (session != null) ? (Integer) session.getAttribute("maNV") : null;
        if (maKH == null && session != null) {
            maKH = (Integer) session.getAttribute("maKH");
        }

        if (maKH != null) {
            thongBaoService.danhDauTatCaDaDoc(maKH);
            if (session != null) {
                session.setAttribute("unreadNotifications", 0L);
                session.setAttribute("notificationList", thongBaoService.getThongBaoByCustomer(maKH));
            }
        } else if (employeeId != null) {
            thongBaoService.danhDauTatCaStaffDaDoc(employeeId);
            if (session != null) {
                session.setAttribute("unreadNotifications", 0L);
                session.setAttribute("notificationList", thongBaoService.getThongBaoStaff(employeeId));
            }
        }

        return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Đã đánh dấu tất cả đã đọc",
                "unreadCount", 0
        ));
    }
}

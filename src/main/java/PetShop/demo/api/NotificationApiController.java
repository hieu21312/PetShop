package PetShop.demo.api;

import PetShop.demo.model.enity.ThongBao;
import PetShop.demo.service.ThongBaoService;
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

    // Lấy danh sách thông báo của khách hàng
    @GetMapping
    public ResponseEntity<?> getNotifications(@RequestParam Integer maKH) {
        List<ThongBao> list = thongBaoService.getThongBaoByCustomer(maKH);

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

        List<Map<String, Object>> result = new ArrayList<>();
        for (ThongBao tb : list) {
            Map<String, Object> map = new HashMap<>();
            map.put("maThongBao", tb.getMaThongBao());
            map.put("tieuDe", tb.getTieuDe());
            map.put("noiDung", tb.getNoiDung());
            map.put("loaiThongBao", tb.getLoaiThongBao());
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
    public ResponseEntity<?> getUnreadCount(@RequestParam Integer maKH) {
        long count = thongBaoService.demThongBaoChuaDoc(maKH);
        return ResponseEntity.ok(Map.of("unreadCount", count));
    }

    // Đánh dấu 1 thông báo đã đọc
    @PostMapping("/{id}/read")
    public ResponseEntity<?> markAsRead(@PathVariable Integer id) {
        thongBaoService.dánhDauDaDoc(id);
        return ResponseEntity.ok(Map.of("success", true, "message", "Đã đánh dấu đã đọc"));
    }

    // Đánh dấu tất cả đã đọc
    @PostMapping("/read-all")
    public ResponseEntity<?> markAllAsRead(@RequestParam Integer maKH) {
        List<ThongBao> unread = thongBaoService.getThongBaoChuaDoc(maKH);
        for (ThongBao tb : unread) {
            thongBaoService.dánhDauDaDoc(tb.getMaThongBao());
        }
        return ResponseEntity.ok(Map.of("success", true, "message", "Đã đánh dấu tất cả đã đọc"));
    }
}

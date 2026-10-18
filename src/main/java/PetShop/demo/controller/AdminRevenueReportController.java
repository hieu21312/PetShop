package PetShop.demo.controller;

import PetShop.demo.model.dto.RevenueReportDTO;
import PetShop.demo.service.AuthService;
import PetShop.demo.service.RevenueReportService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;

@Controller
@RequestMapping("/admin/reports")
public class AdminRevenueReportController {

    @Autowired
    private RevenueReportService revenueReportService;

    @Autowired
    private AuthService authService;

    @GetMapping
    public String viewReport(@RequestParam(value = "type", defaultValue = "day") String type,
                             @RequestParam(value = "date", required = false) String date,
                             @RequestParam(value = "month", required = false) String month,
                             @RequestParam(value = "year", required = false) Integer year,
                             @RequestParam(value = "from", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
                             @RequestParam(value = "to", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
                             Model model, HttpSession session) {
        if (!authService.isAdmin(session)) {
            return authService.redirectUnauthorized(session);
        }

        RevenueReportDTO report = revenueReportService.generateReport(type, date, month, year, from, to);
        model.addAttribute("report", report);
        return "admin/revenue-report";
    }

    @GetMapping("/export-csv")
    public void exportCsv(@RequestParam(value = "type", defaultValue = "day") String type,
                          @RequestParam(value = "date", required = false) String date,
                          @RequestParam(value = "month", required = false) String month,
                          @RequestParam(value = "year", required = false) Integer year,
                          @RequestParam(value = "from", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
                          @RequestParam(value = "to", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
                          jakarta.servlet.http.HttpServletResponse response,
                          HttpSession session) throws java.io.IOException {
        if (!authService.isAdmin(session)) {
            response.sendRedirect(authService.isLoggedIn(session) ? "/admin" : "/DangNhap");
            return;
        }

        RevenueReportDTO report = revenueReportService.generateReport(type, date, month, year, from, to);
        response.setContentType("text/csv; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"BaoCaoDoanhThu_PetShop.csv\"");

        var writer = response.getWriter();
        writer.write('\ufeff'); // UTF-8 BOM for Excel

        writer.println("BÁO CÁO DOANH THU HỆ THỐNG PETSHOP");
        writer.println("Thời gian báo cáo: " + report.getSelectedTimeLabel());
        writer.println("Tổng doanh thu: " + (report.getTongDoanhThuHopNhat() != null ? report.getTongDoanhThuHopNhat().toString() : "0") + " VND");
        writer.println("Doanh thu bán hàng: " + (report.getTongDoanhThuSanPham() != null ? report.getTongDoanhThuSanPham().toString() : "0") + " VND (" + report.getSoDonHangSanPham() + " đơn)");
        writer.println("Doanh thu dịch vụ: " + (report.getTongDoanhThuDichVu() != null ? report.getTongDoanhThuDichVu().toString() : "0") + " VND (" + report.getSoPhieuDichVu() + " phiếu)");
        writer.println();

        writer.println("CHI TIẾT THEO MỐC THỜI GIAN");
        writer.println("Thời gian,Doanh thu bán hàng (VND),Doanh thu dịch vụ (VND),Tổng cộng (VND)");
        if (report.getBreakdownList() != null) {
            for (var b : report.getBreakdownList()) {
                writer.println(String.format("\"%s\",%s,%s,%s",
                        b.getPeriodLabel(),
                        b.getProductRevenue() != null ? b.getProductRevenue() : "0",
                        b.getServiceRevenue() != null ? b.getServiceRevenue() : "0",
                        b.getTotalRevenue() != null ? b.getTotalRevenue() : "0"));
            }
        }
        writer.flush();
    }
}

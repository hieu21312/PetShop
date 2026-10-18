package PetShop.demo.service;

import PetShop.demo.model.dto.RevenueReportDTO;
import PetShop.demo.model.dto.RevenueReportDTO.PeriodStat;
import PetShop.demo.model.enity.Order;
import PetShop.demo.model.enity.PhieuDichVuChamSoc;
import PetShop.demo.repository.OrderRepository;
import PetShop.demo.repository.PhieuDichVuChamSocRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.*;

@Service
public class RevenueReportService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private PhieuDichVuChamSocRepository phieuRepository;

    private static final DateTimeFormatter DMY = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter DM = DateTimeFormatter.ofPattern("dd/MM");

    public RevenueReportDTO generateReport(String type, String dateStr, String monthStr, Integer yearVal, LocalDate fromDate, LocalDate toDate) {
        if (type == null || type.isBlank()) {
            type = "day";
        }

        RevenueReportDTO report = new RevenueReportDTO();
        report.setFilterType(type);

        LocalDate now = LocalDate.now();

        if ("year".equalsIgnoreCase(type)) {
            int year = (yearVal != null) ? yearVal : now.getYear();
            report.setSelectedYear(year);
            report.setSelectedTimeLabel("Năm " + year);

            LocalDate start = LocalDate.of(year, 1, 1);
            LocalDate end = LocalDate.of(year, 12, 31);
            processYearReport(report, year, start, end);

        } else if ("month".equalsIgnoreCase(type)) {
            YearMonth ym;
            try {
                ym = (monthStr != null && !monthStr.isBlank()) ? YearMonth.parse(monthStr) : YearMonth.from(now);
            } catch (Exception e) {
                ym = YearMonth.from(now);
            }
            report.setSelectedMonth(ym.toString());
            report.setSelectedTimeLabel("Tháng " + ym.getMonthValue() + "/" + ym.getYear());

            LocalDate start = ym.atDay(1);
            LocalDate end = ym.atEndOfMonth();
            processMonthReport(report, ym, start, end);

        } else if ("custom".equalsIgnoreCase(type)) {
            LocalDate start = (fromDate != null) ? fromDate : now.minusDays(30);
            LocalDate end = (toDate != null) ? toDate : now;
            if (start.isAfter(end)) {
                LocalDate temp = start;
                start = end;
                end = temp;
            }
            report.setCustomFrom(start.toString());
            report.setCustomTo(end.toString());
            report.setSelectedTimeLabel("Từ " + start.format(DMY) + " đến " + end.format(DMY));
            processCustomReport(report, start, end);

        } else if ("day".equalsIgnoreCase(type)) {
            LocalDate target;
            try {
                target = (dateStr != null && !dateStr.isBlank()) ? LocalDate.parse(dateStr) : now;
            } catch (Exception e) {
                target = now;
            }
            report.setSelectedDate(target.toString());
            report.setSelectedTimeLabel("Ngày " + target.format(DMY));
            processDayReport(report, target);

        } else {
            // Mặc định: Theo tuần
            report.setFilterType("week");
            LocalDate target;
            try {
                target = (dateStr != null && !dateStr.isBlank()) ? LocalDate.parse(dateStr) : now;
            } catch (Exception e) {
                target = now;
            }
            report.setSelectedDate(target.toString());

            LocalDate start = target.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
            LocalDate end = target.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
            report.setSelectedTimeLabel("Tuần từ " + start.format(DMY) + " đến " + end.format(DMY));
            processWeekReport(report, start, end);
        }

        return report;
    }

    private void processDayReport(RevenueReportDTO report, LocalDate target) {
        LocalDateTime fromTime = target.atStartOfDay();
        LocalDateTime toTime = target.atTime(LocalTime.MAX);

        List<Order> orders = orderRepository.findOrdersBetween(fromTime, toTime);
        List<PhieuDichVuChamSoc> tickets = phieuRepository.findTicketsBetween(fromTime, toTime);
        report.setOrders(orders);
        report.setTickets(tickets);

        String[] slotLabels = {"Sáng (00:00 - 12:00)", "Trưa (12:00 - 14:00)", "Chiều (14:00 - 18:00)", "Tối (18:00 - 23:59)"};
        LocalTime[][] ranges = {
                {LocalTime.of(0, 0), LocalTime.of(11, 59, 59)},
                {LocalTime.of(12, 0), LocalTime.of(13, 59, 59)},
                {LocalTime.of(14, 0), LocalTime.of(17, 59, 59)},
                {LocalTime.of(18, 0), LocalTime.of(23, 59, 59)}
        };

        for (int i = 0; i < slotLabels.length; i++) {
            String label = slotLabels[i];
            LocalTime rStart = ranges[i][0];
            LocalTime rEnd = ranges[i][1];
            report.getChartLabels().add(label);

            BigDecimal pRev = BigDecimal.ZERO;
            int pCount = 0;
            for (Order o : orders) {
                if (o.getNgayLap() != null) {
                    LocalTime t = o.getNgayLap().toLocalTime();
                    if (!t.isBefore(rStart) && !t.isAfter(rEnd)) {
                        if (o.getTongTien() != null) pRev = pRev.add(o.getTongTien());
                        pCount++;
                    }
                }
            }

            BigDecimal sRev = BigDecimal.ZERO;
            int sCount = 0;
            for (PhieuDichVuChamSoc tk : tickets) {
                if (tk.getNgayTiepNhan() != null) {
                    LocalTime t = tk.getNgayTiepNhan().toLocalTime();
                    if (!t.isBefore(rStart) && !t.isAfter(rEnd)) {
                        BigDecimal val = tk.getThanhToan() != null ? tk.getThanhToan() : tk.getTongTien();
                        if (val != null) sRev = sRev.add(val);
                        sCount++;
                    }
                }
            }

            report.getProductRevenues().add(pRev);
            report.getServiceRevenues().add(sRev);
            report.getTotalRevenues().add(pRev.add(sRev));
            report.getBreakdownList().add(new PeriodStat(label, pRev, sRev, pCount, sCount));
        }

        calculateSummary(report);
    }

    private void processWeekReport(RevenueReportDTO report, LocalDate start, LocalDate end) {
        LocalDateTime fromTime = start.atStartOfDay();
        LocalDateTime toTime = end.atTime(LocalTime.MAX);

        List<Order> orders = orderRepository.findOrdersBetween(fromTime, toTime);
        List<PhieuDichVuChamSoc> tickets = phieuRepository.findTicketsBetween(fromTime, toTime);
        report.setOrders(orders);
        report.setTickets(tickets);

        String[] dayNames = {"Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy", "Chủ Nhật"};

        for (int i = 0; i < 7; i++) {
            LocalDate d = start.plusDays(i);
            String label = dayNames[i] + " (" + d.format(DM) + ")";
            report.getChartLabels().add(label);

            BigDecimal pRev = BigDecimal.ZERO;
            int pCount = 0;
            for (Order o : orders) {
                if (o.getNgayLap() != null && o.getNgayLap().toLocalDate().isEqual(d)) {
                    if (o.getTongTien() != null) pRev = pRev.add(o.getTongTien());
                    pCount++;
                }
            }

            BigDecimal sRev = BigDecimal.ZERO;
            int sCount = 0;
            for (PhieuDichVuChamSoc t : tickets) {
                if (t.getNgayTiepNhan() != null && t.getNgayTiepNhan().toLocalDate().isEqual(d)) {
                    BigDecimal val = t.getThanhToan() != null ? t.getThanhToan() : t.getTongTien();
                    if (val != null) sRev = sRev.add(val);
                    sCount++;
                }
            }

            report.getProductRevenues().add(pRev);
            report.getServiceRevenues().add(sRev);
            report.getTotalRevenues().add(pRev.add(sRev));
            report.getBreakdownList().add(new PeriodStat(label, pRev, sRev, pCount, sCount));
        }

        calculateSummary(report);
    }

    private void processMonthReport(RevenueReportDTO report, YearMonth ym, LocalDate start, LocalDate end) {
        LocalDateTime fromTime = start.atStartOfDay();
        LocalDateTime toTime = end.atTime(LocalTime.MAX);

        List<Order> orders = orderRepository.findOrdersBetween(fromTime, toTime);
        List<PhieuDichVuChamSoc> tickets = phieuRepository.findTicketsBetween(fromTime, toTime);
        report.setOrders(orders);
        report.setTickets(tickets);

        int daysInMonth = ym.lengthOfMonth();
        for (int d = 1; d <= daysInMonth; d++) {
            LocalDate cur = ym.atDay(d);
            String label = "Ngày " + String.format("%02d", d);
            report.getChartLabels().add(label);

            BigDecimal pRev = BigDecimal.ZERO;
            int pCount = 0;
            for (Order o : orders) {
                if (o.getNgayLap() != null && o.getNgayLap().toLocalDate().isEqual(cur)) {
                    if (o.getTongTien() != null) pRev = pRev.add(o.getTongTien());
                    pCount++;
                }
            }

            BigDecimal sRev = BigDecimal.ZERO;
            int sCount = 0;
            for (PhieuDichVuChamSoc t : tickets) {
                if (t.getNgayTiepNhan() != null && t.getNgayTiepNhan().toLocalDate().isEqual(cur)) {
                    BigDecimal val = t.getThanhToan() != null ? t.getThanhToan() : t.getTongTien();
                    if (val != null) sRev = sRev.add(val);
                    sCount++;
                }
            }

            report.getProductRevenues().add(pRev);
            report.getServiceRevenues().add(sRev);
            report.getTotalRevenues().add(pRev.add(sRev));
            report.getBreakdownList().add(new PeriodStat(label + "/" + ym.getMonthValue(), pRev, sRev, pCount, sCount));
        }

        calculateSummary(report);
    }

    private void processYearReport(RevenueReportDTO report, int year, LocalDate start, LocalDate end) {
        LocalDateTime fromTime = start.atStartOfDay();
        LocalDateTime toTime = end.atTime(LocalTime.MAX);

        List<Order> orders = orderRepository.findOrdersBetween(fromTime, toTime);
        List<PhieuDichVuChamSoc> tickets = phieuRepository.findTicketsBetween(fromTime, toTime);
        report.setOrders(orders);
        report.setTickets(tickets);

        for (int m = 1; m <= 12; m++) {
            String label = "Tháng " + m;
            report.getChartLabels().add(label);

            final int monthIdx = m;
            BigDecimal pRev = BigDecimal.ZERO;
            int pCount = 0;
            for (Order o : orders) {
                if (o.getNgayLap() != null && o.getNgayLap().getYear() == year && o.getNgayLap().getMonthValue() == monthIdx) {
                    if (o.getTongTien() != null) pRev = pRev.add(o.getTongTien());
                    pCount++;
                }
            }

            BigDecimal sRev = BigDecimal.ZERO;
            int sCount = 0;
            for (PhieuDichVuChamSoc t : tickets) {
                if (t.getNgayTiepNhan() != null && t.getNgayTiepNhan().getYear() == year && t.getNgayTiepNhan().getMonthValue() == monthIdx) {
                    BigDecimal val = t.getThanhToan() != null ? t.getThanhToan() : t.getTongTien();
                    if (val != null) sRev = sRev.add(val);
                    sCount++;
                }
            }

            report.getProductRevenues().add(pRev);
            report.getServiceRevenues().add(sRev);
            report.getTotalRevenues().add(pRev.add(sRev));
            report.getBreakdownList().add(new PeriodStat("Tháng " + m + "/" + year, pRev, sRev, pCount, sCount));
        }

        calculateSummary(report);
    }

    private void processCustomReport(RevenueReportDTO report, LocalDate start, LocalDate end) {
        LocalDateTime fromTime = start.atStartOfDay();
        LocalDateTime toTime = end.atTime(LocalTime.MAX);

        List<Order> orders = orderRepository.findOrdersBetween(fromTime, toTime);
        List<PhieuDichVuChamSoc> tickets = phieuRepository.findTicketsBetween(fromTime, toTime);
        report.setOrders(orders);
        report.setTickets(tickets);

        LocalDate cur = start;
        while (!cur.isAfter(end)) {
            String label = cur.format(DM);
            report.getChartLabels().add(label);

            BigDecimal pRev = BigDecimal.ZERO;
            int pCount = 0;
            for (Order o : orders) {
                if (o.getNgayLap() != null && o.getNgayLap().toLocalDate().isEqual(cur)) {
                    if (o.getTongTien() != null) pRev = pRev.add(o.getTongTien());
                    pCount++;
                }
            }

            BigDecimal sRev = BigDecimal.ZERO;
            int sCount = 0;
            for (PhieuDichVuChamSoc t : tickets) {
                if (t.getNgayTiepNhan() != null && t.getNgayTiepNhan().toLocalDate().isEqual(cur)) {
                    BigDecimal val = t.getThanhToan() != null ? t.getThanhToan() : t.getTongTien();
                    if (val != null) sRev = sRev.add(val);
                    sCount++;
                }
            }

            report.getProductRevenues().add(pRev);
            report.getServiceRevenues().add(sRev);
            report.getTotalRevenues().add(pRev.add(sRev));
            report.getBreakdownList().add(new PeriodStat(cur.format(DMY), pRev, sRev, pCount, sCount));

            cur = cur.plusDays(1);
        }

        calculateSummary(report);
    }

    private void calculateSummary(RevenueReportDTO report) {
        BigDecimal totalProd = BigDecimal.ZERO;
        BigDecimal totalServ = BigDecimal.ZERO;
        int countProd = (report.getOrders() != null) ? report.getOrders().size() : 0;
        int countServ = (report.getTickets() != null) ? report.getTickets().size() : 0;

        if (report.getOrders() != null) {
            for (Order o : report.getOrders()) {
                if (o.getTongTien() != null) totalProd = totalProd.add(o.getTongTien());
            }
        }

        if (report.getTickets() != null) {
            for (PhieuDichVuChamSoc t : report.getTickets()) {
                BigDecimal val = t.getThanhToan() != null ? t.getThanhToan() : t.getTongTien();
                if (val != null) totalServ = totalServ.add(val);
            }
        }

        report.setTongDoanhThuSanPham(totalProd);
        report.setTongDoanhThuDichVu(totalServ);
        report.setTongDoanhThuHopNhat(totalProd.add(totalServ));
        report.setSoDonHangSanPham(countProd);
        report.setSoPhieuDichVu(countServ);
        report.setTongGiaoDich(countProd + countServ);
    }
}

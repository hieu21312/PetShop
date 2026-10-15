package PetShop.demo.service;

import PetShop.demo.model.dto.DashboardDTO;
import PetShop.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import PetShop.demo.model.enity.Order;
@Service
public class AdminService {

    @Autowired private ProductRepository productRepository;
    @Autowired private CustomerRepository customerRepository;
    @Autowired private OrderRepository orderRepository;
    @Autowired private OrderDetailRepository orderDetailRepository;
    @Autowired private DichVuChamSocRepository dichVuChamSocRepository;
    @Autowired private PhieuDichVuChamSocRepository phieuRepository;
    @Autowired private BookingRepository bookingRepository;

    public DashboardDTO getDashboardData() {
        DashboardDTO dto = new DashboardDTO();

        // 1. Thống kê Sản phẩm
        dto.setTongSanPham((int) productRepository.count());
        dto.setTongKhachHang((int) customerRepository.count());
        dto.setTongHoaDon((int) orderRepository.count());

        BigDecimal tongDoanhThu = orderRepository.findAll().stream()
                .map(Order::getTongTien)
                .filter(bb -> bb != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        dto.setTongDoanhThu(tongDoanhThu);

        // Doanh thu sản phẩm 7 ngày gần nhất
        LocalDateTime sevenDaysAgo = LocalDateTime.now().minusDays(6).with(LocalTime.MIN);
        List<Object[]> revenueData = orderRepository.getLast7DaysRevenue(sevenDaysAgo);
        List<String> labels = new ArrayList<>();
        List<BigDecimal> revenues = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            LocalDate date = LocalDate.now().minusDays(6 - i);
            labels.add(date.getDayOfMonth() + "/" + date.getMonthValue());
            BigDecimal revenue = BigDecimal.ZERO;
            for (Object[] row : revenueData) {
                if (row[0] != null && row[0].toString().equals(date.toString())) {
                    if (row[1] instanceof BigDecimal) {
                        revenue = (BigDecimal) row[1];
                    } else if (row[1] instanceof Number) {
                        revenue = BigDecimal.valueOf(((Number) row[1]).doubleValue());
                    }
                    break;
                }
            }
            revenues.add(revenue);
        }
        dto.setLabels(labels);
        dto.setRevenues(revenues);

        // Top 5 sản phẩm bán chạy
        List<Object[]> topProducts = orderDetailRepository.findTopSellingProducts();
        List<DashboardDTO.TopProductDTO> topList = topProducts.stream().limit(5)
                .map(row -> {
                    DashboardDTO.TopProductDTO tp = new DashboardDTO.TopProductDTO();
                    tp.setTenSP((String) row[0]);
                    int count = (row[1] instanceof Number) ? ((Number) row[1]).intValue() : 0;
                    tp.setSoLuongBan(count);
                    return tp;
                }).collect(Collectors.toList());
        dto.setTopProducts(topList);

        // 2. Thống kê Dịch vụ
        dto.setTongDichVu((int) dichVuChamSocRepository.count());
        dto.setTongPhieuDichVu((int) phieuRepository.count());
        dto.setTongDatLich((int) bookingRepository.count());

        BigDecimal tongDoanhThuDichVu = phieuRepository.findAll().stream()
                .map(p -> p.getThanhToan() != null ? p.getThanhToan() : p.getTongTien())
                .filter(val -> val != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        dto.setTongDoanhThuDichVu(tongDoanhThuDichVu);
        dto.setTongDoanhThuTongCong(tongDoanhThu.add(tongDoanhThuDichVu));

        // Doanh thu dịch vụ 7 ngày gần nhất
        List<Object[]> serviceRevenueData = new ArrayList<>();
        try {
            serviceRevenueData = phieuRepository.getLast7DaysRevenue(sevenDaysAgo);
        } catch (Exception e) {
            // Native query fallback
        }
        List<String> serviceLabels = new ArrayList<>();
        List<BigDecimal> serviceRevenues = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            LocalDate date = LocalDate.now().minusDays(6 - i);
            serviceLabels.add(date.getDayOfMonth() + "/" + date.getMonthValue());
            BigDecimal sRevenue = BigDecimal.ZERO;
            for (Object[] row : serviceRevenueData) {
                if (row[0] != null && row[0].toString().equals(date.toString())) {
                    if (row[1] instanceof BigDecimal) {
                        sRevenue = (BigDecimal) row[1];
                    } else if (row[1] instanceof Number) {
                        sRevenue = BigDecimal.valueOf(((Number) row[1]).doubleValue());
                    }
                    break;
                }
            }
            serviceRevenues.add(sRevenue);
        }
        dto.setServiceLabels(serviceLabels);
        dto.setServiceRevenues(serviceRevenues);

        // Top 5 dịch vụ phổ biến nhất
        List<DashboardDTO.TopServiceDTO> topServicesList = new ArrayList<>();
        try {
            List<Object[]> topServicesData = dichVuChamSocRepository.findTopServices();
            if (topServicesData != null && !topServicesData.isEmpty()) {
                topServicesList = topServicesData.stream().limit(5)
                        .map(row -> {
                            DashboardDTO.TopServiceDTO ts = new DashboardDTO.TopServiceDTO();
                            ts.setTenDV((String) row[0]);
                            int cnt = (row[1] instanceof Number) ? ((Number) row[1]).intValue() : 0;
                            ts.setSoLuotSuDung(cnt);
                            return ts;
                        }).collect(Collectors.toList());
            }
        } catch (Exception e) {
            // Fallback
        }
        if (topServicesList.isEmpty()) {
            topServicesList = dichVuChamSocRepository.findAll().stream().limit(5)
                    .map(s -> {
                        DashboardDTO.TopServiceDTO ts = new DashboardDTO.TopServiceDTO();
                        ts.setTenDV(s.getTenDichVu());
                        ts.setSoLuotSuDung(0);
                        return ts;
                    }).collect(Collectors.toList());
        }
        dto.setTopServices(topServicesList);

        return dto;
    }
}
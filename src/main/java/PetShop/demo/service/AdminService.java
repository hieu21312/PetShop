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

    public DashboardDTO getDashboardData() {
        DashboardDTO dto = new DashboardDTO();
        dto.setTongSanPham((int) productRepository.count());
        dto.setTongKhachHang((int) customerRepository.count());
        dto.setTongHoaDon((int) orderRepository.count());

        BigDecimal tongDoanhThu = orderRepository.findAll().stream()
                .map(Order::getTongTien)
                .filter(bb -> bb != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        dto.setTongDoanhThu(tongDoanhThu);

        // Doanh thu 7 ngày gần nhất
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
                    revenue = (BigDecimal) row[1];
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
                    // row[1] là Long (SUM), chuyển thành int
                    tp.setSoLuongBan(((Long) row[1]).intValue());
                    return tp;
                }).collect(Collectors.toList());
        dto.setTopProducts(topList);

        return dto;
    }
}
package PetShop.demo.model.dto;

import PetShop.demo.model.enity.Order;
import PetShop.demo.model.enity.PhieuDichVuChamSoc;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class RevenueReportDTO {

    private String filterType; // "week", "month", "year", "custom"
    private String selectedDate;
    private String selectedMonth;
    private Integer selectedYear;
    private String customFrom;
    private String customTo;
    private String selectedTimeLabel;

    // Tổng hợp doanh thu
    private BigDecimal tongDoanhThuSanPham = BigDecimal.ZERO;
    private BigDecimal tongDoanhThuDichVu = BigDecimal.ZERO;
    private BigDecimal tongDoanhThuHopNhat = BigDecimal.ZERO;
    private int soDonHangSanPham = 0;
    private int soPhieuDichVu = 0;
    private int tongGiaoDich = 0;

    // Biểu đồ
    private List<String> chartLabels = new ArrayList<>();
    private List<BigDecimal> productRevenues = new ArrayList<>();
    private List<BigDecimal> serviceRevenues = new ArrayList<>();
    private List<BigDecimal> totalRevenues = new ArrayList<>();

    // Bảng chi tiết theo từng mốc (ngày/tháng)
    private List<PeriodStat> breakdownList = new ArrayList<>();

    // Danh sách giao dịch phát sinh trong kỳ
    private List<Order> orders = new ArrayList<>();
    private List<PhieuDichVuChamSoc> tickets = new ArrayList<>();

    public RevenueReportDTO() {}

    public static class PeriodStat {
        private String periodLabel;
        private BigDecimal productRevenue = BigDecimal.ZERO;
        private BigDecimal serviceRevenue = BigDecimal.ZERO;
        private BigDecimal totalRevenue = BigDecimal.ZERO;
        private int productCount = 0;
        private int serviceCount = 0;

        public PeriodStat() {}

        public PeriodStat(String periodLabel, BigDecimal productRevenue, BigDecimal serviceRevenue, int productCount, int serviceCount) {
            this.periodLabel = periodLabel;
            this.productRevenue = productRevenue != null ? productRevenue : BigDecimal.ZERO;
            this.serviceRevenue = serviceRevenue != null ? serviceRevenue : BigDecimal.ZERO;
            this.totalRevenue = this.productRevenue.add(this.serviceRevenue);
            this.productCount = productCount;
            this.serviceCount = serviceCount;
        }

        public String getPeriodLabel() { return periodLabel; }
        public void setPeriodLabel(String periodLabel) { this.periodLabel = periodLabel; }

        public BigDecimal getProductRevenue() { return productRevenue; }
        public void setProductRevenue(BigDecimal productRevenue) { this.productRevenue = productRevenue; }

        public BigDecimal getServiceRevenue() { return serviceRevenue; }
        public void setServiceRevenue(BigDecimal serviceRevenue) { this.serviceRevenue = serviceRevenue; }

        public BigDecimal getTotalRevenue() { return totalRevenue; }
        public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }

        public int getProductCount() { return productCount; }
        public void setProductCount(int productCount) { this.productCount = productCount; }

        public int getServiceCount() { return serviceCount; }
        public void setServiceCount(int serviceCount) { this.serviceCount = serviceCount; }
    }

    // Getters and Setters
    public String getFilterType() { return filterType; }
    public void setFilterType(String filterType) { this.filterType = filterType; }

    public String getSelectedDate() { return selectedDate; }
    public void setSelectedDate(String selectedDate) { this.selectedDate = selectedDate; }

    public String getSelectedMonth() { return selectedMonth; }
    public void setSelectedMonth(String selectedMonth) { this.selectedMonth = selectedMonth; }

    public Integer getSelectedYear() { return selectedYear; }
    public void setSelectedYear(Integer selectedYear) { this.selectedYear = selectedYear; }

    public String getCustomFrom() { return customFrom; }
    public void setCustomFrom(String customFrom) { this.customFrom = customFrom; }

    public String getCustomTo() { return customTo; }
    public void setCustomTo(String customTo) { this.customTo = customTo; }

    public String getSelectedTimeLabel() { return selectedTimeLabel; }
    public void setSelectedTimeLabel(String selectedTimeLabel) { this.selectedTimeLabel = selectedTimeLabel; }

    public BigDecimal getTongDoanhThuSanPham() { return tongDoanhThuSanPham; }
    public void setTongDoanhThuSanPham(BigDecimal tongDoanhThuSanPham) { this.tongDoanhThuSanPham = tongDoanhThuSanPham; }

    public BigDecimal getTongDoanhThuDichVu() { return tongDoanhThuDichVu; }
    public void setTongDoanhThuDichVu(BigDecimal tongDoanhThuDichVu) { this.tongDoanhThuDichVu = tongDoanhThuDichVu; }

    public BigDecimal getTongDoanhThuHopNhat() { return tongDoanhThuHopNhat; }
    public void setTongDoanhThuHopNhat(BigDecimal tongDoanhThuHopNhat) { this.tongDoanhThuHopNhat = tongDoanhThuHopNhat; }

    public int getSoDonHangSanPham() { return soDonHangSanPham; }
    public void setSoDonHangSanPham(int soDonHangSanPham) { this.soDonHangSanPham = soDonHangSanPham; }

    public int getSoPhieuDichVu() { return soPhieuDichVu; }
    public void setSoPhieuDichVu(int soPhieuDichVu) { this.soPhieuDichVu = soPhieuDichVu; }

    public int getTongGiaoDich() { return tongGiaoDich; }
    public void setTongGiaoDich(int tongGiaoDich) { this.tongGiaoDich = tongGiaoDich; }

    public List<String> getChartLabels() { return chartLabels; }
    public void setChartLabels(List<String> chartLabels) { this.chartLabels = chartLabels; }

    public List<BigDecimal> getProductRevenues() { return productRevenues; }
    public void setProductRevenues(List<BigDecimal> productRevenues) { this.productRevenues = productRevenues; }

    public List<BigDecimal> getServiceRevenues() { return serviceRevenues; }
    public void setServiceRevenues(List<BigDecimal> serviceRevenues) { this.serviceRevenues = serviceRevenues; }

    public List<BigDecimal> getTotalRevenues() { return totalRevenues; }
    public void setTotalRevenues(List<BigDecimal> totalRevenues) { this.totalRevenues = totalRevenues; }

    public List<PeriodStat> getBreakdownList() { return breakdownList; }
    public void setBreakdownList(List<PeriodStat> breakdownList) { this.breakdownList = breakdownList; }

    public List<Order> getOrders() { return orders; }
    public void setOrders(List<Order> orders) { this.orders = orders; }

    public List<PhieuDichVuChamSoc> getTickets() { return tickets; }
    public void setTickets(List<PhieuDichVuChamSoc> tickets) { this.tickets = tickets; }
}

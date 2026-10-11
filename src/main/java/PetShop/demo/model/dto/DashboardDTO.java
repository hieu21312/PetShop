package PetShop.demo.model.dto;

import java.math.BigDecimal;
import java.util.List;

public class DashboardDTO {
    private int tongSanPham;
    private int tongKhachHang;
    private int tongHoaDon;
    private BigDecimal tongDoanhThu;
    private List<String> labels;
    private List<BigDecimal> revenues;
    private List<TopProductDTO> topProducts;

    // Thống kê dịch vụ
    private int tongDichVu;
    private int tongPhieuDichVu;
    private int tongDatLich;
    private BigDecimal tongDoanhThuDichVu;
    private List<String> serviceLabels;
    private List<BigDecimal> serviceRevenues;
    private List<TopServiceDTO> topServices;

    // Tổng doanh thu kết hợp (Sản phẩm + Dịch vụ)
    private BigDecimal tongDoanhThuTongCong;

    // Constructors
    public DashboardDTO() {}

    // Getters and Setters
    public int getTongSanPham() { return tongSanPham; }
    public void setTongSanPham(int tongSanPham) { this.tongSanPham = tongSanPham; }

    public int getTongKhachHang() { return tongKhachHang; }
    public void setTongKhachHang(int tongKhachHang) { this.tongKhachHang = tongKhachHang; }

    public int getTongHoaDon() { return tongHoaDon; }
    public void setTongHoaDon(int tongHoaDon) { this.tongHoaDon = tongHoaDon; }

    public BigDecimal getTongDoanhThu() { return tongDoanhThu; }
    public void setTongDoanhThu(BigDecimal tongDoanhThu) { this.tongDoanhThu = tongDoanhThu; }

    public List<String> getLabels() { return labels; }
    public void setLabels(List<String> labels) { this.labels = labels; }

    public List<BigDecimal> getRevenues() { return revenues; }
    public void setRevenues(List<BigDecimal> revenues) { this.revenues = revenues; }

    public List<TopProductDTO> getTopProducts() { return topProducts; }
    public void setTopProducts(List<TopProductDTO> topProducts) { this.topProducts = topProducts; }

    public int getTongDichVu() { return tongDichVu; }
    public void setTongDichVu(int tongDichVu) { this.tongDichVu = tongDichVu; }

    public int getTongPhieuDichVu() { return tongPhieuDichVu; }
    public void setTongPhieuDichVu(int tongPhieuDichVu) { this.tongPhieuDichVu = tongPhieuDichVu; }

    public int getTongDatLich() { return tongDatLich; }
    public void setTongDatLich(int tongDatLich) { this.tongDatLich = tongDatLich; }

    public BigDecimal getTongDoanhThuDichVu() { return tongDoanhThuDichVu; }
    public void setTongDoanhThuDichVu(BigDecimal tongDoanhThuDichVu) { this.tongDoanhThuDichVu = tongDoanhThuDichVu; }

    public List<String> getServiceLabels() { return serviceLabels; }
    public void setServiceLabels(List<String> serviceLabels) { this.serviceLabels = serviceLabels; }

    public List<BigDecimal> getServiceRevenues() { return serviceRevenues; }
    public void setServiceRevenues(List<BigDecimal> serviceRevenues) { this.serviceRevenues = serviceRevenues; }

    public List<TopServiceDTO> getTopServices() { return topServices; }
    public void setTopServices(List<TopServiceDTO> topServices) { this.topServices = topServices; }

    public BigDecimal getTongDoanhThuTongCong() { return tongDoanhThuTongCong; }
    public void setTongDoanhThuTongCong(BigDecimal tongDoanhThuTongCong) { this.tongDoanhThuTongCong = tongDoanhThuTongCong; }

    public static class TopProductDTO {
        private String tenSP;
        private int soLuongBan;

        public String getTenSP() { return tenSP; }
        public void setTenSP(String tenSP) { this.tenSP = tenSP; }

        public int getSoLuongBan() { return soLuongBan; }
        public void setSoLuongBan(int soLuongBan) { this.soLuongBan = soLuongBan; }
    }

    public static class TopServiceDTO {
        private String tenDV;
        private int soLuotSuDung;

        public String getTenDV() { return tenDV; }
        public void setTenDV(String tenDV) { this.tenDV = tenDV; }

        public int getSoLuotSuDung() { return soLuotSuDung; }
        public void setSoLuotSuDung(int soLuotSuDung) { this.soLuotSuDung = soLuotSuDung; }
    }
}
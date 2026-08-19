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

    public static class TopProductDTO {
        private String tenSP;
        private int soLuongBan;

        public String getTenSP() { return tenSP; }
        public void setTenSP(String tenSP) { this.tenSP = tenSP; }

        public int getSoLuongBan() { return soLuongBan; }
        public void setSoLuongBan(int soLuongBan) { this.soLuongBan = soLuongBan; }
    }
}
package PetShop.demo.model.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.math.BigDecimal;
import java.util.List;

public class HoaDonRequestDTO {

    @JsonProperty("maKH")
    @JsonAlias({"MaKH", "ma_kh", "customerId"})
    private Integer maKH;

    @JsonProperty("maNV")
    @JsonAlias({"MaNV", "ma_nv", "employeeId"})
    private Integer maNV;

    @JsonProperty("tongTien")
    @JsonAlias({"TongTien", "tong_tien", "totalAmount"})
    private BigDecimal tongTien;

    @JsonProperty("ghiChu")
    @JsonAlias({"GhiChu", "ghi_chu", "note", "notes"})
    private String ghiChu;

    @JsonProperty("phuongThucThanhToan")
    @JsonAlias({"PhuongThucThanhToan", "phuong_thuc_thanh_toan", "paymentMethod"})
    private String phuongThucThanhToan;

    @JsonProperty("maPhieuDV")
    @JsonAlias({"MaPhieuDV", "ma_phieu_dv", "careTicketId"})
    private Integer maPhieuDV;

    @JsonProperty("maDatLich")
    @JsonAlias({"MaDatLich", "ma_dat_lich", "bookingId"})
    private Integer maDatLich;

    @JsonProperty("soPhieu")
    @JsonAlias({"SoPhieu", "so_phieu", "maDichVu", "serviceCode"})
    private String soPhieu;

    @JsonProperty("items")
    @JsonAlias({"Items", "chiTietDichVu", "services"})
    private List<ChiTietDichVuItemDTO> items;

    public HoaDonRequestDTO() {}

    public HoaDonRequestDTO(Integer maKH, Integer maNV, BigDecimal tongTien, String ghiChu, String phuongThucThanhToan) {
        this.maKH = maKH;
        this.maNV = maNV;
        this.tongTien = tongTien;
        this.ghiChu = ghiChu;
        this.phuongThucThanhToan = phuongThucThanhToan;
    }

    public Integer getMaKH() {
        return maKH;
    }

    public void setMaKH(Integer maKH) {
        this.maKH = maKH;
    }

    public Integer getMaNV() {
        return maNV;
    }

    public void setMaNV(Integer maNV) {
        this.maNV = maNV;
    }

    public BigDecimal getTongTien() {
        return tongTien;
    }

    public void setTongTien(BigDecimal tongTien) {
        this.tongTien = tongTien;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public String getPhuongThucThanhToan() {
        return phuongThucThanhToan;
    }

    public void setPhuongThucThanhToan(String phuongThucThanhToan) {
        this.phuongThucThanhToan = phuongThucThanhToan;
    }

    public Integer getMaPhieuDV() {
        return maPhieuDV;
    }

    public void setMaPhieuDV(Integer maPhieuDV) {
        this.maPhieuDV = maPhieuDV;
    }

    public Integer getMaDatLich() {
        return maDatLich;
    }

    public void setMaDatLich(Integer maDatLich) {
        this.maDatLich = maDatLich;
    }

    public String getSoPhieu() {
        return soPhieu;
    }

    public void setSoPhieu(String soPhieu) {
        this.soPhieu = soPhieu;
    }

    public List<ChiTietDichVuItemDTO> getItems() {
        return items;
    }

    public void setItems(List<ChiTietDichVuItemDTO> items) {
        this.items = items;
    }
}

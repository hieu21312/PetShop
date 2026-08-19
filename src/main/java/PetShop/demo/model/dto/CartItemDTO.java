package PetShop.demo.model.dto;

import java.math.BigDecimal;

public class CartItemDTO {
    private Integer maSP;
    private String tenSP;
    private String anhDaiDien;
    private BigDecimal giaBan;
    private int soLuong;

    public CartItemDTO() {}

    public CartItemDTO(Integer maSP, String tenSP, String anhDaiDien, BigDecimal giaBan, int soLuong) {
        this.maSP = maSP;
        this.tenSP = tenSP;
        this.anhDaiDien = anhDaiDien;
        this.giaBan = giaBan;
        this.soLuong = soLuong;
    }

    public BigDecimal getThanhTien() {
        return giaBan.multiply(BigDecimal.valueOf(soLuong));
    }

    // Getters and Setters
    public Integer getMaSP() { return maSP; }
    public void setMaSP(Integer maSP) { this.maSP = maSP; }

    public String getTenSP() { return tenSP; }
    public void setTenSP(String tenSP) { this.tenSP = tenSP; }

    public String getAnhDaiDien() { return anhDaiDien; }
    public void setAnhDaiDien(String anhDaiDien) { this.anhDaiDien = anhDaiDien; }

    public BigDecimal getGiaBan() { return giaBan; }
    public void setGiaBan(BigDecimal giaBan) { this.giaBan = giaBan; }

    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }
}
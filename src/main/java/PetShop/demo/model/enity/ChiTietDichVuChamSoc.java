package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tblChiTietDichVuChamSoc")
public class ChiTietDichVuChamSoc {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaChiTiet")
    private Integer maChiTiet;

    @Column(name = "MaPhieuDV", nullable = false)
    private Integer maPhieuDV;

    @Column(name = "MaDVCS")
    private Integer maDVCS;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaDVCS", insertable = false, updatable = false)
    private DichVuChamSoc dichVuChamSoc;

    @Column(name = "SoLuong")
    private Integer soLuong = 1;

    @Column(name = "DonGia", precision = 18, scale = 2)
    private BigDecimal donGia;

    @Column(name = "PhuPhi", precision = 18, scale = 2)
    private BigDecimal phuPhi;

    @Column(name = "ThanhTien", precision = 18, scale = 2)
    private BigDecimal thanhTien;

    @Column(name = "NhanVienPhuTrach")
    private String nhanVienPhuTrach;

    @Column(name = "GhiChuChiTiet")
    private String ghiChuChiTiet;

    public ChiTietDichVuChamSoc() {}

    public Integer getMaChiTiet() {
        return maChiTiet;
    }

    public void setMaChiTiet(Integer maChiTiet) {
        this.maChiTiet = maChiTiet;
    }

    public Integer getMaPhieuDV() {
        return maPhieuDV;
    }

    public void setMaPhieuDV(Integer maPhieuDV) {
        this.maPhieuDV = maPhieuDV;
    }

    public Integer getMaDVCS() {
        return maDVCS;
    }

    public void setMaDVCS(Integer maDVCS) {
        this.maDVCS = maDVCS;
    }

    public DichVuChamSoc getDichVuChamSoc() {
        return dichVuChamSoc;
    }

    public void setDichVuChamSoc(DichVuChamSoc dichVuChamSoc) {
        this.dichVuChamSoc = dichVuChamSoc;
    }

    public Integer getSoLuong() {
        return soLuong != null ? soLuong : 1;
    }

    public void setSoLuong(Integer soLuong) {
        this.soLuong = soLuong;
    }

    public BigDecimal getDonGia() {
        return donGia;
    }

    public void setDonGia(BigDecimal donGia) {
        this.donGia = donGia;
    }

    public BigDecimal getPhuPhi() {
        return phuPhi;
    }

    public void setPhuPhi(BigDecimal phuPhi) {
        this.phuPhi = phuPhi;
    }

    public BigDecimal getThanhTien() {
        return thanhTien;
    }

    public void setThanhTien(BigDecimal thanhTien) {
        this.thanhTien = thanhTien;
    }

    public String getNhanVienPhuTrach() {
        return nhanVienPhuTrach;
    }

    public void setNhanVienPhuTrach(String nhanVienPhuTrach) {
        this.nhanVienPhuTrach = nhanVienPhuTrach;
    }

    public String getGhiChuChiTiet() {
        return ghiChuChiTiet;
    }

    public void setGhiChuChiTiet(String ghiChuChiTiet) {
        this.ghiChuChiTiet = ghiChuChiTiet;
    }
}

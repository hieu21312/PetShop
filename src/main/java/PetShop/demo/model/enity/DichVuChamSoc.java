package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tblDichVuChamSoc")
public class DichVuChamSoc {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaDVCS")
    private Integer maDVCS;

    @Column(name = "TenDichVu", nullable = false)
    private String tenDichVu;

    @Column(name = "NhomDichVu", nullable = false)
    private String nhomDichVu; // 'Spa - Grooming', 'Thú y & Khám chữa', 'Khách sạn thú cưng'

    @Column(name = "DoiTuongApDung")
    private String doiTuongApDung;

    @Column(name = "GiaDichVu", nullable = false)
    private BigDecimal giaDichVu;

    @Column(name = "ThoiGianThucHien")
    private Integer thoiGianThucHien; // phút

    @Column(name = "MoTaChiTiet", columnDefinition = "NVARCHAR(MAX)")
    private String moTaChiTiet;

    @Column(name = "HinhAnhDichVu")
    private String hinhAnhDichVu;

    @Column(name = "TrangThai")
    private String trangThai = "Đang cung cấp";

    public DichVuChamSoc() {}

    public Integer getMaDVCS() { return maDVCS; }
    public void setMaDVCS(Integer maDVCS) { this.maDVCS = maDVCS; }

    public String getTenDichVu() { return tenDichVu; }
    public void setTenDichVu(String tenDichVu) { this.tenDichVu = tenDichVu; }

    public String getNhomDichVu() { return nhomDichVu; }
    public void setNhomDichVu(String nhomDichVu) { this.nhomDichVu = nhomDichVu; }

    public String getDoiTuongApDung() { return doiTuongApDung; }
    public void setDoiTuongApDung(String doiTuongApDung) { this.doiTuongApDung = doiTuongApDung; }

    public BigDecimal getGiaDichVu() { return giaDichVu; }
    public void setGiaDichVu(BigDecimal giaDichVu) { this.giaDichVu = giaDichVu; }

    public Integer getThoiGianThucHien() { return thoiGianThucHien; }
    public void setThoiGianThucHien(Integer thoiGianThucHien) { this.thoiGianThucHien = thoiGianThucHien; }

    public String getMoTaChiTiet() { return moTaChiTiet; }
    public void setMoTaChiTiet(String moTaChiTiet) { this.moTaChiTiet = moTaChiTiet; }

    public String getHinhAnhDichVu() { return hinhAnhDichVu; }
    public void setHinhAnhDichVu(String hinhAnhDichVu) { this.hinhAnhDichVu = hinhAnhDichVu; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
}

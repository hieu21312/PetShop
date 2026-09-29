package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "tblPhieuDichVuChamSoc")
public class PhieuDichVuChamSoc {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaPhieuDV")
    private Integer maPhieuDV;

    @Column(name = "SoPhieu", nullable = false, unique = true)
    private String soPhieu;

    @Column(name = "MaThuCung", nullable = false)
    private Integer maThuCung;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaThuCung", insertable = false, updatable = false)
    private HoSoThuCung thuCung;

    @Column(name = "MaChuNuoi", nullable = false)
    private Integer maChuNuoi;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaChuNuoi", insertable = false, updatable = false)
    private ChuNuoi chuNuoi;

    @Column(name = "MaNVTiepNhan")
    private Integer maNVTiepNhan;

    @Column(name = "MaNVThucHien")
    private Integer maNVThucHien;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaNVThucHien", insertable = false, updatable = false)
    private Employee nvThucHien;

    @Column(name = "NgayTiepNhan")
    private LocalDateTime ngayTiepNhan;

    @Column(name = "NgayHenTra")
    private LocalDateTime ngayHenTra;

    @Column(name = "NgayTraThucTe")
    private LocalDateTime ngayTraThucTe;

    @Column(name = "CanNangTiepNhan")
    private BigDecimal canNangTiepNhan;

    @Column(name = "TinhTrangBanDau")
    private String tinhTrangBanDau;

    @Column(name = "YeuCauCuaChuNuoi")
    private String yeuCauCuaChuNuoi;

    @Column(name = "KetQuaChamSoc")
    private String ketQuaChamSoc;

    @Column(name = "TongTien")
    private BigDecimal tongTien = BigDecimal.ZERO;

    @Column(name = "TienGiamGia")
    private BigDecimal tienGiamGia = BigDecimal.ZERO;

    @Column(name = "ThanhToan")
    private BigDecimal thanhToan = BigDecimal.ZERO;

    @Column(name = "HinhThucThanhToan")
    private String hinhThucThanhToan;

    @Column(name = "TrangThaiThanhToan")
    private String trangThaiThanhToan = "Chưa thanh toán";

    @Column(name = "TrangThaiDichVu")
    private String trangThaiDichVu = "Chờ tiếp nhận";

    @Column(name = "DanhGiaCuaChu")
    private String danhGiaCuaChu;

    @Column(name = "GhiChu")
    private String ghiChu;

    public PhieuDichVuChamSoc() {
        this.ngayTiepNhan = LocalDateTime.now();
    }

    public Integer getMaPhieuDV() { return maPhieuDV; }
    public void setMaPhieuDV(Integer maPhieuDV) { this.maPhieuDV = maPhieuDV; }

    public String getSoPhieu() { return soPhieu; }
    public void setSoPhieu(String soPhieu) { this.soPhieu = soPhieu; }

    public Integer getMaThuCung() { return maThuCung; }
    public void setMaThuCung(Integer maThuCung) { this.maThuCung = maThuCung; }

    public HoSoThuCung getThuCung() { return thuCung; }
    public void setThuCung(HoSoThuCung thuCung) { this.thuCung = thuCung; }

    public Integer getMaChuNuoi() { return maChuNuoi; }
    public void setMaChuNuoi(Integer maChuNuoi) { this.maChuNuoi = maChuNuoi; }

    public ChuNuoi getChuNuoi() { return chuNuoi; }
    public void setChuNuoi(ChuNuoi chuNuoi) { this.chuNuoi = chuNuoi; }

    public Integer getMaNVTiepNhan() { return maNVTiepNhan; }
    public void setMaNVTiepNhan(Integer maNVTiepNhan) { this.maNVTiepNhan = maNVTiepNhan; }

    public Integer getMaNVThucHien() { return maNVThucHien; }
    public void setMaNVThucHien(Integer maNVThucHien) { this.maNVThucHien = maNVThucHien; }

    public Employee getNvThucHien() { return nvThucHien; }
    public void setNvThucHien(Employee nvThucHien) { this.nvThucHien = nvThucHien; }

    public LocalDateTime getNgayTiepNhan() { return ngayTiepNhan; }
    public void setNgayTiepNhan(LocalDateTime ngayTiepNhan) { this.ngayTiepNhan = ngayTiepNhan; }

    public LocalDateTime getNgayHenTra() { return ngayHenTra; }
    public void setNgayHenTra(LocalDateTime ngayHenTra) { this.ngayHenTra = ngayHenTra; }

    public LocalDateTime getNgayTraThucTe() { return ngayTraThucTe; }
    public void setNgayTraThucTe(LocalDateTime ngayTraThucTe) { this.ngayTraThucTe = ngayTraThucTe; }

    public BigDecimal getCanNangTiepNhan() { return canNangTiepNhan; }
    public void setCanNangTiepNhan(BigDecimal canNangTiepNhan) { this.canNangTiepNhan = canNangTiepNhan; }

    public String getTinhTrangBanDau() { return tinhTrangBanDau; }
    public void setTinhTrangBanDau(String tinhTrangBanDau) { this.tinhTrangBanDau = tinhTrangBanDau; }

    public String getYeuCauCuaChuNuoi() { return yeuCauCuaChuNuoi; }
    public void setYeuCauCuaChuNuoi(String yeuCauCuaChuNuoi) { this.yeuCauCuaChuNuoi = yeuCauCuaChuNuoi; }

    public String getKetQuaChamSoc() { return ketQuaChamSoc; }
    public void setKetQuaChamSoc(String ketQuaChamSoc) { this.ketQuaChamSoc = ketQuaChamSoc; }

    public BigDecimal getTongTien() { return tongTien; }
    public void setTongTien(BigDecimal tongTien) { this.tongTien = tongTien; }

    public BigDecimal getTienGiamGia() { return tienGiamGia; }
    public void setTienGiamGia(BigDecimal tienGiamGia) { this.tienGiamGia = tienGiamGia; }

    public BigDecimal getThanhToan() { return thanhToan; }
    public void setThanhToan(BigDecimal thanhToan) { this.thanhToan = thanhToan; }

    public String getHinhThucThanhToan() { return hinhThucThanhToan; }
    public void setHinhThucThanhToan(String hinhThucThanhToan) { this.hinhThucThanhToan = hinhThucThanhToan; }

    public String getTrangThaiThanhToan() { return trangThaiThanhToan; }
    public void setTrangThaiThanhToan(String trangThaiThanhToan) { this.trangThaiThanhToan = trangThaiThanhToan; }

    public String getTrangThaiDichVu() { return trangThaiDichVu; }
    public void setTrangThaiDichVu(String trangThaiDichVu) { this.trangThaiDichVu = trangThaiDichVu; }

    public String getDanhGiaCuaChu() { return danhGiaCuaChu; }
    public void setDanhGiaCuaChu(String danhGiaCuaChu) { this.danhGiaCuaChu = danhGiaCuaChu; }

    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }
}

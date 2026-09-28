package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "tblHoSoThuCung")
public class HoSoThuCung {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaThuCung")
    private Integer maThuCung;

    @Column(name = "MaChuNuoi", nullable = false)
    private Integer maChuNuoi;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaChuNuoi", insertable = false, updatable = false)
    private ChuNuoi chuNuoi;

    @Column(name = "TenThuCung", nullable = false)
    private String tenThuCung;

    @Column(name = "LoaiThuCung", nullable = false)
    private String loaiThuCung; // Chó, Mèo, ...

    @Column(name = "GiongLoai", nullable = false)
    private String giongLoai;

    @Column(name = "GioiTinh", nullable = false)
    private String gioiTinh;

    @Column(name = "TrietSan")
    private Boolean trietSan = false;

    @Column(name = "NgaySinh")
    private LocalDate ngaySinh;

    @Column(name = "TuoiThang")
    private Integer tuoiThang;

    @Column(name = "MauSac")
    private String mauSac;

    @Column(name = "CanNang")
    private BigDecimal canNang;

    @Column(name = "DacDiemNhanDang")
    private String dacDiemNhanDang;

    @Column(name = "SoMicrochip")
    private String soMicrochip;

    @Column(name = "TinhTrangSucKhoeHienTai")
    private String tinhTrangSucKhoeHienTai;

    @Column(name = "TienSuBenhLy")
    private String tienSuBenhLy;

    @Column(name = "DiUngThuocThucAn")
    private String diUngThuocThucAn;

    @Column(name = "LichSuTiemChung")
    private String lichSuTiemChung;

    @Column(name = "HinhAnh")
    private String hinhAnh;

    @Column(name = "NgayTaoHoSo")
    private LocalDateTime ngayTaoHoSo;

    @Column(name = "TrangThai")
    private String trangThai = "Đang nuôi";

    @Column(name = "GhiChu")
    private String ghiChu;

    public HoSoThuCung() {
        this.ngayTaoHoSo = LocalDateTime.now();
    }

    public Integer getMaThuCung() { return maThuCung; }
    public void setMaThuCung(Integer maThuCung) { this.maThuCung = maThuCung; }

    public Integer getMaChuNuoi() { return maChuNuoi; }
    public void setMaChuNuoi(Integer maChuNuoi) { this.maChuNuoi = maChuNuoi; }

    public ChuNuoi getChuNuoi() { return chuNuoi; }
    public void setChuNuoi(ChuNuoi chuNuoi) { this.chuNuoi = chuNuoi; }

    public String getTenThuCung() { return tenThuCung; }
    public void setTenThuCung(String tenThuCung) { this.tenThuCung = tenThuCung; }

    public String getLoaiThuCung() { return loaiThuCung; }
    public void setLoaiThuCung(String loaiThuCung) { this.loaiThuCung = loaiThuCung; }

    public String getGiongLoai() { return giongLoai; }
    public void setGiongLoai(String giongLoai) { this.giongLoai = giongLoai; }

    public String getGioiTinh() { return gioiTinh; }
    public void setGioiTinh(String gioiTinh) { this.gioiTinh = gioiTinh; }

    public Boolean getTrietSan() { return trietSan; }
    public void setTrietSan(Boolean trietSan) { this.trietSan = trietSan; }

    public LocalDate getNgaySinh() { return ngaySinh; }
    public void setNgaySinh(LocalDate ngaySinh) { this.ngaySinh = ngaySinh; }

    public Integer getTuoiThang() { return tuoiThang; }
    public void setTuoiThang(Integer tuoiThang) { this.tuoiThang = tuoiThang; }

    public String getMauSac() { return mauSac; }
    public void setMauSac(String mauSac) { this.mauSac = mauSac; }

    public BigDecimal getCanNang() { return canNang; }
    public void setCanNang(BigDecimal canNang) { this.canNang = canNang; }

    public String getDacDiemNhanDang() { return dacDiemNhanDang; }
    public void setDacDiemNhanDang(String dacDiemNhanDang) { this.dacDiemNhanDang = dacDiemNhanDang; }

    public String getSoMicrochip() { return soMicrochip; }
    public void setSoMicrochip(String soMicrochip) { this.soMicrochip = soMicrochip; }

    public String getTinhTrangSucKhoeHienTai() { return tinhTrangSucKhoeHienTai; }
    public void setTinhTrangSucKhoeHienTai(String tinhTrangSucKhoeHienTai) { this.tinhTrangSucKhoeHienTai = tinhTrangSucKhoeHienTai; }

    public String getTienSuBenhLy() { return tienSuBenhLy; }
    public void setTienSuBenhLy(String tienSuBenhLy) { this.tienSuBenhLy = tienSuBenhLy; }

    public String getDiUngThuocThucAn() { return diUngThuocThucAn; }
    public void setDiUngThuocThucAn(String diUngThuocThucAn) { this.diUngThuocThucAn = diUngThuocThucAn; }

    public String getLichSuTiemChung() { return lichSuTiemChung; }
    public void setLichSuTiemChung(String lichSuTiemChung) { this.lichSuTiemChung = lichSuTiemChung; }

    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }

    public LocalDateTime getNgayTaoHoSo() { return ngayTaoHoSo; }
    public void setNgayTaoHoSo(LocalDateTime ngayTaoHoSo) { this.ngayTaoHoSo = ngayTaoHoSo; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }
}

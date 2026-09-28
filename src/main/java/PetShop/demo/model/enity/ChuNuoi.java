package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "tblChuNuoi")
public class ChuNuoi {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaChuNuoi")
    private Integer maChuNuoi;

    @Column(name = "MaKH")
    private Integer maKH;

    @Column(name = "HoTenChuNuoi", nullable = false)
    private String hoTenChuNuoi;

    @Column(name = "SoDienThoai", nullable = false)
    private String soDienThoai;

    @Column(name = "Email")
    private String email;

    @Column(name = "SoCCCD")
    private String soCCCD;

    @Column(name = "DiaChi")
    private String diaChi;

    @Column(name = "GioiTinh")
    private String gioiTinh;

    @Column(name = "NgaySinh")
    private LocalDate ngaySinh;

    @Column(name = "SoDienThoaiKhanCap")
    private String soDienThoaiKhanCap;

    @Column(name = "NguoiLienHeKhanCap")
    private String nguoiLienHeKhanCap;

    @Column(name = "LoaiChuNuoi")
    private String loaiChuNuoi = "Tiêu chuẩn";

    @Column(name = "DiemTichLuy")
    private Integer diemTichLuy = 0;

    @Column(name = "NgayDangKy")
    private LocalDateTime ngayDangKy;

    @Column(name = "GhiChu")
    private String ghiChu;

    @Column(name = "TrangThai")
    private String trangThai = "Đang hoạt động";

    @OneToMany(mappedBy = "chuNuoi", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<HoSoThuCung> danhSachThuCung;

    public ChuNuoi() {
        this.ngayDangKy = LocalDateTime.now();
    }

    public Integer getMaChuNuoi() { return maChuNuoi; }
    public void setMaChuNuoi(Integer maChuNuoi) { this.maChuNuoi = maChuNuoi; }

    public Integer getMaKH() { return maKH; }
    public void setMaKH(Integer maKH) { this.maKH = maKH; }

    public String getHoTenChuNuoi() { return hoTenChuNuoi; }
    public void setHoTenChuNuoi(String hoTenChuNuoi) { this.hoTenChuNuoi = hoTenChuNuoi; }

    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSoCCCD() { return soCCCD; }
    public void setSoCCCD(String soCCCD) { this.soCCCD = soCCCD; }

    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }

    public String getGioiTinh() { return gioiTinh; }
    public void setGioiTinh(String gioiTinh) { this.gioiTinh = gioiTinh; }

    public LocalDate getNgaySinh() { return ngaySinh; }
    public void setNgaySinh(LocalDate ngaySinh) { this.ngaySinh = ngaySinh; }

    public String getSoDienThoaiKhanCap() { return soDienThoaiKhanCap; }
    public void setSoDienThoaiKhanCap(String soDienThoaiKhanCap) { this.soDienThoaiKhanCap = soDienThoaiKhanCap; }

    public String getNguoiLienHeKhanCap() { return nguoiLienHeKhanCap; }
    public void setNguoiLienHeKhanCap(String nguoiLienHeKhanCap) { this.nguoiLienHeKhanCap = nguoiLienHeKhanCap; }

    public String getLoaiChuNuoi() { return loaiChuNuoi; }
    public void setLoaiChuNuoi(String loaiChuNuoi) { this.loaiChuNuoi = loaiChuNuoi; }

    public Integer getDiemTichLuy() { return diemTichLuy; }
    public void setDiemTichLuy(Integer diemTichLuy) { this.diemTichLuy = diemTichLuy; }

    public LocalDateTime getNgayDangKy() { return ngayDangKy; }
    public void setNgayDangKy(LocalDateTime ngayDangKy) { this.ngayDangKy = ngayDangKy; }

    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public List<HoSoThuCung> getDanhSachThuCung() { return danhSachThuCung; }
    public void setDanhSachThuCung(List<HoSoThuCung> danhSachThuCung) { this.danhSachThuCung = danhSachThuCung; }
}

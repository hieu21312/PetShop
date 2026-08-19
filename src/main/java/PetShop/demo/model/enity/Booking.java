package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "tblDatLich")
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaDatLich")
    private Integer maDatLich;

    @Column(name = "MaDV")
    private Integer maDV;  // dịch vụ được đặt

    @Column(name = "TenKhachHang")
    private String tenKhachHang;

    @Column(name = "SoDienThoai")
    private String soDienThoai;

    @Column(name = "Email")
    private String email;

    @Column(name = "NgayDat")
    private LocalDate ngayDat;

    @Column(name = "GioDat")
    private LocalTime gioDat;

    @Column(name = "GhiChu")
    private String ghiChu;

    @Column(name = "TrangThai")
    private String trangThai;  // Chờ xác nhận, Đã xác nhận, Hoàn thành, Hủy

    @Column(name = "NgayTao")
    private LocalDateTime ngayTao;

    @Column(name = "MaKH")  // nếu khách hàng đã đăng nhập, lưu mã KH
    private Integer maKH;

    // Constructors
    public Booking() {}

    // Getters and Setters (generate all)
    public Integer getMaDatLich() { return maDatLich; }
    public void setMaDatLich(Integer maDatLich) { this.maDatLich = maDatLich; }
    public Integer getMaDV() { return maDV; }
    public void setMaDV(Integer maDV) { this.maDV = maDV; }
    public String getTenKhachHang() { return tenKhachHang; }
    public void setTenKhachHang(String tenKhachHang) { this.tenKhachHang = tenKhachHang; }
    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public LocalDate getNgayDat() { return ngayDat; }
    public void setNgayDat(LocalDate ngayDat) { this.ngayDat = ngayDat; }
    public LocalTime getGioDat() { return gioDat; }
    public void setGioDat(LocalTime gioDat) { this.gioDat = gioDat; }
    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
    public LocalDateTime getNgayTao() { return ngayTao; }
    public void setNgayTao(LocalDateTime ngayTao) { this.ngayTao = ngayTao; }
    public Integer getMaKH() { return maKH; }
    public void setMaKH(Integer maKH) { this.maKH = maKH; }
}
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
    private Integer maDV;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaDV", insertable = false, updatable = false)
    private PetService petService;

    @Column(name = "TenKhachHang")
    private String tenKhachHang;

    @Column(name = "SoDienThoai")
    private String soDienThoai;

    @Column(name = "Email")
    private String email;

    @Column(name = "NgayDat")
    private LocalDate ngayDat;

    @Column(name = "GioDat", columnDefinition = "TIME")
    private LocalTime gioDat;

    @Column(name = "GhiChu")
    private String ghiChu;

    @Column(name = "TrangThai")
    private String trangThai;

    @Column(name = "TrangThaiThanhToan")
    private String trangThaiThanhToan = "Chưa thanh toán";

    @Column(name = "NgayTao")
    private LocalDateTime ngayTao;

    @Column(name = "MaKH")
    private Integer maKH;

    @Column(name = "MaNV")
    private Integer maNV;

    @ManyToOne
    @JoinColumn(name = "MaNV", insertable = false, updatable = false)
    private Employee employee;

    public Booking() {
        this.ngayTao = LocalDateTime.now();
        this.trangThaiThanhToan = "Chưa thanh toán";
    }

    public String getMaDichVu() {
        if (maDatLich == null) return "BK-NEW";
        return "BK-" + String.format("%04d", maDatLich);
    }

    public Integer getMaDatLich() { return maDatLich; }
    public void setMaDatLich(Integer maDatLich) { this.maDatLich = maDatLich; }
    public Integer getMaDV() { return maDV; }
    public void setMaDV(Integer maDV) { this.maDV = maDV; }
    public PetService getPetService() { return petService; }
    public void setPetService(PetService petService) { this.petService = petService; }
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
    public String getTrangThaiThanhToan() { return trangThaiThanhToan != null ? trangThaiThanhToan : "Chưa thanh toán"; }
    public void setTrangThaiThanhToan(String trangThaiThanhToan) { this.trangThaiThanhToan = trangThaiThanhToan; }
    public LocalDateTime getNgayTao() { return ngayTao; }
    public void setNgayTao(LocalDateTime ngayTao) { this.ngayTao = ngayTao; }
    public Integer getMaKH() { return maKH; }
    public void setMaKH(Integer maKH) { this.maKH = maKH; }
    public Integer getMaNV() { return maNV; }
    public void setMaNV(Integer maNV) { this.maNV = maNV; }
    public Employee getEmployee() { return employee; }
    public void setEmployee(Employee employee) { this.employee = employee; }
}

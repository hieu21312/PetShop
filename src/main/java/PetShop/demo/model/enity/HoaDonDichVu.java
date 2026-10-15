package PetShop.demo.model.enity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "tblHoaDonDichVu")
public class HoaDonDichVu {

    public static final String TRANG_THAI_CHUA_THANH_TOAN = "ChuaThanhToan";
    public static final String TRANG_THAI_DA_THANH_TOAN = "DaThanhToan";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaHDDV")
    private Integer maHDDV;

    @Column(name = "MaKH")
    private Integer maKH;

    @Column(name = "MaNV")
    private Integer maNV;

    @Column(name = "NgaySuDung")
    private LocalDateTime ngaySuDung;

    @Column(name = "TongTien")
    private BigDecimal tongTien;

    @Column(name = "GhiChu")
    private String ghiChu;

    // 1. Trường TrangThai (String) - Mặc định: 'ChuaThanhToan'
    @Column(name = "TrangThai", length = 50)
    private String trangThai = TRANG_THAI_CHUA_THANH_TOAN;

    // 1. Trường PhuongThucThanhToan (String)
    @Column(name = "PhuongThucThanhToan", length = 100)
    private String phuongThucThanhToan;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaKH", insertable = false, updatable = false)
    private Customer customer;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaNV", insertable = false, updatable = false)
    private Employee employee;

    @JsonIgnore
    @OneToMany(mappedBy = "hoaDonDichVu", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<ChiTietHoaDonDichVu> chiTietHoaDonDichVus = new ArrayList<>();

    // Constructors
    public HoaDonDichVu() {
        this.ngaySuDung = LocalDateTime.now();
        this.trangThai = TRANG_THAI_CHUA_THANH_TOAN;
    }

    public HoaDonDichVu(Integer maKH, Integer maNV, BigDecimal tongTien, String phuongThucThanhToan, String ghiChu) {
        this.maKH = maKH;
        this.maNV = maNV;
        this.tongTien = tongTien;
        this.phuongThucThanhToan = phuongThucThanhToan;
        this.ghiChu = ghiChu;
        this.ngaySuDung = LocalDateTime.now();
        this.trangThai = TRANG_THAI_CHUA_THANH_TOAN;
    }

    // Getters and Setters
    public Integer getMaHDDV() {
        return maHDDV;
    }

    public void setMaHDDV(Integer maHDDV) {
        this.maHDDV = maHDDV;
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

    public LocalDateTime getNgaySuDung() {
        return ngaySuDung;
    }

    public void setNgaySuDung(LocalDateTime ngaySuDung) {
        this.ngaySuDung = ngaySuDung;
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

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getPhuongThucThanhToan() {
        return phuongThucThanhToan;
    }

    public void setPhuongThucThanhToan(String phuongThucThanhToan) {
        this.phuongThucThanhToan = phuongThucThanhToan;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }

    public List<ChiTietHoaDonDichVu> getChiTietHoaDonDichVus() {
        return chiTietHoaDonDichVus;
    }

    public void setChiTietHoaDonDichVus(List<ChiTietHoaDonDichVu> chiTietHoaDonDichVus) {
        this.chiTietHoaDonDichVus = chiTietHoaDonDichVus;
    }
}

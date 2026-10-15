package PetShop.demo.model.enity;

import jakarta.persistence.*;

@Entity
@Table(name = "tblNhanVien")
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaNV")
    private Integer maNV;

    @Column(name = "MatKhau")
    private String matKhau;

    @Column(name = "TenNV")
    private String tenNV;

    @Column(name = "GioiTinh")
    private String gioiTinh;

    @Column(name = "NamSinh")
    private Integer namSinh;

    @Column(name = "VaiTro")
    private Integer vaiTro;

    @Column(name = "DienThoai")
    private String dienThoai;

    @Column(name = "Email")
    private String email;

    @Column(name = "ChuyenMon")
    private String chuyenMon;

    @Column(name = "AnhDaiDien")
    private String anhDaiDien;

    @Column(name = "TrangThai")
    private String trangThai; // 'Đang làm việc', 'Tạm nghỉ'

    @ManyToOne
    @JoinColumn(name = "VaiTro", insertable = false, updatable = false)
    private Role role;

    // Constructors
    public Employee() {}

    // Getters and Setters
    public Integer getMaNV() { return maNV; }
    public void setMaNV(Integer maNV) { this.maNV = maNV; }

    public String getMatKhau() { return matKhau; }
    public void setMatKhau(String matKhau) { this.matKhau = matKhau; }

    public String getTenNV() { return tenNV; }
    public void setTenNV(String tenNV) { this.tenNV = tenNV; }

    public String getGioiTinh() { return gioiTinh; }
    public void setGioiTinh(String gioiTinh) { this.gioiTinh = gioiTinh; }

    public Integer getNamSinh() { return namSinh; }
    public void setNamSinh(Integer namSinh) { this.namSinh = namSinh; }

    public Integer getVaiTro() { return vaiTro; }
    public void setVaiTro(Integer vaiTro) { this.vaiTro = vaiTro; }

    public String getDienThoai() { return dienThoai; }
    public void setDienThoai(String dienThoai) { this.dienThoai = dienThoai; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getChuyenMon() { return chuyenMon; }
    public void setChuyenMon(String chuyenMon) { this.chuyenMon = chuyenMon; }

    public String getAnhDaiDien() { return anhDaiDien; }
    public void setAnhDaiDien(String anhDaiDien) { this.anhDaiDien = anhDaiDien; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }
}
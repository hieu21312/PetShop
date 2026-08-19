package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "tblKhachHang")
public class Customer {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaKH") private Integer maKH;
    @Column(name = "TenKH") private String tenKH;
    @Column(name = "MatKhau") private String matKhau;
    @Column(name = "GioiTinh") private String gioiTinh;
    @Column(name = "NamSinh") private Integer namSinh;
    @Column(name = "Avarta") private String avarta;
    @Column(name = "DienThoai") private String dienThoai;
    @Column(name = "Email") private String email;
    @Column(name = "DiaChi") private String diaChi;
    @Column(name = "IsLocked") private Boolean isLocked = false;
    @OneToMany(mappedBy = "customer") private List<Order> orders;

    public Customer() {}
    
    public Boolean getIsLocked() { return isLocked; }
    public void setIsLocked(Boolean isLocked) { this.isLocked = isLocked; }

    // Getters and setters (bạn tự generate trong IntelliJ: Alt+Insert -> Getter and Setter)
    public Integer getMaKH() { return maKH; }
    public void setMaKH(Integer maKH) { this.maKH = maKH; }
    public String getTenKH() { return tenKH; }
    public void setTenKH(String tenKH) { this.tenKH = tenKH; }
    public String getMatKhau() { return matKhau; }
    public void setMatKhau(String matKhau) { this.matKhau = matKhau; }
    public String getGioiTinh() { return gioiTinh; }
    public void setGioiTinh(String gioiTinh) { this.gioiTinh = gioiTinh; }
    public Integer getNamSinh() { return namSinh; }
    public void setNamSinh(Integer namSinh) { this.namSinh = namSinh; }
    public String getAvarta() { return avarta; }
    public void setAvarta(String avarta) { this.avarta = avarta; }
    public String getDienThoai() { return dienThoai; }
    public void setDienThoai(String dienThoai) { this.dienThoai = dienThoai; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }
    public List<Order> getOrders() { return orders; }
    public void setOrders(List<Order> orders) { this.orders = orders; }
}
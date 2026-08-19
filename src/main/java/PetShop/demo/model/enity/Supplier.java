package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "tblNhaCungCap")
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaNCC")
    private Integer maNCC;

    @Column(name = "TenNCC")
    private String tenNCC;

    @Column(name = "DiaChi")
    private String diaChi;

    @Column(name = "DienThoai")
    private String dienThoai;

    @OneToMany(mappedBy = "supplier")
    private List<Product> products;

    // Constructors
    public Supplier() {}

    // Getters and Setters
    public Integer getMaNCC() { return maNCC; }
    public void setMaNCC(Integer maNCC) { this.maNCC = maNCC; }

    public String getTenNCC() { return tenNCC; }
    public void setTenNCC(String tenNCC) { this.tenNCC = tenNCC; }

    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }

    public String getDienThoai() { return dienThoai; }
    public void setDienThoai(String dienThoai) { this.dienThoai = dienThoai; }

    public List<Product> getProducts() { return products; }
    public void setProducts(List<Product> products) { this.products = products; }
}
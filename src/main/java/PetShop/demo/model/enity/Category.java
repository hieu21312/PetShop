package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "tblDanhMuc")
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaDanhMuc")
    private Integer maDanhMuc;

    @Column(name = "TenDanhMuc")
    private String tenDanhMuc;

    @Column(name = "GhiChu")
    private String ghiChu;

    @OneToMany(mappedBy = "category")
    private List<Product> products;

    // Constructors
    public Category() {}

    // Getters and Setters
    public Integer getMaDanhMuc() { return maDanhMuc; }
    public void setMaDanhMuc(Integer maDanhMuc) { this.maDanhMuc = maDanhMuc; }

    public String getTenDanhMuc() { return tenDanhMuc; }
    public void setTenDanhMuc(String tenDanhMuc) { this.tenDanhMuc = tenDanhMuc; }

    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }

    public List<Product> getProducts() { return products; }
    public void setProducts(List<Product> products) { this.products = products; }
}
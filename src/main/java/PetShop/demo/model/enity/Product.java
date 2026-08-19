package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "tblSanPham")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaSP")
    private Integer maSP;

    @Column(name = "TenSP")
    private String tenSP;

    @Column(name = "LoaiSanPham")
    private String loaiSanPham;

    @Column(name = "GioiTinh")
    private String gioiTinh;

    @Column(name = "NgaySinh")
    private LocalDate ngaySinh;

    @Column(name = "MauSac")
    private String mauSac;

    @Column(name = "TinhTrangSucKhoe")
    private String tinhTrangSucKhoe;

    @Column(name = "TienSuBenh")
    private String tienSuBenh;

    @Column(name = "MoTa")
    private String moTa;

    @Column(name = "GiaBan")
    private BigDecimal giaBan;

    @Column(name = "AnhDaiDien")
    private String anhDaiDien;

    @Column(name = "MaDanhMuc")
    private Integer maDanhMuc;

    @Column(name = "MaNCC")
    private Integer maNCC;

    @ManyToOne
    @JoinColumn(name = "MaDanhMuc", insertable = false, updatable = false)
    private Category category;

    @ManyToOne
    @JoinColumn(name = "MaNCC", insertable = false, updatable = false)
    private Supplier supplier;

    @OneToOne(mappedBy = "product")
    private Inventory inventory;

    @OneToMany(mappedBy = "product")
    private List<ProductImage> images;

    @OneToMany(mappedBy = "product")
    private List<Review> reviews;

    // Constructors
    public Product() {}

    // Getters and Setters
    public Integer getMaSP() { return maSP; }
    public void setMaSP(Integer maSP) { this.maSP = maSP; }

    public String getTenSP() { return tenSP; }
    public void setTenSP(String tenSP) { this.tenSP = tenSP; }

    public String getLoaiSanPham() { return loaiSanPham; }
    public void setLoaiSanPham(String loaiSanPham) { this.loaiSanPham = loaiSanPham; }

    public String getGioiTinh() { return gioiTinh; }
    public void setGioiTinh(String gioiTinh) { this.gioiTinh = gioiTinh; }

    public LocalDate getNgaySinh() { return ngaySinh; }
    public void setNgaySinh(LocalDate ngaySinh) { this.ngaySinh = ngaySinh; }

    public String getMauSac() { return mauSac; }
    public void setMauSac(String mauSac) { this.mauSac = mauSac; }

    public String getTinhTrangSucKhoe() { return tinhTrangSucKhoe; }
    public void setTinhTrangSucKhoe(String tinhTrangSucKhoe) { this.tinhTrangSucKhoe = tinhTrangSucKhoe; }

    public String getTienSuBenh() { return tienSuBenh; }
    public void setTienSuBenh(String tienSuBenh) { this.tienSuBenh = tienSuBenh; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public BigDecimal getGiaBan() { return giaBan; }
    public void setGiaBan(BigDecimal giaBan) { this.giaBan = giaBan; }

    public String getAnhDaiDien() { return anhDaiDien; }
    public void setAnhDaiDien(String anhDaiDien) { this.anhDaiDien = anhDaiDien; }

    public Integer getMaDanhMuc() { return maDanhMuc; }
    public void setMaDanhMuc(Integer maDanhMuc) { this.maDanhMuc = maDanhMuc; }

    public Integer getMaNCC() { return maNCC; }
    public void setMaNCC(Integer maNCC) { this.maNCC = maNCC; }

    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }

    public Supplier getSupplier() { return supplier; }
    public void setSupplier(Supplier supplier) { this.supplier = supplier; }

    public Inventory getInventory() { return inventory; }
    public void setInventory(Inventory inventory) { this.inventory = inventory; }

    public List<ProductImage> getImages() { return images; }
    public void setImages(List<ProductImage> images) { this.images = images; }

    public List<Review> getReviews() { return reviews; }
    public void setReviews(List<Review> reviews) { this.reviews = reviews; }
}
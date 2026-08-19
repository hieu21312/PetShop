package PetShop.demo.model.enity;

import jakarta.persistence.*;

@Entity
@Table(name = "tblTonKho")
public class Inventory {
    @Id
    @Column(name = "MaSP")
    private Integer maSP;

    @Column(name = "SoLuongTon")
    private Integer soLuongTon;

    @Column(name = "TrangThai")
    private String trangThai;

    @OneToOne
    @MapsId
    @JoinColumn(name = "MaSP")
    private Product product;

    // Constructors
    public Inventory() {}

    // Getters and Setters
    public Integer getMaSP() { return maSP; }
    public void setMaSP(Integer maSP) { this.maSP = maSP; }

    public Integer getSoLuongTon() { return soLuongTon; }
    public void setSoLuongTon(Integer soLuongTon) { this.soLuongTon = soLuongTon; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
}
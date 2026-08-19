package PetShop.demo.model.enity;

import jakarta.persistence.*;

@Entity
@Table(name = "tblHinhAnh")
public class ProductImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "MaSP")
    private Integer maSP;

    @Column(name = "HinhAnh")
    private String hinhAnh;

    @ManyToOne
    @JoinColumn(name = "MaSP", insertable = false, updatable = false)
    private Product product;

    // Constructors
    public ProductImage() {}

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaSP() { return maSP; }
    public void setMaSP(Integer maSP) { this.maSP = maSP; }

    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
}
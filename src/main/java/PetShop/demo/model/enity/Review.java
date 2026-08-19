package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "tblBinhLuan")
public class Review {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @Column(name = "MaSP")
    private Integer maSP;

    @Column(name = "HoTen")
    private String hoTen;

    @Column(name = "NoiDung")
    private String noiDung;

    @Column(name = "SoSao")
    private Integer soSao;

    @Column(name = "Ngay")
    private LocalDateTime ngay;

    @Column(name = "DaDuyet")
    private Boolean daDuyet = false;

    // Thêm quan hệ ManyToOne với Product
    @ManyToOne
    @JoinColumn(name = "MaSP", insertable = false, updatable = false)
    private Product product;

    // Constructors
    public Review() {}

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaSP() { return maSP; }
    public void setMaSP(Integer maSP) { this.maSP = maSP; }

    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public Integer getSoSao() { return soSao; }
    public void setSoSao(Integer soSao) { this.soSao = soSao; }

    public LocalDateTime getNgay() { return ngay; }
    public void setNgay(LocalDateTime ngay) { this.ngay = ngay; }

    public Boolean getDaDuyet() { return daDuyet; }
    public void setDaDuyet(Boolean daDuyet) { this.daDuyet = daDuyet; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
}
package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tblDichVu")
public class PetService {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaDV")
    private Integer maDV;

    @Column(name = "TenDV")
    private String tenDV;

    @Column(name = "MoTa")
    private String moTa;

    @Column(name = "GiaDichVu")
    private BigDecimal giaDichVu;

    // Thêm thuộc tính này vào bên trong class PetService
    @Column(name = "HinhAnh")
    private String hinhAnh;

    // Tạo thêm Getter và Setter cho thuộc tính hinhAnh này


    // Constructors
    public PetService() {}

    public String getHinhAnh() {
        return hinhAnh;
    }
    public void setHinhAnh(String hinhAnh) {this.hinhAnh = hinhAnh;}

    // Getters and Setters
    public Integer getMaDV() { return maDV; }
    public void setMaDV(Integer maDV) { this.maDV = maDV; }

    public String getTenDV() { return tenDV; }
    public void setTenDV(String tenDV) { this.tenDV = tenDV; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public BigDecimal getGiaDichVu() { return giaDichVu; }
    public void setGiaDichVu(BigDecimal giaDichVu) { this.giaDichVu = giaDichVu; }
}
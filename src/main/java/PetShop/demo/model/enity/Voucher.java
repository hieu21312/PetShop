package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "tblMaGiamGia")
public class Voucher {
    @Id
    @Column(name = "MaGiamGia")
    private String maGiamGia;

    @Column(name = "PhanTramGiam")
    private BigDecimal phanTramGiam;

    @Column(name = "SoTienGiamToiDa")
    private BigDecimal soTienGiamToiDa;

    @Column(name = "NgayBatDau")
    private LocalDate ngayBatDau;

    @Column(name = "NgayKetThuc")
    private LocalDate ngayKetThuc;

    @Column(name = "SoLuong")
    private Integer soLuong;

    @OneToMany(mappedBy = "voucher")
    private List<Order> orders;

    // Constructors
    public Voucher() {}

    // Getters and setters
    public String getMaGiamGia() { return maGiamGia; }
    public void setMaGiamGia(String maGiamGia) { this.maGiamGia = maGiamGia; }

    public BigDecimal getPhanTramGiam() { return phanTramGiam; }
    public void setPhanTramGiam(BigDecimal phanTramGiam) { this.phanTramGiam = phanTramGiam; }

    public BigDecimal getSoTienGiamToiDa() { return soTienGiamToiDa; }
    public void setSoTienGiamToiDa(BigDecimal soTienGiamToiDa) { this.soTienGiamToiDa = soTienGiamToiDa; }

    public LocalDate getNgayBatDau() { return ngayBatDau; }
    public void setNgayBatDau(LocalDate ngayBatDau) { this.ngayBatDau = ngayBatDau; }

    public LocalDate getNgayKetThuc() { return ngayKetThuc; }
    public void setNgayKetThuc(LocalDate ngayKetThuc) { this.ngayKetThuc = ngayKetThuc; }

    public Integer getSoLuong() { return soLuong; }
    public void setSoLuong(Integer soLuong) { this.soLuong = soLuong; }

    public List<Order> getOrders() { return orders; }
    public void setOrders(List<Order> orders) { this.orders = orders; }
}
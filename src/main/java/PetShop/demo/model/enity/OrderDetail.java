package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tblChiTietHoaDon")
public class OrderDetail {

    @EmbeddedId
    private OrderDetailId id;

    @ManyToOne
    @MapsId("maHD")
    @JoinColumn(name = "MaHD")
    private Order order;

    @ManyToOne
    @MapsId("maSP")
    @JoinColumn(name = "MaSP")
    private Product product;

    @Column(name = "SoLuong")
    private Integer soLuong;

    @Column(name = "GiaBan")
    private BigDecimal giaBan;

    public OrderDetail() {}

    // Getters and setters
    public OrderDetailId getId() { return id; }
    public void setId(OrderDetailId id) { this.id = id; }

    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public Integer getSoLuong() { return soLuong; }
    public void setSoLuong(Integer soLuong) { this.soLuong = soLuong; }

    public BigDecimal getGiaBan() { return giaBan; }
    public void setGiaBan(BigDecimal giaBan) { this.giaBan = giaBan; }
}
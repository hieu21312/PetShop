package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "tblTinhTrang")
public class OrderStatus {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "TinhTrangDonHang")
    private String tinhTrangDonHang;

    @OneToMany(mappedBy = "orderStatus")
    private List<Order> orders;

    // Constructors
    public OrderStatus() {}

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getTinhTrangDonHang() { return tinhTrangDonHang; }
    public void setTinhTrangDonHang(String tinhTrangDonHang) { this.tinhTrangDonHang = tinhTrangDonHang; }

    public List<Order> getOrders() { return orders; }
    public void setOrders(List<Order> orders) { this.orders = orders; }
}
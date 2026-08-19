package PetShop.demo.model.enity;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "tblHoaDon")
public class Order {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaHD") private Integer maHD;
    @Column(name = "MaKH") private Integer maKH;
    @Column(name = "NgayLap") private LocalDateTime ngayLap;
    @Column(name = "TongTien") private BigDecimal tongTien;
    @Column(name = "TinhTrang") private Integer tinhTrang;
    @Column(name = "DiaChiGiaoHang") private String diaChiGiaoHang;
    @Column(name = "DaThanhToan") private Boolean daThanhToan;
    @Column(name = "MaGiamGia") private String maGiamGia;
    @Column(name = "TienGiam") private BigDecimal tienGiam;
    @Column(name = "HinhThucThanhToan") private String hinhThucThanhToan;
    @ManyToOne @JoinColumn(name = "MaKH", insertable = false, updatable = false)
    private Customer customer;
    @ManyToOne @JoinColumn(name = "TinhTrang", insertable = false, updatable = false)
    private OrderStatus orderStatus;
    @OneToMany(mappedBy = "order", fetch = FetchType.LAZY)
    private java.util.List<OrderDetail> orderDetails;

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }

    public Order() {}
    // Getters and setters (generate all)
    public Integer getMaHD() { return maHD; }
    public void setMaHD(Integer maHD) { this.maHD = maHD; }
    public Integer getMaKH() { return maKH; }
    public void setMaKH(Integer maKH) { this.maKH = maKH; }
    public LocalDateTime getNgayLap() { return ngayLap; }
    public void setNgayLap(LocalDateTime ngayLap) { this.ngayLap = ngayLap; }
    public BigDecimal getTongTien() { return tongTien; }
    public void setTongTien(BigDecimal tongTien) { this.tongTien = tongTien; }
    public Integer getTinhTrang() { return tinhTrang; }
    public void setTinhTrang(Integer tinhTrang) { this.tinhTrang = tinhTrang; }
    public String getDiaChiGiaoHang() { return diaChiGiaoHang; }
    public void setDiaChiGiaoHang(String diaChiGiaoHang) { this.diaChiGiaoHang = diaChiGiaoHang; }
    public Boolean getDaThanhToan() { return daThanhToan; }
    public void setDaThanhToan(Boolean daThanhToan) { this.daThanhToan = daThanhToan; }
    public String getMaGiamGia() { return maGiamGia; }
    public void setMaGiamGia(String maGiamGia) { this.maGiamGia = maGiamGia; }
    public BigDecimal getTienGiam() { return tienGiam; }
    public void setTienGiam(BigDecimal tienGiam) { this.tienGiam = tienGiam; }
    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }
    public OrderStatus getOrderStatus() { return orderStatus; }
    public void setOrderStatus(OrderStatus orderStatus) { this.orderStatus = orderStatus; }
    @ManyToOne
    @JoinColumn(name = "MaGiamGia", referencedColumnName = "MaGiamGia", insertable = false, updatable = false)
    private Voucher voucher;

    public Voucher getVoucher() {
        return voucher;
    }

    public void setVoucher(Voucher voucher) {
        this.voucher = voucher;
    }
    public String getHinhThucThanhToan() { return hinhThucThanhToan; }
    public void setHinhThucThanhToan(String hinhThucThanhToan) { this.hinhThucThanhToan = hinhThucThanhToan; }
}
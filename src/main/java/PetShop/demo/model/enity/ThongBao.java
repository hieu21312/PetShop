package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "tblThongBao")
public class ThongBao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaThongBao")
    private Integer maThongBao;

    @Column(name = "MaKH", nullable = false)
    private Integer maKH;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaKH", insertable = false, updatable = false)
    private Customer khachHang;

    @Column(name = "MaThuCung")
    private Integer maThuCung;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaThuCung", insertable = false, updatable = false)
    private HoSoThuCung thuCung;

    @Column(name = "TieuDe", nullable = false)
    private String tieuDe;

    @Column(name = "NoiDung")
    private String noiDung;

    @Column(name = "LoaiThongBao")
    private String loaiThongBao = "NhacLichTaiKham";

    @Column(name = "NgayTao")
    private LocalDateTime ngayTao;

    @Column(name = "NgayHen")
    private LocalDateTime ngayHen;

    @Column(name = "TrangThai")
    private String trangThai = "Chưa đọc";

    public ThongBao() {
        this.ngayTao = LocalDateTime.now();
    }

    public Integer getMaThongBao() { return maThongBao; }
    public void setMaThongBao(Integer maThongBao) { this.maThongBao = maThongBao; }

    public Integer getMaKH() { return maKH; }
    public void setMaKH(Integer maKH) { this.maKH = maKH; }

    public Customer getKhachHang() { return khachHang; }
    public void setKhachHang(Customer khachHang) { this.khachHang = khachHang; }

    public Integer getMaThuCung() { return maThuCung; }
    public void setMaThuCung(Integer maThuCung) { this.maThuCung = maThuCung; }

    public HoSoThuCung getThuCung() { return thuCung; }
    public void setThuCung(HoSoThuCung thuCung) { this.thuCung = thuCung; }

    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public String getLoaiThongBao() { return loaiThongBao; }
    public void setLoaiThongBao(String loaiThongBao) { this.loaiThongBao = loaiThongBao; }

    public LocalDateTime getNgayTao() { return ngayTao; }
    public void setNgayTao(LocalDateTime ngayTao) { this.ngayTao = ngayTao; }

    public LocalDateTime getNgayHen() { return ngayHen; }
    public void setNgayHen(LocalDateTime ngayHen) { this.ngayHen = ngayHen; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
}

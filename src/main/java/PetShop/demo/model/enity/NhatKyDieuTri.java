package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "tblNhatKyDieuTri")
public class NhatKyDieuTri {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaNhatKy")
    private Integer maNhatKy;

    @Column(name = "MaThuCung", nullable = false)
    private Integer maThuCung;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaThuCung", insertable = false, updatable = false)
    private HoSoThuCung thuCung;

    @Column(name = "MaBacSi", nullable = false)
    private Integer maBacSi;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaBacSi", insertable = false, updatable = false)
    private Employee bacSi;

    @Column(name = "NgayKham")
    private LocalDateTime ngayKham;

    @Column(name = "ChuanDoan")
    private String chuanDoan;

    @Column(name = "PhuongPhapDieuTri")
    private String phuongPhapDieuTri;

    @Column(name = "ThuocSuDung")
    private String thuocSuDung;

    @Column(name = "CanNang")
    private BigDecimal canNang;

    @Column(name = "NhietDo")
    private BigDecimal nhietDo;

    @Column(name = "TrangThaiSucKhoe")
    private String trangThaiSucKhoe = "Đang điều trị";

    @Column(name = "CanTaiKham")
    private Boolean canTaiKham = false;

    @Column(name = "NgayTaiKham")
    private LocalDateTime ngayTaiKham;

    @Column(name = "GhiChu")
    private String ghiChu;

    public NhatKyDieuTri() {
        this.ngayKham = LocalDateTime.now();
    }

    public Integer getMaNhatKy() { return maNhatKy; }
    public void setMaNhatKy(Integer maNhatKy) { this.maNhatKy = maNhatKy; }

    public Integer getMaThuCung() { return maThuCung; }
    public void setMaThuCung(Integer maThuCung) { this.maThuCung = maThuCung; }

    public HoSoThuCung getThuCung() { return thuCung; }
    public void setThuCung(HoSoThuCung thuCung) { this.thuCung = thuCung; }

    public Integer getMaBacSi() { return maBacSi; }
    public void setMaBacSi(Integer maBacSi) { this.maBacSi = maBacSi; }

    public Employee getBacSi() { return bacSi; }
    public void setBacSi(Employee bacSi) { this.bacSi = bacSi; }

    public LocalDateTime getNgayKham() { return ngayKham; }
    public void setNgayKham(LocalDateTime ngayKham) { this.ngayKham = ngayKham; }

    public String getChuanDoan() { return chuanDoan; }
    public void setChuanDoan(String chuanDoan) { this.chuanDoan = chuanDoan; }

    public String getPhuongPhapDieuTri() { return phuongPhapDieuTri; }
    public void setPhuongPhapDieuTri(String phuongPhapDieuTri) { this.phuongPhapDieuTri = phuongPhapDieuTri; }

    public String getThuocSuDung() { return thuocSuDung; }
    public void setThuocSuDung(String thuocSuDung) { this.thuocSuDung = thuocSuDung; }

    public BigDecimal getCanNang() { return canNang; }
    public void setCanNang(BigDecimal canNang) { this.canNang = canNang; }

    public BigDecimal getNhietDo() { return nhietDo; }
    public void setNhietDo(BigDecimal nhietDo) { this.nhietDo = nhietDo; }

    public String getTrangThaiSucKhoe() { return trangThaiSucKhoe; }
    public void setTrangThaiSucKhoe(String trangThaiSucKhoe) { this.trangThaiSucKhoe = trangThaiSucKhoe; }

    public Boolean getCanTaiKham() { return canTaiKham; }
    public void setCanTaiKham(Boolean canTaiKham) { this.canTaiKham = canTaiKham; }

    public LocalDateTime getNgayTaiKham() { return ngayTaiKham; }
    public void setNgayTaiKham(LocalDateTime ngayTaiKham) { this.ngayTaiKham = ngayTaiKham; }

    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }
}

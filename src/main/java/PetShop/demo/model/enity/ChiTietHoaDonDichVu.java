package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tblChiTietHoaDonDichVu")
public class ChiTietHoaDonDichVu {

    @EmbeddedId
    private ChiTietHoaDonDichVuId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("maHDDV")
    @JoinColumn(name = "MaHDDV")
    private HoaDonDichVu hoaDonDichVu;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("maDV")
    @JoinColumn(name = "MaDV")
    private PetService petService;

    @Column(name = "SoLuong")
    private Integer soLuong;

    @Column(name = "GiaDichVu")
    private BigDecimal giaDichVu;

    public ChiTietHoaDonDichVu() {}

    public ChiTietHoaDonDichVu(HoaDonDichVu hoaDonDichVu, PetService petService, Integer soLuong, BigDecimal giaDichVu) {
        this.hoaDonDichVu = hoaDonDichVu;
        this.petService = petService;
        this.soLuong = soLuong;
        this.giaDichVu = giaDichVu;
        if (hoaDonDichVu != null && petService != null) {
            this.id = new ChiTietHoaDonDichVuId(hoaDonDichVu.getMaHDDV(), petService.getMaDV());
        }
    }

    public ChiTietHoaDonDichVuId getId() {
        return id;
    }

    public void setId(ChiTietHoaDonDichVuId id) {
        this.id = id;
    }

    public HoaDonDichVu getHoaDonDichVu() {
        return hoaDonDichVu;
    }

    public void setHoaDonDichVu(HoaDonDichVu hoaDonDichVu) {
        this.hoaDonDichVu = hoaDonDichVu;
    }

    public PetService getPetService() {
        return petService;
    }

    public void setPetService(PetService petService) {
        this.petService = petService;
    }

    public Integer getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(Integer soLuong) {
        this.soLuong = soLuong;
    }

    public BigDecimal getGiaDichVu() {
        return giaDichVu;
    }

    public void setGiaDichVu(BigDecimal giaDichVu) {
        this.giaDichVu = giaDichVu;
    }
}

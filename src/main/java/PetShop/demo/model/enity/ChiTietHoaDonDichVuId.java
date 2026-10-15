package PetShop.demo.model.enity;

import jakarta.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class ChiTietHoaDonDichVuId implements Serializable {

    private Integer maHDDV;
    private Integer maDV;

    public ChiTietHoaDonDichVuId() {}

    public ChiTietHoaDonDichVuId(Integer maHDDV, Integer maDV) {
        this.maHDDV = maHDDV;
        this.maDV = maDV;
    }

    public Integer getMaHDDV() {
        return maHDDV;
    }

    public void setMaHDDV(Integer maHDDV) {
        this.maHDDV = maHDDV;
    }

    public Integer getMaDV() {
        return maDV;
    }

    public void setMaDV(Integer maDV) {
        this.maDV = maDV;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ChiTietHoaDonDichVuId that = (ChiTietHoaDonDichVuId) o;
        return Objects.equals(maHDDV, that.maHDDV) && Objects.equals(maDV, that.maDV);
    }

    @Override
    public int hashCode() {
        return Objects.hash(maHDDV, maDV);
    }
}

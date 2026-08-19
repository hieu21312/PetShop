package PetShop.demo.model.enity;

import jakarta.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class OrderDetailId implements Serializable {

    private Integer maHD;
    private Integer maSP;

    public OrderDetailId() {}

    public OrderDetailId(Integer maHD, Integer maSP) {
        this.maHD = maHD;
        this.maSP = maSP;
    }

    public Integer getMaHD() { return maHD; }
    public void setMaHD(Integer maHD) { this.maHD = maHD; }

    public Integer getMaSP() { return maSP; }
    public void setMaSP(Integer maSP) { this.maSP = maSP; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        OrderDetailId that = (OrderDetailId) o;
        return Objects.equals(maHD, that.maHD) && Objects.equals(maSP, that.maSP);
    }

    @Override
    public int hashCode() {
        return Objects.hash(maHD, maSP);
    }
}
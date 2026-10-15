package PetShop.demo.model.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.math.BigDecimal;

public class ChiTietDichVuItemDTO {

    @JsonProperty("maDV")
    @JsonAlias({"MaDV", "ma_dv", "serviceId"})
    private Integer maDV;

    @JsonProperty("tenDV")
    @JsonAlias({"TenDV", "ten_dv", "serviceName"})
    private String tenDV;

    @JsonProperty("soLuong")
    @JsonAlias({"SoLuong", "so_luong", "quantity"})
    private Integer soLuong = 1;

    @JsonProperty("giaDichVu")
    @JsonAlias({"GiaDichVu", "gia_dich_vu", "price"})
    private BigDecimal giaDichVu;

    public ChiTietDichVuItemDTO() {}

    public ChiTietDichVuItemDTO(Integer maDV, String tenDV, Integer soLuong, BigDecimal giaDichVu) {
        this.maDV = maDV;
        this.tenDV = tenDV;
        this.soLuong = soLuong;
        this.giaDichVu = giaDichVu;
    }

    public Integer getMaDV() {
        return maDV;
    }

    public void setMaDV(Integer maDV) {
        this.maDV = maDV;
    }

    public String getTenDV() {
        return tenDV;
    }

    public void setTenDV(String tenDV) {
        this.tenDV = tenDV;
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

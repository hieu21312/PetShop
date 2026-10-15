package PetShop.demo.model.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;

public class ThanhToanRequestDTO {

    @JsonProperty("phuongThucThanhToan")
    @JsonAlias({"PhuongThucThanhToan", "phuong_thuc_thanh_toan", "paymentMethod", "method"})
    private String phuongThucThanhToan;

    @JsonProperty("ghiChu")
    @JsonAlias({"GhiChu", "ghi_chu", "note"})
    private String ghiChu;

    public ThanhToanRequestDTO() {}

    public ThanhToanRequestDTO(String phuongThucThanhToan) {
        this.phuongThucThanhToan = phuongThucThanhToan;
    }

    public String getPhuongThucThanhToan() {
        return phuongThucThanhToan;
    }

    public void setPhuongThucThanhToan(String phuongThucThanhToan) {
        this.phuongThucThanhToan = phuongThucThanhToan;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }
}

package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tblDichVu")
public class PetService {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaDV")
    private Integer maDV;

    @Column(name = "TenDV")
    private String tenDV;

    @Column(name = "MoTa")
    private String moTa;

    @Column(name = "GiaDichVu")
    private BigDecimal giaDichVu;

    @Column(name = "HinhAnh")
    private String hinhAnh;

    // Constructors
    public PetService() {}

    public String getHinhAnh() {
        if (hinhAnh != null && !hinhAnh.trim().isEmpty() && !"default-service.jpg".equalsIgnoreCase(hinhAnh.trim())) {
            return hinhAnh;
        }
        return resolveDefaultImage(tenDV, maDV);
    }

    public void setHinhAnh(String hinhAnh) {
        this.hinhAnh = hinhAnh;
    }

    public static String resolveDefaultImage(String name, Integer id) {
        if (name != null) {
            String n = name.toLowerCase();
            if (n.contains("tắm") || n.contains("tam")) return "tam-goi.jpg";
            if (n.contains("tỉa") || n.contains("tia")) return "cat-tia-long.jpg";
            if (n.contains("tổng quát") || n.contains("tong quat")) return "kham-tong-quat.jpg";
            if (n.contains("tiêm") || n.contains("tiem")) return "tiem-phong.jpg";
            if (n.contains("phẫu thuật") || n.contains("phau thuat")) return "cham-soc-sau-phau-thuat.jpg";
            if (n.contains("khách sạn") || n.contains("khach san")) return "khach-san-thu-cung.jpg";
            if (n.contains("tai") || n.contains("răng") || n.contains("rang")) return "ve-sinh-tai-rang.jpg";
            if (n.contains("cạo") || n.contains("cao")) return "cao-long.jpg";
            if (n.contains("dinh dưỡng") || n.contains("dinh duong")) return "tu-van-dinh-duong.jpg";
            if (n.contains("da liễu") || n.contains("da lieu")) return "kham-da-lieu.jpg";
            if (n.contains("massage")) return "massage.jpg";
            if (n.contains("rối") || n.contains("roi")) return "go-roi-long.jpg";
            if (n.contains("móng") || n.contains("mong")) return "cham-soc-mong.jpg";
            if (n.contains("khử mùi") || n.contains("khu mui")) return "xit-khu-mui.jpg";
            if (n.contains("chụp ảnh") || n.contains("chup anh")) return "chup-anh.jpg";
            if (n.contains("đào tạo") || n.contains("dao tao")) return "dao-tao.jpg";
            if (n.contains("theo giờ") || n.contains("theo gio") || n.contains("gửi") || n.contains("gui")) return "gui-thu-cung.jpg";
            if (n.contains("cao tuổi") || n.contains("cao tuoi")) return "cham-soc-cao-tuoi.jpg";
            if (n.contains("xét nghiệm") || n.contains("xet nghiem")) return "xet-nghiem-mau.jpg";
            if (n.contains("tuyến hôi") || n.contains("tuyen hoi")) return "ve-sinh-tuyen-hoi.jpg";
        }
        if (id != null) {
            switch (id) {
                case 1: return "tam-goi.jpg";
                case 2: return "cat-tia-long.jpg";
                case 3: return "kham-tong-quat.jpg";
                case 4: return "tiem-phong.jpg";
                case 5: return "cham-soc-sau-phau-thuat.jpg";
                case 6: return "khach-san-thu-cung.jpg";
                case 7: return "ve-sinh-tai-rang.jpg";
                case 8: return "cao-long.jpg";
                case 9: return "tu-van-dinh-duong.jpg";
                case 10: return "kham-da-lieu.jpg";
                case 11: return "massage.jpg";
                case 12: return "go-roi-long.jpg";
                case 13: return "cham-soc-mong.jpg";
                case 14: return "xit-khu-mui.jpg";
                case 15: return "chup-anh.jpg";
                case 16: return "dao-tao.jpg";
                case 17: return "gui-thu-cung.jpg";
                case 18: return "cham-soc-cao-tuoi.jpg";
                case 19: return "xet-nghiem-mau.jpg";
                case 20: return "ve-sinh-tuyen-hoi.jpg";
            }
        }
        return "default-service.jpg";
    }

    // Getters and Setters
    public Integer getMaDV() { return maDV; }
    public void setMaDV(Integer maDV) { this.maDV = maDV; }

    public String getTenDV() { return tenDV; }
    public void setTenDV(String tenDV) { this.tenDV = tenDV; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public BigDecimal getGiaDichVu() { return giaDichVu; }
    public void setGiaDichVu(BigDecimal giaDichVu) { this.giaDichVu = giaDichVu; }
}

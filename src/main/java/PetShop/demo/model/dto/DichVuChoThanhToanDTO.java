package PetShop.demo.model.dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class DichVuChoThanhToanDTO {

    private String loaiDichVu; // "PHIEU_CHAM_SOC" hoặc "DAT_LICH"
    private String maDichVu;   // Ví dụ: PDV-2024-0001 hoặc BK-0001
    private Integer maPhieuDV;  // ID của tblPhieuDichVuChamSoc nếu có
    private Integer maDatLich;  // ID của tblDatLich nếu có
    private Integer maKH;       // ID khách hàng nếu đã có tài khoản
    private String tenKhachHang;
    private String soDienThoai;
    private String email;
    private String tenThuCung;
    private String tenDichVu;   // Chuỗi hiển thị tên các dịch vụ
    private Integer maNV;       // Bác sĩ / Nhân viên thực hiện
    private String tenNhanSu;
    private BigDecimal tongTien;
    private BigDecimal tienGiamGia;
    private BigDecimal thanhToan; // Tiền khách cần trả đúng với đăng ký
    private String thoiGian;
    private String ghiChu;
    private List<ChiTietDichVuItemDTO> items = new ArrayList<>();

    public DichVuChoThanhToanDTO() {}

    public String getLoaiDichVu() {
        return loaiDichVu;
    }

    public void setLoaiDichVu(String loaiDichVu) {
        this.loaiDichVu = loaiDichVu;
    }

    public String getMaDichVu() {
        return maDichVu;
    }

    public void setMaDichVu(String maDichVu) {
        this.maDichVu = maDichVu;
    }

    public Integer getMaPhieuDV() {
        return maPhieuDV;
    }

    public void setMaPhieuDV(Integer maPhieuDV) {
        this.maPhieuDV = maPhieuDV;
    }

    public Integer getMaDatLich() {
        return maDatLich;
    }

    public void setMaDatLich(Integer maDatLich) {
        this.maDatLich = maDatLich;
    }

    public Integer getMaKH() {
        return maKH;
    }

    public void setMaKH(Integer maKH) {
        this.maKH = maKH;
    }

    public String getTenKhachHang() {
        return tenKhachHang;
    }

    public void setTenKhachHang(String tenKhachHang) {
        this.tenKhachHang = tenKhachHang;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTenThuCung() {
        return tenThuCung;
    }

    public void setTenThuCung(String tenThuCung) {
        this.tenThuCung = tenThuCung;
    }

    public String getTenDichVu() {
        return tenDichVu;
    }

    public void setTenDichVu(String tenDichVu) {
        this.tenDichVu = tenDichVu;
    }

    public Integer getMaNV() {
        return maNV;
    }

    public void setMaNV(Integer maNV) {
        this.maNV = maNV;
    }

    public String getTenNhanSu() {
        return tenNhanSu;
    }

    public void setTenNhanSu(String tenNhanSu) {
        this.tenNhanSu = tenNhanSu;
    }

    public BigDecimal getTongTien() {
        return tongTien;
    }

    public void setTongTien(BigDecimal tongTien) {
        this.tongTien = tongTien;
    }

    public BigDecimal getTienGiamGia() {
        return tienGiamGia;
    }

    public void setTienGiamGia(BigDecimal tienGiamGia) {
        this.tienGiamGia = tienGiamGia;
    }

    public BigDecimal getThanhToan() {
        return thanhToan;
    }

    public void setThanhToan(BigDecimal thanhToan) {
        this.thanhToan = thanhToan;
    }

    public String getThoiGian() {
        return thoiGian;
    }

    public void setThoiGian(String thoiGian) {
        this.thoiGian = thoiGian;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public List<ChiTietDichVuItemDTO> getItems() {
        return items;
    }

    public void setItems(List<ChiTietDichVuItemDTO> items) {
        this.items = items;
    }
}

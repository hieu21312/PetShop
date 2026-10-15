package PetShop.demo.service;

import PetShop.demo.model.enity.ChiTietHoaDonDichVu;
import PetShop.demo.model.enity.ChiTietHoaDonDichVuId;
import PetShop.demo.model.enity.HoaDonDichVu;
import PetShop.demo.model.enity.PetService;
import PetShop.demo.repository.ChiTietHoaDonDichVuRepository;
import PetShop.demo.repository.HoaDonDichVuRepository;
import PetShop.demo.repository.PetServiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class HoaDonDichVuService {

    @Autowired
    private HoaDonDichVuRepository hoaDonDichVuRepository;

    @Autowired
    private ChiTietHoaDonDichVuRepository chiTietHoaDonDichVuRepository;

    @Autowired
    private PetServiceRepository petServiceRepository;

    /**
     * Logic 1: Tạo hóa đơn dịch vụ mới với trạng thái mặc định là 'ChuaThanhToan'
     *
     * @param hoaDon Đối tượng hóa đơn dịch vụ cần tạo
     * @return Hóa đơn dịch vụ đã được lưu thành công
     */
    @Transactional
    public HoaDonDichVu createHoaDon(HoaDonDichVu hoaDon) {
        if (hoaDon == null) {
            throw new IllegalArgumentException("Thông tin hóa đơn không được để trống!");
        }

        // Đảm bảo thời gian sử dụng được gán
        if (hoaDon.getNgaySuDung() == null) {
            hoaDon.setNgaySuDung(LocalDateTime.now());
        }

        // Luôn gán trạng thái khởi tạo là 'ChuaThanhToan'
        hoaDon.setTrangThai(HoaDonDichVu.TRANG_THAI_CHUA_THANH_TOAN);

        // Đảm bảo tổng tiền không bị null
        if (hoaDon.getTongTien() == null) {
            hoaDon.setTongTien(BigDecimal.ZERO);
        }

        return hoaDonDichVuRepository.save(hoaDon);
    }

    /**
     * Logic 1 (Overload tiện lợi): Tạo hóa đơn dịch vụ mới theo các tham số cơ bản
     *
     * @param maKH Mã khách hàng (có thể null nếu khách vãng lai)
     * @param maNV Mã nhân viên lập hóa đơn/phục vụ
     * @param tongTien Tổng tiền dịch vụ
     * @param phuongThucThanhToan Phương thức thanh toán dự kiến (Tiền mặt, Chuyển khoản,...)
     * @param ghiChu Ghi chú thêm
     * @return Hóa đơn dịch vụ mới với trạng thái 'ChuaThanhToan'
     */
    @Transactional
    public HoaDonDichVu createHoaDon(Integer maKH, Integer maNV, BigDecimal tongTien,
                                     String phuongThucThanhToan, String ghiChu) {
        HoaDonDichVu hoaDon = new HoaDonDichVu();
        hoaDon.setMaKH(maKH);
        hoaDon.setMaNV(maNV);
        hoaDon.setTongTien(tongTien != null ? tongTien : BigDecimal.ZERO);
        hoaDon.setPhuongThucThanhToan(phuongThucThanhToan);
        hoaDon.setGhiChu(ghiChu);
        hoaDon.setNgaySuDung(LocalDateTime.now());
        hoaDon.setTrangThai(HoaDonDichVu.TRANG_THAI_CHUA_THANH_TOAN);

        return hoaDonDichVuRepository.save(hoaDon);
    }

    /**
     * Logic 1 (Nâng cao): Tạo hóa đơn kèm theo danh sách chi tiết các dịch vụ sử dụng
     * Tự động tính toán tổng tiền từ các dịch vụ con và gán trạng thái 'ChuaThanhToan'
     */
    @Transactional
    public HoaDonDichVu createHoaDonWithDetails(Integer maKH, Integer maNV, String phuongThucThanhToan,
                                                String ghiChu, List<ChiTietHoaDonDichVu> chiTiets) {
        HoaDonDichVu hoaDon = new HoaDonDichVu();
        hoaDon.setMaKH(maKH);
        hoaDon.setMaNV(maNV);
        hoaDon.setPhuongThucThanhToan(phuongThucThanhToan);
        hoaDon.setGhiChu(ghiChu);
        hoaDon.setNgaySuDung(LocalDateTime.now());
        hoaDon.setTrangThai(HoaDonDichVu.TRANG_THAI_CHUA_THANH_TOAN);

        BigDecimal tongTien = BigDecimal.ZERO;
        if (chiTiets != null && !chiTiets.isEmpty()) {
            for (ChiTietHoaDonDichVu ct : chiTiets) {
                if (ct.getGiaDichVu() != null && ct.getSoLuong() != null) {
                    BigDecimal thanhTien = ct.getGiaDichVu().multiply(BigDecimal.valueOf(ct.getSoLuong()));
                    tongTien = tongTien.add(thanhTien);
                }
            }
        }
        hoaDon.setTongTien(tongTien);

        HoaDonDichVu savedHoaDon = hoaDonDichVuRepository.save(hoaDon);

        if (chiTiets != null && !chiTiets.isEmpty()) {
            for (ChiTietHoaDonDichVu ct : chiTiets) {
                ct.setHoaDonDichVu(savedHoaDon);
                if (ct.getPetService() != null) {
                    ct.setId(new ChiTietHoaDonDichVuId(savedHoaDon.getMaHDDV(), ct.getPetService().getMaDV()));
                }
                chiTietHoaDonDichVuRepository.save(ct);
            }
        }

        return savedHoaDon;
    }

    /**
     * Logic 2: Cập nhật trạng thái thành 'DaThanhToan' sau khi có xác nhận
     *
     * @param maHDDV Mã hóa đơn dịch vụ cần xác nhận thanh toán
     * @return Hóa đơn dịch vụ đã được cập nhật trạng thái 'DaThanhToan'
     */
    @Transactional
    public HoaDonDichVu xacNhanThanhToan(Integer maHDDV) {
        if (maHDDV == null) {
            throw new IllegalArgumentException("Mã hóa đơn dịch vụ không được để trống!");
        }

        HoaDonDichVu hoaDon = hoaDonDichVuRepository.findById(maHDDV)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn dịch vụ với mã: " + maHDDV));

        hoaDon.setTrangThai(HoaDonDichVu.TRANG_THAI_DA_THANH_TOAN);
        return hoaDonDichVuRepository.save(hoaDon);
    }

    /**
     * Logic 2 (Overload): Cập nhật trạng thái thành 'DaThanhToan' kèm cập nhật phương thức thanh toán
     *
     * @param maHDDV Mã hóa đơn dịch vụ
     * @param phuongThucThanhToan Phương thức thanh toán được xác nhận (Tiền mặt, Chuyển khoản, VNPay,...)
     * @return Hóa đơn dịch vụ đã được cập nhật
     */
    @Transactional
    public HoaDonDichVu xacNhanThanhToan(Integer maHDDV, String phuongThucThanhToan) {
        if (maHDDV == null) {
            throw new IllegalArgumentException("Mã hóa đơn dịch vụ không được để trống!");
        }

        HoaDonDichVu hoaDon = hoaDonDichVuRepository.findById(maHDDV)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn dịch vụ với mã: " + maHDDV));

        hoaDon.setTrangThai(HoaDonDichVu.TRANG_THAI_DA_THANH_TOAN);
        if (phuongThucThanhToan != null && !phuongThucThanhToan.trim().isEmpty()) {
            hoaDon.setPhuongThucThanhToan(phuongThucThanhToan.trim());
        }

        return hoaDonDichVuRepository.save(hoaDon);
    }

    /**
     * Cập nhật trạng thái tùy chỉnh cho hóa đơn dịch vụ
     */
    @Transactional
    public HoaDonDichVu capNhatTrangThai(Integer maHDDV, String trangThai) {
        if (maHDDV == null) {
            throw new IllegalArgumentException("Mã hóa đơn dịch vụ không được để trống!");
        }

        HoaDonDichVu hoaDon = hoaDonDichVuRepository.findById(maHDDV)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn dịch vụ với mã: " + maHDDV));

        hoaDon.setTrangThai(trangThai);
        return hoaDonDichVuRepository.save(hoaDon);
    }

    // Các phương thức truy vấn hỗ trợ
    public Optional<HoaDonDichVu> getHoaDonById(Integer maHDDV) {
        if (maHDDV == null) return Optional.empty();
        return hoaDonDichVuRepository.findById(maHDDV);
    }

    public List<HoaDonDichVu> getAllHoaDon() {
        return hoaDonDichVuRepository.findAllByOrderByNgaySuDungDesc();
    }

    public List<HoaDonDichVu> getHoaDonByTrangThai(String trangThai) {
        if (trangThai == null || trangThai.isBlank()) {
            return getAllHoaDon();
        }
        return hoaDonDichVuRepository.findByTrangThaiOrderByNgaySuDungDesc(trangThai.trim());
    }

    public List<HoaDonDichVu> getHoaDonChuaThanhToan() {
        return hoaDonDichVuRepository.findByTrangThaiOrderByNgaySuDungDesc(HoaDonDichVu.TRANG_THAI_CHUA_THANH_TOAN);
    }

    public List<HoaDonDichVu> getHoaDonDaThanhToan() {
        return hoaDonDichVuRepository.findByTrangThaiOrderByNgaySuDungDesc(HoaDonDichVu.TRANG_THAI_DA_THANH_TOAN);
    }

    public List<HoaDonDichVu> getHoaDonByKhachHang(Integer maKH) {
        if (maKH == null) return List.of();
        return hoaDonDichVuRepository.findByMaKHOrderByNgaySuDungDesc(maKH);
    }

    @Transactional
    public void deleteHoaDon(Integer maHDDV) {
        if (maHDDV != null && hoaDonDichVuRepository.existsById(maHDDV)) {
            hoaDonDichVuRepository.deleteById(maHDDV);
        }
    }
}

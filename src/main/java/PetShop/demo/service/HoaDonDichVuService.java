package PetShop.demo.service;

import PetShop.demo.model.dto.ChiTietDichVuItemDTO;
import PetShop.demo.model.dto.DichVuChoThanhToanDTO;
import PetShop.demo.model.enity.*;
import PetShop.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
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

    @Autowired
    private PhieuDichVuChamSocRepository phieuRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private ChiTietDichVuChamSocRepository chiTietDichVuChamSocRepository;

    @Autowired
    private MembershipService membershipService;

    /**
     * Logic 1: Tạo hóa đơn dịch vụ mới với trạng thái mặc định là 'ChuaThanhToan'
     */
    @Transactional
    public HoaDonDichVu createHoaDon(HoaDonDichVu hoaDon) {
        if (hoaDon == null) {
            throw new IllegalArgumentException("Thông tin hóa đơn không được để trống!");
        }

        if (hoaDon.getNgaySuDung() == null) {
            hoaDon.setNgaySuDung(LocalDateTime.now());
        }

        hoaDon.setTrangThai(HoaDonDichVu.TRANG_THAI_CHUA_THANH_TOAN);

        if (hoaDon.getTongTien() == null) {
            hoaDon.setTongTien(BigDecimal.ZERO);
        }

        return hoaDonDichVuRepository.save(hoaDon);
    }

    /**
     * Logic 1 (Overload tiện lợi): Tạo hóa đơn dịch vụ mới theo các tham số cơ bản
     */
    @Transactional
    public HoaDonDichVu createHoaDon(Integer maKH, Integer maNV, BigDecimal tongTien,
                                     String phuongThucThanhToan, String ghiChu) {
        return createHoaDon(maKH, maNV, tongTien, phuongThucThanhToan, ghiChu, null, null);
    }

    /**
     * Logic 1 (Mở rộng): Tạo hóa đơn có liên kết trực tiếp tới Mã phiếu chăm sóc hoặc Mã đặt lịch
     */
    @Transactional
    public HoaDonDichVu createHoaDon(Integer maKH, Integer maNV, BigDecimal tongTien,
                                     String phuongThucThanhToan, String ghiChu,
                                     Integer maPhieuDV, Integer maDatLich) {
        HoaDonDichVu hoaDon = new HoaDonDichVu();
        hoaDon.setMaKH(maKH);
        hoaDon.setMaNV(maNV);
        hoaDon.setTongTien(tongTien != null ? tongTien : BigDecimal.ZERO);
        hoaDon.setPhuongThucThanhToan(phuongThucThanhToan);
        hoaDon.setGhiChu(ghiChu);
        hoaDon.setMaPhieuDV(maPhieuDV);
        hoaDon.setMaDatLich(maDatLich);
        hoaDon.setNgaySuDung(LocalDateTime.now());
        hoaDon.setTrangThai(HoaDonDichVu.TRANG_THAI_CHUA_THANH_TOAN);

        return hoaDonDichVuRepository.save(hoaDon);
    }

    /**
     * Logic 1 (Nâng cao): Tạo hóa đơn kèm theo danh sách chi tiết các dịch vụ sử dụng
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
     * Tự động đồng bộ sang Phiếu dịch vụ hoặc Lịch đặt gốc!
     */
    @Transactional
    public HoaDonDichVu xacNhanThanhToan(Integer maHDDV) {
        return xacNhanThanhToan(maHDDV, null);
    }

    /**
     * Logic 2 (Overload): Cập nhật trạng thái thành 'DaThanhToan' kèm cập nhật phương thức thanh toán
     * Đồng thời tự động cập nhật phiếu chăm sóc / lịch đặt thành "Đã thanh toán" và cộng điểm thành viên.
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

        // Tự động đồng bộ trạng thái sang Phiếu dịch vụ chăm sóc gốc nếu có
        if (hoaDon.getMaPhieuDV() != null) {
            phieuRepository.findById(hoaDon.getMaPhieuDV()).ifPresent(ticket -> {
                ticket.setTrangThaiThanhToan("Đã thanh toán");
                if (ticket.getHinhThucThanhToan() == null || ticket.getHinhThucThanhToan().isBlank()) {
                    ticket.setHinhThucThanhToan(hoaDon.getPhuongThucThanhToan() != null ? hoaDon.getPhuongThucThanhToan() : "Tiền mặt");
                }
                membershipService.processCareTicketPoints(ticket);
                phieuRepository.save(ticket);
            });
        }

        // Tự động đồng bộ trạng thái sang Lịch đặt dịch vụ gốc nếu có
        if (hoaDon.getMaDatLich() != null) {
            bookingRepository.findById(hoaDon.getMaDatLich()).ifPresent(b -> {
                b.setTrangThai("Đã thanh toán");
                b.setTrangThaiThanhToan("Đã thanh toán");
                bookingRepository.save(b);
            });
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

    /**
     * Tra cứu hóa đơn theo ID
     */
    public Optional<HoaDonDichVu> getHoaDonById(Integer maHDDV) {
        return hoaDonDichVuRepository.findById(maHDDV);
    }

    /**
     * Lấy toàn bộ danh sách hóa đơn theo thứ tự mới nhất
     */
    public List<HoaDonDichVu> getAllHoaDons() {
        return hoaDonDichVuRepository.findAllByOrderByNgaySuDungDesc();
    }

    public List<HoaDonDichVu> getAllHoaDon() {
        return hoaDonDichVuRepository.findAllByOrderByNgaySuDungDesc();
    }

    public List<HoaDonDichVu> getHoaDonByTrangThai(String trangThai) {
        return hoaDonDichVuRepository.findByTrangThaiOrderByNgaySuDungDesc(trangThai);
    }

    /**
     * THÔNG SUỐT DỊCH VỤ: Lấy danh sách toàn bộ dịch vụ đã được Bác sĩ hoặc Nhân viên chăm sóc
     * xác nhận hoàn thành nhưng chưa thanh toán, sẵn sàng chuyển qua cho Thu ngân thanh toán.
     */
    public List<DichVuChoThanhToanDTO> getDanhSachDichVuChoThanhToan() {
        List<DichVuChoThanhToanDTO> list = new ArrayList<>();

        // 1. Phiếu dịch vụ chăm sóc tại quầy đã hoàn thành nhưng chưa thanh toán
        List<PhieuDichVuChamSoc> tickets = phieuRepository.findCompletedAwaitingPayment();
        for (PhieuDichVuChamSoc t : tickets) {
            DichVuChoThanhToanDTO dto = new DichVuChoThanhToanDTO();
            dto.setLoaiDichVu("PHIEU_CHAM_SOC");
            dto.setMaDichVu(t.getSoPhieu());
            dto.setMaPhieuDV(t.getMaPhieuDV());

            if (t.getChuNuoi() != null) {
                dto.setTenKhachHang(t.getChuNuoi().getHoTenChuNuoi());
                dto.setSoDienThoai(t.getChuNuoi().getSoDienThoai());
                dto.setEmail(t.getChuNuoi().getEmail());
                dto.setMaKH(t.getChuNuoi().getMaKH());
            } else {
                dto.setTenKhachHang("Khách lẻ");
                dto.setSoDienThoai("");
            }

            if (t.getThuCung() != null) {
                String petInfo = t.getThuCung().getTenThuCung();
                if (t.getThuCung().getLoaiThuCung() != null && !t.getThuCung().getLoaiThuCung().isBlank()) {
                    petInfo += " (" + t.getThuCung().getLoaiThuCung() + ")";
                }
                dto.setTenThuCung(petInfo);
            } else {
                dto.setTenThuCung("");
            }

            if (t.getNvThucHien() != null) {
                dto.setTenNhanSu(t.getNvThucHien().getTenNV());
                dto.setMaNV(t.getNvThucHien().getMaNV());
            } else {
                dto.setTenNhanSu("Chưa phân công");
            }

            dto.setTongTien(t.getTongTien() != null ? t.getTongTien() : BigDecimal.ZERO);
            dto.setTienGiamGia(t.getTienGiamGia() != null ? t.getTienGiamGia() : BigDecimal.ZERO);
            BigDecimal payAmount = (t.getThanhToan() != null && t.getThanhToan().compareTo(BigDecimal.ZERO) > 0)
                    ? t.getThanhToan() : dto.getTongTien().subtract(dto.getTienGiamGia());
            if (payAmount.compareTo(BigDecimal.ZERO) < 0) payAmount = BigDecimal.ZERO;
            dto.setThanhToan(payAmount);

            dto.setTenDichVu(t.getYeuCauCuaChuNuoi() != null && !t.getYeuCauCuaChuNuoi().isBlank()
                    ? t.getYeuCauCuaChuNuoi() : "Dịch vụ chăm sóc thú cưng");
            dto.setGhiChu(t.getGhiChu());
            if (t.getNgayTiepNhan() != null) {
                dto.setThoiGian(t.getNgayTiepNhan().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
            }

            // Chi tiết dịch vụ
            List<ChiTietDichVuChamSoc> ctdvs = chiTietDichVuChamSocRepository.findByMaPhieuDV(t.getMaPhieuDV());
            if (ctdvs != null && !ctdvs.isEmpty()) {
                for (ChiTietDichVuChamSoc c : ctdvs) {
                    ChiTietDichVuItemDTO item = new ChiTietDichVuItemDTO();
                    item.setMaDV(c.getMaDVCS() != null ? c.getMaDVCS() : 1);
                    item.setTenDV(c.getDichVuChamSoc() != null ? c.getDichVuChamSoc().getTenDichVu() : ("Dịch vụ #" + c.getMaDVCS()));
                    item.setSoLuong(c.getSoLuong() != null ? c.getSoLuong() : 1);
                    item.setGiaDichVu(c.getThanhTien() != null ? c.getThanhTien() : (c.getDonGia() != null ? c.getDonGia() : BigDecimal.ZERO));
                    dto.getItems().add(item);
                }
            } else {
                ChiTietDichVuItemDTO item = new ChiTietDichVuItemDTO();
                item.setMaDV(1);
                item.setTenDV(dto.getTenDichVu());
                item.setSoLuong(1);
                item.setGiaDichVu(dto.getThanhToan());
                dto.getItems().add(item);
            }

            list.add(dto);
        }

        // 2. Lịch đặt dịch vụ online đã được bác sĩ / nhân viên xác nhận hoàn thành nhưng chưa thanh toán
        List<Booking> bookings = bookingRepository.findCompletedAwaitingPayment();
        for (Booking b : bookings) {
            DichVuChoThanhToanDTO dto = new DichVuChoThanhToanDTO();
            dto.setLoaiDichVu("DAT_LICH");
            dto.setMaDichVu(b.getMaDichVu());
            dto.setMaDatLich(b.getMaDatLich());
            dto.setTenKhachHang(b.getTenKhachHang() != null ? b.getTenKhachHang() : "Khách online");
            dto.setSoDienThoai(b.getSoDienThoai() != null ? b.getSoDienThoai() : "");
            dto.setEmail(b.getEmail());
            dto.setMaKH(b.getMaKH());
            dto.setTenThuCung(b.getGhiChu() != null ? b.getGhiChu() : "");

            String serviceName = (b.getPetService() != null && b.getPetService().getTenDV() != null)
                    ? b.getPetService().getTenDV() : ("Dịch vụ #" + b.getMaDV());
            BigDecimal servicePrice = (b.getPetService() != null && b.getPetService().getGiaDichVu() != null)
                    ? b.getPetService().getGiaDichVu() : BigDecimal.ZERO;

            dto.setTenDichVu(serviceName);
            dto.setTongTien(servicePrice);
            dto.setTienGiamGia(BigDecimal.ZERO);
            dto.setThanhToan(servicePrice);

            if (b.getEmployee() != null) {
                dto.setTenNhanSu(b.getEmployee().getTenNV());
                dto.setMaNV(b.getEmployee().getMaNV());
            } else {
                dto.setTenNhanSu("Chưa phân công");
            }

            String timeStr = "";
            if (b.getNgayDat() != null) {
                timeStr += b.getNgayDat().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            }
            if (b.getGioDat() != null) {
                timeStr += " " + b.getGioDat().toString();
            }
            dto.setThoiGian(timeStr.trim());
            dto.setGhiChu(b.getGhiChu());

            ChiTietDichVuItemDTO item = new ChiTietDichVuItemDTO();
            item.setMaDV(b.getMaDV() != null ? b.getMaDV() : 1);
            item.setTenDV(serviceName);
            item.setSoLuong(1);
            item.setGiaDichVu(servicePrice);
            dto.getItems().add(item);

            list.add(dto);
        }

        return list;
    }

    /**
     * THÔNG SUỐT DỊCH VỤ: Tra cứu nhanh một mã dịch vụ (theo số phiếu PDV-... hoặc mã đặt lịch BK-...)
     * để thu ngân có thể quét/gõ mã và tải dữ liệu lên thanh toán tự động ngay tức thì.
     */
    public Optional<DichVuChoThanhToanDTO> traCuuDichVuTheoMa(String rawCode) {
        if (rawCode == null || rawCode.trim().isEmpty()) {
            return Optional.empty();
        }
        String code = rawCode.trim();

        // 1. Kiểm tra Phiếu dịch vụ chăm sóc theo số phiếu
        Optional<PhieuDichVuChamSoc> ticketOpt = phieuRepository.findBySoPhieuIgnoreCase(code);
        if (ticketOpt.isEmpty()) {
            ticketOpt = phieuRepository.findBySoPhieu(code);
        }
        if (ticketOpt.isEmpty() && code.matches("\\d+")) {
            ticketOpt = phieuRepository.findById(Integer.parseInt(code));
        }

        if (ticketOpt.isPresent()) {
            PhieuDichVuChamSoc t = ticketOpt.get();
            DichVuChoThanhToanDTO dto = new DichVuChoThanhToanDTO();
            dto.setLoaiDichVu("PHIEU_CHAM_SOC");
            dto.setMaDichVu(t.getSoPhieu());
            dto.setMaPhieuDV(t.getMaPhieuDV());

            if (t.getChuNuoi() != null) {
                dto.setTenKhachHang(t.getChuNuoi().getHoTenChuNuoi());
                dto.setSoDienThoai(t.getChuNuoi().getSoDienThoai());
                dto.setEmail(t.getChuNuoi().getEmail());
                dto.setMaKH(t.getChuNuoi().getMaKH());
            } else {
                dto.setTenKhachHang("Khách lẻ");
                dto.setSoDienThoai("");
            }

            if (t.getThuCung() != null) {
                String petInfo = t.getThuCung().getTenThuCung();
                if (t.getThuCung().getLoaiThuCung() != null && !t.getThuCung().getLoaiThuCung().isBlank()) {
                    petInfo += " (" + t.getThuCung().getLoaiThuCung() + ")";
                }
                dto.setTenThuCung(petInfo);
            }

            if (t.getNvThucHien() != null) {
                dto.setTenNhanSu(t.getNvThucHien().getTenNV());
                dto.setMaNV(t.getNvThucHien().getMaNV());
            } else {
                dto.setTenNhanSu("Chưa phân công");
            }

            dto.setTongTien(t.getTongTien() != null ? t.getTongTien() : BigDecimal.ZERO);
            dto.setTienGiamGia(t.getTienGiamGia() != null ? t.getTienGiamGia() : BigDecimal.ZERO);
            BigDecimal payAmount = (t.getThanhToan() != null && t.getThanhToan().compareTo(BigDecimal.ZERO) > 0)
                    ? t.getThanhToan() : dto.getTongTien().subtract(dto.getTienGiamGia());
            if (payAmount.compareTo(BigDecimal.ZERO) < 0) payAmount = BigDecimal.ZERO;
            dto.setThanhToan(payAmount);

            dto.setTenDichVu(t.getYeuCauCuaChuNuoi() != null && !t.getYeuCauCuaChuNuoi().isBlank()
                    ? t.getYeuCauCuaChuNuoi() : "Dịch vụ chăm sóc thú cưng");
            dto.setGhiChu(t.getGhiChu());
            if (t.getNgayTiepNhan() != null) {
                dto.setThoiGian(t.getNgayTiepNhan().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
            }

            List<ChiTietDichVuChamSoc> ctdvs = chiTietDichVuChamSocRepository.findByMaPhieuDV(t.getMaPhieuDV());
            if (ctdvs != null && !ctdvs.isEmpty()) {
                for (ChiTietDichVuChamSoc c : ctdvs) {
                    ChiTietDichVuItemDTO item = new ChiTietDichVuItemDTO();
                    item.setMaDV(c.getMaDVCS() != null ? c.getMaDVCS() : 1);
                    item.setTenDV(c.getDichVuChamSoc() != null ? c.getDichVuChamSoc().getTenDichVu() : ("Dịch vụ #" + c.getMaDVCS()));
                    item.setSoLuong(c.getSoLuong() != null ? c.getSoLuong() : 1);
                    item.setGiaDichVu(c.getThanhTien() != null ? c.getThanhTien() : (c.getDonGia() != null ? c.getDonGia() : BigDecimal.ZERO));
                    dto.getItems().add(item);
                }
            } else {
                ChiTietDichVuItemDTO item = new ChiTietDichVuItemDTO();
                item.setMaDV(1);
                item.setTenDV(dto.getTenDichVu());
                item.setSoLuong(1);
                item.setGiaDichVu(dto.getThanhToan());
                dto.getItems().add(item);
            }
            return Optional.of(dto);
        }

        // 2. Kiểm tra Booking theo mã
        Integer bookingId = null;
        if (code.toUpperCase().startsWith("BK-")) {
            try { bookingId = Integer.parseInt(code.substring(3)); } catch (Exception ignored) {}
        } else if (code.toUpperCase().startsWith("BK")) {
            try { bookingId = Integer.parseInt(code.substring(2)); } catch (Exception ignored) {}
        } else if (code.toUpperCase().startsWith("DL-")) {
            try { bookingId = Integer.parseInt(code.substring(3)); } catch (Exception ignored) {}
        } else if (code.matches("\\d+")) {
            try { bookingId = Integer.parseInt(code); } catch (Exception ignored) {}
        }

        if (bookingId != null) {
            Optional<Booking> bOpt = bookingRepository.findById(bookingId);
            if (bOpt.isPresent()) {
                Booking b = bOpt.get();
                DichVuChoThanhToanDTO dto = new DichVuChoThanhToanDTO();
                dto.setLoaiDichVu("DAT_LICH");
                dto.setMaDichVu(b.getMaDichVu());
                dto.setMaDatLich(b.getMaDatLich());
                dto.setTenKhachHang(b.getTenKhachHang() != null ? b.getTenKhachHang() : "Khách online");
                dto.setSoDienThoai(b.getSoDienThoai() != null ? b.getSoDienThoai() : "");
                dto.setEmail(b.getEmail());
                dto.setMaKH(b.getMaKH());
                dto.setTenThuCung(b.getGhiChu() != null ? b.getGhiChu() : "");

                String serviceName = (b.getPetService() != null && b.getPetService().getTenDV() != null)
                        ? b.getPetService().getTenDV() : ("Dịch vụ #" + b.getMaDV());
                BigDecimal servicePrice = (b.getPetService() != null && b.getPetService().getGiaDichVu() != null)
                        ? b.getPetService().getGiaDichVu() : BigDecimal.ZERO;

                dto.setTenDichVu(serviceName);
                dto.setTongTien(servicePrice);
                dto.setTienGiamGia(BigDecimal.ZERO);
                dto.setThanhToan(servicePrice);

                if (b.getEmployee() != null) {
                    dto.setTenNhanSu(b.getEmployee().getTenNV());
                    dto.setMaNV(b.getEmployee().getMaNV());
                } else {
                    dto.setTenNhanSu("Chưa phân công");
                }

                String timeStr = "";
                if (b.getNgayDat() != null) {
                    timeStr += b.getNgayDat().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                }
                if (b.getGioDat() != null) {
                    timeStr += " " + b.getGioDat().toString();
                }
                dto.setThoiGian(timeStr.trim());
                dto.setGhiChu(b.getGhiChu());

                ChiTietDichVuItemDTO item = new ChiTietDichVuItemDTO();
                item.setMaDV(b.getMaDV() != null ? b.getMaDV() : 1);
                item.setTenDV(serviceName);
                item.setSoLuong(1);
                item.setGiaDichVu(servicePrice);
                dto.getItems().add(item);

                return Optional.of(dto);
            }
        }

        return Optional.empty();
    }
}

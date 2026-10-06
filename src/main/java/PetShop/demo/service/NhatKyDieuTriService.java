package PetShop.demo.service;

import PetShop.demo.model.enity.HoSoThuCung;
import PetShop.demo.model.enity.NhatKyDieuTri;
import PetShop.demo.repository.HoSoThuCungRepository;
import PetShop.demo.repository.NhatKyDieuTriRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Service
public class NhatKyDieuTriService {

    @Autowired
    private NhatKyDieuTriRepository nhatKyDieuTriRepository;

    @Autowired
    private HoSoThuCungRepository hoSoThuCungRepository;

    @Autowired
    private ThongBaoService thongBaoService;

    public List<NhatKyDieuTri> getLichSuDieuTriByThuCung(Integer maThuCung) {
        return nhatKyDieuTriRepository.findByMaThuCungOrderByNgayKhamDesc(maThuCung);
    }

    public List<HoSoThuCung> getDanhSachThuCungDangDieuTri() {
        // Lấy danh sách thú cưng có trạng thái 'Đang điều trị' hoặc mặc định tất cả hồ sơ thú cưng
        List<HoSoThuCung> list = hoSoThuCungRepository.findAll();
        return list;
    }

    public Optional<HoSoThuCung> getHoSoThuCung(Integer maThuCung) {
        return hoSoThuCungRepository.findById(maThuCung);
    }

    @Transactional
    public NhatKyDieuTri taoNhatKyDieuTri(NhatKyDieuTri nhatKy) {
        if (nhatKy.getNgayKham() == null) {
            nhatKy.setNgayKham(LocalDateTime.now());
        }

        // 1. Lưu nhật ký điều trị mới
        NhatKyDieuTri savedLog = nhatKyDieuTriRepository.save(nhatKy);

        // 2. Cập nhật trạng thái sức khỏe hiện tại trong Hồ sơ thú cưng
        Optional<HoSoThuCung> thuCungOpt = hoSoThuCungRepository.findById(nhatKy.getMaThuCung());
        if (thuCungOpt.isPresent()) {
            HoSoThuCung thuCung = thuCungOpt.get();
            if (nhatKy.getTrangThaiSucKhoe() != null && !nhatKy.getTrangThaiSucKhoe().isBlank()) {
                thuCung.setTinhTrangSucKhoeHienTai(nhatKy.getTrangThaiSucKhoe());
            }
            if (nhatKy.getCanNang() != null) {
                thuCung.setCanNang(nhatKy.getCanNang());
            }
            hoSoThuCungRepository.save(thuCung);

            // 3. Nếu Bác sĩ chọn "Cần tái khám" -> Kích hoạt Hệ thống gửi Thông báo nhắc lịch cho Khách hàng
            if (Boolean.TRUE.equals(nhatKy.getCanTaiKham()) && nhatKy.getNgayTaiKham() != null) {
                Integer maKhachHang = (thuCung.getChuNuoi() != null && thuCung.getChuNuoi().getMaKH() != null) 
                        ? thuCung.getChuNuoi().getMaKH() 
                        : thuCung.getMaChuNuoi();
                String tenThuCung = thuCung.getTenThuCung() != null ? thuCung.getTenThuCung() : "Thú cưng";
                String ngayStr = nhatKy.getNgayTaiKham().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));

                String tieuDe = "Lịch hẹn tái khám cho " + tenThuCung;
                String noiDung = "Bác sĩ đã lên lịch tái khám cho bé " + tenThuCung + " vào lúc " + ngayStr 
                        + ". Chẩn đoán gần nhất: " + (nhatKy.getChuanDoan() != null ? nhatKy.getChuanDoan() : "Đang theo dõi")
                        + ". Vui lòng đưa bé đến phòng khám đúng giờ!";

                thongBaoService.taoThongBaoNhacLich(maKhachHang, thuCung.getMaThuCung(), tieuDe, noiDung, nhatKy.getNgayTaiKham());
            }
        }

        return savedLog;
    }
}

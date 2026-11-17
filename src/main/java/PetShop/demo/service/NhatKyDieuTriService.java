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

        NhatKyDieuTri savedLog = nhatKyDieuTriRepository.save(nhatKy);

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

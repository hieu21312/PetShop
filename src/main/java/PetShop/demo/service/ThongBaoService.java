package PetShop.demo.service;

import PetShop.demo.model.enity.ThongBao;
import PetShop.demo.repository.ThongBaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ThongBaoService {

    @Autowired
    private ThongBaoRepository thongBaoRepository;

    public ThongBao taoThongBaoNhacLich(Integer maKH, Integer maThuCung, String tieuDe, String noiDung, LocalDateTime ngayHen) {
        ThongBao tb = new ThongBao();
        tb.setMaKH(maKH);
        tb.setMaThuCung(maThuCung);
        tb.setTieuDe(tieuDe);
        tb.setNoiDung(noiDung);
        tb.setLoaiThongBao("NhacLichTaiKham");
        tb.setNgayTao(LocalDateTime.now());
        tb.setNgayHen(ngayHen);
        tb.setTrangThai("Chưa đọc");
        return thongBaoRepository.save(tb);
    }

    public ThongBao taoThongBaoDatLich(Integer maKH, String tieuDe, String noiDung, LocalDateTime ngayHen, String loaiThongBao) {
        return taoThongBaoDatLich(maKH, tieuDe, noiDung, ngayHen, loaiThongBao, null);
    }

    public ThongBao taoThongBaoDatLich(Integer maKH, String tieuDe, String noiDung, LocalDateTime ngayHen, String loaiThongBao, String lienKet) {
        if (maKH == null) return null;
        ThongBao tb = new ThongBao();
        tb.setMaKH(maKH);
        tb.setTieuDe(tieuDe);
        tb.setNoiDung(noiDung);
        tb.setLoaiThongBao(loaiThongBao != null ? loaiThongBao : "XacNhanDatLich");
        tb.setLienKet(lienKet);
        tb.setNgayTao(LocalDateTime.now());
        tb.setNgayHen(ngayHen);
        tb.setTrangThai("Chưa đọc");
        return thongBaoRepository.save(tb);
    }

    // Tạo thông báo cho toàn bộ nhân sự (Thu ngân, Admin, v.v...) hoặc cho một nhân viên cụ thể
    public ThongBao taoThongBaoStaff(String tieuDe, String noiDung, String loaiThongBao, String lienKet) {
        return taoThongBaoStaff(null, tieuDe, noiDung, loaiThongBao, lienKet);
    }

    public ThongBao taoThongBaoStaff(Integer maNV, String tieuDe, String noiDung, String loaiThongBao, String lienKet) {
        ThongBao tb = new ThongBao();
        tb.setMaNV(maNV);
        tb.setMaKH(null);
        tb.setTieuDe(tieuDe);
        tb.setNoiDung(noiDung);
        tb.setLoaiThongBao(loaiThongBao != null ? loaiThongBao : "XacNhanThanhToan");
        tb.setLienKet(lienKet);
        tb.setNgayTao(LocalDateTime.now());
        tb.setTrangThai("Chưa đọc");
        return thongBaoRepository.save(tb);
    }

    public List<ThongBao> getThongBaoByCustomer(Integer maKH) {
        return thongBaoRepository.findByMaKHOrderByNgayTaoDesc(maKH);
    }

    public List<ThongBao> getThongBaoChuaDoc(Integer maKH) {
        return thongBaoRepository.findByMaKHAndTrangThaiOrderByNgayTaoDesc(maKH, "Chưa đọc");
    }

    public long demThongBaoChuaDoc(Integer maKH) {
        return thongBaoRepository.countByMaKHAndTrangThai(maKH, "Chưa đọc");
    }

    public List<ThongBao> getThongBaoStaff(Integer maNV) {
        return thongBaoRepository.findStaffNotifications(maNV);
    }

    public long demThongBaoStaffChuaDoc(Integer maNV) {
        return thongBaoRepository.countStaffNotifications(maNV, "Chưa đọc");
    }

    public ThongBao danhDauDaDoc(Integer maThongBao) {
        if (maThongBao == null) return null;
        var opt = thongBaoRepository.findById(maThongBao);
        if (opt.isPresent()) {
            ThongBao tb = opt.get();
            tb.setTrangThai("Đã đọc");
            return thongBaoRepository.save(tb);
        }
        return null;
    }

    public void dánhDauDaDoc(Integer maThongBao) {
        danhDauDaDoc(maThongBao);
    }

    public void danhDauTatCaDaDoc(Integer maKH) {
        if (maKH == null) return;
        List<ThongBao> unread = getThongBaoChuaDoc(maKH);
        if (!unread.isEmpty()) {
            for (ThongBao tb : unread) {
                tb.setTrangThai("Đã đọc");
            }
            thongBaoRepository.saveAll(unread);
        }
    }

    public void danhDauTatCaStaffDaDoc(Integer maNV) {
        List<ThongBao> list = getThongBaoStaff(maNV);
        if (!list.isEmpty()) {
            for (ThongBao tb : list) {
                if (!"Đã đọc".equalsIgnoreCase(tb.getTrangThai())) {
                    tb.setTrangThai("Đã đọc");
                }
            }
            thongBaoRepository.saveAll(list);
        }
    }
}

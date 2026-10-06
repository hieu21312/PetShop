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

    public List<ThongBao> getThongBaoByCustomer(Integer maKH) {
        return thongBaoRepository.findByMaKHOrderByNgayTaoDesc(maKH);
    }

    public List<ThongBao> getThongBaoChuaDoc(Integer maKH) {
        return thongBaoRepository.findByMaKHAndTrangThaiOrderByNgayTaoDesc(maKH, "Chưa đọc");
    }

    public long demThongBaoChuaDoc(Integer maKH) {
        return thongBaoRepository.countByMaKHAndTrangThai(maKH, "Chưa đọc");
    }

    public void dánhDauDaDoc(Integer maThongBao) {
        thongBaoRepository.findById(maThongBao).ifPresent(tb -> {
            tb.setTrangThai("Đã đọc");
            thongBaoRepository.save(tb);
        });
    }
}

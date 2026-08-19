package PetShop.demo.service;

import PetShop.demo.model.enity.Voucher;
import PetShop.demo.repository.VoucherRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class VoucherService {
    @Autowired private VoucherRepository voucherRepository;

    public List<Voucher> getAllVouchers() {
        return voucherRepository.findAll();
    }

    public Optional<Voucher> getVoucherByCode(String code) {
        return voucherRepository.findByMaGiamGia(code);
    }

    public Voucher saveVoucher(Voucher voucher) {
        return voucherRepository.save(voucher);
    }

    public void deleteVoucher(String code) {
        voucherRepository.deleteById(code);
    }

    public boolean isVoucherValid(String code) {
        Optional<Voucher> opt = voucherRepository.findByMaGiamGia(code);
        if (opt.isEmpty()) return false;
        Voucher v = opt.get();
        LocalDate now = LocalDate.now();
        return v.getSoLuong() > 0 && now.isAfter(v.getNgayBatDau()) && now.isBefore(v.getNgayKetThuc());
    }
}
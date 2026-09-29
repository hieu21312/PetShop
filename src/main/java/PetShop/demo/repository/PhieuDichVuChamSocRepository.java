package PetShop.demo.repository;

import PetShop.demo.model.enity.PhieuDichVuChamSoc;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PhieuDichVuChamSocRepository extends JpaRepository<PhieuDichVuChamSoc, Integer> {
    List<PhieuDichVuChamSoc> findByOrderByNgayTiepNhanDesc();
    List<PhieuDichVuChamSoc> findByTrangThaiDichVu(String trangThaiDichVu);
    List<PhieuDichVuChamSoc> findByMaChuNuoi(Integer maChuNuoi);
    List<PhieuDichVuChamSoc> findByMaThuCung(Integer maThuCung);
}

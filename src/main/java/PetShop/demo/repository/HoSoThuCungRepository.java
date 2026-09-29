package PetShop.demo.repository;

import PetShop.demo.model.enity.HoSoThuCung;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface HoSoThuCungRepository extends JpaRepository<HoSoThuCung, Integer> {
    List<HoSoThuCung> findByMaChuNuoi(Integer maChuNuoi);
    List<HoSoThuCung> findByLoaiThuCung(String loaiThuCung);
    List<HoSoThuCung> findByTenThuCungContainingIgnoreCaseOrGiongLoaiContainingIgnoreCase(String ten, String giong);
}

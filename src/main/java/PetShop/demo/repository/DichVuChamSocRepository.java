package PetShop.demo.repository;

import PetShop.demo.model.enity.DichVuChamSoc;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DichVuChamSocRepository extends JpaRepository<DichVuChamSoc, Integer> {
    List<DichVuChamSoc> findByNhomDichVu(String nhomDichVu);
    List<DichVuChamSoc> findByTrangThai(String trangThai);
}

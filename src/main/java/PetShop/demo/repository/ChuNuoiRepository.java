package PetShop.demo.repository;

import PetShop.demo.model.enity.ChuNuoi;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ChuNuoiRepository extends JpaRepository<ChuNuoi, Integer> {
    Optional<ChuNuoi> findBySoDienThoai(String soDienThoai);
    List<ChuNuoi> findByHoTenChuNuoiContainingIgnoreCaseOrSoDienThoaiContaining(String hoTen, String sdt);
}

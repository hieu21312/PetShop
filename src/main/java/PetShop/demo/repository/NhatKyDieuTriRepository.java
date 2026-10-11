package PetShop.demo.repository;

import PetShop.demo.model.enity.NhatKyDieuTri;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NhatKyDieuTriRepository extends JpaRepository<NhatKyDieuTri, Integer> {
    List<NhatKyDieuTri> findByMaThuCungOrderByNgayKhamDesc(Integer maThuCung);
    List<NhatKyDieuTri> findByMaBacSiOrderByNgayKhamDesc(Integer maBacSi);
    List<NhatKyDieuTri> findByCanTaiKhamTrueOrderByNgayTaiKhamAsc();
}

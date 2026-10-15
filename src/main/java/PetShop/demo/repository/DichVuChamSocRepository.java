package PetShop.demo.repository;

import PetShop.demo.model.enity.DichVuChamSoc;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DichVuChamSocRepository extends JpaRepository<DichVuChamSoc, Integer> {
    List<DichVuChamSoc> findByNhomDichVu(String nhomDichVu);
    List<DichVuChamSoc> findByTrangThai(String trangThai);

    @Query(value = "SELECT dv.TenDichVu, COUNT(ct.MaChiTiet) AS soLuot " +
            "FROM tblDichVuChamSoc dv " +
            "LEFT JOIN tblChiTietDichVuChamSoc ct ON dv.MaDVCS = ct.MaDVCS " +
            "GROUP BY dv.MaDVCS, dv.TenDichVu " +
            "ORDER BY soLuot DESC", nativeQuery = true)
    List<Object[]> findTopServices();
}

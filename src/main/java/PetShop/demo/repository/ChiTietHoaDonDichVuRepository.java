package PetShop.demo.repository;

import PetShop.demo.model.enity.ChiTietHoaDonDichVu;
import PetShop.demo.model.enity.ChiTietHoaDonDichVuId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChiTietHoaDonDichVuRepository extends JpaRepository<ChiTietHoaDonDichVu, ChiTietHoaDonDichVuId> {

    List<ChiTietHoaDonDichVu> findById_MaHDDV(Integer maHDDV);

    void deleteById_MaHDDV(Integer maHDDV);
}

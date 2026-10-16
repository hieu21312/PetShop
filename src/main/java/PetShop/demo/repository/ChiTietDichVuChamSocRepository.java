package PetShop.demo.repository;

import PetShop.demo.model.enity.ChiTietDichVuChamSoc;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChiTietDichVuChamSocRepository extends JpaRepository<ChiTietDichVuChamSoc, Integer> {
    List<ChiTietDichVuChamSoc> findByMaPhieuDV(Integer maPhieuDV);
}

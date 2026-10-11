package PetShop.demo.repository;

import PetShop.demo.model.enity.ThongBao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ThongBaoRepository extends JpaRepository<ThongBao, Integer> {
    List<ThongBao> findByMaKHOrderByNgayTaoDesc(Integer maKH);
    List<ThongBao> findByMaKHAndTrangThaiOrderByNgayTaoDesc(Integer maKH, String trangThai);
    long countByMaKHAndTrangThai(Integer maKH, String trangThai);
}

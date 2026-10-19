package PetShop.demo.repository;

import PetShop.demo.model.enity.ThongBao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ThongBaoRepository extends JpaRepository<ThongBao, Integer> {
    List<ThongBao> findByMaKHOrderByNgayTaoDesc(Integer maKH);
    List<ThongBao> findByMaKHAndTrangThaiOrderByNgayTaoDesc(Integer maKH, String trangThai);
    long countByMaKHAndTrangThai(Integer maKH, String trangThai);

    @Query("SELECT tb FROM ThongBao tb WHERE (tb.maNV = :maNV OR (tb.maNV IS NULL AND tb.maKH IS NULL)) ORDER BY tb.ngayTao DESC")
    List<ThongBao> findStaffNotifications(@Param("maNV") Integer maNV);

    @Query("SELECT COUNT(tb) FROM ThongBao tb WHERE (tb.maNV = :maNV OR (tb.maNV IS NULL AND tb.maKH IS NULL)) AND tb.trangThai = :trangThai")
    long countStaffNotifications(@Param("maNV") Integer maNV, @Param("trangThai") String trangThai);
}

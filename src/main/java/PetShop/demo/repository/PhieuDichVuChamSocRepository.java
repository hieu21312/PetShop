package PetShop.demo.repository;

import PetShop.demo.model.enity.PhieuDichVuChamSoc;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface PhieuDichVuChamSocRepository extends JpaRepository<PhieuDichVuChamSoc, Integer> {
    List<PhieuDichVuChamSoc> findByOrderByNgayTiepNhanDesc();
    List<PhieuDichVuChamSoc> findByTrangThaiDichVu(String trangThaiDichVu);
    List<PhieuDichVuChamSoc> findByMaChuNuoi(Integer maChuNuoi);
    List<PhieuDichVuChamSoc> findByMaThuCung(Integer maThuCung);
    List<PhieuDichVuChamSoc> findByMaNVThucHienAndTrangThaiDichVuIn(Integer maNVThucHien, List<String> trangThaiList);
    List<PhieuDichVuChamSoc> findByMaThuCungAndTrangThaiDichVuIn(Integer maThuCung, List<String> trangThaiList);

    @Query(value = "SELECT CAST(p.NgayTiepNhan AS date) as ngay, SUM(ISNULL(p.ThanhToan, p.TongTien)) as doanhThu " +
            "FROM tblPhieuDichVuChamSoc p WHERE p.NgayTiepNhan >= :sevenDaysAgo GROUP BY CAST(p.NgayTiepNhan AS date)",
            nativeQuery = true)
    List<Object[]> getLast7DaysRevenue(@Param("sevenDaysAgo") LocalDateTime sevenDaysAgo);

    @Query("SELECT p FROM PhieuDichVuChamSoc p WHERE p.ngayTiepNhan >= :from AND p.ngayTiepNhan <= :to ORDER BY p.ngayTiepNhan ASC")
    List<PhieuDichVuChamSoc> findTicketsBetween(@Param("from") LocalDateTime from, @Param("to") LocalDateTime to);

    @Query("SELECT p FROM PhieuDichVuChamSoc p " +
           "LEFT JOIN p.thuCung tc " +
           "LEFT JOIN p.chuNuoi cn " +
           "LEFT JOIN p.nvThucHien nv " +
           "WHERE (:status IS NULL OR :status = '' OR :status = 'All' OR p.trangThaiDichVu = :status) " +
           "AND (:keyword IS NULL OR :keyword = '' OR " +
           "LOWER(p.soPhieu) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(tc.tenThuCung) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(cn.hoTenChuNuoi) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "cn.soDienThoai LIKE CONCAT('%', :keyword, '%') OR " +
           "LOWER(nv.tenNV) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
           "ORDER BY p.ngayTiepNhan DESC")
    List<PhieuDichVuChamSoc> searchTickets(@Param("status") String status, @Param("keyword") String keyword);
}

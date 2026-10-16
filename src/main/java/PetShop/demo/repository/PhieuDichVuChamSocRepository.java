package PetShop.demo.repository;

import PetShop.demo.model.enity.PhieuDichVuChamSoc;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface PhieuDichVuChamSocRepository extends JpaRepository<PhieuDichVuChamSoc, Integer> {
    List<PhieuDichVuChamSoc> findByOrderByNgayTiepNhanDesc();
    List<PhieuDichVuChamSoc> findByTrangThaiDichVu(String trangThaiDichVu);
    List<PhieuDichVuChamSoc> findByMaChuNuoi(Integer maChuNuoi);
    List<PhieuDichVuChamSoc> findByMaThuCung(Integer maThuCung);
    List<PhieuDichVuChamSoc> findByMaNVThucHienOrderByNgayTiepNhanDesc(Integer maNVThucHien);
    List<PhieuDichVuChamSoc> findByMaNVThucHienAndTrangThaiDichVuIn(Integer maNVThucHien, List<String> trangThaiList);
    List<PhieuDichVuChamSoc> findByMaThuCungAndTrangThaiDichVuIn(Integer maThuCung, List<String> trangThaiList);

    Optional<PhieuDichVuChamSoc> findBySoPhieu(String soPhieu);
    Optional<PhieuDichVuChamSoc> findBySoPhieuIgnoreCase(String soPhieu);

    // Lấy danh sách phiếu theo nhân sự phụ trách hoặc chưa phân công
    @Query("SELECT p FROM PhieuDichVuChamSoc p WHERE p.maNVThucHien = :maNV OR p.maNVThucHien IS NULL ORDER BY p.ngayTiepNhan DESC")
    List<PhieuDichVuChamSoc> findStaffAndUnassignedTickets(@Param("maNV") Integer maNV);

    // Lấy danh sách phiếu dịch vụ đã hoàn thành hoặc đã bàn giao nhưng chưa thanh toán (chờ Thu ngân thanh toán)
    @Query("SELECT p FROM PhieuDichVuChamSoc p WHERE p.trangThaiDichVu IN ('Hoàn thành chăm sóc', 'Đã bàn giao thú cưng') AND (p.trangThaiThanhToan IS NULL OR p.trangThaiThanhToan != 'Đã thanh toán') ORDER BY p.ngayTiepNhan DESC")
    List<PhieuDichVuChamSoc> findCompletedAwaitingPayment();

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

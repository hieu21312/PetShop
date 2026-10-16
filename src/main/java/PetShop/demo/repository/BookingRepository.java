package PetShop.demo.repository;

import PetShop.demo.model.enity.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Integer> {
    List<Booking> findByMaKHOrderByNgayTaoDesc(Integer maKH);
    List<Booking> findByMaNVOrderByNgayTaoDesc(Integer maNV);
    List<Booking> findBySoDienThoaiOrderByNgayTaoDesc(String soDienThoai);

    @Query("SELECT b FROM Booking b WHERE (b.maKH IS NOT NULL AND b.maKH = :maKH) OR (b.soDienThoai IS NOT NULL AND :phone IS NOT NULL AND b.soDienThoai = :phone) OR (b.email IS NOT NULL AND :email IS NOT NULL AND b.email = :email) ORDER BY b.ngayTao DESC")
    List<Booking> findCustomerBookings(@Param("maKH") Integer maKH, @Param("phone") String phone, @Param("email") String email);

    List<Booking> findAllByOrderByNgayTaoDesc();
    long countByNgayDatAndGioDatAndTrangThaiNot(LocalDate ngayDat, LocalTime gioDat, String trangThai);
    long countByMaNVAndNgayDatAndGioDatAndTrangThaiNot(Integer maNV, LocalDate ngayDat, LocalTime gioDat, String trangThai);
    long countByMaNVAndNgayDatAndGioDatAndTrangThaiNotAndMaDatLichNot(Integer maNV, LocalDate ngayDat, LocalTime gioDat, String trangThai, Integer maDatLich);
    long countByTrangThai(String trangThai);
    List<Booking> findByTrangThaiOrderByNgayTaoDesc(String trangThai);

    // Lấy danh sách lịch đặt theo nhân sự phụ trách hoặc chưa phân công
    @Query("SELECT b FROM Booking b WHERE b.maNV = :maNV OR b.maNV IS NULL ORDER BY b.ngayTao DESC")
    List<Booking> findStaffAndUnassignedBookings(@Param("maNV") Integer maNV);

    // Lấy danh sách lịch đặt dịch vụ hoàn thành chờ thanh toán
    @Query("SELECT b FROM Booking b WHERE b.trangThai = 'Hoàn thành' AND (b.trangThaiThanhToan IS NULL OR b.trangThaiThanhToan != 'Đã thanh toán') ORDER BY b.ngayDat DESC, b.gioDat DESC")
    List<Booking> findCompletedAwaitingPayment();
}

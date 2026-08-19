package PetShop.demo.repository;

import PetShop.demo.model.enity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDateTime;
import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Integer> {
    List<Order> findByMaKHOrderByNgayLapDesc(Integer maKH);
    List<Order> findAllByOrderByNgayLapDesc();

    @Query("SELECT o FROM Order o WHERE o.ngayLap >= :from AND o.ngayLap <= :to AND o.tinhTrang = 4")
    List<Order> findCompletedOrdersBetween(@Param("from") LocalDateTime from, @Param("to") LocalDateTime to);

    // Sửa native query để lấy doanh thu 7 ngày
    @Query(value = "SELECT CAST(o.NgayLap AS date) as ngay, SUM(o.TongTien) as doanhThu " +
            "FROM tblHoaDon o WHERE o.NgayLap >= :sevenDaysAgo GROUP BY CAST(o.NgayLap AS date)",
            nativeQuery = true)
    List<Object[]> getLast7DaysRevenue(@Param("sevenDaysAgo") LocalDateTime sevenDaysAgo);

    long count();
}
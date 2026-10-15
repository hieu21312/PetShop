package PetShop.demo.repository;

import PetShop.demo.model.enity.OrderDetail;
import PetShop.demo.model.enity.OrderDetailId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface OrderDetailRepository extends JpaRepository<OrderDetail, OrderDetailId> {
    List<OrderDetail> findById_MaHD(Integer maHD);

    @Query("SELECT od.product.tenSP, SUM(od.soLuong) FROM OrderDetail od GROUP BY od.product.tenSP ORDER BY SUM(od.soLuong) DESC")
    List<Object[]> findTopSellingProducts();
}
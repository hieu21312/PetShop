package PetShop.demo.repository;

import PetShop.demo.model.enity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Integer> {
    List<Product> findByLoaiSanPham(String loaiSanPham);
    List<Product> findByTenSPContainingIgnoreCaseOrMoTaContainingIgnoreCase(String ten, String moTa);

    @Query("SELECT p FROM Product p WHERE " +
            "(:loai IS NULL OR p.loaiSanPham = :loai) AND " +
            "(:search IS NULL OR LOWER(p.tenSP) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(p.moTa) LIKE LOWER(CONCAT('%', :search, '%')))")
    List<Product> filterProducts(@Param("loai") String loai, @Param("search") String search);
}
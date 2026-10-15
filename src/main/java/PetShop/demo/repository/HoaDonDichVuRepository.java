package PetShop.demo.repository;

import PetShop.demo.model.enity.HoaDonDichVu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HoaDonDichVuRepository extends JpaRepository<HoaDonDichVu, Integer> {

    List<HoaDonDichVu> findByTrangThai(String trangThai);

    List<HoaDonDichVu> findByTrangThaiOrderByNgaySuDungDesc(String trangThai);

    List<HoaDonDichVu> findByMaKHOrderByNgaySuDungDesc(Integer maKH);

    List<HoaDonDichVu> findByMaNVOrderByNgaySuDungDesc(Integer maNV);

    List<HoaDonDichVu> findAllByOrderByNgaySuDungDesc();

    long countByTrangThai(String trangThai);

    @Modifying
    @Query("UPDATE HoaDonDichVu h SET h.trangThai = :trangThai WHERE h.maHDDV = :maHDDV")
    int updateTrangThai(@Param("maHDDV") Integer maHDDV, @Param("trangThai") String trangThai);

    @Modifying
    @Query("UPDATE HoaDonDichVu h SET h.trangThai = :trangThai, h.phuongThucThanhToan = :phuongThuc WHERE h.maHDDV = :maHDDV")
    int updateTrangThaiVaPhuongThuc(@Param("maHDDV") Integer maHDDV,
                                   @Param("trangThai") String trangThai,
                                   @Param("phuongThuc") String phuongThuc);
}

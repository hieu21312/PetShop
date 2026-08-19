package PetShop.demo.repository;

import PetShop.demo.model.enity.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Integer> {
    List<Booking> findByMaKHOrderByNgayTaoDesc(Integer maKH);
    List<Booking> findAllByOrderByNgayTaoDesc();
}
package PetShop.demo.service;

import PetShop.demo.model.enity.Booking;
import PetShop.demo.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class BookingService {

    @Autowired
    private BookingRepository bookingRepository;

    public Booking saveBooking(Booking booking) {
        booking.setNgayTao(LocalDateTime.now());
        booking.setTrangThai("Chờ xác nhận");
        return bookingRepository.save(booking);
    }

    public List<Booking> getAllBookings() {
        return bookingRepository.findAllByOrderByNgayTaoDesc();
    }

    public List<Booking> getBookingsByCustomer(Integer maKH) {
        return bookingRepository.findByMaKHOrderByNgayTaoDesc(maKH);
    }

    public Booking getBookingById(Integer id) {
        return bookingRepository.findById(id).orElse(null);
    }

    public void updateStatus(Integer id, String trangThai) {
        Booking b = getBookingById(id);
        if (b != null) {
            b.setTrangThai(trangThai);
            bookingRepository.save(b);
        }
    }

    public void deleteBooking(Integer id) {
        bookingRepository.deleteById(id);
    }
}
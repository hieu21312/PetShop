package PetShop.demo.service;

import PetShop.demo.model.enity.Booking;
import PetShop.demo.model.enity.Customer;
import PetShop.demo.repository.BookingRepository;
import PetShop.demo.repository.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Service
public class BookingService {

    private static final int MAX_BOOKINGS_PER_SLOT = 3;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private CustomerRepository customerRepository;

    public boolean isSlotAvailable(LocalDate date, LocalTime time) {
        long count = bookingRepository.countByNgayDatAndGioDatAndTrangThaiNot(date, time, "Đã hủy");
        return count < MAX_BOOKINGS_PER_SLOT;
    }

    public Booking saveBooking(Booking booking) {
        // Tra cứu tự động MaKH theo SĐT hoặc Email nếu MaKH chưa được gán
        if (booking.getMaKH() == null) {
            Optional<Customer> customerOpt = Optional.empty();
            if (booking.getSoDienThoai() != null && !booking.getSoDienThoai().isBlank()) {
                customerOpt = customerRepository.findByDienThoai(booking.getSoDienThoai().trim());
            }
            if (customerOpt.isEmpty() && booking.getEmail() != null && !booking.getEmail().isBlank()) {
                customerOpt = customerRepository.findByEmail(booking.getEmail().trim());
            }
            customerOpt.ifPresent(c -> booking.setMaKH(c.getMaKH()));
        }

        booking.setNgayTao(LocalDateTime.now());
        if (booking.getTrangThai() == null || booking.getTrangThai().isBlank()) {
            booking.setTrangThai("Chờ xác nhận");
        }
        return bookingRepository.save(booking);
    }

    public List<Booking> getAllBookings() {
        return bookingRepository.findAllByOrderByNgayTaoDesc();
    }

    public List<Booking> getBookingsByCustomer(Integer maKH) {
        return bookingRepository.findByMaKHOrderByNgayTaoDesc(maKH);
    }

    public List<Booking> getBookingsForCustomer(Integer maKH, String phone, String email) {
        if (maKH == null && (phone == null || phone.isBlank()) && (email == null || email.isBlank())) {
            return List.of();
        }
        return bookingRepository.findCustomerBookings(maKH, phone, email);
    }

    public List<Booking> getBookingsByPhone(String phone) {
        if (phone == null || phone.isBlank()) return List.of();
        return bookingRepository.findBySoDienThoaiOrderByNgayTaoDesc(phone.trim());
    }

    public List<Booking> getBookingsByStaff(Integer maNV) {
        return bookingRepository.findByMaNVOrderByNgayTaoDesc(maNV);
    }

    public boolean isStaffAvailable(Integer maNV, LocalDate date, LocalTime time) {
        return isStaffAvailable(maNV, date, time, null);
    }

    public boolean isStaffAvailable(Integer maNV, LocalDate date, LocalTime time, Integer currentBookingId) {
        if (maNV == null || date == null || time == null) return true;
        long count;
        if (currentBookingId != null) {
            count = bookingRepository.countByMaNVAndNgayDatAndGioDatAndTrangThaiNotAndMaDatLichNot(maNV, date, time, "Đã hủy", currentBookingId);
        } else {
            count = bookingRepository.countByMaNVAndNgayDatAndGioDatAndTrangThaiNot(maNV, date, time, "Đã hủy");
        }
        return count == 0;
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

    public void updateProgressAndNotes(Integer id, String trangThai, String ghiChu) {
        Booking b = getBookingById(id);
        if (b != null) {
            if (trangThai != null && !trangThai.isBlank()) {
                b.setTrangThai(trangThai);
            }
            if (ghiChu != null) {
                b.setGhiChu(ghiChu.trim());
            }
            bookingRepository.save(b);
        }
    }

    public void assignStaff(Integer id, Integer maNV) {
        Booking b = getBookingById(id);
        if (b != null) {
            b.setMaNV(maNV);
            bookingRepository.save(b);
        }
    }

    public void deleteBooking(Integer id) {
        bookingRepository.deleteById(id);
    }
}
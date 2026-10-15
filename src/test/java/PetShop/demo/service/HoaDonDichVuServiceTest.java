package PetShop.demo.service;

import PetShop.demo.model.enity.HoaDonDichVu;
import PetShop.demo.repository.ChiTietHoaDonDichVuRepository;
import PetShop.demo.repository.HoaDonDichVuRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class HoaDonDichVuServiceTest {

    @Mock
    private HoaDonDichVuRepository hoaDonDichVuRepository;

    @Mock
    private ChiTietHoaDonDichVuRepository chiTietHoaDonDichVuRepository;

    @InjectMocks
    private HoaDonDichVuService hoaDonDichVuService;

    private HoaDonDichVu sampleHoaDon;

    @BeforeEach
    void setUp() {
        sampleHoaDon = new HoaDonDichVu();
        sampleHoaDon.setMaHDDV(1);
        sampleHoaDon.setMaKH(10);
        sampleHoaDon.setMaNV(2);
        sampleHoaDon.setTongTien(new BigDecimal("250000"));
        sampleHoaDon.setGhiChu("Tắm gội cho cún");
    }

    @Test
    void testCreateHoaDon_SetsChuaThanhToan() {
        when(hoaDonDichVuRepository.save(any(HoaDonDichVu.class))).thenAnswer(invocation -> invocation.getArgument(0));

        HoaDonDichVu created = hoaDonDichVuService.createHoaDon(sampleHoaDon);

        assertNotNull(created);
        assertEquals(HoaDonDichVu.TRANG_THAI_CHUA_THANH_TOAN, created.getTrangThai());
        assertNotNull(created.getNgaySuDung());
        verify(hoaDonDichVuRepository, times(1)).save(sampleHoaDon);
    }

    @Test
    void testXacNhanThanhToan_UpdatesStatusToDaThanhToan() {
        sampleHoaDon.setTrangThai(HoaDonDichVu.TRANG_THAI_CHUA_THANH_TOAN);
        when(hoaDonDichVuRepository.findById(1)).thenReturn(Optional.of(sampleHoaDon));
        when(hoaDonDichVuRepository.save(any(HoaDonDichVu.class))).thenAnswer(invocation -> invocation.getArgument(0));

        HoaDonDichVu updated = hoaDonDichVuService.xacNhanThanhToan(1, "ChuyenKhoan");

        assertNotNull(updated);
        assertEquals(HoaDonDichVu.TRANG_THAI_DA_THANH_TOAN, updated.getTrangThai());
        assertEquals("ChuyenKhoan", updated.getPhuongThucThanhToan());
        verify(hoaDonDichVuRepository, times(1)).save(sampleHoaDon);
    }
}

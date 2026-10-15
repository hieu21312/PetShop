package PetShop.demo.service;

import PetShop.demo.model.enity.HoaDonDichVu;
import PetShop.demo.utils.VNPayUtils;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class VNPayServiceTest {

    @Mock
    private HoaDonDichVuService hoaDonDichVuService;

    @InjectMocks
    private VNPayService vnPayService;

    private final String secretKey = "26QDYK2N8JUGD9051M395H3Z8J00D740";

    @BeforeEach
    void setUp() {
        ReflectionTestUtils.setField(vnPayService, "tmnCode", "DEMOVNP1");
        ReflectionTestUtils.setField(vnPayService, "hashSecret", secretKey);
        ReflectionTestUtils.setField(vnPayService, "payUrl", "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html");
        ReflectionTestUtils.setField(vnPayService, "returnUrl", "http://localhost:8080/api/vnpay/return");
        ReflectionTestUtils.setField(vnPayService, "version", "2.1.0");
        ReflectionTestUtils.setField(vnPayService, "command", "pay");
    }

    @Test
    void testCreatePaymentUrl_GeneratesValidUrl() {
        String paymentUrl = vnPayService.createPaymentUrl(
                15,
                new BigDecimal("250000"),
                "Thanh toan hoa don #15",
                "127.0.0.1",
                null
        );

        assertNotNull(paymentUrl);
        assertTrue(paymentUrl.startsWith("https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?"));
        assertTrue(paymentUrl.contains("vnp_Amount=25000000"));
        assertTrue(paymentUrl.contains("vnp_TmnCode=DEMOVNP1"));
        assertTrue(paymentUrl.contains("vnp_SecureHash="));
    }

    @Test
    void testCreatePaymentQRCodeBase64_GeneratesDataUrl() {
        String sampleUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=25000000";
        String qrBase64 = vnPayService.createPaymentQRCodeBase64(sampleUrl, 200, 200);

        assertNotNull(qrBase64);
        assertTrue(qrBase64.startsWith("data:image/png;base64,"));
    }

    @Test
    void testProcessIpn_Success_UpdatesHoaDonToDaThanhToan() {
        HoaDonDichVu hd = new HoaDonDichVu();
        hd.setMaHDDV(20);
        hd.setTongTien(new BigDecimal("300000"));
        hd.setTrangThai(HoaDonDichVu.TRANG_THAI_CHUA_THANH_TOAN);

        when(hoaDonDichVuService.getHoaDonById(20)).thenReturn(Optional.of(hd));

        Map<String, String> vnpParams = new HashMap<>();
        vnpParams.put("vnp_Version", "2.1.0");
        vnpParams.put("vnp_Command", "pay");
        vnpParams.put("vnp_TmnCode", "DEMOVNP1");
        vnpParams.put("vnp_Amount", "30000000"); // 300,000 VND
        vnpParams.put("vnp_TxnRef", "HDDV_20_123456789");
        vnpParams.put("vnp_ResponseCode", "00");
        vnpParams.put("vnp_TransactionStatus", "00");

        String query = VNPayUtils.buildQueryUrl(vnpParams, secretKey);
        String secureHash = query.substring(query.indexOf("&vnp_SecureHash=") + "&vnp_SecureHash=".length());
        vnpParams.put("vnp_SecureHash", secureHash);

        Map<String, String> result = vnPayService.processIpn(vnpParams);

        assertNotNull(result);
        assertEquals("00", result.get("RspCode"));
        assertEquals("Confirm Success", result.get("Message"));
        verify(hoaDonDichVuService, times(1)).xacNhanThanhToan(eq(20), eq("VNPay"));
    }

    @Test
    void testProcessIpn_InvalidChecksum_Returns97() {
        Map<String, String> vnpParams = new HashMap<>();
        vnpParams.put("vnp_Amount", "10000000");
        vnpParams.put("vnp_TxnRef", "HDDV_20");
        vnpParams.put("vnp_SecureHash", "invalid_hash");

        Map<String, String> result = vnPayService.processIpn(vnpParams);

        assertEquals("97", result.get("RspCode"));
        assertEquals("Invalid Checksum", result.get("Message"));
        verify(hoaDonDichVuService, never()).xacNhanThanhToan(anyInt(), anyString());
    }
}

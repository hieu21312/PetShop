package PetShop.demo.utils;

import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class VNPayUtilsTest {

    private final String secretKey = "26QDYK2N8JUGD9051M395H3Z8J00D740";

    @Test
    void testHmacSHA512_ProducesValidHex() {
        String data = "vnp_Amount=10000000&vnp_Command=pay&vnp_TmnCode=DEMOVNP1";
        String hash = VNPayUtils.hmacSHA512(secretKey, data);

        assertNotNull(hash);
        assertEquals(128, hash.length(), "HMAC SHA512 hex string must be 128 chars long");
    }

    @Test
    void testBuildQueryUrl_And_VerifySignature() {
        Map<String, String> params = new HashMap<>();
        params.put("vnp_Version", "2.1.0");
        params.put("vnp_Command", "pay");
        params.put("vnp_TmnCode", "DEMOVNP1");
        params.put("vnp_Amount", "25000000");
        params.put("vnp_TxnRef", "HDDV_123");

        String queryUrl = VNPayUtils.buildQueryUrl(params, secretKey);
        assertNotNull(queryUrl);
        assertTrue(queryUrl.contains("vnp_SecureHash="));

        // Tách hash ra để kiểm tra verifySignature
        String[] parts = queryUrl.split("&vnp_SecureHash=");
        assertEquals(2, parts.length);
        String secureHash = parts[1];

        params.put("vnp_SecureHash", secureHash);
        boolean isValid = VNPayUtils.verifySignature(params, secretKey);
        assertTrue(isValid, "Chữ ký phải hợp lệ khi không bị thay đổi");

        // Giả mạo dữ liệu
        params.put("vnp_Amount", "99999999");
        boolean isTamperedValid = VNPayUtils.verifySignature(params, secretKey);
        assertFalse(isTamperedValid, "Chữ ký phải không hợp lệ khi dữ liệu bị sửa");
    }

    @Test
    void testParseMaHDDVFromTxnRef() {
        assertEquals(12, VNPayUtils.parseMaHDDVFromTxnRef("12"));
        assertEquals(12, VNPayUtils.parseMaHDDVFromTxnRef("HDDV_12"));
        assertEquals(12, VNPayUtils.parseMaHDDVFromTxnRef("HDDV_12_1728740000"));
        assertNull(VNPayUtils.parseMaHDDVFromTxnRef("invalid_ref"));
    }
}

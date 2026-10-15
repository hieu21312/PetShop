package PetShop.demo.utils;

import jakarta.servlet.http.HttpServletRequest;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * Lớp tiện ích phục vụ cổng thanh toán VNPay
 * Hỗ trợ băm HMAC SHA512, tạo chuỗi ký hashData, xác thực chữ ký callback và lấy IP client
 */
public class VNPayUtils {

    /**
     * Băm chuỗi dữ liệu bằng thuật toán HMAC SHA512 theo quy chuẩn VNPay
     *
     * @param key Khóa bí mật (vnp_HashSecret)
     * @param data Dữ liệu cần băm (hashData)
     * @return Chuỗi mã hóa Hex lowercase
     */
    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) {
                throw new NullPointerException("Key hoặc data không được để null");
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes(StandardCharsets.UTF_8);
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            throw new RuntimeException("Lỗi trong quá trình mã hóa HMAC SHA512: " + ex.getMessage(), ex);
        }
    }

    /**
     * Sắp xếp các tham số theo thứ tự bảng chữ cái ASCII và tạo chuỗi hashData & queryUrl
     *
     * @param params Map chứa danh sách tham số gửi sang VNPay
     * @param secretKey Khóa bí mật (vnp_HashSecret)
     * @return Chuỗi query params kèm theo vnp_SecureHash
     */
    public static String buildQueryUrl(Map<String, String> params, String secretKey) {
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        for (String fieldName : fieldNames) {
            String fieldValue = params.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                // Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));

                // Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));

                query.append('&');
                hashData.append('&');
            }
        }

        // Xóa dấu '&' thừa ở cuối
        if (query.length() > 0) {
            query.setLength(query.length() - 1);
        }
        if (hashData.length() > 0) {
            hashData.setLength(hashData.length() - 1);
        }

        String vnpSecureHash = hmacSHA512(secretKey, hashData.toString());
        query.append("&vnp_SecureHash=").append(vnpSecureHash);

        return query.toString();
    }

    /**
     * Kiểm tra chữ ký bảo mật từ callback/IPN của VNPay
     *
     * @param fields Danh sách các tham số VNPay trả về
     * @param secretKey Khóa bí mật (vnp_HashSecret)
     * @return true nếu chữ ký hợp lệ, false nếu bị làm giả
     */
    public static boolean verifySignature(Map<String, String> fields, String secretKey) {
        if (fields == null || !fields.containsKey("vnp_SecureHash") || secretKey == null) {
            return false;
        }

        String vnpSecureHash = fields.get("vnp_SecureHash");

        // Loại bỏ các trường hash để tính toán lại hashData
        Map<String, String> paramsToSign = new HashMap<>(fields);
        paramsToSign.remove("vnp_SecureHash");
        paramsToSign.remove("vnp_SecureHashType");

        List<String> fieldNames = new ArrayList<>(paramsToSign.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        for (String fieldName : fieldNames) {
            String fieldValue = paramsToSign.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                hashData.append('&');
            }
        }

        if (hashData.length() > 0) {
            hashData.setLength(hashData.length() - 1);
        }

        String calculatedHash = hmacSHA512(secretKey, hashData.toString());
        return calculatedHash.equalsIgnoreCase(vnpSecureHash);
    }

    /**
     * Lấy địa chỉ IP thực tế của client từ HttpServletRequest
     */
    public static String getIpAddress(HttpServletRequest request) {
        if (request == null) return "127.0.0.1";
        String ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("Proxy-Client-IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getRemoteAddr();
        }
        if (ipAddress != null && ipAddress.contains(",")) {
            ipAddress = ipAddress.split(",")[0].trim();
        }
        if (ipAddress != null && ("0:0:0:0:0:0:0:1".equals(ipAddress) || "::1".equals(ipAddress))) {
            ipAddress = "127.0.0.1";
        }
        return (ipAddress != null && !ipAddress.isEmpty()) ? ipAddress : "127.0.0.1";
    }

    /**
     * Trích xuất mã hóa đơn dịch vụ (MaHDDV) từ chuỗi vnp_TxnRef
     * Hỗ trợ định dạng số nguyên thuần "12" hoặc "HDDV_12" hoặc "HDDV_12_1728740000"
     */
    public static Integer parseMaHDDVFromTxnRef(String txnRef) {
        if (txnRef == null || txnRef.isBlank()) return null;
        txnRef = txnRef.trim();
        if (txnRef.startsWith("HDDV_")) {
            String[] parts = txnRef.split("_");
            if (parts.length >= 2) {
                try {
                    return Integer.parseInt(parts[1]);
                } catch (NumberFormatException ignored) {}
            }
        }
        try {
            return Integer.parseInt(txnRef);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}

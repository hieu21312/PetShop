package PetShop.demo.service;

import PetShop.demo.model.enity.HoaDonDichVu;
import PetShop.demo.utils.QRCodeUtils;
import PetShop.demo.utils.VNPayUtils;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class VNPayService {

    @Value("${vnpay.tmn-code:DEMOVNP1}")
    private String tmnCode;

    @Value("${vnpay.hash-secret:26QDYK2N8JUGD9051M395H3Z8J00D740}")
    private String hashSecret;

    @Value("${vnpay.pay-url:https://sandbox.vnpayment.vn/paymentv2/vpcpay.html}")
    private String payUrl;

    @Value("${vnpay.return-url:http://localhost:8080/api/vnpay/return}")
    private String returnUrl;

    @Value("${vnpay.version:2.1.0}")
    private String version;

    @Value("${vnpay.command:pay}")
    private String command;

    @Value("${vietqr.bank-id:MB}")
    private String bankId;

    @Value("${vietqr.account-no:0901234567}")
    private String accountNo;

    @Value("${vietqr.account-name:PET SHOP}")
    private String accountName;

    @Autowired
    private HoaDonDichVuService hoaDonDichVuService;

    /**
     * 1. Hàm tạo URL thanh toán VNPay (sử dụng mã hóa HMAC SHA512)
     *
     * @param maHDDV Mã hóa đơn dịch vụ
     * @param amount Số tiền cần thanh toán (VNĐ)
     * @param orderInfo Nội dung thanh toán
     * @param ipAddress Địa chỉ IP của client
     * @param customReturnUrl Return URL tùy chọn (nếu null sẽ lấy cấu hình mặc định)
     * @return Đường link thanh toán VNPay đầy đủ chữ ký bảo mật
     */
    public String createPaymentUrl(Integer maHDDV, BigDecimal amount, String orderInfo,
                                   String ipAddress, String customReturnUrl) {
        if (maHDDV == null || amount == null) {
            throw new IllegalArgumentException("Mã hóa đơn và số tiền không được để trống!");
        }

        long amountInCents = amount.multiply(BigDecimal.valueOf(100)).longValue();
        String vnpTxnRef = "HDDV_" + maHDDV + "_" + System.currentTimeMillis();

        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        formatter.setTimeZone(TimeZone.getTimeZone("GMT+7"));
        Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("GMT+7"));
        String vnpCreateDate = formatter.format(calendar.getTime());

        calendar.add(Calendar.MINUTE, 15);
        String vnpExpireDate = formatter.format(calendar.getTime());

        Map<String, String> vnpParams = new HashMap<>();
        vnpParams.put("vnp_Version", version);
        vnpParams.put("vnp_Command", command);
        vnpParams.put("vnp_TmnCode", tmnCode);
        vnpParams.put("vnp_Amount", String.valueOf(amountInCents));
        vnpParams.put("vnp_CurrCode", "VND");
        vnpParams.put("vnp_TxnRef", vnpTxnRef);
        vnpParams.put("vnp_OrderInfo", (orderInfo != null && !orderInfo.isBlank()) ? orderInfo : ("Thanh toan hoa don dich vu #" + maHDDV));
        vnpParams.put("vnp_OrderType", "other");
        vnpParams.put("vnp_Locale", "vn");
        vnpParams.put("vnp_ReturnUrl", (customReturnUrl != null && !customReturnUrl.isBlank()) ? customReturnUrl : returnUrl);
        vnpParams.put("vnp_IpAddr", (ipAddress != null && !ipAddress.isBlank()) ? ipAddress : "127.0.0.1");
        vnpParams.put("vnp_CreateDate", vnpCreateDate);
        vnpParams.put("vnp_ExpireDate", vnpExpireDate);

        String queryUrl = VNPayUtils.buildQueryUrl(vnpParams, hashSecret);
        return payUrl + "?" + queryUrl;
    }

    /**
     * 1. Hàm tạo URL thanh toán tiện lợi trực tiếp từ Entity HoaDonDichVu
     */
    public String createPaymentUrl(HoaDonDichVu hoaDon, HttpServletRequest request) {
        String ip = VNPayUtils.getIpAddress(request);
        String info = "Thanh toan hoa don dich vu #" + hoaDon.getMaHDDV();
        if (hoaDon.getGhiChu() != null && !hoaDon.getGhiChu().isBlank()) {
            info += " - " + hoaDon.getGhiChu();
        }
        return createPaymentUrl(hoaDon.getMaHDDV(), hoaDon.getTongTien(), info, ip, null);
    }

    /**
     * 2. Hàm tạo mã QR Code dạng chuỗi Base64 Data URL từ URL thanh toán VNPay
     */
    public String createPaymentQRCodeBase64(String paymentUrl, int width, int height) {
        return QRCodeUtils.generateQRCodeBase64(paymentUrl, width, height);
    }

    /**
     * 2. Hàm tạo mã QR Code dạng mảng byte PNG từ URL thanh toán VNPay
     */
    public byte[] createPaymentQRCodeBytes(String paymentUrl, int width, int height) {
        return QRCodeUtils.generateQRCodeBytes(paymentUrl, width, height);
    }

    /**
     * Tạo mã VietQR chuẩn App Ngân hàng Việt Nam (VCB, MB, Techcombank, BIDV,...)
     */
    public String createVietQrUrl(Integer maHDDV, BigDecimal amount) {
        String content = "HDDV" + maHDDV;
        return QRCodeUtils.buildVietQrUrl(bankId, accountNo, accountName, amount, content);
    }

    /**
     * 2. Tiện ích: Tạo mã QR Code Base64 trực tiếp cho hóa đơn dịch vụ
     */
    public String createQRCodeForHoaDon(Integer maHDDV, HttpServletRequest request) {
        HoaDonDichVu hd = hoaDonDichVuService.getHoaDonById(maHDDV)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn dịch vụ với mã: " + maHDDV));
        String paymentUrl = createPaymentUrl(hd, request);
        return createPaymentQRCodeBase64(paymentUrl, QRCodeUtils.DEFAULT_WIDTH, QRCodeUtils.DEFAULT_HEIGHT);
    }

    /**
     * 3. Xử lý IPN (Instant Payment Notification) từ cổng thanh toán VNPay
     */
    public Map<String, String> processIpn(Map<String, String> vnpParams) {
        Map<String, String> response = new HashMap<>();

        boolean isSignatureValid = VNPayUtils.verifySignature(vnpParams, hashSecret);
        if (!isSignatureValid) {
            response.put("RspCode", "97");
            response.put("Message", "Invalid Checksum");
            return response;
        }

        String txnRef = vnpParams.get("vnp_TxnRef");
        Integer maHDDV = VNPayUtils.parseMaHDDVFromTxnRef(txnRef);
        if (maHDDV == null) {
            response.put("RspCode", "01");
            response.put("Message", "Order not Found");
            return response;
        }

        Optional<HoaDonDichVu> hdOpt = hoaDonDichVuService.getHoaDonById(maHDDV);
        if (hdOpt.isEmpty()) {
            response.put("RspCode", "01");
            response.put("Message", "Order not Found");
            return response;
        }

        HoaDonDichVu hoaDon = hdOpt.get();

        try {
            long vnpAmount = Long.parseLong(vnpParams.get("vnp_Amount")) / 100;
            long expectedAmount = hoaDon.getTongTien() != null ? hoaDon.getTongTien().longValue() : 0L;
            if (vnpAmount != expectedAmount) {
                response.put("RspCode", "04");
                response.put("Message", "Invalid Amount");
                return response;
            }
        } catch (NumberFormatException e) {
            response.put("RspCode", "04");
            response.put("Message", "Invalid Amount Format");
            return response;
        }

        if (HoaDonDichVu.TRANG_THAI_DA_THANH_TOAN.equalsIgnoreCase(hoaDon.getTrangThai())) {
            response.put("RspCode", "02");
            response.put("Message", "Order already confirmed");
            return response;
        }

        String responseCode = vnpParams.get("vnp_ResponseCode");
        String transactionStatus = vnpParams.get("vnp_TransactionStatus");

        if ("00".equals(responseCode) && ("00".equals(transactionStatus) || transactionStatus == null)) {
            hoaDonDichVuService.xacNhanThanhToan(maHDDV, "VNPay");
            response.put("RspCode", "00");
            response.put("Message", "Confirm Success");
        } else {
            response.put("RspCode", "00");
            response.put("Message", "Transaction Failed Recorded");
        }

        return response;
    }

    public String getTmnCode() { return tmnCode; }
    public String getHashSecret() { return hashSecret; }
    public String getPayUrl() { return payUrl; }
    public String getReturnUrl() { return returnUrl; }
    public String getBankId() { return bankId; }
    public String getAccountNo() { return accountNo; }
    public String getAccountName() { return accountName; }
}

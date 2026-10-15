package PetShop.demo.api;

import PetShop.demo.model.enity.HoaDonDichVu;
import PetShop.demo.service.HoaDonDichVuService;
import PetShop.demo.service.VNPayService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping(produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
@CrossOrigin(origins = "*")
public class VNPayApiController {

    @Autowired
    private VNPayService vnPayService;

    @Autowired
    private HoaDonDichVuService hoaDonDichVuService;

    /**
     * 1. API tạo URL thanh toán VNPay và VietQR cho hóa đơn dịch vụ
     * POST /api/hoa-don/{id}/vnpay-url
     * Trả về cả URL thanh toán VNPay, mã QR VNPay và mã VietQR chuẩn ngân hàng
     */
    @PostMapping("/api/hoa-don/{id}/vnpay-url")
    public ResponseEntity<?> createPaymentUrl(
            @PathVariable("id") Integer id,
            HttpServletRequest request) {

        Optional<HoaDonDichVu> hdOpt = hoaDonDichVuService.getHoaDonById(id);
        if (hdOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of(
                    "success", false,
                    "message", "Không tìm thấy hóa đơn dịch vụ với mã: " + id
            ));
        }

        HoaDonDichVu hd = hdOpt.get();
        String paymentUrl = vnPayService.createPaymentUrl(hd, request);
        String qrBase64 = vnPayService.createPaymentQRCodeBase64(paymentUrl, 300, 300);
        String vietQrUrl = vnPayService.createVietQrUrl(hd.getMaHDDV(), hd.getTongTien());

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("maHDDV", hd.getMaHDDV());
        res.put("tongTien", hd.getTongTien());
        res.put("paymentUrl", paymentUrl);
        res.put("qrCodeBase64", qrBase64);
        res.put("vietQrUrl", vietQrUrl);
        res.put("bankId", vnPayService.getBankId());
        res.put("accountNo", vnPayService.getAccountNo());
        res.put("accountName", vnPayService.getAccountName());

        return ResponseEntity.ok(res);
    }

    /**
     * 2. API tạo mã QR Code cho hóa đơn dịch vụ
     * GET /api/hoa-don/{id}/vnpay-qr?format=json (trả về Base64) hoặc format=image (trả về file ảnh PNG)
     */
    @GetMapping("/api/hoa-don/{id}/vnpay-qr")
    public ResponseEntity<?> getPaymentQRCode(
            @PathVariable("id") Integer id,
            @RequestParam(name = "format", defaultValue = "json") String format,
            HttpServletRequest request) {

        Optional<HoaDonDichVu> hdOpt = hoaDonDichVuService.getHoaDonById(id);
        if (hdOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of(
                    "success", false,
                    "message", "Không tìm thấy hóa đơn dịch vụ với mã: " + id
            ));
        }

        HoaDonDichVu hd = hdOpt.get();
        String paymentUrl = vnPayService.createPaymentUrl(hd, request);

        if ("image".equalsIgnoreCase(format)) {
            byte[] imageBytes = vnPayService.createPaymentQRCodeBytes(paymentUrl, 300, 300);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_TYPE, MediaType.IMAGE_PNG_VALUE)
                    .body(imageBytes);
        }

        String qrCodeBase64 = vnPayService.createPaymentQRCodeBase64(paymentUrl, 300, 300);
        String vietQrUrl = vnPayService.createVietQrUrl(hd.getMaHDDV(), hd.getTongTien());

        return ResponseEntity.ok(Map.of(
                "success", true,
                "maHDDV", hd.getMaHDDV(),
                "paymentUrl", paymentUrl,
                "qrCodeBase64", qrCodeBase64,
                "vietQrUrl", vietQrUrl
        ));
    }

    /**
     * 3. API nhận callback (IPN) từ VNPay
     */
    @RequestMapping(value = "/api/vnpay/ipn", method = {RequestMethod.GET, RequestMethod.POST})
    public ResponseEntity<?> handleVNPayIpn(@RequestParam Map<String, String> allParams) {
        Map<String, String> result = vnPayService.processIpn(allParams);
        return ResponseEntity.ok(result);
    }

    /**
     * Callback Return URL: Nhận điều hướng từ trình duyệt sau khi khách hoàn tất thanh toán trên VNPay
     * GET /api/vnpay/return
     */
    @GetMapping("/api/vnpay/return")
    public ResponseEntity<?> handleVNPayReturn(@RequestParam Map<String, String> allParams) {
        Map<String, String> ipnResult = vnPayService.processIpn(allParams);
        boolean isSuccess = "00".equals(ipnResult.get("RspCode")) && "00".equals(allParams.get("vnp_ResponseCode"));

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", isSuccess);
        res.put("message", isSuccess ? "Thanh toán VNPay thành công!" : "Thanh toán không thành công hoặc xảy ra lỗi");
        res.put("vnp_ResponseCode", allParams.get("vnp_ResponseCode"));
        res.put("vnp_TxnRef", allParams.get("vnp_TxnRef"));
        res.put("vnp_Amount", allParams.get("vnp_Amount"));
        res.put("vnp_BankCode", allParams.get("vnp_BankCode"));
        res.put("vnp_PayDate", allParams.get("vnp_PayDate"));
        res.put("ipnResult", ipnResult);

        return ResponseEntity.ok(res);
    }
}

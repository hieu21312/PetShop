package PetShop.demo.utils;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.EnumMap;
import java.util.Map;

public class QRCodeUtils {
    public static final int DEFAULT_WIDTH = 300;
    public static final int DEFAULT_HEIGHT = 300;

    public static byte[] generateQRCodeBytes(String text, int width, int height) {
        try {
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            Map<EncodeHintType, Object> hints = new EnumMap<>(EncodeHintType.class);
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            hints.put(EncodeHintType.MARGIN, 1);

            BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height, hints);

            ByteArrayOutputStream pngOutputStream = new ByteArrayOutputStream();
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", pngOutputStream);
            return pngOutputStream.toByteArray();
        } catch (Exception ex) {
            throw new RuntimeException("Lỗi trong quá trình tạo QR Code dạng byte: " + ex.getMessage(), ex);
        }
    }

    public static String generateQRCodeBase64(String text, int width, int height) {
        byte[] imageBytes = generateQRCodeBytes(text, width, height);
        String base64Image = Base64.getEncoder().encodeToString(imageBytes);
        return "data:image/png;base64," + base64Image;
    }

    public static String generateQRCodeBase64(String text) {
        return generateQRCodeBase64(text, DEFAULT_WIDTH, DEFAULT_HEIGHT);
    }

    public static BufferedImage generateQRCodeBufferedImage(String text, int width, int height) {
        try {
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            Map<EncodeHintType, Object> hints = new EnumMap<>(EncodeHintType.class);
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            hints.put(EncodeHintType.MARGIN, 1);

            BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height, hints);
            return MatrixToImageWriter.toBufferedImage(bitMatrix);
        } catch (Exception ex) {
            throw new RuntimeException("Lỗi tạo QR Code dạng BufferedImage: " + ex.getMessage(), ex);
        }
    }

    public static String buildVietQrUrl(String bankId, String accountNo, String accountName, BigDecimal amount, String content) {
        String cleanBank = (bankId != null && !bankId.isBlank()) ? bankId.trim() : "MB";
        String cleanAcc = (accountNo != null && !accountNo.isBlank()) ? accountNo.trim() : "0901234567";
        String cleanName = (accountName != null && !accountName.isBlank()) ? accountName.trim() : "PET SHOP";
        long amt = amount != null ? amount.longValue() : 0L;
        String cleanContent = (content != null && !content.isBlank()) ? content.trim() : "HDDV";

        try {
            return String.format("https://img.vietqr.io/image/%s-%s-compact2.png?amount=%d&addInfo=%s&accountName=%s",
                    cleanBank,
                    cleanAcc,
                    amt,
                    URLEncoder.encode(cleanContent, StandardCharsets.UTF_8),
                    URLEncoder.encode(cleanName, StandardCharsets.UTF_8));
        } catch (Exception e) {
            return "";
        }
    }
}

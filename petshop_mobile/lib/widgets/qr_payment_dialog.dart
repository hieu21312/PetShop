import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class QRPaymentDialog extends StatelessWidget {
  final int? maHD;
  final double tongTien;
  final String bankId;
  final String bankName;
  final String accountNo;
  final String accountName;
  final VoidCallback? onComplete;

  const QRPaymentDialog({
    super.key,
    this.maHD,
    required this.tongTien,
    this.bankId = 'VCB',
    this.bankName = 'Vietcombank',
    this.accountNo = '123456789',
    this.accountName = 'PETSHOP COMPANY',
    this.onComplete,
  });

  static Future<void> show(
    BuildContext context, {
    int? maHD,
    required double tongTien,
    VoidCallback? onComplete,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => QRPaymentDialog(
        maHD: maHD,
        tongTien: tongTien,
        onComplete: onComplete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,###', 'vi_VN');
    final String transferContent = maHD != null ? 'THANHTOAN $maHD' : 'THANHTOAN';
    final int amountInt = tongTien.toInt();
    final String qrUrl =
        'https://img.vietqr.io/image/$bankId-$accountNo-compact2.png?amount=$amountInt&addInfo=${Uri.encodeComponent(transferContent)}';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.qr_code_2_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thanh toán chuyển khoản',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            maHD != null ? 'Đơn hàng #$maHD' : 'Quét mã VietQR',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        onComplete?.call();
                      },
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  children: [
                    // Số tiền cần chuyển
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF8BBD0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Số tiền cần chuyển:',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          Text(
                            '${currencyFormat.format(tongTien)} đ',
                            style: const TextStyle(
                              color: Color(0xFFE91E63),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Khung ảnh QR VietQR
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              qrUrl,
                              width: 210,
                              height: 210,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return SizedBox(
                                  width: 210,
                                  height: 210,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                      color: const Color(0xFFE91E63),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 210,
                                  height: 210,
                                  color: Colors.grey.shade100,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.wifi_off_rounded, size: 36, color: Colors.grey),
                                      SizedBox(height: 6),
                                      Text(
                                        'Không tải được mã QR\nVui lòng kiểm tra mạng',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 11, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Quét mã QR bằng ứng dụng ngân hàng bất kỳ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Bảng chi tiết thông tin chuyển khoản (có nút sao chép)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          _buildCopyRow(context, 'Ngân hàng', bankName, copyable: false),
                          const Divider(height: 1),
                          _buildCopyRow(context, 'Số tài khoản', accountNo, copyable: true),
                          const Divider(height: 1),
                          _buildCopyRow(context, 'Chủ tài khoản', accountName, copyable: true),
                          const Divider(height: 1),
                          _buildCopyRow(context, 'Nội dung CK', transferContent, copyable: true, highlight: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Cảnh báo xác nhận giống web order-confirmation
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFFE082)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFFF57F17), size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Sau khi chuyển khoản, vui lòng chờ admin xác nhận thanh toán. Đơn hàng sẽ được xử lý ngay khi xác nhận.',
                              style: TextStyle(fontSize: 11, color: Color(0xFF5D4037), height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Nút hoàn tất
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline, size: 20),
                        label: const Text(
                          'TÔI ĐÃ CHUYỂN KHOẢN XONG',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onComplete?.call();
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onComplete?.call();
                      },
                      child: const Text('Đóng (Thanh toán sau)', style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCopyRow(
    BuildContext context,
    String label,
    String value, {
    bool copyable = true,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: highlight ? const Color(0xFFE91E63) : Colors.black87,
                ),
              ),
              if (copyable) ...[
                const SizedBox(width: 6),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã sao chép "$value"'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.copy_rounded, size: 15, color: Color(0xFFE91E63)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

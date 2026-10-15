import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../services/cart_service.dart';
import '../services/api_service.dart';
import '../widgets/qr_payment_dialog.dart';

class CartScreen extends StatefulWidget {
  final UserModel currentUser;

  const CartScreen({super.key, required this.currentUser});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartService = CartService();
  final currencyFormat = NumberFormat('#,###', 'vi_VN');
  bool _isSubmitting = false;

  void _handleCheckout() {
    if (cartService.items.isEmpty) return;

    final addressController = TextEditingController(text: widget.currentUser.diaChi ?? '');
    final voucherController = TextEditingController();
    String paymentMethod = 'COD';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final subtotal = cartService.totalPrice;
          final discountPercent = widget.currentUser.discountPercent;
          final discount = subtotal * (discountPercent / 100.0);
          final finalTotal = (subtotal - discount).clamp(0.0, double.infinity);

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Xác nhận đặt hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const Divider(),
                  Text('Người nhận: ${widget.currentUser.tenKH} (${widget.currentUser.dienThoai ?? "Chưa có SĐT"})',
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ nhận hàng *',
                      hintText: 'Nhập số nhà, tên đường, phường/xã...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: voucherController,
                    decoration: InputDecoration(
                      labelText: 'Mã giảm giá (nếu có)',
                      hintText: 'VD: PETVIP10',
                      prefixIcon: const Icon(Icons.confirmation_number_outlined, color: Color(0xFFE91E63)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // PHƯƠNG THỨC THANH TOÁN
                  const Text('Phương thức thanh toán *',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                  const SizedBox(height: 8),

                  // Lựa chọn 1: COD
                  InkWell(
                    onTap: () => setModalState(() => paymentMethod = 'COD'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: paymentMethod == 'COD' ? const Color(0xFFFFF0F5) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: paymentMethod == 'COD' ? const Color(0xFFE91E63) : Colors.grey.shade300,
                          width: paymentMethod == 'COD' ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'COD',
                            groupValue: paymentMethod,
                            activeColor: const Color(0xFFE91E63),
                            onChanged: (val) => setModalState(() => paymentMethod = val!),
                          ),
                          const Icon(Icons.local_shipping_outlined, color: Color(0xFFE91E63), size: 22),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Thanh toán khi nhận hàng (COD)',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text('Thanh toán tiền mặt khi nhận hàng',
                                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Lựa chọn 2: BankTransfer (QR)
                  InkWell(
                    onTap: () => setModalState(() => paymentMethod = 'BankTransfer'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: paymentMethod == 'BankTransfer' ? const Color(0xFFFFF0F5) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: paymentMethod == 'BankTransfer' ? const Color(0xFFE91E63) : Colors.grey.shade300,
                          width: paymentMethod == 'BankTransfer' ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'BankTransfer',
                            groupValue: paymentMethod,
                            activeColor: const Color(0xFFE91E63),
                            onChanged: (val) => setModalState(() => paymentMethod = val!),
                          ),
                          const Icon(Icons.qr_code_2_rounded, color: Color(0xFFE91E63), size: 22),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Thanh toán QR (Chuyển khoản Online)',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text('Quét mã VietQR chuyển khoản nhanh chóng',
                                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Khung QR preview nếu chọn Thanh toán QR (như web)
                  if (paymentMethod == 'BankTransfer') ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF48FB1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code_scanner, color: Color(0xFFE91E63), size: 16),
                              SizedBox(width: 6),
                              Text('Quét mã để thanh toán:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFE91E63))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://img.vietqr.io/image/VCB-123456789-compact2.png?amount=${finalTotal.toInt()}&addInfo=${Uri.encodeComponent("THANHTOAN")}',
                              height: 160,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const SizedBox(
                                  height: 160,
                                  child: Center(child: CircularProgressIndicator(color: Color(0xFFE91E63))),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(
                                height: 160,
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: Text('Không tải được mã QR', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Ngân hàng: Vietcombank | STK: 123456789\nChủ TK: PETSHOP COMPANY',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tạm tính:'),
                            Text('${currencyFormat.format(subtotal)} đ', style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        if (discountPercent > 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Ưu đãi hội viên (${widget.currentUser.hangThanhVien} -$discountPercent%):',
                                  style: const TextStyle(color: Colors.green, fontSize: 12)),
                              Text('-${currencyFormat.format(discount)} đ',
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                        const Divider(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tổng thanh toán:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              '${currencyFormat.format(finalTotal)} đ',
                              style: const TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              final addr = addressController.text.trim();
                              if (addr.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Vui lòng nhập địa chỉ nhận hàng')),
                                );
                                return;
                              }
                              setModalState(() => _isSubmitting = true);

                              final itemsPayload = cartService.items
                                  .map((item) => {
                                        'maSP': item.product.maSP,
                                        'soLuong': item.quantity,
                                      })
                                  .toList();

                              final res = await ApiService.createOrder(
                                maKH: widget.currentUser.maKH,
                                diaChiGiaoHang: addr,
                                items: itemsPayload,
                                maGiamGia: voucherController.text.trim().isEmpty ? null : voucherController.text.trim(),
                                hinhThucThanhToan: paymentMethod,
                              );

                              setModalState(() => _isSubmitting = false);
                              if (!mounted) return;
                              Navigator.pop(ctx);

                              if (res['success'] == true) {
                                cartService.clearCart();
                                setState(() {});
                                final int? maHD = res['maHD'] != null ? int.tryParse(res['maHD'].toString()) : null;

                                if (paymentMethod == 'BankTransfer') {
                                  // Hiển thị mã QR thanh toán giống web order-confirmation
                                  QRPaymentDialog.show(
                                    context,
                                    maHD: maHD,
                                    tongTien: finalTotal,
                                    onComplete: () {
                                      if (mounted) {
                                        Navigator.pop(context, true);
                                      }
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('🎉 Đặt hàng thành công! Mã đơn: #${maHD ?? ""}')),
                                  );
                                  Navigator.pop(context, true);
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Lỗi: ${res['message']}')),
                                );
                              }
                            },
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              paymentMethod == 'BankTransfer' ? 'XÁC NHẬN & THANH TOÁN QR' : 'XÁC NHẬN THANH TOÁN (COD)',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = cartService.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng của bạn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Xóa giỏ hàng',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Xác nhận'),
                    content: const Text('Bạn có muốn xóa toàn bộ sản phẩm khỏi giỏ hàng?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Không')),
                      TextButton(
                        onPressed: () {
                          cartService.clearCart();
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: const Text('Xóa hết', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF0F5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_cart_outlined, size: 64, color: Color(0xFFE91E63)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Giỏ hàng đang trống', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Hãy chọn các bé cưng hoặc phụ kiện yêu thích nhé!', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('TIẾP TỤC MUA SẮM'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final item = items[i];
                final p = item.product;
                final imgUrl = ApiService.getImageUrl(p.anhDaiDien);

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Ảnh sản phẩm
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 75,
                            height: 75,
                            color: const Color(0xFFFFF0F5),
                            child: imgUrl.isNotEmpty
                                ? Image.network(
                                    imgUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.pets, color: Color(0xFFE91E63)),
                                  )
                                : const Icon(Icons.pets, color: Color(0xFFE91E63)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Thông tin sản phẩm
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.tenSP,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${currencyFormat.format(p.giaBan)} đ',
                                style: const TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  // Nút giảm số lượng
                                  InkWell(
                                    onTap: () {
                                      cartService.updateQuantity(p.maSP, -1);
                                      setState(() {});
                                    },
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.remove, size: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  // Nút tăng số lượng
                                  InkWell(
                                    onTap: () {
                                      cartService.updateQuantity(p.maSP, 1);
                                      setState(() {});
                                    },
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.add, size: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Nút xóa món
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey),
                          onPressed: () {
                            cartService.removeFromCart(p.maSP);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomSheet: items.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -3)),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tổng cộng:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(
                          '${currencyFormat.format(cartService.totalPrice)} đ',
                          style: const TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: _handleCheckout,
                          icon: const Icon(Icons.shopping_bag_outlined),
                          label: const Text('MUA HÀNG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

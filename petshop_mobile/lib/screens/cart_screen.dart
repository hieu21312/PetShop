import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../services/cart_service.dart';
import '../services/api_service.dart';
import '../widgets/qr_payment_dialog.dart';

class CartScreen extends StatefulWidget {
  final UserModel currentUser;
  final int initialTab; // 0: Giỏ hàng, 1: Lịch sử mua hàng

  const CartScreen({
    super.key,
    required this.currentUser,
    this.initialTab = 0,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final cartService = CartService();
  final currencyFormat = NumberFormat('#,###', 'vi_VN');

  bool _isSubmitting = false;

  // Lịch sử mua hàng
  List<OrderModel> _myOrders = [];
  bool _isLoadingOrders = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: (widget.initialTab >= 0 && widget.initialTab <= 1) ? widget.initialTab : 0,
    );
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _loadMyOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMyOrders() async {
    if (widget.currentUser.maKH <= 0) return;
    setState(() => _isLoadingOrders = true);
    final list = await ApiService.getMyOrders(widget.currentUser.maKH);
    if (mounted) {
      setState(() {
        _myOrders = list;
        _isLoadingOrders = false;
      });
    }
  }

  void _confirmClearCart() {
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
  }

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
                        color: paymentMethod == 'COD' ? const Color(0xFFFCE4EC) : Colors.white,
                        border: Border.all(
                          color: paymentMethod == 'COD' ? const Color(0xFFE91E63) : Colors.grey.shade300,
                          width: paymentMethod == 'COD' ? 1.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'COD',
                            groupValue: paymentMethod,
                            activeColor: const Color(0xFFE91E63),
                            onChanged: (val) => setModalState(() => paymentMethod = val!),
                          ),
                          const Icon(Icons.local_shipping_outlined, color: Colors.green),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Thanh toán khi nhận hàng (COD)',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text('Nhận hàng và thanh toán tiền mặt cho shipper',
                                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Lựa chọn 2: Chuyển khoản QR (VietQR)
                  InkWell(
                    onTap: () => setModalState(() => paymentMethod = 'BankTransfer'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: paymentMethod == 'BankTransfer' ? const Color(0xFFFCE4EC) : Colors.white,
                        border: Border.all(
                          color: paymentMethod == 'BankTransfer' ? const Color(0xFFE91E63) : Colors.grey.shade300,
                          width: paymentMethod == 'BankTransfer' ? 1.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'BankTransfer',
                            groupValue: paymentMethod,
                            activeColor: const Color(0xFFE91E63),
                            onChanged: (val) => setModalState(() => paymentMethod = val!),
                          ),
                          const Icon(Icons.qr_code_2, color: Color(0xFFE91E63)),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Chuyển khoản VietQR (Tự động)',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text('Quét mã QR qua app ngân hàng / MoMo / ZaloPay',
                                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tạm tính:'),
                            Text('${currencyFormat.format(subtotal)} đ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (discountPercent > 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ưu đãi ${widget.currentUser.hangThanhVien} (-${discountPercent.toStringAsFixed(0)}%):',
                                style: const TextStyle(color: Colors.green),
                              ),
                              Text(
                                '-${currencyFormat.format(discount)} đ',
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tổng thanh toán:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              '${currencyFormat.format(finalTotal)} đ',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFE91E63)),
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
                                  const SnackBar(content: Text('Vui lòng nhập địa chỉ nhận hàng!')),
                                );
                                return;
                              }

                              setModalState(() => _isSubmitting = true);

                              final itemsPayload = cartService.items.map((i) => {
                                'maSP': i.product.maSP,
                                'soLuong': i.quantity,
                              }).toList();

                              final res = await ApiService.createOrder(
                                maKH: widget.currentUser.maKH,
                                diaChiGiaoHang: addr,
                                items: itemsPayload,
                                maGiamGia: voucherController.text.trim().isEmpty ? null : voucherController.text.trim(),
                                hinhThucThanhToan: paymentMethod,
                              );

                              setModalState(() => _isSubmitting = false);
                              if (!mounted) return;
                              Navigator.pop(ctx); // Close checkout bottom sheet

                              if (res['success'] == true) {
                                cartService.clearCart();
                                setState(() {});
                                final int? maHD = res['maHD'] != null ? int.tryParse(res['maHD'].toString()) : null;

                                _loadMyOrders();
                                _tabController.animateTo(1); // Chuyển sang Tab Lịch sử mua hàng

                                if (paymentMethod == 'BankTransfer') {
                                  QRPaymentDialog.show(
                                    context,
                                    maHD: maHD,
                                    tongTien: finalTotal,
                                    onComplete: () {
                                      _loadMyOrders();
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('🎉 Đặt hàng thành công! Mã đơn: #${maHD ?? ""}')),
                                  );
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Giỏ hàng & Đơn mua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(
              icon: const Icon(Icons.shopping_cart_outlined, size: 20),
              text: 'Giỏ hàng (${cartService.items.length})',
            ),
            Tab(
              icon: const Icon(Icons.receipt_long, size: 20),
              text: 'Lịch sử mua hàng (${_myOrders.length})',
            ),
          ],
        ),
        actions: [
          if (_tabController.index == 0 && items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Xóa giỏ hàng',
              onPressed: _confirmClearCart,
            ),
          if (_tabController.index == 1)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Tải lại',
              onPressed: _loadMyOrders,
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 0: GIỎ HÀNG
          _buildCartTab(items),

          // TAB 1: LỊCH SỬ MUA HÀNG
          _buildOrderHistoryTab(),
        ],
      ),
      bottomSheet: (_tabController.index == 0 && items.isNotEmpty)
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -3)),
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
            )
          : null,
    );
  }

  // TAB 0: GIỎ HÀNG
  Widget _buildCartTab(List items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.store),
                label: const Text('TIẾP TỤC MUA SẮM', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              if (_myOrders.isNotEmpty) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE91E63),
                    side: const BorderSide(color: Color(0xFFE91E63)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _tabController.animateTo(1),
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('XEM LỊCH SỬ MUA HÀNG', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
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
                            errorBuilder: (_, _, _) => const Icon(Icons.pets, color: Color(0xFFE91E63)),
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
    );
  }

  // TAB 1: LỊCH SỬ MUA HÀNG
  Widget _buildOrderHistoryTab() {
    if (_isLoadingOrders) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)));
    }

    if (_myOrders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 16),
              const Text('Chưa có lịch sử mua hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Mọi đơn hàng bạn mua sẽ được lưu lại tại đây để theo dõi tình trạng đơn và thanh toán.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _tabController.animateTo(0),
                icon: const Icon(Icons.shopping_cart),
                label: const Text('XEM GIỎ HÀNG'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFE91E63),
      onRefresh: _loadMyOrders,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _myOrders.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) {
          final o = _myOrders[i];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1.5,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCE4EC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.receipt_long, color: Color(0xFFE91E63), size: 18),
                          ),
                          const SizedBox(width: 8),
                          Text('Đơn hàng #${o.maHD}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: o.tinhTrang == 4
                              ? Colors.green.shade50
                              : (o.tinhTrang == 5 ? Colors.red.shade50 : Colors.blue.shade50),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          o.tinhTrangText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: o.tinhTrang == 4
                                ? Colors.green.shade800
                                : (o.tinhTrang == 5 ? Colors.red.shade800 : Colors.blue.shade800),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng tiền:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text(
                        '${currencyFormat.format(o.tongTien)} đ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFE91E63)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Phương thức:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text(
                        o.hinhThucThanhToan == 'BankTransfer' ? 'Chuyển khoản QR' : 'Tiền mặt khi nhận (COD)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: o.hinhThucThanhToan == 'BankTransfer' ? const Color(0xFFE91E63) : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Trạng thái thanh toán:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: o.daThanhToan ? Colors.green.shade50 : Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          o.daThanhToan ? 'Đã thanh toán' : 'Chưa thanh toán',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: o.daThanhToan ? Colors.green.shade800 : Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (o.diaChiGiaoHang != null && o.diaChiGiaoHang!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Địa chỉ: ${o.diaChiGiaoHang}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (o.hinhThucThanhToan == 'BankTransfer' && !o.daThanhToan && o.tinhTrang == 1) ...[
                        OutlinedButton.icon(
                          icon: const Icon(Icons.qr_code_2, size: 16, color: Color(0xFFE91E63)),
                          label: const Text('Mã QR Thanh toán', style: TextStyle(fontSize: 12, color: Color(0xFFE91E63), fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE91E63)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            QRPaymentDialog.show(
                              context,
                              maHD: o.maHD,
                              tongTien: o.tongTien,
                              onComplete: () {
                                _loadMyOrders();
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (o.tinhTrang == 1)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Xác nhận'),
                                content: Text('Bạn có chắc muốn hủy đơn hàng #${o.maHD} không?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Không')),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Hủy đơn', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              final res = await ApiService.cancelOrder(o.maHD, widget.currentUser.maKH);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? '')));
                              _loadMyOrders();
                            }
                          },
                          icon: const Icon(Icons.cancel_outlined, size: 16),
                          label: const Text('Hủy đơn', style: TextStyle(fontSize: 12)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

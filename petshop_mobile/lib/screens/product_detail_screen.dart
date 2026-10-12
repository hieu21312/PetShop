import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import 'cart_screen.dart';
import '../widgets/app_toast.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final UserModel? currentUser;

  const ProductDetailScreen({super.key, required this.productId, this.currentUser});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? _detail;
  bool _isLoading = true;
  final currencyFormat = NumberFormat('#,###', 'vi_VN');

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  void _loadDetail() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getProductDetail(widget.productId);
    if (mounted) {
      setState(() {
        _detail = data;
        _isLoading = false;
      });
    }
  }

  void _handleBuyNow() {
    if (widget.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để mua hàng')),
      );
      return;
    }

    final addressController = TextEditingController(text: widget.currentUser!.diaChi ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
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
            const Text('Xác nhận đặt hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Sản phẩm: ${_detail!['tenSP']}', style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(
              'Đơn giá: ${currencyFormat.format(_detail!['giaBan'])} đ',
              style: const TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Địa chỉ nhận hàng *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final addr = addressController.text.trim();
                  if (addr.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng nhập địa chỉ nhận hàng')),
                    );
                    return;
                  }
                  Navigator.pop(ctx);
                  final res = await ApiService.createOrder(
                    maKH: widget.currentUser!.maKH,
                    diaChiGiaoHang: addr,
                    items: [
                      {'maSP': widget.productId, 'soLuong': 1}
                    ],
                  );
                  if (mounted) {
                    if (res['success'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('🎉 ${res['message']}')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi: ${res['message']}')),
                      );
                    }
                  }
                },
                child: const Text('XÁC NHẬN MUA NGAY', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFFE91E63))),
      );
    }

    if (_detail == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết')),
        body: const Center(child: Text('Không tìm thấy thông tin sản phẩm')),
      );
    }

    final reviews = _detail!['reviews'] as List? ?? [];
    final imgUrl = ApiService.getImageUrl(_detail!['anhDaiDien']);

    return Scaffold(
      appBar: AppBar(
        title: Text(_detail!['tenSP'] ?? 'Chi tiết'),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        actions: [
          if (widget.currentUser != null)
            ValueListenableBuilder<int>(
              valueListenable: CartService().cartCountNotifier,
              builder: (context, count, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      tooltip: 'Giỏ hàng',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CartScreen(currentUser: widget.currentUser!)),
                        );
                      },
                    ),
                    if (count > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            '$count',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFFE91E63), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                height: 240,
                width: double.infinity,
                color: const Color(0xFFFFF0F5),
                child: imgUrl.isNotEmpty
                    ? Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(color: Color(0xFFE91E63)),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.pets, size: 80, color: Color(0xFFE91E63)),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.pets, size: 80, color: Color(0xFFE91E63)),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _detail!['tenSP'] ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
            ),
            const SizedBox(height: 6),
            Text(
              '${currencyFormat.format(_detail!['giaBan'] ?? 0)} đ',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE91E63)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (_detail!['tenDanhMuc'] != null)
                  Chip(
                    avatar: const Icon(Icons.category, size: 16, color: Color(0xFFE91E63)),
                    label: Text('${_detail!['tenDanhMuc']}'),
                    backgroundColor: Colors.pink.shade50,
                  ),
                if (_detail!['soLuongTon'] != null)
                  Chip(
                    avatar: const Icon(Icons.inventory_2, size: 16, color: Colors.blue),
                    label: Text('Kho: ${_detail!['soLuongTon']}'),
                  ),
                if (_detail!['gioiTinh'] != null) Chip(label: Text('Giới tính: ${_detail!['gioiTinh']}')),
                if (_detail!['mauSac'] != null) Chip(label: Text('Màu: ${_detail!['mauSac']}')),
              ],
            ),
            if (_detail!['tinhTrangSucKhoe'] != null) ...[
              const SizedBox(height: 12),
              const Text('Tình trạng sức khỏe:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_detail!['tinhTrangSucKhoe']),
            ],
            if (_detail!['tienSuBenh'] != null && _detail!['tienSuBenh'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Tiền sử bệnh:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_detail!['tienSuBenh']),
            ],
            const SizedBox(height: 12),
            const Text('Mô tả sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_detail!['moTa'] ?? 'Đang cập nhật'),
            const SizedBox(height: 24),
            const Divider(),
            Text('Đánh giá (${reviews.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (reviews.isEmpty)
              const Text('Chưa có đánh giá nào', style: TextStyle(color: Colors.grey))
            else
              ...reviews.map((r) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(r['hoTen'] ?? 'Khách'),
                    subtitle: Text(r['noiDung'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        r['soSao'] ?? 5,
                        (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
                      ),
                    ),
                  )),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: [
            // Nút Thêm vào giỏ
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE91E63),
                    side: const BorderSide(color: Color(0xFFE91E63), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    final product = ProductModel.fromJson(_detail!);
                    CartService().addToCart(product, 1);
                    AppToast.show(
                      context,
                      message: '🛒 Đã thêm "${product.tenSP}" vào giỏ hàng!',
                      actionLabel: widget.currentUser != null ? 'Xem giỏ' : null,
                      duration: const Duration(seconds: 3),
                      onAction: () {
                        if (widget.currentUser != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CartScreen(currentUser: widget.currentUser!)),
                          );
                        }
                      },
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('THÊM VÀO GIỎ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Nút Mua ngay
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _handleBuyNow,
                  icon: const Icon(Icons.bolt),
                  label: const Text('MUA NGAY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

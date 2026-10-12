import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/booking_model.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import 'product_detail_screen.dart';
import 'login_screen.dart';
import 'cart_screen.dart';
import 'notification_screen.dart';
import '../widgets/app_toast.dart';
import '../widgets/qr_payment_dialog.dart';

class HomeScreen extends StatefulWidget {
  final UserModel currentUser;

  const HomeScreen({super.key, required this.currentUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final currencyFormat = NumberFormat('#,###', 'vi_VN');

  // Tab 0: Sản phẩm & Danh mục
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  bool _isLoadingProducts = true;
  int? _selectedCategoryId; // null = Tất cả
  String? _selectedCategoryGroup; // null = Tất cả, 'cho' = Chó, 'meo' = Mèo, 'phukien' = Phụ kiện
  final _searchController = TextEditingController();
  bool _isSearching = false;
  int _unreadNotificationCount = 0;

  // Tab 1: Dịch vụ & Đặt lịch
  List<ServiceModel> _services = [];
  ServiceModel? _selectedService;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  final _petNameController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isBookingSubmitting = false;

  // Tab 2: Lịch hẹn & Đơn hàng
  List<BookingModel> _myBookings = [];
  List<OrderModel> _myOrders = [];
  bool _isLoadingHistory = false;
  late UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.currentUser;
    _loadUserProfile();
    _loadCategories();
    _loadProducts();
    _loadServices();
    _loadHistory();
    _loadNotificationsCount();
  }

  void _loadUserProfile() async {
    final updated = await ApiService.getProfile(_currentUser.maKH);
    if (updated != null && mounted) {
      setState(() {
        _currentUser = updated;
      });
    }
  }

  void _loadNotificationsCount() async {
    final count = await ApiService.getUnreadNotificationCount(_currentUser.maKH);
    if (mounted) {
      setState(() => _unreadNotificationCount = count);
    }
  }

  void _loadCategories() async {
    final list = await ApiService.getCategories();
    if (mounted) {
      setState(() {
        _categories = list;
      });
    }
  }

  void _loadProducts() async {
    setState(() => _isLoadingProducts = true);
    final list = await ApiService.getProducts(
      search: _searchController.text.trim(),
      loai: _selectedCategoryGroup,
      categoryId: _selectedCategoryId,
    );
    if (mounted) {
      setState(() {
        _products = list;
        _isLoadingProducts = false;
      });
    }
  }

  void _loadServices() async {
    final list = await ApiService.getServices();
    if (mounted) {
      setState(() {
        _services = list;
        if (list.isNotEmpty) _selectedService = list.first;
      });
    }
  }

  void _loadHistory() async {
    setState(() => _isLoadingHistory = true);
    final bookings = await ApiService.getMyBookings(_currentUser.maKH);
    final orders = await ApiService.getMyOrders(_currentUser.maKH);
    if (mounted) {
      setState(() {
        _myBookings = bookings;
        _myOrders = orders;
        _isLoadingHistory = false;
      });
    }
  }

  void _submitBooking() async {
    if (_selectedService == null) return;
    setState(() => _isBookingSubmitting = true);

    final ngayStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final gioStr = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}:00';

    final res = await ApiService.createBooking(
      maKH: _currentUser.maKH,
      tenKhachHang: _currentUser.tenKH,
      soDienThoai: _currentUser.dienThoai ?? '',
      email: _currentUser.email,
      ngayDat: ngayStr,
      gioDat: gioStr,
      maDV: _selectedService!.maDV,
      ghiChu: 'Bé: ${_petNameController.text.trim()}. ${_noteController.text.trim()}',
    );

    setState(() => _isBookingSubmitting = false);

    if (mounted) {
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🎉 Đặt lịch hẹn thành công!')),
        );
        _loadHistory();
        setState(() => _currentIndex = 2); // Chuyển sang tab Lịch sử
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${res['message']}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildCategoryDrawer(),
      appBar: AppBar(
        leading: (_currentIndex == 0)
            ? (_isSearching
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Đóng tìm kiếm',
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchController.clear();
                        _loadProducts();
                      });
                    },
                  )
                : Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu),
                      tooltip: 'Danh mục sản phẩm',
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ))
            : null,
        title: (_currentIndex == 0 && _isSearching)
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                cursorColor: Colors.white,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm thú cưng, thức ăn...',
                  hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _loadProducts();
                            setState(() {});
                          },
                        )
                      : null,
                ),
                onChanged: (val) => setState(() {}),
                onSubmitted: (_) => _loadProducts(),
              )
            : Row(
                children: [
                  const Icon(Icons.pets, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    _currentIndex == 0
                        ? 'PetShop'
                        : _currentIndex == 1
                            ? 'Đặt Lịch Dịch Vụ'
                            : _currentIndex == 2
                                ? 'Đơn Hàng & Lịch Hẹn'
                                : 'Tài Khoản Cá Nhân',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        actions: [
          if (_currentIndex == 0) ...[
            // 1. Kính lúp tìm kiếm
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              tooltip: _isSearching ? 'Đóng tìm kiếm' : 'Tìm kiếm',
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _loadProducts();
                  }
                });
              },
            ),
            // 2. Icon Chuông thông báo
            Badge.count(
              count: _unreadNotificationCount,
              isLabelVisible: _unreadNotificationCount > 0,
              backgroundColor: Colors.amber,
              textColor: Colors.black87,
              offset: const Offset(-4, 4),
              child: IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white, size: 24),
                tooltip: 'Thông báo',
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationScreen(currentUser: _currentUser)),
                  );
                  _loadNotificationsCount();
                },
              ),
            ),
            // 3. Icon Giỏ hàng
            ValueListenableBuilder<int>(
              valueListenable: CartService().cartCountNotifier,
              builder: (context, count, _) {
                return Badge.count(
                  count: count,
                  isLabelVisible: count > 0,
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFFE91E63),
                  offset: const Offset(-4, 4),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                    tooltip: 'Giỏ hàng',
                    onPressed: () async {
                      final ordered = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (_) => CartScreen(currentUser: _currentUser)),
                      );
                      if (ordered == true) {
                        _loadHistory();
                        _loadNotificationsCount();
                        _loadUserProfile();
                        setState(() => _currentIndex = 2);
                      }
                    },
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
          ],
        ],
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
            _isSearching = false;
          });
          if (i == 2) _loadHistory();
          if (i == 3) _loadUserProfile();
        },
        selectedItemColor: const Color(0xFFE91E63),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Sản phẩm'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Đặt lịch'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Lịch sử'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _buildProductsTab();
      case 1:
        return _buildBookingTab();
      case 2:
        return _buildHistoryTab();
      case 3:
        return _buildProfileTab();
      default:
        return const SizedBox();
    }
  }

  // TAB 0: SẢN PHẨM & TÌM KIẾM
  Widget _buildProductsTab() {
    return Column(
      children: [
        // Thanh hiển thị danh mục đang lọc (nếu đã chọn trong menu Drawer)
        if (_selectedCategoryGroup != null || _selectedCategoryId != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFFCE4EC),
            child: Row(
              children: [
                Icon(
                  _selectedCategoryGroup == 'cho' || _selectedCategoryGroup == 'meo'
                      ? Icons.pets
                      : _selectedCategoryGroup == 'thucan'
                          ? Icons.restaurant
                          : _selectedCategoryGroup == 'phukien'
                              ? Icons.shopping_bag
                              : Icons.category,
                  size: 16,
                  color: const Color(0xFFE91E63),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Danh mục: ${_selectedCategoryGroup == 'cho' ? '🐶 Chó' : _selectedCategoryGroup == 'meo' ? '🐱 Mèo' : _selectedCategoryGroup == 'thucan' ? '🍖 Thức ăn' : _selectedCategoryGroup == 'phukien' ? '🎀 Phụ kiện' : (_categories.firstWhere((c) => c.maDanhMuc == _selectedCategoryId, orElse: () => CategoryModel(maDanhMuc: 0, tenDanhMuc: '')).tenDanhMuc)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE91E63),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategoryGroup = null;
                      _selectedCategoryId = null;
                    });
                    _loadProducts();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close, size: 14, color: Color(0xFFE91E63)),
                        SizedBox(width: 4),
                        Text(
                          'Bỏ lọc',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFE91E63),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        // Thanh thông báo từ khóa đang tìm kiếm
        if (_searchController.text.trim().isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFFFF0F5),
            child: Row(
              children: [
                const Icon(Icons.search, size: 16, color: Color(0xFFE91E63)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kết quả: "${_searchController.text.trim()}"',
                    style: const TextStyle(fontSize: 12, color: Color(0xFFE91E63), fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchController.clear();
                      _loadProducts();
                    });
                  },
                  child: const Icon(Icons.close, size: 16, color: Color(0xFFE91E63)),
                ),
              ],
            ),
          ),
        // Grid View
        Expanded(
          child: _isLoadingProducts
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
              : _products.isEmpty
                  ? const Center(child: Text('Không tìm thấy sản phẩm phù hợp'))
                  : RefreshIndicator(
                      onRefresh: () async => _loadProducts(),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final availableWidth = constraints.maxWidth;
                          int crossAxisCount = 2;
                          if (availableWidth >= 1100) {
                            crossAxisCount = 5;
                          } else if (availableWidth >= 800) {
                            crossAxisCount = 4;
                          } else if (availableWidth >= 550) {
                            crossAxisCount = 3;
                          } else {
                            crossAxisCount = 2;
                          }

                          const double padding = 10.0;
                          const double spacing = 10.0;
                          final itemWidth = (availableWidth - (padding * 2) - ((crossAxisCount - 1) * spacing)) / crossAxisCount;

                          // Chiều cao ảnh cân đối theo chiều rộng thẻ
                          final imageHeight = (itemWidth * 0.72).clamp(100.0, 145.0);
                          // Chiều cao phần thông tin chữ (tên 32 + khoảng cách 4 + giá/nút 30 + padding 12) = 78
                          const double infoHeight = 78.0;
                          final itemHeight = imageHeight + infoHeight;
                          final childAspectRatio = itemWidth / itemHeight;

                          return GridView.builder(
                            padding: const EdgeInsets.all(padding),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: childAspectRatio,
                              crossAxisSpacing: spacing,
                              mainAxisSpacing: spacing,
                            ),
                            itemCount: _products.length,
                            itemBuilder: (ctx, i) {
                              final p = _products[i];
                              final imgUrl = ApiService.getImageUrl(p.anhDaiDien);

                              return Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                elevation: 1.5,
                                color: Colors.white,
                                clipBehavior: Clip.antiAlias,
                                margin: EdgeInsets.zero,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailScreen(
                                          productId: p.maSP,
                                          currentUser: _currentUser,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Ảnh sản phẩm
                                      SizedBox(
                                        height: imageHeight,
                                        width: double.infinity,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Container(
                                              color: const Color(0xFFF9FAFB),
                                              child: imgUrl.isNotEmpty
                                                  ? Image.network(
                                                      imgUrl,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context, child, loadingProgress) {
                                                        if (loadingProgress == null) return child;
                                                        return const Center(
                                                          child: SizedBox(
                                                            width: 22,
                                                            height: 22,
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              color: Color(0xFFE91E63),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      errorBuilder: (context, error, stackTrace) => const Center(
                                                        child: Icon(Icons.pets, size: 36, color: Color(0xFFE91E63)),
                                                      ),
                                                    )
                                                  : const Center(
                                                      child: Icon(Icons.pets, size: 36, color: Color(0xFFE91E63)),
                                                    ),
                                            ),
                                            if (p.tenDanhMuc.isNotEmpty)
                                              Positioned(
                                                top: 6,
                                                left: 6,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withValues(alpha: 0.95),
                                                    borderRadius: BorderRadius.circular(8),
                                                    boxShadow: const [
                                                      BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    p.tenDanhMuc,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontSize: 9.5,
                                                      color: Color(0xFFE91E63),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      // Thông tin sản phẩm
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Tên sản phẩm cố định chiều cao 32px (2 dòng)
                                            SizedBox(
                                              height: 32,
                                              child: Text(
                                                p.tenSP,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.5,
                                                  height: 1.25,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            // Hàng giá tiền & nút Thêm vào giỏ hàng
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${currencyFormat.format(p.giaBan)} đ',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Color(0xFFE91E63),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 13.5,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    CartService().addToCart(p, 1);
                                                    AppToast.show(
                                                      context,
                                                      message: '🛒 Đã thêm "${p.tenSP}" vào giỏ!',
                                                      actionLabel: 'Xem giỏ',
                                                      duration: const Duration(seconds: 3),
                                                      onAction: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) => CartScreen(currentUser: _currentUser),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  borderRadius: BorderRadius.circular(16),
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFE91E63),
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color(0xFFE91E63).withValues(alpha: 0.35),
                                                          blurRadius: 4,
                                                          offset: const Offset(0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: const Center(
                                                      child: Icon(Icons.shopping_cart, size: 16, color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  // TAB 1: ĐẶT LỊCH HẸN DỊCH VỤ
  Widget _buildBookingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.spa, color: Color(0xFFE91E63)),
                  SizedBox(width: 8),
                  Text('Đặt Lịch Chăm Sóc & Spa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Chọn gói dịch vụ *', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (_services.isEmpty)
                const CircularProgressIndicator()
              else
                DropdownButtonFormField<ServiceModel>(
                  isExpanded: true,
                  itemHeight: null,
                  initialValue: _selectedService,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE91E63), width: 1.5),
                    ),
                  ),
                  selectedItemBuilder: (BuildContext context) {
                    return _services.map((s) {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              s.tenDV,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${currencyFormat.format(s.giaDichVu)} đ',
                            style: const TextStyle(
                              color: Color(0xFFE91E63),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                  items: _services.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                s.tenDV,
                                softWrap: true,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.3),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${currencyFormat.format(s.giaDichVu)} đ',
                              style: const TextStyle(
                                color: Color(0xFFE91E63),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedService = val),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _petNameController,
                decoration: InputDecoration(
                  labelText: 'Tên thú cưng & Giống loài *',
                  hintText: 'VD: Cún Lu Lu - Poodle',
                  prefixIcon: const Icon(Icons.pets),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 60)),
                        );
                        if (picked != null) setState(() => _selectedDate = picked);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time, size: 18),
                      label: Text('${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}'),
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (picked != null) setState(() => _selectedTime = picked);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Ghi chú đặc biệt cho bác sĩ/nhân viên',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isBookingSubmitting ? null : _submitBooking,
                  child: _isBookingSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('GỬI YÊU CẦU ĐẶT LỊCH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TAB 2: LỊCH SỬ ĐƠN HÀNG & LỊCH HẸN
  Widget _buildHistoryTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Color(0xFFE91E63),
            indicatorColor: Color(0xFFE91E63),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.shopping_bag), text: 'Đơn hàng'),
              Tab(icon: Icon(Icons.event_available), text: 'Lịch hẹn'),
            ],
          ),
          Expanded(
            child: _isLoadingHistory
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
                : TabBarView(
                    children: [
                      // List đơn hàng
                      _myOrders.isEmpty
                          ? const Center(child: Text('Bạn chưa có đơn hàng nào'))
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: _myOrders.length,
                              itemBuilder: (ctx, i) {
                                final o = _myOrders[i];
                                return Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    title: Text('Đơn hàng #${o.maHD}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Tổng tiền: ${currencyFormat.format(o.tongTien)} đ'),
                                        Text('Trạng thái: ${o.tinhTrangText}'),
                                        Text(
                                          'Thanh toán: ${o.hinhThucThanhToan == "BankTransfer" ? "Chuyển khoản QR" : "Khi nhận hàng (COD)"}${o.daThanhToan ? " (Đã thanh toán)" : ""}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: o.hinhThucThanhToan == "BankTransfer"
                                                ? const Color(0xFFE91E63)
                                                : Colors.grey.shade600,
                                            fontWeight: o.hinhThucThanhToan == "BankTransfer" ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Wrap(
                                      spacing: 4,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        if (o.hinhThucThanhToan == 'BankTransfer' && !o.daThanhToan && o.tinhTrang == 1)
                                          OutlinedButton.icon(
                                            icon: const Icon(Icons.qr_code_2, size: 15, color: Color(0xFFE91E63)),
                                            label: const Text('Mã QR', style: TextStyle(fontSize: 11, color: Color(0xFFE91E63))),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(color: Color(0xFFE91E63)),
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              minimumSize: Size.zero,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            onPressed: () {
                                              QRPaymentDialog.show(
                                                context,
                                                maHD: o.maHD,
                                                tongTien: o.tongTien,
                                              );
                                            },
                                          ),
                                        if (o.tinhTrang == 1)
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              minimumSize: Size.zero,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            onPressed: () async {
                                              final confirm = await showDialog<bool>(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text('Xác nhận'),
                                                  content: const Text('Bạn có chắc muốn hủy đơn này?'),
                                                  actions: [
                                                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Không')),
                                                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hủy đơn')),
                                                  ],
                                                ),
                                              );
                                              if (confirm == true) {
                                                final res = await ApiService.cancelOrder(o.maHD, _currentUser.maKH);
                                                if (!mounted) return;
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? '')));
                                                _loadHistory();
                                              }
                                            },
                                            child: const Text('Hủy', style: TextStyle(color: Colors.red, fontSize: 12)),
                                          )
                                        else
                                          Chip(
                                            label: Text(o.tinhTrangText, style: const TextStyle(fontSize: 10)),
                                            backgroundColor: o.tinhTrang == 4 ? Colors.green.shade50 : Colors.grey.shade100,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      // List lịch hẹn
                      _myBookings.isEmpty
                          ? const Center(child: Text('Bạn chưa có lịch hẹn nào'))
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: _myBookings.length,
                              itemBuilder: (ctx, i) {
                                final b = _myBookings[i];
                                return Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      backgroundColor: Color(0xFFFFF0F5),
                                      child: Icon(Icons.spa, color: Color(0xFFE91E63)),
                                    ),
                                    title: Text(b.tenDichVu ?? 'Dịch vụ chăm sóc', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text('Thời gian: ${b.ngayDat} ${b.gioDat}\nTrạng thái: ${b.trangThai}'),
                                    isThreeLine: true,
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // TAB 3: TÀI KHOẢN & HỘI VIÊN
  Widget _buildProfileTab() {
    final isVip = _currentUser.hangThanhVien.toUpperCase() == 'VIP';
    final isVvip = _currentUser.hangThanhVien.toUpperCase() == 'VVIP';
    final isLoyal = _currentUser.hangThanhVien.toUpperCase().contains('THÂN') ||
        _currentUser.hangThanhVien.toUpperCase().contains('THAN');

    final cardGradient = isVvip
        ? const LinearGradient(
            colors: [Color(0xFF232526), Color(0xFFD4AF37)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : isVip
            ? const LinearGradient(
                colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFFC2185B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : isLoyal
                ? const LinearGradient(
                    colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  );

    final badgeText = isVvip
        ? '👑 VVIP'
        : isVip
            ? '👑 VIP'
            : isLoyal
                ? '⭐ Thân thiết'
                : 'Tiêu chuẩn';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Membership Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: cardGradient,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: isVip
                      ? Colors.amber.withValues(alpha: 0.3)
                      : Colors.purple.withValues(alpha: 0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('PETSHOP MEMBERSHIP',
                        style: TextStyle(color: Colors.white70, letterSpacing: 1.2, fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: (isVip || isVvip)
                            ? Colors.amber.shade300
                            : Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: (isVip || isVvip)
                            ? [
                                BoxShadow(
                                  color: Colors.amber.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          color: (isVip || isVvip) ? const Color(0xFF4A148C) : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(_currentUser.tenKH,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(_currentUser.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('⭐ Điểm tích: ${_currentUser.diemTichLuy} điểm',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(
                      'Ưu đãi: -${_currentUser.discountPercent.toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars, color: Colors.amberAccent, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          (isVip || isVvip)
                              ? 'Đặc quyền VIP: Giảm ${_currentUser.discountPercent.toStringAsFixed(0)}% mọi đơn hàng & dịch vụ'
                              : isLoyal
                                  ? 'Đặc quyền Thân thiết: Giảm ${_currentUser.discountPercent.toStringAsFixed(0)}% mọi đơn hàng'
                                  : 'Tích 1 điểm cho mỗi 100.000đ mua hàng & dịch vụ',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.phone, color: Color(0xFFE91E63)),
                  title: const Text('Số điện thoại'),
                  subtitle: Text(_currentUser.dienThoai ?? 'Chưa cập nhật'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.home, color: Color(0xFFE91E63)),
                  title: const Text('Địa chỉ nhận hàng'),
                  subtitle: Text(_currentUser.diaChi ?? 'Chưa cập nhật'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout),
              label: const Text('ĐĂNG XUẤT', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // DRAWER: DANH MỤC SẢN PHẨM (ẨN / HIỆN QUA MENU 3 GẠCH)
  Widget _buildCategoryDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Header Menu Drawer
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pets, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DANH MỤC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        'PetShop Services & Products',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Danh sách danh mục (Chó, Mèo, Phụ kiện, Dịch vụ giống bản web)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // 1. Tất cả sản phẩm
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  title: Text(
                    'Tất cả sản phẩm',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: (_selectedCategoryGroup == null && _selectedCategoryId == null)
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: (_selectedCategoryGroup == null && _selectedCategoryId == null)
                          ? const Color(0xFFE91E63)
                          : Colors.black87,
                    ),
                  ),
                  trailing: (_selectedCategoryGroup == null && _selectedCategoryId == null)
                      ? const Icon(Icons.check_circle, color: Color(0xFFE91E63), size: 18)
                      : null,
                  selected: _selectedCategoryGroup == null && _selectedCategoryId == null,
                  selectedTileColor: const Color(0xFFFCE4EC),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _currentIndex = 0;
                      _selectedCategoryGroup = null;
                      _selectedCategoryId = null;
                    });
                    _loadProducts();
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // 2. Chó
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  title: Text(
                    '🐶 Chó',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: _selectedCategoryGroup == 'cho' ? FontWeight.bold : FontWeight.w500,
                      color: _selectedCategoryGroup == 'cho' ? const Color(0xFFE91E63) : Colors.black87,
                    ),
                  ),
                  trailing: _selectedCategoryGroup == 'cho'
                      ? const Icon(Icons.check_circle, color: Color(0xFFE91E63), size: 18)
                      : const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                  selected: _selectedCategoryGroup == 'cho',
                  selectedTileColor: const Color(0xFFFCE4EC),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _currentIndex = 0;
                      _selectedCategoryGroup = 'cho';
                      _selectedCategoryId = null;
                    });
                    _loadProducts();
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // 3. Mèo
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  title: Text(
                    '🐱 Mèo',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: _selectedCategoryGroup == 'meo' ? FontWeight.bold : FontWeight.w500,
                      color: _selectedCategoryGroup == 'meo' ? Colors.deepOrange : Colors.black87,
                    ),
                  ),
                  trailing: _selectedCategoryGroup == 'meo'
                      ? const Icon(Icons.check_circle, color: Colors.deepOrange, size: 18)
                      : const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                  selected: _selectedCategoryGroup == 'meo',
                  selectedTileColor: Colors.orange.shade50,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _currentIndex = 0;
                      _selectedCategoryGroup = 'meo';
                      _selectedCategoryId = null;
                    });
                    _loadProducts();
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // 4. Thức ăn
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  title: Text(
                    '🍖 Thức ăn',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: _selectedCategoryGroup == 'thucan' ? FontWeight.bold : FontWeight.w500,
                      color: _selectedCategoryGroup == 'thucan' ? Colors.brown : Colors.black87,
                    ),
                  ),
                  trailing: _selectedCategoryGroup == 'thucan'
                      ? const Icon(Icons.check_circle, color: Colors.brown, size: 18)
                      : const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                  selected: _selectedCategoryGroup == 'thucan',
                  selectedTileColor: Colors.brown.shade50,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _currentIndex = 0;
                      _selectedCategoryGroup = 'thucan';
                      _selectedCategoryId = null;
                    });
                    _loadProducts();
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // 5. Phụ kiện
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  title: Text(
                    '🎀 Phụ kiện',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: _selectedCategoryGroup == 'phukien' ? FontWeight.bold : FontWeight.w500,
                      color: _selectedCategoryGroup == 'phukien' ? Colors.purple : Colors.black87,
                    ),
                  ),
                  trailing: _selectedCategoryGroup == 'phukien'
                      ? const Icon(Icons.check_circle, color: Colors.purple, size: 18)
                      : const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                  selected: _selectedCategoryGroup == 'phukien',
                  selectedTileColor: Colors.purple.shade50,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _currentIndex = 0;
                      _selectedCategoryGroup = 'phukien';
                      _selectedCategoryId = null;
                    });
                    _loadProducts();
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // 5. Dịch vụ (chuyển sang tab Đặt Lịch Dịch Vụ)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  title: Text(
                    '🩺 Dịch vụ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: (_currentIndex == 1) ? FontWeight.bold : FontWeight.w500,
                      color: (_currentIndex == 1) ? Colors.teal : Colors.black87,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.teal),
                  selected: _currentIndex == 1,
                  selectedTileColor: Colors.teal.shade50,
                  onTap: () {
                    Navigator.pop(context); // Đóng menu drawer
                    setState(() {
                      _currentIndex = 1; // Chuyển sang Tab 1: Đặt lịch dịch vụ
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

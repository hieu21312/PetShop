import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  final UserModel currentUser;

  const AdminHomeScreen({super.key, required this.currentUser});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> _careTickets = [];
  List<Map<String, dynamic>> _bookings = [];
  List<Map<String, dynamic>> _staffList = [];

  String _selectedRevenuePeriod = 'day'; // 'day', 'week', 'month', 'year'
  DateTime _selectedDate = DateTime.now();
  Map<String, dynamic>? _revenueReport;
  bool _isLoadingReport = false;

  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    _loadAllAdminData();
    _loadRevenueReport();
  }

  Future<void> _loadRevenueReport() async {
    setState(() => _isLoadingReport = true);
    String? dateStr;
    String? monthStr;
    int? yearVal;

    if (_selectedRevenuePeriod == 'day' || _selectedRevenuePeriod == 'week') {
      dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    } else if (_selectedRevenuePeriod == 'month') {
      monthStr = DateFormat('yyyy-MM').format(_selectedDate);
    } else if (_selectedRevenuePeriod == 'year') {
      yearVal = _selectedDate.year;
    }

    final rep = await ApiService.getAdminRevenueReport(
      type: _selectedRevenuePeriod,
      date: dateStr,
      month: monthStr,
      year: yearVal,
    );

    if (mounted) {
      setState(() {
        _revenueReport = rep;
        _isLoadingReport = false;
      });
    }
  }

  Future<void> _loadAllAdminData() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      ApiService.getAdminDashboard(),
      ApiService.getAdminOrders(),
      ApiService.getAdminCareTickets(),
      ApiService.getAdminBookings(),
      ApiService.getAdminStaffList(),
    ]);

    if (mounted) {
      setState(() {
        _dashboardData = results[0] as Map<String, dynamic>?;
        _orders = results[1] as List<Map<String, dynamic>>;
        _careTickets = results[2] as List<Map<String, dynamic>>;
        _bookings = results[3] as List<Map<String, dynamic>>;
        _staffList = results[4] as List<Map<String, dynamic>>;
        _isLoading = false;
      });
    }
    _loadRevenueReport();
  }

  Color _getOrderStatusColor(dynamic status) {
    int s = 1;
    if (status is int) s = status;
    else if (status != null) s = int.tryParse(status.toString()) ?? 1;

    switch (s) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.green;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getOrderStatusText(dynamic status) {
    int s = 1;
    if (status is int) s = status;
    else if (status != null) s = int.tryParse(status.toString()) ?? 1;

    switch (s) {
      case 1:
        return 'Chờ xác nhận';
      case 2:
        return 'Đã xác nhận';
      case 3:
        return 'Đang giao hàng';
      case 4:
        return 'Hoàn thành';
      case 5:
        return 'Đã hủy';
      default:
        return 'Đang xử lý';
    }
  }

  // Dialog cập nhật trạng thái đơn hàng
  void _showUpdateOrderDialog(Map<String, dynamic> order) {
    int currentStatus = 1;
    if (order['tinhTrang'] != null) {
      currentStatus = int.tryParse(order['tinhTrang'].toString()) ?? 1;
    }
    bool isPaid = order['daThanhToan'] == true;

    showDialog(
      context: context,
      builder: (ctx) {
        int selectedStatus = currentStatus;
        bool selectedPaid = isPaid;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('Đơn hàng #${order['maHD']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Khách: ${order['tenKhachHang'] ?? "Khách lẻ"}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('SĐT: ${order['soDienThoai'] ?? "---"}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    Text('Tổng tiền: ${_currencyFormat.format(order['tongTien'] ?? 0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE91E63))),
                    const SizedBox(height: 16),
                    const Text('Tình trạng đơn:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('1. Chờ xác nhận')),
                        DropdownMenuItem(value: 2, child: Text('2. Đã xác nhận')),
                        DropdownMenuItem(value: 3, child: Text('3. Đang giao hàng')),
                        DropdownMenuItem(value: 4, child: Text('4. Hoàn thành')),
                        DropdownMenuItem(value: 5, child: Text('5. Đã hủy đơn')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedStatus = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Đã thanh toán', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(order['hinhThucThanhToan'] ?? 'COD'),
                      value: selectedPaid,
                      activeColor: const Color(0xFFE91E63),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedPaid = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final res = await ApiService.updateAdminOrderStatus(
                      order['maHD'],
                      tinhTrang: selectedStatus,
                      daThanhToan: selectedPaid,
                    );
                    if (res['success'] == true) {
                      _loadAllAdminData();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(res['message'] ?? 'Cập nhật thành công!')),
                        );
                      }
                    }
                  },
                  child: const Text('Lưu thay đổi'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Dialog phân công nhân sự cho phiếu chăm sóc
  void _showAssignTicketDialog(Map<String, dynamic> ticket) {
    int? currentStaff = ticket['maNVThucHien'];

    showDialog(
      context: context,
      builder: (ctx) {
        int? selectedStaff = currentStaff;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('Phân công: ${ticket['soPhieu'] ?? ""}', style: const TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bé cưng: ${ticket['tenThuCung'] ?? "Bé"}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  const Text('Chọn nhân viên phụ trách:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<int>(
                    value: selectedStaff,
                    hint: const Text('Chọn nhân viên'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _staffList.map((st) {
                      return DropdownMenuItem<int>(
                        value: st['maNV'],
                        child: Text('${st['tenNV']} (${st['tenVaiTro'] ?? ""})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setDialogState(() => selectedStaff = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: selectedStaff == null
                      ? null
                      : () async {
                          Navigator.pop(ctx);
                          final res = await ApiService.assignAdminCareTicketStaff(ticket['maPhieuDV'], selectedStaff!);
                          if (res['success'] == true) {
                            _loadAllAdminData();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(res['message'] ?? 'Phân công thành công!')),
                              );
                            }
                          }
                        },
                  child: const Text('Xác nhận'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Dialog phân công nhân sự cho lịch hẹn
  void _showAssignBookingDialog(Map<String, dynamic> booking) {
    int? currentStaff = booking['maNV'];

    showDialog(
      context: context,
      builder: (ctx) {
        int? selectedStaff = currentStaff;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('Phân công: Lịch hẹn #${booking['maDatLich']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Khách: ${booking['tenKhachHang'] ?? ""}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('Dịch vụ: ${booking['tenDichVu'] ?? ""}', style: const TextStyle(color: Color(0xFFE91E63), fontSize: 13)),
                  const SizedBox(height: 12),
                  const Text('Chọn bác sĩ / nhân viên phụ trách:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<int>(
                    value: selectedStaff,
                    hint: const Text('Chọn nhân sự'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _staffList.map((st) {
                      return DropdownMenuItem<int>(
                        value: st['maNV'],
                        child: Text('${st['tenNV']} (${st['tenVaiTro'] ?? ""})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setDialogState(() => selectedStaff = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: selectedStaff == null
                      ? null
                      : () async {
                          Navigator.pop(ctx);
                          final res = await ApiService.assignAdminBookingStaff(booking['maDatLich'], selectedStaff!);
                          if (res['success'] == true) {
                            _loadAllAdminData();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(res['message'] ?? 'Phân công thành công!')),
                              );
                            }
                          }
                        },
                  child: const Text('Xác nhận'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quản Trị PetShop', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              '${widget.currentUser.tenKH} • Quản trị viên (Admin)',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B), // Professional Dark Navy for Admin
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            tooltip: 'Xem Cửa hàng Khách',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen(currentUser: widget.currentUser)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
            onPressed: _loadAllAdminData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
          : IndexedStack(
              index: _currentIndex,
              children: [
                _buildDashboardTab(),
                _buildOrdersTab(),
                _buildServicesTab(),
                _buildStaffTab(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFE91E63),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Tổng quan'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Đơn hàng'),
          BottomNavigationBarItem(icon: Icon(Icons.pets_outlined), activeIcon: Icon(Icons.pets), label: 'Dịch vụ'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Nhân sự'),
        ],
      ),
    );
  }

  // --- TAB 1: DASHBOARD ---
  Widget _buildDashboardTab() {
    final d = _dashboardData;
    if (d == null) {
      return const Center(child: Text('Không thể tải dữ liệu thống kê'));
    }

    final rep = _revenueReport;
    final periodTotalRev = rep != null ? (rep['tongDoanhThuHopNhat'] ?? 0) : (d['tongDoanhThuTongCong'] ?? 0);
    final periodProdRev = rep != null ? (rep['tongDoanhThuSanPham'] ?? 0) : (d['tongDoanhThu'] ?? 0);
    final periodServRev = rep != null ? (rep['tongDoanhThuDichVu'] ?? 0) : (d['tongDoanhThuDichVu'] ?? 0);
    final periodProdCount = rep?['soDonHangSanPham'] ?? 0;
    final periodServCount = rep?['soPhieuDichVu'] ?? 0;
    final timeLabel = rep?['selectedTimeLabel'] ?? '';

    String periodTitle;
    if (_selectedRevenuePeriod == 'day') {
      periodTitle = 'DOANH THU THEO NGÀY';
    } else if (_selectedRevenuePeriod == 'week') {
      periodTitle = 'DOANH THU THEO TUẦN';
    } else if (_selectedRevenuePeriod == 'month') {
      periodTitle = 'DOANH THU THEO THÁNG';
    } else {
      periodTitle = 'DOANH THU THEO NĂM';
    }

    final topProducts = (d['topProducts'] as List?) ?? [];
    final topServices = (d['topServices'] as List?) ?? [];

    return RefreshIndicator(
      onRefresh: _loadAllAdminData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Doanh thu theo Ngày / Tuần / Tháng
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF334155)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          periodTitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (timeLabel.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            timeLabel,
                            style: const TextStyle(color: Colors.white38, fontSize: 11),
                          ),
                        ],
                      ],
                    ),
                    // Nhấn vào hình mũi tên thay cho logo đồng tiền để xem chi tiết
                    InkWell(
                      onTap: _showRevenueDetailModal,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Các nút chọn Ngày, Tuần, Tháng
                Row(
                  children: [
                    _buildCardPeriodBtn('day', 'Ngày'),
                    const SizedBox(width: 8),
                    _buildCardPeriodBtn('week', 'Tuần'),
                    const SizedBox(width: 8),
                    _buildCardPeriodBtn('month', 'Tháng'),
                  ],
                ),
                const SizedBox(height: 14),

                if (_isLoadingReport) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    ),
                  ),
                ] else ...[
                  Text(
                    _currencyFormat.format(periodTotalRev),
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            periodProdCount > 0 ? 'Bán hàng ($periodProdCount đơn):' : 'Bán hàng:',
                            style: const TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _currencyFormat.format(periodProdRev),
                            style: const TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            periodServCount > 0 ? 'Dịch vụ ($periodServCount phiếu):' : 'Dịch vụ:',
                            style: const TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _currencyFormat.format(periodServRev),
                            style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Lưới thống kê số lượng
          const Text('Hoạt động tổng quan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.6,
            children: [
              _buildStatCard('Đơn bán hàng', '${d['tongHoaDon'] ?? 0}', Icons.shopping_bag_outlined, Colors.blue),
              _buildStatCard('Phiếu chăm sóc', '${d['tongPhieuDichVu'] ?? 0}', Icons.pets, Colors.purple),
              _buildStatCard('Lịch hẹn online', '${d['tongDatLich'] ?? 0}', Icons.calendar_month_outlined, Colors.orange),
              _buildStatCard('Khách hàng', '${d['tongKhachHang'] ?? 0}', Icons.group_outlined, Colors.teal),
            ],
          ),
          const SizedBox(height: 20),

          // Top sản phẩm bán chạy
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.trending_up, color: Color(0xFFE91E63)),
                      SizedBox(width: 8),
                      Text('Top sản phẩm bán chạy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 20),
                  if (topProducts.isEmpty)
                    const Text('Chưa có dữ liệu bán hàng', style: TextStyle(color: Colors.grey))
                  else
                    ...topProducts.map((p) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(p['tenSP'] ?? '',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text('${p['soLuongBan'] ?? 0} đã bán',
                                    style: const TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Top dịch vụ hot
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.star_outline, color: Colors.amber),
                      SizedBox(width: 8),
                      Text('Top dịch vụ phổ biến', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 20),
                  if (topServices.isEmpty)
                    const Text('Chưa có dữ liệu dịch vụ', style: TextStyle(color: Colors.grey))
                  else
                    ...topServices.map((s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(s['tenDV'] ?? '',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text('${s['soLuotSuDung'] ?? 0} lượt',
                                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardPeriodBtn(String key, String title) {
    final isSelected = _selectedRevenuePeriod == key;
    return GestureDetector(
      onTap: () {
        if (_selectedRevenuePeriod == key) return;
        setState(() {
          _selectedRevenuePeriod = key;
          _selectedDate = DateTime.now();
        });
        _loadRevenueReport();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE91E63) : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFE91E63) : Colors.white24,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showRevenueDetailModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final rep = _revenueReport;
            final timeLabel = rep?['selectedTimeLabel'] ?? '';
            final totalRev = rep?['tongDoanhThuHopNhat'] ?? 0;
            final prodRev = rep?['tongDoanhThuSanPham'] ?? 0;
            final prodCount = rep?['soDonHangSanPham'] ?? 0;
            final servRev = rep?['tongDoanhThuDichVu'] ?? 0;
            final servCount = rep?['soPhieuDichVu'] ?? 0;

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.insights, color: Color(0xFFE91E63), size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Chi tiết doanh thu',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nút chọn Ngày, Tuần, Tháng, Năm trong modal
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      children: [
                        _buildModalPeriodItem('day', 'Ngày', setModalState),
                        _buildModalPeriodItem('week', 'Tuần', setModalState),
                        _buildModalPeriodItem('month', 'Tháng', setModalState),
                        _buildModalPeriodItem('year', 'Năm', setModalState),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Điều hướng thời gian
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, size: 22, color: Color(0xFFE91E63)),
                          onPressed: () async {
                            setState(() {
                              if (_selectedRevenuePeriod == 'day') {
                                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                              } else if (_selectedRevenuePeriod == 'week') {
                                _selectedDate = _selectedDate.subtract(const Duration(days: 7));
                              } else if (_selectedRevenuePeriod == 'month') {
                                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
                              } else if (_selectedRevenuePeriod == 'year') {
                                _selectedDate = DateTime(_selectedDate.year - 1, 1, 1);
                              }
                            });
                            await _loadRevenueReport();
                            setModalState(() {});
                          },
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setState(() => _selectedDate = picked);
                                await _loadRevenueReport();
                                setModalState(() {});
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_today, size: 14, color: Color(0xFFE91E63)),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    timeLabel.isNotEmpty ? timeLabel : 'Chọn thời gian',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C3E50)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, size: 22, color: Color(0xFFE91E63)),
                          onPressed: () async {
                            setState(() {
                              if (_selectedRevenuePeriod == 'day') {
                                _selectedDate = _selectedDate.add(const Duration(days: 1));
                              } else if (_selectedRevenuePeriod == 'week') {
                                _selectedDate = _selectedDate.add(const Duration(days: 7));
                              } else if (_selectedRevenuePeriod == 'month') {
                                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
                              } else if (_selectedRevenuePeriod == 'year') {
                                _selectedDate = DateTime(_selectedDate.year + 1, 1, 1);
                              }
                            });
                            await _loadRevenueReport();
                            setModalState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_isLoadingReport)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(color: Color(0xFFE91E63)),
                      ),
                    )
                  else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tổng doanh thu:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                              Text(
                                _currencyFormat.format(totalRev),
                                style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Bán hàng ($prodCount đơn):', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currencyFormat.format(prodRev),
                                      style: const TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Dịch vụ ($servCount phiếu):', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currencyFormat.format(servRev),
                                      style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalPeriodItem(String key, String title, StateSetter setModalState) {
    final isSelected = _selectedRevenuePeriod == key;
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          setState(() {
            _selectedRevenuePeriod = key;
          });
          await _loadRevenueReport();
          setModalState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE91E63) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
              CircleAvatar(radius: 14, backgroundColor: color.withOpacity(0.15), child: Icon(icon, size: 16, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // --- TAB 2: QUẢN LÝ ĐƠN HÀNG ---
  Widget _buildOrdersTab() {
    if (_orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadAllAdminData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Center(child: Text('Chưa có đơn hàng nào', style: TextStyle(color: Colors.grey, fontSize: 16))),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAllAdminData,
      child: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final o = _orders[index];
          final statusColor = _getOrderStatusColor(o['tinhTrang']);
          final statusText = _getOrderStatusText(o['tinhTrang']);
          final isPaid = o['daThanhToan'] == true;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đơn hàng #${o['maHD']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor.withOpacity(0.4)),
                        ),
                        child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Khách: ${o['tenKhachHang'] ?? "Khách lẻ"} • SĐT: ${o['soDienThoai'] ?? "---"}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  if (o['diaChiGiaoHang'] != null)
                    Text('Đ/C: ${o['diaChiGiaoHang']}', style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isPaid ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isPaid ? 'ĐÃ THANH TOÁN' : 'CHƯA THANH TOÁN',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isPaid ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${o['hinhThucThanhToan'] ?? "COD"}', style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    ],
                  ),
                  const Divider(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _currencyFormat.format(o['tongTien'] ?? 0),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFE91E63)),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E293B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        icon: const Icon(Icons.edit, size: 14),
                        label: const Text('Cập nhật', style: TextStyle(fontSize: 12)),
                        onPressed: () => _showUpdateOrderDialog(o),
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

  // --- TAB 3: QUẢN LÝ DỊCH VỤ & LỊCH HẸN ---
  Widget _buildServicesTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              indicatorColor: Color(0xFFE91E63),
              labelColor: Color(0xFFE91E63),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Phiếu chăm sóc tại quầy'),
                Tab(text: 'Lịch hẹn online'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildCareTicketsAdminList(),
                _buildBookingsAdminList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTicketsAdminList() {
    if (_careTickets.isEmpty) {
      return const Center(child: Text('Chưa có phiếu chăm sóc nào'));
    }
    return RefreshIndicator(
      onRefresh: _loadAllAdminData,
      child: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _careTickets.length,
        itemBuilder: (context, index) {
          final t = _careTickets[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t['soPhieu'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE91E63))),
                      Text(t['trangThaiDichVu'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Bé: ${t['tenThuCung'] ?? "Bé cưng"} • Chủ: ${t['tenChuNuoi'] ?? "Khách lẻ"}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    'Phụ trách: ${t['tenNVThucHien'] ?? "Chưa phân công"}',
                    style: TextStyle(
                      fontSize: 13,
                      color: t['tenNVThucHien'] != null ? Colors.blue : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_currencyFormat.format(t['tongTien'] ?? 0),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE91E63),
                          side: const BorderSide(color: Color(0xFFE91E63)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        icon: const Icon(Icons.person_add, size: 14),
                        label: const Text('Phân công', style: TextStyle(fontSize: 12)),
                        onPressed: () => _showAssignTicketDialog(t),
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

  Widget _buildBookingsAdminList() {
    if (_bookings.isEmpty) {
      return const Center(child: Text('Chưa có lịch hẹn nào'));
    }
    return RefreshIndicator(
      onRefresh: _loadAllAdminData,
      child: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final b = _bookings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Lịch hẹn #${b['maDatLich']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      Text(b['trangThai'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Khách: ${b['tenKhachHang'] ?? ""} • ${b['soDienThoai'] ?? ""}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('Dịch vụ: ${b['tenDichVu'] ?? ""}', style: const TextStyle(color: Color(0xFFE91E63), fontSize: 13)),
                  Text('Thời gian: ${b['gioDat']} ngày ${b['ngayDat']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    'Bác sĩ/Nhân sự: ${b['tenNV'] ?? "Chưa phân công"}',
                    style: TextStyle(
                      fontSize: 13,
                      color: b['tenNV'] != null ? Colors.blue : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE91E63),
                          side: const BorderSide(color: Color(0xFFE91E63)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        icon: const Icon(Icons.person_add, size: 14),
                        label: const Text('Phân công BS/NV', style: TextStyle(fontSize: 12)),
                        onPressed: () => _showAssignBookingDialog(b),
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

  // --- TAB 4: NHÂN SỰ & HỆ THỐNG ---
  Widget _buildStaffTab() {
    return RefreshIndicator(
      onRefresh: _loadAllAdminData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Danh sách nhân sự (${_staffList.length})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          ..._staffList.map((st) {
            final isWorking = st['trangThai'] == null || st['trangThai'] == 'Đang làm việc';

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE91E63).withOpacity(0.15),
                  child: Text(
                    (st['tenNV'] ?? 'N').toString().substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(st['tenNV'] ?? 'Nhân viên', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vai trò: ${st['tenVaiTro'] ?? "Nhân viên"}', style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    if (st['email'] != null) Text('Email: ${st['email']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    if (st['dienThoai'] != null) Text('SĐT: ${st['dienThoai']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isWorking ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isWorking ? 'Đang làm việc' : 'Tạm nghỉ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isWorking ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

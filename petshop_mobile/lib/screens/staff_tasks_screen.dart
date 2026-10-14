import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class StaffTasksScreen extends StatefulWidget {
  final UserModel currentUser;

  const StaffTasksScreen({super.key, required this.currentUser});

  @override
  State<StaffTasksScreen> createState() => _StaffTasksScreenState();
}

class _StaffTasksScreenState extends State<StaffTasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<Map<String, dynamic>> _bookings = [];
  List<Map<String, dynamic>> _careTickets = [];
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final maNV = widget.currentUser.maNV ?? 0;
    final data = await ApiService.getStaffTasks(maNV);

    if (mounted) {
      setState(() {
        _bookings = List<Map<String, dynamic>>.from(data['bookings'] ?? []);
        _careTickets = List<Map<String, dynamic>>.from(data['careTickets'] ?? []);
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'chờ tiếp nhận':
      case 'chờ xác nhận':
        return Colors.orange;
      case 'đang thực hiện':
      case 'đang chăm sóc':
      case 'đã tiếp nhận':
        return Colors.blue;
      case 'hoàn thành chăm sóc':
      case 'hoàn thành':
        return Colors.green;
      case 'đã trả bé':
      case 'đã bàn giao thú cưng':
        return Colors.purple;
      case 'đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showUpdateTicketDialog(Map<String, dynamic> ticket) {
    String currentStatus = ticket['trangThaiDichVu'] ?? 'Chờ tiếp nhận';
    final notesController = TextEditingController(text: ticket['ketQuaChamSoc'] ?? '');
    final statuses = ['Chờ tiếp nhận', 'Đang thực hiện', 'Hoàn thành chăm sóc', 'Đã trả bé'];

    showDialog(
      context: context,
      builder: (ctx) {
        String selectedStatus = currentStatus;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  const Icon(Icons.edit_note, color: Color(0xFFE91E63)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Phiếu ${ticket['soPhieu'] ?? ''}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bé cưng: ${ticket['tenThuCung'] ?? 'Chưa rõ'}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    const Text('Trạng thái dịch vụ:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: statuses.contains(selectedStatus) ? selectedStatus : statuses.first,
                          items: statuses.map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Row(
                                children: [
                                  CircleAvatar(radius: 5, backgroundColor: _getStatusColor(s)),
                                  const SizedBox(width: 8),
                                  Text(s, style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => selectedStatus = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Kết quả / Ghi chú chăm sóc:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Nhập tình trạng sức khỏe, kết quả spa...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.all(12),
                      ),
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
                    final res = await ApiService.updateStaffTicketProgress(
                      ticket['maPhieuDV'],
                      selectedStatus,
                      ketQuaChamSoc: notesController.text.trim(),
                    );
                    if (res['success'] == true) {
                      _loadTasks();
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

  void _showUpdateBookingDialog(Map<String, dynamic> booking) {
    String currentStatus = booking['trangThai'] ?? 'Chờ xác nhận';
    final notesController = TextEditingController(text: booking['ghiChu'] ?? '');
    final statuses = ['Chờ xác nhận', 'Đã tiếp nhận', 'Đang chăm sóc', 'Hoàn thành', 'Đã hủy'];

    showDialog(
      context: context,
      builder: (ctx) {
        String selectedStatus = currentStatus;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Color(0xFFE91E63)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Lịch hẹn #${booking['maDatLich'] ?? ''}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Khách hàng: ${booking['tenKhachHang'] ?? 'Chưa rõ'}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Dịch vụ: ${booking['tenDichVu'] ?? 'Dịch vụ thú cưng'}',
                        style: const TextStyle(color: Color(0xFFE91E63), fontSize: 13)),
                    const SizedBox(height: 12),
                    const Text('Trạng thái lịch hẹn:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: statuses.contains(selectedStatus) ? selectedStatus : statuses.first,
                          items: statuses.map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Row(
                                children: [
                                  CircleAvatar(radius: 5, backgroundColor: _getStatusColor(s)),
                                  const SizedBox(width: 8),
                                  Text(s, style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => selectedStatus = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Ghi chú thực hiện:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Nhập ghi chú hoặc kết quả tư vấn...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.all(12),
                      ),
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
                    final res = await ApiService.updateStaffBookingProgress(
                      booking['maDatLich'],
                      selectedStatus,
                      ghiChu: notesController.text.trim(),
                    );
                    if (res['success'] == true) {
                      _loadTasks();
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

  @override
  Widget build(BuildContext context) {
    final staff = widget.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lịch làm việc của tôi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              '${staff.tenKH} • ${staff.chucVu ?? "Nhân viên"}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            tooltip: 'Xem Cửa hàng',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen(currentUser: staff)),
              );
            },
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              icon: const Icon(Icons.pets),
              text: 'Phiếu chăm sóc (${_careTickets.length})',
            ),
            Tab(
              icon: const Icon(Icons.calendar_month),
              text: 'Lịch hẹn online (${_bookings.length})',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCareTicketsTab(),
                _buildBookingsTab(),
              ],
            ),
    );
  }

  Widget _buildCareTicketsTab() {
    if (_careTickets.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadTasks,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            const Icon(Icons.pets, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Chưa có phiếu chăm sóc nào được phân công',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _careTickets.length,
        itemBuilder: (context, index) {
          final t = _careTickets[index];
          final statusColor = _getStatusColor(t['trangThaiDichVu']);

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          t['soPhieu'] ?? 'PDV',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE91E63)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor.withOpacity(0.4)),
                        ),
                        child: Text(
                          t['trangThaiDichVu'] ?? 'Chờ tiếp nhận',
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.pets, size: 20, color: Color(0xFFE91E63)),
                      const SizedBox(width: 8),
                      Text(
                        'Bé: ${t['tenThuCung'] ?? "Bé cưng"}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (t['loaiThuCung'] != null)
                        Text(
                          ' (${t['loaiThuCung']}${t['giongLoai'] != null ? " - " + t['giongLoai'] : ""})',
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (t['canNangTiepNhan'] != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Text('Cân nặng: ${t['canNangTiepNhan']} kg',
                          style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('Chủ: ${t['tenChuNuoi'] ?? "Khách lẻ"}', style: const TextStyle(fontSize: 13)),
                      if (t['soDienThoaiChu'] != null)
                        Text(' • ${t['soDienThoaiChu']}', style: const TextStyle(fontSize: 13, color: Colors.blueGrey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Tiếp nhận: ${t['ngayTiepNhan'] != null ? t['ngayTiepNhan'].toString().replaceFirst("T", " ") : ""}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  if (t['yeuCauCuaChuNuoi'] != null && t['yeuCauCuaChuNuoi'].toString().trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Yêu cầu của chủ: ${t['yeuCauCuaChuNuoi']}',
                        style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                      ),
                    ),
                  ],
                  if (t['ketQuaChamSoc'] != null && t['ketQuaChamSoc'].toString().trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Kết quả: ${t['ketQuaChamSoc']}',
                        style: TextStyle(fontSize: 12, color: Colors.green.shade900),
                      ),
                    ),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thanh toán: ${t['tongTien'] != null ? _currencyFormat.format(t['tongTien']) : "0đ"}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        icon: const Icon(Icons.update, size: 16),
                        label: const Text('Cập nhật'),
                        onPressed: () => _showUpdateTicketDialog(t),
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

  Widget _buildBookingsTab() {
    if (_bookings.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadTasks,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            const Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Chưa có lịch hẹn trực tuyến nào được phân công',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final b = _bookings[index];
          final statusColor = _getStatusColor(b['trangThai']);

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lịch hẹn #${b['maDatLich']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2C3E50)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor.withOpacity(0.4)),
                        ),
                        child: Text(
                          b['trangThai'] ?? 'Chờ xác nhận',
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: Color(0xFFE91E63)),
                      const SizedBox(width: 8),
                      Text(
                        b['tenKhachHang'] ?? 'Khách hàng',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      if (b['soDienThoai'] != null)
                        Text(' • ${b['soDienThoai']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.medical_services_outlined, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Dịch vụ: ${b['tenDichVu'] ?? "Chăm sóc thú cưng"}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.event, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Thời gian: ${b['gioDat'] ?? ""} ngày ${b['ngayDat'] ?? ""}',
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ),
                  if (b['ghiChu'] != null && b['ghiChu'].toString().trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Ghi chú: ${b['ghiChu']}',
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                  const Divider(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Cập nhật tiến độ'),
                      onPressed: () => _showUpdateBookingDialog(b),
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
}

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/notification_model.dart';
import '../services/api_service.dart';

class NotificationScreen extends StatefulWidget {
  final UserModel currentUser;

  const NotificationScreen({super.key, required this.currentUser});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() async {
    setState(() => _isLoading = true);
    final list = await ApiService.getNotifications(widget.currentUser.maKH);
    if (mounted) {
      setState(() {
        _notifications = list;
        _isLoading = false;
      });
    }
  }

  void _markAllAsRead() async {
    await ApiService.markAllNotificationsAsRead(widget.currentUser.maKH);
    _loadNotifications();
  }

  void _markItemAsRead(NotificationModel tb) async {
    if (!tb.isRead) {
      await ApiService.markNotificationAsRead(tb.maThongBao);
      _loadNotifications();
    }
  }

  IconData _getIcon(String loai) {
    switch (loai.toLowerCase()) {
      case 'datlich':
        return Icons.calendar_month;
      case 'donhang':
        return Icons.local_shipping;
      case 'huydon':
        return Icons.cancel;
      case 'khuyenmai':
        return Icons.card_giftcard;
      case 'nhaclichtaikham':
        return Icons.health_and_safety;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String loai) {
    switch (loai.toLowerCase()) {
      case 'datlich':
        return const Color(0xFFE91E63);
      case 'donhang':
        return Colors.blue;
      case 'huydon':
        return Colors.red;
      case 'khuyenmai':
        return Colors.orange;
      case 'nhaclichtaikham':
        return Colors.teal;
      default:
        return const Color(0xFFE91E63);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Đọc tất cả', style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
          : _notifications.isEmpty
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
                        child: const Icon(Icons.notifications_none, size: 64, color: Color(0xFFE91E63)),
                      ),
                      const SizedBox(height: 16),
                      const Text('Chưa có thông báo nào', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Mọi cập nhật về lịch hẹn và đơn hàng sẽ xuất hiện tại đây.', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => _loadNotifications(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) {
                      final tb = _notifications[i];
                      final iconColor = _getIconColor(tb.loaiThongBao);

                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: tb.isRead ? 1 : 3,
                        color: tb.isRead ? Colors.white : const Color(0xFFFFF7F9),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _markItemAsRead(tb),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon tròn
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: iconColor.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(_getIcon(tb.loaiThongBao), color: iconColor, size: 24),
                                ),
                                const SizedBox(width: 14),
                                // Nội dung
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              tb.tieuDe,
                                              style: TextStyle(
                                                fontWeight: tb.isRead ? FontWeight.w600 : FontWeight.bold,
                                                fontSize: 14,
                                                color: const Color(0xFF2C3E50),
                                              ),
                                            ),
                                          ),
                                          if (!tb.isRead)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE91E63),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        tb.noiDung,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: tb.isRead ? Colors.black87 : Colors.black,
                                          height: 1.3,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        tb.ngayTao,
                                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/booking_model.dart';
import '../models/order_model.dart';
import '../models/notification_model.dart';

class ApiService {
  // Tự động nhận diện: localhost cho Web/Windows, 10.0.2.2 cho Android Emulator
  static String baseUrl = (kIsWeb || defaultTargetPlatform == TargetPlatform.windows)
      ? 'http://localhost:8080'
      : 'http://10.0.2.2:8080';

  static void setBaseUrl(String url) {
    baseUrl = url;
  }

  // URL hình ảnh đầy đủ từ backend
  static String getImageUrl(String? imageName) {
    if (imageName == null || imageName.trim().isEmpty) return '';
    return '$baseUrl/Content/HinhAnh/${imageName.trim()}';
  }

  // Lấy danh mục từ tblDanhMuc
  static Future<List<CategoryModel>> getCategories() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/categories'));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => CategoryModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getCategories error: $e');
    }
    return [];
  }

  // 1. Đăng nhập
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode == 200 && data['success'] == true && data['user'] != null) {
        return {
          'success': true,
          'user': UserModel.fromJson(data['user']),
          'message': data['message'] ?? 'Đăng nhập thành công',
        };
      } else {
        return {
          'success': false,
          'user': null,
          'message': data['message'] ?? 'Đăng nhập thất bại. Vui lòng thử lại!',
        };
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return {
        'success': false,
        'user': null,
        'message': 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra lại mạng!',
      };
    }
  }

  // 1b. Lấy thông tin tài khoản & thành viên mới nhất
  static Future<UserModel?> getProfile(int maKH) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/auth/profile?maKH=$maKH'));
      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        if (data['success'] == true && data['user'] != null) {
          return UserModel.fromJson(data['user']);
        }
      }
    } catch (e) {
      debugPrint('getProfile error: $e');
    }
    return null;
  }

  // 2. Đăng ký
  static Future<Map<String, dynamic>> register({
    required String tenKH,
    required String email,
    required String password,
    String? dienThoai,
    String? diaChi,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tenKH': tenKH,
          'email': email,
          'password': password,
          'dienThoai': dienThoai ?? '',
          'diaChi': diaChi ?? '',
        }),
      );
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // 3. Danh sách sản phẩm (hỗ trợ search, categoryId, type, loai, sort)
  static Future<List<ProductModel>> getProducts({
    String? search,
    String? type,
    int? categoryId,
    String? loai,
    String? sort,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (type != null && type.isNotEmpty) queryParams['type'] = type;
      if (categoryId != null && categoryId > 0) queryParams['categoryId'] = categoryId.toString();
      if (loai != null && loai.isNotEmpty) queryParams['loai'] = loai;
      if (sort != null && sort.isNotEmpty) queryParams['sort'] = sort;

      final uri = Uri.parse('$baseUrl/api/products').replace(queryParameters: queryParams.isEmpty ? null : queryParams);
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getProducts error: $e');
    }
    return [];
  }

  // 4. Chi tiết sản phẩm
  static Future<Map<String, dynamic>?> getProductDetail(int id) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/products/$id'));
      if (res.statusCode == 200) {
        return jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (e) {
      debugPrint('getProductDetail error: $e');
    }
    return null;
  }

  // 5. Danh sách dịch vụ chăm sóc
  static Future<List<ServiceModel>> getServices() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/bookings/services'));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => ServiceModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getServices error: $e');
    }
    return [];
  }

  // 6. Đặt lịch hẹn
  static Future<Map<String, dynamic>> createBooking({
    required int maKH,
    required String tenKhachHang,
    required String soDienThoai,
    required String email,
    required String ngayDat,
    required String gioDat,
    required int maDV,
    String? ghiChu,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'maKH': maKH,
          'tenKhachHang': tenKhachHang,
          'soDienThoai': soDienThoai,
          'email': email,
          'ngayDat': ngayDat,
          'gioDat': gioDat,
          'maDV': maDV,
          'ghiChu': ghiChu ?? '',
        }),
      );
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // 7. Lấy danh sách lịch hẹn của tôi
  static Future<List<BookingModel>> getMyBookings(int maKH) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/bookings/my?maKH=$maKH'));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => BookingModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getMyBookings error: $e');
    }
    return [];
  }

  // 8. Đặt hàng
  static Future<Map<String, dynamic>> createOrder({
    required int maKH,
    required String diaChiGiaoHang,
    required List<Map<String, dynamic>> items,
    String? maGiamGia,
    String hinhThucThanhToan = 'COD',
  }) async {
    try {
      final cleanVoucher = (maGiamGia != null && maGiamGia.trim().isNotEmpty) ? maGiamGia.trim() : null;
      final res = await http.post(
        Uri.parse('$baseUrl/api/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'maKH': maKH,
          'diaChiGiaoHang': diaChiGiaoHang,
          'items': items,
          'maGiamGia': cleanVoucher,
          'hinhThucThanhToan': hinhThucThanhToan,
        }),
      );
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // 9. Danh sách đơn hàng của tôi
  static Future<List<OrderModel>> getMyOrders(int maKH) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/orders/my?maKH=$maKH'));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => OrderModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getMyOrders error: $e');
    }
    return [];
  }

  // 10. Hủy đơn hàng
  static Future<Map<String, dynamic>> cancelOrder(int maHD, int maKH) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/api/orders/$maHD/cancel?maKH=$maKH'));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // 11. Lấy danh sách thông báo
  static Future<List<NotificationModel>> getNotifications(int maKH) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/notifications?maKH=$maKH'));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => NotificationModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getNotifications error: $e');
    }
    return [];
  }

  // 12. Đếm số thông báo chưa đọc
  static Future<int> getUnreadNotificationCount(int maKH) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/notifications/unread-count?maKH=$maKH'));
      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        return (data['unreadCount'] as num?)?.toInt() ?? 0;
      }
    } catch (e) {
      debugPrint('getUnreadNotificationCount error: $e');
    }
    return 0;
  }

  // 13. Đánh dấu đã đọc
  static Future<bool> markNotificationAsRead(int id) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/api/notifications/$id/read'));
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('markNotificationAsRead error: $e');
      return false;
    }
  }

  // 14. Đánh dấu tất cả đã đọc
  static Future<bool> markAllNotificationsAsRead(int maKH) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/api/notifications/read-all?maKH=$maKH'));
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('markAllNotificationsAsRead error: $e');
      return false;
    }
  }

  // --- STAFF APIs ---
  // Lấy danh sách nhiệm vụ / ca làm việc của nhân viên
  static Future<Map<String, dynamic>> getStaffTasks(int maNV) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/staff/tasks?maNV=$maNV'));
      if (res.statusCode == 200) {
        return jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (e) {
      debugPrint('getStaffTasks error: $e');
    }
    return {'bookings': [], 'careTickets': []};
  }

  // Cập nhật tiến độ lịch hẹn (Staff)
  static Future<Map<String, dynamic>> updateStaffBookingProgress(int id, String trangThai, {String? ghiChu}) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/staff/tasks/update-booking'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'trangThai': trangThai, 'ghiChu': ghiChu}),
      );
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Cập nhật tiến độ phiếu chăm sóc (Staff)
  static Future<Map<String, dynamic>> updateStaffTicketProgress(int id, String trangThaiDichVu, {String? ketQuaChamSoc}) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/staff/tasks/update-ticket'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'trangThaiDichVu': trangThaiDichVu, 'ketQuaChamSoc': ketQuaChamSoc}),
      );
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // --- ADMIN APIs ---
  // Dashboard tổng quan
  static Future<Map<String, dynamic>?> getAdminDashboard() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/admin/dashboard'));
      if (res.statusCode == 200) {
        return jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (e) {
      debugPrint('getAdminDashboard error: $e');
    }
    return null;
  }

  // Danh sách toàn bộ đơn hàng
  static Future<List<Map<String, dynamic>>> getAdminOrders() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/admin/orders'));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint('getAdminOrders error: $e');
    }
    return [];
  }

  // Cập nhật trạng thái đơn hàng (Admin)
  static Future<Map<String, dynamic>> updateAdminOrderStatus(int maHD, {int? tinhTrang, bool? daThanhToan}) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/admin/orders/update-status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'maHD': maHD, 'tinhTrang': tinhTrang, 'daThanhToan': daThanhToan}),
      );
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Danh sách phiếu dịch vụ chăm sóc
  static Future<List<Map<String, dynamic>>> getAdminCareTickets() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/admin/care-tickets'));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint('getAdminCareTickets error: $e');
    }
    return [];
  }

  // Phân công nhân viên cho phiếu chăm sóc
  static Future<Map<String, dynamic>> assignAdminCareTicketStaff(int maPhieuDV, int maNV) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/admin/care-tickets/assign'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'maPhieuDV': maPhieuDV, 'maNV': maNV}),
      );
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Danh sách toàn bộ lịch hẹn
  static Future<List<Map<String, dynamic>>> getAdminBookings() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/admin/bookings'));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint('getAdminBookings error: $e');
    }
    return [];
  }

  // Phân công nhân sự cho lịch hẹn
  static Future<Map<String, dynamic>> assignAdminBookingStaff(int maDatLich, int maNV) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/admin/bookings/assign'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'maDatLich': maDatLich, 'maNV': maNV}),
      );
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Cập nhật trạng thái lịch hẹn (Admin)
  static Future<Map<String, dynamic>> updateAdminBookingStatus(int maDatLich, String trangThai) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/admin/bookings/update-status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'maDatLich': maDatLich, 'trangThai': trangThai}),
      );
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Danh sách nhân sự
  static Future<List<Map<String, dynamic>>> getAdminStaffList() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/admin/staff'));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint('getAdminStaffList error: $e');
    }
    return [];
  }

  // Báo cáo thống kê doanh thu theo ngày, tuần, tháng, năm
  static Future<Map<String, dynamic>?> getAdminRevenueReport({
    String type = 'day',
    String? date,
    String? month,
    int? year,
  }) async {
    try {
      final queryParams = <String, String>{'type': type};
      if (date != null && date.isNotEmpty) queryParams['date'] = date;
      if (month != null && month.isNotEmpty) queryParams['month'] = month;
      if (year != null) queryParams['year'] = year.toString();

      final uri = Uri.parse('$baseUrl/api/admin/revenue-report').replace(queryParameters: queryParams);
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        return jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (e) {
      debugPrint('getAdminRevenueReport error: $e');
    }
    return null;
  }
}

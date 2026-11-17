import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/booking_model.dart';
import '../models/order_model.dart';
import '../models/notification_model.dart';
import '../models/pet_model.dart';

class ApiService {
  static String baseUrl = 'https://petshop-2pj5.onrender.com';

  static void setBaseUrl(String url) {
    baseUrl = url;
  }

  static String getImageUrl(String? imageName) {
    if (imageName == null || imageName.trim().isEmpty) return '';
    return '$baseUrl/Content/HinhAnh/${imageName.trim()}';
  }

  static Future<List<CategoryModel>> getCategories() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/categories')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => CategoryModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getCategories error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 90));
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
          'message': data['message'] ?? 'Tài khoản hoặc mật khẩu không chính xác. Vui lòng thử lại!',
        };
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return {
        'success': false,
        'user': null,
        'message': (e.toString().contains('TimeoutException')) ? 'Máy chủ Cloud đang thức dậy (mất ~30-60 giây). Vui lòng thử lại sau giây lát!' : 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra lại mạng!',
      };
    }
  }

  static Future<UserModel?> getProfile(int maKH) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/auth/profile?maKH=$maKH')).timeout(const Duration(seconds: 90));
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
      ).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

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
      final res = await http.get(uri).timeout(const Duration(seconds: 90));

      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getProducts error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getProductDetail(int id) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/products/$id')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        return jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (e) {
      debugPrint('getProductDetail error: $e');
    }
    return null;
  }

  static Future<List<ServiceModel>> getServices() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/bookings/services')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => ServiceModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getServices error: $e');
    }
    return [];
  }

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
      ).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<List<BookingModel>> getMyBookings(int maKH) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/bookings/my?maKH=$maKH')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => BookingModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getMyBookings error: $e');
    }
    return [];
  }

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
      ).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<List<OrderModel>> getMyOrders(int maKH) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/orders/my?maKH=$maKH')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => OrderModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getMyOrders error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> cancelOrder(int maHD, int maKH) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/api/orders/$maHD/cancel?maKH=$maKH')).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<List<NotificationModel>> getNotifications(int maKH) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/notifications?maKH=$maKH')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => NotificationModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getNotifications error: $e');
    }
    return [];
  }

  static Future<int> getUnreadNotificationCount(int maKH) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/notifications/unread-count?maKH=$maKH')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        return (data['unreadCount'] as num?)?.toInt() ?? 0;
      }
    } catch (e) {
      debugPrint('getUnreadNotificationCount error: $e');
    }
    return 0;
  }

  static Future<bool> markNotificationAsRead(int id) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/api/notifications/$id/read')).timeout(const Duration(seconds: 90));
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('markNotificationAsRead error: $e');
      return false;
    }
  }

  static Future<bool> markAllNotificationsAsRead(int maKH) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/api/notifications/read-all?maKH=$maKH')).timeout(const Duration(seconds: 90));
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('markAllNotificationsAsRead error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> getStaffTasks(int maNV) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/staff/tasks?maNV=$maNV')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        return jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (e) {
      debugPrint('getStaffTasks error: $e');
    }
    return {'bookings': [], 'careTickets': []};
  }

  static Future<Map<String, dynamic>> updateStaffBookingProgress(int id, String trangThai, {String? ghiChu}) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/staff/tasks/update-booking'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'trangThai': trangThai, 'ghiChu': ghiChu}),
      ).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateStaffTicketProgress(int id, String trangThaiDichVu, {String? ketQuaChamSoc}) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/staff/tasks/update-ticket'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'trangThaiDichVu': trangThaiDichVu, 'ketQuaChamSoc': ketQuaChamSoc}),
      ).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>?> getAdminDashboard() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/admin/dashboard')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        return jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (e) {
      debugPrint('getAdminDashboard error: $e');
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> getAdminOrders() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/admin/orders')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint('getAdminOrders error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> updateAdminOrderStatus(int maHD, {int? tinhTrang, bool? daThanhToan}) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/admin/orders/update-status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'maHD': maHD, 'tinhTrang': tinhTrang, 'daThanhToan': daThanhToan}),
      ).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<List<Map<String, dynamic>>> getAdminCareTickets() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/admin/care-tickets')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint('getAdminCareTickets error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> assignAdminCareTicketStaff(int maPhieuDV, int maNV) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/admin/care-tickets/assign'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'maPhieuDV': maPhieuDV, 'maNV': maNV}),
      ).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<List<Map<String, dynamic>>> getAdminBookings() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/admin/bookings')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint('getAdminBookings error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> assignAdminBookingStaff(int maDatLich, int maNV) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/admin/bookings/assign'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'maDatLich': maDatLich, 'maNV': maNV}),
      ).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateAdminBookingStatus(int maDatLich, String trangThai) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/admin/bookings/update-status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'maDatLich': maDatLich, 'trangThai': trangThai}),
      ).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<List<Map<String, dynamic>>> getAdminStaffList() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/admin/staff')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint('getAdminStaffList error: $e');
    }
    return [];
  }

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
      final res = await http.get(uri).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        return jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (e) {
      debugPrint('getAdminRevenueReport error: $e');
    }
    return null;
  }

  static Future<List<PetModel>> getMyPets(int maKH) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/pets/my?maKH=$maKH')).timeout(const Duration(seconds: 90));
      if (res.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(res.bodyBytes));
        return list.map((json) => PetModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('getMyPets error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> createPet(int maKH, Map<String, dynamic> petData) async {
    try {
      final payload = Map<String, dynamic>.from(petData);
      payload['maKH'] = maKH;
      final res = await http.post(
        Uri.parse('$baseUrl/api/pets'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updatePet(int id, Map<String, dynamic> petData) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/api/pets/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(petData),
      ).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> deletePet(int id, int maKH) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/api/pets/$id?maKH=$maKH')).timeout(const Duration(seconds: 90));
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}

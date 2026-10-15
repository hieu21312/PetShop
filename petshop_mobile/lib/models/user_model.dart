class UserModel {
  final int maKH;
  final int? maNV;
  final String tenKH;
  final String email;
  final String? dienThoai;
  final String? diaChi;
  final String hangThanhVien;
  final int diemTichLuy;
  final double discountPercent;
  final String role; // 'KhachHang', 'Admin', 'NhanVien'
  final String? chucVu;
  final String? chuyenMon;
  final String? anhDaiDien;

  UserModel({
    this.maKH = 0,
    this.maNV,
    required this.tenKH,
    required this.email,
    this.dienThoai,
    this.diaChi,
    this.hangThanhVien = 'Tiêu chuẩn',
    this.diemTichLuy = 0,
    this.discountPercent = 0.0,
    this.role = 'KhachHang',
    this.chucVu,
    this.chuyenMon,
    this.anhDaiDien,
  });

  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isStaff => role.toLowerCase() == 'nhanvien' || role.toLowerCase() == 'staff';
  bool get isCustomer => !isAdmin && !isStaff;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    int parsedMaKH = 0;
    if (json['maKH'] != null) {
      parsedMaKH = json['maKH'] is int ? json['maKH'] : (int.tryParse(json['maKH'].toString()) ?? 0);
    }

    int? parsedMaNV;
    if (json['maNV'] != null) {
      parsedMaNV = json['maNV'] is int ? json['maNV'] : int.tryParse(json['maNV'].toString());
    }

    return UserModel(
      maKH: parsedMaKH,
      maNV: parsedMaNV,
      tenKH: json['tenKH'] ?? json['tenNV'] ?? '',
      email: json['email'] ?? '',
      dienThoai: json['dienThoai'],
      diaChi: json['diaChi'],
      hangThanhVien: json['hangThanhVien'] ?? 'Tiêu chuẩn',
      diemTichLuy: json['diemTichLuy'] != null
          ? (int.tryParse(json['diemTichLuy'].toString()) ?? 0)
          : 0,
      discountPercent: json['discountPercent'] != null
          ? double.tryParse(json['discountPercent'].toString()) ?? 0.0
          : 0.0,
      role: json['role'] ?? 'KhachHang',
      chucVu: json['chucVu'],
      chuyenMon: json['chuyenMon'],
      anhDaiDien: json['anhDaiDien'],
    );
  }
}

class UserModel {
  final int maKH;
  final String tenKH;
  final String email;
  final String? dienThoai;
  final String? diaChi;
  final String hangThanhVien;
  final int diemTichLuy;
  final double discountPercent;

  UserModel({
    required this.maKH,
    required this.tenKH,
    required this.email,
    this.dienThoai,
    this.diaChi,
    this.hangThanhVien = 'Tiêu chuẩn',
    this.diemTichLuy = 0,
    this.discountPercent = 0.0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      maKH: json['maKH'] is int ? json['maKH'] : int.parse(json['maKH'].toString()),
      tenKH: json['tenKH'] ?? '',
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
    );
  }
}

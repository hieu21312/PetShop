class ServiceModel {
  final int maDV;
  final String tenDV;
  final String? moTa;
  final double giaDichVu;

  ServiceModel({
    required this.maDV,
    required this.tenDV,
    this.moTa,
    required this.giaDichVu,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      maDV: json['maDV'] is int ? json['maDV'] : int.parse(json['maDV'].toString()),
      tenDV: json['tenDV'] ?? '',
      moTa: json['moTa'],
      giaDichVu: json['giaDichVu'] != null ? double.tryParse(json['giaDichVu'].toString()) ?? 0.0 : 0.0,
    );
  }
}

class BookingModel {
  final int maDatLich;
  final String tenKhachHang;
  final String soDienThoai;
  final String ngayDat;
  final String gioDat;
  final String trangThai;
  final String? ghiChu;
  final String? tenDichVu;

  BookingModel({
    required this.maDatLich,
    required this.tenKhachHang,
    required this.soDienThoai,
    required this.ngayDat,
    required this.gioDat,
    required this.trangThai,
    this.ghiChu,
    this.tenDichVu,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      maDatLich: json['maDatLich'] is int ? json['maDatLich'] : int.parse(json['maDatLich'].toString()),
      tenKhachHang: json['tenKhachHang'] ?? '',
      soDienThoai: json['soDienThoai'] ?? '',
      ngayDat: json['ngayDat'] ?? '',
      gioDat: json['gioDat'] ?? '',
      trangThai: json['trangThai'] ?? 'Chờ xác nhận',
      ghiChu: json['ghiChu'],
      tenDichVu: json['tenDichVu'],
    );
  }
}

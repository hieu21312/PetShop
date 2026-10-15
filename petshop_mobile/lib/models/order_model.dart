class OrderModel {
  final int maHD;
  final String ngayLap;
  final double tongTien;
  final int tinhTrang;
  final String tinhTrangText;
  final bool daThanhToan;
  final String? diaChiGiaoHang;
  final String? hinhThucThanhToan;

  OrderModel({
    required this.maHD,
    required this.ngayLap,
    required this.tongTien,
    required this.tinhTrang,
    required this.tinhTrangText,
    required this.daThanhToan,
    this.diaChiGiaoHang,
    this.hinhThucThanhToan,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      maHD: json['maHD'] is int ? json['maHD'] : int.parse(json['maHD'].toString()),
      ngayLap: json['ngayLap'] ?? '',
      tongTien: json['tongTien'] != null ? double.tryParse(json['tongTien'].toString()) ?? 0.0 : 0.0,
      tinhTrang: json['tinhTrang'] is int ? json['tinhTrang'] : int.parse(json['tinhTrang'].toString()),
      tinhTrangText: json['tinhTrangText'] ?? 'Đang xử lý',
      daThanhToan: json['daThanhToan'] == true,
      diaChiGiaoHang: json['diaChiGiaoHang'],
      hinhThucThanhToan: json['hinhThucThanhToan'],
    );
  }
}

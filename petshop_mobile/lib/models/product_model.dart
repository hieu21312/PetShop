class ProductModel {
  final int maSP;
  final String tenSP;
  final String loaiSanPham;
  final int? maDanhMuc;
  final String tenDanhMuc;
  final double giaBan;
  final String? anhDaiDien;
  final String? mauSac;
  final String? gioiTinh;
  final String? tinhTrangSucKhoe;
  final String? moTa;
  final int? soLuongTon;
  final String? trangThaiTonKho;

  ProductModel({
    required this.maSP,
    required this.tenSP,
    required this.loaiSanPham,
    this.maDanhMuc,
    required this.tenDanhMuc,
    required this.giaBan,
    this.anhDaiDien,
    this.mauSac,
    this.gioiTinh,
    this.tinhTrangSucKhoe,
    this.moTa,
    this.soLuongTon,
    this.trangThaiTonKho,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      maSP: json['maSP'] is int ? json['maSP'] : int.parse(json['maSP'].toString()),
      tenSP: json['tenSP'] ?? '',
      loaiSanPham: json['loaiSanPham'] ?? 'Accessory',
      maDanhMuc: json['maDanhMuc'] is int ? json['maDanhMuc'] : (json['maDanhMuc'] != null ? int.tryParse(json['maDanhMuc'].toString()) : null),
      tenDanhMuc: json['tenDanhMuc'] ?? (json['loaiSanPham'] == 'Pet' ? 'Thú cưng' : 'Phụ kiện'),
      giaBan: json['giaBan'] != null ? double.tryParse(json['giaBan'].toString()) ?? 0.0 : 0.0,
      anhDaiDien: json['anhDaiDien'],
      mauSac: json['mauSac'],
      gioiTinh: json['gioiTinh'],
      tinhTrangSucKhoe: json['tinhTrangSucKhoe'],
      moTa: json['moTa'],
      soLuongTon: json['soLuongTon'] is int ? json['soLuongTon'] : (json['soLuongTon'] != null ? int.tryParse(json['soLuongTon'].toString()) : null),
      trangThaiTonKho: json['trangThaiTonKho'],
    );
  }
}

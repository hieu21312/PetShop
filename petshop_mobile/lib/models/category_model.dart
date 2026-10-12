class CategoryModel {
  final int maDanhMuc;
  final String tenDanhMuc;
  final String? ghiChu;

  CategoryModel({
    required this.maDanhMuc,
    required this.tenDanhMuc,
    this.ghiChu,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      maDanhMuc: json['maDanhMuc'] is int ? json['maDanhMuc'] : int.parse(json['maDanhMuc'].toString()),
      tenDanhMuc: json['tenDanhMuc'] ?? '',
      ghiChu: json['ghiChu'],
    );
  }
}

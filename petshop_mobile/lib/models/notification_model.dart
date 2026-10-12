class NotificationModel {
  final int maThongBao;
  final String tieuDe;
  final String noiDung;
  final String loaiThongBao;
  final String ngayTao;
  final String? ngayHen;
  final String trangThai;
  final bool isRead;

  NotificationModel({
    required this.maThongBao,
    required this.tieuDe,
    required this.noiDung,
    required this.loaiThongBao,
    required this.ngayTao,
    this.ngayHen,
    required this.trangThai,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      maThongBao: json['maThongBao'] is int ? json['maThongBao'] : int.parse(json['maThongBao'].toString()),
      tieuDe: json['tieuDe'] ?? '',
      noiDung: json['noiDung'] ?? '',
      loaiThongBao: json['loaiThongBao'] ?? 'ThongBao',
      ngayTao: json['ngayTao'] ?? '',
      ngayHen: json['ngayHen'],
      trangThai: json['trangThai'] ?? 'Chưa đọc',
      isRead: json['isRead'] == true,
    );
  }
}

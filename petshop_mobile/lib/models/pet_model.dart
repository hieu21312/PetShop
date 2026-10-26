class PetModel {
  final int maThuCung;
  final int maChuNuoi;
  final String tenThuCung;
  final String loaiThuCung;
  final String? giongLoai;
  final String gioiTinh;
  final bool trietSan;
  final String? ngaySinh;
  final int? tuoiThang;
  final String? mauSac;
  final double? canNang;
  final String? dacDiemNhanDang;
  final String? soMicrochip;
  final String tinhTrangSucKhoeHienTai;
  final String? tienSuBenhLy;
  final String? diUngThuocThucAn;
  final String? lichSuTiemChung;
  final String? hinhAnh;
  final String trangThai;
  final String? ghiChu;
  final String? ngayTaoHoSo;

  PetModel({
    required this.maThuCung,
    required this.maChuNuoi,
    required this.tenThuCung,
    required this.loaiThuCung,
    this.giongLoai,
    this.gioiTinh = 'Đực',
    this.trietSan = false,
    this.ngaySinh,
    this.tuoiThang,
    this.mauSac,
    this.canNang,
    this.dacDiemNhanDang,
    this.soMicrochip,
    this.tinhTrangSucKhoeHienTai = 'Khỏe mạnh',
    this.tienSuBenhLy,
    this.diUngThuocThucAn,
    this.lichSuTiemChung,
    this.hinhAnh,
    this.trangThai = 'Đang nuôi',
    this.ghiChu,
    this.ngayTaoHoSo,
  });

  bool get isDog =>
      loaiThuCung.toLowerCase().contains('chó') ||
      loaiThuCung.toLowerCase().contains('cho') ||
      loaiThuCung.toLowerCase().contains('dog');

  bool get isCat =>
      loaiThuCung.toLowerCase().contains('mèo') ||
      loaiThuCung.toLowerCase().contains('meo') ||
      loaiThuCung.toLowerCase().contains('cat');

  String get speciesIcon => isDog ? '🐶' : (isCat ? '🐱' : '🐾');

  String get genderDisplay =>
      (gioiTinh.toLowerCase().contains('đực') || gioiTinh.toLowerCase().contains('duc'))
          ? '♂ Đực'
          : '♀ Cái';

  String get ageDisplay {
    if (tuoiThang != null && tuoiThang! > 0) {
      if (tuoiThang! >= 12) {
        final years = (tuoiThang! / 12).floor();
        final remMonths = tuoiThang! % 12;
        if (remMonths > 0) {
          return '$years tuổi $remMonths tháng';
        }
        return '$years tuổi';
      }
      return '$tuoiThang tháng';
    }
    if (ngaySinh != null && ngaySinh!.isNotEmpty) {
      try {
        final birthDate = DateTime.parse(ngaySinh!);
        final now = DateTime.now();
        final diffDays = now.difference(birthDate).inDays;
        final months = (diffDays / 30).floor();
        if (months >= 12) {
          return '${(months / 12).floor()} tuổi';
        }
        return '$months tháng';
      } catch (_) {}
    }
    return 'Chưa rõ';
  }

  String get weightDisplay => canNang != null ? '${canNang!.toStringAsFixed(1)} kg' : 'Chưa rõ';

  factory PetModel.fromJson(Map<String, dynamic> json) {
    int parsedId = 0;
    if (json['maThuCung'] != null) {
      parsedId = json['maThuCung'] is int
          ? json['maThuCung']
          : (int.tryParse(json['maThuCung'].toString()) ?? 0);
    }

    int parsedMaChuNuoi = 0;
    if (json['maChuNuoi'] != null) {
      parsedMaChuNuoi = json['maChuNuoi'] is int
          ? json['maChuNuoi']
          : (int.tryParse(json['maChuNuoi'].toString()) ?? 0);
    }

    double? parsedCanNang;
    if (json['canNang'] != null) {
      parsedCanNang = json['canNang'] is num
          ? (json['canNang'] as num).toDouble()
          : double.tryParse(json['canNang'].toString());
    }

    int? parsedTuoiThang;
    if (json['tuoiThang'] != null) {
      parsedTuoiThang = json['tuoiThang'] is int
          ? json['tuoiThang']
          : int.tryParse(json['tuoiThang'].toString());
    }

    bool parsedTrietSan = false;
    if (json['trietSan'] != null) {
      if (json['trietSan'] is bool) {
        parsedTrietSan = json['trietSan'];
      } else {
        parsedTrietSan = json['trietSan'].toString().toLowerCase() == 'true';
      }
    }

    return PetModel(
      maThuCung: parsedId,
      maChuNuoi: parsedMaChuNuoi,
      tenThuCung: json['tenThuCung'] ?? '',
      loaiThuCung: json['loaiThuCung'] ?? 'Chó',
      giongLoai: json['giongLoai'],
      gioiTinh: json['gioiTinh'] ?? 'Đực',
      trietSan: parsedTrietSan,
      ngaySinh: json['ngaySinh'],
      tuoiThang: parsedTuoiThang,
      mauSac: json['mauSac'],
      canNang: parsedCanNang,
      dacDiemNhanDang: json['dacDiemNhanDang'],
      soMicrochip: json['soMicrochip'],
      tinhTrangSucKhoeHienTai: json['tinhTrangSucKhoeHienTai'] ?? 'Khỏe mạnh',
      tienSuBenhLy: json['tienSuBenhLy'],
      diUngThuocThucAn: json['diUngThuocThucAn'],
      lichSuTiemChung: json['lichSuTiemChung'],
      hinhAnh: json['hinhAnh'],
      trangThai: json['trangThai'] ?? 'Đang nuôi',
      ghiChu: json['ghiChu'],
      ngayTaoHoSo: json['ngayTaoHoSo'],
    );
  }

  Map<String, dynamic> toJson({int? maKH}) {
    final map = <String, dynamic>{
      'tenThuCung': tenThuCung,
      'loaiThuCung': loaiThuCung,
      'giongLoai': giongLoai,
      'gioiTinh': gioiTinh,
      'trietSan': trietSan,
      'ngaySinh': ngaySinh,
      'tuoiThang': tuoiThang,
      'mauSac': mauSac,
      'canNang': canNang,
      'dacDiemNhanDang': dacDiemNhanDang,
      'soMicrochip': soMicrochip,
      'tinhTrangSucKhoeHienTai': tinhTrangSucKhoeHienTai,
      'tienSuBenhLy': tienSuBenhLy,
      'diUngThuocThucAn': diUngThuocThucAn,
      'lichSuTiemChung': lichSuTiemChung,
      'hinhAnh': hinhAnh,
      'trangThai': trangThai,
      'ghiChu': ghiChu,
    };
    if (maKH != null) map['maKH'] = maKH;
    return map;
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/pet_model.dart';
import '../services/api_service.dart';
import '../widgets/app_toast.dart';

class MyPetsScreen extends StatefulWidget {
  final UserModel currentUser;
  final Function(PetModel pet)? onSelectPetForBooking;
  final bool showAppBar;

  const MyPetsScreen({
    super.key,
    required this.currentUser,
    this.onSelectPetForBooking,
    this.showAppBar = true,
  });

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  List<PetModel> _pets = [];
  bool _isLoading = true;
  String _selectedFilter = 'all'; // 'all', 'cho', 'meo', 'khac'
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPets() async {
    if (widget.currentUser.maKH <= 0) {
      setState(() => _isLoading = false);
      return;
    }
    setState(() => _isLoading = true);
    final list = await ApiService.getMyPets(widget.currentUser.maKH);
    if (mounted) {
      setState(() {
        _pets = list;
        _isLoading = false;
      });
    }
  }

  List<PetModel> get _filteredPets {
    return _pets.where((p) {
      // Filter by type
      if (_selectedFilter == 'cho' && !p.isDog) return false;
      if (_selectedFilter == 'meo' && !p.isCat) return false;
      if (_selectedFilter == 'khac' && (p.isDog || p.isCat)) return false;

      // Filter by search
      final q = _searchController.text.trim().toLowerCase();
      if (q.isNotEmpty) {
        final matchName = p.tenThuCung.toLowerCase().contains(q);
        final matchBreed = (p.giongLoai ?? '').toLowerCase().contains(q);
        final matchColor = (p.mauSac ?? '').toLowerCase().contains(q);
        if (!matchName && !matchBreed && !matchColor) return false;
      }
      return true;
    }).toList();
  }

  void _showAddEditPetSheet({PetModel? petToEdit}) {
    final isEditing = petToEdit != null;
    final nameCtrl = TextEditingController(text: petToEdit?.tenThuCung ?? '');
    String selectedLoai = petToEdit?.loaiThuCung ?? 'Chó';
    final breedCtrl = TextEditingController(text: petToEdit?.giongLoai ?? '');
    String selectedGender = petToEdit?.gioiTinh ?? 'Đực';
    bool trietSan = petToEdit?.trietSan ?? false;
    final weightCtrl = TextEditingController(text: petToEdit?.canNang?.toString() ?? '');
    final ageMonthsCtrl = TextEditingController(text: petToEdit?.tuoiThang?.toString() ?? '');
    final colorCtrl = TextEditingController(text: petToEdit?.mauSac ?? '');
    String healthStatus = petToEdit?.tinhTrangSucKhoeHienTai ?? 'Khỏe mạnh';
    final medicalCtrl = TextEditingController(text: petToEdit?.tienSuBenhLy ?? '');
    final allergyCtrl = TextEditingController(text: petToEdit?.diUngThuocThucAn ?? '');
    final vaccineCtrl = TextEditingController(text: petToEdit?.lichSuTiemChung ?? '');
    final noteCtrl = TextEditingController(text: petToEdit?.ghiChu ?? petToEdit?.dacDiemNhanDang ?? '');
    DateTime? birthDate = (petToEdit?.ngaySinh != null && petToEdit!.ngaySinh!.isNotEmpty)
        ? DateTime.tryParse(petToEdit.ngaySinh!)
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE4EC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.pets, color: Color(0xFFE91E63), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              isEditing ? 'Chỉnh sửa hồ sơ bé cưng' : 'Thêm hồ sơ bé cưng mới',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),

                  // Body form
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 16,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tên thú cưng
                          const Text('Tên thú cưng *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: nameCtrl,
                            decoration: InputDecoration(
                              hintText: 'Ví dụ: Lu Lu, Miu Miu, Cún...',
                              prefixIcon: const Icon(Icons.badge, color: Color(0xFFE91E63)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Loài thú cưng
                          const Text('Loài thú cưng *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          Row(
                            children: ['Chó', 'Mèo', 'Thú cưng khác'].map((type) {
                              final isSelected = selectedLoai == type;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: ChoiceChip(
                                    label: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(type == 'Chó' ? '🐶' : (type == 'Mèo' ? '🐱' : '🐾')),
                                        const SizedBox(width: 4),
                                        Text(type, style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.black87,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          fontSize: 12,
                                        )),
                                      ],
                                    ),
                                    selected: isSelected,
                                    selectedColor: const Color(0xFFE91E63),
                                    backgroundColor: Colors.grey.shade100,
                                    onSelected: (val) {
                                      if (val) setSheetState(() => selectedLoai = type);
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // Giống loài
                          const Text('Giống loài', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: breedCtrl,
                            decoration: InputDecoration(
                              hintText: selectedLoai == 'Chó' ? 'Ví dụ: Poodle, Corgi, Husky...' : (selectedLoai == 'Mèo' ? 'Ví dụ: Mèo Anh, Ba Tư, Xiêm...' : 'Ví dụ: Hamster, Thỏ...'),
                              prefixIcon: const Icon(Icons.category, color: Colors.orange),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Giới tính & Triệt sản
                          Row(
                            children: [
                              // Giới tính
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Giới tính', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: ['Đực', 'Cái'].map((g) {
                                        final isSel = selectedGender == g;
                                        return Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 4),
                                            child: ChoiceChip(
                                              label: Text(g == 'Đực' ? '♂ Đực' : '♀ Cái', style: TextStyle(
                                                color: isSel ? Colors.white : Colors.black87,
                                                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                              )),
                                              selected: isSel,
                                              selectedColor: g == 'Đực' ? Colors.blue : Colors.pink,
                                              backgroundColor: Colors.grey.shade100,
                                              onSelected: (val) {
                                                if (val) setSheetState(() => selectedGender = g);
                                              },
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Triệt sản
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Triệt sản', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(height: 6),
                                    InkWell(
                                      onTap: () => setSheetState(() => trietSan = !trietSan),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: trietSan ? Colors.teal : Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(12),
                                          color: trietSan ? Colors.teal.shade50 : Colors.transparent,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(trietSan ? Icons.check_circle : Icons.radio_button_unchecked,
                                                color: trietSan ? Colors.teal : Colors.grey, size: 20),
                                            const SizedBox(width: 6),
                                            Text(trietSan ? 'Đã triệt sản' : 'Chưa triệt sản',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: trietSan ? FontWeight.bold : FontWeight.normal,
                                                  color: trietSan ? Colors.teal : Colors.black87,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Cân nặng & Tuổi
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Cân nặng (kg)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(height: 6),
                                    TextField(
                                      controller: weightCtrl,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        hintText: 'Ví dụ: 4.5',
                                        prefixIcon: const Icon(Icons.scale, color: Colors.blueGrey),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Tuổi (tháng)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(height: 6),
                                    TextField(
                                      controller: ageMonthsCtrl,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Ví dụ: 12',
                                        prefixIcon: const Icon(Icons.cake, color: Colors.purple),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Màu lông & Ngày sinh
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Màu sắc / Màu lông', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(height: 6),
                                    TextField(
                                      controller: colorCtrl,
                                      decoration: InputDecoration(
                                        hintText: 'Ví dụ: Trắng kem, Vàng...',
                                        prefixIcon: const Icon(Icons.color_lens, color: Colors.teal),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Ngày sinh (nếu biết)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(height: 6),
                                    InkWell(
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: birthDate ?? DateTime.now().subtract(const Duration(days: 365)),
                                          firstDate: DateTime(2010),
                                          lastDate: DateTime.now(),
                                        );
                                        if (picked != null) {
                                          setSheetState(() => birthDate = picked);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade400),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                                            const SizedBox(width: 8),
                                            Text(
                                              birthDate != null ? DateFormat('dd/MM/yyyy').format(birthDate!) : 'Chọn ngày',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: birthDate != null ? Colors.black87 : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Tình trạng sức khỏe
                          const Text('Tình trạng sức khỏe hiện tại', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            children: ['Khỏe mạnh', 'Đang theo dõi', 'Cần chăm sóc đặc biệt', 'Sau phẫu thuật'].map((st) {
                              final isSel = healthStatus == st;
                              return ChoiceChip(
                                label: Text(st, style: TextStyle(
                                  color: isSel ? Colors.white : Colors.black87,
                                  fontSize: 12,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                )),
                                selected: isSel,
                                selectedColor: st == 'Khỏe mạnh' ? Colors.green : (st == 'Đang theo dõi' ? Colors.amber.shade800 : Colors.red),
                                backgroundColor: Colors.grey.shade100,
                                onSelected: (val) {
                                  if (val) setSheetState(() => healthStatus = st);
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // Tiêm chủng
                          const Text('Lịch sử tiêm chủng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: vaccineCtrl,
                            decoration: InputDecoration(
                              hintText: 'Ví dụ: Đã tiêm 7 bệnh, dại (08/2026)...',
                              prefixIcon: const Icon(Icons.vaccines, color: Colors.green),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Dị ứng / Tiền sử bệnh
                          const Text('Dị ứng thức ăn / thuốc', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: allergyCtrl,
                            decoration: InputDecoration(
                              hintText: 'Ví dụ: Dị ứng thịt gà, dị ứng sữa...',
                              prefixIcon: const Icon(Icons.warning_amber, color: Colors.redAccent),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tiền sử bệnh lý
                          const Text('Tiền sử bệnh lý', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: medicalCtrl,
                            decoration: InputDecoration(
                              hintText: 'Ví dụ: Từng bị nấm da, viêm tai...',
                              prefixIcon: const Icon(Icons.healing, color: Colors.indigo),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Ghi chú & Đặc điểm nhận dạng
                          const Text('Ghi chú / Đặc điểm nhận dạng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: noteCtrl,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Ví dụ: Đốm trắng ở ngực, sợ tiếng sấm sét...',
                              prefixIcon: const Icon(Icons.notes, color: Colors.grey),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE91E63),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: () async {
                                final name = nameCtrl.text.trim();
                                if (name.isEmpty) {
                                  AppToast.show(context, message: 'Vui lòng nhập tên bé cưng!');
                                  return;
                                }

                                final petData = <String, dynamic>{
                                  'tenThuCung': name,
                                  'loaiThuCung': selectedLoai,
                                  'giongLoai': breedCtrl.text.trim(),
                                  'gioiTinh': selectedGender,
                                  'trietSan': trietSan,
                                  'tinhTrangSucKhoeHienTai': healthStatus,
                                  'mauSac': colorCtrl.text.trim(),
                                  'lichSuTiemChung': vaccineCtrl.text.trim(),
                                  'diUngThuocThucAn': allergyCtrl.text.trim(),
                                  'tienSuBenhLy': medicalCtrl.text.trim(),
                                  'ghiChu': noteCtrl.text.trim(),
                                  'dacDiemNhanDang': noteCtrl.text.trim(),
                                };

                                if (weightCtrl.text.trim().isNotEmpty) {
                                  final w = double.tryParse(weightCtrl.text.trim());
                                  if (w != null) petData['canNang'] = w;
                                }

                                if (ageMonthsCtrl.text.trim().isNotEmpty) {
                                  final a = int.tryParse(ageMonthsCtrl.text.trim());
                                  if (a != null) petData['tuoiThang'] = a;
                                }

                                if (birthDate != null) {
                                  petData['ngaySinh'] = DateFormat('yyyy-MM-dd').format(birthDate!);
                                }

                                Navigator.pop(ctx);

                                if (isEditing) {
                                  final res = await ApiService.updatePet(petToEdit.maThuCung, petData);
                                  if (res['success'] == true) {
                                    if (mounted) AppToast.show(context, message: 'Cập nhật thông tin bé cưng thành công!');
                                    _loadPets();
                                  } else {
                                    if (mounted) AppToast.show(context, message: res['message'] ?? 'Lỗi cập nhật');
                                  }
                                } else {
                                  final res = await ApiService.createPet(widget.currentUser.maKH, petData);
                                  if (res['success'] == true) {
                                    if (mounted) AppToast.show(context, message: 'Thêm hồ sơ bé cưng thành công!');
                                    _loadPets();
                                  } else {
                                    if (mounted) AppToast.show(context, message: res['message'] ?? 'Lỗi thêm mới');
                                  }
                                }
                              },
                              icon: Icon(isEditing ? Icons.save : Icons.add),
                              label: Text(
                                isEditing ? 'LƯU THAY ĐỔI' : 'TẠO HỒ SƠ BÉ CƯNG',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleSelectPetForBooking(PetModel pet) {
    if (widget.onSelectPetForBooking != null) {
      widget.onSelectPetForBooking!(pet);
      // Chỉ pop nếu màn hình này được mở dạng trang riêng (showAppBar == true)
      if (widget.showAppBar && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context, pet);
      }
    }
  }

  void _showPetDetailModal(PetModel pet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Header Card with Gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: pet.isDog
                        ? [const Color(0xFFFF8A65), const Color(0xFFFF7043)]
                        : pet.isCat
                            ? [const Color(0xFFBA68C8), const Color(0xFF8E24AA)]
                            : [const Color(0xFF4DB6AC), const Color(0xFF00897B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Mã HS: #${pet.maThuCung}',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        pet.speciesIcon,
                        style: const TextStyle(fontSize: 42),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      pet.tenThuCung,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.loaiThuCung} • ${pet.giongLoai != null && pet.giongLoai!.isNotEmpty ? pet.giongLoai : "Giống hỗn hợp"}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Detail content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Quick info grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(Icons.male, 'Giới tính', pet.genderDisplay, Colors.blue),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildInfoItem(Icons.cake, 'Tuổi', pet.ageDisplay, Colors.purple),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildInfoItem(Icons.scale, 'Cân nặng', pet.weightDisplay, Colors.teal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Card: Sức khỏe & Y tế
                      Card(
                        elevation: 0,
                        color: Colors.grey.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.health_and_safety, color: Colors.green, size: 20),
                                  SizedBox(width: 8),
                                  Text('Hồ sơ sức khỏe & Y tế', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ],
                              ),
                              const Divider(height: 20),
                              _buildDetailRow('Tình trạng', pet.tinhTrangSucKhoeHienTai, isStatus: true),
                              _buildDetailRow('Triệt sản', pet.trietSan ? 'Đã triệt sản' : 'Chưa triệt sản'),
                              _buildDetailRow('Màu lông', pet.mauSac ?? 'Chưa rõ'),
                              _buildDetailRow('Tiêm chủng', pet.lichSuTiemChung ?? 'Chưa có thông tin'),
                              _buildDetailRow('Dị ứng', pet.diUngThuocThucAn ?? 'Không có'),
                              _buildDetailRow('Tiền sử bệnh', pet.tienSuBenhLy ?? 'Không có'),
                              if (pet.ghiChu != null && pet.ghiChu!.isNotEmpty)
                                _buildDetailRow('Ghi chú', pet.ghiChu!),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFE91E63),
                                side: const BorderSide(color: Color(0xFFE91E63)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                Navigator.pop(ctx);
                                _showAddEditPetSheet(petToEdit: pet);
                              },
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text('Chỉnh sửa'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE91E63),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                Navigator.pop(ctx);
                                _handleSelectPetForBooking(pet);
                              },
                              icon: const Icon(Icons.calendar_month, size: 18),
                              label: const Text('Đặt lịch bé này'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ),
          Expanded(
            child: isStatus
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: value == 'Khỏe mạnh' ? Colors.green.shade50 : Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        value,
                        style: TextStyle(
                          color: value == 'Khỏe mạnh' ? Colors.green.shade800 : Colors.amber.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                : Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  void _confirmDeletePet(PetModel pet) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.delete_outline, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Xác nhận xóa'),
          ],
        ),
        content: Text('Bạn có chắc muốn xóa hồ sơ bé "${pet.tenThuCung}" không? Thao tác này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final res = await ApiService.deletePet(pet.maThuCung, widget.currentUser.maKH);
              if (res['success'] == true) {
                if (mounted) AppToast.show(context, message: 'Đã xóa hồ sơ bé cưng!');
                _loadPets();
              } else {
                if (mounted) AppToast.show(context, message: res['message'] ?? 'Lỗi khi xóa');
              }
            },
            child: const Text('Xóa ngay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredPets;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Hồ sơ thú cưng của tôi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0.5,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Tải lại',
                  onPressed: _loadPets,
                ),
              ],
            )
          : null,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Thêm bé cưng', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => _showAddEditPetSheet(),
      ),
      body: Column(
        children: [
          // Search & Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Tìm theo tên, giống loài, màu lông...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFE91E63)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Species Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', '🐾 Tất cả (${_pets.length})'),
                      _buildFilterChip('cho', '🐶 Chó (${_pets.where((p) => p.isDog).length})'),
                      _buildFilterChip('meo', '🐱 Mèo (${_pets.where((p) => p.isCat).length})'),
                      _buildFilterChip('khac', '🐰 Khác (${_pets.where((p) => !p.isDog && !p.isCat).length})'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Pet List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
                : filtered.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        color: const Color(0xFFE91E63),
                        onRefresh: _loadPets,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 14),
                          itemBuilder: (ctx, idx) => _buildPetCard(filtered[idx]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSel = _selectedFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSel,
        selectedColor: const Color(0xFFFCE4EC),
        checkmarkColor: const Color(0xFFE91E63),
        labelStyle: TextStyle(
          color: isSel ? const Color(0xFFE91E63) : Colors.black87,
          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSel ? const Color(0xFFE91E63) : Colors.transparent),
        ),
        onSelected: (val) {
          if (val) setState(() => _selectedFilter = key);
        },
      ),
    );
  }

  Widget _buildPetCard(PetModel pet) {
    final isDog = pet.isDog;
    final isCat = pet.isCat;
    final primaryColor = isDog
        ? const Color(0xFFFF7043)
        : isCat
            ? const Color(0xFFAB47BC)
            : const Color(0xFF26A69A);

    return InkWell(
      onTap: () => _showPetDetailModal(pet),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor.withValues(alpha: 0.2), primaryColor.withValues(alpha: 0.05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      pet.speciesIcon,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pet.tenThuCung,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: pet.tinhTrangSucKhoeHienTai == 'Khỏe mạnh'
                                    ? Colors.green.shade50
                                    : Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                pet.tinhTrangSucKhoeHienTai,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: pet.tinhTrangSucKhoeHienTai == 'Khỏe mạnh'
                                      ? Colors.green.shade800
                                      : Colors.amber.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pet.loaiThuCung} • ${pet.giongLoai != null && pet.giongLoai!.isNotEmpty ? pet.giongLoai : "Giống hỗn hợp"}',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                        const SizedBox(height: 8),

                        // Tags
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _buildPetTag(pet.genderDisplay, Colors.blue),
                            _buildPetTag(pet.ageDisplay, Colors.purple),
                            _buildPetTag(pet.weightDisplay, Colors.teal),
                            if (pet.trietSan) _buildPetTag('Đã triệt sản', Colors.green),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),

              // Bottom card buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFE91E63),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () {
                      _handleSelectPetForBooking(pet);
                    },
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: const Text('Đặt dịch vụ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.info_outline, size: 20, color: Colors.blueGrey),
                        tooltip: 'Chi tiết hồ sơ',
                        onPressed: () => _showPetDetailModal(pet),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blue),
                        tooltip: 'Chỉnh sửa',
                        onPressed: () => _showAddEditPetSheet(petToEdit: pet),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        tooltip: 'Xóa hồ sơ',
                        onPressed: () => _confirmDeletePet(pet),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.pets, size: 64, color: Color(0xFFE91E63)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Chưa có hồ sơ thú cưng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy thêm bé cưng của bạn để quản lý lịch tiêm phòng, theo dõi sức khỏe và đặt lịch chăm sóc dễ dàng hơn!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => _showAddEditPetSheet(),
              icon: const Icon(Icons.add),
              label: const Text('Thêm bé cưng ngay', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

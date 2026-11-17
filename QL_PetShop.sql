IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'QL_PetShop')
BEGIN
    CREATE DATABASE [QL_PetShop]
END
GO

USE [QL_PetShop]
GO


/****** Object:  Table [dbo].[tblDanhMuc] ******/
CREATE TABLE [dbo].[tblDanhMuc](
    [MaDanhMuc] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TenDanhMuc] [nvarchar](100) NULL, -- Ví dụ: 'Chó', 'Mèo', 'Thức ăn', 'Phụ kiện'
    [GhiChu] [nvarchar](255) NULL
)
GO

/****** Object:  Table [dbo].[tblNhaCungCap] ******/
CREATE TABLE [dbo].[tblNhaCungCap](
    [MaNCC] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TenNCC] [nvarchar](100) NULL, -- Tên trại giống hoặc nhà phân phối
    [DiaChi] [nvarchar](255) NULL,
    [DienThoai] [nvarchar](20) NULL
)
GO

/****** Object:  Table [dbo].[tblSanPham] ******/
CREATE TABLE [dbo].[tblSanPham](
    [MaSP] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TenSP] [nvarchar](200) NULL,
    -- Phân biệt sản phẩm là Pet hay Phụ kiện
    [LoaiSanPham] [nvarchar](50) NULL, -- 'Pet' hoặc 'Accessory'
    -- Thông tin dành cho PET
    [GioiTinh] [nvarchar](10) NULL,
    [NgaySinh] [date] NULL,
    [MauSac] [nvarchar](50) NULL,
    [TinhTrangSucKhoe] [nvarchar](max) NULL,
    [TienSuBenh] [nvarchar](max) NULL,
    -- Thông tin chung
    [MoTa] [nvarchar](max) NULL,
    [GiaBan] [decimal](18, 2) NULL,
    [AnhDaiDien] [nvarchar](255) NULL,
    [MaDanhMuc] [int] NULL, -- FK đến Danh mục (Ví dụ: Chó Alaska, Thức ăn khô)
    [MaNCC] [int] NULL, -- FK đến Nhà cung cấp (Trại giống, công ty...)
    CONSTRAINT [FK_tblSanPham_tblDanhMuc] FOREIGN KEY([MaDanhMuc]) REFERENCES [dbo].[tblDanhMuc] ([MaDanhMuc]),
    CONSTRAINT [FK_tblSanPham_tblNhaCungCap] FOREIGN KEY([MaNCC]) REFERENCES [dbo].[tblNhaCungCap] ([MaNCC])
)
GO

/****** Object:  Table [dbo].[tblTonKho] ******/
CREATE TABLE [dbo].[tblTonKho](
    [MaSP] [int] NOT NULL PRIMARY KEY,
    [SoLuongTon] [int] NULL, -- Áp dụng cho Phụ kiện, Thức ăn (có thể >1)
    [TrangThai] [nvarchar](50) NULL, -- Áp dụng cho PET: 'Con', 'Đã bán', 'Đặt trước', 'Đang chăm sóc'
    CONSTRAINT [FK_tblTonKho_tblSanPham] FOREIGN KEY([MaSP]) REFERENCES [dbo].[tblSanPham] ([MaSP])
)
GO

/****** Object:  Table [dbo].[tblKhachHang] ******/
CREATE TABLE [dbo].[tblKhachHang](
    [MaKH] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TenKH] [nvarchar](100) NULL,
    [MatKhau] [nvarchar](100) NULL,
    [GioiTinh] [nvarchar](10) NULL,
    [NamSinh] [int] NULL,
    [Avarta] [nvarchar](255) NULL,
    [DienThoai] [nvarchar](20) NULL,
    [Email] [nvarchar](100) NULL,
    [DiaChi] [nvarchar](255) NULL
)
GO

/****** Object:  Table [dbo].[tblVaiTro] ******/
CREATE TABLE [dbo].[tblVaiTro](
    [IDVaiTro] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TenVaiTro] [nvarchar](50) NULL, -- 'Admin', 'Nhân viên', 'Bác sĩ thú y'
    [MoTa] [nvarchar](255) NULL
)
GO

/****** Object:  Table [dbo].[tblNhanVien] ******/
CREATE TABLE [dbo].[tblNhanVien](
    [MaNV] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MatKhau] [nvarchar](100) NULL,
    [TenNV] [nvarchar](100) NULL,
    [GioiTinh] [nvarchar](10) NULL,
    [NamSinh] [int] NULL,
    [VaiTro] [int] NULL,
    [DienThoai] [nvarchar](20) NULL,
    [Email] [nvarchar](100) NULL,
    [ChuyenMon] [nvarchar](255) NULL, -- 'Bác sĩ sản khoa/phẫu thuật', 'Cắt tỉa & Spa chuyên nghiệp'
    [AnhDaiDien] [nvarchar](255) NULL,
    [TrangThai] [nvarchar](50) NULL DEFAULT N'Đang làm việc', -- 'Đang làm việc', 'Tạm nghỉ'
    CONSTRAINT [FK_tblNhanVien_tblVaiTro] FOREIGN KEY([VaiTro]) REFERENCES [dbo].[tblVaiTro] ([IDVaiTro])
)
GO

/****** Object:  Table [dbo].[tblTinhTrang] ******/
CREATE TABLE [dbo].[tblTinhTrang](
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TinhTrangDonHang] [nvarchar](50) NULL -- 'Đang xử lý', 'Đã xác nhận', 'Đang giao', 'Hoàn thành', 'Đã hủy'
)
GO

/****** Object:  Table [dbo].[tblMaGiamGia] ******/
CREATE TABLE [dbo].[tblMaGiamGia](
    [MaGiamGia] [nvarchar](50) NOT NULL PRIMARY KEY, -- Ví dụ: 'SALE10'
    [PhanTramGiam] [decimal](5, 2) NULL, -- 10.00 có nghĩa là 10%
    [SoTienGiamToiDa] [decimal](18, 2) NULL,
    [NgayBatDau] [datetime] NULL,
    [NgayKetThuc] [datetime] NULL,
    [SoLuong] [int] NULL -- Số lượt sử dụng tối đa
)
GO
/****** Object:  Table [dbo].[tblHoaDon] ******/
CREATE TABLE [dbo].[tblHoaDon](
    [MaHD] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaKH] [int] NULL,
    [MaNV] [int] NULL,
    [NgayLap] [datetime] NULL,
    [TongTien] [decimal](18, 2) NULL,
    [TinhTrang] [int] NULL, -- FK đến Tình trạng đơn hàng
    [DiaChiGiaoHang] [nvarchar](255) NULL,
    [DaThanhToan] [bit] NULL,
    [MaGiamGia] [nvarchar](50) NULL, -- Áp mã giảm giá
    [TienGiam] [decimal](18, 2) NULL, -- Số tiền được giảm thực tế
    CONSTRAINT [FK_tblHoaDon_tblKhachHang] FOREIGN KEY([MaKH]) REFERENCES [dbo].[tblKhachHang] ([MaKH]),
    CONSTRAINT [FK_tblHoaDon_tblNhanVien] FOREIGN KEY([MaNV]) REFERENCES [dbo].[tblNhanVien] ([MaNV]),
    CONSTRAINT [FK_tblHoaDon_tblTinhTrang] FOREIGN KEY([TinhTrang]) REFERENCES [dbo].[tblTinhTrang] ([ID]),
    CONSTRAINT [FK_tblHoaDon_tblMaGiamGia] FOREIGN KEY([MaGiamGia]) REFERENCES [dbo].[tblMaGiamGia] ([MaGiamGia])
)
GO

/****** Object:  Table [dbo].[tblChiTietHoaDon] ******/
CREATE TABLE [dbo].[tblChiTietHoaDon](
    [MaHD] [int] NOT NULL,
    [MaSP] [int] NOT NULL,
    [SoLuong] [int] NULL,
    [GiaBan] [decimal](18, 2) NULL,
    PRIMARY KEY CLUSTERED ([MaHD] ASC, [MaSP] ASC),
    CONSTRAINT [FK_tblChiTietHoaDon_tblHoaDon] FOREIGN KEY([MaHD]) REFERENCES [dbo].[tblHoaDon] ([MaHD]),
    CONSTRAINT [FK_tblChiTietHoaDon_tblSanPham] FOREIGN KEY([MaSP]) REFERENCES [dbo].[tblSanPham] ([MaSP])
)
GO

/****** Object:  Table [dbo].[tblDichVu] ******/
CREATE TABLE [dbo].[tblDichVu](
    [MaDV] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TenDV] [nvarchar](200) NULL, -- 'Tắm gội', 'Khám bệnh', 'Cắt tỉa lông'
    [MoTa] [nvarchar](max) NULL,
    [GiaDichVu] [decimal](18, 2) NULL,
    [HinhAnh] [nvarchar](255) NULL
)
GO

/****** Object:  Table [dbo].[tblHoaDonDichVu] ******/
CREATE TABLE [dbo].[tblHoaDonDichVu](
    [MaHDDV] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaKH] [int] NULL,
    [MaNV] [int] NULL,
    [NgaySuDung] [datetime] NULL,
    [TongTien] [decimal](18, 2) NULL,
    [GhiChu] [nvarchar](500) NULL,
    CONSTRAINT [FK_tblHoaDonDichVu_tblKhachHang] FOREIGN KEY([MaKH]) REFERENCES [dbo].[tblKhachHang] ([MaKH]),
    CONSTRAINT [FK_tblHoaDonDichVu_tblNhanVien] FOREIGN KEY([MaNV]) REFERENCES [dbo].[tblNhanVien] ([MaNV])
)
GO

/****** Object:  Table [dbo].[tblChiTietHoaDonDichVu] ******/
CREATE TABLE [dbo].[tblChiTietHoaDonDichVu](
    [MaHDDV] [int] NOT NULL,
    [MaDV] [int] NOT NULL,
    [SoLuong] [int] NULL,
    [GiaDichVu] [decimal](18, 2) NULL,
    PRIMARY KEY CLUSTERED ([MaHDDV] ASC, [MaDV] ASC),
    CONSTRAINT [FK_tblChiTietHoaDonDichVu_tblHoaDonDichVu] FOREIGN KEY([MaHDDV]) REFERENCES [dbo].[tblHoaDonDichVu] ([MaHDDV]),
    CONSTRAINT [FK_tblChiTietHoaDonDichVu_tblDichVu] FOREIGN KEY([MaDV]) REFERENCES [dbo].[tblDichVu] ([MaDV])
)
GO

/****** Object:  Table [dbo].[tblHinhAnh] ******/
CREATE TABLE [dbo].[tblHinhAnh](
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaSP] [int] NULL,
    [HinhAnh] [nvarchar](255) NULL, -- URL hoặc tên file ảnh
    CONSTRAINT [FK_tblHinhAnh_tblSanPham] FOREIGN KEY([MaSP]) REFERENCES [dbo].[tblSanPham] ([MaSP])
)
GO

/****** Object:  Table [dbo].[tblBinhLuan] ******/
CREATE TABLE [dbo].[tblBinhLuan](
    [Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaSP] [int] NOT NULL,
    [HoTen] [nvarchar](100) NOT NULL,
    [NoiDung] [nvarchar](500) NOT NULL,
    [SoSao] [int] NOT NULL,
    [Ngay] [datetime] NOT NULL,
    CONSTRAINT [FK_tblBinhLuan_tblSanPham] FOREIGN KEY([MaSP]) REFERENCES [dbo].[tblSanPham] ([MaSP])
)
GO

INSERT INTO [dbo].[tblDanhMuc] ([TenDanhMuc], [GhiChu]) VALUES
(N'Chó cảnh', N'Các giống chó phổ biến như Poodle, Corgi, Alaska'),
(N'Mèo cảnh', N'Các giống mèo như Anh lông ngắn, Ba Tư, Munchkin'),
(N'Thức ăn cho chó', N'Thức ăn khô và ướt dành cho chó'),
(N'Thức ăn cho mèo', N'Thức ăn khô, pate dành cho mèo'),
(N'Phụ kiện thú cưng', N'Dây dắt, quần áo, chuồng, ổ nệm'),
(N'Sản phẩm chăm sóc', N'Dầu tắm, sữa tắm, nước hoa cho thú cưng'),
(N'Đồ chơi thú cưng', N'Bóng, gặm nhai, chuột giả cho mèo'),
(N'Dụng cụ vệ sinh', N'Khay cát, túi đựng phân, bàn chải'),
(N'Thuốc & vitamin', N'Thuốc tẩy giun, vitamin cho thú cưng'),
(N'Dịch vụ thú y', N'Tắm, khám, tiêm phòng, chăm sóc'),
(N'Bảo hiểm thú cưng', N'Gói bảo hiểm sức khỏe và tai nạn cho thú cưng');
GO

INSERT INTO [dbo].[tblNhaCungCap] ([TenNCC], [DiaChi], [DienThoai]) VALUES
(N'Trại giống Su Poodle', N'An Lạc A,Bình Tân, TP.HCM', N'0988934057'),
(N'Công ty PetPro', N'Quận 3, TP.HCM', N'070269862'),
(N'Trại giống Corgi SG', N'Thủ Đức, TP.HCM', N'0389343941'),
(N'Cửa hàng CutePet', N'Cầu Giấy,Hà Nội', N'0374493142'),
(N'Công ty VitaPet', N'Sơn Trà,Đà Nẵng', N'0848694473'),
(N'Trại giống Alaska Hà Nội', N'Ba Đình,Hà Nội', N'0359393975'),
(N'Shop Phụ kiện PetClub', N'Ninh Kiều,Cần Thơ', N'02303996984'),
(N'Sun Pet- Spa Thú Cưng', N'Quận 7,TP.HCM', N'0345870492'),
(N'Công ty PetLove', N'Phù Cát,Huế', N'0910234567'),
(N'Trại chó giống Thành Đạt', N'123 Nguyễn Văn Linh, Quận 7, TP.HCM', N'0909123456'),
(N'Trại mèo cảnh Meow House', N'45 Lê Lợi, Quận 1, TP.HCM', N'0911222333'),
(N'Công ty TNHH PetFood VN', N'Khu công nghiệp Biên Hòa, Đồng Nai', N'0251384567'),
(N'Trại chó Alaska Siberian', N'78 Nguyễn Thị Minh Khai, Quận 3, TP.HCM', N'0987654321'),
(N'Shop phụ kiện PetShop24h', N'255 Cách Mạng Tháng 8, Quận 10, TP.HCM', N'0283865432'),
(N'Trại mèo Anh lông ngắn Royal', N'12 Phạm Văn Đồng, Thủ Đức, TP.HCM', N'0933111222'),
(N'Nhập khẩu thức ăn PetKing', N'Lô A12 Khu chế xuất Tân Thuận, TP.HCM', N'0283999888'),
(N'Trại chó Poodle Tiny', N'56 Võ Văn Ngân, Thủ Đức, TP.HCM', N'0977123456'),
(N'Cửa hàng đồ chơi PetFun', N'89 Lê Văn Việt, Quận 9, TP.HCM', N'0918877665'),
(N'Trại chó Phú Quốc thuần chủng', N'Đảo Phú Quốc, Kiên Giang', N'0297384765'),
(N'Trại giống Golden Pet', N'Long Biên, Hà Nội', N'0901122334'),
(N'Cửa hàng PetZone', N'Nguyễn Trãi, Thanh Xuân, Hà Nội', N'0912233445'),
(N'Công ty TNHH PetCare', N'Nguyễn Văn Linh, Đà Nẵng', N'0923344556'),
(N'Trại giống Mèo Anh', N'Tân Phú, TP.HCM', N'0934455667'),
(N'PetMart Việt Nam', N'Nguyễn Thị Minh Khai, TP.HCM', N'0945566778'),
(N'Cửa hàng Thú Cưng HappyPet', N'Lê Hồng Phong, Hải Phòng', N'0956677889'),
(N'Công ty TNHH PetXinh', N'Bình Thạnh, TP.HCM', N'0967788990'),
(N'Trại giống Husky Bắc Cực', N'Buôn Ma Thuột, Đắk Lắk', N'0978899001'),
(N'Cửa hàng PetHouse', N'Nguyễn Văn Cừ, Cần Thơ', N'0989900112'),
(N'Công ty TNHH PetWorld', N'Thanh Khê, Đà Nẵng', N'0990011223');
GO

INSERT INTO [dbo].[tblVaiTro] ([TenVaiTro], [MoTa]) VALUES
(N'Admin', N'Quản trị toàn bộ hệ thống PetShop'),
(N'Quản lý cửa hàng', N'Giám sát hoạt động kinh doanh, điều phối nhân sự và vận hành cửa hàng'),
(N'Bác sĩ thú y', N'Khám chữa bệnh, tiêm phòng, phẫu thuật và chăm sóc y tế thú cưng'),
(N'Nhân viên chăm sóc', N'Tắm spa, cắt tỉa lông (grooming), vệ sinh móng tai và chăm sóc lưu trú'),
(N'Thu ngân', N'Thu ngân quầy POS, tiếp nhận phiếu dịch vụ, áp dụng voucher & xuất hóa đơn'),
(N'Thủ kho', N'Quản lý kho hàng, nhập xuất vật tư, kiểm kê sản phẩm & thuốc thú y');
GO

INSERT INTO [dbo].[tblNhanVien] ([MatKhau], [TenNV], [GioiTinh], [NamSinh], [VaiTro], [DienThoai], [Email], [ChuyenMon]) VALUES
(N'123456', N'Phan Thị Thắng', N'Nam', 1990, 1, N'0901234001', N'thang.pt@petshop.vn', N'Quản trị toàn diện hệ thống & Điều hành PetShop'),
(N'123456', N'Nguyễn Khánh Quỳnh Hoa', N'Nữ', 1998, 5, N'0901234002', N'hoa.nkq@petshop.vn', N'Thu ngân trưởng quầy POS, Tiếp nhận phiếu dịch vụ & Xuất hóa đơn'),
(N'123456', N'Phạm An Thành', N'Nam', 1988, 3, N'0901234003', N'thanh.pa@petshop.vn', N'Bác sĩ thú y trưởng, Khám chẩn đoán, Triệt sản & Phẫu thuật mô mềm'),
(N'123456', N'Nguyễn Thị Huệ', N'Nữ', 1996, 5, N'0901234004', N'hue.nt@petshop.vn', N'Thu ngân quầy POS ca chiều, Tiếp nhận khách & Thanh toán hóa đơn'),
(N'123456', N'Hoàng Nam Quang', N'Nam', 1997, 6, N'0901234005', N'quang.hn@petshop.vn', N'Thủ kho chính, Quản lý xuất nhập tồn & Kiểm soát hạn dùng sản phẩm'),
(N'123456', N'Huỳnh Thị Ngọc Tú', N'Nữ', 1999, 6, N'0901234006', N'tu.htn@petshop.vn', N'Thủ kho, Quản lý kho thức ăn hạt, Pate & Phụ kiện thú cưng'),
(N'123456', N'Bùi Ngọc Thúy', N'Nữ', 1995, 4, N'0901234007', N'thuy.bn@petshop.vn', N'Chuyên viên Spa, Cắt tỉa tạo kiểu lông nghệ thuật & Grooming thú cưng'),
(N'123456', N'Lê Văn Minh', N'Nam', 1998, 4, N'0901234008', N'minh.lv@petshop.vn', N'Nhân viên chăm sóc, Tắm sấy khử mùi, Cạo lông móng & Vệ sinh tai'),
(N'123456', N'Trần Thị Mỹ Duyên', N'Nữ', 1997, 4, N'0901234009', N'duyen.ttm@petshop.vn', N'Nhân viên chăm sóc, Quản lý phòng lưu trú & Chế độ ăn uống thú cưng'),
(N'123456', N'Nguyễn Hồng Ngân', N'Nữ', 1992, 2, N'0901234010', N'ngan.nh@petshop.vn', N'Quản lý cửa hàng, Điều phối ca trực, Quản lý doanh thu & Nhân sự'),
(N'123456', N'Ngô Minh Nhật', N'Nam', 1999, 3, N'0901234011', N'nhat.nm@petshop.vn', N'Bác sĩ thú y, Khám tổng quát, Tiêm phòng vắc xin, Tẩy giun & Cấp cứu'),
(N'123456', N'Phạm Văn Tài', N'Nam', 2001, 4, N'0901234012', N'tai.pv@petshop.vn', N'Nhân viên chăm sóc, Hỗ trợ tắm rửa, Vệ sinh khử khuẩn khu lưu trú');
GO

INSERT INTO [dbo].[tblKhachHang] ([TenKH], [MatKhau], [GioiTinh], [NamSinh], [Avarta], [DienThoai], [Email], [DiaChi]) VALUES
(N'Trần Minh Anh', N'123', N'Nữ', 2002, N'anh1.jpg', N'0946725980', N'minha@gmail.com', N'Quận 1, TP.HCM'),
(N'Nguyễn Quốc Bảo', N'123', N'Nam', 2000, N'bao.jpg', N'0842629565', N'bao@gmail.com', N'Đà Nẵng'),
(N'Lê Hồng Cúc', N'123', N'Nữ', 2003, N'cuc.jpg', N'0834622456', N'cuc@gmail.com', N'Hà Nội'),
(N'Phan Văn Dũng', N'123', N'Nam', 1999, N'dung.jpg', N'035268964', N'dung@gmail.com', N'Cần Thơ'),
(N'Đỗ Thị Lan', N'123', N'Nữ', 2001, N'lan.jpg', N'0953684544', N'lan@gmail.com', N'Bình Dương'),
(N'Trịnh Hoàng Nam', N'123', N'Nam', 2002, N'nam.jpg', N'0566732425', N'nam@gmail.com', N'Huế'),
(N'Nguyễn Mỹ Hoa', N'123', N'Nữ', 2004, N'hoa.jpg', N'0856642415', N'hoa@gmail.com', N'TP.HCM'),
(N'Phạm Hữu Tài', N'123', N'Nam', 1998, N'tai.jpg', N'0883525754', N'tai@gmail.com', N'Đà Lạt'),
(N'Đoàn Thanh Hà', N'123', N'Nữ', 2003, N'ha.jpg', N'0364634684', N'ha@gmail.com', N'Nha Trang'),
(N'Ngô Văn Phúc', N'123', N'Nam', 2001, N'phuc.jpg', N'0986764309', N'phuc@gmail.com', N'Long An'),
(N'Nguyễn Văn An', N'123456', N'Nam', 1990, N'avt1.jpg', N'0909111222', N'an.nguyen@gmail.com', N'123 Lý Thường Kiệt, Quận 10, TP.HCM'),
(N'Trần Thị Bích', N'abcdef', N'Nữ', 1995, N'avt2.jpg', N'0912333444', N'bichtran@yahoo.com', N'45 Nguyễn Du, Quận 1, TP.HCM'),
(N'Lê Minh Cường', N'cuongle', N'Nam', 1988, N'avt3.jpg', N'0988222333', N'cuongle@gmail.com', N'78 Lê Văn Sỹ, Quận 3, TP.HCM'),
(N'Phạm Thu Hà', N'haphamm', N'Nữ', 1992, N'avt4.jpg', N'0933444555', N'ha.pham@outlook.com', N'56 Hoàng Văn Thụ, Quận Phú Nhuận, TP.HCM'),
(N'Hoàng Văn Dũng', N'dunghoang', N'Nam', 1998, N'avt5.jpg', N'0977555666', N'dung.hoang@gmail.com', N'234 Cộng Hòa, Tân Bình, TP.HCM'),
(N'Vũ Thị Lan', N'lanvuu', N'Nữ', 1993, N'avt6.jpg', N'0911666777', N'lan.vu@yahoo.com', N'89 Nguyễn Trãi, Quận 5, TP.HCM'),
(N'Đặng Quang Huy', N'huydang', N'Nam', 1991, N'avt7.jpg', N'0922777888', N'huy.dang@gmail.com', N'67 Võ Thị Sáu, Quận 3, TP.HCM'),
(N'Ngô Thị Mai', N'maingo', N'Nữ', 1996, N'avt8.jpg', N'0944888999', N'mai.ngo@outlook.com', N'123 Lê Quang Định, Bình Thạnh, TP.HCM'),
(N'Bùi Văn Tài', N'taibui', N'Nam', 1989, N'avt9.jpg', N'0966999000', N'tai.bui@gmail.com', N'45 Trường Chinh, Tân Phú, TP.HCM'),
(N'Lý Thị Hương', N'huongly', N'Nữ', 1994, N'avt10.jpg', N'0955111222', N'huong.ly@yahoo.com', N'78 Lý Thái Tổ, Quận 10, TP.HCM'),
(N'Tạ Minh Tuấn', N'tuan123', N'Nam', 1997, N'avt11.jpg', N'0938123456', N'tuan.taminh@gmail.com', N'Biên Hòa, Đồng Nai'),
(N'Nguyễn Thị Kim Yến', N'yenkim', N'Nữ', 1999, N'avt12.jpg', N'0947234567', N'yen.kim@yahoo.com', N'Bến Tre'),
(N'Phạm Văn Khánh', N'khanhpham', N'Nam', 1995, N'avt13.jpg', N'0968345678', N'khanh.pham@gmail.com', N'Vũng Tàu'),
(N'Lê Thị Ngọc Mai', N'ngocmai', N'Nữ', 2000, N'avt14.jpg', N'0978456789', N'ngoc.mai@outlook.com', N'Tây Ninh'),
(N'Hoàng Minh Nhật', N'nhathoang', N'Nam', 1996, N'avt15.jpg', N'0988567890', N'minh.nhat@gmail.com', N'Bình Thuận'),
(N'Nguyễn Thị Hồng Nhung', N'nhunghong', N'Nữ', 1998, N'avt16.jpg', N'0918678901', N'nhung.hong@gmail.com', N'Phan Thiết'),
(N'Đinh Văn Lâm', N'lamdinh', N'Nam', 1994, N'avt17.jpg', N'0928789012', N'lam.dinh@yahoo.com', N'Bạc Liêu'),
(N'Võ Thị Thanh Trúc', N'thanhtruc', N'Nữ', 1997, N'avt18.jpg', N'0938890123', N'truc.vo@gmail.com', N'Trà Vinh'),
(N'Trần Quốc Huy', N'huytran', N'Nam', 1993, N'avt19.jpg', N'0948901234', N'huy.tran@outlook.com', N'Bình Phước'),
(N'Nguyễn Thị Diễm My', N'diemmy', N'Nữ', 1996, N'avt20.jpg', N'0959012345', N'diem.my@gmail.com', N'Quảng Ngãi');
GO

INSERT INTO [dbo].[tblTinhTrang] ([TinhTrangDonHang]) VALUES
(N'Đang xử lý'),
(N'Đã xác nhận'),
(N'Đang giao'),
(N'Hoàn thành'),
(N'Đã hủy'),
(N'Chờ thanh toán'),
(N'Đã hoàn tiền'),
(N'Lỗi thanh toán'),
(N'Đặt trước'),
(N'Chờ xác nhận'),
(N'Đang xử lý đổi trả'),
(N'Đã đổi trả')
GO

INSERT INTO [dbo].[tblMaGiamGia] ([MaGiamGia], [PhanTramGiam], [SoTienGiamToiDa], [NgayBatDau], [NgayKetThuc], [SoLuong]) VALUES
(N'SALE10', 10.00, 50000, GETDATE(), DATEADD(DAY,30,GETDATE()), 100),
(N'SUMMER15', 15.00, 70000, GETDATE(), DATEADD(DAY,60,GETDATE()), 50),
(N'NEWUSER5', 5.00, 20000, GETDATE(), DATEADD(DAY,90,GETDATE()), 200),
(N'PETCARE20', 20.00, 100000, GETDATE(), DATEADD(DAY,10,GETDATE()), 20),
(N'FREESHIP', 0.00, 30000, GETDATE(), DATEADD(DAY,120,GETDATE()), 500),
(N'SALE25', 25.00, 150000, GETDATE(), DATEADD(DAY,15,GETDATE()), 10),
(N'XMAS30', 30.00, 200000, GETDATE(), DATEADD(DAY,45,GETDATE()), 5),
(N'HAPPYDAY', 12.00, 60000, GETDATE(), DATEADD(DAY,30,GETDATE()), 80),
(N'WEEKEND', 8.00, 40000, GETDATE(), DATEADD(DAY,14,GETDATE()), 120),
(N'WELCOME10', 10.00, 500000, GETDATE(), DATEADD(DAY, 30, GETDATE()), 100),
(N'SALE20', 20.00, 1000000, GETDATE(), DATEADD(DAY, 15, GETDATE()), 500),
(N'PETLOVER15', 15.00, 800000, GETDATE(), DATEADD(DAY, 31, GETDATE()), 300),
(N'FIRSTORDER5', 5.00, 200000, GETDATE(), DATEADD(DAY, 365, GETDATE()), 200),
(N'SUMMER25', 25.00, 1500000, GETDATE(), DATEADD(DAY, 45, GETDATE()), 200),
(N'VIPMEMBER', 10.00, NULL, GETDATE(), DATEADD(DAY, 365, GETDATE()), NULL),
(N'PETCARE10', 10.00, 300000, GETDATE(), DATEADD(DAY, 20, GETDATE()), 40),
(N'HOLIDAY30', 30.00, 2000000, GETDATE(), DATEADD(DAY, 60, GETDATE()), 100),
(N'NEWYEAR2025', 15.00, 1000000, GETDATE(), DATEADD(DAY, 90, GETDATE()), 50),
(N'SPECIAL', 50.00, 250000, GETDATE(), DATEADD(DAY, 5, GETDATE()), 3),
(N'CHAMSOCPET', 10.00, 50000, GETDATE(), DATEADD(DAY, 30, GETDATE()), 20),
(N'TAMGOI', 15.00, 70000, GETDATE(), DATEADD(DAY, 45, GETDATE()), 10),
(N'PHUKIENPET', 5.00, 30000, GETDATE(), DATEADD(DAY, 60, GETDATE()), 25),
(N'KHAMTHUY', 20.00, 100000, GETDATE(), DATEADD(DAY, 10, GETDATE()), 5),
(N'QUANAOPET', 12.00, 60000, GETDATE(), DATEADD(DAY, 20, GETDATE()), 15),
(N'PETMOI', 8.00, 40000, GETDATE(), DATEADD(DAY, 14, GETDATE()), 30),
(N'PETSPA', 25.00, 150000, GETDATE(), DATEADD(DAY, 15, GETDATE()), 8),
(N'PETYEU', 30.00, 200000, GETDATE(), DATEADD(DAY, 25, GETDATE()), 3),
(N'PETSHOPVUI', 10.00, 50000, GETDATE(), DATEADD(DAY, 30, GETDATE()), 20),
(N'THUCPET', 5.00, 20000, GETDATE(), DATEADD(DAY, 7, GETDATE()), 50);
GO

INSERT INTO [dbo].[tblSanPham]
([TenSP], [LoaiSanPham], [GioiTinh], [NgaySinh], [MauSac], [TinhTrangSucKhoe], [TienSuBenh], [MoTa], [GiaBan], [AnhDaiDien], [MaDanhMuc], [MaNCC]) VALUES
(N'Chó Poodle Mini', N'Pet', N'Đực', '2024-01-10', N'Nâu', N'Khỏe mạnh', NULL, N'Dễ thương, thân thiện', 6500000, N'poodle.jpg', 1, 1),
(N'Chó Corgi', N'Pet', N'Cái', '2024-02-14', N'Vàng trắng', N'Khỏe mạnh', NULL, N'Thân ngắn, mông to', 12000000, N'corgi.jpg', 1, 3),
(N'Mèo Anh lông ngắn', N'Pet', N'Đực', '2024-03-05', N'Xám', N'Khỏe mạnh', NULL, N'Hiền, dễ nuôi', 8000000, N'meolongan.jpg', 2, 4),
(N'Mèo Ba Tư', N'Pet', N'Cái', '2024-04-12', N'Trắng', N'Khỏe mạnh', NULL, N'Lông dài, dễ rụng', 9500000, N'meobatu.jpg', 2, 4),
(N'Thức ăn Pedigree 3kg', N'Accessory', NULL, NULL, NULL, NULL, NULL, N'Thức ăn khô cho chó', 350000, N'pedigree.jpg', 3, 5),
(N'Pate Whiskas 85g', N'Accessory', NULL, NULL, NULL, NULL, NULL, N'Pate cho mèo vị cá ngừ', 18000, N'whiskas.jpg', 4, 5),
(N'Dây dắt thú cưng', N'Accessory', NULL, NULL, N'Đỏ', NULL, NULL, N'Chất liệu bền, an toàn', 80000, N'daydatcho.jpg', 5, 8),
(N'Áo len cho chó', N'Accessory', NULL, NULL, N'Hồng', NULL, NULL, N'Giữ ấm, dễ giặt', 120000, N'aolen.jpg', 5, 8),
(N'Bóng gặm nhai', N'Accessory', NULL, NULL, NULL, NULL, NULL, N'Giúp thú cưng vận động', 40000, N'bong.jpg', 7, 8),
(N'Sữa tắm PetLove', N'Accessory', NULL, NULL, NULL, NULL, NULL, N'Sạch lông, mùi dễ chịu', 95000, N'suatam.jpg', 6, 9),
(N'Chó Alaska 3 tháng tuổi', N'Pet', N'Đực', CAST(N'2024-05-15' AS Date), N'Xám trắng', N'Tốt, đã tiêm phòng 2 mũi', N'Không', N'Chó Alaska thuần chủng, khỏe mạnh, thân thiện', 15000000.00, N'alaska.jpg', 1, 1),
(N'Mèo Anh lông ngắn 2 tháng', N'Pet', N'Cái', CAST(N'2024-06-20' AS Date), N'Xám xanh', N'Rất tốt, đã tiêm phòng đầy đủ', N'Không', N'Mèo Anh lông ngắn thuần chủng, mắt to tròn', 8000000.00, N'meo_anh.jpg', 2, 2),
(N'Thức ăn cho chó Royal Canin', N'Accessory', NULL, NULL, NULL, NULL, NULL, N'Thức ăn hạt cao cấp cho chó trưởng thành', 450000.00, N'royal_canin.jpg', 3, 3),
(N'Chó Poodle Tiny 4 tháng', N'Pet', N'Cái', CAST(N'2024-04-10' AS Date), N'Trắng', N'Tốt, đã tiêm phòng 3 mũi', N'Viêm da nhẹ (đã khỏi)', N'Poodle Tiny thuần chủng, thông minh, dễ thương', 12000000.00, N'poodle_tiny.jpg', 1, 8),
(N'Cát vệ sinh cho mèo', N'Accessory', NULL, NULL, N'Trắng', NULL, NULL, N'Cát vệ sinh khử mùi tốt, thân thiện môi trường', 150000.00, N'cat_sand.jpg', 8, 5),
(N'Chó Phú Quốc 5 tháng', N'Pet', N'Đực', CAST(N'2024-03-25' AS Date), N'Vàng', N'Rất khỏe, đã tiêm phòng', N'Không', N'Chó Phú Quốc thuần chủng, xoáy lưng rõ nét', 7000000.00, N'phuquoc_dog.jpg', 1, 10),
(N'Pate cho mèo Whiskas', N'Accessory', NULL, NULL, NULL, NULL, NULL, N'Pate dinh dưỡng cao cấp cho mèo mọi lứa tuổi', 85000.00, N'whiskas_pate.jpg', 3, 7),
(N'Vòng cổ da cao cấp', N'Accessory', NULL, NULL, N'Nâu', NULL, NULL, N'Vòng cổ bằng da thật, điều chỉnh được kích thước', 250000.00, N'leather_collar.jpg', 5, 9),
(N'Mèo Ba Tư 3 tháng', N'Pet', N'Đực', CAST(N'2024-05-30' AS Date), N'Trắng', N'Tốt, cần chăm sóc lông thường xuyên', N'Không', N'Mèo Ba Tư thuần chủng, mặt tịt, lông dày', 10000000.00, N'persian_cat.jpg', 2, 6),
(N'Đồ chơi xương gặm', N'Accessory', NULL, NULL, N'Đỏ', NULL, NULL, N'Đồ chơi cho chó gặm, làm sạch răng', 120000.00, N'chew_toy.jpg', 7, 5),
(N'Chó Bull Pháp 2 tháng', N'Pet', N'Đực', CAST(N'2024-07-01' AS Date), N'Nâu vàng', N'Khỏe mạnh', N'Không', N'Mặt xệ, thân thiện, dễ nuôi', 9000000, N'bull_phap.jpg', 1, 1),
(N'Mèo Munchkin chân ngắn', N'Pet', N'Cái', CAST(N'2024-06-10' AS Date), N'Kem', N'Khỏe mạnh', N'Không', N'Mèo chân ngắn, hoạt bát, dễ thương', 8500000, N'munchkin.jpg', 2, 2),
(N'Thức ăn hạt Me-O 1.5kg', N'Accessory', NULL, NULL, NULL, NULL, NULL, N'Thức ăn cho mèo vị cá biển', 120000, N'meo.jpg', 4, 5),
(N'Balo vận chuyển thú cưng', N'Accessory', NULL, NULL, N'Xanh dương', NULL, NULL, N'Balo có lỗ thoáng khí, tiện di chuyển', 350000, N'balo_pet.jpg', 5, 8),
(N'Bàn chải lông chó mèo', N'Accessory', NULL, NULL, N'Trắng xanh', NULL, NULL, N'Dễ cầm, loại bỏ lông rụng hiệu quả', 95000, N'brush.jpg', 6, 9),
(N'Nước hoa thú cưng PetScent', N'Accessory', NULL, NULL, NULL, NULL, NULL, N'Mùi hương nhẹ nhàng, an toàn cho da', 110000, N'petscent.jpg', 6, 9),
(N'Chuồng lưới gấp gọn', N'Accessory', NULL, NULL, N'Đen', NULL, NULL, N'Chuồng sắt gấp gọn, dễ vệ sinh', 650000, N'chuong_luoi.jpg', 8, 4),
(N'Vitamin tổng hợp PetVita', N'Accessory', NULL, NULL, NULL, NULL, NULL, N'Hỗ trợ miễn dịch và tiêu hóa', 180000, N'petvita.jpg', 9, 6),
(N'Chó Husky 4 tháng tuổi', N'Pet', N'Cái', CAST(N'2024-05-01' AS Date), N'Xám trắng', N'Khỏe mạnh', N'Không', N'Husky thân thiện, năng động, đã tiêm phòng', 14000000, N'husky.jpg', 1, 10),
(N'Mèo Sphynx không lông', N'Pet', N'Đực', CAST(N'2024-04-20' AS Date), N'Hồng nhạt', N'Khỏe mạnh', N'Không', N'Mèo không lông, phù hợp người dị ứng', 16000000, N'sphynx.jpg', 2, 6);
GO

INSERT INTO [dbo].[tblTonKho] ([MaSP], [SoLuongTon], [TrangThai]) VALUES
-- Thú cưng
(1, 1, N'Sẵn sàng bán'),
(2, 1, N'Sẵn sàng bán'),
(3, 1, N'Sẵn sàng bán'),
(4, 1, N'Sẵn sàng bán'),
(11, 1, N'Sẵn sàng bán'),
(12, 1, N'Sẵn sàng bán'),
(14, 1, N'Đặt trước'),
(16, 1, N'Sẵn sàng bán'),
(19, 1, N'Sẵn sàng bán'),
(21, 1, N'Sẵn sàng bán'),
(22, 1, N'Sẵn sàng bán'),
(29, 1, N'Sẵn sàng bán'),
(30, 1, N'Sẵn sàng bán'),

(5, 50, NULL),
(6, 200, NULL),
(7, 100, NULL),
(8, 80, NULL),
(9, 150, NULL),
(10, 120, NULL),
(13, 50, NULL),
(15, 100, NULL),
(17, 80, NULL),
(18, 25, NULL),
(20, 45, NULL),
(23, 60, NULL),
(24, 40, NULL),
(25, 100, NULL),
(26, 70, NULL),
(27, 30, NULL),
(28, 35, NULL);
GO

INSERT INTO [dbo].[tblDichVu] ([TenDV], [MoTa], [GiaDichVu], [HinhAnh]) VALUES
(N'Tắm gội', N'Tắm, sấy và chải lông cho thú cưng', 150000, N'tam-goi.jpg'),
(N'Cắt tỉa lông', N'Cắt tỉa tạo kiểu chuyên nghiệp', 200000, N'cat-tia-long.jpg'),
(N'Khám tổng quát', N'Khám sức khỏe toàn diện', 100000, N'kham-tong-quat.jpg'),
(N'Tiêm phòng', N'Tiêm ngừa bệnh dại, care, parvo', 250000, N'tiem-phong.jpg'),
(N'Chăm sóc sau phẫu thuật', N'Theo dõi thú cưng sau điều trị', 300000, N'cham-soc-sau-phau-thuat.jpg'),
(N'Khách sạn thú cưng', N'Lưu trú an toàn, tiện nghi', 400000, N'khach-san-thu-cung.jpg'),
(N'Ve sinh tai & răng', N'Làm sạch vùng tai, miệng', 100000, N've-sinh-tai-rang.jpg'),
(N'Cạo lông mùa hè', N'Cạo sạch giúp mát mẻ', 120000, N'cao-long.jpg'),
(N'Tư vấn dinh dưỡng', N'Xây dựng khẩu phần ăn hợp lý', 80000, N'tu-van-dinh-duong.jpg'),
(N'Khám da liễu', N'Điều trị viêm da, nấm, rụng lông', 200000, N'kham-da-lieu.jpg'),
(N'Massage thư giãn', N'Giúp thú cưng giảm căng thẳng và tuần hoàn tốt hơn', 180000, N'massage.jpg'),
(N'Gỡ rối lông', N'Gỡ rối lông bị rối, xù, kết cục', 100000, N'go-roi-long.jpg'),
(N'Chăm sóc móng', N'Cắt móng, vệ sinh móng cho thú cưng', 90000, N'cham-soc-mong.jpg'),
(N'Xịt khử mùi', N'Khử mùi hôi cơ thể bằng sản phẩm an toàn', 70000, N'xit-khu-mui.jpg'),
(N'Chụp ảnh thú cưng', N'Chụp ảnh chuyên nghiệp, lưu giữ khoảnh khắc', 250000, N'chup-anh.jpg'),
(N'Đào tạo cơ bản', N'Dạy thú cưng các kỹ năng cơ bản như ngồi, nằm, đi vệ sinh đúng chỗ', 300000, N'dao-tao.jpg'),
(N'Gửi thú cưng theo giờ', N'Dịch vụ giữ thú cưng ngắn hạn theo giờ', 50000, N'gui-thu-cung.jpg'),
(N'Chăm sóc thú cưng cao tuổi', N'Dịch vụ đặc biệt cho thú cưng lớn tuổi, theo dõi sức khỏe định kỳ', 350000, N'cham-soc-cao-tuoi.jpg'),
(N'Xét nghiệm máu', N'Kiểm tra tổng quát các chỉ số máu', 280000, N'xet-nghiem-mau.jpg'),
(N'Vệ sinh tuyến hôi', N'Làm sạch tuyến hôi giúp thú cưng thơm tho và khỏe mạnh', 120000, N've-sinh-tuyen-hoi.jpg');
GO

INSERT INTO [dbo].[tblHinhAnh] ([MaSP], [HinhAnh]) VALUES
(1, N'poodle.jpg'),
(1, N'poodle1.jpg'),
(1, N'poodle2.jpg'),
(2, N'corgi.jpg'),
(2, N'corgi1.jfif'),
(2, N'corgi2.jfif'),
(3, N'meolongan1.jpg'),
(3, N'meolongan2.jpg'),
(3, N'meolongan.jpg'),
(4, N'meobatu.jpg'),
(4, N'meobatu1.jpg'),
(4, N'meobatu2.jpg'),
(5, N'pedigree.jpg'),
(5, N'pedigree1.jpg'),
(5, N'pedigree2.jpg'),
(6, N'whiskas.jpg'),
(6, N'whiskas1.jpg'),
(6, N'whiskas2.jpg'),
(7, N'daydatcho.jpg'),
(7, N'daydatcho1.jfif'),
(7, N'daydatcho2.jfif'),
(8, N'aolen.jpg'),
(8, N'aolen1.jfif'),
(8, N'aolen2.jfif'),
(9, N'bong.jpg'),
(9, N'bong1.jfif'),
(9, N'bong2.jfif'),
(10, N'suatam.jpg'),
(10, N'suatam1.jpg'),
(10, N'suatam2.jpg'),
(11, N'alaska.jpg'),
(11, N'alaska1.jpg'),
(11, N'alaska2.jpg'),
(12, N'meo_anh.jpg'),
(12, N'meo_anh1.jpg'),
(12, N'meo_anh2.jpg'),
(13, N'royal_canin.jpg'),
(13, N'royal_canin1.jpg'),
(13, N'royal_canin2.jpg'),
(14, N'poodle_tiny.jpg'),
(14, N'poodle_tiny1.jpg'),
(14, N'poodle_tiny2.jpg'),
(15, N'cat_sand.jpg'),
(15, N'cat_sand1.jfif'),
(15, N'cat_sand2.jfif'),
(16, N'phuquoc_dog.jpg'),
(16, N'phuquoc_dog1.jpg'),
(16, N'phuquoc_dog2.jpg'),
(17, N'whiskas_pate.jpg'),
(17, N'whiskas_pate1.jpg'),
(17, N'whiskas_pate2.jpg'),
(18, N'leather_collar.jpg'),
(18, N'leather_collar1.jfif'),
(18, N'leather_collar2.jpg'),
(19, N'persian_cat.jpg'),
(19, N'persian_cat1.jpg'),
(19, N'persian_cat2.jpg'),
(20, N'chew_toy.jpg'),
(20, N'chew_toy1.jfif'),
(20, N'chew_toy2.jfif'),
(21, N'bull_phap.jpg'),
(21, N'bull_phap1.jfif'),
(21, N'bull_phap2.jfif'),
(22, N'munchkin.jpg'),
(22, N'munchkin1.jpg'),
(22, N'munchkin2.jpg'),
(23, N'meo.jpg'),
(23, N'meo1.jpg'),
(23, N'meo2.jpg'),
(24, N'balo_pet.jpg'),
(24, N'balo_pet1.jfif'),
(24, N'balo_pet2.jfif'),
(25, N'brush.jpg'),
(25, N'brush1.jfif'),
(25, N'brush2.jfif'),
(26, N'petscent.jpg'),
(26, N'petscent1.jpg'),
(26, N'petscent2.jpg'),
(27, N'chuong_luoi.jpg'),
(27, N'chuong_luoi1.jfif'),
(27, N'chuong_luoi2.jfif'),
(28, N'petvita.jpg'),
(28, N'petvita1.jpg'),
(28, N'petvita2.jpg'),
(29, N'husky.jpg'),
(29, N'husky1.jfif'),
(29, N'husky2.jfif'),
(30, N'sphynx.jpg'),
(30, N'sphynx1.jpg'),
(30, N'sphynx2.jpg');
GO

-- 4. DỮ LIỆU MẪU: HÓA ĐƠN BÁN HÀNG & SẢN PHẨM (tblHoaDon)
SET IDENTITY_INSERT [dbo].[tblHoaDon] ON;
INSERT INTO [dbo].[tblHoaDon] ([MaHD], [MaKH], [MaNV], [NgayLap], [TongTien], [TinhTrang], [DiaChiGiaoHang], [DaThanhToan], [MaGiamGia], [TienGiam], [HinhThucThanhToan], [DaCongDiem]) VALUES
(1, 8, 4, '2026-01-01 19:17:00', 11900000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, N'VIPMEMBER', 100000.00, N'VietQR', True),
(2, 4, 6, '2026-01-04 09:24:00', 330000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(3, 18, 5, '2026-01-04 14:05:00', 2130000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(4, 9, 1, '2026-01-08 15:37:00', 165000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(5, 18, 4, '2026-01-17 17:01:00', 9500000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(6, 4, 7, '2026-01-28 11:55:00', 2285000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(7, 19, 7, '2026-01-29 16:05:00', 13900000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, N'VIPMEMBER', 100000.00, N'ChuyenKhoan', True),
(8, 10, 10, '2026-02-01 12:46:00', 330000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(9, 4, 2, '2026-02-02 12:31:00', 690000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(10, 2, 5, '2026-02-02 13:50:00', 420000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(11, 4, 12, '2026-02-03 09:27:00', 1558000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(12, 31, 4, '2026-02-03 10:48:00', 1020000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(13, 30, 8, '2026-02-04 15:45:00', 200000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(14, 16, 8, '2026-02-04 19:04:00', 690000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(15, 10, 6, '2026-02-05 09:58:00', 120000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(16, 9, 3, '2026-02-05 10:34:00', 700000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(17, 7, 2, '2026-02-05 20:36:00', 995000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(18, 31, 4, '2026-02-07 15:28:00', 950000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(19, 1, 3, '2026-02-08 17:20:00', 285000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(20, 28, 9, '2026-02-08 20:27:00', 1380000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(21, 22, 1, '2026-02-09 15:16:00', 730000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VNPay', True),
(22, 1, 11, '2026-02-10 19:18:00', 54000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(23, 29, 8, '2026-02-11 18:45:00', 660000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(24, 28, 3, '2026-02-12 08:11:00', 120000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(25, 30, 5, '2026-02-12 16:32:00', 490000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(26, 4, 6, '2026-02-13 14:46:00', 545000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, N'SALE10', 30000.00, N'VNPay', True),
(27, 21, 12, '2026-02-14 09:48:00', 250000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(28, 15, 5, '2026-02-14 19:16:00', 690000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(29, 24, 11, '2026-02-15 13:43:00', 480000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(30, 13, 4, '2026-02-15 16:09:00', 9500000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(31, 4, 6, '2026-02-16 11:54:00', 255000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(32, 18, 9, '2026-02-16 13:21:00', 1620000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, N'SALE10', 30000.00, N'VietQR', True),
(33, 24, 12, '2026-02-18 14:37:00', 1790000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(34, 4, 8, '2026-02-19 13:55:00', 80000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(35, 6, 3, '2026-02-19 18:50:00', 1850000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(36, 30, 10, '2026-02-20 16:20:00', 560000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, N'SALE10', 30000.00, N'ChuyenKhoan', True),
(37, 18, 12, '2026-02-20 18:37:00', 1560000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, N'SALE10', 30000.00, N'VietQR', True),
(38, 24, 9, '2026-02-21 08:05:00', 350000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(39, 21, 11, '2026-02-23 09:54:00', 520000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(40, 29, 5, '2026-02-24 15:53:00', 1350000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(41, 11, 12, '2026-02-25 14:02:00', 690000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VietQR', True),
(42, 30, 12, '2026-02-25 14:55:00', 1098000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, N'SALE10', 30000.00, N'VNPay', True),
(43, 22, 11, '2026-02-25 19:49:00', 1336000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(44, 25, 7, '2026-02-28 09:17:00', 7900000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, N'VIPMEMBER', 100000.00, N'VietQR', True),
(45, 22, 4, '2026-02-28 15:05:00', 120000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(46, 3, 8, '2026-02-28 18:09:00', 1225000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(47, 10, 8, '2026-02-28 18:33:00', 1300000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(48, 30, 12, '2026-03-05 12:12:00', 8000000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(49, 21, 2, '2026-03-09 11:21:00', 450000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VNPay', True),
(50, 20, 10, '2026-03-09 14:43:00', 870000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, N'SALE10', 30000.00, N'ChuyenKhoan', True),
(51, 11, 5, '2026-03-13 11:35:00', 1070000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(52, 2, 9, '2026-03-14 12:17:00', 3190000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(53, 14, 7, '2026-03-17 13:44:00', 745000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(54, 7, 2, '2026-03-20 08:15:00', 11900000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, N'VIPMEMBER', 100000.00, N'VietQR', True),
(55, 28, 1, '2026-03-20 18:45:00', 480000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(56, 15, 1, '2026-03-23 10:51:00', 400000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(57, 9, 9, '2026-03-24 10:01:00', 530000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(58, 5, 9, '2026-03-25 20:03:00', 780000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(59, 25, 6, '2026-03-26 19:30:00', 303000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(60, 18, 11, '2026-03-27 11:31:00', 1480000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(61, 31, 1, '2026-03-30 13:19:00', 2400000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(62, 17, 4, '2026-04-07 16:38:00', 15000000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(63, 30, 6, '2026-04-17 08:23:00', 12000000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(64, 13, 2, '2026-04-29 11:31:00', 16000000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(65, 27, 9, '2026-05-01 13:48:00', 1560000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, N'SALE10', 30000.00, N'ChuyenKhoan', True),
(66, 9, 4, '2026-05-02 08:28:00', 320000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(67, 13, 2, '2026-05-04 14:28:00', 1470000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(68, 11, 5, '2026-05-04 15:04:00', 335000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(69, 24, 5, '2026-05-04 15:08:00', 680000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(70, 4, 8, '2026-05-10 09:50:00', 1710000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(71, 14, 7, '2026-05-10 12:58:00', 1830000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(72, 4, 11, '2026-05-10 14:42:00', 2275000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(73, 29, 8, '2026-05-11 14:36:00', 580000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(74, 22, 3, '2026-05-11 14:56:00', 965000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, N'SALE10', 30000.00, N'VietQR', True),
(75, 10, 3, '2026-05-13 16:37:00', 1080000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(76, 11, 6, '2026-05-14 20:56:00', 2070000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(77, 17, 10, '2026-05-15 12:43:00', 9400000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, N'VIPMEMBER', 100000.00, N'VietQR', True),
(78, 29, 1, '2026-05-17 20:15:00', 480000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(79, 14, 8, '2026-05-21 14:25:00', 1350000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(80, 13, 11, '2026-05-21 20:02:00', 498000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(81, 21, 10, '2026-05-22 13:35:00', 9900000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, N'VIPMEMBER', 100000.00, N'VNPay', True),
(82, 24, 1, '2026-05-24 10:13:00', 360000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(83, 31, 11, '2026-05-26 15:58:00', 190000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(84, 16, 4, '2026-05-31 17:04:00', 1050000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(85, 30, 10, '2026-06-03 10:30:00', 85000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(86, 13, 11, '2026-06-04 16:00:00', 10000000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(87, 24, 4, '2026-06-05 18:07:00', 1350000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'TienMat', True),
(88, 12, 11, '2026-06-09 20:25:00', 1820000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(89, 20, 12, '2026-06-11 20:35:00', 1020000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, N'SALE10', 30000.00, N'ChuyenKhoan', True),
(90, 14, 11, '2026-06-12 09:09:00', 11900000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, N'VIPMEMBER', 100000.00, N'VNPay', True),
(91, 2, 12, '2026-06-12 09:38:00', 910000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(92, 18, 8, '2026-06-14 16:50:00', 2240000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(93, 20, 5, '2026-06-14 17:23:00', 10000000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(94, 28, 11, '2026-06-15 08:12:00', 54000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(95, 8, 10, '2026-06-17 16:44:00', 500000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(96, 6, 7, '2026-06-19 08:16:00', 1020000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(97, 19, 6, '2026-06-24 16:58:00', 900000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(98, 15, 11, '2026-07-01 09:01:00', 1600000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(99, 1, 5, '2026-07-02 14:48:00', 864000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(100, 2, 3, '2026-07-02 18:22:00', 116000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, NULL, 0.00, N'VNPay', True);
INSERT INTO [dbo].[tblHoaDon] ([MaHD], [MaKH], [MaNV], [NgayLap], [TongTien], [TinhTrang], [DiaChiGiaoHang], [DaThanhToan], [MaGiamGia], [TienGiam], [HinhThucThanhToan], [DaCongDiem]) VALUES
(101, 6, 12, '2026-07-03 14:25:00', 1155000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(102, 18, 8, '2026-07-03 20:19:00', 450000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(103, 15, 10, '2026-07-03 20:48:00', 1030000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(104, 25, 10, '2026-07-05 10:01:00', 12000000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(105, 10, 10, '2026-07-06 10:43:00', 156000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(106, 3, 6, '2026-07-06 15:24:00', 570000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(107, 7, 12, '2026-07-07 08:40:00', 500000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(108, 29, 6, '2026-07-07 11:43:00', 440000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(109, 31, 10, '2026-07-09 09:00:00', 360000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(110, 4, 3, '2026-07-10 18:11:00', 1320000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(111, 10, 5, '2026-07-11 11:12:00', 205000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(112, 31, 12, '2026-07-11 12:09:00', 160000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(113, 13, 2, '2026-07-11 13:57:00', 770000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(114, 8, 7, '2026-07-11 15:56:00', 2760000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(115, 17, 4, '2026-07-11 16:26:00', 180000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(116, 30, 8, '2026-07-11 18:30:00', 340000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(117, 23, 7, '2026-07-12 09:33:00', 386000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(118, 10, 1, '2026-07-12 09:55:00', 1180000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(119, 31, 5, '2026-07-12 15:53:00', 240000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(120, 27, 5, '2026-07-13 12:49:00', 804000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'TienMat', True),
(121, 1, 3, '2026-07-14 13:28:00', 415000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'TienMat', True),
(122, 25, 6, '2026-07-15 10:18:00', 900000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(123, 31, 4, '2026-07-15 15:14:00', 1335000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(124, 3, 12, '2026-07-15 18:28:00', 80000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(125, 14, 12, '2026-07-15 20:52:00', 1650000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(126, 12, 3, '2026-07-16 19:41:00', 135000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(127, 20, 12, '2026-07-16 19:44:00', 1915000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(128, 25, 1, '2026-07-17 16:20:00', 700000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(129, 23, 1, '2026-07-17 18:56:00', 164000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(130, 2, 9, '2026-07-18 14:47:00', 500000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(131, 5, 3, '2026-07-19 18:55:00', 401000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(132, 29, 9, '2026-07-20 08:15:00', 95000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(133, 26, 5, '2026-07-20 09:55:00', 270000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(134, 8, 4, '2026-07-20 11:38:00', 2030000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(135, 15, 1, '2026-07-20 13:34:00', 156000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(136, 7, 10, '2026-07-20 15:15:00', 425000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(137, 28, 3, '2026-07-20 16:25:00', 1104000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(138, 17, 12, '2026-07-20 17:31:00', 585000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(139, 6, 12, '2026-07-21 19:50:00', 330000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(140, 24, 1, '2026-07-22 10:13:00', 1530000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VietQR', True),
(141, 27, 8, '2026-07-24 19:36:00', 340000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(142, 7, 2, '2026-07-26 08:49:00', 260000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'ChuyenKhoan', True),
(143, 15, 1, '2026-07-28 09:21:00', 750000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(144, 16, 1, '2026-07-28 13:29:00', 240000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(145, 25, 11, '2026-07-29 17:57:00', 555000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(146, 3, 3, '2026-07-29 20:22:00', 1335000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(147, 28, 9, '2026-07-30 15:46:00', 360000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(148, 20, 2, '2026-07-31 14:04:00', 668000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(149, 8, 4, '2026-08-02 18:15:00', 500000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, N'SALE10', 30000.00, N'VNPay', True),
(150, 10, 9, '2026-08-03 18:52:00', 3090000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(151, 31, 11, '2026-08-03 20:30:00', 1920000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, N'SALE10', 30000.00, N'TienMat', True),
(152, 16, 11, '2026-08-04 17:43:00', 226000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(153, 4, 8, '2026-08-04 20:20:00', 1080000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, N'SALE10', 30000.00, N'TienMat', True),
(154, 26, 12, '2026-08-05 13:22:00', 976000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(155, 20, 7, '2026-08-07 13:12:00', 2205000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(156, 8, 11, '2026-08-09 15:31:00', 18000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(157, 13, 5, '2026-08-11 15:07:00', 660000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, N'SALE10', 30000.00, N'VNPay', True),
(158, 28, 7, '2026-08-13 15:20:00', 18000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VietQR', True),
(159, 11, 10, '2026-08-13 17:24:00', 900000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(160, 22, 2, '2026-08-15 16:42:00', 1140000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, N'SALE10', 30000.00, N'TienMat', True),
(161, 20, 11, '2026-08-16 17:24:00', 404000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(162, 6, 7, '2026-08-16 18:01:00', 750000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(163, 11, 9, '2026-08-17 12:34:00', 95000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(164, 4, 4, '2026-08-18 08:46:00', 16000000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(165, 15, 11, '2026-08-18 13:02:00', 1700000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(166, 25, 5, '2026-08-18 18:55:00', 620000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(167, 28, 7, '2026-08-18 20:39:00', 720000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(168, 23, 10, '2026-08-20 19:05:00', 810000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(169, 6, 1, '2026-08-22 20:35:00', 3090000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(170, 15, 11, '2026-08-23 17:11:00', 605000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, N'SALE10', 30000.00, N'TienMat', True),
(171, 25, 9, '2026-08-25 09:42:00', 750000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VietQR', True),
(172, 14, 7, '2026-08-25 12:54:00', 1225000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(173, 21, 7, '2026-08-25 20:51:00', 1490000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, N'SALE10', 30000.00, N'VietQR', True),
(174, 28, 9, '2026-08-26 09:53:00', 554000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(175, 11, 3, '2026-08-26 20:42:00', 1540000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(176, 4, 6, '2026-09-02 12:24:00', 435000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(177, 30, 1, '2026-09-04 09:03:00', 900000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(178, 20, 10, '2026-09-07 11:48:00', 746000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(179, 31, 6, '2026-09-07 17:32:00', 495000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(180, 2, 1, '2026-09-08 10:51:00', 655000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, N'SALE10', 30000.00, N'VNPay', True),
(181, 22, 10, '2026-09-08 17:50:00', 585000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, N'SALE10', 30000.00, N'VietQR', True),
(182, 31, 10, '2026-09-11 11:29:00', 680000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(183, 21, 11, '2026-09-11 12:04:00', 1335000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(184, 20, 6, '2026-09-12 14:52:00', 1090000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, N'SALE10', 30000.00, N'TienMat', True),
(185, 3, 10, '2026-09-13 11:21:00', 285000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(186, 22, 1, '2026-09-14 09:06:00', 890000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(187, 1, 7, '2026-09-14 09:30:00', 255000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(188, 23, 12, '2026-09-14 16:57:00', 790000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VietQR', True),
(189, 2, 10, '2026-09-14 18:10:00', 14900000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, N'VIPMEMBER', 100000.00, N'ChuyenKhoan', True),
(190, 27, 8, '2026-09-15 08:00:00', 2840000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(191, 9, 8, '2026-09-16 13:02:00', 1350000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(192, 31, 3, '2026-09-17 11:50:00', 285000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(193, 29, 12, '2026-09-17 20:02:00', 300000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(194, 10, 2, '2026-09-18 17:04:00', 170000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(195, 8, 9, '2026-09-19 18:06:00', 425000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(196, 2, 6, '2026-09-21 18:41:00', 460000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(197, 1, 8, '2026-09-21 18:50:00', 834000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, N'SALE10', 30000.00, N'VNPay', True),
(198, 27, 11, '2026-09-22 14:22:00', 285000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(199, 9, 11, '2026-09-24 08:48:00', 720000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, N'SALE10', 30000.00, N'TienMat', True),
(200, 25, 10, '2026-09-26 11:04:00', 330000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VietQR', True);
INSERT INTO [dbo].[tblHoaDon] ([MaHD], [MaKH], [MaNV], [NgayLap], [TongTien], [TinhTrang], [DiaChiGiaoHang], [DaThanhToan], [MaGiamGia], [TienGiam], [HinhThucThanhToan], [DaCongDiem]) VALUES
(201, 19, 3, '2026-09-26 11:57:00', 2235000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(202, 4, 8, '2026-09-27 12:15:00', 360000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(203, 17, 8, '2026-09-28 12:36:00', 555000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, N'SALE10', 30000.00, N'TienMat', True),
(204, 8, 9, '2026-09-30 17:54:00', 1340000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(205, 28, 9, '2026-10-01 17:07:00', 8000000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(206, 19, 4, '2026-10-03 13:47:00', 240000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(207, 20, 10, '2026-10-05 16:42:00', 810000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(208, 20, 11, '2026-10-08 13:28:00', 1535000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(209, 22, 8, '2026-10-10 11:31:00', 54000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(210, 23, 4, '2026-10-11 10:52:00', 1950000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(211, 22, 7, '2026-10-11 11:23:00', 7900000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, N'VIPMEMBER', 100000.00, N'VietQR', True),
(212, 23, 2, '2026-10-11 12:32:00', 2690000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(213, 10, 12, '2026-10-17 19:18:00', 80000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(214, 10, 1, '2026-10-19 19:00:00', 550000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(215, 18, 7, '2026-10-21 18:50:00', 370000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(216, 15, 3, '2026-10-22 16:55:00', 330000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'ChuyenKhoan', True),
(217, 24, 5, '2026-10-25 12:14:00', 810000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(218, 3, 2, '2026-10-25 18:44:00', 240000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(219, 28, 1, '2026-10-25 20:37:00', 665000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(220, 14, 8, '2026-10-26 09:22:00', 1750000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(221, 28, 4, '2026-10-26 19:21:00', 1740000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(222, 28, 3, '2026-10-27 18:58:00', 1490000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(223, 24, 6, '2026-10-28 08:51:00', 1300000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(224, 4, 1, '2026-10-28 13:51:00', 8000000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VietQR', True),
(225, 28, 12, '2026-10-29 17:50:00', 650000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(226, 5, 2, '2026-11-01 10:23:00', 7900000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, N'VIPMEMBER', 100000.00, N'ChuyenKhoan', True),
(227, 13, 8, '2026-11-01 17:50:00', 365000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(228, 20, 3, '2026-11-02 18:02:00', 700000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(229, 8, 12, '2026-11-02 19:50:00', 240000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(230, 31, 12, '2026-11-03 18:05:00', 660000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(231, 20, 1, '2026-11-04 09:13:00', 1278000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(232, 2, 6, '2026-11-04 17:31:00', 410000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(233, 24, 3, '2026-11-05 10:30:00', 12000000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(234, 18, 3, '2026-11-09 15:02:00', 1280000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, N'SALE10', 30000.00, N'TienMat', True),
(235, 12, 2, '2026-11-09 17:23:00', 840000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(236, 28, 3, '2026-11-10 10:36:00', 250000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(237, 13, 4, '2026-11-10 11:24:00', 120000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(238, 14, 10, '2026-11-11 17:26:00', 120000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(239, 24, 6, '2026-11-11 20:25:00', 405000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(240, 28, 7, '2026-11-12 14:32:00', 350000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VNPay', True),
(241, 4, 11, '2026-11-12 14:49:00', 360000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(242, 13, 2, '2026-11-13 10:36:00', 400000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(243, 20, 10, '2026-11-13 11:13:00', 1470000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(244, 18, 6, '2026-11-14 11:25:00', 250000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VNPay', True),
(245, 15, 11, '2026-11-14 19:21:00', 6900000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, N'VIPMEMBER', 100000.00, N'VNPay', True),
(246, 19, 11, '2026-11-15 11:43:00', 240000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(247, 1, 10, '2026-11-15 15:26:00', 1350000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(248, 3, 6, '2026-11-16 12:10:00', 1950000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(249, 28, 3, '2026-11-16 15:35:00', 180000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VNPay', True),
(250, 1, 2, '2026-11-16 19:30:00', 120000.00, 1, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', False, NULL, 0.00, N'BankTransfer', False),
(251, 24, 4, '2026-11-17 14:08:00', 350000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(252, 2, 1, '2026-11-19 20:30:00', 940000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(253, 9, 2, '2026-11-21 14:12:00', 790000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, N'SALE10', 30000.00, N'ChuyenKhoan', True),
(254, 27, 8, '2026-11-21 16:57:00', 240000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(255, 13, 6, '2026-11-25 14:12:00', 3300000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(256, 14, 8, '2026-11-26 13:50:00', 1050000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(257, 3, 8, '2026-11-26 20:57:00', 345000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(258, 20, 2, '2026-11-27 19:35:00', 530000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VietQR', True),
(259, 12, 2, '2026-11-28 17:20:00', 955000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(260, 23, 5, '2026-11-29 15:35:00', 450000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(261, 15, 3, '2026-11-30 20:21:00', 339000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(262, 26, 4, '2026-12-01 20:50:00', 2510000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, N'SALE10', 30000.00, N'VietQR', True),
(263, 16, 9, '2026-12-02 09:02:00', 900000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(264, 13, 3, '2026-12-02 11:13:00', 904000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(265, 29, 1, '2026-12-02 20:08:00', 1140000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(266, 15, 3, '2026-12-03 08:08:00', 390000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(267, 18, 5, '2026-12-03 11:49:00', 170000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(268, 8, 7, '2026-12-03 17:00:00', 150000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(269, 20, 6, '2026-12-05 08:20:00', 1050000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(270, 24, 6, '2026-12-07 15:45:00', 2010000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, N'SALE10', 30000.00, N'VietQR', True),
(271, 19, 6, '2026-12-08 11:20:00', 190000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(272, 26, 6, '2026-12-08 13:15:00', 690000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(273, 13, 5, '2026-12-09 12:37:00', 1650000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(274, 26, 11, '2026-12-09 18:16:00', 750000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(275, 9, 5, '2026-12-09 20:50:00', 95000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'TienMat', True),
(276, 19, 1, '2026-12-10 10:58:00', 420000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(277, 27, 5, '2026-12-11 08:14:00', 375000.00, 4, N'15 Phan Xích Long, Phường 2, Phú Nhuận, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(278, 8, 4, '2026-12-15 18:18:00', 7000000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(279, 7, 10, '2026-12-16 11:53:00', 240000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VNPay', True),
(280, 28, 9, '2026-12-18 17:15:00', 294000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'VNPay', True),
(281, 18, 12, '2026-12-19 13:02:00', 1665000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(282, 9, 3, '2026-12-19 20:33:00', 560000.00, 4, N'54 Điện Biên Phủ, Phường 25, Bình Thạnh, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(283, 4, 2, '2026-12-20 11:22:00', 180000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(284, 22, 2, '2026-12-20 14:30:00', 255000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(285, 3, 10, '2026-12-21 14:55:00', 638000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(286, 14, 9, '2026-12-21 16:46:00', 1695000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(287, 5, 2, '2026-12-23 14:35:00', 690000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, N'SALE10', 30000.00, N'ChuyenKhoan', True),
(288, 9, 2, '2026-12-23 17:31:00', 820000.00, 4, N'210 Quang Trung, Phường 10, Gò Vấp, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(289, 27, 5, '2026-12-25 13:59:00', 360000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(290, 19, 1, '2026-12-26 11:05:00', 15900000.00, 4, N'24 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM', True, N'VIPMEMBER', 100000.00, N'VietQR', True),
(291, 6, 8, '2026-12-27 12:54:00', 570000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'ChuyenKhoan', True),
(292, 22, 12, '2026-12-27 17:02:00', 950000.00, 4, N'78 Nguyễn Thị Thập, Tân Phú, Quận 7, TP.HCM', True, NULL, 0.00, N'VietQR', True),
(293, 28, 7, '2026-12-27 17:27:00', 1740000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(294, 30, 11, '2026-12-27 19:21:00', 178000.00, 4, N'125 Lê Văn Sỹ, Phường 13, Quận 3, TP.HCM', True, NULL, 0.00, N'TienMat', True),
(295, 2, 4, '2026-12-27 20:09:00', 700000.00, 4, N'89 Võ Văn Ngân, Linh Chiểu, TP. Thủ Đức', True, NULL, 0.00, N'VietQR', True),
(296, 14, 1, '2026-12-28 16:13:00', 320000.00, 4, N'67 Kinh Dương Vương, Phường 12, Quận 6, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(297, 2, 4, '2026-12-28 17:41:00', 360000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(298, 23, 9, '2026-12-29 12:20:00', 240000.00, 4, N'110 Tạ Quang Bửu, Phường 3, Quận 8, TP.HCM', True, NULL, 0.00, N'ChuyenKhoan', True),
(299, 1, 1, '2026-12-30 12:41:00', 540000.00, 4, N'332 Cộng Hòa, Phường 13, Tân Bình, TP.HCM', True, N'SALE10', 30000.00, N'VietQR', True),
(300, 24, 10, '2026-12-31 14:38:00', 255000.00, 4, N'45/12 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, TP.HCM', True, NULL, 0.00, N'VietQR', True);
SET IDENTITY_INSERT [dbo].[tblHoaDon] OFF;
GO

-- CHI TIẾT HÓA ĐƠN SẢN PHẨM (tblChiTietHoaDon)
INSERT INTO [dbo].[tblChiTietHoaDon] ([MaHD], [MaSP], [SoLuong], [GiaBan]) VALUES
(1, 2, 1, 12000000.00),
(2, 26, 3, 110000.00),
(3, 5, 2, 350000.00),
(3, 7, 1, 80000.00),
(3, 13, 3, 450000.00),
(4, 9, 2, 40000.00),
(4, 17, 1, 85000.00),
(5, 4, 1, 9500000.00),
(6, 10, 1, 95000.00),
(6, 23, 2, 120000.00),
(6, 27, 3, 650000.00),
(7, 29, 1, 14000000.00),
(8, 26, 3, 110000.00),
(9, 23, 3, 120000.00),
(9, 26, 3, 110000.00),
(10, 9, 3, 40000.00),
(10, 15, 2, 150000.00),
(11, 6, 1, 18000.00),
(11, 20, 2, 120000.00),
(11, 27, 2, 650000.00),
(12, 7, 1, 80000.00),
(12, 23, 2, 120000.00),
(12, 24, 2, 350000.00),
(13, 7, 2, 80000.00),
(13, 9, 1, 40000.00),
(14, 15, 1, 150000.00),
(14, 28, 3, 180000.00),
(15, 9, 3, 40000.00),
(16, 5, 2, 350000.00),
(17, 10, 1, 95000.00),
(17, 13, 1, 450000.00),
(17, 15, 3, 150000.00),
(18, 5, 1, 350000.00),
(18, 23, 2, 120000.00),
(18, 28, 2, 180000.00),
(19, 25, 3, 95000.00),
(20, 5, 3, 350000.00),
(20, 7, 2, 80000.00),
(20, 17, 2, 85000.00),
(21, 7, 3, 80000.00),
(21, 10, 2, 95000.00),
(21, 15, 2, 150000.00),
(22, 6, 3, 18000.00),
(23, 7, 3, 80000.00),
(23, 15, 2, 150000.00),
(23, 20, 1, 120000.00),
(24, 9, 3, 40000.00),
(25, 18, 1, 250000.00),
(25, 20, 2, 120000.00),
(26, 7, 1, 80000.00),
(26, 17, 3, 85000.00),
(26, 23, 2, 120000.00),
(27, 18, 1, 250000.00),
(28, 8, 2, 120000.00),
(28, 15, 3, 150000.00),
(29, 8, 2, 120000.00),
(29, 20, 1, 120000.00),
(29, 23, 1, 120000.00),
(30, 4, 1, 9500000.00),
(31, 17, 3, 85000.00),
(32, 13, 3, 450000.00),
(32, 15, 2, 150000.00),
(33, 8, 2, 120000.00),
(33, 18, 1, 250000.00),
(33, 27, 2, 650000.00),
(34, 9, 2, 40000.00),
(35, 15, 1, 150000.00),
(35, 24, 3, 350000.00),
(35, 27, 1, 650000.00),
(36, 18, 1, 250000.00),
(36, 20, 1, 120000.00),
(36, 26, 2, 110000.00),
(37, 15, 2, 150000.00),
(37, 18, 3, 250000.00),
(37, 28, 3, 180000.00),
(38, 20, 2, 120000.00),
(38, 26, 1, 110000.00),
(39, 15, 2, 150000.00),
(39, 26, 2, 110000.00),
(40, 13, 3, 450000.00),
(41, 9, 1, 40000.00),
(41, 27, 1, 650000.00),
(42, 6, 1, 18000.00),
(42, 18, 3, 250000.00),
(42, 23, 3, 120000.00),
(43, 6, 2, 18000.00),
(43, 18, 1, 250000.00),
(43, 24, 3, 350000.00),
(44, 3, 1, 8000000.00),
(45, 20, 1, 120000.00),
(46, 7, 3, 80000.00),
(46, 24, 2, 350000.00),
(46, 25, 3, 95000.00),
(47, 27, 2, 650000.00),
(48, 12, 1, 8000000.00),
(49, 13, 1, 450000.00),
(50, 13, 2, 450000.00),
(51, 9, 2, 40000.00),
(51, 18, 3, 250000.00),
(51, 23, 2, 120000.00);
INSERT INTO [dbo].[tblChiTietHoaDon] ([MaHD], [MaSP], [SoLuong], [GiaBan]) VALUES
(52, 5, 3, 350000.00),
(52, 25, 2, 95000.00),
(52, 27, 3, 650000.00),
(53, 10, 1, 95000.00),
(53, 27, 1, 650000.00),
(54, 14, 1, 12000000.00),
(55, 15, 1, 150000.00),
(55, 26, 3, 110000.00),
(56, 9, 1, 40000.00),
(56, 28, 2, 180000.00),
(57, 9, 2, 40000.00),
(57, 13, 1, 450000.00),
(58, 8, 3, 120000.00),
(58, 20, 2, 120000.00),
(58, 28, 1, 180000.00),
(59, 6, 1, 18000.00),
(59, 25, 3, 95000.00),
(60, 27, 2, 650000.00),
(60, 28, 1, 180000.00),
(61, 8, 1, 120000.00),
(61, 26, 3, 110000.00),
(61, 27, 3, 650000.00),
(62, 11, 1, 15000000.00),
(63, 2, 1, 12000000.00),
(64, 30, 1, 16000000.00),
(65, 5, 3, 350000.00),
(65, 8, 2, 120000.00),
(65, 15, 2, 150000.00),
(66, 7, 3, 80000.00),
(66, 9, 2, 40000.00),
(67, 9, 3, 40000.00),
(67, 13, 3, 450000.00),
(68, 17, 1, 85000.00),
(68, 18, 1, 250000.00),
(69, 7, 1, 80000.00),
(69, 8, 3, 120000.00),
(69, 20, 2, 120000.00),
(70, 13, 3, 450000.00),
(70, 28, 2, 180000.00),
(71, 13, 3, 450000.00),
(71, 20, 1, 120000.00),
(71, 23, 3, 120000.00),
(72, 9, 1, 40000.00),
(72, 25, 3, 95000.00),
(72, 27, 3, 650000.00),
(73, 7, 3, 80000.00),
(73, 10, 2, 95000.00),
(73, 15, 1, 150000.00),
(74, 10, 1, 95000.00),
(74, 13, 2, 450000.00),
(75, 18, 3, 250000.00),
(75, 26, 3, 110000.00),
(76, 8, 1, 120000.00),
(76, 27, 3, 650000.00),
(77, 4, 1, 9500000.00),
(78, 9, 3, 40000.00),
(78, 20, 1, 120000.00),
(78, 23, 2, 120000.00),
(79, 13, 3, 450000.00),
(80, 6, 1, 18000.00),
(80, 8, 1, 120000.00),
(80, 20, 3, 120000.00),
(81, 19, 1, 10000000.00),
(82, 23, 3, 120000.00),
(83, 10, 2, 95000.00),
(84, 13, 1, 450000.00),
(84, 18, 1, 250000.00),
(84, 24, 1, 350000.00),
(85, 17, 1, 85000.00),
(86, 19, 1, 10000000.00),
(87, 13, 3, 450000.00),
(88, 5, 1, 350000.00),
(88, 13, 3, 450000.00),
(88, 23, 1, 120000.00),
(89, 24, 3, 350000.00),
(90, 14, 1, 12000000.00),
(91, 18, 1, 250000.00),
(91, 23, 1, 120000.00),
(91, 28, 3, 180000.00),
(92, 9, 3, 40000.00),
(92, 17, 2, 85000.00),
(92, 27, 3, 650000.00),
(93, 19, 1, 10000000.00),
(94, 6, 3, 18000.00),
(95, 5, 1, 350000.00),
(95, 15, 1, 150000.00),
(96, 7, 1, 80000.00),
(96, 10, 2, 95000.00),
(96, 18, 3, 250000.00),
(97, 13, 2, 450000.00),
(98, 5, 3, 350000.00),
(98, 25, 2, 95000.00),
(98, 28, 2, 180000.00),
(99, 6, 3, 18000.00),
(99, 13, 1, 450000.00),
(99, 28, 2, 180000.00),
(100, 6, 2, 18000.00),
(100, 7, 1, 80000.00),
(101, 10, 3, 95000.00),
(101, 18, 3, 250000.00);
INSERT INTO [dbo].[tblChiTietHoaDon] ([MaHD], [MaSP], [SoLuong], [GiaBan]) VALUES
(101, 23, 1, 120000.00),
(102, 15, 3, 150000.00),
(103, 8, 3, 120000.00),
(103, 15, 3, 150000.00),
(103, 26, 2, 110000.00),
(104, 2, 1, 12000000.00),
(105, 6, 2, 18000.00),
(105, 23, 1, 120000.00),
(106, 15, 3, 150000.00),
(106, 20, 1, 120000.00),
(107, 18, 2, 250000.00),
(108, 7, 1, 80000.00),
(108, 23, 3, 120000.00),
(109, 23, 3, 120000.00),
(110, 5, 2, 350000.00),
(110, 15, 3, 150000.00),
(110, 17, 2, 85000.00),
(111, 8, 1, 120000.00),
(111, 17, 1, 85000.00),
(112, 7, 2, 80000.00),
(113, 9, 3, 40000.00),
(113, 27, 1, 650000.00),
(114, 13, 3, 450000.00),
(114, 20, 3, 120000.00),
(114, 24, 3, 350000.00),
(115, 28, 1, 180000.00),
(116, 9, 3, 40000.00),
(116, 26, 2, 110000.00),
(117, 6, 2, 18000.00),
(117, 24, 1, 350000.00),
(118, 20, 2, 120000.00),
(118, 23, 2, 120000.00),
(118, 24, 2, 350000.00),
(119, 8, 2, 120000.00),
(120, 6, 3, 18000.00),
(120, 18, 3, 250000.00),
(121, 7, 2, 80000.00),
(121, 17, 3, 85000.00),
(122, 8, 3, 120000.00),
(122, 24, 1, 350000.00),
(122, 25, 2, 95000.00),
(123, 10, 3, 95000.00),
(123, 24, 3, 350000.00),
(124, 9, 2, 40000.00),
(125, 5, 3, 350000.00),
(125, 8, 2, 120000.00),
(125, 20, 3, 120000.00),
(126, 9, 1, 40000.00),
(126, 10, 1, 95000.00),
(127, 17, 3, 85000.00),
(127, 20, 3, 120000.00),
(127, 27, 2, 650000.00),
(128, 5, 1, 350000.00),
(128, 24, 1, 350000.00),
(129, 6, 3, 18000.00),
(129, 26, 1, 110000.00),
(130, 18, 2, 250000.00),
(131, 6, 2, 18000.00),
(131, 9, 2, 40000.00),
(131, 25, 3, 95000.00),
(132, 10, 1, 95000.00),
(133, 7, 1, 80000.00),
(133, 25, 2, 95000.00),
(134, 7, 1, 80000.00),
(134, 27, 3, 650000.00),
(135, 6, 2, 18000.00),
(135, 8, 1, 120000.00),
(136, 25, 1, 95000.00),
(136, 26, 3, 110000.00),
(137, 5, 3, 350000.00),
(137, 6, 3, 18000.00),
(138, 10, 3, 95000.00),
(138, 15, 2, 150000.00),
(139, 26, 3, 110000.00),
(140, 5, 3, 350000.00),
(140, 8, 1, 120000.00),
(140, 28, 2, 180000.00),
(141, 8, 1, 120000.00),
(141, 26, 2, 110000.00),
(142, 9, 2, 40000.00),
(142, 28, 1, 180000.00),
(143, 18, 3, 250000.00),
(144, 23, 2, 120000.00),
(145, 9, 2, 40000.00),
(145, 17, 3, 85000.00),
(145, 26, 2, 110000.00),
(146, 10, 3, 95000.00),
(146, 24, 3, 350000.00),
(147, 8, 3, 120000.00),
(148, 6, 1, 18000.00),
(148, 27, 1, 650000.00),
(149, 7, 2, 80000.00),
(149, 25, 2, 95000.00),
(149, 28, 1, 180000.00),
(150, 13, 2, 450000.00),
(150, 20, 2, 120000.00),
(150, 27, 3, 650000.00),
(151, 27, 3, 650000.00),
(152, 6, 2, 18000.00),
(152, 10, 2, 95000.00);
INSERT INTO [dbo].[tblChiTietHoaDon] ([MaHD], [MaSP], [SoLuong], [GiaBan]) VALUES
(153, 18, 3, 250000.00),
(153, 23, 3, 120000.00),
(154, 6, 2, 18000.00),
(154, 20, 2, 120000.00),
(154, 24, 2, 350000.00),
(155, 17, 3, 85000.00),
(155, 27, 3, 650000.00),
(156, 6, 1, 18000.00),
(157, 15, 2, 150000.00),
(157, 17, 2, 85000.00),
(157, 26, 2, 110000.00),
(158, 6, 1, 18000.00),
(159, 13, 2, 450000.00),
(160, 8, 1, 120000.00),
(160, 24, 3, 350000.00),
(161, 5, 1, 350000.00),
(161, 6, 3, 18000.00),
(162, 18, 3, 250000.00),
(163, 25, 1, 95000.00),
(164, 30, 1, 16000000.00),
(165, 5, 3, 350000.00),
(165, 27, 1, 650000.00),
(166, 9, 3, 40000.00),
(166, 18, 2, 250000.00),
(167, 13, 1, 450000.00),
(167, 15, 1, 150000.00),
(167, 23, 1, 120000.00),
(168, 7, 2, 80000.00),
(168, 27, 1, 650000.00),
(169, 13, 2, 450000.00),
(169, 20, 2, 120000.00),
(169, 27, 3, 650000.00),
(170, 24, 1, 350000.00),
(170, 25, 3, 95000.00),
(171, 18, 3, 250000.00),
(172, 9, 1, 40000.00),
(172, 13, 2, 450000.00),
(172, 25, 3, 95000.00),
(173, 17, 2, 85000.00),
(173, 24, 2, 350000.00),
(173, 27, 1, 650000.00),
(174, 6, 3, 18000.00),
(174, 18, 2, 250000.00),
(175, 13, 3, 450000.00),
(175, 25, 2, 95000.00),
(176, 17, 1, 85000.00),
(176, 24, 1, 350000.00),
(177, 5, 2, 350000.00),
(177, 7, 2, 80000.00),
(177, 9, 1, 40000.00),
(178, 6, 2, 18000.00),
(178, 24, 1, 350000.00),
(178, 28, 2, 180000.00),
(179, 9, 2, 40000.00),
(179, 17, 1, 85000.00),
(179, 26, 3, 110000.00),
(180, 9, 1, 40000.00),
(180, 23, 3, 120000.00),
(180, 25, 3, 95000.00),
(181, 25, 3, 95000.00),
(181, 26, 3, 110000.00),
(182, 5, 1, 350000.00),
(182, 9, 2, 40000.00),
(182, 18, 1, 250000.00),
(183, 5, 3, 350000.00),
(183, 25, 3, 95000.00),
(184, 5, 2, 350000.00),
(184, 8, 1, 120000.00),
(184, 15, 2, 150000.00),
(185, 7, 1, 80000.00),
(185, 25, 1, 95000.00),
(185, 26, 1, 110000.00),
(186, 24, 1, 350000.00),
(186, 28, 3, 180000.00),
(187, 17, 3, 85000.00),
(188, 7, 1, 80000.00),
(188, 17, 2, 85000.00),
(188, 28, 3, 180000.00),
(189, 11, 1, 15000000.00),
(190, 5, 2, 350000.00),
(190, 10, 2, 95000.00),
(190, 27, 3, 650000.00),
(191, 13, 3, 450000.00),
(192, 25, 3, 95000.00),
(193, 25, 2, 95000.00),
(193, 26, 1, 110000.00),
(194, 17, 2, 85000.00),
(195, 25, 1, 95000.00),
(195, 26, 3, 110000.00),
(196, 8, 2, 120000.00),
(196, 26, 2, 110000.00),
(197, 6, 3, 18000.00),
(197, 8, 3, 120000.00),
(197, 13, 1, 450000.00),
(198, 10, 3, 95000.00),
(199, 18, 3, 250000.00),
(200, 26, 3, 110000.00),
(201, 25, 3, 95000.00),
(201, 27, 3, 650000.00),
(202, 20, 3, 120000.00);
INSERT INTO [dbo].[tblChiTietHoaDon] ([MaHD], [MaSP], [SoLuong], [GiaBan]) VALUES
(203, 7, 3, 80000.00),
(203, 10, 1, 95000.00),
(203, 18, 1, 250000.00),
(204, 5, 3, 350000.00),
(204, 17, 2, 85000.00),
(204, 20, 1, 120000.00),
(205, 3, 1, 8000000.00),
(206, 20, 2, 120000.00),
(207, 5, 2, 350000.00),
(207, 26, 1, 110000.00),
(208, 5, 1, 350000.00),
(208, 13, 2, 450000.00),
(208, 25, 3, 95000.00),
(209, 6, 3, 18000.00),
(210, 27, 3, 650000.00),
(211, 12, 1, 8000000.00),
(212, 9, 1, 40000.00),
(212, 13, 3, 450000.00),
(212, 27, 2, 650000.00),
(213, 9, 2, 40000.00),
(214, 20, 3, 120000.00),
(214, 25, 2, 95000.00),
(215, 8, 1, 120000.00),
(215, 18, 1, 250000.00),
(216, 15, 1, 150000.00),
(216, 28, 1, 180000.00),
(217, 8, 3, 120000.00),
(217, 9, 3, 40000.00),
(217, 26, 3, 110000.00),
(218, 20, 2, 120000.00),
(219, 9, 2, 40000.00),
(219, 10, 3, 95000.00),
(219, 15, 2, 150000.00),
(220, 18, 3, 250000.00),
(220, 24, 1, 350000.00),
(220, 27, 1, 650000.00),
(221, 20, 3, 120000.00),
(221, 24, 3, 350000.00),
(221, 26, 3, 110000.00),
(222, 25, 2, 95000.00),
(222, 27, 2, 650000.00),
(223, 27, 2, 650000.00),
(224, 12, 1, 8000000.00),
(225, 27, 1, 650000.00),
(226, 3, 1, 8000000.00),
(227, 9, 2, 40000.00),
(227, 10, 3, 95000.00),
(228, 24, 2, 350000.00),
(229, 8, 2, 120000.00),
(230, 9, 3, 40000.00),
(230, 10, 3, 95000.00),
(230, 17, 3, 85000.00),
(231, 6, 1, 18000.00),
(231, 8, 3, 120000.00),
(231, 13, 2, 450000.00),
(232, 9, 2, 40000.00),
(232, 26, 3, 110000.00),
(233, 14, 1, 12000000.00),
(234, 13, 1, 450000.00),
(234, 18, 2, 250000.00),
(234, 20, 3, 120000.00),
(235, 15, 3, 150000.00),
(235, 17, 2, 85000.00),
(235, 26, 2, 110000.00),
(236, 18, 1, 250000.00),
(237, 8, 1, 120000.00),
(238, 23, 1, 120000.00),
(239, 8, 1, 120000.00),
(239, 25, 3, 95000.00),
(240, 24, 1, 350000.00),
(241, 23, 3, 120000.00),
(242, 7, 2, 80000.00),
(242, 23, 2, 120000.00),
(243, 8, 1, 120000.00),
(243, 24, 2, 350000.00),
(243, 27, 1, 650000.00),
(244, 18, 1, 250000.00),
(245, 16, 1, 7000000.00),
(246, 8, 2, 120000.00),
(247, 13, 3, 450000.00),
(248, 27, 3, 650000.00),
(249, 28, 1, 180000.00),
(250, 23, 1, 120000.00),
(251, 24, 1, 350000.00),
(252, 5, 2, 350000.00),
(252, 23, 2, 120000.00),
(253, 5, 2, 350000.00),
(253, 20, 1, 120000.00),
(254, 8, 2, 120000.00),
(255, 13, 3, 450000.00),
(255, 27, 3, 650000.00),
(256, 5, 3, 350000.00),
(257, 10, 1, 95000.00),
(257, 18, 1, 250000.00),
(258, 24, 1, 350000.00),
(258, 28, 1, 180000.00),
(259, 17, 1, 85000.00),
(259, 26, 3, 110000.00),
(259, 28, 3, 180000.00),
(260, 15, 1, 150000.00);
INSERT INTO [dbo].[tblChiTietHoaDon] ([MaHD], [MaSP], [SoLuong], [GiaBan]) VALUES
(260, 25, 2, 95000.00),
(260, 26, 1, 110000.00),
(261, 6, 3, 18000.00),
(261, 25, 3, 95000.00),
(262, 5, 2, 350000.00),
(262, 27, 2, 650000.00),
(262, 28, 3, 180000.00),
(263, 18, 1, 250000.00),
(263, 27, 1, 650000.00),
(264, 5, 1, 350000.00),
(264, 6, 3, 18000.00),
(264, 18, 2, 250000.00),
(265, 7, 3, 80000.00),
(265, 20, 3, 120000.00),
(265, 28, 3, 180000.00),
(266, 15, 1, 150000.00),
(266, 23, 2, 120000.00),
(267, 17, 2, 85000.00),
(268, 15, 1, 150000.00),
(269, 9, 1, 40000.00),
(269, 23, 3, 120000.00),
(269, 27, 1, 650000.00),
(270, 18, 3, 250000.00),
(270, 23, 2, 120000.00),
(270, 24, 3, 350000.00),
(271, 25, 2, 95000.00),
(272, 8, 2, 120000.00),
(272, 15, 3, 150000.00),
(273, 24, 1, 350000.00),
(273, 27, 2, 650000.00),
(274, 18, 3, 250000.00),
(275, 10, 1, 95000.00),
(276, 23, 2, 120000.00),
(276, 28, 1, 180000.00),
(277, 7, 2, 80000.00),
(277, 23, 1, 120000.00),
(277, 25, 1, 95000.00),
(278, 16, 1, 7000000.00),
(279, 7, 2, 80000.00),
(279, 9, 2, 40000.00),
(280, 6, 3, 18000.00),
(280, 8, 2, 120000.00),
(281, 5, 3, 350000.00),
(281, 17, 3, 85000.00),
(281, 28, 2, 180000.00),
(282, 9, 2, 40000.00),
(282, 15, 1, 150000.00),
(282, 26, 3, 110000.00),
(283, 28, 1, 180000.00),
(284, 17, 3, 85000.00),
(285, 6, 1, 18000.00),
(285, 8, 1, 120000.00),
(285, 18, 2, 250000.00),
(286, 10, 3, 95000.00),
(286, 26, 1, 110000.00),
(286, 27, 2, 650000.00),
(287, 8, 1, 120000.00),
(287, 23, 2, 120000.00),
(287, 28, 2, 180000.00),
(288, 15, 3, 150000.00),
(288, 18, 1, 250000.00),
(288, 23, 1, 120000.00),
(289, 20, 3, 120000.00),
(290, 30, 1, 16000000.00),
(291, 5, 1, 350000.00),
(291, 26, 2, 110000.00),
(292, 7, 1, 80000.00),
(292, 26, 3, 110000.00),
(292, 28, 3, 180000.00),
(293, 18, 2, 250000.00),
(293, 24, 3, 350000.00),
(293, 25, 2, 95000.00),
(294, 6, 1, 18000.00),
(294, 7, 2, 80000.00),
(295, 5, 2, 350000.00),
(296, 7, 1, 80000.00),
(296, 20, 2, 120000.00),
(297, 28, 2, 180000.00),
(298, 23, 2, 120000.00),
(299, 13, 1, 450000.00),
(299, 20, 1, 120000.00),
(300, 17, 3, 85000.00);
GO

INSERT INTO [dbo].[tblHoaDonDichVu] ([MaKH], [MaNV], [NgaySuDung], [TongTien], [GhiChu]) VALUES
(1, 3, GETDATE(), 150000, N'Tắm gội cho chó Poodle'),
(2, 3, GETDATE(), 200000, N'Cắt tỉa lông cho Corgi'),
(3, 3, GETDATE(), 100000, N'Khám tổng quát cho mèo'),
(4, 3, GETDATE(), 250000, N'Tiêm phòng dại'),
(5, 3, GETDATE(), 300000, N'Chăm sóc sau phẫu thuật'),
(6, 3, GETDATE(), 400000, N'Khách sạn thú cưng 2 ngày'),
(7, 3, GETDATE(), 100000, N'Ve sinh tai & răng'),
(8, 3, GETDATE(), 120000, N'Cạo lông mùa hè'),
(9, 3, GETDATE(), 80000, N'Tư vấn dinh dưỡng'),
(10, 3, GETDATE(), 200000, N'Khám da liễu'),
(11, 4, GETDATE(), 180000, N'Massage thư giãn cho chó Alaska'),
(12, 5, GETDATE(), 100000, N'Gỡ rối lông cho mèo Ba Tư'),
(13, 6, GETDATE(), 90000, N'Chăm sóc móng cho Poodle Tiny'),
(14, 7, GETDATE(), 70000, N'Xịt khử mùi cho mèo Anh lông ngắn'),
(15, 8, GETDATE(), 250000, N'Chụp ảnh thú cưng tại studio'),
(16, 9, GETDATE(), 300000, N'Đào tạo cơ bản cho chó Corgi'),
(17, 10, GETDATE(), 50000, N'Gửi thú cưng theo giờ'),
(18, 1, GETDATE(), 350000, N'Chăm sóc thú cưng cao tuổi'),
(19, 2, GETDATE(), 280000, N'Xét nghiệm máu cho mèo Munchkin'),
(20, 3, GETDATE(), 120000, N'Vệ sinh tuyến hôi cho chó Bull Pháp'),
(21, 4, GETDATE(), 150000, N'Tắm gội cho mèo Sphynx'),
(22, 5, GETDATE(), 200000, N'Cắt tỉa lông cho chó Husky'),
(23, 6, GETDATE(), 100000, N'Khám tổng quát cho mèo Ba Tư'),
(24, 7, GETDATE(), 250000, N'Tiêm phòng cho chó Phú Quốc'),
(25, 8, GETDATE(), 300000, N'Chăm sóc sau phẫu thuật cho mèo Anh'),
(26, 9, GETDATE(), 400000, N'Khách sạn thú cưng 3 ngày'),
(27, 10, GETDATE(), 100000, N'Ve sinh tai & răng cho chó Poodle'),
(28, 1, GETDATE(), 120000, N'Cạo lông mùa hè cho mèo Munchkin'),
(29, 2, GETDATE(), 80000, N'Tư vấn dinh dưỡng cho chó Corgi'),
(30, 3, GETDATE(), 200000, N'Khám da liễu cho mèo Sphynx');
GO

INSERT INTO [dbo].[tblChiTietHoaDonDichVu] ([MaHDDV], [MaDV], [SoLuong], [GiaDichVu]) VALUES
(1, 1, 1, 150000),
(2, 2, 1, 200000),
(3, 3, 1, 100000),
(4, 4, 1, 250000),
(5, 5, 1, 300000),
(6, 6, 1, 400000),
(7, 7, 1, 100000),
(8, 8, 1, 120000),
(9, 9, 1, 80000),
(10, 10, 1, 200000),
(11, 11, 1, 180000), 
(12, 12, 1, 100000), 
(13, 13, 1, 90000),  
(14, 14, 1, 70000),  
(15, 15, 1, 250000), 
(16, 16, 1, 300000), 
(17, 17, 1, 50000),  
(18, 18, 1, 350000), 
(19, 19, 1, 280000), 
(20, 20, 1, 120000), 
(21, 1, 1, 150000),  
(22, 2, 1, 200000),  
(23, 3, 1, 100000), 
(24, 4, 1, 250000),  
(25, 5, 1, 300000), 
(26, 6, 1, 400000), 
(27, 7, 1, 100000), 
(28, 8, 1, 120000),  
(29, 9, 1, 80000),   
(30, 10, 1, 200000); 
GO

/****** Object:  Table [dbo].[tblDatLich] ******/
CREATE TABLE [dbo].[tblDatLich](
    [MaDatLich] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaDV] [int] NULL,
    [MaKH] [int] NULL,
    [MaNV] [int] NULL, -- Bác sĩ / Nhân viên chăm sóc phụ trách
    [TenKhachHang] [nvarchar](100) NULL,
    [SoDienThoai] [nvarchar](20) NULL,
    [Email] [nvarchar](100) NULL,
    [NgayDat] [date] NULL,
    [GioDat] [time](7) NULL,
    [GhiChu] [nvarchar](500) NULL,
    [TrangThai] [nvarchar](50) NULL, -- 'Chờ xác nhận', 'Đã xác nhận', 'Hoàn thành', 'Đã hủy'
    [NgayTao] [datetime] NULL,
    CONSTRAINT [FK_tblDatLich_tblDichVu] FOREIGN KEY([MaDV]) REFERENCES [dbo].[tblDichVu] ([MaDV]),
    CONSTRAINT [FK_tblDatLich_tblKhachHang] FOREIGN KEY([MaKH]) REFERENCES [dbo].[tblKhachHang] ([MaKH]),
    CONSTRAINT [FK_tblDatLich_tblNhanVien] FOREIGN KEY([MaNV]) REFERENCES [dbo].[tblNhanVien] ([MaNV])
)
GO

INSERT INTO [dbo].[tblBinhLuan] ([MaSP], [HoTen], [NoiDung], [SoSao], [Ngay]) VALUES
(1, N'Trần Minh Anh', N'Poodle siêu dễ thương!', 5, GETDATE()),
(2, N'Nguyễn Quốc Bảo', N'Corgi rất đáng yêu, giao hàng nhanh.', 5, GETDATE()),
(3, N'Lê Hồng Cúc', N'Mèo khỏe mạnh, sạch sẽ.', 4, GETDATE()),
(4, N'Phan Văn Dũng', N'Giá hơi cao nhưng đáng tiền.', 4, GETDATE()),
(5, N'Đỗ Thị Lan', N'Thức ăn chất lượng tốt.', 5, GETDATE()),
(6, N'Trịnh Hoàng Nam', N'Mèo ăn rất thích.', 5, GETDATE()),
(7, N'Nguyễn Mỹ Hoa', N'Dây dắt bền, đẹp.', 5, GETDATE()),
(8, N'Phạm Hữu Tài', N'Áo len vừa vặn.', 4, GETDATE()),
(9, N'Đoàn Thanh Hà', N'Bóng gặm nhai vui lắm.', 5, GETDATE()),
(10, N'Ngô Văn Phúc', N'Sữa tắm thơm, dễ chịu.', 5, GETDATE()),
(11, N'Nguyễn Văn An', N'Alaska rất khỏe và thân thiện.', 5, GETDATE()),
(12, N'Trần Thị Bích', N'Mèo Anh lông ngắn dễ thương, mắt to tròn.', 5, GETDATE()),
(13, N'Lê Minh Cường', N'Thức ăn Royal Canin chất lượng cao.', 5, GETDATE()),
(14, N'Phạm Thu Hà', N'Poodle Tiny thông minh, dễ huấn luyện.', 5, GETDATE()),
(15, N'Hoàng Văn Dũng', N'Cát vệ sinh khử mùi tốt.', 4, GETDATE()),
(16, N'Vũ Thị Lan', N'Chó Phú Quốc xoáy lưng đẹp, rất khỏe.', 5, GETDATE()),
(17, N'Đặng Quang Huy', N'Pate Whiskas thơm, mèo ăn ngon.', 5, GETDATE()),
(18, N'Ngô Thị Mai', N'Vòng cổ da mềm, dễ điều chỉnh.', 4, GETDATE()),
(19, N'Bùi Văn Tài', N'Mèo Ba Tư lông dày, mặt tịt đúng chuẩn.', 5, GETDATE()),
(20, N'Lý Thị Hương', N'Xương gặm giúp chó sạch răng.', 5, GETDATE()),
(21, N'Tạ Minh Tuấn', N'Bull Pháp mặt xệ siêu đáng yêu.', 5, GETDATE()),
(22, N'Nguyễn Thị Kim Yến', N'Mèo Munchkin chân ngắn cực kỳ dễ thương.', 5, GETDATE()),
(23, N'Phạm Văn Khánh', N'Thức ăn Me-O hợp với mèo nhà mình.', 4, GETDATE()),
(24, N'Lê Thị Ngọc Mai', N'Balo vận chuyển tiện lợi, thoáng khí.', 5, GETDATE()),
(25, N'Hoàng Minh Nhật', N'Bàn chải lông dễ dùng, mèo thích.', 5, GETDATE()),
(26, N'Nguyễn Thị Hồng Nhung', N'Nước hoa PetScent thơm nhẹ, không kích ứng.', 5, GETDATE()),
(27, N'Đinh Văn Lâm', N'Chuồng lưới chắc chắn, dễ gấp gọn.', 5, GETDATE()),
(28, N'Võ Thị Thanh Trúc', N'Vitamin PetVita giúp thú cưng khỏe hơn.', 5, GETDATE()),
(29, N'Trần Quốc Huy', N'Husky năng động, rất thông minh.', 5, GETDATE()),
(30, N'Nguyễn Thị Diễm My', N'Mèo Sphynx không lông, phù hợp người dị ứng.', 5, GETDATE());
GO

-- ==================================================================================
-- BỔ SUNG CÁC CHỨC NĂNG:
--   PHẦN 1: QUẢN LÝ HỒ SƠ CHỦ NUÔI
--   PHẦN 2: QUẢN LÝ HỒ SƠ THÚ CƯNG
--   PHẦN 3: QUẢN LÝ DỊCH VỤ CHĂM SÓC THÚ CƯNG
-- ==================================================================================

-- ----------------------------------------------------------------------------------
-- 1. BẢNG QUẢN LÝ HỒ SƠ CHỦ NUÔI (tblChuNuoi)
-- ----------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[tblChuNuoi]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tblChuNuoi](
        [MaChuNuoi] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [MaKH] [int] NULL, -- Liên kết với tài khoản hệ thống khách hàng nếu có
        [HoTenChuNuoi] [nvarchar](100) NOT NULL,
        [SoDienThoai] [varchar](20) NOT NULL,
        [Email] [varchar](100) NULL,
        [SoCCCD] [varchar](20) NULL,
        [DiaChi] [nvarchar](255) NULL,
        [GioiTinh] [nvarchar](10) NULL,
        [NgaySinh] [date] NULL,
        [SoDienThoaiKhanCap] [varchar](20) NULL, -- Liên lạc khẩn cấp khi thú cưng có sự cố
        [NguoiLienHeKhanCap] [nvarchar](100) NULL,
        [LoaiChuNuoi] [nvarchar](50) NULL DEFAULT N'Tiêu chuẩn', -- 'Tiêu chuẩn', 'Thân thiết', 'VIP', 'VVIP'
        [DiemTichLuy] [int] NULL DEFAULT 0,
        [NgayDangKy] [datetime] NULL DEFAULT GETDATE(),
        [GhiChu] [nvarchar](500) NULL,
        [TrangThai] [nvarchar](50) NULL DEFAULT N'Đang hoạt động', -- 'Đang hoạt động', 'Tạm khóa'
        CONSTRAINT [FK_tblChuNuoi_tblKhachHang] FOREIGN KEY([MaKH]) REFERENCES [dbo].[tblKhachHang] ([MaKH])
    );
END
GO

-- ----------------------------------------------------------------------------------
-- 2. BẢNG QUẢN LÝ HỒ SƠ THÚ CƯNG (tblHoSoThuCung)
-- ----------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[tblHoSoThuCung]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tblHoSoThuCung](
        [MaThuCung] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [MaChuNuoi] [int] NOT NULL, -- FK liên kết đến Chủ nuôi
        [TenThuCung] [nvarchar](100) NOT NULL,
        [LoaiThuCung] [nvarchar](50) NOT NULL, -- 'Chó', 'Mèo', 'Thỏ', 'Chuột cảnh', v.v.
        [GiongLoai] [nvarchar](100) NOT NULL,  -- 'Poodle', 'Corgi', 'Mèo Anh lông ngắn', 'Alaska', v.v.
        [GioiTinh] [nvarchar](10) NOT NULL,    -- 'Đực', 'Cái'
        [TrietSan] [bit] NULL DEFAULT 0,       -- 0: Chưa triệt sản, 1: Đã triệt sản
        [NgaySinh] [date] NULL,
        [TuoiThang] [int] NULL,                -- Tuổi tính theo tháng
        [MauSac] [nvarchar](50) NULL,
        [CanNang] [decimal](5, 2) NULL,        -- Đơn vị kg (ví dụ: 4.50 kg)
        [DacDiemNhanDang] [nvarchar](255) NULL, -- Đốm mắt, xoáy lưng, đuôi cộc, tai cụp...
        [SoMicrochip] [varchar](50) NULL,      -- Mã chip định danh thú cưng điện tử
        [TinhTrangSucKhoeHienTai] [nvarchar](max) NULL,
        [TienSuBenhLy] [nvarchar](max) NULL,
        [DiUngThuocThucAn] [nvarchar](max) NULL,
        [LichSuTiemChung] [nvarchar](max) NULL,
        [HinhAnh] [nvarchar](255) NULL,
        [NgayTaoHoSo] [datetime] NULL DEFAULT GETDATE(),
        [TrangThai] [nvarchar](50) NULL DEFAULT N'Đang nuôi', -- 'Đang nuôi', 'Đã chuyển nhượng', 'Đã mất', 'Đang điều trị'
        [GhiChu] [nvarchar](max) NULL,
        CONSTRAINT [FK_tblHoSoThuCung_tblChuNuoi] FOREIGN KEY([MaChuNuoi]) REFERENCES [dbo].[tblChuNuoi] ([MaChuNuoi]) ON DELETE CASCADE
    );
END
GO

-- ----------------------------------------------------------------------------------
-- 3. BẢNG SỔ THEO DÕI SỨC KHỎE & TIÊM CHỦNG THÚ CƯNG (tblSoTheoDoiSucKhoe)
-- ----------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[tblSoTheoDoiSucKhoe]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tblSoTheoDoiSucKhoe](
        [MaSoSucKhoe] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [MaThuCung] [int] NOT NULL,
        [NgayKiemTra] [datetime] NULL DEFAULT GETDATE(),
        [CanNang] [decimal](5, 2) NULL,
        [ThanNhiet] [decimal](4, 1) NULL, -- Thân nhiệt độ C (ví dụ: 38.5)
        [LoaiKham] [nvarchar](100) NULL,  -- 'Tiêm phòng vắc xin', 'Tẩy giun', 'Khám định kỳ', 'Khám bệnh', 'Tái khám'
        [TenVacXinThuoc] [nvarchar](200) NULL, -- 'Vắc xin 7 bệnh Pfizer', 'Vắc xin Dại Rabisin', 'Drontal'
        [BacSiPhuTrach] [nvarchar](100) NULL,
        [KetLuanVaDanDo] [nvarchar](max) NULL,
        [NgayHenTaiKham] [date] NULL,
        CONSTRAINT [FK_tblSoTheoDoiSucKhoe_tblHoSoThuCung] FOREIGN KEY([MaThuCung]) REFERENCES [dbo].[tblHoSoThuCung] ([MaThuCung]) ON DELETE CASCADE
    );
END
GO

-- ----------------------------------------------------------------------------------
-- 4. BẢNG DANH MỤC DỊCH VỤ CHĂM SÓC THÚ CƯNG (tblDichVuChamSoc)
-- ----------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[tblDichVuChamSoc]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tblDichVuChamSoc](
        [MaDVCS] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [TenDichVu] [nvarchar](200) NOT NULL,
        [NhomDichVu] [nvarchar](100) NOT NULL, -- 'Spa - Grooming', 'Thú y & Khám chữa', 'Khách sạn thú cưng', 'Chăm sóc cao cấp'
        [DoiTuongApDung] [nvarchar](100) NULL, -- 'Chó < 5kg', 'Chó 5-10kg', 'Chó > 10kg', 'Mèo mọi lứa tuổi', 'Tất cả'
        [GiaDichVu] [decimal](18, 2) NOT NULL,
        [ThoiGianThucHien] [int] NULL, -- Thời gian ước tính (phút)
        [MoTaChiTiet] [nvarchar](max) NULL,
        [HinhAnhDichVu] [nvarchar](255) NULL,
        [TrangThai] [nvarchar](50) NULL DEFAULT N'Đang cung cấp' -- 'Đang cung cấp', 'Tạm ngưng'
    );
END
GO

-- ----------------------------------------------------------------------------------
-- 5. BẢNG PHIẾU DỊCH VỤ TIẾP NHẬN & CHĂM SÓC THÚ CƯNG (tblPhieuDichVuChamSoc)
-- ----------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[tblPhieuDichVuChamSoc]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tblPhieuDichVuChamSoc](
        [MaPhieuDV] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [SoPhieu] [varchar](30) NOT NULL UNIQUE, -- 'PDV-2026-0001'
        [MaThuCung] [int] NOT NULL,
        [MaChuNuoi] [int] NOT NULL,
        [MaNVTiepNhan] [int] NULL, -- Lễ tân/nhân viên nhận pet
        [MaNVThucHien] [int] NULL, -- Kỹ thuật viên Spa / Bác sĩ thú y trực tiếp thực hiện
        [NgayTiepNhan] [datetime] NULL DEFAULT GETDATE(),
        [NgayHenTra] [datetime] NULL,
        [NgayTraThucTe] [datetime] NULL,
        [CanNangTiepNhan] [decimal](5, 2) NULL,
        [TinhTrangBanDau] [nvarchar](max) NULL, -- Ghi nhận da, lông, mắt mũi, ve rận khi nhận pet
        [YeuCauCuaChuNuoi] [nvarchar](max) NULL, -- Yêu cầu cắt tỉa kiểu gì, dùng sữa tắm gì
        [KetQuaChamSoc] [nvarchar](max) NULL, -- Đánh giá sau khi làm xong dịch vụ
        [TongTien] [decimal](18, 2) NULL DEFAULT 0,
        [TienGiamGia] [decimal](18, 2) NULL DEFAULT 0,
        [ThanhToan] [decimal](18, 2) NULL DEFAULT 0,
        [HinhThucThanhToan] [nvarchar](50) NULL, -- 'Tiền mặt', 'Chuyển khoản', 'Quẹt thẻ'
        [TrangThaiThanhToan] [nvarchar](50) NULL DEFAULT N'Chưa thanh toán', -- 'Chưa thanh toán', 'Đã đặt cọc', 'Đã thanh toán'
        [TrangThaiDichVu] [nvarchar](50) NULL DEFAULT N'Chờ tiếp nhận', -- 'Chờ tiếp nhận', 'Đang thực hiện', 'Hoàn thành chăm sóc', 'Đã bàn giao thú cưng', 'Đã hủy'
        [DanhGiaCuaChu] [nvarchar](max) NULL, -- Đánh giá hoặc phản hồi của chủ nuôi
        [GhiChu] [nvarchar](500) NULL,
        CONSTRAINT [FK_tblPhieuDVCS_tblThuCung] FOREIGN KEY([MaThuCung]) REFERENCES [dbo].[tblHoSoThuCung] ([MaThuCung]),
        CONSTRAINT [FK_tblPhieuDVCS_tblChuNuoi] FOREIGN KEY([MaChuNuoi]) REFERENCES [dbo].[tblChuNuoi] ([MaChuNuoi]),
        CONSTRAINT [FK_tblPhieuDVCS_tblNVTiepNhan] FOREIGN KEY([MaNVTiepNhan]) REFERENCES [dbo].[tblNhanVien] ([MaNV]),
        CONSTRAINT [FK_tblPhieuDVCS_tblNVThucHien] FOREIGN KEY([MaNVThucHien]) REFERENCES [dbo].[tblNhanVien] ([MaNV])
    );
END
GO

-- ----------------------------------------------------------------------------------
-- 6. BẢNG CHI TIẾT DỊCH VỤ CHĂM SÓC (tblChiTietDichVuChamSoc)
-- ----------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[tblChiTietDichVuChamSoc]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tblChiTietDichVuChamSoc](
        [MaChiTiet] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [MaPhieuDV] [int] NOT NULL,
        [MaDVCS] [int] NOT NULL,
        [SoLuong] [int] NULL DEFAULT 1,
        [DonGia] [decimal](18, 2) NOT NULL,
        [PhuPhi] [decimal](18, 2) NULL DEFAULT 0, -- Phụ phí nếu lông rối nặng, tính cách khó
        [ThanhTien] [decimal](18, 2) NOT NULL,
        [NhanVienPhuTrach] [nvarchar](100) NULL,
        [GhiChuChiTiet] [nvarchar](255) NULL,
        CONSTRAINT [FK_tblCTDVCS_tblPhieuDVCS] FOREIGN KEY([MaPhieuDV]) REFERENCES [dbo].[tblPhieuDichVuChamSoc] ([MaPhieuDV]) ON DELETE CASCADE,
        CONSTRAINT [FK_tblCTDVCS_tblDVCS] FOREIGN KEY([MaDVCS]) REFERENCES [dbo].[tblDichVuChamSoc] ([MaDVCS])
    );
END
GO

-- ----------------------------------------------------------------------------------
-- 7. BẢNG ĐẶT LỊCH HẸN CHĂM SÓC THÚ CƯNG (tblLichHenChamSoc)
-- ----------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[tblLichHenChamSoc]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tblLichHenChamSoc](
        [MaLichHen] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [MaChuNuoi] [int] NOT NULL,
        [MaThuCung] [int] NOT NULL,
        [MaDVCS] [int] NOT NULL,
        [NgayHen] [date] NOT NULL,
        [GioHen] [time](7) NOT NULL,
        [GhiChuYeuCau] [nvarchar](500) NULL,
        [TrangThai] [nvarchar](50) NULL DEFAULT N'Chờ xác nhận', -- 'Chờ xác nhận', 'Đã xác nhận', 'Đã tiếp nhận', 'Đã hủy'
        [NgayTaoLich] [datetime] NULL DEFAULT GETDATE(),
        CONSTRAINT [FK_tblLichHenCS_tblChuNuoi] FOREIGN KEY([MaChuNuoi]) REFERENCES [dbo].[tblChuNuoi] ([MaChuNuoi]),
        CONSTRAINT [FK_tblLichHenCS_tblThuCung] FOREIGN KEY([MaThuCung]) REFERENCES [dbo].[tblHoSoThuCung] ([MaThuCung]),
        CONSTRAINT [FK_tblLichHenCS_tblDVCS] FOREIGN KEY([MaDVCS]) REFERENCES [dbo].[tblDichVuChamSoc] ([MaDVCS])
    );
END
GO

-- ----------------------------------------------------------------------------------
-- 8. BẢNG NHẬT KÝ QUÁ TRÌNH CHĂM SÓC / LƯU TRÚ (tblNhatKyChamSoc)
-- ----------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[tblNhatKyChamSoc]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tblNhatKyChamSoc](
        [MaNhatKy] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [MaPhieuDV] [int] NOT NULL,
        [ThoiGian] [datetime] NULL DEFAULT GETDATE(),
        [NhanVienThucHien] [nvarchar](100) NULL,
        [BuocThucHien] [nvarchar](200) NULL, -- 'Tắm thảo dược khử mùi', 'Cắt tỉa tạo dáng Teddy', 'Cho ăn hạt Royal Canin'
        [TinhTrangThuCung] [nvarchar](255) NULL, -- 'Bé ngoan, ăn hết suất, không cắn'
        [HinhAnhNhatKy] [nvarchar](255) NULL,
        CONSTRAINT [FK_tblNhatKyCS_tblPhieuDVCS] FOREIGN KEY([MaPhieuDV]) REFERENCES [dbo].[tblPhieuDichVuChamSoc] ([MaPhieuDV]) ON DELETE CASCADE
    );
END
GO


-- ==================================================================================
-- PHẦN DỮ LIỆU MẪU (SEED DATA) CHO CÁC MODULE MỚI
-- ==================================================================================

-- 1. DỮ LIỆU MẪU: HỒ SƠ CHỦ NUÔI (tblChuNuoi)
INSERT INTO [dbo].[tblChuNuoi] 
([MaKH], [HoTenChuNuoi], [SoDienThoai], [Email], [SoCCCD], [DiaChi], [GioiTinh], [NgaySinh], [SoDienThoaiKhanCap], [NguoiLienHeKhanCap], [LoaiChuNuoi], [DiemTichLuy], [GhiChu])
VALUES
(1, N'Trần Minh Anh', '0946725980', 'minha@gmail.com', '079199001234', N'123 Nguyễn Huệ, Quận 1, TP.HCM', N'Nữ', '2002-05-15', '0903112233', N'Nguyễn Văn Tuấn (Chồng)', N'VIP', 250, N'Khách thân thiết, yêu cầu sữa tắm thảo mộc'),
(2, N'Nguyễn Quốc Bảo', '0842629565', 'bao@gmail.com', '048198002345', N'45 Lê Duẩn, Hải Châu, Đà Nẵng', N'Nam', '2000-08-20', '0912334455', N'Nguyễn Thị Mai (Mẹ)', N'Thân thiết', 120, N'Chó Corgi hơi nhát người lạ'),
(3, N'Lê Hồng Cúc', '0834622456', 'cuc@gmail.com', '001197003456', N'78 Hoàng Hoa Thám, Ba Đình, Hà Nội', N'Nữ', '2003-03-10', '0988776655', N'Lê Hoàng Long (Anh trai)', N'Tiêu chuẩn', 60, N'Mèo Ba Tư cần chải lông cẩn thận'),
(4, N'Phan Văn Dũng', '035268964', 'dung@gmail.com', '092196004567', N'89 Mậu Thân, Ninh Kiều, Cần Thơ', N'Nam', '1999-11-25', '0977665544', N'Phan Thị Hoa (Chị)', N'Tiêu chuẩn', 40, N'Chó Alaska rất hiếu động'),
(5, N'Đỗ Thị Lan', '0953684544', 'lan@gmail.com', '074195005678', N'12 Đại lộ Bình Dương, Thủ Dầu Một', N'Nữ', '2001-07-18', '0966554433', N'Đỗ Văn Hưng (Bố)', N'Thân thiết', 150, N'Nuôi 2 bé mèo Anh'),
(6, N'Trịnh Hoàng Nam', '0566732425', 'nam@gmail.com', '046194006789', N'34 Hùng Vương, TP. Huế', N'Nam', '2002-09-09', '0944332211', N'Trần Thu Hà (Vợ)', N'VIP', 320, N'Nuôi chó Poodle Tiny, chăm sóc định kỳ hàng tuần'),
(7, N'Nguyễn Mỹ Hoa', '0856642415', 'hoa@gmail.com', '079193007890', N'56 Nguyễn Thị Thập, Quận 7, TP.HCM', N'Nữ', '2004-02-14', '0933221100', N'Nguyễn Hoàng (Bố)', N'Tiêu chuẩn', 80, N'Nuôi mèo Scottish tai cụp'),
(8, N'Phạm Hữu Tài', '0883525754', 'tai@gmail.com', '068192008901', N'22 Phan Đình Phùng, Đà Lạt', N'Nam', '1998-12-05', '0922110099', N'Phạm Thu Dung (Em gái)', N'Tiêu chuẩn', 50, N'Chó Golden rất năng động'),
(9, N'Đoàn Thanh Hà', '0364634684', 'ha@gmail.com', '056191009012', N'67 Trần Phú, Nha Trang, Khánh Hòa', N'Nữ', '2003-06-30', '0911009988', N'Đoàn Minh Trí (Anh trai)', N'VIP', 410, N'Yêu cầu kỹ thuật viên có kinh nghiệm với mèo Sphynx'),
(10, N'Ngô Văn Phúc', '0986764309', 'phuc@gmail.com', '080190010123', N'88 Hùng Vương, TP. Tân An, Long An', N'Nam', '2001-04-12', '0900998877', N'Ngô Thị Bích (Mẹ)', N'Thân thiết', 180, N'Chó Pug mặt xệ cần vệ sinh kẽ mặt sạch sẽ'),
(11, N'Nguyễn Văn An', '0909111222', 'an.nguyen@gmail.com', '079189011234', N'123 Lý Thường Kiệt, Quận 10, TP.HCM', N'Nam', '1990-01-01', '0989123456', N'Trần Thị Mai (Vợ)', N'VIP', 500, N'Khách VIP lâu năm, sở hữu đàn chó giống'),
(12, N'Trần Thị Bích', '0912333444', 'bichtran@yahoo.com', '079188012345', N'45 Nguyễn Du, Quận 1, TP.HCM', N'Nữ', '1995-10-10', '0978234567', N'Trần Văn Hải (Bố)', N'VIP', 450, N'Thích dùng dịch vụ tạo kiểu Hàn Quốc'),
(13, N'Lê Minh Cường', '0988222333', 'cuongle@gmail.com', '079187013456', N'78 Lê Văn Sỹ, Quận 3, TP.HCM', N'Nam', '1988-06-06', '0967345678', N'Lê Thị Hương (Mẹ)', N'Thân thiết', 200, N'Chó Samoyed lông trắng tinh, cần sấy khô kỹ'),
(14, N'Phạm Thu Hà', '0933444555', 'ha.pham@outlook.com', '079186014567', N'56 Hoàng Văn Thụ, Phú Nhuận, TP.HCM', N'Nữ', '1992-04-20', '0956456789', N'Vũ Đình Khang (Chồng)', N'VIP', 380, N'Bé Poodle dị ứng phấn hoa'),
(15, N'Hoàng Văn Dũng', '0977555666', 'dung.hoang@gmail.com', '079185015678', N'234 Cộng Hòa, Tân Bình, TP.HCM', N'Nam', '1998-08-15', '0945567890', N'Hoàng Lan (Em gái)', N'Tiêu chuẩn', 90, N'Gửi khách sạn dịp lễ Tết'),
(16, N'Vũ Thị Lan', '0911666777', 'lan.vu@yahoo.com', '079184016789', N'89 Nguyễn Trãi, Quận 5, TP.HCM', N'Nữ', '1993-09-05', '0934678901', N'Vũ Minh Tuấn (Anh trai)', N'Thân thiết', 160, N'Mèo Munchkin chân ngắn rất quấn người'),
(17, N'Đặng Quang Huy', '0922777888', 'huy.dang@gmail.com', '079183017890', N'67 Võ Thị Sáu, Quận 3, TP.HCM', N'Nam', '1991-03-22', '0923789012', N'Đặng Thị Thu (Mẹ)', N'VIP', 290, N'Chó Doberman kỷ luật, cần dắt đi dạo 2 lần/ngày'),
(18, N'Ngô Thị Mai', '0944888999', 'mai.ngo@outlook.com', '079182018901', N'123 Lê Quang Định, Bình Thạnh, TP.HCM', N'Nữ', '1996-12-12', '0912890123', N'Ngô Hữu Phước (Bố)', N'Tiêu chuẩn', 70, N'Bé Corgi đang tập đi vệ sinh đúng chỗ'),
(19, N'Bùi Văn Tài', '0966999000', 'tai.bui@gmail.com', '079181019012', N'45 Trường Chinh, Tân Phú, TP.HCM', N'Nam', '1989-05-19', '0901901234', N'Bùi Thị Liễu (Vợ)', N'Thân thiết', 190, N'Chó Shiba Inu tính cách độc lập'),
(20, N'Lý Thị Hương', '0955111222', 'huong.ly@yahoo.com', '079180020123', N'78 Lý Thái Tổ, Quận 10, TP.HCM', N'Nữ', '1994-07-07', '0890012345', N'Lý Văn Nam (Anh trai)', N'VIP', 340, N'Bé Poodle màu xám khói rất quý');
GO

-- 2. DỮ LIỆU MẪU: HỒ SƠ THÚ CƯNG (tblHoSoThuCung)
INSERT INTO [dbo].[tblHoSoThuCung]
([MaChuNuoi], [TenThuCung], [LoaiThuCung], [GiongLoai], [GioiTinh], [TrietSan], [NgaySinh], [TuoiThang], [MauSac], [CanNang], [DacDiemNhanDang], [SoMicrochip], [TinhTrangSucKhoeHienTai], [TienSuBenhLy], [DiUngThuocThucAn], [LichSuTiemChung], [HinhAnh], [TrangThai], [GhiChu])
VALUES
(1, N'Bông Xù', N'Chó', N'Poodle Toy', N'Đực', 1, '2023-04-10', 17, N'Nâu đỏ', 3.80, N'Lông xoăn tít, tai dài cụp, ngực có đốm trắng nhỏ', 'MC-981001-VN', N'Khỏe mạnh, lanh lợi', N'Từng viêm tai ngoài lúc 5 tháng tuổi', N'Không phát hiện', N'Đã tiêm đủ 3 mũi 7 bệnh và 1 mũi Dại', N'poodle_bong.jpg', N'Đang nuôi', N'Rất thích được massage bụng'),
(1, N'Mimi', N'Mèo', N'Mèo Anh lông ngắn', N'Cái', 0, '2023-08-15', 13, N'Xám xanh', 4.10, N'Mắt màu hổ phách to tròn, má phúng phính', 'MC-981002-VN', N'Sức khỏe tốt, da bóng mượt', N'Không', N'Không', N'Tiêm 2 mũi phòng bệnh cho mèo + Dại', N'meo_mimi.jpg', N'Đang nuôi', N'Hơi nhút nhát khi gặp chó lạ'),
(2, N'Mông To', N'Chó', N'Corgi Pembroke', N'Đực', 0, '2022-11-20', 22, N'Vàng trắng', 11.50, N'Đuôi cộc bẩm sinh, mông hình trái tim, chân ngắn', 'MC-981003-VN', N'Khỏe mạnh, hơi thừa cân nhẹ', N'Không', N'Không', N'Tiêm nhắc lại hàng năm đầy đủ', N'corgi_mongto.jpg', N'Đang nuôi', N'Cần kiểm soát lượng hạt, thích chạy nhảy'),
(3, N'Công Chúa', N'Mèo', N'Mèo Ba Tư', N'Cái', 1, '2022-05-12', 28, N'Trắng tinh', 3.60, N'Mặt tịt, lông xù dài, mắt xanh ngọc bích', 'MC-981004-VN', N'Thường xuyên có rỉ mắt, cần vệ sinh hàng ngày', N'Tắc búi lông năm 2023', N'Dị ứng thức ăn có thịt bò', N'Đã tiêm đầy đủ các mũi', N'meo_batu_congchua.jpg', N'Đang nuôi', N'Yêu cầu dùng sữa tắm dưỡng ẩm mượt lông'),
(4, N'Bão Tuyết', N'Chó', N'Alaska Malamute', N'Đực', 0, '2023-01-05', 20, N'Xám trắng', 34.00, N'Vóc dáng to lớn, lông 2 lớp dày, mắt nâu đen', 'MC-981005-VN', N'Khỏe mạnh, lực kéo tốt', N'Không', N'Không', N'Đã tiêm phòng dại và 7 bệnh đầy đủ', N'alaska_baotuyet.jpg', N'Đang nuôi', N'Thân thiện với người nhưng không chịu ở phòng nóng'),
(5, N'Bơ', N'Mèo', N'Mèo Anh lông ngắn', N'Đực', 1, '2023-06-01', 15, N'Vàng kem', 4.80, N'Lông dày mịn, chân to mập', 'MC-981006-VN', N'Tốt, đã triệt sản', N'Không', N'Không', N'Tiêm chủng đầy đủ theo sổ khám', N'meo_bo.jpg', N'Đang nuôi', N'Rất thích ăn pate súp thưởng'),
(5, N'Đậu Đậu', N'Mèo', N'Mèo Anh lông dài', N'Cái', 0, '2023-09-10', 12, N'Bicolor (Xám trắng)', 3.20, N'Lông dài mượt, yếm ngực trắng muốt', 'MC-981007-VN', N'Khỏe mạnh', N'Nấm da nhẹ (đã khỏi hoàn toàn)', N'Không', N'Tiêm 2 mũi phòng bệnh mèo', N'meo_daudau.jpg', N'Đang nuôi', N'Đang trong độ tuổi chăm sóc lông đặc biệt'),
(6, N'Hạt Tiêu', N'Chó', N'Poodle Teacup', N'Cái', 0, '2023-10-18', 11, N'Nâu cánh gián', 1.80, N'Kích thước siêu nhỏ, mắt đen láy', 'MC-981008-VN', N'Hệ tiêu hóa hơi nhạy cảm', N'Từng bị rối loạn tiêu hóa nhẹ', N'Không cho ăn thức ăn dầu mỡ', N'Đã hoàn thành các mũi cơ bản', N'poodle_hattieu.jpg', N'Đang nuôi', N'Cần giữ ấm khi tắm sấy'),
(7, N'Bánh Bao', N'Mèo', N'Scottish Fold (Tai cụp)', N'Đực', 1, '2022-07-25', 26, N'Xám sọc Tabby', 4.50, N'Hai tai cụp sát đầu, mặt tròn xoe', 'MC-981009-VN', N'Khớp xương ổn định, đã bổ sung canxi', N'Hơi yếu sụn tai bẩm sinh', N'Không', N'Tiêm chủng hàng năm đầy đủ', N'meo_banhbao.jpg', N'Đang nuôi', N'Tránh vận động quá mạnh hoặc leo trèo cao'),
(8, N'Lucky', N'Chó', N'Golden Retriever', N'Đực', 0, '2022-03-30', 30, N'Vàng kim', 29.50, N'Lông óng ả, đuôi bông lau, tính cách vô cùng hiền lành', 'MC-981010-VN', N'Khỏe mạnh, tim phổi tốt', N'Không', N'Không', N'Đầy đủ sổ tiêm chủng định kỳ', N'golden_lucky.jpg', N'Đang nuôi', N'Rất thích nghịch nước, bơi lội'),
(9, N'Người Ngoài Hành Tinh', N'Mèo', N'Mèo Sphynx', N'Đực', 1, '2022-09-14', 24, N'Hồng phấn', 3.90, N'Toàn thân không lông, da ấm, nếp nhăn nhiều ở trán', 'MC-981011-VN', N'Tốt, da tiết dầu bình thường', N'Dễ cảm lạnh nếu gặp máy lạnh sâu', N'Dị ứng xà phòng tắm có tính kiềm mạnh', N'Đã tiêm phòng đầy đủ', N'meo_sphynx.jpg', N'Đang nuôi', N'Phải mặc áo ấm và tắm bằng sữa tắm dịu nhẹ'),
(10, N'Lu', N'Chó', N'Pug mặt xệ', N'Đực', 0, '2023-02-28', 19, N'Vàng kim viền đen', 8.20, N'Mặt nhiều nếp nhăn, đuôi cuộn tròn trên lưng', 'MC-981012-VN', N'Hơi thở có tiếng ngáy đặc trưng giống loài', N'Từng viêm kẽ nếp nhăn mũi', N'Không', N'Tiêm đầy đủ các mũi phòng bệnh', N'pug_lu.jpg', N'Đang nuôi', N'Phải lau sạch và sấy khô kỹ các nếp gấp mặt'),
(11, N'Maximus', N'Chó', N'Husky Siberian', N'Đực', 0, '2022-01-15', 32, N'Đen trắng', 26.00, N'Mắt hai màu (1 xanh 1 nâu), biểu cảm hài hước', 'MC-981013-VN', N'Rất khỏe, tràn đầy năng lượng', N'Không', N'Không', N'Đầy đủ vắc xin và sổ theo dõi', N'husky_maximus.jpg', N'Đang nuôi', N'Rất ồn ào khi ở một mình'),
(12, N'Ruby', N'Chó', N'Poodle Toy', N'Cái', 1, '2023-03-08', 18, N'Trắng tinh', 3.40, N'Lông dày phồng, được tỉa kiểu Puppy clip', 'MC-981014-VN', N'Rất khỏe mạnh, nhanh nhẹn', N'Không', N'Không', N'Đầy đủ tiêm phòng', N'poodle_ruby.jpg', N'Đang nuôi', N'Chủ yêu cầu chỉ dùng kéo cắt tỉa tay thủ công'),
(13, N'Bạch Tuyết', N'Chó', N'Samoyed', N'Cái', 0, '2022-08-20', 25, N'Trắng tuyết', 21.00, N'Miệng cười Samoyed đặc trưng, lông trắng muốt xù bông', 'MC-981015-VN', N'Khỏe mạnh, da sạch không gàu nấm', N'Từng bị rối lông vào mùa thay lông', N'Không', N'Tiêm chủng định kỳ đúng hẹn', N'samoyed_bachtuyet.jpg', N'Đang nuôi', N'Mỗi lần tắm cần sấy 2 máy công suất lớn'),
(14, N'Cacao', N'Chó', N'Poodle Tiny', N'Đực', 0, '2023-05-10', 16, N'Nâu sô-cô-la', 2.30, N'Mũi màu nâu, mắt màu hổ phách', 'MC-981016-VN', N'Sức khỏe bình thường', N'Dị ứng phấn hoa nhẹ vào mùa xuân', N'Dị ứng phấn hoa', N'Đã hoàn thành 3 mũi vắc xin', N'poodle_cacao.jpg', N'Đang nuôi', N'Dễ bị giật mình bởi tiếng sấm sét'),
(15, N'Xúc Xích', N'Chó', N'Dachshund (Lạp xưởng)', N'Đực', 1, '2021-12-10', 33, N'Nâu đỏ', 7.50, N'Lưng dài, chân ngắn cũn cỡn, ngực nở', 'MC-981017-VN', N'Tốt, hạn chế cho leo cầu thang', N'Đã phòng ngừa thoái hóa cột sống', N'Không', N'Tiêm phòng đầy đủ', N'dachshund_xucxich.jpg', N'Đang nuôi', N'Không để bế bốc ngang lưng làm đau cột sống'),
(16, N'Mầm', N'Mèo', N'Munchkin Chân Ngắn', N'Cái', 0, '2023-07-07', 14, N'Calico (Tam thể)', 2.90, N'Chân siêu ngắn, đi lạch bạch như vịt, rất đáng yêu', 'MC-981018-VN', N'Khỏe mạnh, ăn uống tốt', N'Không', N'Không', N'Đã tiêm phòng 2 mũi', N'meo_mam.jpg', N'Đang nuôi', N'Rất thích được chải lông cằm'),
(17, N'Héc-quyn', N'Chó', N'Doberman Pinscher', N'Đực', 0, '2022-04-18', 29, N'Đen vàng (Black & Tan)', 36.50, N'Cơ bắp săn chắc, tai đứng, ngực sâu', 'MC-981019-VN', N'Cực kỳ sung mãn, thể lực tốt', N'Không', N'Không', N'Sổ tiêm ngừa chuẩn quốc tế', N'doberman_hecquyn.jpg', N'Đang nuôi', N'Huấn luyện viên chuyên nghiệp dắt, rọ mõm nơi đông người'),
(18, N'Khoai Tây', N'Chó', N'Corgi Cardigan', N'Cái', 0, '2023-04-25', 17, N'Brindle (Vện vằn)', 10.80, N'Đuôi dài chạm đất, tai to tròn', 'MC-981020-VN', N'Khỏe mạnh, đang thay lông tơ', N'Không', N'Không', N'Đã tiêm đủ các mũi vắc xin', N'corgi_khoaitay.jpg', N'Đang nuôi', N'Thích ăn cà rốt luộc làm đồ thưởng'),
(19, N'Kuro', N'Chó', N'Shiba Inu', N'Đực', 1, '2022-10-10', 23, N'Đen vàng (Black Tan)', 9.60, N'Mặt cáo, đuôi cuộn chặt hình trăng lưỡi liềm', 'MC-981021-VN', N'Rất tốt, tính tình điềm đạm', N'Không', N'Không', N'Tiêm ngừa đầy đủ đúng hạn', N'shiba_kuro.jpg', N'Đang nuôi', N'Không thích người lạ vuốt ve phần đuôi'),
(20, N'Bạch Mã', N'Chó', N'Poodle Standard', N'Đực', 0, '2022-06-15', 27, N'Xám khói (Silver)', 22.00, N'Chân dài thanh thoát, tạo hình lông kiểu quý tộc', 'MC-981022-VN', N'Tốt, vóc dáng chuẩn thi đấu', N'Không', N'Không', N'Đã kiểm tra sức khỏe và tiêm đủ', N'poodle_bachma.jpg', N'Đang nuôi', N'Chăm sóc lông hàng tuần để giữ màu xám ánh kim');
GO

-- 3. DỮ LIỆU MẪU: SỔ THEO DÕI SỨC KHỎE & TIÊM PHÒNG (tblSoTheoDoiSucKhoe)
INSERT INTO [dbo].[tblSoTheoDoiSucKhoe]
([MaThuCung], [NgayKiemTra], [CanNang], [ThanNhiet], [LoaiKham], [TenVacXinThuoc], [BacSiPhuTrach], [KetLuanVaDanDo], [NgayHenTaiKham])
VALUES
(1, '2024-01-15 09:30:00', 3.60, 38.4, N'Tiêm phòng định kỳ', N'Vắc xin 7 bệnh Vanguard Plus 5/L', N'BS. Phạm An Thành', N'Sức khỏe tốt, không sốt, đã tiêm nhắc lại mũi 7 bệnh. Kiêng tắm 7 ngày.', '2025-01-15'),
(1, '2024-06-10 10:15:00', 3.80, 38.5, N'Tẩy giun định kỳ', N'Thuốc tẩy giun Drontal Plus', N'BS. Phan Thị Thắng', N'Uống thuốc tẩy giun an toàn, theo dõi phân trong 48h. Tái tẩy giun sau 3 tháng.', '2024-09-10'),
(2, '2024-02-20 14:00:00', 3.90, 38.6, N'Tiêm phòng dại', N'Vắc xin Dại Rabisin', N'BS. Phạm An Thành', N'Mèo khỏe mạnh, phản ứng sau tiêm bình thường, không dị ứng.', '2025-02-20'),
(3, '2024-03-05 11:00:00', 11.20, 38.7, N'Khám định kỳ & tư vấn cân nặng', N'Bổ sung Glucosamine cho khớp chân ngắn', N'BS. Phạm An Thành', N'Khớp háng tốt, hơi nặng cân (11.2kg). Cần giảm 10% khẩu phần ăn hàng ngày.', '2024-09-05'),
(4, '2024-04-12 15:30:00', 3.50, 38.3, N'Khám mắt & đường ruột', N'Thuốc nhỏ mắt Tobrex, Gel tiêu búi lông GimCat', N'BS. Huỳnh Thị Ngọc Tú', N'Tuyến lệ bị tắc nhẹ gây ố khóe mắt, nhỏ thuốc 2 lần/ngày. Cho uống gel tiêu búi lông.', '2024-04-26'),
(5, '2024-05-18 08:45:00', 33.50, 38.2, N'Tiêm phòng định kỳ', N'Vắc xin 7 bệnh Merial + Dại Defensor', N'BS. Phạm An Thành', N'Thể trạng tuyệt vời, nhịp tim đều, phổi trong. Đã hoàn thành 2 mũi.', '2025-05-18'),
(6, '2024-06-02 16:20:00', 4.80, 38.6, N'Khám sức khỏe tổng quát sau triệt sản', N'Kháng viêm giảm đau, bổ sung Omega-3', N'BS. Phan Thị Thắng', N'Vết mổ triệt sản lành hoàn toàn, không sưng viêm. Hoạt bát, ăn ngủ tốt.', '2024-12-02'),
(7, '2024-07-01 10:00:00', 3.10, 38.5, N'Điều trị da liễu', N'Xịt nấm Fungikur, Dầu tắm bọt Dermaleen', N'BS. Huỳnh Thị Ngọc Tú', N'Đốm nấm ở rìa tai đã đóng vảy, tiếp tục xịt thuốc và tắm 2 lần/tuần đến khi dứt điểm.', '2024-07-15'),
(8, '2024-07-20 09:10:00', 1.80, 38.4, N'Khám tiêu hóa', N'Men tiêu hóa vi sinh Bio-Scour', N'BS. Phạm An Thành', N'Bé Poodle nhỏ con tiêu hóa kém, bổ sung men vi sinh vào thức ăn trong 10 ngày.', '2024-08-05'),
(9, '2024-08-03 14:40:00', 4.40, 38.5, N'Kiểm tra sụn xương tai', N'Viên nhai Osteo-Form bổ sung Canxi & D3', N'BS. Phan Thị Thắng', N'Khung xương vững, dáng đi linh hoạt. Tiếp tục cho uống canxi theo đợt 30 ngày.', '2024-11-03'),
(10, '2024-08-15 11:30:00', 29.00, 38.3, N'Khám răng & lấy vôi răng', N'Gel sát khuẩn nướu răng Orozyme', N'BS. Phạm An Thành', N'Đã cạo vôi răng mảng bám hàm trên dưới, hơi thở thơm tho, nướu răng hồng hào.', '2025-02-15');
GO

-- 4. DỮ LIỆU MẪU: DANH MỤC DỊCH VỤ CHĂM SÓC THÚ CƯNG (tblDichVuChamSoc)
INSERT INTO [dbo].[tblDichVuChamSoc]
([TenDichVu], [NhomDichVu], [DoiTuongApDung], [GiaDichVu], [ThoiGianThucHien], [MoTaChiTiet], [HinhAnhDichVu], [TrangThai])
VALUES
(N'Tắm sấy & Khử mùi cơ bản (Chó nhỏ < 5kg)', N'Spa - Grooming', N'Chó < 5kg', 150000, 45, N'Tắm 2 nước bằng dầu tắm nhập khẩu, sấy khô chải lông tơi, vệ sinh tai và xịt thơm thảo dược', N'spa_tam_cho_nho.jpg', N'Đang cung cấp'),
(N'Tắm sấy & Khử mùi toàn diện (Chó vừa 5-10kg)', N'Spa - Grooming', N'Chó 5-10kg', 220000, 60, N'Tắm sạch sâu, vắt tuyến hôi, sấy khô đánh bồng lông, cắt mài móng chân, xịt dưỡng lông', N'spa_tam_cho_vua.jpg', N'Đang cung cấp'),
(N'Tắm sấy & Chăm sóc lông chuyên sâu (Chó lớn > 10kg)', N'Spa - Grooming', N'Chó > 10kg', 350000, 90, N'Tắm phục hồi hư tổn lông, khử mùi tuyến hôi, sấy bằng máy thổi áp lực lớn, chải lông rụng', N'spa_tam_cho_lon.jpg', N'Đang cung cấp'),
(N'Tắm Spa dưỡng lông & Khử khuẩn cho Mèo', N'Spa - Grooming', N'Mèo mọi cỡ', 180000, 50, N'Tắm nhẹ nhàng giảm stress bằng sữa tắm chuyên biệt cho mèo, sấy trong lồng sấy nhiệt êm ái', N'spa_tam_meo.jpg', N'Đang cung cấp'),
(N'Cắt tỉa tạo kiểu nghệ thuật - Gấu bông Teddy (Poodle)', N'Spa - Grooming', N'Chó < 5kg', 280000, 90, N'Tỉa mặt tròn gấu bông Teddy bear xinh xắn, bo tròn tai, cắt gọn bốn bàn chân kiểu bốt', N'grooming_teddy.jpg', N'Đang cung cấp'),
(N'Cắt tỉa lông toàn thân & Tạo phom chuẩn thi đấu', N'Spa - Grooming', N'Tất cả', 400000, 120, N'Cắt tỉa phom chuẩn giống loài (Corgi, Poodle, Samoyed, Mèo Ba Tư), tạo viền sắc nét chuyên nghiệp', N'grooming_pro.jpg', N'Đang cung cấp'),
(N'Vệ sinh toàn diện: Tai, Móng, Tuyến hôi & Nhổ lông tai', N'Spa - Grooming', N'Tất cả', 100000, 30, N'Cắt mài móng không chảy máu, nhổ lông tai và làm sạch rỉ tai bằng dung dịch y tế, vắt sạch tuyến hôi', N've_sinh_toan_dien.jpg', N'Đang cung cấp'),
(N'Cạo lông vệ sinh mùa hè & Trị ve rận', N'Spa - Grooming', N'Tất cả', 160000, 45, N'Cạo sạch lông bụng, hậu môn, bàn chân hoặc cạo sạch toàn thân giúp thoáng mát và bôi thuốc trị ve', N'cao_long_ve_sinh.jpg', N'Đang cung cấp'),
(N'Gỡ rối lông chuyên nghiệp & Phục hồi collagen', N'Spa - Grooming', N'Chó mèo lông dài', 250000, 75, N'Gỡ rối mảng bết mà không cần cạo trụi lông, ủ dầu hấp collagen dưỡng sợi lông mềm mượt bóng bẩy', N'go_roi_collagen.jpg', N'Đang cung cấp'),
(N'Khách sạn thú cưng cao cấp - Phòng Deluxe (Theo ngày)', N'Khách sạn thú cưng', N'Tất cả', 200000, 1440, N'Phòng điều hòa 24/7, camera quan sát gửi chủ nuôi, ăn 3 bữa hạt cao cấp, dắt đi dạo 2 lần/ngày', N'hotel_deluxe.jpg', N'Đang cung cấp'),
(N'Khách sạn thú cưng VIP Suite (Theo ngày)', N'Khách sạn thú cưng', N'Tất cả', 350000, 1440, N'Phòng riêng biệt diện tích lớn, đệm nhung êm ái, thực đơn tự chọn thịt tươi/pate, đồ chơi phong phú', N'hotel_vip.jpg', N'Đang cung cấp'),
(N'Gửi thú cưng bán trú theo giờ', N'Khách sạn thú cưng', N'Tất cả', 40000, 60, N'Giữ và chăm sóc thú cưng ngắn hạn trong ngày cho khách bận công việc hoặc đi siêu thị', N'gui_theo_gio.jpg', N'Đang cung cấp'),
(N'Khám sức khỏe tổng quát & Đo các chỉ số sinh tồn', N'Thú y & Khám chữa', N'Tất cả', 120000, 30, N'Kiểm tra mắt, mũi, họng, tai, răng miệng, nghe tim phổi, đo thân nhiệt và nắn kiểm tra bụng', N'kham_tong_quat.jpg', N'Đang cung cấp'),
(N'Tiêm phòng Vắc xin 7 bệnh cho Chó (Mỹ)', N'Thú y & Khám chữa', N'Chó mọi lứa tuổi', 260000, 20, N'Vắc xin phòng 7 bệnh nguy hiểm (Care, Parvo, Viêm gan, Ho cũi, Phó cúm, Leptospira 2 type)', N'tiem_vacxin_cho.jpg', N'Đang cung cấp'),
(N'Tiêm phòng Vắc xin 4 bệnh cho Mèo (Pháp)', N'Thú y & Khám chữa', N'Mèo', 240000, 20, N'Phòng ngừa giảm bạch cầu, viêm mũi khí quản truyền nhiễm, Calicivirus và Chlamydia', N'tiem_vacxin_meo.jpg', N'Đang cung cấp'),
(N'Tiêm Vắc xin phòng dại & Cấp sổ chứng nhận', N'Thú y & Khám chữa', N'Tất cả', 100000, 15, N'Tiêm ngừa dại đạt chuẩn an toàn của Cục Thú y, cấp tem chứng nhận và sổ theo dõi quốc gia', N'tiem_dai.jpg', N'Đang cung cấp'),
(N'Tẩy giun sán định kỳ trọn gói', N'Thú y & Khám chữa', N'Tất cả', 60000, 15, N'Cân nặng chính xác và cho uống liều thuốc tẩy giun ngoại nhập diệt sạch giun đũa, giun móc, sán dây', N'tay_giun.jpg', N'Đang cung cấp'),
(N'Lấy cao răng siêu âm không gây mê', N'Thú y & Khám chữa', N'Tất cả', 220000, 45, N'Sử dụng máy rung siêu âm nha khoa nhẹ nhàng loại bỏ mảng bám ố vàng quanh nướu, không đau rát', N'cao_rang.jpg', N'Đang cung cấp'),
(N'Xét nghiệm máu tổng quát (18 chỉ số huyết học)', N'Thú y & Khám chữa', N'Tất cả', 300000, 40, N'Máy xét nghiệm tự động kiểm tra số lượng hồng cầu, bạch cầu, tiểu cầu, dấu hiệu nhiễm trùng máu', N'xet_nghiem_mau.jpg', N'Đang cung cấp'),
(N'Gói triệt sản an toàn thú cưng', N'Thú y & Khám chữa', N'Tất cả', 650000, 90, N'Phẫu thuật triệt sản vô trùng, gây mê tĩnh mạch an toàn, khâu chỉ tự tiêu thẩm mỹ, tặng thuốc uống 5 ngày', N'triet_san.jpg', N'Đang cung cấp');
GO

-- 5. DỮ LIỆU MẪU: PHIẾU DỊCH VỤ TIẾP NHẬN & CHĂM SÓC (tblPhieuDichVuChamSoc)
SET IDENTITY_INSERT [dbo].[tblPhieuDichVuChamSoc] ON;
INSERT INTO [dbo].[tblPhieuDichVuChamSoc] ([MaPhieuDV], [SoPhieu], [MaThuCung], [MaChuNuoi], [MaNVTiepNhan], [MaNVThucHien], [NgayTiepNhan], [NgayHenTra], [NgayTraThucTe], [CanNangTiepNhan], [TinhTrangBanDau], [YeuCauCuaChuNuoi], [KetQuaChamSoc], [TongTien], [TienGiamGia], [ThanhToan], [HinhThucThanhToan], [TrangThaiThanhToan], [TrangThaiDichVu], [DanhGiaCuaChu], [GhiChu], [DaCongDiem]) VALUES
(1, N'PDV-2026-0001', 26, 23, 2, 7, '2026-01-01 10:30:00', '2026-01-01 12:30:00', '2026-01-01 12:48:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(2, N'PDV-2026-0002', 21, 19, 4, 11, '2026-01-02 08:30:00', '2026-01-02 10:30:00', '2026-01-02 10:39:00', 9.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(3, N'PDV-2026-0003', 21, 19, 4, 3, '2026-01-02 11:30:00', '2026-01-02 13:30:00', '2026-01-02 13:50:00', 9.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(4, N'PDV-2026-0004', 12, 10, 4, 3, '2026-01-02 14:00:00', '2026-01-06 14:00:00', '2026-01-06 15:00:00', 8.20, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 0.00, 1400000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(5, N'PDV-2026-0005', 8, 6, 2, 11, '2026-01-02 14:30:00', '2026-01-02 16:30:00', '2026-01-02 16:38:00', 1.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(6, N'PDV-2026-0006', 19, 17, 2, 8, '2026-01-03 10:00:00', '2026-01-03 12:00:00', '2026-01-03 12:16:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(7, N'PDV-2026-0007', 4, 3, 4, 9, '2026-01-03 13:30:00', '2026-01-03 15:30:00', '2026-01-03 15:45:00', 3.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(8, N'PDV-2026-0008', 22, 20, 4, 11, '2026-01-03 16:15:00', '2026-01-03 18:15:00', '2026-01-03 18:28:00', 22.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(9, N'PDV-2026-0009', 23, 1, 2, 8, '2026-01-04 14:30:00', '2026-01-04 16:30:00', '2026-01-04 16:49:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(10, N'PDV-2026-0010', 9, 7, 4, 8, '2026-01-04 15:30:00', '2026-01-04 17:30:00', '2026-01-04 17:47:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(11, N'PDV-2026-0011', 9, 7, 2, 3, '2026-01-04 16:15:00', '2026-01-04 18:15:00', '2026-01-04 18:24:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(12, N'PDV-2026-0012', 24, 21, 4, 8, '2026-01-04 17:45:00', '2026-01-04 19:45:00', '2026-01-04 20:01:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(13, N'PDV-2026-0013', 23, 1, 2, 3, '2026-01-05 11:45:00', '2026-01-05 13:45:00', '2026-01-05 13:54:00', 4.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(14, N'PDV-2026-0014', 11, 9, 2, 3, '2026-01-05 18:30:00', '2026-01-05 20:30:00', '2026-01-05 20:49:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(15, N'PDV-2026-0015', 6, 5, 2, 8, '2026-01-06 11:15:00', '2026-01-06 13:15:00', '2026-01-06 13:22:00', 4.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(16, N'PDV-2026-0016', 19, 17, 2, 12, '2026-01-07 12:15:00', '2026-01-07 14:15:00', '2026-01-07 14:21:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(17, N'PDV-2026-0017', 25, 22, 4, 8, '2026-01-07 14:45:00', '2026-01-07 16:45:00', '2026-01-07 16:50:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(18, N'PDV-2026-0018', 12, 10, 2, 11, '2026-01-07 16:30:00', '2026-01-07 18:30:00', '2026-01-07 18:39:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(19, N'PDV-2026-0019', 12, 10, 4, 9, '2026-01-07 18:15:00', '2026-01-07 20:15:00', '2026-01-07 20:23:00', 8.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(20, N'PDV-2026-0020', 2, 1, 2, 3, '2026-01-08 09:45:00', '2026-01-10 09:45:00', '2026-01-10 10:45:00', 4.10, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(21, N'PDV-2026-0021', 21, 19, 2, 8, '2026-01-08 09:45:00', '2026-01-12 09:45:00', '2026-01-12 10:45:00', 9.60, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 0.00, 1400000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(22, N'PDV-2026-0022', 18, 16, 2, 3, '2026-01-08 10:45:00', '2026-01-08 12:45:00', '2026-01-08 12:51:00', 2.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(23, N'PDV-2026-0023', 10, 8, 2, 11, '2026-01-08 11:45:00', '2026-01-08 13:45:00', '2026-01-08 14:01:00', 29.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(24, N'PDV-2026-0024', 22, 20, 2, 12, '2026-01-09 08:00:00', '2026-01-09 10:00:00', '2026-01-09 10:12:00', 22.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 30000.00, 150000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(25, N'PDV-2026-0025', 15, 13, 4, 7, '2026-01-09 14:30:00', '2026-01-09 16:30:00', '2026-01-09 16:41:00', 21.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(26, N'PDV-2026-0026', 13, 11, 4, 3, '2026-01-09 15:00:00', '2026-01-09 17:00:00', '2026-01-09 17:07:00', 26.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(27, N'PDV-2026-0027', 17, 15, 2, 3, '2026-01-09 17:30:00', '2026-01-09 19:30:00', '2026-01-09 19:35:00', 7.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(28, N'PDV-2026-0028', 22, 20, 2, 7, '2026-01-10 12:45:00', '2026-01-10 14:45:00', '2026-01-10 14:52:00', 22.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(29, N'PDV-2026-0029', 7, 5, 4, 9, '2026-01-10 17:15:00', '2026-01-10 19:15:00', '2026-01-10 19:30:00', 3.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(30, N'PDV-2026-0030', 1, 1, 2, 12, '2026-01-11 08:15:00', '2026-01-11 10:15:00', '2026-01-11 10:27:00', 3.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(31, N'PDV-2026-0031', 12, 10, 4, 11, '2026-01-11 15:00:00', '2026-01-11 17:00:00', '2026-01-11 17:08:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(32, N'PDV-2026-0032', 11, 9, 4, 12, '2026-01-11 18:00:00', '2026-01-11 20:00:00', '2026-01-11 20:10:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(33, N'PDV-2026-0033', 17, 15, 4, 3, '2026-01-13 13:15:00', '2026-01-13 15:15:00', '2026-01-13 15:24:00', 7.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(34, N'PDV-2026-0034', 16, 14, 4, 11, '2026-01-14 18:15:00', '2026-01-14 20:15:00', '2026-01-14 20:32:00', 2.30, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(35, N'PDV-2026-0035', 26, 23, 2, 12, '2026-01-15 15:15:00', '2026-01-15 17:15:00', '2026-01-15 17:35:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(36, N'PDV-2026-0036', 15, 13, 2, 12, '2026-01-16 18:15:00', '2026-01-16 20:15:00', '2026-01-16 20:28:00', 21.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(37, N'PDV-2026-0037', 13, 11, 4, 9, '2026-01-17 12:45:00', '2026-01-17 14:45:00', '2026-01-17 15:00:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(38, N'PDV-2026-0038', 6, 5, 4, 12, '2026-01-17 18:45:00', '2026-01-17 20:45:00', '2026-01-17 20:58:00', 4.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(39, N'PDV-2026-0039', 4, 3, 2, 9, '2026-01-18 12:15:00', '2026-01-18 14:15:00', '2026-01-18 14:35:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(40, N'PDV-2026-0040', 8, 6, 4, 8, '2026-01-18 16:15:00', '2026-01-18 18:15:00', '2026-01-18 18:35:00', 1.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(41, N'PDV-2026-0041', 24, 21, 4, 7, '2026-01-18 16:30:00', '2026-01-18 18:30:00', '2026-01-18 18:48:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(42, N'PDV-2026-0042', 22, 20, 4, 7, '2026-01-20 08:00:00', '2026-01-20 10:00:00', '2026-01-20 10:18:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(43, N'PDV-2026-0043', 20, 18, 4, 9, '2026-01-20 09:45:00', '2026-01-20 11:45:00', '2026-01-20 12:02:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(44, N'PDV-2026-0044', 6, 5, 4, 8, '2026-01-20 16:45:00', '2026-01-20 18:45:00', '2026-01-20 19:04:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(45, N'PDV-2026-0045', 18, 16, 2, 7, '2026-01-20 17:30:00', '2026-01-20 19:30:00', '2026-01-20 19:47:00', 2.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(46, N'PDV-2026-0046', 5, 4, 4, 11, '2026-01-21 15:45:00', '2026-01-21 17:45:00', '2026-01-21 18:04:00', 34.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(47, N'PDV-2026-0047', 3, 2, 4, 11, '2026-01-21 15:45:00', '2026-01-21 17:45:00', '2026-01-21 17:50:00', 11.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(48, N'PDV-2026-0048', 3, 2, 2, 3, '2026-01-22 14:45:00', '2026-01-22 16:45:00', '2026-01-22 16:56:00', 11.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(49, N'PDV-2026-0049', 4, 3, 4, 8, '2026-01-22 16:30:00', '2026-01-22 18:30:00', '2026-01-22 18:45:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(50, N'PDV-2026-0050', 20, 18, 2, 11, '2026-01-23 12:30:00', '2026-01-27 12:30:00', '2026-01-27 13:30:00', 10.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 30000.00, 770000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(51, N'PDV-2026-0051', 24, 21, 2, 11, '2026-01-24 11:30:00', '2026-01-24 13:30:00', '2026-01-24 13:38:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(52, N'PDV-2026-0052', 21, 19, 2, 11, '2026-01-25 10:00:00', '2026-01-25 12:00:00', '2026-01-25 12:14:00', 9.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(53, N'PDV-2026-0053', 1, 1, 4, 7, '2026-01-25 15:45:00', '2026-01-25 17:45:00', '2026-01-25 18:00:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(54, N'PDV-2026-0054', 22, 20, 4, 3, '2026-01-26 08:30:00', '2026-01-26 10:30:00', '2026-01-26 10:48:00', 22.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(55, N'PDV-2026-0055', 4, 3, 2, 12, '2026-01-26 15:45:00', '2026-01-26 17:45:00', '2026-01-26 17:56:00', 3.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(56, N'PDV-2026-0056', 14, 12, 4, 7, '2026-01-26 16:45:00', '2026-01-26 18:45:00', '2026-01-26 19:04:00', 3.40, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(57, N'PDV-2026-0057', 22, 20, 2, 11, '2026-01-26 18:00:00', '2026-01-26 20:00:00', '2026-01-26 20:14:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(58, N'PDV-2026-0058', 26, 23, 4, 8, '2026-01-27 08:15:00', '2026-01-27 10:15:00', '2026-01-27 10:21:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(59, N'PDV-2026-0059', 22, 20, 4, 9, '2026-01-27 09:15:00', '2026-01-27 11:15:00', '2026-01-27 11:24:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(60, N'PDV-2026-0060', 24, 21, 2, 7, '2026-01-27 09:45:00', '2026-01-27 11:45:00', '2026-01-27 11:50:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(61, N'PDV-2026-0061', 26, 23, 2, 11, '2026-01-27 11:30:00', '2026-01-27 13:30:00', '2026-01-27 13:42:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(62, N'PDV-2026-0062', 12, 10, 2, 7, '2026-01-27 11:30:00', '2026-01-27 13:30:00', '2026-01-27 13:42:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(63, N'PDV-2026-0063', 13, 11, 2, 3, '2026-01-27 15:15:00', '2026-01-27 17:15:00', '2026-01-27 17:20:00', 26.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(64, N'PDV-2026-0064', 13, 11, 2, 8, '2026-01-28 14:00:00', '2026-01-28 16:00:00', '2026-01-28 16:10:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(65, N'PDV-2026-0065', 21, 19, 2, 12, '2026-01-29 15:00:00', '2026-01-29 17:00:00', '2026-01-29 17:05:00', 9.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(66, N'PDV-2026-0066', 10, 8, 2, 9, '2026-01-30 15:30:00', '2026-02-01 15:30:00', '2026-02-01 16:30:00', 29.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(67, N'PDV-2026-0067', 13, 11, 4, 8, '2026-01-30 16:15:00', '2026-01-30 18:15:00', '2026-01-30 18:29:00', 26.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 30000.00, 330000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(68, N'PDV-2026-0068', 18, 16, 2, 11, '2026-01-30 18:00:00', '2026-01-30 20:00:00', '2026-01-30 20:10:00', 2.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(69, N'PDV-2026-0069', 20, 18, 2, 11, '2026-01-31 11:15:00', '2026-01-31 13:15:00', '2026-01-31 13:20:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(70, N'PDV-2026-0070', 4, 3, 4, 9, '2026-01-31 12:00:00', '2026-01-31 14:00:00', '2026-01-31 14:12:00', 3.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(71, N'PDV-2026-0071', 22, 20, 4, 3, '2026-01-31 12:30:00', '2026-01-31 14:30:00', '2026-01-31 14:47:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(72, N'PDV-2026-0072', 3, 2, 2, 12, '2026-01-31 16:00:00', '2026-01-31 18:00:00', '2026-01-31 18:10:00', 11.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 30000.00, 330000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(73, N'PDV-2026-0073', 21, 19, 4, 12, '2026-02-02 08:00:00', '2026-02-02 10:00:00', '2026-02-02 10:06:00', 9.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(74, N'PDV-2026-0074', 11, 9, 4, 8, '2026-02-02 08:30:00', '2026-02-04 08:30:00', '2026-02-04 09:30:00', 3.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 700000.00, 0.00, 700000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(75, N'PDV-2026-0075', 26, 23, 2, 3, '2026-02-02 12:15:00', '2026-02-02 14:15:00', '2026-02-02 14:21:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(76, N'PDV-2026-0076', 10, 8, 2, 3, '2026-02-02 12:45:00', '2026-02-02 14:45:00', '2026-02-02 15:05:00', 29.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(77, N'PDV-2026-0077', 25, 22, 2, 12, '2026-02-02 12:45:00', '2026-02-05 12:45:00', '2026-02-05 13:45:00', 3.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(78, N'PDV-2026-0078', 25, 22, 4, 12, '2026-02-02 13:30:00', '2026-02-02 15:30:00', '2026-02-02 15:40:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(79, N'PDV-2026-0079', 12, 10, 4, 3, '2026-02-02 14:00:00', '2026-02-02 16:00:00', '2026-02-02 16:11:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(80, N'PDV-2026-0080', 12, 10, 2, 12, '2026-02-02 18:15:00', '2026-02-02 20:15:00', '2026-02-02 20:29:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(81, N'PDV-2026-0081', 22, 20, 4, 9, '2026-02-03 12:00:00', '2026-02-03 14:00:00', '2026-02-03 14:06:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(82, N'PDV-2026-0082', 11, 9, 2, 3, '2026-02-03 14:15:00', '2026-02-03 16:15:00', '2026-02-03 16:29:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(83, N'PDV-2026-0083', 6, 5, 4, 3, '2026-02-04 10:00:00', '2026-02-04 12:00:00', '2026-02-04 12:19:00', 4.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(84, N'PDV-2026-0084', 6, 5, 4, 12, '2026-02-04 14:00:00', '2026-02-07 14:00:00', '2026-02-07 15:00:00', 4.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(85, N'PDV-2026-0085', 12, 10, 4, 9, '2026-02-05 09:15:00', '2026-02-05 11:15:00', '2026-02-05 11:31:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(86, N'PDV-2026-0086', 10, 8, 4, 12, '2026-02-05 11:00:00', '2026-02-05 13:00:00', '2026-02-05 13:05:00', 29.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(87, N'PDV-2026-0087', 8, 6, 4, 3, '2026-02-05 13:00:00', '2026-02-05 15:00:00', '2026-02-05 15:15:00', 1.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(88, N'PDV-2026-0088', 1, 1, 4, 8, '2026-02-05 15:30:00', '2026-02-05 17:30:00', '2026-02-05 17:42:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(89, N'PDV-2026-0089', 12, 10, 4, 3, '2026-02-06 10:30:00', '2026-02-06 12:30:00', '2026-02-06 12:42:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(90, N'PDV-2026-0090', 25, 22, 4, 12, '2026-02-06 18:45:00', '2026-02-10 18:45:00', '2026-02-10 19:45:00', 3.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 0.00, 1400000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(91, N'PDV-2026-0091', 24, 21, 4, 12, '2026-02-07 09:30:00', '2026-02-07 11:30:00', '2026-02-07 11:40:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(92, N'PDV-2026-0092', 2, 1, 2, 11, '2026-02-07 17:45:00', '2026-02-07 19:45:00', '2026-02-07 19:51:00', 4.10, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(93, N'PDV-2026-0093', 23, 1, 4, 11, '2026-02-08 08:30:00', '2026-02-08 10:30:00', '2026-02-08 10:38:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(94, N'PDV-2026-0094', 14, 12, 2, 8, '2026-02-08 15:30:00', '2026-02-08 17:30:00', '2026-02-08 17:35:00', 3.40, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(95, N'PDV-2026-0095', 5, 4, 2, 9, '2026-02-10 13:00:00', '2026-02-10 15:00:00', '2026-02-10 15:06:00', 34.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(96, N'PDV-2026-0096', 25, 22, 4, 9, '2026-02-10 14:45:00', '2026-02-10 16:45:00', '2026-02-10 17:03:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(97, N'PDV-2026-0097', 11, 9, 2, 8, '2026-02-10 15:00:00', '2026-02-10 17:00:00', '2026-02-10 17:16:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(98, N'PDV-2026-0098', 24, 21, 4, 11, '2026-02-11 09:00:00', '2026-02-11 11:00:00', '2026-02-11 11:20:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(99, N'PDV-2026-0099', 22, 20, 2, 12, '2026-02-11 16:45:00', '2026-02-11 18:45:00', '2026-02-11 18:53:00', 22.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(100, N'PDV-2026-0100', 20, 18, 4, 8, '2026-02-12 12:00:00', '2026-02-12 14:00:00', '2026-02-12 14:07:00', 10.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True);
INSERT INTO [dbo].[tblPhieuDichVuChamSoc] ([MaPhieuDV], [SoPhieu], [MaThuCung], [MaChuNuoi], [MaNVTiepNhan], [MaNVThucHien], [NgayTiepNhan], [NgayHenTra], [NgayTraThucTe], [CanNangTiepNhan], [TinhTrangBanDau], [YeuCauCuaChuNuoi], [KetQuaChamSoc], [TongTien], [TienGiamGia], [ThanhToan], [HinhThucThanhToan], [TrangThaiThanhToan], [TrangThaiDichVu], [DanhGiaCuaChu], [GhiChu], [DaCongDiem]) VALUES
(101, N'PDV-2026-0101', 7, 5, 2, 9, '2026-02-12 15:30:00', '2026-02-12 17:30:00', '2026-02-12 17:50:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(102, N'PDV-2026-0102', 15, 13, 2, 7, '2026-02-13 08:45:00', '2026-02-13 10:45:00', '2026-02-13 10:50:00', 21.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(103, N'PDV-2026-0103', 18, 16, 4, 9, '2026-02-13 13:15:00', '2026-02-13 15:15:00', '2026-02-13 15:34:00', 2.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(104, N'PDV-2026-0104', 26, 23, 4, 3, '2026-02-13 14:30:00', '2026-02-13 16:30:00', '2026-02-13 16:36:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(105, N'PDV-2026-0105', 6, 5, 4, 9, '2026-02-13 17:45:00', '2026-02-13 19:45:00', '2026-02-13 19:57:00', 4.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(106, N'PDV-2026-0106', 21, 19, 4, 7, '2026-02-13 18:30:00', '2026-02-13 20:30:00', '2026-02-13 20:38:00', 9.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(107, N'PDV-2026-0107', 23, 1, 2, 9, '2026-02-14 16:45:00', '2026-02-14 18:45:00', '2026-02-14 18:51:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(108, N'PDV-2026-0108', 13, 11, 4, 12, '2026-02-15 09:15:00', '2026-02-15 11:15:00', '2026-02-15 11:31:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(109, N'PDV-2026-0109', 19, 17, 2, 9, '2026-02-15 10:45:00', '2026-02-15 12:45:00', '2026-02-15 13:04:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(110, N'PDV-2026-0110', 7, 5, 4, 9, '2026-02-15 14:45:00', '2026-02-15 16:45:00', '2026-02-15 17:04:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(111, N'PDV-2026-0111', 1, 1, 2, 8, '2026-02-15 15:30:00', '2026-02-15 17:30:00', '2026-02-15 17:50:00', 3.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(112, N'PDV-2026-0112', 19, 17, 2, 3, '2026-02-15 16:30:00', '2026-02-15 18:30:00', '2026-02-15 18:37:00', 36.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(113, N'PDV-2026-0113', 23, 1, 4, 9, '2026-02-15 17:30:00', '2026-02-15 19:30:00', '2026-02-15 19:48:00', 4.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(114, N'PDV-2026-0114', 18, 16, 4, 11, '2026-02-16 11:15:00', '2026-02-19 11:15:00', '2026-02-19 12:15:00', 2.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(115, N'PDV-2026-0115', 19, 17, 4, 11, '2026-02-16 12:15:00', '2026-02-16 14:15:00', '2026-02-16 14:21:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(116, N'PDV-2026-0116', 4, 3, 4, 8, '2026-02-16 13:30:00', '2026-02-16 15:30:00', '2026-02-16 15:44:00', 3.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(117, N'PDV-2026-0117', 19, 17, 2, 7, '2026-02-16 15:30:00', '2026-02-16 17:30:00', '2026-02-16 17:43:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(118, N'PDV-2026-0118', 6, 5, 4, 9, '2026-02-17 10:30:00', '2026-02-17 12:30:00', '2026-02-17 12:45:00', 4.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(119, N'PDV-2026-0119', 24, 21, 2, 11, '2026-02-17 11:30:00', '2026-02-17 13:30:00', '2026-02-17 13:46:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(120, N'PDV-2026-0120', 10, 8, 2, 11, '2026-02-17 13:00:00', '2026-02-17 15:00:00', '2026-02-17 15:16:00', 29.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(121, N'PDV-2026-0121', 25, 22, 4, 12, '2026-02-17 14:00:00', '2026-02-17 16:00:00', '2026-02-17 16:13:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(122, N'PDV-2026-0122', 26, 23, 2, 7, '2026-02-17 14:15:00', '2026-02-17 16:15:00', '2026-02-17 16:26:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(123, N'PDV-2026-0123', 7, 5, 4, 12, '2026-02-18 11:30:00', '2026-02-21 11:30:00', '2026-02-21 12:30:00', 3.20, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(124, N'PDV-2026-0124', 23, 1, 2, 7, '2026-02-18 12:30:00', '2026-02-18 14:30:00', '2026-02-18 14:40:00', 4.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(125, N'PDV-2026-0125', 10, 8, 4, 11, '2026-02-19 14:00:00', '2026-02-19 16:00:00', '2026-02-19 16:17:00', 29.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(126, N'PDV-2026-0126', 20, 18, 4, 8, '2026-02-19 18:15:00', '2026-02-19 20:15:00', '2026-02-19 20:25:00', 10.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(127, N'PDV-2026-0127', 21, 19, 4, 11, '2026-02-20 09:30:00', '2026-02-20 11:30:00', '2026-02-20 11:47:00', 9.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(128, N'PDV-2026-0128', 7, 5, 2, 7, '2026-02-20 15:45:00', '2026-02-20 17:45:00', '2026-02-20 17:58:00', 3.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(129, N'PDV-2026-0129', 23, 1, 2, 7, '2026-02-20 16:00:00', '2026-02-20 18:00:00', '2026-02-20 18:12:00', 4.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(130, N'PDV-2026-0130', 2, 1, 2, 12, '2026-02-20 17:15:00', '2026-02-20 19:15:00', '2026-02-20 19:27:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(131, N'PDV-2026-0131', 23, 1, 4, 8, '2026-02-21 10:00:00', '2026-02-21 12:00:00', '2026-02-21 12:12:00', 4.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(132, N'PDV-2026-0132', 17, 15, 2, 3, '2026-02-21 11:30:00', '2026-02-21 13:30:00', '2026-02-21 13:50:00', 7.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(133, N'PDV-2026-0133', 19, 17, 2, 11, '2026-02-21 12:00:00', '2026-02-21 14:00:00', '2026-02-21 14:10:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(134, N'PDV-2026-0134', 16, 14, 2, 12, '2026-02-21 16:30:00', '2026-02-21 18:30:00', '2026-02-21 18:44:00', 2.30, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(135, N'PDV-2026-0135', 6, 5, 4, 11, '2026-02-21 17:15:00', '2026-02-24 17:15:00', '2026-02-24 18:15:00', 4.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(136, N'PDV-2026-0136', 14, 12, 4, 8, '2026-02-22 10:00:00', '2026-02-22 12:00:00', '2026-02-22 12:10:00', 3.40, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(137, N'PDV-2026-0137', 13, 11, 2, 3, '2026-02-22 12:00:00', '2026-02-22 14:00:00', '2026-02-22 14:12:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(138, N'PDV-2026-0138', 25, 22, 2, 11, '2026-02-22 16:30:00', '2026-02-22 18:30:00', '2026-02-22 18:39:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(139, N'PDV-2026-0139', 4, 3, 4, 7, '2026-02-22 17:00:00', '2026-02-22 19:00:00', '2026-02-22 19:09:00', 3.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(140, N'PDV-2026-0140', 3, 2, 2, 8, '2026-02-22 18:00:00', '2026-02-22 20:00:00', '2026-02-22 20:16:00', 11.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(141, N'PDV-2026-0141', 17, 15, 2, 3, '2026-02-22 18:45:00', '2026-02-22 20:45:00', '2026-02-22 21:01:00', 7.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(142, N'PDV-2026-0142', 2, 1, 4, 9, '2026-02-23 15:30:00', '2026-02-27 15:30:00', '2026-02-27 16:30:00', 4.10, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 0.00, 1400000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(143, N'PDV-2026-0143', 12, 10, 2, 12, '2026-02-24 08:30:00', '2026-02-24 10:30:00', '2026-02-24 10:37:00', 8.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(144, N'PDV-2026-0144', 6, 5, 4, 12, '2026-02-24 15:45:00', '2026-02-24 17:45:00', '2026-02-24 18:00:00', 4.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(145, N'PDV-2026-0145', 21, 19, 4, 12, '2026-02-24 17:00:00', '2026-02-24 19:00:00', '2026-02-24 19:13:00', 9.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(146, N'PDV-2026-0146', 3, 2, 2, 7, '2026-02-24 18:15:00', '2026-02-24 20:15:00', '2026-02-24 20:30:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(147, N'PDV-2026-0147', 4, 3, 2, 11, '2026-02-25 12:15:00', '2026-02-25 14:15:00', '2026-02-25 14:29:00', 3.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(148, N'PDV-2026-0148', 3, 2, 2, 7, '2026-02-25 15:45:00', '2026-02-25 17:45:00', '2026-02-25 17:50:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(149, N'PDV-2026-0149', 14, 12, 4, 12, '2026-02-26 10:45:00', '2026-02-26 12:45:00', '2026-02-26 12:51:00', 3.40, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(150, N'PDV-2026-0150', 18, 16, 4, 8, '2026-02-26 15:00:00', '2026-02-26 17:00:00', '2026-02-26 17:16:00', 2.90, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 30000.00, 150000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(151, N'PDV-2026-0151', 2, 1, 4, 7, '2026-02-27 08:15:00', '2026-02-27 10:15:00', '2026-02-27 10:22:00', 4.10, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(152, N'PDV-2026-0152', 19, 17, 2, 11, '2026-02-27 18:15:00', '2026-02-27 20:15:00', '2026-02-27 20:21:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(153, N'PDV-2026-0153', 25, 22, 2, 7, '2026-02-28 09:30:00', '2026-02-28 11:30:00', '2026-02-28 11:37:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(154, N'PDV-2026-0154', 22, 20, 2, 12, '2026-02-28 14:45:00', '2026-02-28 16:45:00', '2026-02-28 16:52:00', 22.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(155, N'PDV-2026-0155', 1, 1, 4, 9, '2026-03-01 08:45:00', '2026-03-05 08:45:00', '2026-03-05 09:45:00', 3.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 0.00, 800000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(156, N'PDV-2026-0156', 9, 7, 2, 9, '2026-03-01 11:30:00', '2026-03-01 13:30:00', '2026-03-01 13:36:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(157, N'PDV-2026-0157', 25, 22, 2, 12, '2026-03-01 12:45:00', '2026-03-05 12:45:00', '2026-03-05 13:45:00', 3.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 0.00, 800000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(158, N'PDV-2026-0158', 26, 23, 4, 12, '2026-03-01 15:15:00', '2026-03-01 17:15:00', '2026-03-01 17:34:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(159, N'PDV-2026-0159', 16, 14, 2, 7, '2026-03-01 18:30:00', '2026-03-01 20:30:00', '2026-03-01 20:49:00', 2.30, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(160, N'PDV-2026-0160', 26, 23, 4, 3, '2026-03-02 17:45:00', '2026-03-02 19:45:00', '2026-03-02 20:00:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(161, N'PDV-2026-0161', 7, 5, 4, 7, '2026-03-04 09:15:00', '2026-03-04 11:15:00', '2026-03-04 11:27:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(162, N'PDV-2026-0162', 11, 9, 2, 8, '2026-03-04 16:15:00', '2026-03-04 18:15:00', '2026-03-04 18:31:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(163, N'PDV-2026-0163', 16, 14, 2, 3, '2026-03-05 12:30:00', '2026-03-05 14:30:00', '2026-03-05 14:43:00', 2.30, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(164, N'PDV-2026-0164', 13, 11, 4, 3, '2026-03-05 17:30:00', '2026-03-05 19:30:00', '2026-03-05 19:48:00', 26.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(165, N'PDV-2026-0165', 6, 5, 4, 8, '2026-03-06 15:30:00', '2026-03-06 17:30:00', '2026-03-06 17:39:00', 4.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(166, N'PDV-2026-0166', 22, 20, 4, 8, '2026-03-06 17:15:00', '2026-03-06 19:15:00', '2026-03-06 19:32:00', 22.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(167, N'PDV-2026-0167', 9, 7, 2, 12, '2026-03-07 10:30:00', '2026-03-07 12:30:00', '2026-03-07 12:40:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(168, N'PDV-2026-0168', 10, 8, 2, 8, '2026-03-07 14:00:00', '2026-03-07 16:00:00', '2026-03-07 16:12:00', 29.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(169, N'PDV-2026-0169', 22, 20, 4, 8, '2026-03-07 14:45:00', '2026-03-07 16:45:00', '2026-03-07 17:03:00', 22.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(170, N'PDV-2026-0170', 6, 5, 2, 11, '2026-03-07 17:30:00', '2026-03-07 19:30:00', '2026-03-07 19:48:00', 4.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(171, N'PDV-2026-0171', 26, 23, 4, 3, '2026-03-08 12:15:00', '2026-03-08 14:15:00', '2026-03-08 14:33:00', 5.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(172, N'PDV-2026-0172', 1, 1, 4, 3, '2026-03-08 16:45:00', '2026-03-12 16:45:00', '2026-03-12 17:45:00', 3.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 30000.00, 1370000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(173, N'PDV-2026-0173', 8, 6, 2, 12, '2026-03-09 18:15:00', '2026-03-09 20:15:00', '2026-03-09 20:24:00', 1.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(174, N'PDV-2026-0174', 26, 23, 2, 3, '2026-03-11 09:30:00', '2026-03-11 11:30:00', '2026-03-11 11:36:00', 5.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 30000.00, 150000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(175, N'PDV-2026-0175', 1, 1, 4, 8, '2026-03-11 13:00:00', '2026-03-11 15:00:00', '2026-03-11 15:07:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(176, N'PDV-2026-0176', 11, 9, 2, 8, '2026-03-11 17:15:00', '2026-03-15 17:15:00', '2026-03-15 18:15:00', 3.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 0.00, 1400000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(177, N'PDV-2026-0177', 6, 5, 2, 9, '2026-03-12 10:15:00', '2026-03-12 12:15:00', '2026-03-12 12:35:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(178, N'PDV-2026-0178', 20, 18, 2, 8, '2026-03-12 12:15:00', '2026-03-12 14:15:00', '2026-03-12 14:35:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(179, N'PDV-2026-0179', 12, 10, 2, 8, '2026-03-12 14:45:00', '2026-03-12 16:45:00', '2026-03-12 16:54:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(180, N'PDV-2026-0180', 19, 17, 4, 8, '2026-03-13 08:15:00', '2026-03-13 10:15:00', '2026-03-13 10:34:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(181, N'PDV-2026-0181', 11, 9, 4, 7, '2026-03-13 09:00:00', '2026-03-13 11:00:00', '2026-03-13 11:08:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(182, N'PDV-2026-0182', 12, 10, 4, 8, '2026-03-13 17:45:00', '2026-03-13 19:45:00', '2026-03-13 19:53:00', 8.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(183, N'PDV-2026-0183', 14, 12, 2, 12, '2026-03-13 18:30:00', '2026-03-13 20:30:00', '2026-03-13 20:42:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(184, N'PDV-2026-0184', 23, 1, 2, 3, '2026-03-14 10:15:00', '2026-03-14 12:15:00', '2026-03-14 12:22:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(185, N'PDV-2026-0185', 1, 1, 2, 7, '2026-03-14 15:45:00', '2026-03-14 17:45:00', '2026-03-14 17:53:00', 3.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(186, N'PDV-2026-0186', 25, 22, 2, 12, '2026-03-15 15:30:00', '2026-03-17 15:30:00', '2026-03-17 16:30:00', 3.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 700000.00, 0.00, 700000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(187, N'PDV-2026-0187', 3, 2, 4, 8, '2026-03-16 08:00:00', '2026-03-16 10:00:00', '2026-03-16 10:10:00', 11.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(188, N'PDV-2026-0188', 25, 22, 4, 9, '2026-03-17 09:00:00', '2026-03-17 11:00:00', '2026-03-17 11:13:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(189, N'PDV-2026-0189', 18, 16, 4, 8, '2026-03-17 10:15:00', '2026-03-17 12:15:00', '2026-03-17 12:30:00', 2.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(190, N'PDV-2026-0190', 23, 1, 2, 3, '2026-03-17 14:00:00', '2026-03-17 16:00:00', '2026-03-17 16:16:00', 4.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(191, N'PDV-2026-0191', 15, 13, 4, 12, '2026-03-17 17:00:00', '2026-03-17 19:00:00', '2026-03-17 19:10:00', 21.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(192, N'PDV-2026-0192', 10, 8, 4, 9, '2026-03-18 10:30:00', '2026-03-20 10:30:00', '2026-03-20 11:30:00', 29.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(193, N'PDV-2026-0193', 4, 3, 2, 7, '2026-03-19 09:15:00', '2026-03-19 11:15:00', '2026-03-19 11:30:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(194, N'PDV-2026-0194', 22, 20, 2, 12, '2026-03-19 11:15:00', '2026-03-21 11:15:00', '2026-03-21 12:15:00', 22.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(195, N'PDV-2026-0195', 11, 9, 2, 11, '2026-03-19 18:00:00', '2026-03-19 20:00:00', '2026-03-19 20:10:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(196, N'PDV-2026-0196', 6, 5, 4, 12, '2026-03-20 10:45:00', '2026-03-20 12:45:00', '2026-03-20 13:03:00', 4.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(197, N'PDV-2026-0197', 4, 3, 2, 3, '2026-03-22 15:15:00', '2026-03-22 17:15:00', '2026-03-22 17:22:00', 3.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(198, N'PDV-2026-0198', 14, 12, 2, 3, '2026-03-24 13:00:00', '2026-03-24 15:00:00', '2026-03-24 15:08:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(199, N'PDV-2026-0199', 23, 1, 2, 3, '2026-03-25 17:30:00', '2026-03-25 19:30:00', '2026-03-25 19:42:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(200, N'PDV-2026-0200', 21, 19, 2, 11, '2026-03-26 10:15:00', '2026-03-26 12:15:00', '2026-03-26 12:28:00', 9.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True);
INSERT INTO [dbo].[tblPhieuDichVuChamSoc] ([MaPhieuDV], [SoPhieu], [MaThuCung], [MaChuNuoi], [MaNVTiepNhan], [MaNVThucHien], [NgayTiepNhan], [NgayHenTra], [NgayTraThucTe], [CanNangTiepNhan], [TinhTrangBanDau], [YeuCauCuaChuNuoi], [KetQuaChamSoc], [TongTien], [TienGiamGia], [ThanhToan], [HinhThucThanhToan], [TrangThaiThanhToan], [TrangThaiDichVu], [DanhGiaCuaChu], [GhiChu], [DaCongDiem]) VALUES
(201, N'PDV-2026-0201', 9, 7, 4, 7, '2026-03-26 11:30:00', '2026-03-26 13:30:00', '2026-03-26 13:47:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(202, N'PDV-2026-0202', 11, 9, 4, 11, '2026-03-27 10:30:00', '2026-03-27 12:30:00', '2026-03-27 12:44:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(203, N'PDV-2026-0203', 15, 13, 4, 8, '2026-03-27 17:45:00', '2026-03-27 19:45:00', '2026-03-27 20:00:00', 21.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(204, N'PDV-2026-0204', 4, 3, 4, 3, '2026-03-29 18:00:00', '2026-03-29 20:00:00', '2026-03-29 20:06:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(205, N'PDV-2026-0205', 23, 1, 4, 7, '2026-03-30 08:15:00', '2026-03-30 10:15:00', '2026-03-30 10:26:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(206, N'PDV-2026-0206', 9, 7, 4, 7, '2026-03-31 14:15:00', '2026-03-31 16:15:00', '2026-03-31 16:35:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(207, N'PDV-2026-0207', 23, 1, 2, 7, '2026-04-01 12:15:00', '2026-04-01 14:15:00', '2026-04-01 14:27:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(208, N'PDV-2026-0208', 9, 7, 4, 12, '2026-04-01 13:30:00', '2026-04-01 15:30:00', '2026-04-01 15:44:00', 4.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(209, N'PDV-2026-0209', 7, 5, 4, 12, '2026-04-02 09:30:00', '2026-04-02 11:30:00', '2026-04-02 11:41:00', 3.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(210, N'PDV-2026-0210', 19, 17, 4, 12, '2026-04-02 15:00:00', '2026-04-02 17:00:00', '2026-04-02 17:10:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(211, N'PDV-2026-0211', 6, 5, 2, 8, '2026-04-02 18:30:00', '2026-04-02 20:30:00', '2026-04-02 20:43:00', 4.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(212, N'PDV-2026-0212', 23, 1, 4, 8, '2026-04-03 08:15:00', '2026-04-07 08:15:00', '2026-04-07 09:15:00', 4.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 30000.00, 770000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(213, N'PDV-2026-0213', 26, 23, 2, 9, '2026-04-03 12:00:00', '2026-04-03 14:00:00', '2026-04-03 14:11:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(214, N'PDV-2026-0214', 12, 10, 2, 7, '2026-04-03 16:45:00', '2026-04-03 18:45:00', '2026-04-03 18:50:00', 8.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(215, N'PDV-2026-0215', 22, 20, 2, 11, '2026-04-03 17:00:00', '2026-04-03 19:00:00', '2026-04-03 19:18:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(216, N'PDV-2026-0216', 25, 22, 2, 9, '2026-04-03 18:30:00', '2026-04-03 20:30:00', '2026-04-03 20:48:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(217, N'PDV-2026-0217', 6, 5, 4, 7, '2026-04-04 08:15:00', '2026-04-04 10:15:00', '2026-04-04 10:20:00', 4.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(218, N'PDV-2026-0218', 6, 5, 4, 9, '2026-04-06 08:45:00', '2026-04-06 10:45:00', '2026-04-06 10:51:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(219, N'PDV-2026-0219', 15, 13, 4, 7, '2026-04-06 15:00:00', '2026-04-06 17:00:00', '2026-04-06 17:13:00', 21.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(220, N'PDV-2026-0220', 7, 5, 4, 11, '2026-04-06 18:30:00', '2026-04-06 20:30:00', '2026-04-06 20:36:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(221, N'PDV-2026-0221', 2, 1, 4, 3, '2026-04-07 11:00:00', '2026-04-10 11:00:00', '2026-04-10 12:00:00', 4.10, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(222, N'PDV-2026-0222', 19, 17, 4, 11, '2026-04-08 09:00:00', '2026-04-08 11:00:00', '2026-04-08 11:17:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(223, N'PDV-2026-0223', 19, 17, 2, 12, '2026-04-08 17:30:00', '2026-04-08 19:30:00', '2026-04-08 19:46:00', 36.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(224, N'PDV-2026-0224', 18, 16, 2, 11, '2026-04-08 18:15:00', '2026-04-08 20:15:00', '2026-04-08 20:28:00', 2.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(225, N'PDV-2026-0225', 15, 13, 2, 8, '2026-04-09 14:00:00', '2026-04-09 16:00:00', '2026-04-09 16:11:00', 21.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(226, N'PDV-2026-0226', 2, 1, 4, 7, '2026-04-09 14:15:00', '2026-04-09 16:15:00', '2026-04-09 16:32:00', 4.10, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(227, N'PDV-2026-0227', 4, 3, 2, 9, '2026-04-11 08:45:00', '2026-04-14 08:45:00', '2026-04-14 09:45:00', 3.60, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(228, N'PDV-2026-0228', 11, 9, 2, 12, '2026-04-11 09:15:00', '2026-04-11 11:15:00', '2026-04-11 11:31:00', 3.90, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(229, N'PDV-2026-0229', 3, 2, 2, 11, '2026-04-11 15:30:00', '2026-04-11 17:30:00', '2026-04-11 17:42:00', 11.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 30000.00, 150000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(230, N'PDV-2026-0230', 11, 9, 2, 7, '2026-04-11 17:15:00', '2026-04-11 19:15:00', '2026-04-11 19:24:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(231, N'PDV-2026-0231', 9, 7, 4, 11, '2026-04-12 11:15:00', '2026-04-12 13:15:00', '2026-04-12 13:28:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(232, N'PDV-2026-0232', 24, 21, 2, 11, '2026-04-12 17:45:00', '2026-04-12 19:45:00', '2026-04-12 19:56:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(233, N'PDV-2026-0233', 8, 6, 4, 8, '2026-04-13 18:00:00', '2026-04-13 20:00:00', '2026-04-13 20:05:00', 1.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(234, N'PDV-2026-0234', 3, 2, 4, 8, '2026-04-14 16:45:00', '2026-04-14 18:45:00', '2026-04-14 18:51:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(235, N'PDV-2026-0235', 14, 12, 2, 11, '2026-04-15 08:45:00', '2026-04-15 10:45:00', '2026-04-15 10:53:00', 3.40, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(236, N'PDV-2026-0236', 1, 1, 4, 7, '2026-04-15 09:00:00', '2026-04-18 09:00:00', '2026-04-18 10:00:00', 3.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 30000.00, 570000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(237, N'PDV-2026-0237', 1, 1, 2, 11, '2026-04-15 09:15:00', '2026-04-15 11:15:00', '2026-04-15 11:23:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(238, N'PDV-2026-0238', 16, 14, 4, 7, '2026-04-15 14:15:00', '2026-04-15 16:15:00', '2026-04-15 16:33:00', 2.30, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(239, N'PDV-2026-0239', 4, 3, 4, 11, '2026-04-15 15:30:00', '2026-04-15 17:30:00', '2026-04-15 17:48:00', 3.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(240, N'PDV-2026-0240', 16, 14, 2, 7, '2026-04-15 16:30:00', '2026-04-15 18:30:00', '2026-04-15 18:36:00', 2.30, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(241, N'PDV-2026-0241', 7, 5, 2, 12, '2026-04-16 11:00:00', '2026-04-16 13:00:00', '2026-04-16 13:05:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(242, N'PDV-2026-0242', 8, 6, 2, 8, '2026-04-17 18:00:00', '2026-04-17 20:00:00', '2026-04-17 20:10:00', 1.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(243, N'PDV-2026-0243', 2, 1, 2, 3, '2026-04-18 12:15:00', '2026-04-18 14:15:00', '2026-04-18 14:35:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(244, N'PDV-2026-0244', 9, 7, 2, 7, '2026-04-18 13:30:00', '2026-04-18 15:30:00', '2026-04-18 15:40:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(245, N'PDV-2026-0245', 11, 9, 2, 8, '2026-04-18 18:45:00', '2026-04-21 18:45:00', '2026-04-21 19:45:00', 3.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(246, N'PDV-2026-0246', 14, 12, 4, 8, '2026-04-19 09:30:00', '2026-04-19 11:30:00', '2026-04-19 11:46:00', 3.40, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(247, N'PDV-2026-0247', 3, 2, 2, 12, '2026-04-19 12:00:00', '2026-04-19 14:00:00', '2026-04-19 14:05:00', 11.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(248, N'PDV-2026-0248', 25, 22, 4, 3, '2026-04-19 14:30:00', '2026-04-19 16:30:00', '2026-04-19 16:40:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(249, N'PDV-2026-0249', 20, 18, 4, 12, '2026-04-20 08:15:00', '2026-04-23 08:15:00', '2026-04-23 09:15:00', 10.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(250, N'PDV-2026-0250', 2, 1, 4, 9, '2026-04-20 11:00:00', '2026-04-20 13:00:00', '2026-04-20 13:13:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(251, N'PDV-2026-0251', 21, 19, 4, 9, '2026-04-21 11:15:00', '2026-04-21 13:15:00', '2026-04-21 13:28:00', 9.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(252, N'PDV-2026-0252', 10, 8, 2, 8, '2026-04-22 15:15:00', '2026-04-26 15:15:00', '2026-04-26 16:15:00', 29.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 0.00, 800000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(253, N'PDV-2026-0253', 8, 6, 2, 8, '2026-04-23 14:15:00', '2026-04-23 16:15:00', '2026-04-23 16:21:00', 1.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(254, N'PDV-2026-0254', 20, 18, 4, 12, '2026-04-24 09:00:00', '2026-04-24 11:00:00', '2026-04-24 11:15:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(255, N'PDV-2026-0255', 11, 9, 4, 7, '2026-04-24 12:00:00', '2026-04-24 14:00:00', '2026-04-24 14:05:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(256, N'PDV-2026-0256', 1, 1, 2, 3, '2026-04-24 16:00:00', '2026-04-24 18:00:00', '2026-04-24 18:06:00', 3.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(257, N'PDV-2026-0257', 7, 5, 2, 11, '2026-04-25 15:15:00', '2026-04-25 17:15:00', '2026-04-25 17:25:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(258, N'PDV-2026-0258', 16, 14, 4, 7, '2026-04-26 08:45:00', '2026-04-29 08:45:00', '2026-04-29 09:45:00', 2.30, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(259, N'PDV-2026-0259', 23, 1, 4, 11, '2026-04-26 10:00:00', '2026-04-26 12:00:00', '2026-04-26 12:14:00', 4.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(260, N'PDV-2026-0260', 22, 20, 4, 3, '2026-04-26 14:45:00', '2026-04-26 16:45:00', '2026-04-26 17:05:00', 22.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(261, N'PDV-2026-0261', 6, 5, 4, 11, '2026-04-26 18:45:00', '2026-04-26 20:45:00', '2026-04-26 21:00:00', 4.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(262, N'PDV-2026-0262', 11, 9, 2, 3, '2026-04-27 18:15:00', '2026-04-27 20:15:00', '2026-04-27 20:28:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(263, N'PDV-2026-0263', 12, 10, 4, 9, '2026-04-28 16:30:00', '2026-04-28 18:30:00', '2026-04-28 18:37:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(264, N'PDV-2026-0264', 21, 19, 4, 8, '2026-04-30 08:45:00', '2026-04-30 10:45:00', '2026-04-30 10:59:00', 9.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(265, N'PDV-2026-0265', 19, 17, 4, 9, '2026-05-01 16:00:00', '2026-05-01 18:00:00', '2026-05-01 18:18:00', 36.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(266, N'PDV-2026-0266', 20, 18, 4, 11, '2026-05-02 08:30:00', '2026-05-06 08:30:00', '2026-05-06 09:30:00', 10.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 0.00, 1400000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(267, N'PDV-2026-0267', 26, 23, 4, 3, '2026-05-02 18:30:00', '2026-05-02 20:30:00', '2026-05-02 20:50:00', 5.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(268, N'PDV-2026-0268', 13, 11, 2, 8, '2026-05-03 12:45:00', '2026-05-03 14:45:00', '2026-05-03 15:02:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(269, N'PDV-2026-0269', 18, 16, 4, 3, '2026-05-03 16:15:00', '2026-05-03 18:15:00', '2026-05-03 18:33:00', 2.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(270, N'PDV-2026-0270', 14, 12, 4, 8, '2026-05-03 17:15:00', '2026-05-03 19:15:00', '2026-05-03 19:28:00', 3.40, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(271, N'PDV-2026-0271', 11, 9, 4, 12, '2026-05-04 09:15:00', '2026-05-08 09:15:00', '2026-05-08 10:15:00', 3.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 0.00, 1400000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(272, N'PDV-2026-0272', 26, 23, 2, 3, '2026-05-04 10:45:00', '2026-05-04 12:45:00', '2026-05-04 12:51:00', 5.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(273, N'PDV-2026-0273', 14, 12, 2, 7, '2026-05-04 14:30:00', '2026-05-04 16:30:00', '2026-05-04 16:47:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(274, N'PDV-2026-0274', 18, 16, 2, 3, '2026-05-04 14:45:00', '2026-05-04 16:45:00', '2026-05-04 16:51:00', 2.90, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(275, N'PDV-2026-0275', 20, 18, 4, 11, '2026-05-05 10:15:00', '2026-05-05 12:15:00', '2026-05-05 12:27:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(276, N'PDV-2026-0276', 3, 2, 4, 9, '2026-05-05 12:45:00', '2026-05-05 14:45:00', '2026-05-05 14:57:00', 11.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(277, N'PDV-2026-0277', 23, 1, 2, 11, '2026-05-05 14:30:00', '2026-05-05 16:30:00', '2026-05-05 16:45:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(278, N'PDV-2026-0278', 14, 12, 2, 3, '2026-05-05 17:30:00', '2026-05-05 19:30:00', '2026-05-05 19:45:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(279, N'PDV-2026-0279', 10, 8, 2, 11, '2026-05-05 18:15:00', '2026-05-05 20:15:00', '2026-05-05 20:23:00', 29.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(280, N'PDV-2026-0280', 23, 1, 4, 7, '2026-05-06 08:45:00', '2026-05-06 10:45:00', '2026-05-06 10:56:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(281, N'PDV-2026-0281', 5, 4, 2, 9, '2026-05-08 08:15:00', '2026-05-08 10:15:00', '2026-05-08 10:25:00', 34.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(282, N'PDV-2026-0282', 1, 1, 4, 8, '2026-05-09 10:15:00', '2026-05-09 12:15:00', '2026-05-09 12:28:00', 3.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(283, N'PDV-2026-0283', 6, 5, 2, 7, '2026-05-09 15:00:00', '2026-05-09 17:00:00', '2026-05-09 17:08:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(284, N'PDV-2026-0284', 4, 3, 4, 8, '2026-05-10 11:45:00', '2026-05-10 13:45:00', '2026-05-10 13:50:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(285, N'PDV-2026-0285', 1, 1, 4, 11, '2026-05-10 14:00:00', '2026-05-10 16:00:00', '2026-05-10 16:08:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(286, N'PDV-2026-0286', 6, 5, 2, 12, '2026-05-10 15:15:00', '2026-05-10 17:15:00', '2026-05-10 17:22:00', 4.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(287, N'PDV-2026-0287', 22, 20, 4, 3, '2026-05-10 18:15:00', '2026-05-10 20:15:00', '2026-05-10 20:29:00', 22.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(288, N'PDV-2026-0288', 13, 11, 4, 8, '2026-05-12 13:15:00', '2026-05-12 15:15:00', '2026-05-12 15:23:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(289, N'PDV-2026-0289', 5, 4, 4, 9, '2026-05-12 14:15:00', '2026-05-12 16:15:00', '2026-05-12 16:29:00', 34.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(290, N'PDV-2026-0290', 1, 1, 2, 9, '2026-05-13 14:15:00', '2026-05-13 16:15:00', '2026-05-13 16:23:00', 3.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(291, N'PDV-2026-0291', 25, 22, 4, 3, '2026-05-15 11:30:00', '2026-05-18 11:30:00', '2026-05-18 12:30:00', 3.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(292, N'PDV-2026-0292', 22, 20, 2, 7, '2026-05-15 18:00:00', '2026-05-15 20:00:00', '2026-05-15 20:14:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(293, N'PDV-2026-0293', 18, 16, 2, 3, '2026-05-16 13:45:00', '2026-05-16 15:45:00', '2026-05-16 15:54:00', 2.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(294, N'PDV-2026-0294', 16, 14, 4, 9, '2026-05-17 14:30:00', '2026-05-17 16:30:00', '2026-05-17 16:46:00', 2.30, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(295, N'PDV-2026-0295', 23, 1, 4, 11, '2026-05-17 14:30:00', '2026-05-20 14:30:00', '2026-05-20 15:30:00', 4.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(296, N'PDV-2026-0296', 5, 4, 2, 11, '2026-05-17 18:30:00', '2026-05-17 20:30:00', '2026-05-17 20:41:00', 34.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(297, N'PDV-2026-0297', 23, 1, 2, 7, '2026-05-18 08:00:00', '2026-05-21 08:00:00', '2026-05-21 09:00:00', 4.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(298, N'PDV-2026-0298', 21, 19, 4, 7, '2026-05-19 16:15:00', '2026-05-19 18:15:00', '2026-05-19 18:32:00', 9.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(299, N'PDV-2026-0299', 10, 8, 2, 12, '2026-05-19 17:45:00', '2026-05-19 19:45:00', '2026-05-19 19:52:00', 29.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(300, N'PDV-2026-0300', 22, 20, 2, 8, '2026-05-20 14:30:00', '2026-05-23 14:30:00', '2026-05-23 15:30:00', 22.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True);
INSERT INTO [dbo].[tblPhieuDichVuChamSoc] ([MaPhieuDV], [SoPhieu], [MaThuCung], [MaChuNuoi], [MaNVTiepNhan], [MaNVThucHien], [NgayTiepNhan], [NgayHenTra], [NgayTraThucTe], [CanNangTiepNhan], [TinhTrangBanDau], [YeuCauCuaChuNuoi], [KetQuaChamSoc], [TongTien], [TienGiamGia], [ThanhToan], [HinhThucThanhToan], [TrangThaiThanhToan], [TrangThaiDichVu], [DanhGiaCuaChu], [GhiChu], [DaCongDiem]) VALUES
(301, N'PDV-2026-0301', 8, 6, 4, 12, '2026-05-20 18:15:00', '2026-05-20 20:15:00', '2026-05-20 20:32:00', 1.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(302, N'PDV-2026-0302', 23, 1, 2, 11, '2026-05-21 10:00:00', '2026-05-21 12:00:00', '2026-05-21 12:09:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(303, N'PDV-2026-0303', 22, 20, 4, 9, '2026-05-21 13:00:00', '2026-05-21 15:00:00', '2026-05-21 15:12:00', 22.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(304, N'PDV-2026-0304', 5, 4, 2, 7, '2026-05-21 17:00:00', '2026-05-21 19:00:00', '2026-05-21 19:13:00', 34.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 30000.00, 150000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(305, N'PDV-2026-0305', 23, 1, 4, 11, '2026-05-22 12:15:00', '2026-05-22 14:15:00', '2026-05-22 14:21:00', 4.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(306, N'PDV-2026-0306', 13, 11, 4, 9, '2026-05-22 13:45:00', '2026-05-22 15:45:00', '2026-05-22 15:53:00', 26.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(307, N'PDV-2026-0307', 25, 22, 2, 12, '2026-05-22 15:15:00', '2026-05-22 17:15:00', '2026-05-22 17:22:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(308, N'PDV-2026-0308', 23, 1, 2, 7, '2026-05-23 18:15:00', '2026-05-23 20:15:00', '2026-05-23 20:30:00', 4.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(309, N'PDV-2026-0309', 15, 13, 4, 3, '2026-05-24 18:15:00', '2026-05-24 20:15:00', '2026-05-24 20:20:00', 21.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(310, N'PDV-2026-0310', 22, 20, 4, 8, '2026-05-26 13:00:00', '2026-05-26 15:00:00', '2026-05-26 15:20:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(311, N'PDV-2026-0311', 2, 1, 4, 12, '2026-05-26 16:45:00', '2026-05-26 18:45:00', '2026-05-26 19:05:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(312, N'PDV-2026-0312', 15, 13, 4, 3, '2026-05-27 11:00:00', '2026-05-27 13:00:00', '2026-05-27 13:19:00', 21.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(313, N'PDV-2026-0313', 16, 14, 4, 8, '2026-05-27 13:15:00', '2026-05-27 15:15:00', '2026-05-27 15:30:00', 2.30, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(314, N'PDV-2026-0314', 20, 18, 4, 11, '2026-05-27 14:15:00', '2026-05-27 16:15:00', '2026-05-27 16:25:00', 10.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(315, N'PDV-2026-0315', 22, 20, 2, 7, '2026-05-28 08:00:00', '2026-05-28 10:00:00', '2026-05-28 10:09:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(316, N'PDV-2026-0316', 11, 9, 2, 7, '2026-05-28 10:00:00', '2026-06-01 10:00:00', '2026-06-01 11:00:00', 3.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 0.00, 800000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(317, N'PDV-2026-0317', 25, 22, 2, 3, '2026-05-28 16:00:00', '2026-05-28 18:00:00', '2026-05-28 18:17:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(318, N'PDV-2026-0318', 15, 13, 2, 11, '2026-05-28 17:15:00', '2026-05-28 19:15:00', '2026-05-28 19:24:00', 21.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(319, N'PDV-2026-0319', 23, 1, 4, 3, '2026-05-29 10:45:00', '2026-05-29 12:45:00', '2026-05-29 12:54:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(320, N'PDV-2026-0320', 15, 13, 2, 3, '2026-05-30 13:45:00', '2026-06-01 13:45:00', '2026-06-01 14:45:00', 21.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 700000.00, 0.00, 700000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(321, N'PDV-2026-0321', 25, 22, 4, 11, '2026-05-31 13:00:00', '2026-05-31 15:00:00', '2026-05-31 15:12:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(322, N'PDV-2026-0322', 8, 6, 4, 7, '2026-05-31 13:30:00', '2026-05-31 15:30:00', '2026-05-31 15:36:00', 1.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(323, N'PDV-2026-0323', 3, 2, 2, 8, '2026-05-31 14:00:00', '2026-05-31 16:00:00', '2026-05-31 16:14:00', 11.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(324, N'PDV-2026-0324', 7, 5, 2, 12, '2026-05-31 16:00:00', '2026-05-31 18:00:00', '2026-05-31 18:07:00', 3.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(325, N'PDV-2026-0325', 10, 8, 4, 9, '2026-06-01 08:15:00', '2026-06-01 10:15:00', '2026-06-01 10:31:00', 29.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(326, N'PDV-2026-0326', 13, 11, 2, 3, '2026-06-01 10:30:00', '2026-06-05 10:30:00', '2026-06-05 11:30:00', 26.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 0.00, 1400000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(327, N'PDV-2026-0327', 22, 20, 2, 9, '2026-06-01 14:00:00', '2026-06-01 16:00:00', '2026-06-01 16:16:00', 22.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(328, N'PDV-2026-0328', 26, 23, 2, 9, '2026-06-01 14:30:00', '2026-06-01 16:30:00', '2026-06-01 16:42:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(329, N'PDV-2026-0329', 4, 3, 4, 9, '2026-06-02 08:45:00', '2026-06-02 10:45:00', '2026-06-02 10:52:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(330, N'PDV-2026-0330', 7, 5, 2, 3, '2026-06-02 09:30:00', '2026-06-02 11:30:00', '2026-06-02 11:37:00', 3.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(331, N'PDV-2026-0331', 5, 4, 4, 7, '2026-06-02 15:30:00', '2026-06-02 17:30:00', '2026-06-02 17:39:00', 34.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(332, N'PDV-2026-0332', 21, 19, 2, 12, '2026-06-04 12:00:00', '2026-06-04 14:00:00', '2026-06-04 14:17:00', 9.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(333, N'PDV-2026-0333', 18, 16, 2, 9, '2026-06-05 08:45:00', '2026-06-05 10:45:00', '2026-06-05 11:05:00', 2.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(334, N'PDV-2026-0334', 7, 5, 2, 8, '2026-06-05 11:30:00', '2026-06-05 13:30:00', '2026-06-05 13:37:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(335, N'PDV-2026-0335', 7, 5, 4, 11, '2026-06-05 15:00:00', '2026-06-05 17:00:00', '2026-06-05 17:12:00', 3.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(336, N'PDV-2026-0336', 26, 23, 4, 3, '2026-06-06 08:30:00', '2026-06-06 10:30:00', '2026-06-06 10:41:00', 5.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(337, N'PDV-2026-0337', 22, 20, 2, 9, '2026-06-06 10:45:00', '2026-06-09 10:45:00', '2026-06-09 11:45:00', 22.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(338, N'PDV-2026-0338', 15, 13, 4, 7, '2026-06-07 12:45:00', '2026-06-07 14:45:00', '2026-06-07 14:53:00', 21.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(339, N'PDV-2026-0339', 4, 3, 2, 8, '2026-06-07 12:45:00', '2026-06-07 14:45:00', '2026-06-07 14:50:00', 3.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(340, N'PDV-2026-0340', 2, 1, 2, 9, '2026-06-07 16:45:00', '2026-06-07 18:45:00', '2026-06-07 18:50:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(341, N'PDV-2026-0341', 8, 6, 4, 3, '2026-06-08 10:45:00', '2026-06-08 12:45:00', '2026-06-08 13:02:00', 1.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(342, N'PDV-2026-0342', 22, 20, 4, 12, '2026-06-08 10:45:00', '2026-06-08 12:45:00', '2026-06-08 12:52:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(343, N'PDV-2026-0343', 5, 4, 2, 3, '2026-06-08 11:15:00', '2026-06-12 11:15:00', '2026-06-12 12:15:00', 34.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 30000.00, 1370000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(344, N'PDV-2026-0344', 21, 19, 2, 11, '2026-06-08 11:30:00', '2026-06-08 13:30:00', '2026-06-08 13:49:00', 9.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(345, N'PDV-2026-0345', 10, 8, 4, 8, '2026-06-08 17:15:00', '2026-06-08 19:15:00', '2026-06-08 19:33:00', 29.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(346, N'PDV-2026-0346', 8, 6, 2, 11, '2026-06-09 10:45:00', '2026-06-09 12:45:00', '2026-06-09 12:50:00', 1.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(347, N'PDV-2026-0347', 1, 1, 4, 9, '2026-06-10 11:15:00', '2026-06-10 13:15:00', '2026-06-10 13:30:00', 3.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(348, N'PDV-2026-0348', 11, 9, 2, 8, '2026-06-10 14:15:00', '2026-06-10 16:15:00', '2026-06-10 16:24:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(349, N'PDV-2026-0349', 25, 22, 2, 12, '2026-06-10 16:15:00', '2026-06-13 16:15:00', '2026-06-13 17:15:00', 3.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 30000.00, 570000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(350, N'PDV-2026-0350', 14, 12, 4, 7, '2026-06-11 10:00:00', '2026-06-11 12:00:00', '2026-06-11 12:15:00', 3.40, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(351, N'PDV-2026-0351', 6, 5, 2, 8, '2026-06-11 13:15:00', '2026-06-11 15:15:00', '2026-06-11 15:28:00', 4.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(352, N'PDV-2026-0352', 3, 2, 4, 9, '2026-06-11 18:45:00', '2026-06-11 20:45:00', '2026-06-11 21:04:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(353, N'PDV-2026-0353', 12, 10, 2, 7, '2026-06-12 13:15:00', '2026-06-12 15:15:00', '2026-06-12 15:30:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(354, N'PDV-2026-0354', 3, 2, 2, 3, '2026-06-12 15:00:00', '2026-06-12 17:00:00', '2026-06-12 17:15:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(355, N'PDV-2026-0355', 19, 17, 4, 8, '2026-06-12 17:30:00', '2026-06-12 19:30:00', '2026-06-12 19:50:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(356, N'PDV-2026-0356', 21, 19, 4, 11, '2026-06-12 18:30:00', '2026-06-14 18:30:00', '2026-06-14 19:30:00', 9.60, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 700000.00, 0.00, 700000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(357, N'PDV-2026-0357', 25, 22, 2, 8, '2026-06-13 16:45:00', '2026-06-13 18:45:00', '2026-06-13 18:54:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(358, N'PDV-2026-0358', 9, 7, 4, 11, '2026-06-14 13:30:00', '2026-06-14 15:30:00', '2026-06-14 15:47:00', 4.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(359, N'PDV-2026-0359', 3, 2, 2, 7, '2026-06-14 18:45:00', '2026-06-14 20:45:00', '2026-06-14 20:52:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(360, N'PDV-2026-0360', 20, 18, 2, 9, '2026-06-14 18:45:00', '2026-06-14 20:45:00', '2026-06-14 21:00:00', 10.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(361, N'PDV-2026-0361', 13, 11, 4, 7, '2026-06-15 09:15:00', '2026-06-15 11:15:00', '2026-06-15 11:35:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(362, N'PDV-2026-0362', 24, 21, 2, 7, '2026-06-15 15:45:00', '2026-06-15 17:45:00', '2026-06-15 17:50:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(363, N'PDV-2026-0363', 26, 23, 4, 12, '2026-06-16 11:30:00', '2026-06-16 13:30:00', '2026-06-16 13:46:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(364, N'PDV-2026-0364', 12, 10, 2, 12, '2026-06-16 18:30:00', '2026-06-16 20:30:00', '2026-06-16 20:41:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(365, N'PDV-2026-0365', 12, 10, 2, 9, '2026-06-17 17:30:00', '2026-06-17 19:30:00', '2026-06-17 19:36:00', 8.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(366, N'PDV-2026-0366', 20, 18, 4, 7, '2026-06-17 18:45:00', '2026-06-17 20:45:00', '2026-06-17 20:54:00', 10.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(367, N'PDV-2026-0367', 10, 8, 2, 8, '2026-06-18 08:30:00', '2026-06-18 10:30:00', '2026-06-18 10:42:00', 29.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(368, N'PDV-2026-0368', 11, 9, 4, 12, '2026-06-18 12:15:00', '2026-06-18 14:15:00', '2026-06-18 14:24:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(369, N'PDV-2026-0369', 20, 18, 2, 12, '2026-06-18 16:30:00', '2026-06-18 18:30:00', '2026-06-18 18:50:00', 10.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(370, N'PDV-2026-0370', 24, 21, 4, 8, '2026-06-19 14:15:00', '2026-06-19 16:15:00', '2026-06-19 16:22:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(371, N'PDV-2026-0371', 11, 9, 2, 7, '2026-06-20 10:30:00', '2026-06-20 12:30:00', '2026-06-20 12:35:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(372, N'PDV-2026-0372', 8, 6, 4, 8, '2026-06-20 12:15:00', '2026-06-23 12:15:00', '2026-06-23 13:15:00', 1.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 30000.00, 1020000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(373, N'PDV-2026-0373', 3, 2, 4, 8, '2026-06-20 16:15:00', '2026-06-20 18:15:00', '2026-06-20 18:27:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(374, N'PDV-2026-0374', 3, 2, 2, 7, '2026-06-21 12:00:00', '2026-06-21 14:00:00', '2026-06-21 14:17:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(375, N'PDV-2026-0375', 25, 22, 4, 12, '2026-06-21 14:30:00', '2026-06-21 16:30:00', '2026-06-21 16:49:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(376, N'PDV-2026-0376', 7, 5, 2, 11, '2026-06-21 16:30:00', '2026-06-21 18:30:00', '2026-06-21 18:48:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(377, N'PDV-2026-0377', 16, 14, 2, 3, '2026-06-21 18:30:00', '2026-06-21 20:30:00', '2026-06-21 20:46:00', 2.30, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(378, N'PDV-2026-0378', 24, 21, 2, 12, '2026-06-22 11:15:00', '2026-06-22 13:15:00', '2026-06-22 13:33:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(379, N'PDV-2026-0379', 22, 20, 4, 8, '2026-06-23 11:15:00', '2026-06-23 13:15:00', '2026-06-23 13:21:00', 22.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(380, N'PDV-2026-0380', 23, 1, 2, 3, '2026-06-23 16:45:00', '2026-06-23 18:45:00', '2026-06-23 19:00:00', 4.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(381, N'PDV-2026-0381', 11, 9, 2, 11, '2026-06-23 17:45:00', '2026-06-23 19:45:00', '2026-06-23 19:56:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(382, N'PDV-2026-0382', 3, 2, 2, 8, '2026-06-24 15:30:00', '2026-06-24 17:30:00', '2026-06-24 17:40:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(383, N'PDV-2026-0383', 2, 1, 4, 9, '2026-06-24 18:00:00', '2026-06-24 20:00:00', '2026-06-24 20:17:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(384, N'PDV-2026-0384', 1, 1, 4, 9, '2026-06-25 18:45:00', '2026-06-25 20:45:00', '2026-06-25 20:55:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(385, N'PDV-2026-0385', 7, 5, 2, 12, '2026-06-26 11:45:00', '2026-06-26 13:45:00', '2026-06-26 14:02:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(386, N'PDV-2026-0386', 7, 5, 2, 8, '2026-06-27 10:15:00', '2026-06-27 12:15:00', '2026-06-27 12:21:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(387, N'PDV-2026-0387', 13, 11, 4, 11, '2026-06-27 17:30:00', '2026-06-27 19:30:00', '2026-06-27 19:49:00', 26.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(388, N'PDV-2026-0388', 21, 19, 4, 11, '2026-06-28 09:00:00', '2026-07-01 09:00:00', '2026-07-01 10:00:00', 9.60, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(389, N'PDV-2026-0389', 18, 16, 4, 11, '2026-06-28 15:45:00', '2026-07-02 15:45:00', '2026-07-02 16:45:00', 2.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 0.00, 800000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(390, N'PDV-2026-0390', 18, 16, 4, 9, '2026-06-29 08:45:00', '2026-06-29 10:45:00', '2026-06-29 11:04:00', 2.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(391, N'PDV-2026-0391', 10, 8, 4, 9, '2026-06-29 18:30:00', '2026-06-29 20:30:00', '2026-06-29 20:50:00', 29.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(392, N'PDV-2026-0392', 12, 10, 4, 7, '2026-06-30 09:45:00', '2026-06-30 11:45:00', '2026-06-30 11:51:00', 8.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(393, N'PDV-2026-0393', 25, 22, 4, 8, '2026-07-01 10:30:00', '2026-07-01 12:30:00', '2026-07-01 12:46:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(394, N'PDV-2026-0394', 12, 10, 2, 7, '2026-07-01 14:15:00', '2026-07-01 16:15:00', '2026-07-01 16:34:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(395, N'PDV-2026-0395', 6, 5, 4, 12, '2026-07-01 14:30:00', '2026-07-01 16:30:00', '2026-07-01 16:48:00', 4.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(396, N'PDV-2026-0396', 2, 1, 4, 7, '2026-07-01 15:15:00', '2026-07-01 17:15:00', '2026-07-01 17:20:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(397, N'PDV-2026-0397', 25, 22, 2, 3, '2026-07-02 10:00:00', '2026-07-02 12:00:00', '2026-07-02 12:17:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(398, N'PDV-2026-0398', 26, 23, 2, 8, '2026-07-02 11:00:00', '2026-07-02 13:00:00', '2026-07-02 13:06:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(399, N'PDV-2026-0399', 25, 22, 4, 11, '2026-07-03 09:30:00', '2026-07-03 11:30:00', '2026-07-03 11:39:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(400, N'PDV-2026-0400', 26, 23, 4, 9, '2026-07-03 10:45:00', '2026-07-03 12:45:00', '2026-07-03 13:04:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True);
INSERT INTO [dbo].[tblPhieuDichVuChamSoc] ([MaPhieuDV], [SoPhieu], [MaThuCung], [MaChuNuoi], [MaNVTiepNhan], [MaNVThucHien], [NgayTiepNhan], [NgayHenTra], [NgayTraThucTe], [CanNangTiepNhan], [TinhTrangBanDau], [YeuCauCuaChuNuoi], [KetQuaChamSoc], [TongTien], [TienGiamGia], [ThanhToan], [HinhThucThanhToan], [TrangThaiThanhToan], [TrangThaiDichVu], [DanhGiaCuaChu], [GhiChu], [DaCongDiem]) VALUES
(401, N'PDV-2026-0401', 26, 23, 4, 7, '2026-07-03 11:45:00', '2026-07-03 13:45:00', '2026-07-03 14:03:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(402, N'PDV-2026-0402', 3, 2, 2, 11, '2026-07-03 14:15:00', '2026-07-03 16:15:00', '2026-07-03 16:29:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(403, N'PDV-2026-0403', 6, 5, 2, 12, '2026-07-04 10:45:00', '2026-07-08 10:45:00', '2026-07-08 11:45:00', 4.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 0.00, 800000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(404, N'PDV-2026-0404', 24, 21, 2, 3, '2026-07-04 11:45:00', '2026-07-04 13:45:00', '2026-07-04 13:54:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(405, N'PDV-2026-0405', 25, 22, 2, 8, '2026-07-04 16:00:00', '2026-07-04 18:00:00', '2026-07-04 18:16:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(406, N'PDV-2026-0406', 23, 1, 4, 3, '2026-07-05 15:30:00', '2026-07-05 17:30:00', '2026-07-05 17:40:00', 4.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(407, N'PDV-2026-0407', 7, 5, 4, 8, '2026-07-05 17:00:00', '2026-07-07 17:00:00', '2026-07-07 18:00:00', 3.20, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 700000.00, 0.00, 700000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(408, N'PDV-2026-0408', 9, 7, 2, 12, '2026-07-05 17:30:00', '2026-07-05 19:30:00', '2026-07-05 19:43:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(409, N'PDV-2026-0409', 26, 23, 2, 7, '2026-07-06 17:00:00', '2026-07-06 19:00:00', '2026-07-06 19:14:00', 5.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(410, N'PDV-2026-0410', 8, 6, 2, 3, '2026-07-06 18:15:00', '2026-07-09 18:15:00', '2026-07-09 19:15:00', 1.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(411, N'PDV-2026-0411', 22, 20, 2, 9, '2026-07-07 08:00:00', '2026-07-07 10:00:00', '2026-07-07 10:19:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(412, N'PDV-2026-0412', 17, 15, 4, 8, '2026-07-07 09:00:00', '2026-07-07 11:00:00', '2026-07-07 11:12:00', 7.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(413, N'PDV-2026-0413', 13, 11, 4, 11, '2026-07-07 17:45:00', '2026-07-07 19:45:00', '2026-07-07 19:55:00', 26.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(414, N'PDV-2026-0414', 5, 4, 2, 9, '2026-07-07 18:15:00', '2026-07-07 20:15:00', '2026-07-07 20:35:00', 34.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(415, N'PDV-2026-0415', 7, 5, 4, 11, '2026-07-08 09:15:00', '2026-07-08 11:15:00', '2026-07-08 11:33:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(416, N'PDV-2026-0416', 23, 1, 4, 9, '2026-07-08 10:00:00', '2026-07-11 10:00:00', '2026-07-11 11:00:00', 4.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(417, N'PDV-2026-0417', 15, 13, 2, 3, '2026-07-08 11:00:00', '2026-07-08 13:00:00', '2026-07-08 13:18:00', 21.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(418, N'PDV-2026-0418', 9, 7, 2, 9, '2026-07-08 14:45:00', '2026-07-08 16:45:00', '2026-07-08 17:05:00', 4.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(419, N'PDV-2026-0419', 15, 13, 2, 12, '2026-07-09 09:30:00', '2026-07-09 11:30:00', '2026-07-09 11:47:00', 21.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(420, N'PDV-2026-0420', 20, 18, 2, 3, '2026-07-09 11:00:00', '2026-07-13 11:00:00', '2026-07-13 12:00:00', 10.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 0.00, 800000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(421, N'PDV-2026-0421', 3, 2, 4, 11, '2026-07-09 12:15:00', '2026-07-09 14:15:00', '2026-07-09 14:34:00', 11.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(422, N'PDV-2026-0422', 21, 19, 4, 8, '2026-07-09 12:45:00', '2026-07-09 14:45:00', '2026-07-09 14:53:00', 9.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(423, N'PDV-2026-0423', 4, 3, 2, 9, '2026-07-09 13:45:00', '2026-07-09 15:45:00', '2026-07-09 15:51:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(424, N'PDV-2026-0424', 2, 1, 4, 7, '2026-07-09 13:45:00', '2026-07-09 15:45:00', '2026-07-09 16:01:00', 4.10, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(425, N'PDV-2026-0425', 3, 2, 4, 12, '2026-07-10 10:15:00', '2026-07-10 12:15:00', '2026-07-10 12:24:00', 11.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(426, N'PDV-2026-0426', 9, 7, 2, 3, '2026-07-11 10:00:00', '2026-07-11 12:00:00', '2026-07-11 12:06:00', 4.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(427, N'PDV-2026-0427', 9, 7, 2, 3, '2026-07-11 13:30:00', '2026-07-11 15:30:00', '2026-07-11 15:48:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(428, N'PDV-2026-0428', 4, 3, 2, 7, '2026-07-11 18:45:00', '2026-07-11 20:45:00', '2026-07-11 21:00:00', 3.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(429, N'PDV-2026-0429', 16, 14, 2, 9, '2026-07-12 10:30:00', '2026-07-12 12:30:00', '2026-07-12 12:42:00', 2.30, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(430, N'PDV-2026-0430', 20, 18, 2, 9, '2026-07-12 11:15:00', '2026-07-12 13:15:00', '2026-07-12 13:33:00', 10.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(431, N'PDV-2026-0431', 1, 1, 4, 12, '2026-07-12 12:15:00', '2026-07-12 14:15:00', '2026-07-12 14:22:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(432, N'PDV-2026-0432', 2, 1, 4, 12, '2026-07-12 12:30:00', '2026-07-12 14:30:00', '2026-07-12 14:40:00', 4.10, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 30000.00, 330000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(433, N'PDV-2026-0433', 17, 15, 2, 3, '2026-07-12 13:15:00', '2026-07-12 15:15:00', '2026-07-12 15:27:00', 7.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(434, N'PDV-2026-0434', 6, 5, 2, 11, '2026-07-12 16:00:00', '2026-07-12 18:00:00', '2026-07-12 18:13:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(435, N'PDV-2026-0435', 13, 11, 4, 3, '2026-07-13 10:45:00', '2026-07-13 12:45:00', '2026-07-13 13:01:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(436, N'PDV-2026-0436', 11, 9, 2, 3, '2026-07-13 15:15:00', '2026-07-17 15:15:00', '2026-07-17 16:15:00', 3.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 0.00, 1400000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(437, N'PDV-2026-0437', 26, 23, 4, 12, '2026-07-15 10:45:00', '2026-07-15 12:45:00', '2026-07-15 12:55:00', 5.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(438, N'PDV-2026-0438', 5, 4, 2, 11, '2026-07-16 09:45:00', '2026-07-16 11:45:00', '2026-07-16 11:56:00', 34.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(439, N'PDV-2026-0439', 24, 21, 4, 12, '2026-07-16 15:30:00', '2026-07-16 17:30:00', '2026-07-16 17:35:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(440, N'PDV-2026-0440', 14, 12, 2, 8, '2026-07-17 18:00:00', '2026-07-17 20:00:00', '2026-07-17 20:14:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(441, N'PDV-2026-0441', 4, 3, 4, 7, '2026-07-17 18:30:00', '2026-07-17 20:30:00', '2026-07-17 20:36:00', 3.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(442, N'PDV-2026-0442', 1, 1, 4, 3, '2026-07-18 08:00:00', '2026-07-18 10:00:00', '2026-07-18 10:07:00', 3.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(443, N'PDV-2026-0443', 5, 4, 4, 8, '2026-07-18 08:30:00', '2026-07-18 10:30:00', '2026-07-18 10:46:00', 34.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(444, N'PDV-2026-0444', 15, 13, 4, 3, '2026-07-18 14:15:00', '2026-07-18 16:15:00', '2026-07-18 16:23:00', 21.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(445, N'PDV-2026-0445', 19, 17, 4, 8, '2026-07-18 15:00:00', '2026-07-18 17:00:00', '2026-07-18 17:14:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(446, N'PDV-2026-0446', 22, 20, 4, 8, '2026-07-19 16:30:00', '2026-07-19 18:30:00', '2026-07-19 18:45:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(447, N'PDV-2026-0447', 10, 8, 2, 7, '2026-07-19 18:45:00', '2026-07-19 20:45:00', '2026-07-19 21:04:00', 29.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(448, N'PDV-2026-0448', 4, 3, 4, 9, '2026-07-20 10:00:00', '2026-07-20 12:00:00', '2026-07-20 12:08:00', 3.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(449, N'PDV-2026-0449', 22, 20, 4, 7, '2026-07-20 10:30:00', '2026-07-20 12:30:00', '2026-07-20 12:45:00', 22.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(450, N'PDV-2026-0450', 18, 16, 4, 8, '2026-07-22 13:00:00', '2026-07-22 15:00:00', '2026-07-22 15:08:00', 2.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(451, N'PDV-2026-0451', 11, 9, 2, 9, '2026-07-23 09:15:00', '2026-07-23 11:15:00', '2026-07-23 11:24:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(452, N'PDV-2026-0452', 13, 11, 2, 9, '2026-07-23 15:45:00', '2026-07-23 17:45:00', '2026-07-23 18:03:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(453, N'PDV-2026-0453', 20, 18, 4, 12, '2026-07-23 16:30:00', '2026-07-25 16:30:00', '2026-07-25 17:30:00', 10.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(454, N'PDV-2026-0454', 23, 1, 4, 12, '2026-07-23 18:30:00', '2026-07-23 20:30:00', '2026-07-23 20:48:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(455, N'PDV-2026-0455', 25, 22, 2, 3, '2026-07-24 13:00:00', '2026-07-24 15:00:00', '2026-07-24 15:13:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(456, N'PDV-2026-0456', 17, 15, 2, 9, '2026-07-24 16:30:00', '2026-07-24 18:30:00', '2026-07-24 18:49:00', 7.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(457, N'PDV-2026-0457', 10, 8, 4, 11, '2026-07-25 08:15:00', '2026-07-25 10:15:00', '2026-07-25 10:31:00', 29.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(458, N'PDV-2026-0458', 19, 17, 2, 11, '2026-07-25 09:00:00', '2026-07-25 11:00:00', '2026-07-25 11:11:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(459, N'PDV-2026-0459', 20, 18, 4, 9, '2026-07-25 12:45:00', '2026-07-25 14:45:00', '2026-07-25 14:52:00', 10.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(460, N'PDV-2026-0460', 8, 6, 2, 9, '2026-07-26 09:45:00', '2026-07-26 11:45:00', '2026-07-26 12:05:00', 1.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(461, N'PDV-2026-0461', 18, 16, 4, 3, '2026-07-26 16:30:00', '2026-07-26 18:30:00', '2026-07-26 18:50:00', 2.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(462, N'PDV-2026-0462', 11, 9, 2, 8, '2026-07-26 17:30:00', '2026-07-26 19:30:00', '2026-07-26 19:36:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(463, N'PDV-2026-0463', 6, 5, 2, 8, '2026-07-27 15:30:00', '2026-07-27 17:30:00', '2026-07-27 17:41:00', 4.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(464, N'PDV-2026-0464', 22, 20, 2, 3, '2026-07-28 17:15:00', '2026-07-28 19:15:00', '2026-07-28 19:32:00', 22.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(465, N'PDV-2026-0465', 1, 1, 2, 12, '2026-07-28 18:15:00', '2026-07-28 20:15:00', '2026-07-28 20:24:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(466, N'PDV-2026-0466', 14, 12, 2, 12, '2026-07-29 11:45:00', '2026-07-29 13:45:00', '2026-07-29 14:00:00', 3.40, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(467, N'PDV-2026-0467', 19, 17, 2, 3, '2026-07-29 12:15:00', '2026-07-29 14:15:00', '2026-07-29 14:25:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(468, N'PDV-2026-0468', 14, 12, 4, 12, '2026-07-29 13:00:00', '2026-08-02 13:00:00', '2026-08-02 14:00:00', 3.40, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 30000.00, 770000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(469, N'PDV-2026-0469', 25, 22, 4, 11, '2026-07-30 10:45:00', '2026-07-30 12:45:00', '2026-07-30 13:03:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(470, N'PDV-2026-0470', 9, 7, 2, 3, '2026-07-30 12:45:00', '2026-07-30 14:45:00', '2026-07-30 15:00:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(471, N'PDV-2026-0471', 2, 1, 4, 12, '2026-07-30 16:30:00', '2026-07-30 18:30:00', '2026-07-30 18:36:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(472, N'PDV-2026-0472', 23, 1, 2, 3, '2026-07-30 17:00:00', '2026-07-30 19:00:00', '2026-07-30 19:12:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(473, N'PDV-2026-0473', 2, 1, 2, 8, '2026-07-31 10:00:00', '2026-07-31 12:00:00', '2026-07-31 12:18:00', 4.10, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 30000.00, 150000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(474, N'PDV-2026-0474', 11, 9, 2, 12, '2026-07-31 17:15:00', '2026-07-31 19:15:00', '2026-07-31 19:34:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(475, N'PDV-2026-0475', 9, 7, 2, 3, '2026-08-01 16:30:00', '2026-08-04 16:30:00', '2026-08-04 17:30:00', 4.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 30000.00, 570000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(476, N'PDV-2026-0476', 15, 13, 4, 3, '2026-08-02 15:30:00', '2026-08-02 17:30:00', '2026-08-02 17:50:00', 21.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(477, N'PDV-2026-0477', 13, 11, 4, 12, '2026-08-02 18:30:00', '2026-08-02 20:30:00', '2026-08-02 20:48:00', 26.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 30000.00, 330000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(478, N'PDV-2026-0478', 16, 14, 2, 8, '2026-08-03 08:45:00', '2026-08-03 10:45:00', '2026-08-03 10:54:00', 2.30, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(479, N'PDV-2026-0479', 15, 13, 2, 3, '2026-08-03 13:45:00', '2026-08-03 15:45:00', '2026-08-03 16:00:00', 21.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(480, N'PDV-2026-0480', 13, 11, 4, 9, '2026-08-03 14:30:00', '2026-08-03 16:30:00', '2026-08-03 16:40:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(481, N'PDV-2026-0481', 25, 22, 2, 3, '2026-08-03 16:30:00', '2026-08-03 18:30:00', '2026-08-03 18:45:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(482, N'PDV-2026-0482', 16, 14, 4, 12, '2026-08-04 13:00:00', '2026-08-04 15:00:00', '2026-08-04 15:09:00', 2.30, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(483, N'PDV-2026-0483', 9, 7, 2, 9, '2026-08-04 15:30:00', '2026-08-04 17:30:00', '2026-08-04 17:46:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(484, N'PDV-2026-0484', 2, 1, 4, 8, '2026-08-04 16:30:00', '2026-08-04 18:30:00', '2026-08-04 18:37:00', 4.10, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(485, N'PDV-2026-0485', 17, 15, 2, 8, '2026-08-05 13:00:00', '2026-08-05 15:00:00', '2026-08-05 15:16:00', 7.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(486, N'PDV-2026-0486', 15, 13, 4, 3, '2026-08-05 16:00:00', '2026-08-05 18:00:00', '2026-08-05 18:11:00', 21.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(487, N'PDV-2026-0487', 11, 9, 4, 11, '2026-08-06 12:15:00', '2026-08-06 14:15:00', '2026-08-06 14:35:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(488, N'PDV-2026-0488', 6, 5, 2, 8, '2026-08-07 10:00:00', '2026-08-07 12:00:00', '2026-08-07 12:12:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(489, N'PDV-2026-0489', 20, 18, 4, 11, '2026-08-08 16:15:00', '2026-08-08 18:15:00', '2026-08-08 18:30:00', 10.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(490, N'PDV-2026-0490', 25, 22, 4, 11, '2026-08-09 13:30:00', '2026-08-09 15:30:00', '2026-08-09 15:36:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(491, N'PDV-2026-0491', 21, 19, 2, 11, '2026-08-09 13:45:00', '2026-08-09 15:45:00', '2026-08-09 16:01:00', 9.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(492, N'PDV-2026-0492', 7, 5, 2, 8, '2026-08-10 09:15:00', '2026-08-10 11:15:00', '2026-08-10 11:29:00', 3.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(493, N'PDV-2026-0493', 5, 4, 4, 3, '2026-08-10 15:00:00', '2026-08-13 15:00:00', '2026-08-13 16:00:00', 34.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(494, N'PDV-2026-0494', 14, 12, 2, 3, '2026-08-10 15:15:00', '2026-08-10 17:15:00', '2026-08-10 17:35:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(495, N'PDV-2026-0495', 11, 9, 2, 12, '2026-08-10 17:00:00', '2026-08-13 17:00:00', '2026-08-13 18:00:00', 3.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(496, N'PDV-2026-0496', 14, 12, 2, 8, '2026-08-11 13:45:00', '2026-08-11 15:45:00', '2026-08-11 15:55:00', 3.40, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(497, N'PDV-2026-0497', 5, 4, 2, 3, '2026-08-12 17:00:00', '2026-08-12 19:00:00', '2026-08-12 19:15:00', 34.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(498, N'PDV-2026-0498', 19, 17, 2, 3, '2026-08-13 11:30:00', '2026-08-13 13:30:00', '2026-08-13 13:45:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(499, N'PDV-2026-0499', 4, 3, 4, 8, '2026-08-13 14:30:00', '2026-08-13 16:30:00', '2026-08-13 16:39:00', 3.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(500, N'PDV-2026-0500', 1, 1, 4, 7, '2026-08-14 10:45:00', '2026-08-14 12:45:00', '2026-08-14 12:54:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True);
INSERT INTO [dbo].[tblPhieuDichVuChamSoc] ([MaPhieuDV], [SoPhieu], [MaThuCung], [MaChuNuoi], [MaNVTiepNhan], [MaNVThucHien], [NgayTiepNhan], [NgayHenTra], [NgayTraThucTe], [CanNangTiepNhan], [TinhTrangBanDau], [YeuCauCuaChuNuoi], [KetQuaChamSoc], [TongTien], [TienGiamGia], [ThanhToan], [HinhThucThanhToan], [TrangThaiThanhToan], [TrangThaiDichVu], [DanhGiaCuaChu], [GhiChu], [DaCongDiem]) VALUES
(501, N'PDV-2026-0501', 2, 1, 4, 9, '2026-08-15 11:30:00', '2026-08-15 13:30:00', '2026-08-15 13:40:00', 4.10, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(502, N'PDV-2026-0502', 7, 5, 4, 9, '2026-08-16 08:45:00', '2026-08-16 10:45:00', '2026-08-16 10:57:00', 3.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 30000.00, 330000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(503, N'PDV-2026-0503', 21, 19, 2, 12, '2026-08-16 13:30:00', '2026-08-16 15:30:00', '2026-08-16 15:35:00', 9.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(504, N'PDV-2026-0504', 17, 15, 4, 8, '2026-08-16 17:15:00', '2026-08-16 19:15:00', '2026-08-16 19:24:00', 7.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(505, N'PDV-2026-0505', 23, 1, 4, 3, '2026-08-16 17:30:00', '2026-08-16 19:30:00', '2026-08-16 19:49:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(506, N'PDV-2026-0506', 17, 15, 2, 7, '2026-08-17 11:00:00', '2026-08-17 13:00:00', '2026-08-17 13:15:00', 7.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(507, N'PDV-2026-0507', 4, 3, 2, 3, '2026-08-17 11:45:00', '2026-08-17 13:45:00', '2026-08-17 13:50:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(508, N'PDV-2026-0508', 4, 3, 2, 11, '2026-08-18 08:00:00', '2026-08-18 10:00:00', '2026-08-18 10:17:00', 3.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(509, N'PDV-2026-0509', 18, 16, 4, 8, '2026-08-18 13:00:00', '2026-08-18 15:00:00', '2026-08-18 15:15:00', 2.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(510, N'PDV-2026-0510', 26, 23, 2, 9, '2026-08-18 14:30:00', '2026-08-18 16:30:00', '2026-08-18 16:46:00', 5.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(511, N'PDV-2026-0511', 23, 1, 4, 12, '2026-08-19 15:45:00', '2026-08-21 15:45:00', '2026-08-21 16:45:00', 4.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(512, N'PDV-2026-0512', 21, 19, 2, 9, '2026-08-20 10:45:00', '2026-08-20 12:45:00', '2026-08-20 13:04:00', 9.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(513, N'PDV-2026-0513', 4, 3, 2, 11, '2026-08-20 11:45:00', '2026-08-20 13:45:00', '2026-08-20 13:57:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(514, N'PDV-2026-0514', 26, 23, 4, 3, '2026-08-20 17:30:00', '2026-08-20 19:30:00', '2026-08-20 19:47:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(515, N'PDV-2026-0515', 2, 1, 4, 7, '2026-08-20 18:00:00', '2026-08-22 18:00:00', '2026-08-22 19:00:00', 4.10, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(516, N'PDV-2026-0516', 9, 7, 2, 3, '2026-08-21 08:15:00', '2026-08-21 10:15:00', '2026-08-21 10:25:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(517, N'PDV-2026-0517', 24, 21, 4, 3, '2026-08-21 14:45:00', '2026-08-21 16:45:00', '2026-08-21 17:05:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(518, N'PDV-2026-0518', 26, 23, 2, 7, '2026-08-22 10:15:00', '2026-08-22 12:15:00', '2026-08-22 12:21:00', 5.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(519, N'PDV-2026-0519', 16, 14, 2, 7, '2026-08-22 14:30:00', '2026-08-22 16:30:00', '2026-08-22 16:49:00', 2.30, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(520, N'PDV-2026-0520', 3, 2, 2, 9, '2026-08-22 17:30:00', '2026-08-22 19:30:00', '2026-08-22 19:50:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(521, N'PDV-2026-0521', 24, 21, 2, 11, '2026-08-22 18:00:00', '2026-08-22 20:00:00', '2026-08-22 20:17:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(522, N'PDV-2026-0522', 1, 1, 4, 11, '2026-08-22 18:45:00', '2026-08-22 20:45:00', '2026-08-22 20:52:00', 3.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(523, N'PDV-2026-0523', 19, 17, 4, 9, '2026-08-23 08:00:00', '2026-08-23 10:00:00', '2026-08-23 10:18:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(524, N'PDV-2026-0524', 4, 3, 2, 3, '2026-08-23 14:30:00', '2026-08-23 16:30:00', '2026-08-23 16:37:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(525, N'PDV-2026-0525', 12, 10, 4, 12, '2026-08-24 14:00:00', '2026-08-24 16:00:00', '2026-08-24 16:06:00', 8.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(526, N'PDV-2026-0526', 2, 1, 4, 8, '2026-08-25 11:30:00', '2026-08-25 13:30:00', '2026-08-25 13:37:00', 4.10, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(527, N'PDV-2026-0527', 14, 12, 4, 3, '2026-08-25 14:30:00', '2026-08-25 16:30:00', '2026-08-25 16:40:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(528, N'PDV-2026-0528', 3, 2, 2, 8, '2026-08-25 17:15:00', '2026-08-25 19:15:00', '2026-08-25 19:33:00', 11.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(529, N'PDV-2026-0529', 3, 2, 4, 7, '2026-08-26 08:00:00', '2026-08-26 10:00:00', '2026-08-26 10:17:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(530, N'PDV-2026-0530', 7, 5, 2, 3, '2026-08-26 12:30:00', '2026-08-26 14:30:00', '2026-08-26 14:40:00', 3.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(531, N'PDV-2026-0531', 8, 6, 2, 9, '2026-08-26 14:45:00', '2026-08-26 16:45:00', '2026-08-26 16:59:00', 1.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(532, N'PDV-2026-0532', 15, 13, 4, 3, '2026-08-26 14:45:00', '2026-08-26 16:45:00', '2026-08-26 17:03:00', 21.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(533, N'PDV-2026-0533', 10, 8, 2, 12, '2026-08-26 15:15:00', '2026-08-26 17:15:00', '2026-08-26 17:26:00', 29.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(534, N'PDV-2026-0534', 19, 17, 2, 8, '2026-08-26 16:30:00', '2026-08-26 18:30:00', '2026-08-26 18:47:00', 36.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(535, N'PDV-2026-0535', 8, 6, 4, 7, '2026-08-26 17:45:00', '2026-08-26 19:45:00', '2026-08-26 20:02:00', 1.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(536, N'PDV-2026-0536', 15, 13, 4, 3, '2026-08-27 10:00:00', '2026-08-27 12:00:00', '2026-08-27 12:11:00', 21.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(537, N'PDV-2026-0537', 19, 17, 2, 9, '2026-08-27 11:45:00', '2026-08-27 13:45:00', '2026-08-27 13:59:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(538, N'PDV-2026-0538', 6, 5, 4, 12, '2026-08-27 12:30:00', '2026-08-31 12:30:00', '2026-08-31 13:30:00', 4.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 0.00, 800000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(539, N'PDV-2026-0539', 14, 12, 4, 7, '2026-08-27 14:00:00', '2026-08-27 16:00:00', '2026-08-27 16:07:00', 3.40, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(540, N'PDV-2026-0540', 21, 19, 2, 12, '2026-08-28 08:15:00', '2026-08-28 10:15:00', '2026-08-28 10:35:00', 9.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(541, N'PDV-2026-0541', 24, 21, 4, 7, '2026-08-28 09:45:00', '2026-08-28 11:45:00', '2026-08-28 12:05:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(542, N'PDV-2026-0542', 18, 16, 2, 12, '2026-08-28 10:00:00', '2026-08-28 12:00:00', '2026-08-28 12:14:00', 2.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(543, N'PDV-2026-0543', 24, 21, 4, 9, '2026-08-28 12:15:00', '2026-08-28 14:15:00', '2026-08-28 14:25:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(544, N'PDV-2026-0544', 12, 10, 4, 3, '2026-08-28 14:00:00', '2026-08-28 16:00:00', '2026-08-28 16:08:00', 8.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(545, N'PDV-2026-0545', 23, 1, 4, 9, '2026-08-30 13:15:00', '2026-08-30 15:15:00', '2026-08-30 15:29:00', 4.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(546, N'PDV-2026-0546', 4, 3, 2, 11, '2026-08-30 14:15:00', '2026-09-02 14:15:00', '2026-09-02 15:15:00', 3.60, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(547, N'PDV-2026-0547', 15, 13, 4, 3, '2026-08-30 15:00:00', '2026-09-02 15:00:00', '2026-09-02 16:00:00', 21.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 30000.00, 1020000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(548, N'PDV-2026-0548', 4, 3, 2, 9, '2026-08-30 15:45:00', '2026-08-30 17:45:00', '2026-08-30 17:53:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(549, N'PDV-2026-0549', 13, 11, 2, 8, '2026-08-31 12:30:00', '2026-08-31 14:30:00', '2026-08-31 14:50:00', 26.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(550, N'PDV-2026-0550', 3, 2, 4, 9, '2026-08-31 15:00:00', '2026-08-31 17:00:00', '2026-08-31 17:06:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(551, N'PDV-2026-0551', 23, 1, 4, 8, '2026-08-31 17:00:00', '2026-08-31 19:00:00', '2026-08-31 19:05:00', 4.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 30000.00, 330000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(552, N'PDV-2026-0552', 9, 7, 4, 7, '2026-08-31 18:00:00', '2026-09-02 18:00:00', '2026-09-02 19:00:00', 4.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 700000.00, 0.00, 700000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(553, N'PDV-2026-0553', 13, 11, 2, 9, '2026-09-01 10:45:00', '2026-09-01 12:45:00', '2026-09-01 12:52:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(554, N'PDV-2026-0554', 8, 6, 2, 12, '2026-09-01 14:15:00', '2026-09-01 16:15:00', '2026-09-01 16:34:00', 1.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(555, N'PDV-2026-0555', 15, 13, 2, 7, '2026-09-03 09:30:00', '2026-09-03 11:30:00', '2026-09-03 11:48:00', 21.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(556, N'PDV-2026-0556', 23, 1, 2, 9, '2026-09-04 09:45:00', '2026-09-06 09:45:00', '2026-09-06 10:45:00', 4.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 700000.00, 0.00, 700000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(557, N'PDV-2026-0557', 7, 5, 4, 12, '2026-09-04 10:15:00', '2026-09-04 12:15:00', '2026-09-04 12:26:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(558, N'PDV-2026-0558', 7, 5, 2, 12, '2026-09-04 15:15:00', '2026-09-04 17:15:00', '2026-09-04 17:25:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(559, N'PDV-2026-0559', 17, 15, 4, 8, '2026-09-05 11:00:00', '2026-09-05 13:00:00', '2026-09-05 13:05:00', 7.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(560, N'PDV-2026-0560', 7, 5, 2, 12, '2026-09-05 15:30:00', '2026-09-05 17:30:00', '2026-09-05 17:40:00', 3.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(561, N'PDV-2026-0561', 23, 1, 4, 3, '2026-09-06 09:15:00', '2026-09-06 11:15:00', '2026-09-06 11:21:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(562, N'PDV-2026-0562', 16, 14, 2, 8, '2026-09-06 09:15:00', '2026-09-08 09:15:00', '2026-09-08 10:15:00', 2.30, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(563, N'PDV-2026-0563', 1, 1, 2, 7, '2026-09-07 09:00:00', '2026-09-07 11:00:00', '2026-09-07 11:18:00', 3.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(564, N'PDV-2026-0564', 19, 17, 2, 11, '2026-09-07 10:00:00', '2026-09-07 12:00:00', '2026-09-07 12:10:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(565, N'PDV-2026-0565', 15, 13, 2, 7, '2026-09-07 11:30:00', '2026-09-07 13:30:00', '2026-09-07 13:37:00', 21.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(566, N'PDV-2026-0566', 7, 5, 4, 3, '2026-09-07 14:00:00', '2026-09-07 16:00:00', '2026-09-07 16:17:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(567, N'PDV-2026-0567', 12, 10, 2, 3, '2026-09-07 14:15:00', '2026-09-07 16:15:00', '2026-09-07 16:20:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(568, N'PDV-2026-0568', 20, 18, 4, 8, '2026-09-07 16:00:00', '2026-09-07 18:00:00', '2026-09-07 18:17:00', 10.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(569, N'PDV-2026-0569', 4, 3, 2, 11, '2026-09-07 16:45:00', '2026-09-07 18:45:00', '2026-09-07 19:03:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(570, N'PDV-2026-0570', 1, 1, 2, 11, '2026-09-07 18:30:00', '2026-09-07 20:30:00', '2026-09-07 20:36:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(571, N'PDV-2026-0571', 2, 1, 2, 7, '2026-09-08 14:15:00', '2026-09-08 16:15:00', '2026-09-08 16:22:00', 4.10, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(572, N'PDV-2026-0572', 1, 1, 2, 7, '2026-09-08 15:45:00', '2026-09-08 17:45:00', '2026-09-08 17:53:00', 3.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(573, N'PDV-2026-0573', 5, 4, 4, 7, '2026-09-08 17:45:00', '2026-09-08 19:45:00', '2026-09-08 20:00:00', 34.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(574, N'PDV-2026-0574', 1, 1, 2, 8, '2026-09-09 11:45:00', '2026-09-09 13:45:00', '2026-09-09 13:59:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(575, N'PDV-2026-0575', 12, 10, 2, 9, '2026-09-10 17:30:00', '2026-09-10 19:30:00', '2026-09-10 19:44:00', 8.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(576, N'PDV-2026-0576', 23, 1, 2, 12, '2026-09-10 18:30:00', '2026-09-10 20:30:00', '2026-09-10 20:41:00', 4.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 30000.00, 330000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(577, N'PDV-2026-0577', 17, 15, 2, 9, '2026-09-11 08:45:00', '2026-09-11 10:45:00', '2026-09-11 11:02:00', 7.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(578, N'PDV-2026-0578', 11, 9, 2, 12, '2026-09-11 18:45:00', '2026-09-11 20:45:00', '2026-09-11 20:54:00', 3.90, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(579, N'PDV-2026-0579', 8, 6, 4, 12, '2026-09-13 08:15:00', '2026-09-13 10:15:00', '2026-09-13 10:34:00', 1.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(580, N'PDV-2026-0580', 13, 11, 2, 3, '2026-09-13 13:45:00', '2026-09-13 15:45:00', '2026-09-13 15:56:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(581, N'PDV-2026-0581', 10, 8, 4, 9, '2026-09-13 15:30:00', '2026-09-13 17:30:00', '2026-09-13 17:49:00', 29.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(582, N'PDV-2026-0582', 15, 13, 2, 7, '2026-09-14 14:15:00', '2026-09-14 16:15:00', '2026-09-14 16:34:00', 21.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(583, N'PDV-2026-0583', 6, 5, 2, 7, '2026-09-14 18:30:00', '2026-09-14 20:30:00', '2026-09-14 20:48:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(584, N'PDV-2026-0584', 23, 1, 2, 8, '2026-09-16 11:00:00', '2026-09-16 13:00:00', '2026-09-16 13:12:00', 4.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(585, N'PDV-2026-0585', 2, 1, 2, 8, '2026-09-16 12:00:00', '2026-09-18 12:00:00', '2026-09-18 13:00:00', 4.10, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(586, N'PDV-2026-0586', 18, 16, 2, 12, '2026-09-16 15:00:00', '2026-09-19 15:00:00', '2026-09-19 16:00:00', 2.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(587, N'PDV-2026-0587', 23, 1, 4, 9, '2026-09-17 15:15:00', '2026-09-17 17:15:00', '2026-09-17 17:30:00', 4.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(588, N'PDV-2026-0588', 21, 19, 4, 8, '2026-09-17 15:30:00', '2026-09-17 17:30:00', '2026-09-17 17:36:00', 9.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(589, N'PDV-2026-0589', 24, 21, 4, 12, '2026-09-17 16:45:00', '2026-09-17 18:45:00', '2026-09-17 18:59:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(590, N'PDV-2026-0590', 5, 4, 4, 9, '2026-09-19 08:00:00', '2026-09-19 10:00:00', '2026-09-19 10:09:00', 34.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(591, N'PDV-2026-0591', 21, 19, 4, 7, '2026-09-19 08:00:00', '2026-09-19 10:00:00', '2026-09-19 10:14:00', 9.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(592, N'PDV-2026-0592', 14, 12, 4, 8, '2026-09-19 08:45:00', '2026-09-19 10:45:00', '2026-09-19 11:00:00', 3.40, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(593, N'PDV-2026-0593', 18, 16, 2, 11, '2026-09-19 10:30:00', '2026-09-19 12:30:00', '2026-09-19 12:43:00', 2.90, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(594, N'PDV-2026-0594', 8, 6, 2, 8, '2026-09-19 14:00:00', '2026-09-19 16:00:00', '2026-09-19 16:11:00', 1.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(595, N'PDV-2026-0595', 26, 23, 4, 12, '2026-09-19 15:15:00', '2026-09-19 17:15:00', '2026-09-19 17:22:00', 5.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(596, N'PDV-2026-0596', 10, 8, 4, 11, '2026-09-21 09:30:00', '2026-09-21 11:30:00', '2026-09-21 11:41:00', 29.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(597, N'PDV-2026-0597', 3, 2, 4, 3, '2026-09-21 17:00:00', '2026-09-21 19:00:00', '2026-09-21 19:10:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(598, N'PDV-2026-0598', 19, 17, 4, 9, '2026-09-22 15:45:00', '2026-09-22 17:45:00', '2026-09-22 18:00:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(599, N'PDV-2026-0599', 9, 7, 4, 12, '2026-09-23 08:15:00', '2026-09-26 08:15:00', '2026-09-26 09:15:00', 4.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(600, N'PDV-2026-0600', 20, 18, 2, 3, '2026-09-23 12:45:00', '2026-09-23 14:45:00', '2026-09-23 14:51:00', 10.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True);
INSERT INTO [dbo].[tblPhieuDichVuChamSoc] ([MaPhieuDV], [SoPhieu], [MaThuCung], [MaChuNuoi], [MaNVTiepNhan], [MaNVThucHien], [NgayTiepNhan], [NgayHenTra], [NgayTraThucTe], [CanNangTiepNhan], [TinhTrangBanDau], [YeuCauCuaChuNuoi], [KetQuaChamSoc], [TongTien], [TienGiamGia], [ThanhToan], [HinhThucThanhToan], [TrangThaiThanhToan], [TrangThaiDichVu], [DanhGiaCuaChu], [GhiChu], [DaCongDiem]) VALUES
(601, N'PDV-2026-0601', 20, 18, 4, 12, '2026-09-23 18:15:00', '2026-09-23 20:15:00', '2026-09-23 20:28:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(602, N'PDV-2026-0602', 6, 5, 2, 7, '2026-09-24 11:15:00', '2026-09-24 13:15:00', '2026-09-24 13:33:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(603, N'PDV-2026-0603', 17, 15, 4, 12, '2026-09-24 11:45:00', '2026-09-24 13:45:00', '2026-09-24 13:57:00', 7.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(604, N'PDV-2026-0604', 11, 9, 2, 11, '2026-09-25 08:15:00', '2026-09-25 10:15:00', '2026-09-25 10:30:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(605, N'PDV-2026-0605', 26, 23, 2, 7, '2026-09-25 17:15:00', '2026-09-25 19:15:00', '2026-09-25 19:29:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(606, N'PDV-2026-0606', 2, 1, 4, 9, '2026-09-26 18:15:00', '2026-09-26 20:15:00', '2026-09-26 20:25:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(607, N'PDV-2026-0607', 8, 6, 4, 8, '2026-09-26 18:30:00', '2026-09-26 20:30:00', '2026-09-26 20:45:00', 1.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(608, N'PDV-2026-0608', 10, 8, 2, 9, '2026-09-27 08:00:00', '2026-09-27 10:00:00', '2026-09-27 10:10:00', 29.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(609, N'PDV-2026-0609', 6, 5, 4, 8, '2026-09-27 10:45:00', '2026-09-27 12:45:00', '2026-09-27 12:57:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(610, N'PDV-2026-0610', 19, 17, 2, 8, '2026-09-27 13:45:00', '2026-09-27 15:45:00', '2026-09-27 16:02:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(611, N'PDV-2026-0611', 14, 12, 2, 7, '2026-09-27 15:00:00', '2026-09-27 17:00:00', '2026-09-27 17:17:00', 3.40, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(612, N'PDV-2026-0612', 12, 10, 2, 11, '2026-09-27 16:00:00', '2026-09-27 18:00:00', '2026-09-27 18:18:00', 8.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(613, N'PDV-2026-0613', 20, 18, 4, 9, '2026-09-27 18:45:00', '2026-09-27 20:45:00', '2026-09-27 20:55:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(614, N'PDV-2026-0614', 15, 13, 2, 3, '2026-09-28 14:30:00', '2026-09-28 16:30:00', '2026-09-28 16:40:00', 21.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(615, N'PDV-2026-0615', 13, 11, 4, 11, '2026-09-28 15:00:00', '2026-09-28 17:00:00', '2026-09-28 17:16:00', 26.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(616, N'PDV-2026-0616', 7, 5, 2, 11, '2026-09-28 16:15:00', '2026-09-28 18:15:00', '2026-09-28 18:25:00', 3.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(617, N'PDV-2026-0617', 25, 22, 4, 3, '2026-09-29 11:45:00', '2026-09-29 13:45:00', '2026-09-29 13:59:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 30000.00, 150000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(618, N'PDV-2026-0618', 3, 2, 4, 3, '2026-09-30 11:00:00', '2026-09-30 13:00:00', '2026-09-30 13:08:00', 11.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(619, N'PDV-2026-0619', 7, 5, 2, 9, '2026-10-02 11:15:00', '2026-10-02 13:15:00', '2026-10-02 13:29:00', 3.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(620, N'PDV-2026-0620', 18, 16, 2, 8, '2026-10-03 09:30:00', '2026-10-05 09:30:00', '2026-10-05 10:30:00', 2.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(621, N'PDV-2026-0621', 1, 1, 4, 7, '2026-10-03 09:45:00', '2026-10-03 11:45:00', '2026-10-03 11:57:00', 3.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(622, N'PDV-2026-0622', 2, 1, 4, 8, '2026-10-03 13:15:00', '2026-10-03 15:15:00', '2026-10-03 15:31:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(623, N'PDV-2026-0623', 18, 16, 4, 3, '2026-10-04 08:00:00', '2026-10-04 10:00:00', '2026-10-04 10:08:00', 2.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(624, N'PDV-2026-0624', 13, 11, 4, 3, '2026-10-04 08:30:00', '2026-10-04 10:30:00', '2026-10-04 10:40:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(625, N'PDV-2026-0625', 5, 4, 4, 8, '2026-10-04 11:30:00', '2026-10-04 13:30:00', '2026-10-04 13:36:00', 34.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(626, N'PDV-2026-0626', 4, 3, 2, 12, '2026-10-04 14:45:00', '2026-10-06 14:45:00', '2026-10-06 15:45:00', 3.60, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(627, N'PDV-2026-0627', 25, 22, 4, 11, '2026-10-04 15:00:00', '2026-10-04 17:00:00', '2026-10-04 17:09:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(628, N'PDV-2026-0628', 15, 13, 4, 3, '2026-10-05 09:45:00', '2026-10-05 11:45:00', '2026-10-05 11:57:00', 21.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(629, N'PDV-2026-0629', 25, 22, 4, 7, '2026-10-05 11:45:00', '2026-10-05 13:45:00', '2026-10-05 13:58:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(630, N'PDV-2026-0630', 10, 8, 4, 8, '2026-10-05 15:45:00', '2026-10-05 17:45:00', '2026-10-05 17:55:00', 29.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(631, N'PDV-2026-0631', 9, 7, 2, 7, '2026-10-05 16:15:00', '2026-10-09 16:15:00', '2026-10-09 17:15:00', 4.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 0.00, 800000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(632, N'PDV-2026-0632', 19, 17, 2, 9, '2026-10-06 08:15:00', '2026-10-06 10:15:00', '2026-10-06 10:26:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(633, N'PDV-2026-0633', 10, 8, 4, 3, '2026-10-06 09:15:00', '2026-10-06 11:15:00', '2026-10-06 11:23:00', 29.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(634, N'PDV-2026-0634', 23, 1, 4, 9, '2026-10-07 09:30:00', '2026-10-07 11:30:00', '2026-10-07 11:41:00', 4.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(635, N'PDV-2026-0635', 12, 10, 2, 12, '2026-10-07 11:15:00', '2026-10-07 13:15:00', '2026-10-07 13:20:00', 8.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(636, N'PDV-2026-0636', 4, 3, 2, 12, '2026-10-07 17:45:00', '2026-10-07 19:45:00', '2026-10-07 19:52:00', 3.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(637, N'PDV-2026-0637', 1, 1, 4, 9, '2026-10-08 13:00:00', '2026-10-08 15:00:00', '2026-10-08 15:11:00', 3.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(638, N'PDV-2026-0638', 6, 5, 4, 9, '2026-10-08 14:00:00', '2026-10-08 16:00:00', '2026-10-08 16:08:00', 4.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 30000.00, 330000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(639, N'PDV-2026-0639', 12, 10, 4, 11, '2026-10-08 14:45:00', '2026-10-12 14:45:00', '2026-10-12 15:45:00', 8.20, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 0.00, 1400000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(640, N'PDV-2026-0640', 10, 8, 2, 7, '2026-10-10 12:45:00', '2026-10-10 14:45:00', '2026-10-10 14:57:00', 29.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(641, N'PDV-2026-0641', 20, 18, 2, 3, '2026-10-11 14:45:00', '2026-10-11 16:45:00', '2026-10-11 16:50:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(642, N'PDV-2026-0642', 17, 15, 4, 12, '2026-10-11 14:45:00', '2026-10-11 16:45:00', '2026-10-11 16:51:00', 7.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(643, N'PDV-2026-0643', 11, 9, 4, 11, '2026-10-11 18:00:00', '2026-10-11 20:00:00', '2026-10-11 20:16:00', 3.90, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(644, N'PDV-2026-0644', 5, 4, 4, 11, '2026-10-12 10:30:00', '2026-10-12 12:30:00', '2026-10-12 12:49:00', 34.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(645, N'PDV-2026-0645', 24, 21, 2, 8, '2026-10-12 13:00:00', '2026-10-12 15:00:00', '2026-10-12 15:13:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(646, N'PDV-2026-0646', 2, 1, 4, 8, '2026-10-14 08:15:00', '2026-10-14 10:15:00', '2026-10-14 10:22:00', 4.10, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(647, N'PDV-2026-0647', 13, 11, 2, 8, '2026-10-14 09:30:00', '2026-10-14 11:30:00', '2026-10-14 11:43:00', 26.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(648, N'PDV-2026-0648', 11, 9, 2, 11, '2026-10-14 12:15:00', '2026-10-14 14:15:00', '2026-10-14 14:22:00', 3.90, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(649, N'PDV-2026-0649', 17, 15, 4, 9, '2026-10-15 10:45:00', '2026-10-15 12:45:00', '2026-10-15 13:00:00', 7.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(650, N'PDV-2026-0650', 5, 4, 4, 3, '2026-10-15 11:45:00', '2026-10-15 13:45:00', '2026-10-15 14:01:00', 34.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(651, N'PDV-2026-0651', 6, 5, 4, 8, '2026-10-16 12:00:00', '2026-10-16 14:00:00', '2026-10-16 14:18:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(652, N'PDV-2026-0652', 20, 18, 4, 12, '2026-10-16 14:00:00', '2026-10-18 14:00:00', '2026-10-18 15:00:00', 10.80, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 700000.00, 0.00, 700000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(653, N'PDV-2026-0653', 19, 17, 2, 3, '2026-10-16 18:45:00', '2026-10-16 20:45:00', '2026-10-16 20:59:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(654, N'PDV-2026-0654', 4, 3, 2, 11, '2026-10-17 14:15:00', '2026-10-17 16:15:00', '2026-10-17 16:23:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(655, N'PDV-2026-0655', 19, 17, 4, 9, '2026-10-18 11:45:00', '2026-10-18 13:45:00', '2026-10-18 13:52:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(656, N'PDV-2026-0656', 22, 20, 4, 11, '2026-10-18 12:00:00', '2026-10-18 14:00:00', '2026-10-18 14:19:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(657, N'PDV-2026-0657', 2, 1, 2, 9, '2026-10-18 15:30:00', '2026-10-18 17:30:00', '2026-10-18 17:38:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(658, N'PDV-2026-0658', 22, 20, 2, 12, '2026-10-19 10:30:00', '2026-10-19 12:30:00', '2026-10-19 12:35:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(659, N'PDV-2026-0659', 1, 1, 4, 11, '2026-10-19 15:15:00', '2026-10-19 17:15:00', '2026-10-19 17:29:00', 3.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(660, N'PDV-2026-0660', 17, 15, 4, 9, '2026-10-20 10:15:00', '2026-10-20 12:15:00', '2026-10-20 12:33:00', 7.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(661, N'PDV-2026-0661', 4, 3, 2, 8, '2026-10-21 14:15:00', '2026-10-21 16:15:00', '2026-10-21 16:21:00', 3.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(662, N'PDV-2026-0662', 14, 12, 4, 7, '2026-10-22 13:45:00', '2026-10-22 15:45:00', '2026-10-22 15:50:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(663, N'PDV-2026-0663', 16, 14, 2, 8, '2026-10-22 16:15:00', '2026-10-22 18:15:00', '2026-10-22 18:35:00', 2.30, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(664, N'PDV-2026-0664', 19, 17, 2, 11, '2026-10-23 09:15:00', '2026-10-23 11:15:00', '2026-10-23 11:26:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(665, N'PDV-2026-0665', 2, 1, 2, 3, '2026-10-23 14:15:00', '2026-10-23 16:15:00', '2026-10-23 16:30:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(666, N'PDV-2026-0666', 26, 23, 2, 8, '2026-10-23 14:30:00', '2026-10-23 16:30:00', '2026-10-23 16:39:00', 5.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(667, N'PDV-2026-0667', 18, 16, 4, 7, '2026-10-23 15:00:00', '2026-10-23 17:00:00', '2026-10-23 17:07:00', 2.90, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(668, N'PDV-2026-0668', 24, 21, 2, 9, '2026-10-23 16:30:00', '2026-10-23 18:30:00', '2026-10-23 18:42:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(669, N'PDV-2026-0669', 19, 17, 2, 3, '2026-10-24 11:00:00', '2026-10-24 13:00:00', '2026-10-24 13:10:00', 36.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(670, N'PDV-2026-0670', 6, 5, 4, 9, '2026-10-24 14:45:00', '2026-10-24 16:45:00', '2026-10-24 16:52:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(671, N'PDV-2026-0671', 24, 21, 4, 12, '2026-10-25 10:30:00', '2026-10-25 12:30:00', '2026-10-25 12:46:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(672, N'PDV-2026-0672', 21, 19, 4, 7, '2026-10-25 18:00:00', '2026-10-25 20:00:00', '2026-10-25 20:19:00', 9.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(673, N'PDV-2026-0673', 3, 2, 2, 11, '2026-10-27 08:45:00', '2026-10-29 08:45:00', '2026-10-29 09:45:00', 11.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(674, N'PDV-2026-0674', 9, 7, 4, 12, '2026-10-27 12:30:00', '2026-10-27 14:30:00', '2026-10-27 14:38:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(675, N'PDV-2026-0675', 6, 5, 4, 3, '2026-10-27 13:15:00', '2026-10-27 15:15:00', '2026-10-27 15:28:00', 4.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(676, N'PDV-2026-0676', 10, 8, 4, 7, '2026-10-27 16:00:00', '2026-10-27 18:00:00', '2026-10-27 18:14:00', 29.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(677, N'PDV-2026-0677', 5, 4, 4, 8, '2026-10-28 10:15:00', '2026-10-28 12:15:00', '2026-10-28 12:30:00', 34.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(678, N'PDV-2026-0678', 18, 16, 2, 11, '2026-10-28 11:30:00', '2026-10-28 13:30:00', '2026-10-28 13:43:00', 2.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(679, N'PDV-2026-0679', 2, 1, 2, 7, '2026-10-28 12:30:00', '2026-10-30 12:30:00', '2026-10-30 13:30:00', 4.10, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 700000.00, 0.00, 700000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(680, N'PDV-2026-0680', 8, 6, 4, 7, '2026-10-28 18:15:00', '2026-10-28 20:15:00', '2026-10-28 20:34:00', 1.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(681, N'PDV-2026-0681', 16, 14, 2, 3, '2026-10-30 08:00:00', '2026-10-30 10:00:00', '2026-10-30 10:16:00', 2.30, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(682, N'PDV-2026-0682', 20, 18, 4, 3, '2026-10-30 12:00:00', '2026-10-30 14:00:00', '2026-10-30 14:19:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(683, N'PDV-2026-0683', 22, 20, 4, 12, '2026-10-30 18:30:00', '2026-10-30 20:30:00', '2026-10-30 20:42:00', 22.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(684, N'PDV-2026-0684', 23, 1, 4, 7, '2026-10-31 10:45:00', '2026-10-31 12:45:00', '2026-10-31 12:50:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(685, N'PDV-2026-0685', 26, 23, 2, 12, '2026-10-31 12:15:00', '2026-11-04 12:15:00', '2026-11-04 13:15:00', 5.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 30000.00, 770000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(686, N'PDV-2026-0686', 26, 23, 2, 9, '2026-10-31 18:00:00', '2026-10-31 20:00:00', '2026-10-31 20:05:00', 5.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(687, N'PDV-2026-0687', 14, 12, 4, 9, '2026-10-31 18:30:00', '2026-10-31 20:30:00', '2026-10-31 20:38:00', 3.40, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(688, N'PDV-2026-0688', 14, 12, 2, 7, '2026-11-01 09:15:00', '2026-11-01 11:15:00', '2026-11-01 11:30:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(689, N'PDV-2026-0689', 13, 11, 2, 9, '2026-11-01 15:30:00', '2026-11-04 15:30:00', '2026-11-04 16:30:00', 26.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(690, N'PDV-2026-0690', 26, 23, 4, 9, '2026-11-02 08:00:00', '2026-11-02 10:00:00', '2026-11-02 10:09:00', 5.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(691, N'PDV-2026-0691', 4, 3, 2, 8, '2026-11-02 08:15:00', '2026-11-05 08:15:00', '2026-11-05 09:15:00', 3.60, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(692, N'PDV-2026-0692', 11, 9, 4, 7, '2026-11-02 12:00:00', '2026-11-02 14:00:00', '2026-11-02 14:13:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(693, N'PDV-2026-0693', 19, 17, 4, 11, '2026-11-03 10:30:00', '2026-11-03 12:30:00', '2026-11-03 12:42:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(694, N'PDV-2026-0694', 20, 18, 4, 9, '2026-11-04 09:45:00', '2026-11-04 11:45:00', '2026-11-04 11:55:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(695, N'PDV-2026-0695', 23, 1, 2, 11, '2026-11-04 10:45:00', '2026-11-04 12:45:00', '2026-11-04 12:59:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(696, N'PDV-2026-0696', 2, 1, 4, 11, '2026-11-04 11:00:00', '2026-11-04 13:00:00', '2026-11-04 13:06:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(697, N'PDV-2026-0697', 25, 22, 4, 12, '2026-11-04 13:15:00', '2026-11-04 15:15:00', '2026-11-04 15:30:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(698, N'PDV-2026-0698', 11, 9, 4, 8, '2026-11-04 14:30:00', '2026-11-04 16:30:00', '2026-11-04 16:43:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(699, N'PDV-2026-0699', 10, 8, 2, 3, '2026-11-04 14:45:00', '2026-11-04 16:45:00', '2026-11-04 17:01:00', 29.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(700, N'PDV-2026-0700', 11, 9, 2, 11, '2026-11-05 08:45:00', '2026-11-07 08:45:00', '2026-11-07 09:45:00', 3.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True);
INSERT INTO [dbo].[tblPhieuDichVuChamSoc] ([MaPhieuDV], [SoPhieu], [MaThuCung], [MaChuNuoi], [MaNVTiepNhan], [MaNVThucHien], [NgayTiepNhan], [NgayHenTra], [NgayTraThucTe], [CanNangTiepNhan], [TinhTrangBanDau], [YeuCauCuaChuNuoi], [KetQuaChamSoc], [TongTien], [TienGiamGia], [ThanhToan], [HinhThucThanhToan], [TrangThaiThanhToan], [TrangThaiDichVu], [DanhGiaCuaChu], [GhiChu], [DaCongDiem]) VALUES
(701, N'PDV-2026-0701', 3, 2, 4, 11, '2026-11-05 13:30:00', '2026-11-08 13:30:00', '2026-11-08 14:30:00', 11.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(702, N'PDV-2026-0702', 26, 23, 4, 3, '2026-11-05 14:00:00', '2026-11-05 16:00:00', '2026-11-05 16:19:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(703, N'PDV-2026-0703', 13, 11, 4, 7, '2026-11-06 12:30:00', '2026-11-06 14:30:00', '2026-11-06 14:45:00', 26.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(704, N'PDV-2026-0704', 21, 19, 2, 7, '2026-11-07 09:15:00', '2026-11-07 11:15:00', '2026-11-07 11:32:00', 9.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(705, N'PDV-2026-0705', 4, 3, 2, 8, '2026-11-07 11:45:00', '2026-11-10 11:45:00', '2026-11-10 12:45:00', 3.60, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 0.00, 1050000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(706, N'PDV-2026-0706', 25, 22, 4, 12, '2026-11-07 16:15:00', '2026-11-07 18:15:00', '2026-11-07 18:32:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(707, N'PDV-2026-0707', 8, 6, 4, 8, '2026-11-08 08:45:00', '2026-11-08 10:45:00', '2026-11-08 11:01:00', 1.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(708, N'PDV-2026-0708', 24, 21, 4, 9, '2026-11-08 10:00:00', '2026-11-11 10:00:00', '2026-11-11 11:00:00', 3.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(709, N'PDV-2026-0709', 20, 18, 2, 8, '2026-11-08 13:45:00', '2026-11-08 15:45:00', '2026-11-08 16:04:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(710, N'PDV-2026-0710', 13, 11, 2, 9, '2026-11-09 10:15:00', '2026-11-09 12:15:00', '2026-11-09 12:28:00', 26.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(711, N'PDV-2026-0711', 12, 10, 4, 8, '2026-11-09 15:15:00', '2026-11-09 17:15:00', '2026-11-09 17:22:00', 8.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(712, N'PDV-2026-0712', 14, 12, 2, 12, '2026-11-09 18:00:00', '2026-11-12 18:00:00', '2026-11-12 19:00:00', 3.40, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1050000.00, 30000.00, 1020000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(713, N'PDV-2026-0713', 5, 4, 2, 7, '2026-11-09 18:15:00', '2026-11-09 20:15:00', '2026-11-09 20:22:00', 34.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(714, N'PDV-2026-0714', 12, 10, 2, 8, '2026-11-10 08:45:00', '2026-11-10 10:45:00', '2026-11-10 10:51:00', 8.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(715, N'PDV-2026-0715', 18, 16, 2, 8, '2026-11-10 09:30:00', '2026-11-10 11:30:00', '2026-11-10 11:49:00', 2.90, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 30000.00, 330000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(716, N'PDV-2026-0716', 26, 23, 2, 12, '2026-11-10 10:45:00', '2026-11-10 12:45:00', '2026-11-10 13:00:00', 5.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 30000.00, 330000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(717, N'PDV-2026-0717', 20, 18, 4, 9, '2026-11-10 11:45:00', '2026-11-10 13:45:00', '2026-11-10 13:55:00', 10.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(718, N'PDV-2026-0718', 12, 10, 2, 3, '2026-11-10 15:45:00', '2026-11-10 17:45:00', '2026-11-10 17:53:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 30000.00, 220000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(719, N'PDV-2026-0719', 16, 14, 4, 3, '2026-11-10 17:15:00', '2026-11-10 19:15:00', '2026-11-10 19:29:00', 2.30, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(720, N'PDV-2026-0720', 23, 1, 2, 3, '2026-11-10 18:45:00', '2026-11-10 20:45:00', '2026-11-10 20:59:00', 4.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(721, N'PDV-2026-0721', 22, 20, 2, 9, '2026-11-11 10:45:00', '2026-11-11 12:45:00', '2026-11-11 13:04:00', 22.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(722, N'PDV-2026-0722', 6, 5, 4, 3, '2026-11-11 13:45:00', '2026-11-11 15:45:00', '2026-11-11 15:50:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(723, N'PDV-2026-0723', 9, 7, 4, 12, '2026-11-11 15:15:00', '2026-11-11 17:15:00', '2026-11-11 17:22:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(724, N'PDV-2026-0724', 22, 20, 4, 7, '2026-11-12 11:30:00', '2026-11-12 13:30:00', '2026-11-12 13:43:00', 22.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(725, N'PDV-2026-0725', 8, 6, 4, 3, '2026-11-12 15:00:00', '2026-11-12 17:00:00', '2026-11-12 17:20:00', 1.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(726, N'PDV-2026-0726', 15, 13, 2, 3, '2026-11-12 16:30:00', '2026-11-12 18:30:00', '2026-11-12 18:45:00', 21.00, N'Lông bám bẩn', N'Tắm sấy làm sạch', N'Bé sạch sẽ thơm mát', 220000.00, 0.00, 220000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất chu đáo', NULL, True),
(727, N'PDV-2026-0727', 16, 14, 2, 11, '2026-11-13 09:15:00', '2026-11-13 11:15:00', '2026-11-13 11:28:00', 2.30, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(728, N'PDV-2026-0728', 14, 12, 2, 3, '2026-11-13 09:45:00', '2026-11-13 11:45:00', '2026-11-13 12:03:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(729, N'PDV-2026-0729', 8, 6, 2, 12, '2026-11-13 13:15:00', '2026-11-13 15:15:00', '2026-11-13 15:33:00', 1.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 30000.00, 150000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(730, N'PDV-2026-0730', 20, 18, 4, 3, '2026-11-14 11:45:00', '2026-11-14 13:45:00', '2026-11-14 13:56:00', 10.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(731, N'PDV-2026-0731', 11, 9, 2, 9, '2026-11-14 15:45:00', '2026-11-14 17:45:00', '2026-11-14 17:58:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(732, N'PDV-2026-0732', 15, 13, 4, 7, '2026-11-14 16:30:00', '2026-11-14 18:30:00', '2026-11-14 18:36:00', 21.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(733, N'PDV-2026-0733', 19, 17, 4, 7, '2026-11-15 10:00:00', '2026-11-15 12:00:00', '2026-11-15 12:13:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(734, N'PDV-2026-0734', 20, 18, 2, 3, '2026-11-15 11:00:00', '2026-11-15 13:00:00', '2026-11-15 13:15:00', 10.80, N'Lông bám bẩn', N'Tắm sấy làm sạch', N'Bé sạch sẽ thơm mát', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất chu đáo', NULL, True),
(735, N'PDV-2026-0735', 11, 9, 2, 3, '2026-11-15 15:00:00', '2026-11-15 17:00:00', '2026-11-15 17:15:00', 3.90, N'Lông bám bẩn', N'Tắm sấy làm sạch', N'Bé sạch sẽ thơm mát', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất chu đáo', NULL, True),
(736, N'PDV-2026-0736', 2, 1, 2, 7, '2026-11-16 08:45:00', '2026-11-16 10:45:00', '2026-11-16 11:02:00', 4.10, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(737, N'PDV-2026-0737', 4, 3, 4, 3, '2026-11-16 13:15:00', '2026-11-16 15:15:00', '2026-11-16 15:32:00', 3.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(738, N'PDV-2026-0738', 12, 10, 4, 3, '2026-11-16 15:15:00', '2026-11-16 17:15:00', '2026-11-16 17:33:00', 8.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 30000.00, 440000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(739, N'PDV-2026-0739', 1, 1, 2, 3, '2026-11-16 18:00:00', '2026-11-16 20:00:00', NULL, 3.80, N'Cần tắm khử mùi', N'Tắm sạch toàn diện', N'Đã hoàn thành tắm sấy, chờ khách đón', 220000.00, 0.00, 220000.00, NULL, N'Chưa thanh toán', N'Hoàn thành chăm sóc', NULL, N'Khách hẹn 19h đón', True),
(740, N'PDV-2026-0740', 2, 1, 4, 7, '2026-11-16 20:15:00', '2026-11-16 22:15:00', NULL, 4.10, N'Lông dài che mắt', N'Tỉa form gấu bông', NULL, 280000.00, 0.00, 280000.00, NULL, N'Chưa thanh toán', N'Đang thực hiện', NULL, N'Đang sấy tạo kiểu', True),
(741, N'PDV-2026-0741', 21, 19, 4, 12, '2026-11-17 08:45:00', '2026-11-19 08:45:00', '2026-11-19 09:45:00', 9.60, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(742, N'PDV-2026-0742', 8, 6, 2, 7, '2026-11-17 10:45:00', '2026-11-17 12:45:00', '2026-11-17 12:54:00', 1.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(743, N'PDV-2026-0743', 2, 1, 2, 8, '2026-11-17 11:30:00', '2026-11-17 13:30:00', '2026-11-17 13:40:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(744, N'PDV-2026-0744', 25, 22, 2, 3, '2026-11-17 16:15:00', '2026-11-17 18:15:00', '2026-11-17 18:24:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(745, N'PDV-2026-0745', 23, 1, 4, 9, '2026-11-17 16:15:00', '2026-11-17 18:15:00', '2026-11-17 18:31:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(746, N'PDV-2026-0746', 12, 10, 4, 8, '2026-11-17 18:30:00', '2026-11-17 20:30:00', '2026-11-17 20:49:00', 8.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(747, N'PDV-2026-0747', 20, 18, 2, 9, '2026-11-18 09:45:00', '2026-11-18 11:45:00', '2026-11-18 11:59:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(748, N'PDV-2026-0748', 12, 10, 4, 3, '2026-11-18 12:45:00', '2026-11-18 14:45:00', '2026-11-18 14:58:00', 8.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(749, N'PDV-2026-0749', 23, 1, 4, 3, '2026-11-20 09:30:00', '2026-11-20 11:30:00', '2026-11-20 11:50:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(750, N'PDV-2026-0750', 1, 1, 2, 9, '2026-11-20 11:00:00', '2026-11-20 13:00:00', '2026-11-20 13:07:00', 3.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 30000.00, 150000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(751, N'PDV-2026-0751', 1, 1, 2, 8, '2026-11-20 16:00:00', '2026-11-20 18:00:00', '2026-11-20 18:17:00', 3.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(752, N'PDV-2026-0752', 4, 3, 2, 11, '2026-11-21 09:15:00', '2026-11-21 11:15:00', '2026-11-21 11:34:00', 3.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(753, N'PDV-2026-0753', 15, 13, 2, 8, '2026-11-22 13:00:00', '2026-11-22 15:00:00', '2026-11-22 15:09:00', 21.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(754, N'PDV-2026-0754', 21, 19, 4, 11, '2026-11-22 14:45:00', '2026-11-22 16:45:00', '2026-11-22 17:00:00', 9.60, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(755, N'PDV-2026-0755', 5, 4, 2, 11, '2026-11-22 15:00:00', '2026-11-22 17:00:00', '2026-11-22 17:18:00', 34.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(756, N'PDV-2026-0756', 9, 7, 2, 9, '2026-11-22 16:45:00', '2026-11-22 18:45:00', '2026-11-22 19:01:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(757, N'PDV-2026-0757', 2, 1, 2, 3, '2026-11-23 09:00:00', '2026-11-23 11:00:00', '2026-11-23 11:20:00', 4.10, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(758, N'PDV-2026-0758', 13, 11, 2, 12, '2026-11-23 10:30:00', '2026-11-23 12:30:00', '2026-11-23 12:44:00', 26.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(759, N'PDV-2026-0759', 7, 5, 4, 11, '2026-11-23 16:15:00', '2026-11-26 16:15:00', '2026-11-26 17:15:00', 3.20, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 3 ngày an toàn, ăn uống vui chơi khỏe mạnh', 600000.00, 0.00, 600000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(760, N'PDV-2026-0760', 23, 1, 4, 9, '2026-11-23 16:30:00', '2026-11-27 16:30:00', '2026-11-27 17:30:00', 4.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 0.00, 1400000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(761, N'PDV-2026-0761', 16, 14, 4, 7, '2026-11-24 16:15:00', '2026-11-24 18:15:00', '2026-11-24 18:35:00', 2.30, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(762, N'PDV-2026-0762', 15, 13, 4, 7, '2026-11-25 13:00:00', '2026-11-25 15:00:00', '2026-11-25 15:10:00', 21.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(763, N'PDV-2026-0763', 11, 9, 2, 12, '2026-11-25 13:00:00', '2026-11-25 15:00:00', '2026-11-25 15:05:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(764, N'PDV-2026-0764', 11, 9, 2, 12, '2026-11-25 13:00:00', '2026-11-25 15:00:00', '2026-11-25 15:10:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(765, N'PDV-2026-0765', 7, 5, 2, 3, '2026-11-27 16:15:00', '2026-11-27 18:15:00', '2026-11-27 18:30:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(766, N'PDV-2026-0766', 16, 14, 4, 3, '2026-11-27 17:00:00', '2026-11-27 19:00:00', '2026-11-27 19:06:00', 2.30, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(767, N'PDV-2026-0767', 20, 18, 2, 3, '2026-11-28 09:00:00', '2026-11-28 11:00:00', '2026-11-28 11:19:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(768, N'PDV-2026-0768', 1, 1, 4, 11, '2026-11-28 13:00:00', '2026-11-28 15:00:00', '2026-11-28 15:11:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(769, N'PDV-2026-0769', 3, 2, 2, 9, '2026-11-29 10:45:00', '2026-11-29 12:45:00', '2026-11-29 13:03:00', 11.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(770, N'PDV-2026-0770', 21, 19, 4, 8, '2026-11-29 12:00:00', '2026-11-29 14:00:00', '2026-11-29 14:20:00', 9.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(771, N'PDV-2026-0771', 11, 9, 4, 11, '2026-11-29 18:45:00', '2026-11-29 20:45:00', '2026-11-29 21:03:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(772, N'PDV-2026-0772', 24, 21, 2, 12, '2026-11-30 14:00:00', '2026-11-30 16:00:00', '2026-11-30 16:20:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(773, N'PDV-2026-0773', 26, 23, 2, 11, '2026-12-01 11:15:00', '2026-12-01 13:15:00', '2026-12-01 13:22:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(774, N'PDV-2026-0774', 20, 18, 4, 12, '2026-12-01 13:15:00', '2026-12-01 15:15:00', '2026-12-01 15:22:00', 10.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(775, N'PDV-2026-0775', 25, 22, 2, 8, '2026-12-01 15:45:00', '2026-12-01 17:45:00', '2026-12-01 18:01:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(776, N'PDV-2026-0776', 24, 21, 4, 11, '2026-12-01 16:15:00', '2026-12-01 18:15:00', '2026-12-01 18:23:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(777, N'PDV-2026-0777', 5, 4, 2, 8, '2026-12-01 17:15:00', '2026-12-01 19:15:00', '2026-12-01 19:25:00', 34.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(778, N'PDV-2026-0778', 5, 4, 4, 9, '2026-12-02 09:15:00', '2026-12-02 11:15:00', '2026-12-02 11:35:00', 34.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(779, N'PDV-2026-0779', 21, 19, 4, 11, '2026-12-02 14:45:00', '2026-12-02 16:45:00', '2026-12-02 16:55:00', 9.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(780, N'PDV-2026-0780', 1, 1, 4, 11, '2026-12-03 11:15:00', '2026-12-03 13:15:00', '2026-12-03 13:31:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(781, N'PDV-2026-0781', 12, 10, 2, 11, '2026-12-03 18:00:00', '2026-12-03 20:00:00', '2026-12-03 20:11:00', 8.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(782, N'PDV-2026-0782', 6, 5, 4, 9, '2026-12-04 09:15:00', '2026-12-04 11:15:00', '2026-12-04 11:22:00', 4.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(783, N'PDV-2026-0783', 17, 15, 4, 9, '2026-12-04 14:30:00', '2026-12-04 16:30:00', '2026-12-04 16:43:00', 7.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(784, N'PDV-2026-0784', 19, 17, 4, 9, '2026-12-04 14:45:00', '2026-12-04 16:45:00', '2026-12-04 16:58:00', 36.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(785, N'PDV-2026-0785', 21, 19, 2, 7, '2026-12-04 16:30:00', '2026-12-04 18:30:00', '2026-12-04 18:41:00', 9.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(786, N'PDV-2026-0786', 2, 1, 2, 7, '2026-12-04 16:45:00', '2026-12-04 18:45:00', '2026-12-04 19:05:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(787, N'PDV-2026-0787', 7, 5, 4, 8, '2026-12-05 08:30:00', '2026-12-05 10:30:00', '2026-12-05 10:43:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(788, N'PDV-2026-0788', 22, 20, 4, 3, '2026-12-05 12:30:00', '2026-12-05 14:30:00', '2026-12-05 14:47:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(789, N'PDV-2026-0789', 10, 8, 2, 11, '2026-12-05 15:15:00', '2026-12-05 17:15:00', '2026-12-05 17:35:00', 29.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(790, N'PDV-2026-0790', 23, 1, 2, 8, '2026-12-05 15:30:00', '2026-12-05 17:30:00', '2026-12-05 17:38:00', 4.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(791, N'PDV-2026-0791', 20, 18, 2, 12, '2026-12-06 15:00:00', '2026-12-06 17:00:00', '2026-12-06 17:13:00', 10.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(792, N'PDV-2026-0792', 7, 5, 2, 7, '2026-12-06 15:00:00', '2026-12-06 17:00:00', '2026-12-06 17:09:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(793, N'PDV-2026-0793', 1, 1, 4, 7, '2026-12-07 15:30:00', '2026-12-07 17:30:00', '2026-12-07 17:41:00', 3.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(794, N'PDV-2026-0794', 10, 8, 4, 8, '2026-12-07 16:30:00', '2026-12-07 18:30:00', '2026-12-07 18:44:00', 29.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(795, N'PDV-2026-0795', 20, 18, 4, 9, '2026-12-08 09:15:00', '2026-12-08 11:15:00', '2026-12-08 11:32:00', 10.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(796, N'PDV-2026-0796', 13, 11, 2, 12, '2026-12-09 08:30:00', '2026-12-09 10:30:00', '2026-12-09 10:50:00', 26.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(797, N'PDV-2026-0797', 5, 4, 4, 3, '2026-12-09 09:45:00', '2026-12-09 11:45:00', '2026-12-09 12:02:00', 34.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(798, N'PDV-2026-0798', 20, 18, 4, 11, '2026-12-09 10:30:00', '2026-12-09 12:30:00', '2026-12-09 12:36:00', 10.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(799, N'PDV-2026-0799', 5, 4, 2, 7, '2026-12-09 14:30:00', '2026-12-09 16:30:00', '2026-12-09 16:45:00', 34.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(800, N'PDV-2026-0800', 11, 9, 4, 9, '2026-12-09 16:30:00', '2026-12-09 18:30:00', '2026-12-09 18:38:00', 3.90, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True);
INSERT INTO [dbo].[tblPhieuDichVuChamSoc] ([MaPhieuDV], [SoPhieu], [MaThuCung], [MaChuNuoi], [MaNVTiepNhan], [MaNVThucHien], [NgayTiepNhan], [NgayHenTra], [NgayTraThucTe], [CanNangTiepNhan], [TinhTrangBanDau], [YeuCauCuaChuNuoi], [KetQuaChamSoc], [TongTien], [TienGiamGia], [ThanhToan], [HinhThucThanhToan], [TrangThaiThanhToan], [TrangThaiDichVu], [DanhGiaCuaChu], [GhiChu], [DaCongDiem]) VALUES
(801, N'PDV-2026-0801', 6, 5, 4, 11, '2026-12-10 08:45:00', '2026-12-10 10:45:00', '2026-12-10 10:59:00', 4.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(802, N'PDV-2026-0802', 25, 22, 2, 8, '2026-12-10 10:45:00', '2026-12-10 12:45:00', '2026-12-10 12:55:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(803, N'PDV-2026-0803', 22, 20, 4, 11, '2026-12-10 12:00:00', '2026-12-10 14:00:00', '2026-12-10 14:12:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(804, N'PDV-2026-0804', 23, 1, 4, 3, '2026-12-11 12:45:00', '2026-12-11 14:45:00', '2026-12-11 14:52:00', 4.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(805, N'PDV-2026-0805', 5, 4, 2, 12, '2026-12-11 14:30:00', '2026-12-11 16:30:00', '2026-12-11 16:40:00', 34.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(806, N'PDV-2026-0806', 14, 12, 4, 12, '2026-12-12 08:30:00', '2026-12-12 10:30:00', '2026-12-12 10:43:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(807, N'PDV-2026-0807', 11, 9, 4, 12, '2026-12-12 14:00:00', '2026-12-12 16:00:00', '2026-12-12 16:19:00', 3.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(808, N'PDV-2026-0808', 11, 9, 2, 12, '2026-12-12 15:00:00', '2026-12-16 15:00:00', '2026-12-16 16:00:00', 3.90, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 800000.00, 30000.00, 770000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(809, N'PDV-2026-0809', 25, 22, 2, 7, '2026-12-12 17:45:00', '2026-12-12 19:45:00', '2026-12-12 20:03:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(810, N'PDV-2026-0810', 11, 9, 4, 7, '2026-12-13 15:00:00', '2026-12-13 17:00:00', '2026-12-13 17:15:00', 3.90, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(811, N'PDV-2026-0811', 18, 16, 4, 8, '2026-12-14 09:15:00', '2026-12-14 11:15:00', '2026-12-14 11:33:00', 2.90, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(812, N'PDV-2026-0812', 23, 1, 2, 3, '2026-12-14 09:45:00', '2026-12-14 11:45:00', '2026-12-14 11:56:00', 4.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(813, N'PDV-2026-0813', 25, 22, 2, 11, '2026-12-14 09:45:00', '2026-12-14 11:45:00', '2026-12-14 11:54:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(814, N'PDV-2026-0814', 18, 16, 2, 7, '2026-12-14 13:00:00', '2026-12-14 15:00:00', '2026-12-14 15:16:00', 2.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(815, N'PDV-2026-0815', 21, 19, 2, 11, '2026-12-14 14:15:00', '2026-12-14 16:15:00', '2026-12-14 16:35:00', 9.60, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(816, N'PDV-2026-0816', 10, 8, 4, 9, '2026-12-14 18:15:00', '2026-12-14 20:15:00', '2026-12-14 20:20:00', 29.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 30000.00, 290000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(817, N'PDV-2026-0817', 8, 6, 4, 8, '2026-12-15 10:30:00', '2026-12-15 12:30:00', '2026-12-15 12:38:00', 1.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(818, N'PDV-2026-0818', 23, 1, 4, 12, '2026-12-15 13:00:00', '2026-12-15 15:00:00', '2026-12-15 15:16:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(819, N'PDV-2026-0819', 2, 1, 2, 7, '2026-12-15 17:15:00', '2026-12-15 19:15:00', '2026-12-15 19:34:00', 4.10, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(820, N'PDV-2026-0820', 19, 17, 4, 11, '2026-12-15 18:15:00', '2026-12-15 20:15:00', '2026-12-15 20:21:00', 36.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(821, N'PDV-2026-0821', 20, 18, 4, 8, '2026-12-16 11:30:00', '2026-12-16 13:30:00', '2026-12-16 13:46:00', 10.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 30000.00, 590000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(822, N'PDV-2026-0822', 4, 3, 4, 8, '2026-12-16 12:00:00', '2026-12-18 12:00:00', '2026-12-18 13:00:00', 3.60, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 700000.00, 0.00, 700000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(823, N'PDV-2026-0823', 8, 6, 4, 12, '2026-12-16 16:15:00', '2026-12-16 18:15:00', '2026-12-16 18:29:00', 1.80, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(824, N'PDV-2026-0824', 14, 12, 4, 3, '2026-12-17 09:30:00', '2026-12-17 11:30:00', '2026-12-17 11:44:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(825, N'PDV-2026-0825', 16, 14, 4, 8, '2026-12-17 14:45:00', '2026-12-17 16:45:00', '2026-12-17 16:50:00', 2.30, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(826, N'PDV-2026-0826', 14, 12, 2, 11, '2026-12-17 15:00:00', '2026-12-17 17:00:00', '2026-12-17 17:15:00', 3.40, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(827, N'PDV-2026-0827', 11, 9, 4, 9, '2026-12-17 15:45:00', '2026-12-17 17:45:00', '2026-12-17 18:05:00', 3.90, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(828, N'PDV-2026-0828', 17, 15, 4, 8, '2026-12-17 18:15:00', '2026-12-17 20:15:00', '2026-12-17 20:31:00', 7.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(829, N'PDV-2026-0829', 13, 11, 2, 12, '2026-12-18 10:45:00', '2026-12-18 12:45:00', '2026-12-18 12:58:00', 26.00, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 0.00, 380000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(830, N'PDV-2026-0830', 19, 17, 2, 3, '2026-12-18 16:15:00', '2026-12-18 18:15:00', '2026-12-18 18:22:00', 36.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 30000.00, 330000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(831, N'PDV-2026-0831', 22, 20, 2, 9, '2026-12-19 10:15:00', '2026-12-19 12:15:00', '2026-12-19 12:33:00', 22.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(832, N'PDV-2026-0832', 16, 14, 2, 7, '2026-12-20 08:15:00', '2026-12-20 10:15:00', '2026-12-20 10:20:00', 2.30, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(833, N'PDV-2026-0833', 24, 21, 2, 8, '2026-12-20 13:15:00', '2026-12-20 15:15:00', '2026-12-20 15:20:00', 3.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(834, N'PDV-2026-0834', 6, 5, 4, 12, '2026-12-20 18:45:00', '2026-12-20 20:45:00', '2026-12-20 21:05:00', 4.80, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(835, N'PDV-2026-0835', 10, 8, 4, 9, '2026-12-21 08:15:00', '2026-12-21 10:15:00', '2026-12-21 10:28:00', 29.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(836, N'PDV-2026-0836', 14, 12, 2, 9, '2026-12-21 08:30:00', '2026-12-21 10:30:00', '2026-12-21 10:49:00', 3.40, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(837, N'PDV-2026-0837', 7, 5, 2, 11, '2026-12-21 11:15:00', '2026-12-21 13:15:00', '2026-12-21 13:35:00', 3.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(838, N'PDV-2026-0838', 24, 21, 2, 7, '2026-12-21 13:45:00', '2026-12-21 15:45:00', '2026-12-21 15:52:00', 3.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(839, N'PDV-2026-0839', 11, 9, 4, 3, '2026-12-21 18:30:00', '2026-12-21 20:30:00', '2026-12-21 20:41:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(840, N'PDV-2026-0840', 26, 23, 4, 8, '2026-12-22 13:45:00', '2026-12-22 15:45:00', '2026-12-22 16:02:00', 5.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(841, N'PDV-2026-0841', 6, 5, 4, 8, '2026-12-23 09:30:00', '2026-12-23 11:30:00', '2026-12-23 11:35:00', 4.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(842, N'PDV-2026-0842', 4, 3, 2, 9, '2026-12-23 09:45:00', '2026-12-23 11:45:00', '2026-12-23 12:00:00', 3.60, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 30000.00, 470000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(843, N'PDV-2026-0843', 5, 4, 2, 9, '2026-12-23 10:15:00', '2026-12-23 12:15:00', '2026-12-23 12:22:00', 34.00, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 470000.00, 0.00, 470000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(844, N'PDV-2026-0844', 16, 14, 4, 12, '2026-12-23 10:45:00', '2026-12-23 12:45:00', '2026-12-23 13:04:00', 2.30, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(845, N'PDV-2026-0845', 11, 9, 2, 7, '2026-12-23 11:45:00', '2026-12-23 13:45:00', '2026-12-23 14:05:00', 3.90, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 620000.00, 0.00, 620000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(846, N'PDV-2026-0846', 17, 15, 4, 9, '2026-12-23 15:30:00', '2026-12-23 17:30:00', '2026-12-23 17:44:00', 7.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(847, N'PDV-2026-0847', 15, 13, 2, 3, '2026-12-24 08:30:00', '2026-12-24 10:30:00', '2026-12-24 10:43:00', 21.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 0.00, 280000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Spa uy tín, nhân viên nhẹ nhàng yêu thương động vật.', N'Khách hàng thân thiết', True),
(848, N'PDV-2026-0848', 14, 12, 2, 3, '2026-12-24 13:00:00', '2026-12-24 15:00:00', '2026-12-24 15:17:00', 3.40, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 280000.00, 30000.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(849, N'PDV-2026-0849', 3, 2, 2, 11, '2026-12-24 14:15:00', '2026-12-24 16:15:00', '2026-12-24 16:25:00', 11.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(850, N'PDV-2026-0850', 26, 23, 2, 12, '2026-12-24 18:00:00', '2026-12-24 20:00:00', '2026-12-24 20:16:00', 5.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 30000.00, 150000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(851, N'PDV-2026-0851', 20, 18, 4, 9, '2026-12-25 13:30:00', '2026-12-25 15:30:00', '2026-12-25 15:48:00', 10.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(852, N'PDV-2026-0852', 5, 4, 2, 8, '2026-12-25 16:45:00', '2026-12-25 18:45:00', '2026-12-25 18:53:00', 34.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(853, N'PDV-2026-0853', 14, 12, 2, 9, '2026-12-26 10:30:00', '2026-12-26 12:30:00', '2026-12-26 12:45:00', 3.40, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(854, N'PDV-2026-0854', 9, 7, 4, 9, '2026-12-26 14:15:00', '2026-12-26 16:15:00', '2026-12-26 16:28:00', 4.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ khách sạn rất tốt, camera xem 24/7 yên tâm.', N'Khách hàng thân thiết', True),
(855, N'PDV-2026-0855', 23, 1, 4, 9, '2026-12-26 15:30:00', '2026-12-28 15:30:00', '2026-12-28 16:30:00', 4.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 400000.00, 0.00, 400000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(856, N'PDV-2026-0856', 19, 17, 4, 12, '2026-12-26 16:45:00', '2026-12-26 18:45:00', '2026-12-26 19:00:00', 36.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 180000.00, 0.00, 180000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(857, N'PDV-2026-0857', 12, 10, 2, 12, '2026-12-27 09:45:00', '2026-12-27 11:45:00', '2026-12-27 11:52:00', 8.20, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 380000.00, 30000.00, 350000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tư vấn nhiệt tình, giá cả hợp lý so với chất lượng.', N'Khách hàng thân thiết', True),
(858, N'PDV-2026-0858', 8, 6, 2, 9, '2026-12-27 16:00:00', '2026-12-27 18:00:00', '2026-12-27 18:05:00', 1.80, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 250000.00, 0.00, 250000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(859, N'PDV-2026-0859', 24, 21, 4, 11, '2026-12-28 13:45:00', '2026-12-28 15:45:00', '2026-12-28 16:01:00', 3.50, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng, bé thơm tho sạch sẽ và ngoan ngoãn.', N'Khách hàng thân thiết', True),
(860, N'PDV-2026-0860', 12, 10, 2, 8, '2026-12-28 16:45:00', '2026-12-28 18:45:00', '2026-12-28 19:03:00', 8.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Lông bé mềm mượt bồng bềnh, hết hẳn mùi hôi tuyến hôi.', N'Khách hàng thân thiết', True),
(861, N'PDV-2026-0861', 9, 7, 4, 7, '2026-12-29 11:15:00', '2026-12-29 13:15:00', '2026-12-29 13:29:00', 4.50, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tẩy giun và cắt móng êm ru, không bị chảy máu.', N'Khách hàng thân thiết', True),
(862, N'PDV-2026-0862', 3, 2, 4, 8, '2026-12-29 13:00:00', '2027-01-02 13:00:00', '2027-01-02 14:00:00', 11.50, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 4 ngày an toàn, ăn uống vui chơi khỏe mạnh', 1400000.00, 0.00, 1400000.00, N'VNPay', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ 5 sao, chắc chắn sẽ gắn bó lâu dài!', N'Khách hàng thân thiết', True),
(863, N'PDV-2026-0863', 12, 10, 4, 7, '2026-12-29 17:15:00', '2026-12-29 19:15:00', '2026-12-29 19:27:00', 8.20, N'Lông dài che mắt, rối nhẹ vùng cổ', N'Cắt phom tròn Teddy bear, tắm dưỡng bóng mượt', N'Cắt phom tròn đẹp, dáng chuẩn, lông óng mượt thơm lâu', 500000.00, 0.00, 500000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Cắt tỉa mặt gấu tròn xoe cực kỳ dễ thương!', N'Khách hàng thân thiết', True),
(864, N'PDV-2026-0864', 12, 10, 4, 11, '2026-12-29 17:30:00', '2026-12-29 19:30:00', '2026-12-29 19:38:00', 8.20, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bác sĩ tận tình, khám kỹ và hướng dẫn dinh dưỡng chu đáo.', N'Khách hàng thân thiết', True),
(865, N'PDV-2026-0865', 23, 1, 2, 3, '2026-12-30 15:45:00', '2026-12-30 17:45:00', '2026-12-30 18:04:00', 4.00, N'Lông bám bẩn nhẹ, móng hơi dài', N'Tắm sấy thơm tho, cắt mài móng sạch sẽ', N'Bé tắm thơm tho, lông tơi xốp, tai và móng sạch sẽ', 320000.00, 0.00, 320000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(866, N'PDV-2026-0866', 10, 8, 2, 12, '2026-12-31 09:15:00', '2026-12-31 11:15:00', '2026-12-31 11:28:00', 29.50, N'Đến lịch tiêm chủng định kỳ', N'Kiểm tra sức khỏe trước tiêm và chích ngừa', N'Sức khỏe tốt, thân nhiệt bình thường, tiêm an toàn', 360000.00, 0.00, 360000.00, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True),
(867, N'PDV-2026-0867', 5, 4, 4, 3, '2026-12-31 16:15:00', '2027-01-02 16:15:00', '2027-01-02 17:15:00', 34.00, N'Chủ nuôi đi công tác gửi bé lưu trú', N'Phòng điều hòa, ăn hạt cao cấp, dắt đi dạo mỗi ngày', N'Lưu trú 2 ngày an toàn, ăn uống vui chơi khỏe mạnh', 700000.00, 0.00, 700000.00, N'VietQR', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đã tiêm phòng xong, bé về ăn ngủ khỏe mạnh.', N'Khách hàng thân thiết', True);
SET IDENTITY_INSERT [dbo].[tblPhieuDichVuChamSoc] OFF;
GO

-- 6. DỮ LIỆU MẪU: CHI TIẾT DỊCH VỤ CHĂM SÓC (tblChiTietDichVuChamSoc)
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(1, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(1, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(2, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(2, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(3, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(3, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(4, 11, 4, 350000.00, 0.00, 1400000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 4 ngày điều hòa'),
(5, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(5, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(6, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(6, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(7, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(7, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(8, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(8, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(9, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(9, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(10, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(10, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(11, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(11, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(12, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(12, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(13, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(13, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(14, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(14, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(15, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(15, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(16, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(16, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(17, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(17, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(18, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(18, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(19, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(19, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(20, 10, 2, 200000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 2 ngày điều hòa'),
(21, 11, 4, 350000.00, 0.00, 1400000.00, N'Lê Văn Minh', N'Phòng lưu trú 4 ngày điều hòa'),
(22, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(22, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(23, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(23, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(24, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(24, 17, 1, 60000.00, 0.00, 60000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(25, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(25, 15, 1, 240000.00, 0.00, 240000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(26, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(26, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(27, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(27, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(28, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(28, 17, 1, 60000.00, 0.00, 60000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(29, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(29, 5, 1, 280000.00, 0.00, 280000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(30, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(30, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(31, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(31, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(32, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(32, 9, 1, 250000.00, 0.00, 250000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(33, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(33, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(34, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(34, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(35, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(35, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(36, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(36, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(37, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(37, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(38, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(38, 14, 1, 260000.00, 0.00, 260000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(39, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(39, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(40, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(40, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(41, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(41, 15, 1, 240000.00, 0.00, 240000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(42, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(42, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(43, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(43, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(44, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(44, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(45, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(45, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(46, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(46, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(47, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(47, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(48, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(48, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(49, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(49, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(50, 10, 4, 200000.00, 0.00, 800000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 4 ngày điều hòa'),
(51, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(51, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(52, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(52, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(53, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(53, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(54, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(54, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(55, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(55, 6, 1, 400000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(56, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(56, 14, 1, 260000.00, 0.00, 260000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(57, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(57, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(58, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(58, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(59, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(59, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(60, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(60, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(61, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(61, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(62, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(62, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(63, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(63, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(64, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(64, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(65, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(65, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(66, 10, 2, 200000.00, 0.00, 400000.00, N'Trần Thị Mỹ Duyên', N'Phòng lưu trú 2 ngày điều hòa'),
(67, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(67, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(68, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(68, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(69, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(69, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(70, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(70, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(71, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(71, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(72, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(72, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(73, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(73, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(74, 11, 2, 350000.00, 0.00, 700000.00, N'Lê Văn Minh', N'Phòng lưu trú 2 ngày điều hòa'),
(75, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(75, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(76, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(76, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(77, 11, 3, 350000.00, 0.00, 1050000.00, N'Phạm Văn Tài', N'Phòng lưu trú 3 ngày điều hòa'),
(78, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(78, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(79, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(79, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(80, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(80, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(81, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(81, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(82, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(82, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(83, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(83, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(84, 10, 3, 200000.00, 0.00, 600000.00, N'Phạm Văn Tài', N'Phòng lưu trú 3 ngày điều hòa'),
(85, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(85, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(86, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(86, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(87, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(87, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(88, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(88, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(89, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(89, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(90, 11, 4, 350000.00, 0.00, 1400000.00, N'Phạm Văn Tài', N'Phòng lưu trú 4 ngày điều hòa'),
(91, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(91, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(92, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(92, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(93, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(93, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(94, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(94, 5, 1, 280000.00, 0.00, 280000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(95, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(95, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(96, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(96, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(97, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(97, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(98, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(98, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(99, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(99, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(100, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(100, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(101, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(101, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(102, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(102, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(103, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(103, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(104, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(104, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(105, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(105, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(106, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(106, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(107, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(107, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(108, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(108, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(109, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(109, 6, 1, 400000.00, 0.00, 400000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(110, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(110, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(111, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(111, 5, 1, 280000.00, 0.00, 280000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(112, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(112, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(113, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(113, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(114, 11, 3, 350000.00, 0.00, 1050000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 3 ngày điều hòa'),
(115, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(115, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(116, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(116, 14, 1, 260000.00, 0.00, 260000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(117, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(117, 6, 1, 400000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(118, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(118, 15, 1, 240000.00, 0.00, 240000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(119, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(119, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(120, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(120, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(121, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(121, 9, 1, 250000.00, 0.00, 250000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(122, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(122, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(123, 11, 3, 350000.00, 0.00, 1050000.00, N'Phạm Văn Tài', N'Phòng lưu trú 3 ngày điều hòa'),
(124, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(124, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(125, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(125, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(126, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(126, 5, 1, 280000.00, 0.00, 280000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(127, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(127, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(128, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(128, 6, 1, 400000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(129, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(129, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(130, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(130, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(131, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(131, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(132, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(132, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(133, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(133, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(134, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(134, 6, 1, 400000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(135, 10, 3, 200000.00, 0.00, 600000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 3 ngày điều hòa'),
(136, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(136, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(137, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(137, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(138, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(138, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(139, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(139, 15, 1, 240000.00, 0.00, 240000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(140, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(140, 14, 1, 260000.00, 0.00, 260000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(141, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(141, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(142, 11, 4, 350000.00, 0.00, 1400000.00, N'Trần Thị Mỹ Duyên', N'Phòng lưu trú 4 ngày điều hòa'),
(143, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(143, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(144, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(144, 9, 1, 250000.00, 0.00, 250000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(145, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(145, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(146, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(146, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(147, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(147, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(148, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(148, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(149, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(149, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(150, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(150, 17, 1, 60000.00, 0.00, 60000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(151, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(151, 17, 1, 60000.00, 0.00, 60000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(152, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(152, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(153, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(153, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(154, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(154, 14, 1, 260000.00, 0.00, 260000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(155, 10, 4, 200000.00, 0.00, 800000.00, N'Trần Thị Mỹ Duyên', N'Phòng lưu trú 4 ngày điều hòa'),
(156, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(156, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(157, 10, 4, 200000.00, 0.00, 800000.00, N'Phạm Văn Tài', N'Phòng lưu trú 4 ngày điều hòa'),
(158, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(158, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(159, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(159, 6, 1, 400000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(160, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(160, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(161, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(161, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(162, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(162, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(163, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(163, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(164, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(164, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(165, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(165, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(166, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(166, 14, 1, 260000.00, 0.00, 260000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(167, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(167, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(168, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(168, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(169, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(169, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(170, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(170, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(171, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(171, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(172, 11, 4, 350000.00, 0.00, 1400000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 4 ngày điều hòa'),
(173, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(173, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(174, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(174, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(175, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(175, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(176, 11, 4, 350000.00, 0.00, 1400000.00, N'Lê Văn Minh', N'Phòng lưu trú 4 ngày điều hòa'),
(177, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(177, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(178, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(178, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(179, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(179, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(180, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(180, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(181, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(181, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(182, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(182, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(183, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(183, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(184, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(184, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(185, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(185, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(186, 11, 2, 350000.00, 0.00, 700000.00, N'Phạm Văn Tài', N'Phòng lưu trú 2 ngày điều hòa'),
(187, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(187, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(188, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(188, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(189, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(189, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(190, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(190, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(191, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(191, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(192, 10, 2, 200000.00, 0.00, 400000.00, N'Trần Thị Mỹ Duyên', N'Phòng lưu trú 2 ngày điều hòa'),
(193, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(193, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(194, 10, 2, 200000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Phòng lưu trú 2 ngày điều hòa'),
(195, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(195, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(196, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(196, 9, 1, 250000.00, 0.00, 250000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(197, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(197, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(198, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(198, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(199, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(199, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(200, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(200, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(201, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(201, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(202, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(202, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(203, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(203, 17, 1, 60000.00, 0.00, 60000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(204, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(204, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(205, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(205, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(206, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(206, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(207, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(207, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(208, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(208, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(209, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(209, 9, 1, 250000.00, 0.00, 250000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(210, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(210, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(211, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(211, 17, 1, 60000.00, 0.00, 60000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(212, 10, 4, 200000.00, 0.00, 800000.00, N'Lê Văn Minh', N'Phòng lưu trú 4 ngày điều hòa'),
(213, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(213, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(214, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(214, 6, 1, 400000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(215, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(215, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(216, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(216, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(217, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(217, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(218, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(218, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(219, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(219, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(220, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(220, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(221, 10, 3, 200000.00, 0.00, 600000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 3 ngày điều hòa'),
(222, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(222, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(223, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(223, 17, 1, 60000.00, 0.00, 60000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(224, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(224, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(225, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(225, 17, 1, 60000.00, 0.00, 60000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(226, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(226, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(227, 11, 3, 350000.00, 0.00, 1050000.00, N'Trần Thị Mỹ Duyên', N'Phòng lưu trú 3 ngày điều hòa'),
(228, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(228, 14, 1, 260000.00, 0.00, 260000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(229, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(229, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(230, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(230, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(231, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(231, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(232, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(232, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(233, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(233, 5, 1, 280000.00, 0.00, 280000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(234, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(234, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(235, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(235, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(236, 10, 3, 200000.00, 0.00, 600000.00, N'Bùi Ngọc Thúy', N'Phòng lưu trú 3 ngày điều hòa'),
(237, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(237, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(238, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(238, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(239, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(239, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(240, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(240, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(241, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(241, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(242, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(242, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(243, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(243, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(244, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(244, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(245, 11, 3, 350000.00, 0.00, 1050000.00, N'Lê Văn Minh', N'Phòng lưu trú 3 ngày điều hòa'),
(246, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(246, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(247, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(247, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(248, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(248, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(249, 11, 3, 350000.00, 0.00, 1050000.00, N'Phạm Văn Tài', N'Phòng lưu trú 3 ngày điều hòa'),
(250, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(250, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(251, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(251, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(252, 10, 4, 200000.00, 0.00, 800000.00, N'Lê Văn Minh', N'Phòng lưu trú 4 ngày điều hòa'),
(253, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(253, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(254, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(254, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(255, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(255, 6, 1, 400000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(256, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(256, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(257, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(257, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(258, 11, 3, 350000.00, 0.00, 1050000.00, N'Bùi Ngọc Thúy', N'Phòng lưu trú 3 ngày điều hòa'),
(259, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(259, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(260, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(260, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(261, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(261, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(262, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(262, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(263, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(263, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(264, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(264, 14, 1, 260000.00, 0.00, 260000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(265, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(265, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(266, 11, 4, 350000.00, 0.00, 1400000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 4 ngày điều hòa'),
(267, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(267, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(268, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(268, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(269, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(269, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(270, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(270, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(271, 11, 4, 350000.00, 0.00, 1400000.00, N'Phạm Văn Tài', N'Phòng lưu trú 4 ngày điều hòa'),
(272, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(272, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(273, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(273, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(274, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(274, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(275, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(275, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(276, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(276, 15, 1, 240000.00, 0.00, 240000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(277, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(277, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(278, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(278, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(279, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(279, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(280, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(280, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(281, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(281, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(282, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(282, 14, 1, 260000.00, 0.00, 260000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(283, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(283, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(284, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(284, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(285, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(285, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(286, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(286, 6, 1, 400000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(287, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(287, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(288, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(288, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(289, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(289, 6, 1, 400000.00, 0.00, 400000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(290, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(290, 17, 1, 60000.00, 0.00, 60000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(291, 10, 3, 200000.00, 0.00, 600000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 3 ngày điều hòa'),
(292, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(292, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(293, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(293, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(294, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(294, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(295, 11, 3, 350000.00, 0.00, 1050000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 3 ngày điều hòa'),
(296, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(296, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(297, 10, 3, 200000.00, 0.00, 600000.00, N'Bùi Ngọc Thúy', N'Phòng lưu trú 3 ngày điều hòa'),
(298, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(298, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(299, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(299, 17, 1, 60000.00, 0.00, 60000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(300, 10, 3, 200000.00, 0.00, 600000.00, N'Lê Văn Minh', N'Phòng lưu trú 3 ngày điều hòa'),
(301, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(301, 6, 1, 400000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(302, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(302, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(303, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(303, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(304, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(304, 17, 1, 60000.00, 0.00, 60000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(305, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(305, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(306, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(306, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(307, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(307, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(308, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(308, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(309, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(309, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(310, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(310, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(311, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(311, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(312, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(312, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(313, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(313, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(314, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(314, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(315, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(315, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(316, 10, 4, 200000.00, 0.00, 800000.00, N'Bùi Ngọc Thúy', N'Phòng lưu trú 4 ngày điều hòa'),
(317, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(317, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(318, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(318, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(319, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(319, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(320, 11, 2, 350000.00, 0.00, 700000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 2 ngày điều hòa'),
(321, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(321, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(322, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(322, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(323, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(323, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(324, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(324, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(325, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(325, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(326, 11, 4, 350000.00, 0.00, 1400000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 4 ngày điều hòa'),
(327, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(327, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(328, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(328, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(329, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(329, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(330, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(330, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(331, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(331, 14, 1, 260000.00, 0.00, 260000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(332, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(332, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(333, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(333, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(334, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(334, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(335, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(335, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(336, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(336, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(337, 11, 3, 350000.00, 0.00, 1050000.00, N'Trần Thị Mỹ Duyên', N'Phòng lưu trú 3 ngày điều hòa'),
(338, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(338, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(339, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(339, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(340, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(340, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(341, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(341, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(342, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(342, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(343, 11, 4, 350000.00, 0.00, 1400000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 4 ngày điều hòa'),
(344, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(344, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(345, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(345, 5, 1, 280000.00, 0.00, 280000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(346, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(346, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(347, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(347, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(348, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(348, 5, 1, 280000.00, 0.00, 280000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(349, 10, 3, 200000.00, 0.00, 600000.00, N'Phạm Văn Tài', N'Phòng lưu trú 3 ngày điều hòa'),
(350, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(350, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(351, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(351, 14, 1, 260000.00, 0.00, 260000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(352, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(352, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(353, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(353, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(354, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(354, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(355, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(355, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(356, 11, 2, 350000.00, 0.00, 700000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 2 ngày điều hòa'),
(357, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(357, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(358, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(358, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(359, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(359, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(360, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(360, 6, 1, 400000.00, 0.00, 400000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(361, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(361, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(362, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(362, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(363, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(363, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(364, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(364, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(365, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(365, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(366, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(366, 6, 1, 400000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(367, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(367, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(368, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(368, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(369, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(369, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(370, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(370, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(371, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(371, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(372, 11, 3, 350000.00, 0.00, 1050000.00, N'Lê Văn Minh', N'Phòng lưu trú 3 ngày điều hòa'),
(373, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(373, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(374, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(374, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(375, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(375, 6, 1, 400000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(376, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(376, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(377, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(377, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(378, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(378, 9, 1, 250000.00, 0.00, 250000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(379, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(379, 17, 1, 60000.00, 0.00, 60000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(380, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(380, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(381, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(381, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(382, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(382, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(383, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(383, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(384, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(384, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(385, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(385, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(386, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(386, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(387, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(387, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(388, 10, 3, 200000.00, 0.00, 600000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 3 ngày điều hòa'),
(389, 10, 4, 200000.00, 0.00, 800000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 4 ngày điều hòa'),
(390, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(390, 5, 1, 280000.00, 0.00, 280000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(391, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(391, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(392, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(392, 14, 1, 260000.00, 0.00, 260000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(393, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(393, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(394, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(394, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(395, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(395, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(396, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(396, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(397, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(397, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(398, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(398, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(399, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(399, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(400, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(400, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(401, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(401, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(402, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(402, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(403, 10, 4, 200000.00, 0.00, 800000.00, N'Phạm Văn Tài', N'Phòng lưu trú 4 ngày điều hòa'),
(404, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(404, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(405, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(405, 17, 1, 60000.00, 0.00, 60000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(406, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(406, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(407, 11, 2, 350000.00, 0.00, 700000.00, N'Lê Văn Minh', N'Phòng lưu trú 2 ngày điều hòa'),
(408, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(408, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(409, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(409, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(410, 10, 3, 200000.00, 0.00, 600000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 3 ngày điều hòa'),
(411, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(411, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(412, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(412, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(413, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(413, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(414, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(414, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(415, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(415, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(416, 11, 3, 350000.00, 0.00, 1050000.00, N'Trần Thị Mỹ Duyên', N'Phòng lưu trú 3 ngày điều hòa'),
(417, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(417, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(418, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(418, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(419, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(419, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(420, 10, 4, 200000.00, 0.00, 800000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 4 ngày điều hòa'),
(421, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(421, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(422, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(422, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(423, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(423, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(424, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(424, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(425, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(425, 14, 1, 260000.00, 0.00, 260000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(426, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(426, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(427, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(427, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(428, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(428, 14, 1, 260000.00, 0.00, 260000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(429, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(429, 15, 1, 240000.00, 0.00, 240000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(430, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(430, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(431, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(431, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(432, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(432, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(433, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(433, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(434, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(434, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(435, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(435, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(436, 11, 4, 350000.00, 0.00, 1400000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 4 ngày điều hòa'),
(437, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(437, 9, 1, 250000.00, 0.00, 250000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(438, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(438, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(439, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(439, 14, 1, 260000.00, 0.00, 260000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(440, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(440, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(441, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(441, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(442, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(442, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(443, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(443, 5, 1, 280000.00, 0.00, 280000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(444, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(444, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(445, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(445, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(446, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(446, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(447, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(447, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(448, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(448, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(449, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(449, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(450, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(450, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(451, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(451, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(452, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(452, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(453, 10, 2, 200000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Phòng lưu trú 2 ngày điều hòa'),
(454, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(454, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(455, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(455, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(456, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(456, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(457, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(457, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(458, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(458, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(459, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(459, 6, 1, 400000.00, 0.00, 400000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(460, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(460, 17, 1, 60000.00, 0.00, 60000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(461, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(461, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(462, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(462, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(463, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(463, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(464, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(464, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(465, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(465, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(466, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(466, 6, 1, 400000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(467, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(467, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(468, 10, 4, 200000.00, 0.00, 800000.00, N'Phạm Văn Tài', N'Phòng lưu trú 4 ngày điều hòa'),
(469, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(469, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(470, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(470, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(471, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(471, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(472, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(472, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(473, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(473, 17, 1, 60000.00, 0.00, 60000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(474, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(474, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(475, 10, 3, 200000.00, 0.00, 600000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 3 ngày điều hòa'),
(476, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(476, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(477, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(477, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(478, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(478, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(479, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(479, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(480, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(480, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(481, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(481, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(482, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(482, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(483, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(483, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(484, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(484, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(485, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(485, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(486, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(486, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(487, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(487, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(488, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(488, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(489, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(489, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(490, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(490, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(491, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(491, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(492, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(492, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(493, 11, 3, 350000.00, 0.00, 1050000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 3 ngày điều hòa'),
(494, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(494, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(495, 10, 3, 200000.00, 0.00, 600000.00, N'Phạm Văn Tài', N'Phòng lưu trú 3 ngày điều hòa'),
(496, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(496, 17, 1, 60000.00, 0.00, 60000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(497, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(497, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(498, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(498, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(499, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(499, 17, 1, 60000.00, 0.00, 60000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(500, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(500, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(501, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(501, 6, 1, 400000.00, 0.00, 400000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(502, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(502, 15, 1, 240000.00, 0.00, 240000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(503, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(503, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(504, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(504, 5, 1, 280000.00, 0.00, 280000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(505, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(505, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(506, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(506, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(507, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(507, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(508, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(508, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(509, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(509, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(510, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(510, 15, 1, 240000.00, 0.00, 240000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(511, 10, 2, 200000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Phòng lưu trú 2 ngày điều hòa'),
(512, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(512, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(513, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(513, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(514, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(514, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(515, 10, 2, 200000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Phòng lưu trú 2 ngày điều hòa'),
(516, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(516, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(517, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(517, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(518, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(518, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(519, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(519, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(520, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(520, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(521, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(521, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(522, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(522, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(523, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(523, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(524, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(524, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(525, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(525, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(526, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(526, 17, 1, 60000.00, 0.00, 60000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(527, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(527, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(528, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(528, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(529, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(529, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(530, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(530, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(531, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(531, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(532, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(532, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(533, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(533, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(534, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(534, 14, 1, 260000.00, 0.00, 260000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(535, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(535, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(536, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(536, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(537, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(537, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(538, 10, 4, 200000.00, 0.00, 800000.00, N'Phạm Văn Tài', N'Phòng lưu trú 4 ngày điều hòa'),
(539, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(539, 6, 1, 400000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(540, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(540, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(541, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(541, 14, 1, 260000.00, 0.00, 260000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(542, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(542, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(543, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(543, 17, 1, 60000.00, 0.00, 60000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(544, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(544, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(545, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(545, 5, 1, 280000.00, 0.00, 280000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(546, 11, 3, 350000.00, 0.00, 1050000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 3 ngày điều hòa'),
(547, 11, 3, 350000.00, 0.00, 1050000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 3 ngày điều hòa'),
(548, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(548, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(549, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(549, 17, 1, 60000.00, 0.00, 60000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(550, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(550, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(551, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(551, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(552, 11, 2, 350000.00, 0.00, 700000.00, N'Bùi Ngọc Thúy', N'Phòng lưu trú 2 ngày điều hòa'),
(553, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(553, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(554, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(554, 17, 1, 60000.00, 0.00, 60000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(555, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(555, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(556, 11, 2, 350000.00, 0.00, 700000.00, N'Trần Thị Mỹ Duyên', N'Phòng lưu trú 2 ngày điều hòa'),
(557, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(557, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(558, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(558, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(559, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(559, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(560, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(560, 6, 1, 400000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(561, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(561, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(562, 10, 2, 200000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Phòng lưu trú 2 ngày điều hòa'),
(563, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(563, 17, 1, 60000.00, 0.00, 60000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(564, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(564, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(565, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(565, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(566, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(566, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(567, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(567, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(568, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(568, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(569, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(569, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(570, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(570, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(571, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(571, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(572, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(572, 14, 1, 260000.00, 0.00, 260000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(573, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(573, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(574, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(574, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(575, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(575, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(576, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(576, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(577, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(577, 5, 1, 280000.00, 0.00, 280000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(578, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(578, 17, 1, 60000.00, 0.00, 60000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(579, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(579, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(580, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(580, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(581, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(581, 5, 1, 280000.00, 0.00, 280000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(582, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(582, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(583, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(583, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(584, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(584, 5, 1, 280000.00, 0.00, 280000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(585, 10, 2, 200000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Phòng lưu trú 2 ngày điều hòa'),
(586, 10, 3, 200000.00, 0.00, 600000.00, N'Phạm Văn Tài', N'Phòng lưu trú 3 ngày điều hòa'),
(587, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(587, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(588, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(588, 14, 1, 260000.00, 0.00, 260000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(589, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(589, 14, 1, 260000.00, 0.00, 260000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(590, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(590, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(591, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(591, 17, 1, 60000.00, 0.00, 60000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(592, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(592, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(593, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(593, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(594, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(594, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(595, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(595, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(596, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(596, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(597, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(597, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(598, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(598, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(599, 10, 3, 200000.00, 0.00, 600000.00, N'Phạm Văn Tài', N'Phòng lưu trú 3 ngày điều hòa'),
(600, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(600, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(601, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(601, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(602, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(602, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(603, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(603, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(604, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(604, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(605, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(605, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(606, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(606, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(607, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(607, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(608, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(608, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(609, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(609, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(610, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(610, 5, 1, 280000.00, 0.00, 280000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(611, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(611, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(612, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(612, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(613, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(613, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(614, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(614, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(615, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(615, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(616, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(616, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(617, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(617, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(618, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(618, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(619, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(619, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(620, 10, 2, 200000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Phòng lưu trú 2 ngày điều hòa'),
(621, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(621, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(622, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(622, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(623, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(623, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(624, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(624, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(625, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(625, 14, 1, 260000.00, 0.00, 260000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(626, 10, 2, 200000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Phòng lưu trú 2 ngày điều hòa'),
(627, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(627, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(628, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(628, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(629, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(629, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(630, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(630, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(631, 10, 4, 200000.00, 0.00, 800000.00, N'Bùi Ngọc Thúy', N'Phòng lưu trú 4 ngày điều hòa'),
(632, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(632, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(633, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(633, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(634, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(634, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(635, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(635, 14, 1, 260000.00, 0.00, 260000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(636, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(636, 14, 1, 260000.00, 0.00, 260000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(637, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(637, 5, 1, 280000.00, 0.00, 280000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(638, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(638, 15, 1, 240000.00, 0.00, 240000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(639, 11, 4, 350000.00, 0.00, 1400000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 4 ngày điều hòa'),
(640, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(640, 6, 1, 400000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(641, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(641, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(642, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(642, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(643, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(643, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(644, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(644, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(645, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(645, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(646, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(646, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(647, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(647, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(648, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(648, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(649, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(649, 5, 1, 280000.00, 0.00, 280000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(650, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(650, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(651, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(651, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(652, 11, 2, 350000.00, 0.00, 700000.00, N'Phạm Văn Tài', N'Phòng lưu trú 2 ngày điều hòa'),
(653, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(653, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(654, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(654, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(655, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(655, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(656, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(656, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(657, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(657, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(658, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(658, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(659, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(659, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(660, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(660, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(661, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(661, 9, 1, 250000.00, 0.00, 250000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(662, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(662, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(663, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(663, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(664, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(664, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(665, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(665, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(666, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(666, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(667, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(667, 14, 1, 260000.00, 0.00, 260000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(668, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(668, 5, 1, 280000.00, 0.00, 280000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(669, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(669, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(670, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(670, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(671, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(671, 17, 1, 60000.00, 0.00, 60000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(672, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(672, 6, 1, 400000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(673, 10, 2, 200000.00, 0.00, 400000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 2 ngày điều hòa'),
(674, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(674, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(675, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(675, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(676, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(676, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(677, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(677, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(678, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(678, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(679, 11, 2, 350000.00, 0.00, 700000.00, N'Bùi Ngọc Thúy', N'Phòng lưu trú 2 ngày điều hòa'),
(680, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(680, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(681, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(681, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(682, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(682, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(683, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(683, 6, 1, 400000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(684, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(684, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(685, 10, 4, 200000.00, 0.00, 800000.00, N'Phạm Văn Tài', N'Phòng lưu trú 4 ngày điều hòa'),
(686, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(686, 15, 1, 240000.00, 0.00, 240000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(687, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(687, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(688, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(688, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(689, 10, 3, 200000.00, 0.00, 600000.00, N'Trần Thị Mỹ Duyên', N'Phòng lưu trú 3 ngày điều hòa'),
(690, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(690, 17, 1, 60000.00, 0.00, 60000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(691, 11, 3, 350000.00, 0.00, 1050000.00, N'Lê Văn Minh', N'Phòng lưu trú 3 ngày điều hòa'),
(692, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(692, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(693, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(693, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(694, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(694, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(695, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(695, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(696, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(696, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(697, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(697, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(698, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(698, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(699, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(699, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(700, 10, 2, 200000.00, 0.00, 400000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 2 ngày điều hòa'),
(701, 10, 3, 200000.00, 0.00, 600000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 3 ngày điều hòa'),
(702, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(702, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(703, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(703, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(704, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(704, 17, 1, 60000.00, 0.00, 60000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(705, 11, 3, 350000.00, 0.00, 1050000.00, N'Lê Văn Minh', N'Phòng lưu trú 3 ngày điều hòa'),
(706, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(706, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(707, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(707, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(708, 10, 3, 200000.00, 0.00, 600000.00, N'Trần Thị Mỹ Duyên', N'Phòng lưu trú 3 ngày điều hòa'),
(709, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(709, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(710, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(710, 17, 1, 60000.00, 0.00, 60000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(711, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(711, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(712, 11, 3, 350000.00, 0.00, 1050000.00, N'Phạm Văn Tài', N'Phòng lưu trú 3 ngày điều hòa'),
(713, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(713, 6, 1, 400000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(714, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(714, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(715, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(715, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(716, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(716, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(717, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(717, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(718, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(718, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(719, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(719, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(720, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(720, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(721, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(721, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(722, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(722, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(723, 4, 1, 180000.00, 0.00, 180000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(723, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(724, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(724, 15, 1, 240000.00, 0.00, 240000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(725, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(725, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(726, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Dịch vụ hoàn tất'),
(727, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(727, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(728, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(728, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(729, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(729, 17, 1, 60000.00, 0.00, 60000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(730, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(730, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(731, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(731, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(732, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(732, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(733, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(733, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(734, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Dịch vụ hoàn tất'),
(735, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Dịch vụ hoàn tất'),
(736, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(736, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(737, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(737, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(738, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(738, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(739, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sấy hoàn tất'),
(740, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Đang cắt tỉa'),
(741, 10, 2, 200000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Phòng lưu trú 2 ngày điều hòa'),
(742, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(742, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(743, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(743, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(744, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(744, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(745, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(745, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(746, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(746, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(747, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(747, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(748, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(748, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(749, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(749, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(750, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(750, 17, 1, 60000.00, 0.00, 60000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(751, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(751, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(752, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(752, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(753, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(753, 14, 1, 260000.00, 0.00, 260000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(754, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(754, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(755, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(755, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(756, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(756, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(757, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(757, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(758, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(758, 6, 1, 400000.00, 0.00, 400000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(759, 10, 3, 200000.00, 0.00, 600000.00, N'Bác sĩ Ngô Minh Nhật', N'Phòng lưu trú 3 ngày điều hòa'),
(760, 11, 4, 350000.00, 0.00, 1400000.00, N'Trần Thị Mỹ Duyên', N'Phòng lưu trú 4 ngày điều hòa'),
(761, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(761, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(762, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(762, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(763, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(763, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(764, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(764, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(765, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(765, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(766, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(766, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(767, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(767, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(768, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(768, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(769, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(769, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(770, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(770, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(771, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(771, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(772, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(772, 9, 1, 250000.00, 0.00, 250000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(773, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(773, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(774, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(774, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(775, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(775, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(776, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(776, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(777, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(777, 14, 1, 260000.00, 0.00, 260000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(778, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(778, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(779, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(779, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(780, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(780, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(781, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(781, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(782, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(782, 5, 1, 280000.00, 0.00, 280000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(783, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(783, 17, 1, 60000.00, 0.00, 60000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(784, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(784, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(785, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(785, 15, 1, 240000.00, 0.00, 240000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(786, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(786, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(787, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(787, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(788, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(788, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(789, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(789, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(790, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(790, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(791, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(791, 5, 1, 280000.00, 0.00, 280000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(792, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(792, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(793, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(793, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(794, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(794, 5, 1, 280000.00, 0.00, 280000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(795, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(795, 17, 1, 60000.00, 0.00, 60000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(796, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(796, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(797, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(797, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(798, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(798, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(799, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(799, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(800, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(800, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(801, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(801, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(802, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(802, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(803, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(803, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(804, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(804, 9, 1, 250000.00, 0.00, 250000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(805, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(805, 17, 1, 60000.00, 0.00, 60000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(806, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(806, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(807, 1, 1, 150000.00, 0.00, 150000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(807, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(808, 10, 4, 200000.00, 0.00, 800000.00, N'Phạm Văn Tài', N'Phòng lưu trú 4 ngày điều hòa'),
(809, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(809, 6, 1, 400000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(810, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(810, 14, 1, 260000.00, 0.00, 260000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(811, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(811, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(812, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(812, 6, 1, 400000.00, 0.00, 400000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(813, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(813, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(814, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(814, 9, 1, 250000.00, 0.00, 250000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(815, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(815, 14, 1, 260000.00, 0.00, 260000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(816, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(816, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(817, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(817, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(818, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(818, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(819, 1, 1, 150000.00, 0.00, 150000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(819, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(820, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(820, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(821, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(821, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(822, 11, 2, 350000.00, 0.00, 700000.00, N'Lê Văn Minh', N'Phòng lưu trú 2 ngày điều hòa'),
(823, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm sạch sâu'),
(823, 9, 1, 250000.00, 0.00, 250000.00, N'Phạm Văn Tài', N'Cắt tỉa tạo dáng'),
(824, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(824, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(825, 13, 1, 120000.00, 0.00, 120000.00, N'Lê Văn Minh', N'Khám sức khỏe tổng quát'),
(825, 15, 1, 240000.00, 0.00, 240000.00, N'Lê Văn Minh', N'Tiêm vắc xin / sổ giun'),
(826, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(826, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(827, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(827, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(828, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(828, 6, 1, 400000.00, 0.00, 400000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(829, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(829, 14, 1, 260000.00, 0.00, 260000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(830, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ An Thành', N'Khám sức khỏe tổng quát'),
(830, 15, 1, 240000.00, 0.00, 240000.00, N'Bác sĩ An Thành', N'Tiêm vắc xin / sổ giun'),
(831, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(831, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(832, 4, 1, 180000.00, 0.00, 180000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(832, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(833, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(833, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(834, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(834, 17, 1, 60000.00, 0.00, 60000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(835, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(835, 15, 1, 240000.00, 0.00, 240000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(836, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(836, 17, 1, 60000.00, 0.00, 60000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(837, 1, 1, 150000.00, 0.00, 150000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(837, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(838, 13, 1, 120000.00, 0.00, 120000.00, N'Bùi Ngọc Thúy', N'Khám sức khỏe tổng quát'),
(838, 17, 1, 60000.00, 0.00, 60000.00, N'Bùi Ngọc Thúy', N'Tiêm vắc xin / sổ giun'),
(839, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm sạch sâu'),
(839, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng'),
(840, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(840, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(841, 4, 1, 180000.00, 0.00, 180000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(841, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(842, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(842, 5, 1, 280000.00, 0.00, 280000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(843, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm sạch sâu'),
(843, 9, 1, 250000.00, 0.00, 250000.00, N'Trần Thị Mỹ Duyên', N'Cắt tỉa tạo dáng'),
(844, 2, 1, 220000.00, 0.00, 220000.00, N'Phạm Văn Tài', N'Tắm 2 nước thơm'),
(844, 7, 1, 100000.00, 0.00, 100000.00, N'Phạm Văn Tài', N'Vệ sinh tai & móng'),
(845, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(845, 6, 1, 400000.00, 0.00, 400000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(846, 4, 1, 180000.00, 0.00, 180000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm');
INSERT INTO [dbo].[tblChiTietDichVuChamSoc] ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet]) VALUES
(846, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(847, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(847, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(848, 4, 1, 180000.00, 0.00, 180000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(848, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(849, 13, 1, 120000.00, 0.00, 120000.00, N'Bác sĩ Ngô Minh Nhật', N'Khám sức khỏe tổng quát'),
(849, 17, 1, 60000.00, 0.00, 60000.00, N'Bác sĩ Ngô Minh Nhật', N'Tiêm vắc xin / sổ giun'),
(850, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(850, 17, 1, 60000.00, 0.00, 60000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(851, 2, 1, 220000.00, 0.00, 220000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(851, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(852, 1, 1, 150000.00, 0.00, 150000.00, N'Lê Văn Minh', N'Tắm 2 nước thơm'),
(852, 7, 1, 100000.00, 0.00, 100000.00, N'Lê Văn Minh', N'Vệ sinh tai & móng'),
(853, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(853, 14, 1, 260000.00, 0.00, 260000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(854, 13, 1, 120000.00, 0.00, 120000.00, N'Trần Thị Mỹ Duyên', N'Khám sức khỏe tổng quát'),
(854, 17, 1, 60000.00, 0.00, 60000.00, N'Trần Thị Mỹ Duyên', N'Tiêm vắc xin / sổ giun'),
(855, 10, 2, 200000.00, 0.00, 400000.00, N'Trần Thị Mỹ Duyên', N'Phòng lưu trú 2 ngày điều hòa'),
(856, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(856, 17, 1, 60000.00, 0.00, 60000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(857, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(857, 14, 1, 260000.00, 0.00, 260000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(858, 1, 1, 150000.00, 0.00, 150000.00, N'Trần Thị Mỹ Duyên', N'Tắm 2 nước thơm'),
(858, 7, 1, 100000.00, 0.00, 100000.00, N'Trần Thị Mỹ Duyên', N'Vệ sinh tai & móng'),
(859, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm sạch sâu'),
(859, 5, 1, 280000.00, 0.00, 280000.00, N'Bác sĩ Ngô Minh Nhật', N'Cắt tỉa tạo dáng'),
(860, 2, 1, 220000.00, 0.00, 220000.00, N'Lê Văn Minh', N'Tắm sạch sâu'),
(860, 5, 1, 280000.00, 0.00, 280000.00, N'Lê Văn Minh', N'Cắt tỉa tạo dáng'),
(861, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm 2 nước thơm'),
(861, 7, 1, 100000.00, 0.00, 100000.00, N'Bùi Ngọc Thúy', N'Vệ sinh tai & móng'),
(862, 11, 4, 350000.00, 0.00, 1400000.00, N'Lê Văn Minh', N'Phòng lưu trú 4 ngày điều hòa'),
(863, 2, 1, 220000.00, 0.00, 220000.00, N'Bùi Ngọc Thúy', N'Tắm sạch sâu'),
(863, 5, 1, 280000.00, 0.00, 280000.00, N'Bùi Ngọc Thúy', N'Cắt tỉa tạo dáng'),
(864, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ Ngô Minh Nhật', N'Tắm 2 nước thơm'),
(864, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ Ngô Minh Nhật', N'Vệ sinh tai & móng'),
(865, 2, 1, 220000.00, 0.00, 220000.00, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(865, 7, 1, 100000.00, 0.00, 100000.00, N'Bác sĩ An Thành', N'Vệ sinh tai & móng'),
(866, 13, 1, 120000.00, 0.00, 120000.00, N'Phạm Văn Tài', N'Khám sức khỏe tổng quát'),
(866, 15, 1, 240000.00, 0.00, 240000.00, N'Phạm Văn Tài', N'Tiêm vắc xin / sổ giun'),
(867, 11, 2, 350000.00, 0.00, 700000.00, N'Bác sĩ An Thành', N'Phòng lưu trú 2 ngày điều hòa');
GO

-- 7. DỮ LIỆU MẪU: ĐẶT LỊCH HẸN CHĂM SÓC (tblLichHenChamSoc)
INSERT INTO [dbo].[tblLichHenChamSoc]
([MaChuNuoi], [MaThuCung], [MaDVCS], [NgayHen], [GioHen], [GhiChuYeuCau], [TrangThai])
VALUES
(1, 1, 5, CAST(GETDATE() AS DATE), '09:00:00', N'Cắt tỉa mặt gấu Teddy định kỳ', N'Đã xác nhận'),
(2, 3, 2, CAST(GETDATE() AS DATE), '10:30:00', N'Tắm khử mùi và vắt tuyến hôi', N'Đã xác nhận'),
(3, 4, 9, DATEADD(DAY, 1, CAST(GETDATE() AS DATE)), '14:00:00', N'Gỡ rối lông đuôi và tai', N'Chờ xác nhận'),
(5, 6, 4, DATEADD(DAY, 1, CAST(GETDATE() AS DATE)), '15:30:00', N'Tắm sấy dưỡng lông cho mèo', N'Chờ xác nhận'),
(6, 8, 1, DATEADD(DAY, 2, CAST(GETDATE() AS DATE)), '09:00:00', N'Tắm sấy và vệ sinh tai móng', N'Chờ xác nhận'),
(8, 10, 18, DATEADD(DAY, 2, CAST(GETDATE() AS DATE)), '11:00:00', N'Lấy cao răng siêu âm', N'Đã xác nhận'),
(9, 11, 4, DATEADD(DAY, 3, CAST(GETDATE() AS DATE)), '14:30:00', N'Tắm dưỡng ẩm cho mèo Sphynx', N'Chờ xác nhận'),
(11, 13, 10, DATEADD(DAY, 5, CAST(GETDATE() AS DATE)), '08:00:00', N'Gửi khách sạn 5 ngày dịp lễ', N'Đã xác nhận'),
(12, 14, 5, DATEADD(DAY, 6, CAST(GETDATE() AS DATE)), '10:00:00', N'Cắt tỉa tạo kiểu Poodle xinh', N'Chờ xác nhận'),
(13, 15, 3, DATEADD(DAY, 7, CAST(GETDATE() AS DATE)), '09:30:00', N'Tắm sấy chuyên sâu Samoyed', N'Chờ xác nhận');
GO

-- 8. DỮ LIỆU MẪU: NHẬT KÝ CHĂM SÓC (tblNhatKyChamSoc)
INSERT INTO [dbo].[tblNhatKyChamSoc] ([MaPhieuDV], [ThoiGian], [NhanVienThucHien], [BuocThucHien], [TinhTrangThuCung], [HinhAnhNhatKy]) VALUES
(1, '2026-01-05 08:45:00', N'Bác sĩ An Thành', N'Kiểm tra da và chải tơi lông trước khi tắm', N'Bé ngoan, không cắn, da khỏe không ve rận', N'nhatky_1_1.jpg'),
(1, '2026-01-05 09:15:00', N'Bác sĩ An Thành', N'Tắm thảo dược 2 nước và xả dầu xả dưỡng ẩm', N'Rất thích thú khi được xoa bóp tạo bọt', N'nhatky_1_2.jpg'),
(1, '2026-01-05 09:50:00', N'Bác sĩ An Thành', N'Sấy khô hoàn toàn và vệ sinh tai, cắt móng', N'Hơi giật mình tiếng máy sấy nhưng hợp tác tốt', N'nhatky_1_3.jpg'),
(1, '2026-01-05 10:45:00', N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng đầu tròn Teddy bear hoàn chỉnh', N'Đứng ngoan trên bàn tỉa, thành phẩm rất đẹp', N'nhatky_1_4.jpg'),
(3, '2026-01-08 09:15:00', N'Bác sĩ An Thành', N'Tắm nước ấm và vắt tuyến hôi hậu môn', N'Vắt ra dịch màu vàng sẫm có mùi hôi đặc trưng, sau đó rửa sạch', N'nhatky_3_1.jpg'),
(3, '2026-01-08 10:00:00', N'Bác sĩ An Thành', N'Sấy phồng lông và tỉa bo mông hình trái tim', N'Chó Corgi rất phấn khích, mông trái tim cực kỳ nét', N'nhatky_3_2.jpg'),
(15, '2026-02-10 10:00:00', N'Lê Văn Minh', N'Tiếp nhận vào phòng khách sạn Deluxe số 03', N'Uống nước đầy đủ, khám phá phòng mới vui vẻ', N'hotel_checkin_husky.jpg'),
(15, '2026-02-10 17:00:00', N'Lê Văn Minh', N'Cho ăn bữa tối hạt Taste of the Wild và pate', N'Ăn hết sạch 1 tô to trong 5 phút, tiêu hóa tốt', N'hotel_meal_husky.jpg'),
(15, '2026-02-11 07:30:00', N'Lê Văn Minh', N'Dắt đi dạo sân chơi ngoài trời', N'Đi vệ sinh phân khuôn đẹp, chạy nhảy năng động', N'hotel_walk_husky.jpg');
GO

-- ==================================================================================
-- PHẦN VIEWS - HỖ TRỢ TRA CỨU & BÁO CÁO THỐNG KÊ
-- ==================================================================================

-- 1. View xem thông tin chi tiết hồ sơ thú cưng kèm chủ nuôi
IF OBJECT_ID(N'[dbo].[vw_HoSoThuCungToanDien]', N'V') IS NOT NULL
    DROP VIEW [dbo].[vw_HoSoThuCungToanDien];
GO
CREATE VIEW [dbo].[vw_HoSoThuCungToanDien]
AS
SELECT 
    p.MaThuCung,
    p.TenThuCung,
    p.LoaiThuCung,
    p.GiongLoai,
    p.GioiTinh,
    CASE WHEN p.TrietSan = 1 THEN N'Đã triệt sản' ELSE N'Chưa triệt sản' END AS TinhTrangTrietSan,
    p.NgaySinh,
    p.TuoiThang,
    p.MauSac,
    p.CanNang,
    p.SoMicrochip,
    p.TinhTrangSucKhoeHienTai,
    p.LichSuTiemChung,
    p.TrangThai AS TrangThaiPet,
    c.MaChuNuoi,
    c.HoTenChuNuoi,
    c.SoDienThoai,
    c.DiaChi,
    c.LoaiChuNuoi,
    c.SoDienThoaiKhanCap,
    (SELECT COUNT(*) FROM dbo.tblPhieuDichVuChamSoc WHERE MaThuCung = p.MaThuCung) AS SoLanDungDichVu,
    (SELECT MAX(NgayTiepNhan) FROM dbo.tblPhieuDichVuChamSoc WHERE MaThuCung = p.MaThuCung) AS LanDungDichVuGanNhat
FROM dbo.tblHoSoThuCung p
INNER JOIN dbo.tblChuNuoi c ON p.MaChuNuoi = c.MaChuNuoi;
GO

-- 2. View theo dõi danh sách phiếu chăm sóc dịch vụ tổng hợp
IF OBJECT_ID(N'[dbo].[vw_DanhSachPhieuDichVuChiTiet]', N'V') IS NOT NULL
    DROP VIEW [dbo].[vw_DanhSachPhieuDichVuChiTiet];
GO
CREATE VIEW [dbo].[vw_DanhSachPhieuDichVuChiTiet]
AS
SELECT 
    pdv.MaPhieuDV,
    pdv.SoPhieu,
    pdv.NgayTiepNhan,
    pdv.NgayHenTra,
    pdv.NgayTraThucTe,
    p.TenThuCung,
    p.LoaiThuCung,
    p.GiongLoai,
    c.HoTenChuNuoi,
    c.SoDienThoai AS SDTChuNuoi,
    nv_tn.TenNV AS NhanVienTiepNhan,
    nv_th.TenNV AS KTV_ThucHien,
    pdv.CanNangTiepNhan,
    pdv.TinhTrangBanDau,
    pdv.YeuCauCuaChuNuoi,
    pdv.KetQuaChamSoc,
    pdv.TongTien,
    pdv.TienGiamGia,
    pdv.ThanhToan,
    pdv.HinhThucThanhToan,
    pdv.TrangThaiThanhToan,
    pdv.TrangThaiDichVu
FROM dbo.tblPhieuDichVuChamSoc pdv
INNER JOIN dbo.tblHoSoThuCung p ON pdv.MaThuCung = p.MaThuCung
INNER JOIN dbo.tblChuNuoi c ON pdv.MaChuNuoi = c.MaChuNuoi
LEFT JOIN dbo.tblNhanVien nv_tn ON pdv.MaNVTiepNhan = nv_tn.MaNV
LEFT JOIN dbo.tblNhanVien nv_th ON pdv.MaNVThucHien = nv_th.MaNV;
GO

-- 3. View thống kê doanh thu và tần suất sử dụng từng dịch vụ chăm sóc
IF OBJECT_ID(N'[dbo].[vw_ThongKeDoanhThuDichVuCS]', N'V') IS NOT NULL
    DROP VIEW [dbo].[vw_ThongKeDoanhThuDichVuCS];
GO
CREATE VIEW [dbo].[vw_ThongKeDoanhThuDichVuCS]
AS
SELECT 
    dv.MaDVCS,
    dv.TenDichVu,
    dv.NhomDichVu,
    dv.GiaDichVu AS GiaHienHanh,
    COUNT(ct.MaChiTiet) AS SoLuotThucHien,
    ISNULL(SUM(ct.SoLuong), 0) AS TongSoLuong,
    ISNULL(SUM(ct.ThanhTien), 0) AS TongDoanhThu
FROM dbo.tblDichVuChamSoc dv
LEFT JOIN dbo.tblChiTietDichVuChamSoc ct ON dv.MaDVCS = ct.MaDVCS
GROUP BY dv.MaDVCS, dv.TenDichVu, dv.NhomDichVu, dv.GiaDichVu;
GO

-- 4. View xem lịch hẹn chăm sóc sắp tới
IF OBJECT_ID(N'[dbo].[vw_LichHenSapToi]', N'V') IS NOT NULL
    DROP VIEW [dbo].[vw_LichHenSapToi];
GO
CREATE VIEW [dbo].[vw_LichHenSapToi]
AS
SELECT 
    lh.MaLichHen,
    lh.NgayHen,
    lh.GioHen,
    c.HoTenChuNuoi,
    c.SoDienThoai,
    p.TenThuCung,
    p.GiongLoai,
    dv.TenDichVu,
    dv.NhomDichVu,
    dv.GiaDichVu,
    lh.GhiChuYeuCau,
    lh.TrangThai
FROM dbo.tblLichHenChamSoc lh
INNER JOIN dbo.tblChuNuoi c ON lh.MaChuNuoi = c.MaChuNuoi
INNER JOIN dbo.tblHoSoThuCung p ON lh.MaThuCung = p.MaThuCung
INNER JOIN dbo.tblDichVuChamSoc dv ON lh.MaDVCS = dv.MaDVCS;
GO


-- ==================================================================================
-- PHẦN TRIGGERS - TỰ ĐỘNG HÓA & KIỂM TRA TÍNH TOÀN VẸN NGHIỆP VỤ
-- ==================================================================================

-- 1. Trigger tự động tính lại TongTien và ThanhToan trong tblPhieuDichVuChamSoc khi thêm/sửa/xóa chi tiết
IF OBJECT_ID(N'[dbo].[trg_CapNhatTongTienPhieuDVCS]', N'TR') IS NOT NULL
    DROP TRIGGER [dbo].[trg_CapNhatTongTienPhieuDVCS];
GO
CREATE TRIGGER [dbo].[trg_CapNhatTongTienPhieuDVCS]
ON [dbo].[tblChiTietDichVuChamSoc]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy danh sách các MaPhieuDV bị tác động
    DECLARE @AffectedPhieu TABLE (MaPhieuDV INT);

    INSERT INTO @AffectedPhieu (MaPhieuDV)
    SELECT DISTINCT MaPhieuDV FROM inserted
    UNION
    SELECT DISTINCT MaPhieuDV FROM deleted;

    -- Cập nhật lại TongTien và ThanhToan
    UPDATE p
    SET 
        TongTien = ISNULL(t.TongChiTiet, 0),
        ThanhToan = CASE 
                        WHEN ISNULL(t.TongChiTiet, 0) - ISNULL(p.TienGiamGia, 0) < 0 THEN 0 
                        ELSE ISNULL(t.TongChiTiet, 0) - ISNULL(p.TienGiamGia, 0) 
                    END
    FROM dbo.tblPhieuDichVuChamSoc p
    INNER JOIN @AffectedPhieu a ON p.MaPhieuDV = a.MaPhieuDV
    OUTER APPLY (
        SELECT SUM(ThanhTien) AS TongChiTiet 
        FROM dbo.tblChiTietDichVuChamSoc 
        WHERE MaPhieuDV = p.MaPhieuDV
    ) t;
END;
GO

-- 2. Trigger kiểm tra ngày trả thú cưng không thể nhỏ hơn ngày tiếp nhận
IF OBJECT_ID(N'[dbo].[trg_KiemTraNgayTraThucTe]', N'TR') IS NOT NULL
    DROP TRIGGER [dbo].[trg_KiemTraNgayTraThucTe];
GO
CREATE TRIGGER [dbo].[trg_KiemTraNgayTraThucTe]
ON [dbo].[tblPhieuDichVuChamSoc]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM inserted 
        WHERE NgayHenTra IS NOT NULL AND NgayHenTra < NgayTiepNhan
    )
    BEGIN
        RAISERROR(N'Lỗi: Ngày hẹn trả thú cưng không thể trước ngày tiếp nhận!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (
        SELECT 1 FROM inserted 
        WHERE NgayTraThucTe IS NOT NULL AND NgayTraThucTe < NgayTiepNhan
    )
    BEGIN
        RAISERROR(N'Lỗi: Ngày trả thực tế không thể trước ngày tiếp nhận!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO


-- ==================================================================================
-- PHẦN STORED PROCEDURES - NGHIỆP VỤ ĐẦY ĐỦ CHO CẢ 3 CHỨC NĂNG
-- ==================================================================================

-- 1. SP: Thêm mới hồ sơ chủ nuôi
IF OBJECT_ID(N'[dbo].[sp_ThemHoSoChuNuoi]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_ThemHoSoChuNuoi];
GO
CREATE PROCEDURE [dbo].[sp_ThemHoSoChuNuoi]
    @MaKH INT = NULL,
    @HoTenChuNuoi NVARCHAR(100),
    @SoDienThoai VARCHAR(20),
    @Email VARCHAR(100) = NULL,
    @SoCCCD VARCHAR(20) = NULL,
    @DiaChi NVARCHAR(255) = NULL,
    @GioiTinh NVARCHAR(10) = NULL,
    @NgaySinh DATE = NULL,
    @SoDienThoaiKhanCap VARCHAR(20) = NULL,
    @NguoiLienHeKhanCap NVARCHAR(100) = NULL,
    @GhiChu NVARCHAR(500) = NULL,
    @MaChuNuoiMoi INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.tblChuNuoi WHERE SoDienThoai = @SoDienThoai)
    BEGIN
        RAISERROR(N'Số điện thoại chủ nuôi đã tồn tại trên hệ thống!', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.tblChuNuoi 
    ([MaKH], [HoTenChuNuoi], [SoDienThoai], [Email], [SoCCCD], [DiaChi], [GioiTinh], [NgaySinh], [SoDienThoaiKhanCap], [NguoiLienHeKhanCap], [GhiChu])
    VALUES
    (@MaKH, @HoTenChuNuoi, @SoDienThoai, @Email, @SoCCCD, @DiaChi, @GioiTinh, @NgaySinh, @SoDienThoaiKhanCap, @NguoiLienHeKhanCap, @GhiChu);

    SET @MaChuNuoiMoi = SCOPE_IDENTITY();
    SELECT @MaChuNuoiMoi AS MaChuNuoiMoi;
END;
GO

-- 2. SP: Thêm mới hồ sơ thú cưng kèm kiểm tra chủ nuôi
IF OBJECT_ID(N'[dbo].[sp_ThemHoSoThuCung]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_ThemHoSoThuCung];
GO
CREATE PROCEDURE [dbo].[sp_ThemHoSoThuCung]
    @MaChuNuoi INT,
    @TenThuCung NVARCHAR(100),
    @LoaiThuCung NVARCHAR(50),
    @GiongLoai NVARCHAR(100),
    @GioiTinh NVARCHAR(10),
    @TrietSan BIT = 0,
    @NgaySinh DATE = NULL,
    @TuoiThang INT = NULL,
    @MauSac NVARCHAR(50) = NULL,
    @CanNang DECIMAL(5,2) = NULL,
    @DacDiemNhanDang NVARCHAR(255) = NULL,
    @SoMicrochip VARCHAR(50) = NULL,
    @TinhTrangSucKhoe NVARCHAR(MAX) = NULL,
    @TienSuBenhLy NVARCHAR(MAX) = NULL,
    @DiUngThuoc NVARCHAR(MAX) = NULL,
    @HinhAnh NVARCHAR(255) = NULL,
    @GhiChu NVARCHAR(MAX) = NULL,
    @MaThuCungMoi INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.tblChuNuoi WHERE MaChuNuoi = @MaChuNuoi)
    BEGIN
        RAISERROR(N'Không tìm thấy chủ nuôi với mã đã cho!', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.tblHoSoThuCung
    ([MaChuNuoi], [TenThuCung], [LoaiThuCung], [GiongLoai], [GioiTinh], [TrietSan], [NgaySinh], [TuoiThang], [MauSac], [CanNang], [DacDiemNhanDang], [SoMicrochip], [TinhTrangSucKhoeHienTai], [TienSuBenhLy], [DiUngThuocThucAn], [HinhAnh], [GhiChu])
    VALUES
    (@MaChuNuoi, @TenThuCung, @LoaiThuCung, @GiongLoai, @GioiTinh, @TrietSan, @NgaySinh, @TuoiThang, @MauSac, @CanNang, @DacDiemNhanDang, @SoMicrochip, @TinhTrangSucKhoe, @TienSuBenhLy, @DiUngThuoc, @HinhAnh, @GhiChu);

    SET @MaThuCungMoi = SCOPE_IDENTITY();
    SELECT @MaThuCungMoi AS MaThuCungMoi;
END;
GO

-- 3. SP: Lập phiếu tiếp nhận dịch vụ chăm sóc thú cưng
IF OBJECT_ID(N'[dbo].[sp_TaoPhieuDichVuChamSoc]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_TaoPhieuDichVuChamSoc];
GO
CREATE PROCEDURE [dbo].[sp_TaoPhieuDichVuChamSoc]
    @MaThuCung INT,
    @MaNVTiepNhan INT,
    @MaNVThucHien INT = NULL,
    @NgayHenTra DATETIME = NULL,
    @CanNangTiepNhan DECIMAL(5,2) = NULL,
    @TinhTrangBanDau NVARCHAR(MAX) = NULL,
    @YeuCauCuaChuNuoi NVARCHAR(MAX) = NULL,
    @TienGiamGia DECIMAL(18,2) = 0,
    @MaPhieuMoi INT OUTPUT,
    @SoPhieuMoi VARCHAR(30) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaChuNuoi INT;
    SELECT @MaChuNuoi = MaChuNuoi FROM dbo.tblHoSoThuCung WHERE MaThuCung = @MaThuCung;

    IF @MaChuNuoi IS NULL
    BEGIN
        RAISERROR(N'Không tìm thấy thú cưng hợp lệ!', 16, 1);
        RETURN;
    END

    -- Tự sinh mã số phiếu: PDV-yyyyMMdd-xxxxx
    DECLARE @RandomSuffix VARCHAR(5) = RIGHT('00000' + CAST(CAST(RAND() * 10000 AS INT) AS VARCHAR(5)), 4);
    SET @SoPhieuMoi = 'PDV-' + CONVERT(VARCHAR(8), GETDATE(), 112) + '-' + @RandomSuffix;

    INSERT INTO dbo.tblPhieuDichVuChamSoc
    ([SoPhieu], [MaThuCung], [MaChuNuoi], [MaNVTiepNhan], [MaNVThucHien], [NgayTiepNhan], [NgayHenTra], [CanNangTiepNhan], [TinhTrangBanDau], [YeuCauCuaChuNuoi], [TienGiamGia], [TrangThaiDichVu], [TrangThaiThanhToan])
    VALUES
    (@SoPhieuMoi, @MaThuCung, @MaChuNuoi, @MaNVTiepNhan, @MaNVThucHien, GETDATE(), @NgayHenTra, @CanNangTiepNhan, @TinhTrangBanDau, @YeuCauCuaChuNuoi, @TienGiamGia, N'Chờ tiếp nhận', N'Chưa thanh toán');

    SET @MaPhieuMoi = SCOPE_IDENTITY();
    SELECT @MaPhieuMoi AS MaPhieuMoi, @SoPhieuMoi AS SoPhieu;
END;
GO

-- 4. SP: Thêm chi tiết dịch vụ vào phiếu chăm sóc
IF OBJECT_ID(N'[dbo].[sp_ThemChiTietDichVuChamSoc]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_ThemChiTietDichVuChamSoc];
GO
CREATE PROCEDURE [dbo].[sp_ThemChiTietDichVuChamSoc]
    @MaPhieuDV INT,
    @MaDVCS INT,
    @SoLuong INT = 1,
    @PhuPhi DECIMAL(18,2) = 0,
    @NhanVienPhuTrach NVARCHAR(100) = NULL,
    @GhiChuChiTiet NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DonGia DECIMAL(18,2);
    SELECT @DonGia = GiaDichVu FROM dbo.tblDichVuChamSoc WHERE MaDVCS = @MaDVCS;

    IF @DonGia IS NULL
    BEGIN
        RAISERROR(N'Không tìm thấy dịch vụ chăm sóc với mã đã cho!', 16, 1);
        RETURN;
    END

    DECLARE @ThanhTien DECIMAL(18,2) = (@SoLuong * @DonGia) + @PhuPhi;

    INSERT INTO dbo.tblChiTietDichVuChamSoc
    ([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet])
    VALUES
    (@MaPhieuDV, @MaDVCS, @SoLuong, @DonGia, @PhuPhi, @ThanhTien, @NhanVienPhuTrach, @GhiChuChiTiet);

    -- Cập nhật trạng thái phiếu sang Đang thực hiện
    UPDATE dbo.tblPhieuDichVuChamSoc
    SET TrangThaiDichVu = N'Đang thực hiện'
    WHERE MaPhieuDV = @MaPhieuDV AND TrangThaiDichVu = N'Chờ tiếp nhận';

    SELECT N'Thêm chi tiết dịch vụ thành công!' AS ThongBao;
END;
GO

-- 5. SP: Hoàn thành dịch vụ, thanh toán và bàn giao thú cưng
IF OBJECT_ID(N'[dbo].[sp_HoanThanhVaBaoGiaoDichVu]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_HoanThanhVaBaoGiaoDichVu];
GO
CREATE PROCEDURE [dbo].[sp_HoanThanhVaBaoGiaoDichVu]
    @MaPhieuDV INT,
    @KetQuaChamSoc NVARCHAR(MAX),
    @HinhThucThanhToan NVARCHAR(50),
    @DanhGiaCuaChu NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.tblPhieuDichVuChamSoc
    SET 
        NgayTraThucTe = GETDATE(),
        KetQuaChamSoc = @KetQuaChamSoc,
        HinhThucThanhToan = @HinhThucThanhToan,
        TrangThaiThanhToan = N'Đã thanh toán',
        TrangThaiDichVu = N'Đã bàn giao thú cưng',
        DanhGiaCuaChu = @DanhGiaCuaChu
    WHERE MaPhieuDV = @MaPhieuDV;

    -- Tích lũy điểm cho chủ nuôi (100.000 VNĐ = 10 điểm)
    DECLARE @MaChuNuoi INT, @ThanhToan DECIMAL(18,2);
    SELECT @MaChuNuoi = MaChuNuoi, @ThanhToan = ThanhToan FROM dbo.tblPhieuDichVuChamSoc WHERE MaPhieuDV = @MaPhieuDV;

    DECLARE @DiemCong INT = CAST((@ThanhToan / 10000) AS INT);
    UPDATE dbo.tblChuNuoi 
    SET DiemTichLuy = ISNULL(DiemTichLuy, 0) + @DiemCong 
    WHERE MaChuNuoi = @MaChuNuoi;

    SELECT N'Hoàn tất dịch vụ, thanh toán và bàn giao thú cưng thành công!' AS ThongBao;
END;
GO

-- 6. SP: Tra cứu toàn bộ lịch sử chăm sóc và hồ sơ thú cưng
IF OBJECT_ID(N'[dbo].[sp_TraCuuLichSuChamSocThuCung]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_TraCuuLichSuChamSocThuCung];
GO
CREATE PROCEDURE [dbo].[sp_TraCuuLichSuChamSocThuCung]
    @MaThuCung INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Lịch sử dùng dịch vụ
    SELECT 
        p.MaPhieuDV,
        p.SoPhieu,
        p.NgayTiepNhan,
        p.NgayTraThucTe,
        p.TinhTrangBanDau,
        p.KetQuaChamSoc,
        p.TongTien,
        p.ThanhToan,
        p.TrangThaiDichVu,
        p.TrangThaiThanhToan
    FROM dbo.tblPhieuDichVuChamSoc p
    WHERE p.MaThuCung = @MaThuCung
    ORDER BY p.NgayTiepNhan DESC;

    -- Sổ theo dõi sức khỏe
    SELECT 
        s.MaSoSucKhoe,
        s.NgayKiemTra,
        s.CanNang,
        s.ThanNhiet,
        s.LoaiKham,
        s.TenVacXinThuoc,
        s.BacSiPhuTrach,
        s.KetLuanVaDanDo,
        s.NgayHenTaiKham
    FROM dbo.tblSoTheoDoiSucKhoe s
    WHERE s.MaThuCung = @MaThuCung
    ORDER BY s.NgayKiemTra DESC;
END;
GO

-- 7. SP: Báo cáo doanh thu dịch vụ theo tháng và năm
IF OBJECT_ID(N'[dbo].[sp_BaoCaoDoanhThuDichVu]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_BaoCaoDoanhThuDichVu];
GO
CREATE PROCEDURE [dbo].[sp_BaoCaoDoanhThuDichVu]
    @Thang INT,
    @Nam INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        dv.TenDichVu,
        dv.NhomDichVu,
        COUNT(ct.MaChiTiet) AS SoLanSuDung,
        SUM(ct.SoLuong) AS TongSoLuong,
        SUM(ct.ThanhTien) AS DoanhThu
    FROM dbo.tblChiTietDichVuChamSoc ct
    INNER JOIN dbo.tblDichVuChamSoc dv ON ct.MaDVCS = dv.MaDVCS
    INNER JOIN dbo.tblPhieuDichVuChamSoc p ON ct.MaPhieuDV = p.MaPhieuDV
    WHERE MONTH(p.NgayTiepNhan) = @Thang AND YEAR(p.NgayTiepNhan) = @Nam
    GROUP BY dv.TenDichVu, dv.NhomDichVu
    ORDER BY DoanhThu DESC;
END;
GO

IF OBJECT_ID(N'[dbo].[tblNhatKyDieuTri]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tblNhatKyDieuTri](
        [MaNhatKy] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [MaThuCung] [int] NOT NULL,
        [MaBacSi] [int] NOT NULL,
        [NgayKham] [datetime] NULL DEFAULT GETDATE(),
        [ChuanDoan] [nvarchar](500) NULL,
        [PhuongPhapDieuTri] [nvarchar](max) NULL,
        [ThuocSuDung] [nvarchar](max) NULL,
        [CanNang] [decimal](5, 2) NULL,
        [NhietDo] [decimal](4, 1) NULL,
        [TrangThaiSucKhoe] [nvarchar](100) NULL DEFAULT N'Đang điều trị',
        [CanTaiKham] [bit] NULL DEFAULT 0,
        [NgayTaiKham] [datetime] NULL,
        [GhiChu] [nvarchar](max) NULL,
        CONSTRAINT [FK_tblNhatKyDieuTri_tblHoSoThuCung] FOREIGN KEY([MaThuCung]) REFERENCES [dbo].[tblHoSoThuCung] ([MaThuCung]),
        CONSTRAINT [FK_tblNhatKyDieuTri_tblNhanVien] FOREIGN KEY([MaBacSi]) REFERENCES [dbo].[tblNhanVien] ([MaNV])
    );
END
GO

/****** Object:  Table [dbo].[tblThongBao] ******/
IF OBJECT_ID(N'[dbo].[tblThongBao]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tblThongBao](
        [MaThongBao] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [MaKH] [int] NULL,
        [MaNV] [int] NULL,
        [MaThuCung] [int] NULL,
        [LienKet] [nvarchar](255) NULL,
        [TieuDe] [nvarchar](200) NOT NULL,
        [NoiDung] [nvarchar](max) NULL,
        [LoaiThongBao] [nvarchar](50) NULL DEFAULT N'NhacLichTaiKham',
        [NgayTao] [datetime] NULL DEFAULT GETDATE(),
        [NgayHen] [datetime] NULL,
        [TrangThai] [nvarchar](50) NULL DEFAULT N'Chưa đọc',
        CONSTRAINT [FK_tblThongBao_tblKhachHang] FOREIGN KEY([MaKH]) REFERENCES [dbo].[tblKhachHang] ([MaKH]),
        CONSTRAINT [FK_tblThongBao_tblHoSoThuCung] FOREIGN KEY([MaThuCung]) REFERENCES [dbo].[tblHoSoThuCung] ([MaThuCung])
    );
END
GO


-- ====================================================================================================
-- MỤC 8: XỬ LÝ LỖI GIAO DỊCH THANH TOÁN VÀ CÁC LỆNH TỔNG HỢP ROLLUP DỮ LIỆU
-- ====================================================================================================
USE [QL_PetShop]
GO

-- ====================================================================================================
-- TÀI LIỆU VÀ KỊCH BẢN SQL:
-- 1. XỬ LÝ CÁC LỖI HAY XẢY RA TRONG THANH TOÁN (DOUBLE PAYMENT, AMOUNT MISMATCH, OUT OF STOCK, v.v.)
-- 2. CÁC LỆNH TỔNG HỢP BÁO CÁO ĐA CHIỀU BẰNG GROUP BY ROLLUP
-- ====================================================================================================

-- ====================================================================================================
-- PHẦN I: KIỂM TRA & BỔ SUNG CỘT BẢO ĐẢM TOÀN VẸN CHO HỆ THỐNG THANH TOÁN
-- ====================================================================================================

IF COL_LENGTH('dbo.tblHoaDon', 'HinhThucThanhToan') IS NULL
BEGIN
    ALTER TABLE dbo.tblHoaDon ADD [HinhThucThanhToan] NVARCHAR(50) NULL DEFAULT N'COD';
END
GO

IF COL_LENGTH('dbo.tblHoaDon', 'DaCongDiem') IS NULL
BEGIN
    ALTER TABLE dbo.tblHoaDon ADD [DaCongDiem] BIT NULL DEFAULT 0;
END
GO

IF COL_LENGTH('dbo.tblKhachHang', 'DiemTichLuy') IS NULL
BEGIN
    ALTER TABLE dbo.tblKhachHang ADD [DiemTichLuy] INT NULL DEFAULT 0;
END
GO

IF COL_LENGTH('dbo.tblKhachHang', 'HangThanhVien') IS NULL
BEGIN
    ALTER TABLE dbo.tblKhachHang ADD [HangThanhVien] NVARCHAR(50) NULL DEFAULT N'Tiêu chuẩn';
END
GO

IF COL_LENGTH('dbo.tblHoaDonDichVu', 'TrangThai') IS NULL
BEGIN
    ALTER TABLE dbo.tblHoaDonDichVu ADD [TrangThai] NVARCHAR(50) NULL DEFAULT N'ChoThanhToan';
END
GO

IF COL_LENGTH('dbo.tblHoaDonDichVu', 'PhuongThucThanhToan') IS NULL
BEGIN
    ALTER TABLE dbo.tblHoaDonDichVu ADD [PhuongThucThanhToan] NVARCHAR(50) NULL;
END
GO

IF COL_LENGTH('dbo.tblHoaDonDichVu', 'MaPhieuDV') IS NULL
BEGIN
    ALTER TABLE dbo.tblHoaDonDichVu ADD [MaPhieuDV] INT NULL;
END
GO

IF COL_LENGTH('dbo.tblHoaDonDichVu', 'MaDatLich') IS NULL
BEGIN
    ALTER TABLE dbo.tblHoaDonDichVu ADD [MaDatLich] INT NULL;
END
GO

-- ====================================================================================================
-- PHẦN II: BẢNG NHẬT KÝ KIỂM TOÁN GIAO DỊCH & XỬ LÝ LỖI THANH TOÁN (PAYMENT AUDIT LOG)
-- ====================================================================================================

IF OBJECT_ID(N'[dbo].[tblLichSuGiaoDichThanhToan]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tblLichSuGiaoDichThanhToan](
        [MaGiaoDich] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [LoaiHoaDon] [nvarchar](20) NOT NULL, -- 'HoaDonHang' hoặc 'HoaDonDichVu'
        [MaHD] [int] NULL,                    -- Mã đơn hàng sản phẩm
        [MaHDDV] [int] NULL,                  -- Mã hóa đơn dịch vụ chăm sóc / spa
        [SoTienGiaoDich] [decimal](18, 2) NOT NULL,
        [PhuongThucThanhToan] [nvarchar](50) NOT NULL, -- 'TienMat', 'VNPay', 'VietQR', 'ChuyenKhoan', 'COD'
        [MaGiaoDichCongTT] [nvarchar](100) NULL,      -- Mã tham chiếu ngân hàng / VNPay TxnRef
        [TrangThaiGiaoDich] [nvarchar](30) NOT NULL,   -- 'ThanhCong', 'ThatBai', 'DaHoanTien', 'CanhBao'
        [MaLoi] [nvarchar](50) NULL,                   -- Mã lỗi chuẩn hóa
        [ThongBaoLoi] [nvarchar](500) NULL,            -- Diễn giải chi tiết nguyên nhân lỗi
        [NgayGiaoDich] [datetime] NULL DEFAULT GETDATE(),
        [NguoiThucHien] [int] NULL,                    -- Mã NV hoặc Mã KH thực hiện giao dịch
        CONSTRAINT [FK_tblLichSuGiaoDich_tblHoaDon] FOREIGN KEY([MaHD]) REFERENCES [dbo].[tblHoaDon] ([MaHD]),
        CONSTRAINT [FK_tblLichSuGiaoDich_tblHoaDonDichVu] FOREIGN KEY([MaHDDV]) REFERENCES [dbo].[tblHoaDonDichVu] ([MaHDDV])
    );
END
GO

-- ====================================================================================================
-- PHẦN III: STORED PROCEDURES XỬ LÝ CÁC LỖI HAY XẢY RA TRONG THANH TOÁN
-- ====================================================================================================

-- ----------------------------------------------------------------------------------------------------
-- 1. SP: sp_XuLyThanhToanDonHang
-- Xử lý thanh toán cho đơn hàng sản phẩm với kiểm tra toàn diện:
--  + Lỗi 1: Đơn hàng không tồn tại (ERR_ORDER_NOT_FOUND)
--  + Lỗi 2: Thanh toán trùng lặp / Double Payment (ERR_ALREADY_PAID)
--  + Lỗi 3: Đơn hàng đã bị hủy (ERR_ORDER_CANCELLED)
--  + Lỗi 4: Số tiền thanh toán không khớp với hóa đơn (ERR_AMOUNT_MISMATCH)
--  + Lỗi 5: Tồn kho không đủ tại thời điểm chốt thanh toán (ERR_OUT_OF_STOCK) kèm khóa dòng UPDLOCK
--  + Lỗi 6: Ngoại lệ hệ thống / Deadlock -> Rollback an toàn (ERR_TRANSACTION_FAILED)
-- ----------------------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_XuLyThanhToanDonHang]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_XuLyThanhToanDonHang];
GO

CREATE PROCEDURE [dbo].[sp_XuLyThanhToanDonHang]
    @MaHD INT,
    @SoTienThanhToan DECIMAL(18, 2),
    @PhuongThuc NVARCHAR(50),
    @MaGiaoDichNgoai NVARCHAR(100) = NULL,
    @MaNV INT = NULL,
    @KetQua BIT OUTPUT,
    @MaLoi NVARCHAR(50) OUTPUT,
    @ThongBao NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @TongTien DECIMAL(18, 2);
    DECLARE @DaThanhToan BIT;
    DECLARE @TinhTrang INT;
    DECLARE @MaKH INT;
    DECLARE @DaCongDiem BIT;

    BEGIN TRY
        -- 1. KIỂM TRA ĐƠN HÀNG CÓ TỒN TẠI KHÔNG
        SELECT 
            @TongTien = TongTien,
            @DaThanhToan = ISNULL(DaThanhToan, 0),
            @TinhTrang = TinhTrang,
            @MaKH = MaKH,
            @DaCongDiem = ISNULL(DaCongDiem, 0)
        FROM dbo.tblHoaDon WITH (UPDLOCK, ROWLOCK)
        WHERE MaHD = @MaHD;

        IF @TongTien IS NULL
        BEGIN
            SET @KetQua = 0;
            SET @MaLoi = N'ERR_ORDER_NOT_FOUND';
            SET @ThongBao = N'Lỗi: Không tìm thấy đơn hàng với mã #' + CAST(@MaHD AS NVARCHAR(20));

            INSERT INTO dbo.tblLichSuGiaoDichThanhToan 
                (LoaiHoaDon, MaHD, SoTienGiaoDich, PhuongThucThanhToan, MaGiaoDichCongTT, TrangThaiGiaoDich, MaLoi, ThongBaoLoi, NguoiThucHien)
            VALUES 
                (N'HoaDonHang', @MaHD, @SoTienThanhToan, @PhuongThuc, @MaGiaoDichNgoai, N'ThatBai', @MaLoi, @ThongBao, @MaNV);

            RETURN;
        END

        -- 2. KIỂM TRA THANH TOÁN TRÙNG LẶP (IDEMPOTENCY / DOUBLE PAYMENT CHECK)
        IF @DaThanhToan = 1
        BEGIN
            SET @KetQua = 0;
            SET @MaLoi = N'ERR_ALREADY_PAID';
            SET @ThongBao = N'Cảnh báo thanh toán trùng: Đơn hàng #' + CAST(@MaHD AS NVARCHAR(20)) + N' đã được thanh toán thành công trước đó.';

            INSERT INTO dbo.tblLichSuGiaoDichThanhToan 
                (LoaiHoaDon, MaHD, SoTienGiaoDich, PhuongThucThanhToan, MaGiaoDichCongTT, TrangThaiGiaoDich, MaLoi, ThongBaoLoi, NguoiThucHien)
            VALUES 
                (N'HoaDonHang', @MaHD, @SoTienThanhToan, @PhuongThuc, @MaGiaoDichNgoai, N'CanhBao', @MaLoi, @ThongBao, @MaNV);

            RETURN;
        END

        -- 3. KIỂM TRA TRẠNG THÁI ĐƠN HÀNG (NẾU ĐÃ BỊ HỦY THÌ KHÔNG CHO THANH TOÁN)
        IF @TinhTrang = 5 -- 5 = Đã hủy
        BEGIN
            SET @KetQua = 0;
            SET @MaLoi = N'ERR_ORDER_CANCELLED';
            SET @ThongBao = N'Lỗi: Đơn hàng #' + CAST(@MaHD AS NVARCHAR(20)) + N' đã bị hủy trước đó, không thể tiến hành thanh toán.';

            INSERT INTO dbo.tblLichSuGiaoDichThanhToan 
                (LoaiHoaDon, MaHD, SoTienGiaoDich, PhuongThucThanhToan, MaGiaoDichCongTT, TrangThaiGiaoDich, MaLoi, ThongBaoLoi, NguoiThucHien)
            VALUES 
                (N'HoaDonHang', @MaHD, @SoTienThanhToan, @PhuongThuc, @MaGiaoDichNgoai, N'ThatBai', @MaLoi, @ThongBao, @MaNV);

            RETURN;
        END

        -- 4. KIỂM TRA SỐ TIỀN THANH TOÁN CÓ KHỚP VỚI HÓA ĐƠN KHÔNG
        IF @SoTienThanhToan < @TongTien
        BEGIN
            SET @KetQua = 0;
            SET @MaLoi = N'ERR_AMOUNT_MISMATCH';
            SET @ThongBao = N'Lỗi số tiền không hợp lệ: Số tiền thanh toán (' + FORMAT(@SoTienThanhToan, 'N0') + 
                            N' đ) nhỏ hơn tổng tiền đơn hàng (' + FORMAT(@TongTien, 'N0') + N' đ).';

            INSERT INTO dbo.tblLichSuGiaoDichThanhToan 
                (LoaiHoaDon, MaHD, SoTienGiaoDich, PhuongThucThanhToan, MaGiaoDichCongTT, TrangThaiGiaoDich, MaLoi, ThongBaoLoi, NguoiThucHien)
            VALUES 
                (N'HoaDonHang', @MaHD, @SoTienThanhToan, @PhuongThuc, @MaGiaoDichNgoai, N'ThatBai', @MaLoi, @ThongBao, @MaNV);

            RETURN;
        END

        -- BẮT ĐẦU TRANSACTION ĐẢM BẢO TÍNH TOÀN VẸN VÀ KHÓA TỒN KHO TRÁNH RACE CONDITION
        BEGIN TRANSACTION;

        -- 5. KIỂM TRA VÀ KHÓA TỒN KHO CHO TỪNG SẢN PHẨM TRONG ĐƠN
        DECLARE @MaSPThieu INT;
        DECLARE @TenSPThieu NVARCHAR(200);
        DECLARE @SoLuongTonHienTai INT;
        DECLARE @SoLuongYeuCau INT;

        SELECT TOP 1
            @MaSPThieu = sp.MaSP,
            @TenSPThieu = sp.TenSP,
            @SoLuongTonHienTai = ISNULL(tk.SoLuongTon, 0),
            @SoLuongYeuCau = ct.SoLuong
        FROM dbo.tblChiTietHoaDon ct
        INNER JOIN dbo.tblSanPham sp ON ct.MaSP = sp.MaSP
        LEFT JOIN dbo.tblTonKho tk WITH (UPDLOCK, HOLDLOCK) ON ct.MaSP = tk.MaSP
        WHERE ct.MaHD = @MaHD AND ISNULL(tk.SoLuongTon, 0) < ct.SoLuong;

        IF @MaSPThieu IS NOT NULL
        BEGIN
            ROLLBACK TRANSACTION;

            SET @KetQua = 0;
            SET @MaLoi = N'ERR_OUT_OF_STOCK';
            SET @ThongBao = N'Lỗi hết hàng: Sản phẩm "' + @TenSPThieu + N'" không đủ tồn kho (chỉ còn ' + 
                            CAST(@SoLuongTonHienTai AS NVARCHAR(10)) + N', yêu cầu ' + CAST(@SoLuongYeuCau AS NVARCHAR(10)) + N').';

            INSERT INTO dbo.tblLichSuGiaoDichThanhToan 
                (LoaiHoaDon, MaHD, SoTienGiaoDich, PhuongThucThanhToan, MaGiaoDichCongTT, TrangThaiGiaoDich, MaLoi, ThongBaoLoi, NguoiThucHien)
            VALUES 
                (N'HoaDonHang', @MaHD, @SoTienThanhToan, @PhuongThuc, @MaGiaoDichNgoai, N'ThatBai', @MaLoi, @ThongBao, @MaNV);

            RETURN;
        END

        -- 6. CẬP NHẬT TRỪ TỒN KHO THỰC TẾ
        UPDATE tk
        SET tk.SoLuongTon = tk.SoLuongTon - ct.SoLuong
        FROM dbo.tblTonKho tk
        INNER JOIN dbo.tblChiTietHoaDon ct ON tk.MaSP = ct.MaSP
        WHERE ct.MaHD = @MaHD;

        -- 7. CẬP NHẬT TRẠNG THÁI HÓA ĐƠN ĐÃ THANH TOÁN
        UPDATE dbo.tblHoaDon
        SET 
            DaThanhToan = 1,
            TinhTrang = 2, -- 2 = Đã xác nhận / Chuẩn bị giao
            HinhThucThanhToan = @PhuongThuc,
            MaNV = COALESCE(@MaNV, MaNV)
        WHERE MaHD = @MaHD;

        -- 8. TÍCH LŨY ĐIỂM THƯỞNG CHO HỘI VIÊN (100.000 VNĐ = 1 ĐIỂM)
        IF @MaKH IS NOT NULL AND @DaCongDiem = 0
        BEGIN
            DECLARE @DiemCong INT = CAST((@TongTien / 100000.0) AS INT);
            IF @DiemCong > 0
            BEGIN
                UPDATE dbo.tblKhachHang
                SET DiemTichLuy = ISNULL(DiemTichLuy, 0) + @DiemCong
                WHERE MaKH = @MaKH;

                -- Tự động nâng hạng thành viên dựa trên điểm
                UPDATE dbo.tblKhachHang
                SET HangThanhVien = CASE 
                    WHEN DiemTichLuy >= 1000 THEN N'VVIP'
                    WHEN DiemTichLuy >= 500  THEN N'VIP'
                    WHEN DiemTichLuy >= 100  THEN N'Thân thiết'
                    ELSE N'Tiêu chuẩn'
                END
                WHERE MaKH = @MaKH;

                UPDATE dbo.tblHoaDon
                SET DaCongDiem = 1
                WHERE MaHD = @MaHD;
            END
        END

        -- 9. GHI VẾT GIAO DỊCH THÀNH CÔNG VÀO AUDIT LOG
        INSERT INTO dbo.tblLichSuGiaoDichThanhToan 
            (LoaiHoaDon, MaHD, SoTienGiaoDich, PhuongThucThanhToan, MaGiaoDichCongTT, TrangThaiGiaoDich, MaLoi, ThongBaoLoi, NguoiThucHien)
        VALUES 
            (N'HoaDonHang', @MaHD, @SoTienThanhToan, @PhuongThuc, @MaGiaoDichNgoai, N'ThanhCong', NULL, N'Thanh toán đơn hàng thành công', @MaNV);

        COMMIT TRANSACTION;

        SET @KetQua = 1;
        SET @MaLoi = NULL;
        SET @ThongBao = N'Thanh toán đơn hàng #' + CAST(@MaHD AS NVARCHAR(20)) + N' thành công.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @KetQua = 0;
        SET @MaLoi = N'ERR_TRANSACTION_FAILED';
        SET @ThongBao = N'Lỗi giao dịch hệ thống: ' + ERROR_MESSAGE();

        INSERT INTO dbo.tblLichSuGiaoDichThanhToan 
            (LoaiHoaDon, MaHD, SoTienGiaoDich, PhuongThucThanhToan, MaGiaoDichCongTT, TrangThaiGiaoDich, MaLoi, ThongBaoLoi, NguoiThucHien)
        VALUES 
            (N'HoaDonHang', @MaHD, @SoTienThanhToan, @PhuongThuc, @MaGiaoDichNgoai, N'ThatBai', @MaLoi, @ThongBao, @MaNV);
    END CATCH
END;
GO

-- ----------------------------------------------------------------------------------------------------
-- 2. SP: sp_XuLyThanhToanHoaDonDichVu
-- Xử lý thanh toán cho hóa đơn dịch vụ chăm sóc & spa tại quầy Thu ngân / Online:
--  + Chống double payment
--  + Kiểm tra số tiền thanh toán
--  + Tự động đồng bộ trạng thái sang Phiếu dịch vụ chăm sóc & Lịch hẹn
--  + Tích lũy điểm hội viên
-- ----------------------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_XuLyThanhToanHoaDonDichVu]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_XuLyThanhToanHoaDonDichVu];
GO

CREATE PROCEDURE [dbo].[sp_XuLyThanhToanHoaDonDichVu]
    @MaHDDV INT,
    @SoTienThanhToan DECIMAL(18, 2),
    @PhuongThuc NVARCHAR(50),
    @MaGiaoDichNgoai NVARCHAR(100) = NULL,
    @MaNV INT = NULL,
    @KetQua BIT OUTPUT,
    @MaLoi NVARCHAR(50) OUTPUT,
    @ThongBao NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @TongTien DECIMAL(18, 2);
    DECLARE @TrangThai NVARCHAR(50);
    DECLARE @MaKH INT;
    DECLARE @MaPhieuDV INT;
    DECLARE @MaDatLich INT;

    BEGIN TRY
        -- 1. KIỂM TRA HÓA ĐƠN DỊCH VỤ CÓ TỒN TẠI KHÔNG
        SELECT 
            @TongTien = TongTien,
            @TrangThai = ISNULL(TrangThai, N'ChoThanhToan'),
            @MaKH = MaKH,
            @MaPhieuDV = MaPhieuDV,
            @MaDatLich = MaDatLich
        FROM dbo.tblHoaDonDichVu WITH (UPDLOCK, ROWLOCK)
        WHERE MaHDDV = @MaHDDV;

        IF @TongTien IS NULL
        BEGIN
            SET @KetQua = 0;
            SET @MaLoi = N'ERR_BILL_NOT_FOUND';
            SET @ThongBao = N'Lỗi: Không tìm thấy hóa đơn dịch vụ với mã #' + CAST(@MaHDDV AS NVARCHAR(20));

            INSERT INTO dbo.tblLichSuGiaoDichThanhToan 
                (LoaiHoaDon, MaHDDV, SoTienGiaoDich, PhuongThucThanhToan, MaGiaoDichCongTT, TrangThaiGiaoDich, MaLoi, ThongBaoLoi, NguoiThucHien)
            VALUES 
                (N'HoaDonDichVu', @MaHDDV, @SoTienThanhToan, @PhuongThuc, @MaGiaoDichNgoai, N'ThatBai', @MaLoi, @ThongBao, @MaNV);

            RETURN;
        END

        -- 2. KIỂM TRA DOUBLE PAYMENT
        IF @TrangThai = N'DaThanhToan'
        BEGIN
            SET @KetQua = 0;
            SET @MaLoi = N'ERR_ALREADY_PAID';
            SET @ThongBao = N'Cảnh báo thanh toán trùng: Hóa đơn dịch vụ #' + CAST(@MaHDDV AS NVARCHAR(20)) + N' đã được thanh toán trước đó.';

            INSERT INTO dbo.tblLichSuGiaoDichThanhToan 
                (LoaiHoaDon, MaHDDV, SoTienGiaoDich, PhuongThucThanhToan, MaGiaoDichCongTT, TrangThaiGiaoDich, MaLoi, ThongBaoLoi, NguoiThucHien)
            VALUES 
                (N'HoaDonDichVu', @MaHDDV, @SoTienThanhToan, @PhuongThuc, @MaGiaoDichNgoai, N'CanhBao', @MaLoi, @ThongBao, @MaNV);

            RETURN;
        END

        -- 3. KIỂM TRA SỐ TIỀN
        IF @SoTienThanhToan < @TongTien
        BEGIN
            SET @KetQua = 0;
            SET @MaLoi = N'ERR_AMOUNT_MISMATCH';
            SET @ThongBao = N'Lỗi số tiền: Số tiền thanh toán (' + FORMAT(@SoTienThanhToan, 'N0') + 
                            N' đ) nhỏ hơn tổng chi phí dịch vụ (' + FORMAT(@TongTien, 'N0') + N' đ).';

            INSERT INTO dbo.tblLichSuGiaoDichThanhToan 
                (LoaiHoaDon, MaHDDV, SoTienGiaoDich, PhuongThucThanhToan, MaGiaoDichCongTT, TrangThaiGiaoDich, MaLoi, ThongBaoLoi, NguoiThucHien)
            VALUES 
                (N'HoaDonDichVu', @MaHDDV, @SoTienThanhToan, @PhuongThuc, @MaGiaoDichNgoai, N'ThatBai', @MaLoi, @ThongBao, @MaNV);

            RETURN;
        END

        BEGIN TRANSACTION;

        -- 4. CẬP NHẬT TRẠNG THÁI HÓA ĐƠN DỊCH VỤ
        UPDATE dbo.tblHoaDonDichVu
        SET 
            TrangThai = N'DaThanhToan',
            PhuongThucThanhToan = @PhuongThuc,
            MaNV = COALESCE(@MaNV, MaNV)
        WHERE MaHDDV = @MaHDDV;

        -- 5. ĐỒNG BỘ SANG PHIẾU DỊCH VỤ CHĂM SÓC (NẾU CÓ LIÊN KẾT)
        IF @MaPhieuDV IS NOT NULL
        BEGIN
            UPDATE dbo.tblPhieuDichVuChamSoc
            SET 
                TrangThaiThanhToan = N'Đã thanh toán',
                TrangThaiDichVu = CASE WHEN TrangThaiDichVu = N'Chờ thanh toán' THEN N'Hoàn thành' ELSE TrangThaiDichVu END
            WHERE MaPhieuDV = @MaPhieuDV;
        END

        -- 6. ĐỒNG BỘ SANG LỊCH HẸN TRỰC TUYẾN (NẾU CÓ LIÊN KẾT)
        IF @MaDatLich IS NOT NULL
        BEGIN
            UPDATE dbo.tblDatLich
            SET 
                TrangThai = N'Hoàn thành',
                TrangThaiThanhToan = N'Đã thanh toán'
            WHERE MaDatLich = @MaDatLich;
        END

        -- 7. TÍCH LŨY ĐIỂM HỘI VIÊN DỊCH VỤ
        IF @MaKH IS NOT NULL
        BEGIN
            DECLARE @DiemCongDV INT = CAST((@TongTien / 100000.0) AS INT);
            IF @DiemCongDV > 0
            BEGIN
                UPDATE dbo.tblKhachHang
                SET DiemTichLuy = ISNULL(DiemTichLuy, 0) + @DiemCongDV
                WHERE MaKH = @MaKH;
            END
        END

        -- 8. GHI LOG KIỂM TOÁN
        INSERT INTO dbo.tblLichSuGiaoDichThanhToan 
            (LoaiHoaDon, MaHDDV, SoTienGiaoDich, PhuongThucThanhToan, MaGiaoDichCongTT, TrangThaiGiaoDich, MaLoi, ThongBaoLoi, NguoiThucHien)
        VALUES 
            (N'HoaDonDichVu', @MaHDDV, @SoTienThanhToan, @PhuongThuc, @MaGiaoDichNgoai, N'ThanhCong', NULL, N'Thanh toán hóa đơn dịch vụ thành công', @MaNV);

        COMMIT TRANSACTION;

        SET @KetQua = 1;
        SET @MaLoi = NULL;
        SET @ThongBao = N'Thanh toán hóa đơn dịch vụ #' + CAST(@MaHDDV AS NVARCHAR(20)) + N' thành công.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @KetQua = 0;
        SET @MaLoi = N'ERR_TRANSACTION_FAILED';
        SET @ThongBao = N'Lỗi giao dịch hệ thống: ' + ERROR_MESSAGE();

        INSERT INTO dbo.tblLichSuGiaoDichThanhToan 
            (LoaiHoaDon, MaHDDV, SoTienGiaoDich, PhuongThucThanhToan, MaGiaoDichCongTT, TrangThaiGiaoDich, MaLoi, ThongBaoLoi, NguoiThucHien)
        VALUES 
            (N'HoaDonDichVu', @MaHDDV, @SoTienThanhToan, @PhuongThuc, @MaGiaoDichNgoai, N'ThatBai', @MaLoi, @ThongBao, @MaNV);
    END CATCH
END;
GO

-- ----------------------------------------------------------------------------------------------------
-- 3. SP: sp_HoanTienVaHuyGiaoDich
-- Xử lý hoàn tiền / đảo ngược giao dịch khi xảy ra khiếu nại hoặc lỗi phát sinh sau thanh toán:
--  + Hoàn trả lại tồn kho vào tblTonKho (nếu là đơn hàng sản phẩm)
--  + Khôi phục trạng thái thanh toán về chưa thanh toán hoặc đã hủy
--  + Khấu trừ lại điểm tích lũy đã cộng
--  + Ghi log giao dịch hoàn tiền
-- ----------------------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_HoanTienVaHuyGiaoDich]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_HoanTienVaHuyGiaoDich];
GO

CREATE PROCEDURE [dbo].[sp_HoanTienVaHuyGiaoDich]
    @LoaiHoaDon NVARCHAR(20), -- 'HoaDonHang' hoặc 'HoaDonDichVu'
    @MaHoaDon INT,
    @LyDoHoanTien NVARCHAR(500),
    @MaNV INT = NULL,
    @KetQua BIT OUTPUT,
    @ThongBao NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @LoaiHoaDon = N'HoaDonHang'
        BEGIN
            DECLARE @TongTienHang DECIMAL(18, 2);
            DECLARE @MaKHHang INT;
            DECLARE @DaThanhToanHang BIT;

            SELECT 
                @TongTienHang = TongTien,
                @MaKHHang = MaKH,
                @DaThanhToanHang = ISNULL(DaThanhToan, 0)
            FROM dbo.tblHoaDon WITH (UPDLOCK, ROWLOCK)
            WHERE MaHD = @MaHoaDon;

            IF @TongTienHang IS NULL OR @DaThanhToanHang = 0
            BEGIN
                ROLLBACK TRANSACTION;
                SET @KetQua = 0;
                SET @ThongBao = N'Lỗi: Đơn hàng #' + CAST(@MaHoaDon AS NVARCHAR(20)) + N' không tồn tại hoặc chưa từng được thanh toán.';
                RETURN;
            END

            -- Hoàn trả số lượng sản phẩm vào kho
            UPDATE tk
            SET tk.SoLuongTon = tk.SoLuongTon + ct.SoLuong
            FROM dbo.tblTonKho tk
            INNER JOIN dbo.tblChiTietHoaDon ct ON tk.MaSP = ct.MaSP
            WHERE ct.MaHD = @MaHoaDon;

            -- Cập nhật trạng thái đơn hàng
            UPDATE dbo.tblHoaDon
            SET 
                DaThanhToan = 0,
                TinhTrang = 5 -- 5 = Đã hủy / Hoàn tiền
            WHERE MaHD = @MaHoaDon;

            -- Khấu trừ lại điểm thưởng nếu đã tích
            IF @MaKHHang IS NOT NULL
            BEGIN
                DECLARE @DiemTru INT = CAST((@TongTienHang / 100000.0) AS INT);
                UPDATE dbo.tblKhachHang
                SET DiemTichLuy = CASE WHEN DiemTichLuy >= @DiemTru THEN DiemTichLuy - @DiemTru ELSE 0 END
                WHERE MaKH = @MaKHHang;
            END

            -- Ghi log hoàn tiền
            INSERT INTO dbo.tblLichSuGiaoDichThanhToan
                (LoaiHoaDon, MaHD, SoTienGiaoDich, PhuongThucThanhToan, TrangThaiGiaoDich, ThongBaoLoi, NguoiThucHien)
            VALUES
                (N'HoaDonHang', @MaHoaDon, @TongTienHang, N'HoanTien', N'DaHoanTien', @LyDoHoanTien, @MaNV);
        END
        ELSE IF @LoaiHoaDon = N'HoaDonDichVu'
        BEGIN
            DECLARE @TongTienDV DECIMAL(18, 2);
            DECLARE @TrangThaiDV NVARCHAR(50);
            DECLARE @MaKHDV INT;

            SELECT 
                @TongTienDV = TongTien,
                @TrangThaiDV = TrangThai,
                @MaKHDV = MaKH
            FROM dbo.tblHoaDonDichVu WITH (UPDLOCK, ROWLOCK)
            WHERE MaHDDV = @MaHoaDon;

            IF @TongTienDV IS NULL OR @TrangThaiDV <> N'DaThanhToan'
            BEGIN
                ROLLBACK TRANSACTION;
                SET @KetQua = 0;
                SET @ThongBao = N'Lỗi: Hóa đơn dịch vụ #' + CAST(@MaHoaDon AS NVARCHAR(20)) + N' chưa được thanh toán, không thể hoàn tiền.';
                RETURN;
            END

            UPDATE dbo.tblHoaDonDichVu
            SET TrangThai = N'DaHuy'
            WHERE MaHDDV = @MaHoaDon;

            -- Khấu trừ điểm dịch vụ
            IF @MaKHDV IS NOT NULL
            BEGIN
                DECLARE @DiemTruDV INT = CAST((@TongTienDV / 100000.0) AS INT);
                UPDATE dbo.tblKhachHang
                SET DiemTichLuy = CASE WHEN DiemTichLuy >= @DiemTruDV THEN DiemTichLuy - @DiemTruDV ELSE 0 END
                WHERE MaKH = @MaKHDV;
            END

            INSERT INTO dbo.tblLichSuGiaoDichThanhToan
                (LoaiHoaDon, MaHDDV, SoTienGiaoDich, PhuongThucThanhToan, TrangThaiGiaoDich, ThongBaoLoi, NguoiThucHien)
            VALUES
                (N'HoaDonDichVu', @MaHoaDon, @TongTienDV, N'HoanTien', N'DaHoanTien', @LyDoHoanTien, @MaNV);
        END

        COMMIT TRANSACTION;
        SET @KetQua = 1;
        SET @ThongBao = N'Hoàn tiền và hủy giao dịch thành công cho hóa đơn #' + CAST(@MaHoaDon AS NVARCHAR(20));
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SET @KetQua = 0;
        SET @ThongBao = N'Lỗi khi xử lý hoàn tiền: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- ----------------------------------------------------------------------------------------------------
-- 4. TRIGGER: trg_ChanSuaHoaDonDaThanhToan
-- Ngăn chặn cập nhật trái phép số tiền hoặc khách hàng sau khi đơn hàng đã thanh toán thành công
-- ----------------------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[trg_ChanSuaHoaDonDaThanhToan]', N'TR') IS NOT NULL
    DROP TRIGGER [dbo].[trg_ChanSuaHoaDonDaThanhToan];
GO

CREATE TRIGGER [dbo].[trg_ChanSuaHoaDonDaThanhToan]
ON dbo.tblHoaDon
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra nếu đơn hàng ĐÃ thanh toán từ trước mà bị can thiệp sửa Tổng tiền hoặc Mã KH
    IF EXISTS (
        SELECT 1 
        FROM deleted d
        INNER JOIN inserted i ON d.MaHD = i.MaHD
        WHERE d.DaThanhToan = 1 
          AND (d.TongTien <> i.TongTien OR ISNULL(d.MaKH, 0) <> ISNULL(i.MaKH, 0) OR ISNULL(d.TienGiam, 0) <> ISNULL(i.TienGiam, 0))
    )
    BEGIN
        RAISERROR(N'Bảo mật thanh toán: Không được phép chỉnh sửa số tiền, tiền giảm hoặc khách hàng của đơn hàng đã thanh toán thành công!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO


-- ====================================================================================================
-- PHẦN IV: CÁC LỆNH TỔNG HỢP VÀ PHÂN TÍCH DỮ LIỆU ĐA CHIỀU BẰNG GROUP BY ROLLUP
-- ====================================================================================================

-- ----------------------------------------------------------------------------------------------------
-- LỆNH ROLLUP 1: BÁO CÁO DOANH THU ĐA CẤP THEO NĂM -> QUÝ -> THÁNG -> PHƯƠNG THỨC THANH TOÁN
-- Tính tổng phụ từng tháng, từng quý, từng năm và tổng đại trà toàn hệ thống
-- ----------------------------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN GROUPING(YEAR(h.NgayLap)) = 1 THEN N'== TỔNG TOÀN BỘ CÁC NĂM ==' 
        ELSE CAST(YEAR(h.NgayLap) AS NVARCHAR(20)) 
    END AS [Nam],
    CASE 
        WHEN GROUPING(DATEPART(QUARTER, h.NgayLap)) = 1 AND GROUPING(YEAR(h.NgayLap)) = 0 THEN N'-- TỔNG CẢ NĂM --'
        WHEN GROUPING(DATEPART(QUARTER, h.NgayLap)) = 1 THEN N''
        ELSE N'Quý ' + CAST(DATEPART(QUARTER, h.NgayLap) AS NVARCHAR(10)) 
    END AS [Quy],
    CASE 
        WHEN GROUPING(MONTH(h.NgayLap)) = 1 AND GROUPING(DATEPART(QUARTER, h.NgayLap)) = 0 THEN N'-- TỔNG QUÝ --'
        WHEN GROUPING(MONTH(h.NgayLap)) = 1 THEN N''
        ELSE N'Tháng ' + CAST(MONTH(h.NgayLap) AS NVARCHAR(10)) 
    END AS [Thang],
    CASE 
        WHEN GROUPING(h.HinhThucThanhToan) = 1 AND GROUPING(MONTH(h.NgayLap)) = 0 THEN N'-- TẤT CẢ PHƯƠNG THỨC --'
        WHEN GROUPING(h.HinhThucThanhToan) = 1 THEN N''
        ELSE ISNULL(h.HinhThucThanhToan, N'Chưa chọn') 
    END AS [PhuongThucThanhToan],
    COUNT(h.MaHD) AS [SoLuongDonHang],
    SUM(h.TongTien) AS [TongDoanhThuGoc],
    SUM(ISNULL(h.TienGiam, 0)) AS [TongTienGiamGia],
    SUM(h.TongTien - ISNULL(h.TienGiam, 0)) AS [DoanhThuThucThu]
FROM dbo.tblHoaDon h
WHERE h.DaThanhToan = 1
GROUP BY ROLLUP(YEAR(h.NgayLap), DATEPART(QUARTER, h.NgayLap), MONTH(h.NgayLap), h.HinhThucThanhToan)
ORDER BY 
    GROUPING(YEAR(h.NgayLap)) DESC,
    YEAR(h.NgayLap),
    GROUPING(DATEPART(QUARTER, h.NgayLap)) DESC,
    DATEPART(QUARTER, h.NgayLap),
    GROUPING(MONTH(h.NgayLap)) DESC,
    MONTH(h.NgayLap);
GO

-- ----------------------------------------------------------------------------------------------------
-- LỆNH ROLLUP 2: BÁO CÁO DOANH SỐ BÁN LẺ THEO DANH MỤC SẢN PHẨM -> TÊN SẢN PHẨM
-- Giúp ban giám đốc phân tích nhóm sản phẩm nào bán chạy nhất, kèm tổng phụ từng danh mục
-- ----------------------------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN GROUPING(dm.TenDanhMuc) = 1 THEN N'== TỔNG TẤT CẢ DANH MỤC ==' 
        ELSE ISNULL(dm.TenDanhMuc, N'Chưa phân loại') 
    END AS [DanhMuc],
    CASE 
        WHEN GROUPING(sp.TenSP) = 1 AND GROUPING(dm.TenDanhMuc) = 0 THEN N'-- TỔNG DANH MỤC ' + ISNULL(dm.TenDanhMuc, N'') + N' --'
        WHEN GROUPING(sp.TenSP) = 1 THEN N''
        ELSE sp.TenSP 
    END AS [TenSanPham],
    SUM(ct.SoLuong) AS [TongSoLuongBan],
    SUM(ct.SoLuong * ct.GiaBan) AS [TongDoanhThuBan],
    AVG(ct.GiaBan) AS [GiaBanTrungBinh]
FROM dbo.tblChiTietHoaDon ct
INNER JOIN dbo.tblHoaDon h ON ct.MaHD = h.MaHD
INNER JOIN dbo.tblSanPham sp ON ct.MaSP = sp.MaSP
LEFT JOIN dbo.tblDanhMuc dm ON sp.MaDanhMuc = dm.MaDanhMuc
WHERE h.DaThanhToan = 1
GROUP BY ROLLUP(dm.TenDanhMuc, sp.TenSP)
ORDER BY 
    GROUPING(dm.TenDanhMuc) DESC,
    dm.TenDanhMuc,
    GROUPING(sp.TenSP) DESC,
    TongDoanhThuBan DESC;
GO

-- ----------------------------------------------------------------------------------------------------
-- LỆNH ROLLUP 3: BÁO CÁO DOANH THU DỊCH VỤ SPA & KHÁM CHỮA BỆNH THEO NHÓM DỊCH VỤ -> TÊN DỊCH VỤ
-- Phân tích cơ cấu doanh thu theo nhóm dịch vụ (Spa, Tiêm phòng, Khám tổng quát) và tổng toàn viện
-- ----------------------------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN GROUPING(dv.NhomDichVu) = 1 THEN N'== TỔNG TẤT CẢ DỊCH VỤ ==' 
        ELSE ISNULL(dv.NhomDichVu, N'Chưa phân nhóm') 
    END AS [NhomDichVu],
    CASE 
        WHEN GROUPING(dv.TenDichVu) = 1 AND GROUPING(dv.NhomDichVu) = 0 THEN N'-- TỔNG NHÓM ' + ISNULL(dv.NhomDichVu, N'') + N' --'
        WHEN GROUPING(dv.TenDichVu) = 1 THEN N''
        ELSE dv.TenDichVu 
    END AS [TenDichVu],
    COUNT(ct.MaChiTiet) AS [SoLuotThucHien],
    SUM(ct.SoLuong) AS [TongSoLuongDichVu],
    SUM(ct.ThanhTien) AS [TongDoanhThuDichVu]
FROM dbo.tblChiTietDichVuChamSoc ct
INNER JOIN dbo.tblDichVuChamSoc dv ON ct.MaDVCS = dv.MaDVCS
INNER JOIN dbo.tblPhieuDichVuChamSoc p ON ct.MaPhieuDV = p.MaPhieuDV
WHERE p.TrangThaiThanhToan = N'Đã thanh toán'
GROUP BY ROLLUP(dv.NhomDichVu, dv.TenDichVu)
ORDER BY 
    GROUPING(dv.NhomDichVu) DESC,
    dv.NhomDichVu,
    GROUPING(dv.TenDichVu) DESC,
    TongDoanhThuDichVu DESC;
GO

-- ----------------------------------------------------------------------------------------------------
-- LỆNH ROLLUP 4: BÁO CÁO GIÁ TRỊ TỒN KHO THEO NHÀ CUNG CẤP -> DANH MỤC -> SẢN PHẨM
-- Giám sát giá trị vốn hàng tồn theo từng đối tác cung ứng và từng mặt hàng
-- ----------------------------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN GROUPING(ncc.TenNCC) = 1 THEN N'== TỔNG TOÀN BỘ KHO HÀNG ==' 
        ELSE ISNULL(ncc.TenNCC, N'Chưa phân bổ NCC') 
    END AS [NhaCungCap],
    CASE 
        WHEN GROUPING(dm.TenDanhMuc) = 1 AND GROUPING(ncc.TenNCC) = 0 THEN N'-- TỔNG THEO NCC ' + ISNULL(ncc.TenNCC, N'') + N' --'
        WHEN GROUPING(dm.TenDanhMuc) = 1 THEN N''
        ELSE ISNULL(dm.TenDanhMuc, N'Chưa phân loại DM') 
    END AS [DanhMuc],
    CASE 
        WHEN GROUPING(sp.TenSP) = 1 AND GROUPING(dm.TenDanhMuc) = 0 THEN N'-- TỔNG DANH MỤC ' + ISNULL(dm.TenDanhMuc, N'') + N' --'
        WHEN GROUPING(sp.TenSP) = 1 THEN N''
        ELSE sp.TenSP 
    END AS [TenSanPham],
    SUM(ISNULL(tk.SoLuongTon, 0)) AS [TongSoLuongTon],
    SUM(ISNULL(tk.SoLuongTon, 0) * ISNULL(sp.GiaBan, 0)) AS [UocTinhGiaTriKho]
FROM dbo.tblTonKho tk
INNER JOIN dbo.tblSanPham sp ON tk.MaSP = sp.MaSP
LEFT JOIN dbo.tblDanhMuc dm ON sp.MaDanhMuc = dm.MaDanhMuc
LEFT JOIN dbo.tblNhaCungCap ncc ON sp.MaNCC = ncc.MaNCC
GROUP BY ROLLUP(ncc.TenNCC, dm.TenDanhMuc, sp.TenSP)
ORDER BY 
    GROUPING(ncc.TenNCC) DESC,
    ncc.TenNCC,
    GROUPING(dm.TenDanhMuc) DESC,
    dm.TenDanhMuc;
GO

-- ----------------------------------------------------------------------------------------------------
-- LỆNH ROLLUP 5: BÁO CÁO KIỂM TOÁN TỶ LỆ LỖI THANH TOÁN THEO CỔNG THANH TOÁN -> TRẠNG THÁI -> MÃ LỖI
-- Thống kê số lượng giao dịch thành công, thất bại và mã lỗi hay gặp nhất trên từng kênh thanh toán
-- ----------------------------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN GROUPING(ls.PhuongThucThanhToan) = 1 THEN N'== TỔNG TẤT CẢ PHƯƠNG THỨC ==' 
        ELSE ls.PhuongThucThanhToan 
    END AS [PhuongThucThanhToan],
    CASE 
        WHEN GROUPING(ls.TrangThaiGiaoDich) = 1 AND GROUPING(ls.PhuongThucThanhToan) = 0 THEN N'-- TỔNG TRẠNG THÁI --'
        WHEN GROUPING(ls.TrangThaiGiaoDich) = 1 THEN N''
        ELSE ls.TrangThaiGiaoDich 
    END AS [TrangThaiGiaoDich],
    CASE 
        WHEN GROUPING(ls.MaLoi) = 1 AND GROUPING(ls.TrangThaiGiaoDich) = 0 THEN N'-- TẤT CẢ MÃ LỖI --'
        WHEN GROUPING(ls.MaLoi) = 1 THEN N''
        ELSE ISNULL(ls.MaLoi, N'THÀNH CÔNG (KHÔNG LỖI)') 
    END AS [MaLoiChiTiet],
    COUNT(ls.MaGiaoDich) AS [SoGiaoDich],
    SUM(ls.SoTienGiaoDich) AS [TongTienGiaoDich]
FROM dbo.tblLichSuGiaoDichThanhToan ls
GROUP BY ROLLUP(ls.PhuongThucThanhToan, ls.TrangThaiGiaoDich, ls.MaLoi)
ORDER BY 
    GROUPING(ls.PhuongThucThanhToan) DESC,
    ls.PhuongThucThanhToan,
    GROUPING(ls.TrangThaiGiaoDich) DESC,
    ls.TrangThaiGiaoDich;
GO

-- ----------------------------------------------------------------------------------------------------
-- STORED PROCEDURE ĐỘNG: sp_BaoCaoTongHopDoanhThu_Rollup
-- Báo cáo tổng hợp Rollup linh hoạt theo khoảng thời gian tùy chọn
-- ----------------------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_BaoCaoTongHopDoanhThu_Rollup]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_BaoCaoTongHopDoanhThu_Rollup];
GO

CREATE PROCEDURE [dbo].[sp_BaoCaoTongHopDoanhThu_Rollup]
    @TuNgay DATETIME = NULL,
    @DenNgay DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @TuNgay IS NULL SET @TuNgay = DATEADD(YEAR, -1, GETDATE());
    IF @DenNgay IS NULL SET @DenNgay = GETDATE();

    SELECT 
        CASE 
            WHEN GROUPING(YEAR(h.NgayLap)) = 1 THEN N'== TỔNG TOÀN BỘ KỲ BÁO CÁO ==' 
            ELSE CAST(YEAR(h.NgayLap) AS NVARCHAR(10)) 
        END AS [Nam],
        CASE 
            WHEN GROUPING(MONTH(h.NgayLap)) = 1 AND GROUPING(YEAR(h.NgayLap)) = 0 THEN N'-- TỔNG CẢ NĂM --'
            WHEN GROUPING(MONTH(h.NgayLap)) = 1 THEN N''
            ELSE N'Tháng ' + CAST(MONTH(h.NgayLap) AS NVARCHAR(10)) 
        END AS [Thang],
        CASE 
            WHEN GROUPING(h.HinhThucThanhToan) = 1 AND GROUPING(MONTH(h.NgayLap)) = 0 THEN N'-- TẤT CẢ KÊNH TT --'
            WHEN GROUPING(h.HinhThucThanhToan) = 1 THEN N''
            ELSE ISNULL(h.HinhThucThanhToan, N'COD/Chưa chọn') 
        END AS [KenhThanhToan],
        COUNT(h.MaHD) AS [SoDonHangThanhCong],
        SUM(h.TongTien) AS [DoanhThuThuThuan]
    FROM dbo.tblHoaDon h
    WHERE h.DaThanhToan = 1 
      AND h.NgayLap >= @TuNgay 
      AND h.NgayLap <= @DenNgay
    GROUP BY ROLLUP(YEAR(h.NgayLap), MONTH(h.NgayLap), h.HinhThucThanhToan)
    ORDER BY 
        GROUPING(YEAR(h.NgayLap)) DESC,
        YEAR(h.NgayLap),
        GROUPING(MONTH(h.NgayLap)) DESC,
        MONTH(h.NgayLap);
END;
GO

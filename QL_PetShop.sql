
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
    [GiaDichVu] [decimal](18, 2) NULL
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
(N'Admin', N'Quản trị hệ thống'),
(N'Nhân viên bán hàng', N'Xử lý đơn hàng và chăm sóc khách hàng'),
(N'Bác sĩ thú y', N'Thực hiện các dịch vụ y tế và đưa ra hướng giải quyết cho sức khỏe của thú cưng'),
(N'Quản lý kho', N'Kiểm tra, nhập và xuất hàng'),
(N'Nhân viên marketing', N'Quảng bá sản phẩm và chương trình khuyến mãi'),
(N'Kế toán', N'Theo dõi doanh thu và chi phí'),
(N'Tư vấn viên', N'Hỗ trợ khách hàng chọn sản phẩm'),
(N'Chăm sóc thú cưng', N'Thực hiện tắm, cắt tỉa, trông giữ'),
(N'Nhân viên giao hàng', N'Vận chuyển đơn hàng đến khách'),
(N'Thử việc', N'Nhân viên mới đang được đào tạo'),
(N'Quản lý cửa hàng', N'Giám sát hoạt động kinh doanh và nhân sự tại cửa hàng'),
(N'Chuyên gia dinh dưỡng', N'Tư vấn chế độ ăn uống phù hợp cho từng loại thú cưng'),
(N'Kỹ thuật viên thú y', N'Hỗ trợ bác sĩ trong việc khám, tiêm, xét nghiệm'),
(N'Chuyên viên chăm sóc khách hàng', N'Giải đáp thắc mắc và xử lý khiếu nại'),
(N'Nhân viên vệ sinh', N'Dọn dẹp, khử khuẩn khu vực nuôi và chăm sóc thú cưng')
GO

INSERT INTO [dbo].[tblNhanVien] ([MatKhau], [TenNV], [GioiTinh], [NamSinh], [VaiTro]) VALUES
(N'123456', N'Phan Thị Thắng', N'Nam', 1999, 1),
(N'123456', N'Nguyễn Khánh Quỳnh Hoa', N'Nữ', 2000, 2),
(N'123456', N'Phạm An Thành', N'Nam', 1998, 3),
(N'123456', N'Nguyễn Thị Huệ', N'Nữ', 1997, 4),
(N'123456', N'Hoàng Nam Quang', N'Nam', 1996, 5),
(N'123456', N'Huỳnh Thị Ngọc Tú', N'Nữ', 2001, 6),
(N'123456', N'Trương Minh Tuấn', N'Nam', 1995, 7),
(N'123456', N'Bùi Ngọc Thúy', N'Nữ', 1998, 8),
(N'123456', N'Lê Văn Minh', N'Nam', 1999, 9),
(N'123456', N'Nguyễn Hồng Ngân', N'Nữ', 2000, 10),
(N'123456', N'Đặng Văn Hòa', N'Nam', 1994, 11),
(N'123456', N'Trần Thị Mỹ Duyên', N'Nữ', 2002, 12),
(N'123456', N'Ngô Minh Nhật', N'Nam', 2003, 13),
(N'123456', N'Lê Thị Thanh Trúc', N'Nữ', 2003, 14),
(N'123456', N'Phạm Văn Tài', N'Nam', 2002, 15)
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
(N'Cát vệ sinh cho mèo', N'Accessory', NULL, NULL, N'Trắng', NULL, NULL, N'Cát vệ sinh khử mùi tốt, thân thiện môi trường', 150000.00, N'cat_sand.jpg', 4, 5),
(N'Chó Phú Quốc 5 tháng', N'Pet', N'Đực', CAST(N'2024-03-25' AS Date), N'Vàng', N'Rất khỏe, đã tiêm phòng', N'Không', N'Chó Phú Quốc thuần chủng, xoáy lưng rõ nét', 7000000.00, N'phuquoc_dog.jpg', 1, 10),
(N'Pate cho mèo Whiskas', N'Accessory', NULL, NULL, NULL, NULL, NULL, N'Pate dinh dưỡng cao cấp cho mèo mọi lứa tuổi', 85000.00, N'whiskas_pate.jpg', 3, 7),
(N'Vòng cổ da cao cấp', N'Accessory', NULL, NULL, N'Nâu', NULL, NULL, N'Vòng cổ bằng da thật, điều chỉnh được kích thước', 250000.00, N'leather_collar.jpg', 4, 9),
(N'Mèo Ba Tư 3 tháng', N'Pet', N'Đực', CAST(N'2024-05-30' AS Date), N'Trắng', N'Tốt, cần chăm sóc lông thường xuyên', N'Không', N'Mèo Ba Tư thuần chủng, mặt tịt, lông dày', 10000000.00, N'persian_cat.jpg', 2, 6),
(N'Đồ chơi xương gặm', N'Accessory', NULL, NULL, N'Đỏ', NULL, NULL, N'Đồ chơi cho chó gặm, làm sạch răng', 120000.00, N'chew_toy.jpg', 4, 5),
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

INSERT INTO [dbo].[tblDichVu] ([TenDV], [MoTa], [GiaDichVu]) VALUES
(N'Tắm gội', N'Tắm, sấy và chải lông cho thú cưng', 150000),
(N'Cắt tỉa lông', N'Cắt tỉa tạo kiểu chuyên nghiệp', 200000),
(N'Khám tổng quát', N'Khám sức khỏe toàn diện', 100000),
(N'Tiêm phòng', N'Tiêm ngừa bệnh dại, care, parvo', 250000),
(N'Chăm sóc sau phẫu thuật', N'Theo dõi thú cưng sau điều trị', 300000),
(N'Khách sạn thú cưng', N'Lưu trú an toàn, tiện nghi', 400000),
(N'Ve sinh tai & răng', N'Làm sạch vùng tai, miệng', 100000),
(N'Cạo lông mùa hè', N'Cạo sạch giúp mát mẻ', 120000),
(N'Tư vấn dinh dưỡng', N'Xây dựng khẩu phần ăn hợp lý', 80000),
(N'Khám da liễu', N'Điều trị viêm da, nấm, rụng lông', 200000),
(N'Massage thư giãn', N'Giúp thú cưng giảm căng thẳng và tuần hoàn tốt hơn', 180000),
(N'Gỡ rối lông', N'Gỡ rối lông bị rối, xù, kết cục', 100000),
(N'Chăm sóc móng', N'Cắt móng, vệ sinh móng cho thú cưng', 90000),
(N'Xịt khử mùi', N'Khử mùi hôi cơ thể bằng sản phẩm an toàn', 70000),
(N'Chụp ảnh thú cưng', N'Chụp ảnh chuyên nghiệp, lưu giữ khoảnh khắc', 250000),
(N'Đào tạo cơ bản', N'Dạy thú cưng các kỹ năng cơ bản như ngồi, nằm, đi vệ sinh đúng chỗ', 300000),
(N'Gửi thú cưng theo giờ', N'Dịch vụ giữ thú cưng ngắn hạn theo giờ', 50000),
(N'Chăm sóc thú cưng cao tuổi', N'Dịch vụ đặc biệt cho thú cưng lớn tuổi, theo dõi sức khỏe định kỳ', 350000),
(N'Xét nghiệm máu', N'Kiểm tra tổng quát các chỉ số máu', 280000),
(N'Vệ sinh tuyến hôi', N'Làm sạch tuyến hôi giúp thú cưng thơm tho và khỏe mạnh', 120000);
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

INSERT INTO [dbo].[tblHoaDon] ([MaKH], [MaNV], [NgayLap], [TongTien], [TinhTrang], [DiaChiGiaoHang], [DaThanhToan], [MaGiamGia], [TienGiam])
VALUES
(1, 2, GETDATE(), 6500000, 4, N'Quận 1, TP.HCM', 1, N'SALE10', 50000),
(2, 3, GETDATE(), 9500000, 3, N'Đà Nẵng', 0, NULL, NULL),
(3, 4, GETDATE(), 350000, 2, N'Hà Nội', 1, N'NEWUSER5', 15000),
(4, 5, GETDATE(), 12000000, 1, N'Cần Thơ', 0, NULL, NULL),
(5, 6, GETDATE(), 18000, 4, N'Bình Dương', 1, NULL, NULL),
(6, 7, GETDATE(), 80000, 5, N'Huế', 0, NULL, NULL),
(7, 8, GETDATE(), 95000, 4, N'TP.HCM', 1, NULL, NULL),
(8, 9, GETDATE(), 40000, 2, N'Đà Lạt', 1, NULL, NULL),
(9, 10, GETDATE(), 120000, 3, N'Nha Trang', 1, NULL, NULL),
(10, 1, GETDATE(), 200000, 4, N'Long An', 1, N'SALE25', 100000),
(11, 2, GETDATE(), 450000, 3, N'TP.HCM', 1, N'WELCOME10', 50000),
(12, 3, GETDATE(), 12000000, 4, N'TP.HCM', 1, NULL, NULL),
(13, 4, GETDATE(), 950000, 2, N'TP.HCM', 0, NULL, NULL),
(14, 5, GETDATE(), 180000, 1, N'TP.HCM', 1, N'PETCARE10', 30000),
(15, 6, GETDATE(), 6500000, 4, N'TP.HCM', 1, NULL, NULL),
(16, 7, GETDATE(), 350000, 3, N'TP.HCM', 1, N'FREESHIP', 30000),
(17, 8, GETDATE(), 8000000, 2, N'TP.HCM', 0, NULL, NULL),
(18, 9, GETDATE(), 120000, 4, N'TP.HCM', 1, NULL, NULL),
(19, 10, GETDATE(), 95000, 5, N'TP.HCM', 1, NULL, NULL),
(20, 1, GETDATE(), 40000, 3, N'TP.HCM', 1, NULL, NULL),
(21, 2, GETDATE(), 120000, 4, N'Đồng Nai', 1, N'SUMMER15', 70000),
(22, 3, GETDATE(), 200000, 2, N'Bến Tre', 0, NULL, NULL),
(23, 4, GETDATE(), 300000, 1, N'Vũng Tàu', 1, NULL, NULL),
(24, 5, GETDATE(), 180000, 4, N'Tây Ninh', 1, NULL, NULL),
(25, 6, GETDATE(), 650000, 3, N'Bình Thuận', 1, NULL, NULL),
(26, 7, GETDATE(), 350000, 2, N'Phan Thiết', 0, NULL, NULL),
(27, 8, GETDATE(), 80000, 4, N'Bạc Liêu', 1, NULL, NULL),
(28, 9, GETDATE(), 120000, 3, N'Trà Vinh', 1, NULL, NULL),
(29, 10, GETDATE(), 95000, 4, N'Bình Phước', 1, NULL, NULL),
(30, 1, GETDATE(), 400000, 2, N'Quảng Ngãi', 1, N'NEWYEAR2025', 150000);
GO

INSERT INTO [dbo].[tblChiTietHoaDon] ([MaHD], [MaSP], [SoLuong], [GiaBan]) VALUES
(1, 1, 1, 6500000),
(2, 4, 1, 9500000),
(3, 5, 1, 350000),
(4, 2, 1, 12000000),
(5, 6, 5, 18000),
(6, 7, 1, 80000),
(7, 10, 1, 95000),
(8, 9, 1, 40000),
(9, 8, 1, 120000),
(10, 3, 1, 8000000),
(11, 13, 1, 450000),
(12, 4, 1, 9500000),
(13, 7, 2, 80000),
(14, 17, 1, 85000),
(15, 11, 1, 6500000),
(16, 6, 1, 18000),
(17, 12, 1, 8000000),
(18, 10, 1, 95000),
(19, 9, 1, 40000),
(20, 8, 1, 120000),
(21, 6, 5, 18000),
(22, 5, 1, 350000),
(23, 27, 1, 650000),
(24, 28, 1, 180000),
(25, 26, 1, 110000),
(26, 25, 1, 95000),
(27, 24, 1, 350000),
(28, 23, 1, 120000),
(29, 22, 1, 8500000),
(30, 21, 1, 9000000);
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
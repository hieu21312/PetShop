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
INSERT INTO [dbo].[tblPhieuDichVuChamSoc]
([SoPhieu], [MaThuCung], [MaChuNuoi], [MaNVTiepNhan], [MaNVThucHien], [NgayTiepNhan], [NgayHenTra], [NgayTraThucTe], [CanNangTiepNhan], [TinhTrangBanDau], [YeuCauCuaChuNuoi], [KetQuaChamSoc], [TongTien], [TienGiamGia], [ThanhToan], [HinhThucThanhToan], [TrangThaiThanhToan], [TrangThaiDichVu], [DanhGiaCuaChu], [GhiChu])
VALUES
('PDV-2024-0001', 1, 1, 2, 3, '2024-08-01 08:30:00', '2024-08-01 11:30:00', '2024-08-01 11:15:00', 3.80, N'Lông dài rậm, tai có rỉ, móng hơi dài', N'Tắm dưỡng thơm lâu, cắt tỉa kiểu Teddy bear tròn xoe', N'Bé đã tắm sạch thơm, tỉa đầu tròn gấu bông rất xinh xắn, ngoan ngoãn', 430000, 30000, 400000, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất ưng ý, bé cắt form mặt gấu quá đẹp!', N'Khách VIP giảm 30k'),
('PDV-2024-0002', 2, 1, 2, 8, '2024-08-03 14:00:00', '2024-08-03 16:00:00', '2024-08-03 15:50:00', 4.10, N'Lông rụng nhiều mùa thay lông, móng sắc nhọn', N'Tắm khử mùi bằng sữa tắm hữu cơ, cắt mài móng', N'Đã loại bỏ lông chết, móng được mài êm ái không cào rách ghế', 280000, 0, 280000, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Mèo thơm và sạch sẽ lắm', NULL),
('PDV-2024-0003', 3, 2, 7, 3, '2024-08-05 09:00:00', '2024-08-05 11:30:00', '2024-08-05 11:20:00', 11.50, N'Mông dính bẩn bùn đất, tuyến hôi đầy', N'Tắm sạch sâu, vắt tuyến hôi, tỉa bo tròn quả mông trái tim', N'Đã vắt sạch tuyến hôi, form mông trái tim cực kỳ tròn đẹp', 320000, 20000, 300000, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Dịch vụ xuất sắc, các bạn nhân viên nhiệt tình', NULL),
('PDV-2024-0004', 4, 3, 4, 8, '2024-08-07 10:15:00', '2024-08-07 13:00:00', '2024-08-07 12:45:00', 3.60, N'Lông bết cục ở nách và ngực, mắt nhiều rỉ đen', N'Gỡ rối lông, ủ dầu hấp mềm mượt, vệ sinh khóe mắt', N'Đã gỡ sạch búi rối không cần cạo, lông tơi xốp bồng bềnh', 350000, 0, 350000, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Không ngờ gỡ được búi rối mà không phải cạo trụi lông, cảm ơn spa', NULL),
('PDV-2024-0005', 5, 4, 9, 3, '2024-08-10 08:00:00', '2024-08-10 11:30:00', '2024-08-10 11:30:00', 34.00, N'Chó lớn, lông rụng nhiều, hơi hôi cơ thể', N'Tắm sấy áp lực cao, chải sạch lông chết, vệ sinh tai', N'Đã loại bỏ gần 1kg lông rụng, chó sạch sẽ thơm tho mát mẻ', 450000, 0, 450000, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tắm chó to rất vất vả, các bạn làm rất có tâm', NULL),
('PDV-2024-0006', 6, 5, 2, 8, '2024-08-12 13:30:00', '2024-08-12 15:30:00', '2024-08-12 15:15:00', 4.80, N'Bình thường, hơi ngứa tai nhẹ', N'Tắm spa thư giãn cho mèo, nhỏ thuốc dưỡng tai', N'Mèo ngoan, tai sạch khô ráo, thơm dịu', 280000, 0, 280000, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bé về nhà ngủ rất ngon', NULL),
('PDV-2024-0007', 7, 5, 2, 8, '2024-08-12 13:30:00', '2024-08-12 15:30:00', '2024-08-12 15:20:00', 3.20, N'Lông dài rậm, đốm nấm cũ đã lành', N'Tắm thảo mộc kháng khuẩn, sấy bồng lông', N'Lông mềm như nhung, da hồng hào khỏe mạnh', 280000, 0, 280000, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất hài lòng', NULL),
('PDV-2024-0008', 8, 6, 7, 3, '2024-08-15 09:30:00', '2024-08-15 11:30:00', '2024-08-15 11:10:00', 1.80, N'Bé nhỏ xíu, lông xoăn rối nhẹ', N'Tắm ấm giữ nhiệt, cắt tỉa nhẹ nhàng kiểu búp bê', N'Đã sấy ấm hoàn toàn, cắt form nhỏ nhắn dễ thương', 380000, 50000, 330000, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bé không hề bị ho hay lạnh, cắt khéo tay', N'Khách VIP giảm 50k'),
('PDV-2024-0009', 9, 7, 4, 8, '2024-08-18 10:00:00', '2024-08-18 12:00:00', '2024-08-18 11:55:00', 4.50, N'Tai cụp đọng sáp tai màu nâu sẫm', N'Tắm spa dịu nhẹ, vệ sinh sạch sâu kẽ tai', N'Đã làm sạch sâu tai, kiểm tra không có ve tai', 280000, 0, 280000, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Rất chu đáo', NULL),
('PDV-2024-0010', 10, 8, 9, 3, '2024-08-20 08:30:00', '2024-08-20 11:30:00', '2024-08-20 11:15:00', 29.50, N'Lông dày, ngực ướt dãi, móng chân dài', N'Tắm trắng sáng lông ngực, cắt tỉa gọn gàng gầm bụng', N'Lông ngực trắng sáng óng ả, cắt móng chân êm', 450000, 0, 450000, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Chó Golden nhà mình mê các bạn ở đây lắm', NULL),
('PDV-2024-0011', 11, 9, 2, 8, '2024-08-22 15:00:00', '2024-08-22 16:30:00', '2024-08-22 16:15:00', 3.90, N'Mèo không lông da tiết nhiều bã nhờn nâu ở cổ nách', N'Tắm tẩy nhờn chuyên dụng cho Sphynx, thoa kem dưỡng ẩm', N'Da sạch bóng nhờn, sờ mềm mịn ấm áp, lau sạch kẽ ngón', 250000, 0, 250000, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Đúng chuẩn spa cho dòng mèo không lông', NULL),
('PDV-2024-0012', 12, 10, 7, 3, '2024-08-25 14:15:00', '2024-08-25 15:45:00', '2024-08-25 15:35:00', 8.20, N'Nếp nhăn mặt đọng ẩm hôi, người có mùi chua', N'Tắm trị mùi da liễu, vệ sinh và bôi bột khô nếp mặt Pug', N'Nếp gấp mũi khô ráo sạch sẽ, người thơm mát thảo dược', 220000, 0, 220000, N'Tiền mặt', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bé Pug hết hẳn mùi hôi nếp nhăn', NULL),
('PDV-2024-0013', 13, 11, 4, 3, '2024-08-28 09:00:00', '2024-08-31 17:00:00', '2024-08-31 16:45:00', 26.00, N'Khách gửi lưu chuồng 3 ngày đi công tác', N'Khách sạn phòng Deluxe, dắt chạy bộ, ăn hạt Taste of the Wild', N'Lưu trú 3 ngày an toàn, ăn uống khỏe, cập nhật video hàng ngày', 750000, 50000, 700000, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Camera xem rất nét, yên tâm đi công tác', N'Lưu trú 3 ngày + tắm trước khi về'),
('PDV-2024-0014', 14, 12, 2, 8, '2024-09-02 10:00:00', '2024-09-02 12:30:00', '2024-09-02 12:20:00', 3.40, N'Lông mọc che mắt, móng dài', N'Tỉa phom tiểu thư quý phái, nhuộm tai hồng hữu cơ', N'Nhuộm tai hồng xinh xắn, khuôn mặt sáng bừng sang chảnh', 480000, 40000, 440000, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Bé đẹp như thiên thần nhỏ', N'Gói VIP Grooming'),
('PDV-2024-0015', 15, 13, 9, 3, '2024-09-05 08:30:00', '2024-09-05 12:30:00', '2024-09-05 12:15:00', 21.00, N'Samoyed lông rụng trắng nhà, xỉn màu vàng ở chân', N'Tắm trắng phục hồi bạch tuyết, sấy tơi lông 2 máy', N'Lông trắng muốt rạng ngời như tuyết, bồng bềnh thơm mát', 500000, 0, 500000, N'Chuyển khoản', N'Đã thanh toán', N'Đã bàn giao thú cưng', N'Tuyệt vời, lông sạch trắng tinh', NULL),
('PDV-2024-0016', 1, 1, 2, 3, '2024-09-10 09:00:00', '2024-09-10 11:30:00', NULL, 3.85, N'Hơi rối lông vùng tai', N'Tắm sấy dưỡng lông & cắt mài móng', NULL, 250000, 0, 250000, NULL, N'Chưa thanh toán', N'Đang thực hiện', NULL, N'Đang sấy tạo kiểu'),
('PDV-2024-0017', 3, 2, 7, 8, '2024-09-12 14:00:00', '2024-09-12 16:30:00', NULL, 11.60, N'Móng dài, dơ chân', N'Tắm sấy & Tỉa gọn mông', NULL, 320000, 0, 320000, NULL, N'Chưa thanh toán', N'Chờ tiếp nhận', NULL, N'Khách vừa đưa pet tới');
GO

-- 6. DỮ LIỆU MẪU: CHI TIẾT DỊCH VỤ CHĂM SÓC (tblChiTietDichVuChamSoc)
INSERT INTO [dbo].[tblChiTietDichVuChamSoc]
([MaPhieuDV], [MaDVCS], [SoLuong], [DonGia], [PhuPhi], [ThanhTien], [NhanVienPhuTrach], [GhiChuChiTiet])
VALUES
(1, 1, 1, 150000, 0, 150000, N'Bác sĩ An Thành', N'Tắm 2 nước thơm'),
(1, 5, 1, 280000, 0, 280000, N'Bác sĩ An Thành', N'Cắt tỉa mặt gấu Teddy'),
(2, 4, 1, 180000, 0, 180000, N'Bùi Ngọc Thúy', N'Tắm sấy êm ái cho mèo'),
(2, 7, 1, 100000, 0, 100000, N'Bùi Ngọc Thúy', N'Cắt móng và dũa móng'),
(3, 2, 1, 220000, 0, 220000, N'Bác sĩ An Thành', N'Tắm cho Corgi'),
(3, 7, 1, 100000, 0, 100000, N'Bác sĩ An Thành', N'Vắt tuyến hôi sạch sẽ'),
(4, 9, 1, 250000, 0, 250000, N'Bùi Ngọc Thúy', N'Gỡ lông bết nách'),
(4, 7, 1, 100000, 0, 100000, N'Bùi Ngọc Thúy', N'Vệ sinh tai mắt'),
(5, 3, 1, 350000, 0, 350000, N'Bác sĩ An Thành', N'Tắm chó Alaska 34kg'),
(5, 7, 1, 100000, 0, 100000, N'Bác sĩ An Thành', N'Làm sạch móng và tai'),
(6, 4, 1, 180000, 0, 180000, N'Bùi Ngọc Thúy', N'Tắm mèo Anh'),
(6, 7, 1, 100000, 0, 100000, N'Bùi Ngọc Thúy', N'Vệ sinh tai'),
(7, 4, 1, 180000, 0, 180000, N'Bùi Ngọc Thúy', N'Tắm mèo Anh lông dài'),
(7, 7, 1, 100000, 0, 100000, N'Bùi Ngọc Thúy', N'Cắt móng'),
(8, 1, 1, 150000, 0, 150000, N'Bác sĩ An Thành', N'Tắm ấm Poodle mini'),
(8, 5, 1, 230000, 0, 230000, N'Bác sĩ An Thành', N'Tỉa gọn gàng'),
(9, 4, 1, 180000, 0, 180000, N'Bùi Ngọc Thúy', N'Tắm mèo tai cụp'),
(9, 7, 1, 100000, 0, 100000, N'Bùi Ngọc Thúy', N'Vệ sinh kẽ tai'),
(10, 3, 1, 350000, 0, 350000, N'Bác sĩ An Thành', N'Tắm Golden Retriever'),
(10, 7, 1, 100000, 0, 100000, N'Bác sĩ An Thành', N'Cắt tỉa lông chân và móng'),
(11, 4, 1, 180000, 70000, 250000, N'Bùi Ngọc Thúy', N'Tắm tẩy tế bào chết Sphynx kèm dưỡng ẩm'),
(12, 2, 1, 220000, 0, 220000, N'Bác sĩ An Thành', N'Tắm trị mùi và vệ sinh nếp nhăn'),
(13, 10, 3, 200000, 0, 600000, N'Lê Văn Minh', N'Khách sạn 3 ngày phòng Deluxe'),
(13, 7, 1, 100000, 50000, 150000, N'Bác sĩ An Thành', N'Tắm thơm trước khi trả khách'),
(14, 5, 1, 280000, 0, 280000, N'Bùi Ngọc Thúy', N'Cắt tạo phom tiểu thư'),
(14, 1, 1, 150000, 50000, 200000, N'Bùi Ngọc Thúy', N'Nhuộm hồng 2 tai tự nhiên'),
(15, 3, 1, 350000, 150000, 500000, N'Bác sĩ An Thành', N'Tắm trắng phục hồi chuyên sâu cho Samoyed'),
(16, 1, 1, 150000, 0, 150000, N'Bác sĩ An Thành', N'Tắm sấy'),
(16, 7, 1, 100000, 0, 100000, N'Bác sĩ An Thành', N'Vệ sinh tai móng');
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
INSERT INTO [dbo].[tblNhatKyChamSoc]
([MaPhieuDV], [ThoiGian], [NhanVienThucHien], [BuocThucHien], [TinhTrangThuCung], [HinhAnhNhatKy])
VALUES
(1, '2024-08-01 08:45:00', N'Bác sĩ An Thành', N'Kiểm tra da và chải tơi lông trước khi tắm', N'Bé ngoan, không cắn, da khỏe không ve rận', N'nhatky_1_1.jpg'),
(1, '2024-08-01 09:15:00', N'Bác sĩ An Thành', N'Tắm thảo dược 2 nước và xả dầu xả dưỡng ẩm', N'Rất thích thú khi được xoa bóp tạo bọt', N'nhatky_1_2.jpg'),
(1, '2024-08-01 09:50:00', N'Bác sĩ An Thành', N'Sấy khô hoàn toàn và vệ sinh tai, cắt móng', N'Hơi giật mình tiếng máy sấy nhưng hợp tác tốt', N'nhatky_1_3.jpg'),
(1, '2024-08-01 10:45:00', N'Bác sĩ An Thành', N'Cắt tỉa tạo dáng đầu tròn Teddy bear hoàn chỉnh', N'Đứng ngoan trên bàn tỉa, thành phẩm rất đẹp', N'nhatky_1_4.jpg'),
(3, '2024-08-05 09:15:00', N'Bác sĩ An Thành', N'Tắm nước ấm và vắt tuyến hôi hậu môn', N'Vắt ra dịch màu vàng sẫm có mùi hôi đặc trưng, sau đó rửa sạch', N'nhatky_3_1.jpg'),
(3, '2024-08-05 10:00:00', N'Bác sĩ An Thành', N'Sấy phồng lông và tỉa bo mông hình trái tim', N'Chó Corgi rất phấn khích, mông trái tim cực kỳ nét', N'nhatky_3_2.jpg'),
(13, '2024-08-28 10:00:00', N'Lê Văn Minh', N'Tiếp nhận vào phòng khách sạn Deluxe số 03', N'Uống nước đầy đủ, khám phá phòng mới vui vẻ', N'hotel_checkin_husky.jpg'),
(13, '2024-08-28 17:00:00', N'Lê Văn Minh', N'Cho ăn bữa tối hạt Taste of the Wild và pate', N'Ăn hết sạch 1 tô to trong 5 phút, tiêu hóa tốt', N'hotel_meal_husky.jpg'),
(13, '2024-08-29 07:30:00', N'Lê Văn Minh', N'Dắt đi dạo sân chơi ngoài trời', N'Đi vệ sinh phân khuôn đẹp, chạy nhảy năng động', N'hotel_walk_husky.jpg');
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

-- ==================================================================================
-- HOÀN TẤT TẠO CƠ SỞ DỮ LIỆU & BỔ SUNG ĐẦY ĐỦ 3 CHỨC NĂNG
-- File được xuất thành công: QL_pet_chủ_dv.sql
-- ==================================================================================

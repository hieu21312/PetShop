-- =========================================================================
-- Migration Script: Bổ sung TrangThai và PhuongThucThanhToan vào tblHoaDonDichVu
-- Hệ quản trị CSDL: Microsoft SQL Server
-- =========================================================================

IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[tblHoaDonDichVu]') 
      AND name = 'TrangThai'
)
BEGIN
    ALTER TABLE [dbo].[tblHoaDonDichVu]
    ADD [TrangThai] NVARCHAR(50) NOT NULL CONSTRAINT DF_tblHoaDonDichVu_TrangThai DEFAULT 'ChuaThanhToan';
    PRINT 'Da them cot TrangThai vao bang tblHoaDonDichVu.';
END
ELSE
BEGIN
    PRINT 'Cot TrangThai da ton tai trong bang tblHoaDonDichVu.';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[tblHoaDonDichVu]') 
      AND name = 'PhuongThucThanhToan'
)
BEGIN
    ALTER TABLE [dbo].[tblHoaDonDichVu]
    ADD [PhuongThucThanhToan] NVARCHAR(100) NULL;
    PRINT 'Da them cot PhuongThucThanhToan vao bang tblHoaDonDichVu.';
END
ELSE
BEGIN
    PRINT 'Cot PhuongThucThanhToan da ton tai trong bang tblHoaDonDichVu.';
END
GO

UPDATE [dbo].[tblHoaDonDichVu]
SET [TrangThai] = 'ChuaThanhToan'
WHERE [TrangThai] IS NULL;
GO

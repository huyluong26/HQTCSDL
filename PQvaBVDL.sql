-- Tạo Tài khoản đăng nhập sql server
CREATE LOGIN [an.nv] WITH PASSWORD = 'password123';
CREATE LOGIN [binh.tt] WITH PASSWORD = 'password123';


-- Tạo người dùng
USE QuanLyNhanSu;
CREATE USER [an.nv] FOR LOGIN [an.nv];
CREATE USER [binh.tt] FOR LOGIN [binh.tt];

-- Tạo vai trò
CREATE ROLE AdminRole;
CREATE ROLE UserRole;

-- Gán quyền cho vai trò
GRANT SELECT, INSERT, UPDATE, DELETE ON tblPhongBan TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblNhanVien TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblChamCong TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblLuong TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblTaiKhoan TO AdminRole;
-- Tạo view cho người dùng 
CREATE VIEW vw_ThongTinCaNhan
AS
SELECT nv.MaNV, nv.HoTen, nv.NgaySinh, nv.DiaChi, nv.SoDienThoai, nv.Email, 
       cc.NgayChamCong, cc.GioVao, cc.GioRa, cc.TangCa,
       l.ThangNam, l.LuongCoBan, l.Thuong, l.TongLuong
FROM tblNhanVien nv
LEFT JOIN tblChamCong cc ON nv.MaNV = cc.MaNV
LEFT JOIN tblLuong l ON nv.MaNV = l.MaNV
WHERE nv.MaNV = (SELECT MaNV FROM tblTaiKhoan WHERE TenDangNhap = CURRENT_USER);

-- Gán quyền cho UserRole:
GRANT SELECT ON vw_ThongTinCaNhan TO UserRole;
DENY SELECT, INSERT, UPDATE, DELETE ON tblNhanVien TO UserRole;
DENY SELECT, INSERT, UPDATE, DELETE ON tblChamCong TO UserRole;
DENY SELECT, INSERT, UPDATE, DELETE ON tblLuong TO UserRole;
DENY SELECT, INSERT, UPDATE, DELETE ON tblTaiKhoan TO UserRole;
DENY SELECT, INSERT, UPDATE, DELETE ON tblPhongBan TO UserRole;

-- Gán người dùng vào vai trò
ALTER ROLE AdminRole ADD MEMBER [an.nv];   -- NV001 là Admin
ALTER ROLE UserRole ADD MEMBER [binh.tt];  -- NV002 là User

-- Bảo vệ mật khẩu 
ALTER TABLE tblTaiKhoan
ALTER COLUMN MatKhau VARCHAR(64); -- Tăng độ dài để lưu giá trị mã hóa
UPDATE tblTaiKhoan
SET MatKhau = CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', MatKhau), 2)
WHERE MaTaiKhoan = 'TK001'; -- Ví dụ cập nhật cho TK001

-- Sao lưu và khôi phục dữ liệu
BACKUP DATABASE QuanLyNhanSu
TO DISK = 'D:\Backup\QuanLyNhanSu.bak'
WITH INIT;
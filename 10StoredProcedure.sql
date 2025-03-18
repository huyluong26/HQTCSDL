-- 1. Thêm nhân viên
CREATE PROCEDURE spThemNhanVien
    @HoTen NVARCHAR(100),
    @MaPhong INT,
    @DiaChi NVARCHAR(255),
    @TenDangNhap NVARCHAR(50),
    @MatKhau NVARCHAR(50)
AS
BEGIN
    INSERT INTO tblNhanVien (HoTen, MaPhong, DiaChi)
    VALUES (@HoTen, @MaPhong, @DiaChi);

    DECLARE @MaNV INT = SCOPE_IDENTITY();

    INSERT INTO tblTaiKhoan (MaNV, TenDangNhap, MatKhau)
    VALUES (@MaNV, @TenDangNhap, @MatKhau);
END;

-- 2. Cập nhật lương
CREATE PROCEDURE spCapNhatLuong
    @MaNV INT,
    @LuongCoBan DECIMAL(18, 2),
    @Thuong DECIMAL(18, 2)
AS
BEGIN
    UPDATE tblLuong
    SET LuongCoBan = @LuongCoBan, Thuong = @Thuong
    WHERE MaNV = @MaNV;
END;

-- 3. Tính tổng lương của phòng ban
CREATE PROCEDURE spTongLuongPhongBan
    @MaPhong INT
AS
BEGIN
    SELECT SUM(TongLuong) AS TongLuong
    FROM tblLuong l
    JOIN tblNhanVien nv ON l.MaNV = nv.MaNV
    WHERE nv.MaPhong = @MaPhong;
END;

-- 4. Lấy danh sách nhân viên theo phòng ban
CREATE PROCEDURE spLayNhanVienTheoPhong
    @MaPhong INT
AS
BEGIN
    SELECT MaNV, HoTen
    FROM tblNhanVien
    WHERE MaPhong = @MaPhong;
END;

-- 5. Thêm chấm công
CREATE PROCEDURE spThemChamCong
    @MaNV INT,
    @NgayChamCong DATE,
    @GioVao TIME,
    @GioRa TIME,
    @TangCa BIT
AS
BEGIN
    INSERT INTO tblChamCong (MaNV, NgayChamCong, GioVao, GioRa, TangCa)
    VALUES (@MaNV, @NgayChamCong, @GioVao, @GioRa, @TangCa);
END;

-- 6. Cập nhật thông tin nhân viên
CREATE PROCEDURE spCapNhatNhanVien
    @MaNV INT,
    @HoTen NVARCHAR(100),
    @DiaChi NVARCHAR(255)
AS
BEGIN
    UPDATE tblNhanVien
    SET HoTen = @HoTen, DiaChi = @DiaChi
    WHERE MaNV = @MaNV;
END;

-- 7. Lấy thông tin lương của nhân viên
CREATE PROCEDURE spLayThongTinLuong
    @MaNV INT
AS
BEGIN
    SELECT ThangNam, LuongCoBan, Thuong, TongLuong
    FROM tblLuong
    WHERE MaNV = @MaNV;
END;

-- 8. Xóa nhân viên
CREATE PROCEDURE spXoaNhanVien
    @MaNV INT
AS
BEGIN
    DELETE FROM tblTaiKhoan WHERE MaNV = @MaNV;
    DELETE FROM tblNhanVien WHERE MaNV = @MaNV;
END;

-- 9. Lấy danh sách chấm công của nhân viên
CREATE PROCEDURE spLayChamCong
    @MaNV INT
AS
BEGIN
    SELECT NgayChamCong, GioVao, GioRa, TangCa
    FROM tblChamCong
    WHERE MaNV = @MaNV;
END;

-- 10. Cập nhật mật khẩu của tài khoản nhân viên
CREATE PROCEDURE spCapNhatMatKhau
    @MaNV INT,
    @MatKhauMoi NVARCHAR(50)
AS
BEGIN
    UPDATE tblTaiKhoan
    SET MatKhau = @MatKhauMoi
    WHERE MaNV = @MaNV;
END;




SELECT 
    p.name AS ProcedureName,
    m.definition AS ProcedureDefinition,
    p.create_date AS CreationDate,
    p.modify_date AS LastModifiedDate
FROM 
    sys.procedures p
JOIN 
    sys.sql_modules m ON p.object_id = m.object_id;
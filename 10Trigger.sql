-- 1. Trigger tự động cập nhật lương khi thay đổi mức lương cơ bản
CREATE TRIGGER trgCapNhatLuong
ON tblLuong
AFTER UPDATE
AS
BEGIN
     ALTER TABLE tblLuong 
	 ADD TongLuong AS (LuongCoBan + Thuong);
END;

-- 2. Trigger kiểm tra dữ liệu hợp lệ trước khi chèn nhân viên
CREATE TRIGGER trgKiemTraNhanVien
ON tblNhanVien
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE HoTen IS NULL OR MaPhong IS NULL)
    BEGIN
        RAISERROR('Dữ liệu không hợp lệ: HoTen và MaPhong không được để trống.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO tblNhanVien (HoTen, MaPhong, DiaChi)
        SELECT HoTen, MaPhong, DiaChi FROM inserted;
    END
END;

-- 3. Trigger tự động ghi chép lịch sử thay đổi lương
CREATE TRIGGER trgLichSuThayDoiLuong
ON tblLuong
AFTER UPDATE
AS
BEGIN
    INSERT INTO tblLichSuLuong (MaNV, ThangNam, LuongCoBan, Thuong, TongLuong, NgayThayDoi)
    SELECT MaNV, ThangNam, LuongCoBan, Thuong, TongLuong, GETDATE()
    FROM inserted;
END;

-- 4. Trigger kiểm tra chấm công không vượt quá giờ làm quy định
CREATE TRIGGER trgKiemTraChamCong
ON tblChamCong
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE DATEDIFF(MINUTE, GioVao, GioRa) > 480)
    BEGIN
        RAISERROR('Thời gian chấm công không hợp lệ: Không được vượt quá 8 giờ làm việc.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO tblChamCong (MaNV, NgayChamCong, GioVao, GioRa, TangCa)
        SELECT MaNV, NgayChamCong, GioVao, GioRa, TangCa FROM inserted;
    END
END;

-- 5. Trigger ghi lại lịch sử thay đổi thông tin nhân viên
CREATE TRIGGER trgLichSuCapNhatNhanVien
ON tblNhanVien
AFTER UPDATE
AS
BEGIN
    INSERT INTO tblLichSuNhanVien (MaNV, HoTen, DiaChi, NgayThayDoi)
    SELECT MaNV, HoTen, DiaChi, GETDATE()
    FROM inserted;
END;

-- 6. Trigger kiểm tra tính duy nhất của tên đăng nhập
CREATE TRIGGER trgKiemTraTenDangNhap
ON tblTaiKhoan
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM tblTaiKhoan WHERE TenDangNhap IN (SELECT TenDangNhap FROM inserted))
    BEGIN
        RAISERROR('Tên đăng nhập đã tồn tại.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO tblTaiKhoan (MaNV, TenDangNhap, MatKhau)
        SELECT MaNV, TenDangNhap, MatKhau FROM inserted;
    END
END;

-- 7. Trigger tự động cập nhật thông tin tài khoản khi thay đổi thông tin nhân viên
CREATE TRIGGER trgCapNhatTaiKhoan
ON tblNhanVien
AFTER UPDATE
AS
BEGIN
    UPDATE tk
    SET tk.TenDangNhap = CONCAT(LEFT(nv.HoTen, 3), nv.MaNV) 
    FROM tblTaiKhoan tk
    JOIN inserted nv ON tk.MaNV = nv.MaNV;
END;
-- 8. Trigger ghi lại lịch sử chấm công
CREATE TRIGGER trgLichSuChamCong
ON tblChamCong
AFTER INSERT
AS
BEGIN
    INSERT INTO tblLichSuChamCong (MaNV, NgayChamCong, GioVao, GioRa, TangCa, NgayGhi)
    SELECT MaNV, NgayChamCong, GioVao, GioRa, TangCa, GETDATE()
    FROM inserted;
END;

-- 9. Trigger tự động xóa tài khoản khi nhân viên bị xóa
CREATE TRIGGER trgXoaTaiKhoan
ON tblNhanVien
AFTER DELETE
AS
BEGIN
    DELETE FROM tblTaiKhoan WHERE MaNV IN (SELECT MaNV FROM deleted);
END;

-- 10. Trigger ghi lại thông tin nhân viên khi bị xóa
CREATE TRIGGER trgLichSuXoaNhanVien
ON tblNhanVien
AFTER DELETE
AS
BEGIN
    INSERT INTO tblLichSuXoaNhanVien (MaNV, HoTen, DiaChi, NgayXoa)
    SELECT d.MaNV, d.HoTen, d.DiaChi, GETDATE()
    FROM deleted d;
END;




SELECT 
    t.name AS TriggerName,
    m.definition AS TriggerDefinition
FROM 
    sys.triggers t
JOIN 
    sys.sql_modules m ON t.object_id = m.object_id;
-- 1. View danh sách nhân viên cùng với phòng ban
CREATE VIEW vwNhanVienPhongBan AS
SELECT nv.MaNV, nv.HoTen, pb.TenPhong
FROM tblNhanVien nv
JOIN tblPhongBan pb ON nv.MaPhong = pb.MaPhong;

-- 2. View tổng số giờ làm việc của nhân viên
CREATE VIEW vwTongGioLam AS
SELECT MaNV, SUM(DATEDIFF(MINUTE, GioVao, GioRa)) AS TongGioLam
FROM tblChamCong
WHERE GioRa IS NOT NULL
GROUP BY MaNV;

-- 3. View thông tin lương nhân viên
CREATE VIEW vwThongTinLuong AS
SELECT nv.MaNV, nv.HoTen, l.ThangNam, l.LuongCoBan, l.Thuong, l.TongLuong
FROM tblLuong l
JOIN tblNhanVien nv ON l.MaNV = nv.MaNV;

-- 4. View danh sách nhân viên có thưởng cao nhất
CREATE VIEW vwNhanVienThuongCao AS
SELECT nv.MaNV, nv.HoTen, l.Thuong
FROM tblNhanVien nv
JOIN tblLuong l ON nv.MaNV = l.MaNV
WHERE l.Thuong > 0;

-- 5. View danh sách chấm công của nhân viên theo ngày
CREATE VIEW vwChamCongTheoNgay AS
SELECT nv.HoTen, cc.NgayChamCong, cc.GioVao, cc.GioRa, cc.TangCa
FROM tblChamCong cc
JOIN tblNhanVien nv ON cc.MaNV = nv.MaNV;

-- 6. View danh sách nhân viên theo phòng ban
CREATE VIEW vwNhanVienTheoPhong AS
SELECT pb.TenPhong, COUNT(nv.MaNV) AS SoNhanVien
FROM tblPhongBan pb
LEFT JOIN tblNhanVien nv ON pb.MaPhong = nv.MaPhong
GROUP BY pb.TenPhong;

-- 7. View danh sách tài khoản nhân viên
CREATE VIEW vwTaiKhoanNhanVien AS
SELECT nv.HoTen, tk.TenDangNhap, tk.Quyen
FROM tblTaiKhoan tk
JOIN tblNhanVien nv ON tk.MaNV = nv.MaNV;

-- 8. View số lượng nhân viên theo từng khu vực
CREATE VIEW vwNhanVienTheoKhuVuc AS
SELECT DiaChi, COUNT(MaNV) AS SoNhanVien
FROM tblNhanVien
GROUP BY DiaChi;

-- 9. View lượt chấm công của nhân viên
CREATE VIEW vwLichChamCong AS
SELECT nv.HoTen, COUNT(cc.MaChamCong) AS SoLanChamCong
FROM tblNhanVien nv
LEFT JOIN tblChamCong cc ON nv.MaNV = cc.MaNV
GROUP BY nv.HoTen;

-- 10. View lương trung bình theo phòng ban
CREATE VIEW vwLuongTrungBinhTheoPhong AS
SELECT pb.TenPhong, AVG(l.TongLuong) AS LuongTrungBinh
FROM tblLuong l
JOIN tblNhanVien nv ON l.MaNV = nv.MaNV
JOIN tblPhongBan pb ON nv.MaPhong = pb.MaPhong
GROUP BY pb.TenPhong;

-- Hiển thị nội dung của tất cả các VIEW:
SELECT * FROM vwNhanVienPhongBan;
SELECT * FROM vwTongGioLam;
SELECT * FROM vwThongTinLuong;
SELECT * FROM vwNhanVienThuongCao;
SELECT * FROM vwChamCongTheoNgay;
SELECT * FROM vwNhanVienTheoPhong;
SELECT * FROM vwTaiKhoanNhanVien;
SELECT * FROM vwNhanVienTheoKhuVuc;
SELECT * FROM vwLichChamCong;
SELECT * FROM vwLuongTrungBinhTheoPhong;
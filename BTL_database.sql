-- Tạo cơ sở dữ liệu
CREATE DATABASE QuanLyNhanSu;
GO

-- Sử dụng cơ sở dữ liệu vừa tạo
USE QuanLyNhanSu;

-- Bảng Phòng ban
CREATE TABLE tblPhongBan (
    MaPhong VARCHAR(10) PRIMARY KEY,
    TenPhong NVARCHAR(50) NOT NULL,
    DiaDiem NVARCHAR(100)
);

-- Bảng Nhân viên
CREATE TABLE tblNhanVien (
    MaNV VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(50) NOT NULL,
    NgaySinh DATE,
    DiaChi NVARCHAR(100),
    SoDienThoai VARCHAR(15) NOT NULL UNIQUE,
    Email VARCHAR(50) UNIQUE,
    MaPhong VARCHAR(10),
    FOREIGN KEY (MaPhong) REFERENCES tblPhongBan(MaPhong)
);

-- Bảng Chấm công
CREATE TABLE tblChamCong (
    MaChamCong VARCHAR(15) PRIMARY KEY,
    MaNV VARCHAR(10),
    NgayChamCong DATE NOT NULL,
    GioVao TIME,
    GioRa TIME,
    TangCa DECIMAL(5,2) DEFAULT 0,
    FOREIGN KEY (MaNV) REFERENCES tblNhanVien(MaNV),
    CHECK (GioRa >= GioVao)
);

-- Bảng Lương
CREATE TABLE tblLuong (
    MaLuong VARCHAR(15) PRIMARY KEY,
    MaNV VARCHAR(10),
    ThangNam VARCHAR(7) NOT NULL, -- Định dạng MM/YYYY
    LuongCoBan DECIMAL(15,2) NOT NULL,
    Thuong DECIMAL(15,2) DEFAULT 0,
    TongLuong AS (LuongCoBan + Thuong), -- Cột tính toán
    FOREIGN KEY (MaNV) REFERENCES tblNhanVien(MaNV)
);

-- Bảng Tài khoản
CREATE TABLE tblTaiKhoan (
    MaTaiKhoan VARCHAR(10) PRIMARY KEY,
    MaNV VARCHAR(10),
    TenDangNhap VARCHAR(30) NOT NULL UNIQUE,
    MatKhau VARCHAR(50) NOT NULL,
    Quyen NVARCHAR(20) NOT NULL,
    FOREIGN KEY (MaNV) REFERENCES tblNhanVien(MaNV)
);

-- Bảng Phòng ban - Dữ liệu mẫu
INSERT INTO tblPhongBan (MaPhong, TenPhong, DiaDiem) VALUES
('PB001', N'Hành chính', N'Tầng 1'),
('PB002', N'Kế toán', N'Tầng 2'),
('PB003', N'Nhân sự', N'Tầng 1'),
('PB004', N'Kỹ thuật', N'Tầng 3'),
('PB005', N'Marketing', N'Tầng 4'),
('PB006', N'Kinh doanh', N'Tầng 5'),
('PB007', N'Sản xuất', N'Nhà xưởng'),
('PB008', N'Chăm sóc khách hàng', N'Tầng 2'),
('PB009', N'IT', N'Tầng 3'),
('PB010', N'Pháp chế', N'Tầng 1'),
('PB011', N'Kho vận', N'Kho tầng'),
('PB012', N'Thiết kế', N'Tầng 4'),
('PB013', N'Đào tạo', N'Tầng 5'),
('PB014', N'Quản lý chất lượng', N'Tầng 3'),
('PB015', N'R&D', N'Tầng 6');

-- Bảng Nhân viên - Dữ liệu mẫu
INSERT INTO tblNhanVien (MaNV, HoTen, NgaySinh, DiaChi, SoDienThoai, Email, MaPhong) VALUES
('NV001', N'Nguyễn Ngọc Hiệp', '1990-05-15', N'Hà Nội', '0912345671', 'an.nv@gmail.com', 'PB001'),
('NV002', N'Nguyễn Thị Yến', '1992-08-20', N'TP.HCM', '0912345672', 'binh.tt@gmail.com', 'PB002'),
('NV003', N'Nguyễn Lan Anh', '1988-03-10', N'Đà Nẵng', '0912345673', 'cuong.lv@gmail.com', 'PB003'),
('NV004', N'Phạm Thị Dung', '1995-12-25', N'Hải Phòng', '0912345674', 'dung.pt@gmail.com', 'PB004'),
('NV005', N'Hoàng Văn Em', '1993-07-30', N'Cần Thơ', '0912345675', 'em.hv@gmail.com', 'PB005'),
('NV006', N'Ngô Đình Nam', '1991-09-05', N'Hà Nội', '0912345676', 'ha.nt@gmail.com', 'PB006'),
('NV007', N'Nguyễn Huy Hoàng', '1989-11-11', N'TP.HCM', '0912345677', 'khanh.dv@gmail.com', 'PB007'),
('NV008', N'Đoàn Duy Mạnh', '1994-02-14', N'Đà Nẵng', '0912345678', 'lan.bt@gmail.com', 'PB008'),
('NV009', N'Vũ Văn Minh', '1990-06-18', N'Hải Phòng', '0912345679', 'minh.vv@gmail.com', 'PB009'),
('NV010', N'Phạm Thị Bích Ngọc', '1996-04-22', N'Cần Thơ', '0912345680', 'ngoc.tt@gmail.com', 'PB010'),
('NV011', N'Lương Quang Huy', '1987-10-01', N'Hà Nội', '0912345681', 'phong.pv@gmail.com', 'PB011'),
('NV012', N'Lương Thị Quyên', '1993-01-12', N'TP.HCM', '0912345682', 'quyen.lt@gmail.com', 'PB012'),
('NV013', N'Hồ Văn Sơn', '1992-03-08', N'Đà Nẵng', '0912345683', 'son.hv@gmail.com', 'PB013'),
('NV014', N'Mai Thị Thảo', '1995-05-19', N'Hải Phòng', '0912345684', 'thao.mt@gmail.com', 'PB014'),
('NV015', N'Đinh Văn Tú', '1988-08-27', N'Cần Thơ', '0912345685', 'tu.dv@gmail.com', 'PB015');

-- Bảng Chấm công - Dữ liệu mẫu
INSERT INTO tblChamCong (MaChamCong, MaNV, NgayChamCong, GioVao, GioRa, TangCa) VALUES
('CC001', 'NV001', '2025-02-01', '08:00', '17:00', 0),
('CC002', 'NV002', '2025-02-01', '08:30', '17:30', 0),
('CC003', 'NV003', '2025-02-01', '07:45', '16:45', 0),
('CC004', 'NV004', '2025-02-01', '08:00', '18:00', 1),
('CC005', 'NV005', '2025-02-01', '09:00', '18:00', 0),
('CC006', 'NV006', '2025-02-02', '08:00', '17:00', 0),
('CC007', 'NV007', '2025-02-02', '07:30', '17:30', 2),
('CC008', 'NV008', '2025-02-02', '08:15', '17:15', 0),
('CC009', 'NV009', '2025-02-02', '08:00', '19:00', 2),
('CC010', 'NV010', '2025-02-02', '08:30', '17:30', 0),
('CC011', 'NV011', '2025-02-03', '08:00', '17:00', 0),
('CC012', 'NV012', '2025-02-03', '07:45', '16:45', 0),
('CC013', 'NV013', '2025-02-03', '08:00', '18:00', 1),
('CC014', 'NV014', '2025-02-03', '09:00', '18:00', 0),
('CC015', 'NV015', '2025-02-03', '08:00', '17:00', 0);

-- Bảng Lương - Dữ liệu mẫu
INSERT INTO tblLuong (MaLuong, MaNV, ThangNam, LuongCoBan, Thuong) VALUES
('L001', 'NV001', '01/2025', 10000000, 2000000),
('L002', 'NV002', '01/2025', 12000000, 1500000),
('L003', 'NV003', '01/2025', 9000000, 1000000),
('L004', 'NV004', '01/2025', 11000000, 3000000),
('L005', 'NV005', '01/2025', 13000000, 0),
('L006', 'NV006', '01/2025', 9500000, 500000),
('L007', 'NV007', '01/2025', 14000000, 2000000),
('L008', 'NV008', '01/2025', 8000000, 0),
('L009', 'NV009', '01/2025', 11500000, 2500000),
('L010', 'NV010', '01/2025', 10500000, 1000000),
('L011', 'NV011', '01/2025', 12500000, 1500000),
('L012', 'NV012', '01/2025', 8500000, 0),
('L013', 'NV013', '01/2025', 13500000, 3000000),
('L014', 'NV014', '01/2025', 10000000, 500000),
('L015', 'NV015', '01/2025', 14500000, 2000000);

-- Bảng Tài khoản - Dữ liệu mẫu
INSERT INTO tblTaiKhoan (MaTaiKhoan, MaNV, TenDangNhap, MatKhau, Quyen) VALUES
('TK001', 'NV001', 'an.nv', 'password123', 'Admin'),
('TK002', 'NV002', 'binh.tt', 'password123', 'User'),
('TK003', 'NV003', 'cuong.lv', 'password123', 'User'),
('TK004', 'NV004', 'dung.pt', 'password123', 'Admin'),
('TK005', 'NV005', 'em.hv', 'password123', 'User'),
('TK006', 'NV006', 'ha.nt', 'password123', 'User'),
('TK007', 'NV007', 'khanh.dv', 'password123', 'Admin'),
('TK008', 'NV008', 'lan.bt', 'password123', 'User'),
('TK009', 'NV009', 'minh.vv', 'password123', 'User'),
('TK010', 'NV010', 'ngoc.tt', 'password123', 'User'),
('TK011', 'NV011', 'phong.pv', 'password123', 'Admin'),
('TK012', 'NV012', 'quyen.lt', 'password123', 'User'),
('TK013', 'NV013', 'son.hv', 'password123', 'User'),
('TK014', 'NV014', 'thao.mt', 'password123', 'User'),
('TK015', 'NV015', 'tu.dv', 'password123', 'Admin');
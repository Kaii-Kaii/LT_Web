create user DB_QL_NhaHang identified by 123

grant create session to DB_QL_NhaHang
-- Cấp quyền tạo bảng cho user
grant create table to DB_QL_NhaHang

-- Bảng QuyenTruyCap
CREATE TABLE QuyenTruyCap (
    MAQUYEN     CHAR(10) PRIMARY KEY,
    TENQUYEN    NVARCHAR2(15) UNIQUE
);
select * from QuyenTruyCap
-- Bảng TaiKhoan
CREATE TABLE TaiKhoan (
    MATAIKHOAN              CHAR(10) PRIMARY KEY,
    MAQUYEN                CHAR(10),
    TENDANGNHAP            VARCHAR2(20) UNIQUE,
    MATKHAU                VARCHAR2(20),
    EMAIL                  VARCHAR2(40),
    ISEMAILCONFIRMED       NUMBER(1) DEFAULT 0,
    EMAILCONFIRMATIONTOKEN NVARCHAR2(100),
    OTP                    NUMBER,
    CONSTRAINT FK_TK_QTC FOREIGN KEY (MAQUYEN) REFERENCES QuyenTruyCap(MAQUYEN)
);

-- Bảng KhachHang
CREATE TABLE KhachHang (
    MAKH            CHAR(10) PRIMARY KEY,
    MATAIKHOAN      CHAR(10),
    HOTEN           NVARCHAR2(80) NOT NULL,
    NGAYSINH        DATE,
    SODT            CHAR(11),
    DIEMTHANHVIEN   NUMBER DEFAULT 0,
    AVATAR          VARCHAR2(150),
    CONSTRAINT FK_KH_TK FOREIGN KEY (MATAIKHOAN) REFERENCES TaiKhoan(MATAIKHOAN)
);

-- Bảng PhieuDatBan
CREATE TABLE PhieuDatBan (
    MAPHIEU     CHAR(10) PRIMARY KEY,
    MAKH        CHAR(10),
    NGAYDAT     DATE,
    TENKH       NVARCHAR2(20) NOT NULL,
    SOLUONG     NUMBER,
    EMAIL       NVARCHAR2(50),
    SDT         CHAR(11),
    GIODAT      VARCHAR2(10),
    CONSTRAINT FK_PhieuDatBan_KhachHang FOREIGN KEY (MAKH) REFERENCES KhachHang(MAKH)
);

-- Bảng NhanVien
CREATE TABLE NhanVien (
    MANV        CHAR(10) PRIMARY KEY,
    MATAIKHOAN  CHAR(10) NOT NULL,
    HOTEN       NVARCHAR2(20) NOT NULL,
    SODT        CHAR(11),
    CONSTRAINT FK_NV_TK FOREIGN KEY (MATAIKHOAN) REFERENCES TaiKhoan(MATAIKHOAN)
);

-- Bảng NguyenLieu
CREATE TABLE NguyenLieu (
    MANGUYENLIEU    CHAR(10) PRIMARY KEY,
    TENNGUYENLIEU   NVARCHAR2(30) NOT NULL UNIQUE,
    DONGIA          NUMBER,
    DVT             NVARCHAR2(10),
    SOLUONGTON      NUMBER DEFAULT 0
);

-- Bảng PhieuNhapKho
CREATE TABLE PhieuNhapKho (
    MANHAPKHO   CHAR(10) PRIMARY KEY,
    MANV        CHAR(10),
    NGAYNK      DATE DEFAULT SYSDATE,
    TONGTIEN    NUMBER,
    CONSTRAINT FK_NK_NV FOREIGN KEY (MANV) REFERENCES NhanVien(MANV)
);

-- Bảng ChiTietNhapKho
CREATE TABLE ChiTietNhapKho (
    MANHAPKHO       CHAR(10),
    MANGUYENLIEU    CHAR(10),
    SOLUONG         NUMBER,
    THANHTIEN       NUMBER,
    PRIMARY KEY (MANHAPKHO, MANGUYENLIEU),
    CONSTRAINT FK_CTNK_NK FOREIGN KEY (MANHAPKHO) REFERENCES PhieuNhapKho(MANHAPKHO),
    CONSTRAINT FK_CTNK_NL FOREIGN KEY (MANGUYENLIEU) REFERENCES NguyenLieu(MANGUYENLIEU)
);

-- Bảng PhieuXuatKho
CREATE TABLE PhieuXuatKho (
    MAXUATKHO   CHAR(10) PRIMARY KEY,
    MANV        CHAR(10),
    NGAYXK      DATE DEFAULT SYSDATE,
    TONGTIEN    NUMBER,
    CONSTRAINT FK_XK_NV FOREIGN KEY (MANV) REFERENCES NhanVien(MANV)
);

-- Bảng ChiTietXuatKho
CREATE TABLE ChiTietXuatKho (
    MAXUATKHO       CHAR(10),
    MANGUYENLIEU    CHAR(10),
    SOLUONG         NUMBER,
    THANHTIEN       NUMBER,
    PRIMARY KEY (MAXUATKHO, MANGUYENLIEU),
    CONSTRAINT FK_CTXK_XK FOREIGN KEY (MAXUATKHO) REFERENCES PhieuXuatKho(MAXUATKHO),
    CONSTRAINT FK_CTXK_NL FOREIGN KEY (MANGUYENLIEU) REFERENCES NguyenLieu(MANGUYENLIEU)
);

-- Bảng MonAn
CREATE TABLE MonAn (
    MAMONAN    CHAR(10) PRIMARY KEY,
    TENMON     NVARCHAR2(20) NOT NULL UNIQUE,
    LOAIMON    NVARCHAR2(20),
    GIA        FLOAT,
    ANHMON     VARCHAR2(150),
    MOTA       NVARCHAR2(500)
);

-- Bảng GiamGia
CREATE TABLE GiamGia (
    MAGIAMGIA   CHAR(10) PRIMARY KEY,
    NGAYBD      DATE NOT NULL,
    NGAYKT      DATE NOT NULL,
    SOLUONG     NUMBER DEFAULT 1,
    SOTIEN      NUMBER
);

-- Bảng Ban
CREATE TABLE Ban (
    MABAN       VARCHAR2(10) PRIMARY KEY,
    TRANGTHAI   NVARCHAR2(10) DEFAULT N'Trống' CHECK (TRANGTHAI IN (N'Trống', N'Đầy')),
    SUCCHUA     VARCHAR2(5) NOT NULL
);

-- Bảng HoaDon
CREATE TABLE HoaDon (
    MAHOADON    CHAR(10) PRIMARY KEY,
    MABAN       VARCHAR2(10) DEFAULT 'Online',
    MAKH        CHAR(10),
    MANV        CHAR(10),
    MAGIAMGIA   CHAR(10),
    NGAYLAP     DATE DEFAULT SYSDATE,
    TONGTIEN    NUMBER,
    HINHTHUC    NVARCHAR2(20),
    GIAGIAM     NUMBER DEFAULT 0,
    CONSTRAINT FK_HD_BAN FOREIGN KEY (MABAN) REFERENCES Ban(MABAN),
    CONSTRAINT FK_HD_KH FOREIGN KEY (MAKH) REFERENCES KhachHang(MAKH),
    CONSTRAINT FK_HD_NV FOREIGN KEY (MANV) REFERENCES NhanVien(MANV),
    CONSTRAINT FK_HD_GG FOREIGN KEY (MAGIAMGIA) REFERENCES GiamGia(MAGIAMGIA)
);

-- Bảng ChiTietHoaDon
CREATE TABLE ChiTietHoaDon (
    MAHOADON    CHAR(10),
    MAMONAN     CHAR(10),
    SOLUONG     NUMBER,
    THANHTIEN   NUMBER,
    PRIMARY KEY (MAHOADON, MAMONAN),
    CONSTRAINT FK_CTHD_HD FOREIGN KEY (MAHOADON) REFERENCES HoaDon(MAHOADON),
    CONSTRAINT FK_CTHD_MA FOREIGN KEY (MAMONAN) REFERENCES MonAn(MAMONAN)
);

-- Bảng PhieuGoiMon
CREATE TABLE PhieuGoiMon (
    MAPGM       VARCHAR2(10) PRIMARY KEY,
    MABAN       VARCHAR2(10),
    CONSTRAINT FK_PGM_BAN FOREIGN KEY (MABAN) REFERENCES Ban(MABAN)
);

-- Bảng ChiTietGoiMon
CREATE TABLE ChiTietGoiMon (
    MAMONAN     CHAR(10),
    MAPGM       VARCHAR2(10),
    SOLUONG     NUMBER,
    PRIMARY KEY (MAMONAN, MAPGM),
    CONSTRAINT FK_CTG_MA FOREIGN KEY (MAMONAN) REFERENCES MonAn(MAMONAN),
    CONSTRAINT FK_CTG_PGM FOREIGN KEY (MAPGM) REFERENCES PhieuGoiMon(MAPGM)
);

-- Nhập dữ liệu
-- Thêm dữ liệu vào bảng Ban
alter user DB_QL_NhaHang quota 100M on users
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('1', N'Đầy', '2');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('2', 'Đầy', '2');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('3', 'Trống', '4');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('4', 'Trống', '4');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('5', 'Trống', '4+');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('6', 'Đầy', '2');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('7', 'Đầy', '2');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('8', 'Trống', '4');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('9', 'Trống', '4');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('10', 'Trống', '4+');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('11', 'Đầy', '2');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('12', 'Đầy', '2');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('13', 'Trống', '4');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('14', 'Trống', '4');
INSERT INTO Ban (MABAN, TRANGTHAI, SUCCHUA) VALUES ('15', 'Trống', '4+');

select* from Ban

-- Chèn dữ liệu vào bảng QuyenTruyCap
INSERT INTO QuyenTruyCap (MAQUYEN, TENQUYEN) 
VALUES 
    ('Q001', 'Khách hàng');

INSERT INTO QuyenTruyCap (MAQUYEN, TENQUYEN) 
VALUES 
    ('Q002', 'Nhân viên');

-- Chèn dữ liệu vào bảng TaiKhoan
INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP) 
VALUES 
    ('TK0001', 'Q001', 'Khang12', '123456', 'khangt2110@gmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP) 
VALUES 
    ('TK0002', 'Q002', 'admin', '123456', 'khangtuong2110@gmail.com', 1, NULL, NULL);
INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES 
    ('TK0003', 'Q002', 'lethihong', '123456', 'lethihong@example.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES 
    ('TK0004', 'Q002', 'tranvanan', '123456', 'tranvanan@example.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES 
    ('TK0005', 'Q002', 'phamthituyet', '123456', 'phamthituyet@example.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES 
    ('TK0006', 'Q002', 'hoangminhtuan', '123456', 'hoangminhtuan@example.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0007', 'Q001', 'nguyenvana', 'NguyenA@2023', 'nguyenvana@gmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0008', 'Q001', 'tranthib', 'TranB#12345', 'tranthib@yahoo.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0009', 'Q001', 'tranvananh', 'TranV@2023', 'tranvananh@gmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0010', 'Q001', 'nguyenthihanh', 'Hanh1234!', 'nguyenthihanh@gmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0011', 'Q001', 'phamminhduc', 'Duc!45678', 'phamminhduc@hotmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0012', 'Q001', 'lethimyen', 'M.Yen@123', 'lethimyen@yahoo.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0013', 'Q001', 'vothanhbinh', 'BinhPro2023', 'vothanhbinh@outlook.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0014', 'Q001', 'doquanghuy', 'Huy$56789', 'doquanghuy@gmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0015', 'Q001', 'hoangthuha', 'ThuHa@2024', 'hoangthuha@gmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0016', 'Q001', 'nguyenhoangphuc', 'Phuc@2024', 'nguyenhoangphuc@gmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0017', 'Q001', 'phamducthang', 'Thang#5678', 'phamducthang@yahoo.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0018', 'Q001', 'lethibichngoc', 'BichNgoc@99', 'lethibichngoc@hotmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0019', 'Q001', 'hoangkimanh', 'KimAnh$123', 'hoangkimanh@gmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0020', 'Q001', 'tranquocbao', 'QuocBao@678', 'tranquocbao@outlook.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0021', 'Q001', 'dothanhhai', 'Hai@!2023', 'dothanhhai@gmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0022', 'Q001', 'nguyenhongngan', 'HongNgan@987', 'nguyenhongngan@yahoo.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0023', 'Q001', 'phannguyenkhoa', 'Khoa#4567', 'phannguyenkhoa@gmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0024', 'Q001', 'vuquangminh', 'QuangMinh!123', 'vuquangminh@hotmail.com', 1, NULL, NULL);

INSERT INTO TaiKhoan (MATAIKHOAN, MAQUYEN, TENDANGNHAP, MATKHAU, EMAIL, ISEMAILCONFIRMED, EMAILCONFIRMATIONTOKEN, OTP)
VALUES ('TK0025', 'Q001', 'ledinhtien', 'DinhTien2023', 'ledinhtien@outlook.com', 1, NULL, NULL);




INSERT INTO KhachHang (MAKH, MATAIKHOAN, HOTEN, NGAYSINH, SODT, DIEMTHANHVIEN, AVATAR)
VALUES 
    ('KH0001', 'TK0001', 'Tưởng Tấn Khang', TO_DATE('2004-08-09', 'YYYY-MM-DD'), '0374075809', 100, 'images/avatar4.png');

INSERT INTO KhachHang (MAKH, MATAIKHOAN, HOTEN, NGAYSINH, SODT, DIEMTHANHVIEN, AVATAR)
VALUES 
    ('KH0002', NULL, 'Nguyễn Vương Đào', TO_DATE('1999-10-11', 'YYYY-MM-DD'), '09808208', 100, NULL);

INSERT INTO KhachHang (MAKH, MATAIKHOAN, HOTEN, NGAYSINH, SODT, DIEMTHANHVIEN, AVATAR)
VALUES 
    ('KH0003', NULL, 'Lê Văn Hoàng', TO_DATE('1995-03-25', 'YYYY-MM-DD'), '0369685078', 200, NULL);

INSERT INTO KhachHang (MAKH, MATAIKHOAN, HOTEN, NGAYSINH, SODT, DIEMTHANHVIEN, AVATAR)
VALUES 
    ('KH0004', NULL, 'Hoàng Gia Huy', TO_DATE('1985-11-05', 'YYYY-MM-DD'), '0919186077', 300, NULL);

INSERT INTO KhachHang (MAKH, MATAIKHOAN, HOTEN, NGAYSINH, SODT, DIEMTHANHVIEN, AVATAR)
VALUES 
    ('KH0005', NULL, 'Đặng Quốc Khang', TO_DATE('1985-11-05', 'YYYY-MM-DD'), '0260385491', 100, NULL);

INSERT INTO KhachHang (MAKH, MATAIKHOAN, HOTEN, NGAYSINH, SODT, DIEMTHANHVIEN, AVATAR)
VALUES 
    ('No', NULL, 'Không rõ', NULL, '0000000000', 0, 'images/avatar4.png');
INSERT INTO KhachHang (MAKH, MATAIKHOAN, HOTEN, NGAYSINH, SODT, DIEMTHANHVIEN, AVATAR)
VALUES ('KH0006', 'TK0011', 'Phạm Minh Đức', TO_DATE('1993-12-01', 'YYYY-MM-DD'), '0978543212', 150, 'avatar11.png');

INSERT INTO KhachHang (MAKH, MATAIKHOAN, HOTEN, NGAYSINH, SODT, DIEMTHANHVIEN, AVATAR)
VALUES ('KH0007', 'TK0012', 'Lê Thị Mỹ Yên', TO_DATE('1997-03-14', 'YYYY-MM-DD'), '0923456781', 85, 'avatar12.png');

INSERT INTO KhachHang (MAKH, MATAIKHOAN, HOTEN, NGAYSINH, SODT, DIEMTHANHVIEN, AVATAR)
VALUES ('KH0008', 'TK0013', 'Võ Thành Bình', TO_DATE('1988-07-22', 'YYYY-MM-DD'), '0936785432', 200, 'avatar13.png');

INSERT INTO KhachHang (MAKH, MATAIKHOAN, HOTEN, NGAYSINH, SODT, DIEMTHANHVIEN, AVATAR)
VALUES ('KH0009', 'TK0014', 'Đỗ Quang Huy', TO_DATE('1995-11-03', 'YYYY-MM-DD'), '0909123456', 130, 'avatar14.png');

INSERT INTO KhachHang (MAKH, MATAIKHOAN, HOTEN, NGAYSINH, SODT, DIEMTHANHVIEN, AVATAR)
VALUES ('KH0010', 'TK0015', 'Hoàng Thu Hà', TO_DATE('1999-04-27', 'YYYY-MM-DD'), '0987654321', 100, 'avatar15.png');

select * from TaiKhoan

INSERT INTO NhanVien (MANV, MATAIKHOAN, HOTEN, SODT)
VALUES ('NV0001', 'TK0002', 'Nguyễn Văn Tú', '0901234567');

INSERT INTO NhanVien (MANV, MATAIKHOAN, HOTEN, SODT)
VALUES ('NV0002', 'TK0003', 'Lê Thị Hồng', '0912345678');

INSERT INTO NhanVien (MANV, MATAIKHOAN, HOTEN, SODT)
VALUES ('NV0003', 'TK0004', 'Trần Văn An', '0923456789');

INSERT INTO NhanVien (MANV, MATAIKHOAN, HOTEN, SODT)
VALUES ('NV0004', 'TK0005', 'Phạm Thị Tuyết', '0934567890');

INSERT INTO NhanVien (MANV, MATAIKHOAN, HOTEN, SODT)
VALUES ('NV0005', 'TK0006', 'Hoàng Minh Tuấn', '0945678901');

--Nguyên liệu 
INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL001', 'Bún', 10000, 'kg', 10);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL002', 'Củ Cải', 20000, 'củ', 10);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL003', 'Gạo', 15000, 'kg', 20);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL004', 'Đậu Phộng', 25000, 'kg', 15);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL005', 'Nấm Đông Cô', 120000, 'kg', 10);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL006', 'Nấm Rơm', 100000, 'kg', 12);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL007', 'Hành Lá', 5000, 'bó', 50);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL008', 'Hành Tây', 30000, 'kg', 25);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL009', 'Tỏi', 40000, 'kg', 18);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL010', 'Tiêu Đen', 200000, 'kg', 5);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL011', 'Tương Ớt', 15000, 'chai', 30);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL012', 'Tương Cà', 15000, 'chai', 25);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL013', 'Dầu Ăn', 30000, 'lít', 40);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL014', 'Nước Mắm', 20000, 'lít', 35);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL015', 'Muối', 5000, 'kg', 60);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL016', 'Đường', 20000, 'kg', 45);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL017', 'Hạt Nêm', 25000, 'gói', 30);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL018', 'Bột Ngọt', 15000, 'gói', 25);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL019', 'Cà Chua', 15000, 'kg', 20);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL020', 'Dưa Leo', 10000, 'kg', 25);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL021', 'Khoai Tây', 20000, 'kg', 30);

INSERT INTO NguyenLieu (MANGUYENLIEU, TENNGUYENLIEU, DONGIA, DVT, SOLUONGTON)
VALUES ('NL022', 'Bắp Cải', 15000, 'kg', 22);

INSERT INTO MonAn (MAMONAN, TENMON, LOAIMON, GIA, AnhMon, MoTa)
VALUES ('M0001', 'Phở Chay', 'Món Nước', 45000, 'pho_chay.jpg', 'Món phở chay đậm đà hương vị truyền thống.');

INSERT INTO MonAn (MAMONAN, TENMON, LOAIMON, GIA, AnhMon, MoTa)
VALUES ('M0002', 'Bún Riêu Chay', 'Món Nước', 50000, 'bun_rieu_chay.jpg', 'Món bún riêu chay thơm ngon với nước dùng từ cà chua và đậu hũ.');

INSERT INTO MonAn (MAMONAN, TENMON, LOAIMON, GIA, AnhMon, MoTa)
VALUES ('M0003', 'Cơm Chiên Dương Châu', 'Món Chiên', 40000, 'com_chien_duong_chau.jpg', 'Cơm chiên chay với rau củ và nấm, phù hợp với mọi bữa ăn.');

INSERT INTO MonAn (MAMONAN, TENMON, LOAIMON, GIA, AnhMon, MoTa)
VALUES ('M0004', 'Gỏi Cuốn Chay', 'Món Khai Vị', 30000, 'goi_cuon_chay.jpg', 'Gỏi cuốn chay với rau tươi, bún, và nước chấm đậu phộng.');

INSERT INTO MonAn (MAMONAN, TENMON, LOAIMON, GIA, AnhMon, MoTa)
VALUES ('M0005', 'Đậu Hũ Sốt Cà', 'Món Chính', 35000, 'dau_hu_sot_ca.jpg', 'Đậu hũ non sốt cà chua đậm đà, thơm ngon.');

INSERT INTO MonAn (MAMONAN, TENMON, LOAIMON, GIA, AnhMon, MoTa)
VALUES ('M0006', 'Salad Rau Củ', 'Món Khai Vị', 25000, 'salad_rau_cu.jpg', 'Món salad rau củ tươi mát, nhiều dinh dưỡng.');

INSERT INTO MonAn (MAMONAN, TENMON, LOAIMON, GIA, AnhMon, MoTa)
VALUES ('M0007', 'Spaghetti Chay', 'Món Âu', 55000, 'spaghetti_chay.jpg', 'Spaghetti chay với sốt cà chua và đậu hũ.');

INSERT INTO MonAn (MAMONAN, TENMON, LOAIMON, GIA, AnhMon, MoTa)
VALUES ('M0008', 'Lẩu Nấm Chay', 'Món Lẩu', 150000, 'lau_nam_chay.jpg', 'Lẩu nấm chay thơm ngon, phù hợp cho nhóm bạn hoặc gia đình.');

INSERT INTO GiamGia (MAGIAMGIA, NGAYBD, NGAYKT, SOLUONG, SOTIEN) 
VALUES ('No', TO_DATE('2024-11-01', 'YYYY-MM-DD'), TO_DATE('2024-11-30', 'YYYY-MM-DD'), 0, 0);

INSERT INTO HoaDon (MAHOADON, MABAN, MAKH, MANV, MAGIAMGIA, TONGTIEN, HINHTHUC, GIAGIAM)
VALUES ('HD0001', '1', 'No', 'NV0001', NULL, 500000, 'Tiền mặt', 0);

INSERT INTO PhieuNhapKho (MANHAPKHO, MANV, NGAYNK, TONGTIEN)
VALUES 
('PNK001', 'NV0001', TO_DATE('2021-05-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1000000);
INSERT INTO PhieuNhapKho (MANHAPKHO, MANV, NGAYNK, TONGTIEN)
VALUES 
('PNK002', 'NV0001', TO_DATE('2021-05-02 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 2000000);

INSERT INTO ChiTietNhapKho (MANHAPKHO, MANGUYENLIEU, SOLUONG, THANHTIEN)
VALUES 
('PNK001', 'NL001', 100, 1000000);
INSERT INTO ChiTietNhapKho (MANHAPKHO, MANGUYENLIEU, SOLUONG, THANHTIEN)
VALUES 
('PNK002', 'NL002', 200, 2000000);

	select* from QuyenTruyCap --xong
	select* from TaiKhoan --xong
	select* from KhachHang --xong
	select* from NhanVien --xong 
	select* from MonAn--xong
	select* from HoaDon--xong
	select* from NguyenLieu--xong
	select* from PhieuNhapKho
	select* from ChiTietNhapKho
	select* from PhieuXuatKho
	select* from ChiTietXuatKho
	select* from PhieuGoiMon--xong
	select* from Ban--xong
	select* from ChiTietGoiMon--xong
	select* from GiamGia -- xong
    select* from chitietHoaDon
    
    SELECT MAX(TO_NUMBER(SUBSTR(MaHoaDon, 3, LENGTH(MaHoaDon) - 2))) AS MaxValue FROM HoaDon;
    
    
    
    
    
    --Cài đặt các chức năng xử lý nghiệp vụ có sử dụng điều khiển truy cập bắt buộc (MAC) kết hợp OLS
-- **Tạo hàm kiểm tra MAC
CREATE OR REPLACE FUNCTION KiemTraMAC(p_user_id VARCHAR2) 
RETURN NUMBER IS
    v_quyen QUYENTRUYCAP.TENQUYEN%TYPE;
BEGIN
    -- Lấy thông tin quyền của người dùng
    SELECT qt.TENQUYEN INTO v_quyen
    FROM TaiKhoan tk
    JOIN QuyenTruyCap qt ON tk.MAQUYEN = qt.MAQUYEN
    WHERE tk.TENDANGNHAP = p_user_id;

    -- Kiểm tra logic MAC
    IF v_quyen = 'NhÃ¢n viÃªn' THEN
        RETURN 1; -- Được phép nếu là nhân viên
    ELSIF v_quyen = 'KhÃ¡ch hÃ ng' THEN
        RETURN 1; -- Khách hàng cũng được phép
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;

/

-- **Tạo hàm kiểm tra OLS**
CREATE OR REPLACE FUNCTION KiemTraOLS(p_user_id VARCHAR2) 
RETURN NUMBER IS
    v_user_id VARCHAR2(20);
BEGIN
    -- Kiểm tra thông tin người dùng
    SELECT TENDANGNHAP INTO v_user_id
    FROM TaiKhoan
    WHERE TENDANGNHAP = p_user_id;

    -- Dựa vào thông tin nếu khớp, cho phép truy cập
    IF v_user_id = p_user_id THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;

/

-- **Kết hợp cả MAC và OLS**
CREATE OR REPLACE FUNCTION KiemTraQuyen(
    p_user_id VARCHAR2
) 
RETURN NUMBER IS
    v_mac NUMBER;
    v_ols NUMBER;
BEGIN
    -- Kiểm tra MAC và OLS
    v_mac := KiemTraMAC(p_user_id);
    v_ols := KiemTraOLS(p_user_id);

    -- Chỉ cho phép nếu cả hai đều hợp lệ
    IF v_mac = 1 AND v_ols = 1 THEN
        RETURN 1; -- Được phép
    ELSE
        RETURN 0; -- Không được phép
    END IF;
END;
/

-- **Thao tác kiểm tra quyền với dữ liệu**
-- Kiểm tra xem người dùng có thể xem thông tin hóa đơn
SELECT * 
FROM HoaDon hd
WHERE KiemTraQuyen('admin') = 1;

-- Hoặc kiểm tra thông tin hóa đơn nếu người dùng là khách hàng
SELECT * 
FROM HoaDon hd
WHERE KiemTraQuyen('Khang12') = 0;


--RBAC
--kiểm tra quyền của tài khoản hiện tại trước khi thực hiện một nghiệp vụ
CREATE OR REPLACE FUNCTION kiemtra_quyen (
    p_tendangnhap IN VARCHAR2
) RETURN VARCHAR2 IS
    v_tenquyen NVARCHAR2(15);
BEGIN
    SELECT qc.TENQUYEN
    INTO v_tenquyen
    FROM TaiKhoan tk
    JOIN QuyenTruyCap qc ON tk.MAQUYEN = qc.MAQUYEN
    WHERE tk.TENDANGNHAP = p_tendangnhap;

    RETURN v_tenquyen;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;

--xử lí nhập kho
CREATE OR REPLACE PROCEDURE nhap_kho (
    p_tendangnhap IN VARCHAR2,
    p_manhapkho IN CHAR,
    p_manv IN CHAR,
    p_tongtien IN NUMBER
) IS
    v_tenquyen NVARCHAR2(15);
BEGIN
    -- Kiểm tra quyền
    v_tenquyen := kiemtra_quyen(p_tendangnhap);

    IF v_tenquyen = 'NhÃ¢n viÃªn' THEN
        INSERT INTO PhieuNhapKho (MANHAPKHO, MANV, NGAYNK, TONGTIEN)
        VALUES (p_manhapkho, p_manv, SYSDATE, p_tongtien);

        DBMS_OUTPUT.PUT_LINE('Thêm phiếu nhập kho thành công!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Không có quyền thực hiện chức năng này!');
    END IF;
END;

BEGIN
    nhap_kho('lethihong', 'PNK003', 'NV0002', 5000000);
END;

-------Cài đặt các chức năng xử lý nghiệp vụ có sử dụng điều khiển truy cập tùy quyền (DAC)
-- Tạo hàm kiểm tra quyền
CREATE OR REPLACE FUNCTION KiemTraQuyenTruyCap(
    p_maTaiKhoan IN CHAR
) RETURN BOOLEAN AS
    v_quyen QuyenTruyCap.TENQUYEN%TYPE;
BEGIN
    -- Lấy thông tin quyền từ tài khoản
    SELECT q.TENQUYEN 
    INTO v_quyen
    FROM TaiKhoan tk
    JOIN QuyenTruyCap q ON tk.MAQUYEN = q.MAQUYEN
    WHERE tk.MATAIKHOAN = p_maTaiKhoan;

    -- Debug thông tin quyền
    DBMS_OUTPUT.PUT_LINE('Debug: Quyền của tài khoản ' || p_maTaiKhoan || ' là: ' || v_quyen);

    -- Kiểm tra nếu quyền là 'Nhân viên'
    IF v_quyen = 'NhÃ¢n viÃªn' THEN
        RETURN TRUE; -- Tài khoản có quyền
    ELSE
        RETURN FALSE; -- Không có quyền
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Debug: Không tìm thấy thông tin cho tài khoản ' || p_maTaiKhoan);
        RETURN FALSE; -- Nếu không tìm thấy thông tin, trả về FALSE
END;
/


SET SERVEROUTPUT ON;
DECLARE
    has_access BOOLEAN;
BEGIN
    has_access := KiemTraQuyenTruyCap('TK0002'); 

    IF has_access THEN
        DBMS_OUTPUT.PUT_LINE('Debug: Tài khoản có quyền. Thực hiện truy vấn thông tin khách hàng.');
        
        -- Debug: Kiểm tra dữ liệu trước khi lặp
        FOR record IN 
            (SELECT kh.HOTEN, kh.NGAYSINH
             FROM KhachHang kh) LOOP
            DBMS_OUTPUT.PUT_LINE('Debug: Lấy dữ liệu từ KhachHang');
            DBMS_OUTPUT.PUT_LINE('Họ tên: ' || record.HOTEN);
            DBMS_OUTPUT.PUT_LINE('Ngày sinh: ' ||   TO_CHAR(record.NGAYSINH, 'YYYY-MM-DD'));
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Bạn không có quyền xem thông tin khách hàng');
    END IF;
END;

--Cài đặt các chức năng xử lý nghiệp vụ có chức năng có ghi nhật ký và giải trình sử dụng Standard Auditing, trigger
-- Ghi nhật ký với lệnh SELECT, INSERT, UPDATE, DELETE trên một bảng cụ thể
AUDIT INSERT, UPDATE, DELETE ON NhanVien BY ACCESS;
SELECT * FROM DBA_AUDIT_TRAIL;


--Tạo một trigger để ghi thông tin hành động vào một bảng ghi nhật ký mỗi khi có thao tác INSERT, UPDATE, hoặc DELETE
-- Tạo bảng ghi nhật ký
CREATE TABLE NhatKy (
    ID              NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    UserName        VARCHAR2(30),
    ActionType     VARCHAR2(20),
    TableName      VARCHAR2(30),
    RecordID       VARCHAR2(50),
    ActionTime     TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Tạo trigger để ghi nhật ký khi thao tác dữ liệu trên bảng NhanVien
CREATE OR REPLACE TRIGGER TRIGGER_GHI_NHATKY
AFTER DELETE ON NhanVien
FOR EACH ROW
BEGIN
    INSERT INTO NhatKy (ActionType) VALUES ('Xóa nhân viên');
END;
/

ALTER TRIGGER TRIGGER_GHI_NHATKY COMPILE;
DELETE FROM NhanVien WHERE MANV = 'NV0005';


SELECT * FROM NhatKy;
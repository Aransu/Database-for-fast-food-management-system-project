
-- DROP TABLE KHACH_HANG CASCADE CONSTRAINTS;
-- DROP TABLE DON_HANG CASCADE CONSTRAINTS;
-- DROP TABLE CHUONG_TRINH_KM CASCADE CONSTRAINTS;
-- DROP TABLE MON_AN CASCADE CONSTRAINTS;
-- DROP TABLE CHITIET_DON CASCADE CONSTRAINTS;
-- DROP TABLE NGUYEN_LIEU CASCADE CONSTRAINTS;
-- DROP TABLE NGUYEN_LIEU_MON_AN CASCADE CONSTRAINTS;
-- DROP TABLE NHA_CUNG_CAP CASCADE CONSTRAINTS;
-- DROP TABLE NHAN_VIEN CASCADE CONSTRAINTS;
-- DROP TABLE NHACUNGCAP_NGUYENLIEU_QUANLY_BEP CASCADE CONSTRAINTS;
-- DROP TABLE NCC_NL CASCADE CONSTRAINTS;
-- DROP TABLE NHANVIEN_LAMVIEC CASCADE CONSTRAINTS;
-- DROP TABLE TAIKHOAN_NV CASCADE CONSTRAINTS;



CREATE TABLE KHACH_HANG(
    ID INT NOT NULL PRIMARY KEY,
    SO_DIEN_THOAI VARCHAR(15),
    NGAY_THAM_GIA DATE,
    TEN NVARCHAR2(50)
);



CREATE TABLE CHUONG_TRINH_KM(
    ID INT NOT NULL PRIMARY KEY,
    MO_TA NVARCHAR2(100),
    NGAY_BAT_DAU DATE,
    NGAY_KET_THUC DATE,
    MA_GIAM_GIA VARCHAR2(10),
    PHAN_TRAM_GIAM_GIA INT
);


CREATE TABLE DON_HANG(
    ID INT NOT NULL PRIMARY KEY,
    ID_KH INT,
    ID_KM INT,
    ID_THU_NGAN INT,
    TONG_TIEN INT,
       SO_BAN_TAO_DON INT,
    HINH_THUC_THANH_TOAN NVARCHAR2(20),
    TRANG_THAI VARCHAR(50),
    DAT_ONLINE INT,
    NGAY_DAT DATE,
    GHI_CHU NVARCHAR2(100)
);

CREATE TABLE MON_AN(
    ID INT NOT NULL PRIMARY KEY,
    TEN_MON NVARCHAR2(50),
    MO_TA NVARCHAR2(200),
    LOAI VARCHAR(20),	
    GIA NUMBER,
    HINH_ANH BLOB
);



CREATE TABLE CHITIET_DON(
ID_DON NUMBER NOT NULL,
ID_MON NUMBER NOT NULL,
SOLUONG NUMBER
);

ALTER TABLE CHITIET_DON ADD CONSTRAINT PK_DM PRIMARY KEY (ID_DON,ID_MON);
ALTER TABLE CHITIET_DON ADD CONSTRAINT FK_DM FOREIGN KEY(ID_MON) REFERENCES MON_AN(ID) ON DELETE CASCADE;
ALTER TABLE CHITIET_DON ADD CONSTRAINT FK_DH FOREIGN KEY (ID_DON) REFERENCES DON_HANG(ID) ON DELETE CASCADE;

CREATE TABLE NGUYEN_LIEU(
    ID INT NOT NULL PRIMARY KEY,
    TEN NVARCHAR2(100),
    DON_VI VARCHAR(20),
    SO_LUONG_TRONG_KHO INT,
    GIA_NL NUMBER
);

CREATE TABLE NGUYEN_LIEU_MON_AN(
    ID_NL INT NOT NULL,
    ID_MON INT NOT NULL,
    SO_LUONG INT
);

ALTER TABLE NGUYEN_LIEU_MON_AN ADD CONSTRAINT PK_NLMA PRIMARY KEY (ID_NL,ID_MON);

CREATE TABLE NHA_CUNG_CAP(
    ID INT NOT NULL PRIMARY KEY,
    TEN NVARCHAR2(30),
    SO_DIEN_THOAI VARCHAR(11),
    EMAIL VARCHAR(50),
    DIA_CHI NVARCHAR2(100)
);

CREATE TABLE NHAN_VIEN(
    ID INT NOT NULL PRIMARY KEY,
    TEN NVARCHAR2(40),
    SO_DIEN_THOAI VARCHAR(15),
    CHUC_VU VARCHAR(50),
    LUONG NUMBER,
    ID_QUAN_LY INT
);

CREATE TABLE TAIKHOAN_NV(
    USERNAME VARCHAR(50) NOT NULL PRIMARY KEY,
    PASSWORD VARCHAR(50),
    ID_NV INT
);




CREATE TABLE NHANVIEN_LAMVIEC(
    ID INT NOT NULL PRIMARY KEY,
    ID_NHANVIEN INT,
    THOIGIAN_BATDAU DATE,
    THOIGIAN_KETTHUC DATE,
    TONG_THOIGIAN NUMBER
);


CREATE TABLE NHACUNGCAP_NGUYENLIEU_QUANLY_BEP(
    ID_NL INT NOT NULL,
    SOLUONG INT DEFAULT 1,
    ID_NCC INT NOT NULL,
    ID_QUAN_LY INT NOT NULL,
    ID_BEP INT NOT NULL,
    NGAY_NL_NHAP_KHO DATE
);

-- Tạo kiểu đối tượng NHACUNGCAP_NGUYENLIEU
CREATE TABLE NCC_NL (
    ID INT NOT NULL PRIMARY KEY,
    ID_NHA_CUNG_CAP NUMBER,
    ID_NGUYEN_LIEU NUMBER
);


CREATE TABLE GIO_LAMVIEC(
    NHANVIEN_ID INT NOT NULL,
    THOIGIAN_BD TIMESTAMP,
    THOIGIAN_KT TIMESTAMP,
    TONGGIO NUMBER
); 
ALTER TABLE GIO_LAMVIEC ADD CONSTRAINT FK_GIO_LAMVIEC 
    FOREIGN KEY (NHANVIEN_ID) REFERENCES NHAN_VIEN(ID);


ALTER TABLE NHANVIEN_LAMVIEC ADD CONSTRAINT FK_NHANVIEN_LAMVIEC FOREIGN KEY(ID_NHANVIEN) REFERENCES NHAN_VIEN(ID) ON DELETE CASCADE;

ALTER TABLE TAIKHOAN_NV ADD CONSTRAINT FK_TAI_KHOAN_NHAN_VIEN FOREIGN KEY(ID_NV) REFERENCES NHAN_VIEN(ID) ON DELETE CASCADE;

ALTER TABLE NHACUNGCAP_NGUYENLIEU_QUANLY_BEP ADD CONSTRAINT PK_NCCNLQLB PRIMARY KEY (ID_NL,ID_NCC,ID_QUAN_LY,ID_BEP);



--khoa ngoai    

--bang don hang
ALTER TABLE DON_HANG ADD CONSTRAINT FK_DON_HANG_KHACH_HANG 
    FOREIGN KEY (ID_KH) REFERENCES KHACH_HANG(ID) ON DELETE CASCADE;

    ALTER TABLE DON_HANG ADD CONSTRAINT FK_DON_HANG_CHUONG_TRINH_KM 
    FOREIGN KEY (ID_KM) REFERENCES CHUONG_TRINH_KM(ID) ON DELETE CASCADE;


    ALTER TABLE DON_HANG ADD CONSTRAINT FK_DON_HANG_NHAN_VIEN_THU_NGAN 
    FOREIGN KEY (ID_THU_NGAN) REFERENCES NHAN_VIEN(ID) ON DELETE CASCADE;




--bang Nguyen lieu mon an
ALTER TABLE NGUYEN_LIEU_MON_AN
ADD CONSTRAINT FK_NLMA_NL FOREIGN KEY (ID_NL)
REFERENCES NGUYEN_LIEU(ID) ON DELETE CASCADE;

ALTER TABLE NGUYEN_LIEU_MON_AN
ADD CONSTRAINT FK_NLMA_MON FOREIGN KEY (ID_MON)
REFERENCES MON_AN(ID) ON DELETE CASCADE;

-- bang nha cung cap nguyen lieu
ALTER TABLE NHACUNGCAP_NGUYENLIEU_QUANLY_BEP
ADD CONSTRAINT FK_NL_NCC
FOREIGN KEY (ID_NL)
REFERENCES NGUYEN_LIEU(ID) ON DELETE CASCADE;

ALTER TABLE NHACUNGCAP_NGUYENLIEU_QUANLY_BEP
ADD CONSTRAINT FK_NL_QUANLY
FOREIGN KEY (ID_QUAN_LY)
REFERENCES NHAN_VIEN(ID) ON DELETE CASCADE;

ALTER TABLE NHACUNGCAP_NGUYENLIEU_QUANLY_BEP
ADD CONSTRAINT FK_NCC
FOREIGN KEY (ID_NCC)
REFERENCES NHA_CUNG_CAP(ID) ON DELETE CASCADE;

ALTER TABLE NCC_NL
ADD CONSTRAINT PK_NCC_NL
FOREIGN KEY (ID_NHA_CUNG_CAP)
REFERENCES NHA_CUNG_CAP(ID) ON DELETE CASCADE;


ALTER TABLE NCC_NL
ADD CONSTRAINT PK_NCC_NLL
FOREIGN KEY (ID_NGUYEN_LIEU)
REFERENCES NGUYEN_LIEU(ID) ON DELETE CASCADE;


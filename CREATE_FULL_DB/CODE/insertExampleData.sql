CREATE DIRECTORY DIRECT_OF_IMAGE AS 'lead the path of the IMAGE FOLDER HERE';

CREATE OR REPLACE PROCEDURE THEM_MON_AN (
    P_ID IN NUMBER,
    P_TEN_MON IN NVARCHAR2,
    P_MO_TA IN NVARCHAR2,
    P_LOAI IN NVARCHAR2,
    P_GIA IN NUMBER,
    P_IMAGE_DIR IN VARCHAR2 := 'DIRECT_OF_IMAGE'
) IS
    L_BLOB BLOB;
    L_BFILE BFILE;
    L_DEST_OFFSET INTEGER := 1;
    L_SRC_OFFSET INTEGER := 1;
    L_LOBMAXSIZE CONSTANT INTEGER := DBMS_LOB.LOBMAXSIZE;
    L_IMAGE_NAME VARCHAR2(100);
BEGIN
    -- generate image file name based on food item name
    L_IMAGE_NAME := REPLACE(P_TEN_MON, ' ', '_') || '.png';

    -- insert food item data into table
    INSERT INTO MON_AN (
        ID,
        TEN_MON,
        MO_TA,
        LOAI,
        GIA,
        HINH_ANH
    ) VALUES (
        P_ID,
        P_TEN_MON,
        P_MO_TA,
        P_LOAI,
        P_GIA,
        EMPTY_BLOB()
    ) RETURN HINH_ANH INTO L_BLOB;

    -- open image file and load image data into BLOB column
    L_BFILE := BFILENAME(P_IMAGE_DIR, L_IMAGE_NAME);
    DBMS_LOB.FILEOPEN(L_BFILE, DBMS_LOB.FILE_READONLY);
    DBMS_LOB.LOADBLOBFROMFILE(L_BLOB, L_BFILE, L_LOBMAXSIZE, L_DEST_OFFSET, L_SRC_OFFSET);
    DBMS_LOB.FILECLOSE(L_BFILE);

    -- display size of image data and commit changes
    DBMS_OUTPUT.PUT_LINE('SIZE OF THE IMAGE IS: ' || DBMS_LOB.GETLENGTH(L_BLOB));
    COMMIT;

END;


DECLARE
   v_mon_an_id INTEGER := 1;
BEGIN
   THEM_MON_AN(v_mon_an_id, 'Hamburger', 'món bánh mì kẹp thịt bò, rau và sốt, thường được kết hợp với khoai tây chiên.', 'do an',10);
   v_mon_an_id := v_mon_an_id + 1;
   THEM_MON_AN(v_mon_an_id, 'Chicken nuggets', 'thịt gà chiên giòn nhỏ có hình dáng khác nhau.', 'do an', 20);
   v_mon_an_id := v_mon_an_id + 1;
   THEM_MON_AN(v_mon_an_id, 'Pizza', 'bánh pizza với nhiều loại nhân khác nhau, như xúc xích, thịt hun khói, rau, nấm và phô mai.', 'do an',10);
   v_mon_an_id := v_mon_an_id + 1;
   THEM_MON_AN(v_mon_an_id, 'French fries', 'khoai tây chiên giòn.', 'do an',20);
   v_mon_an_id := v_mon_an_id + 1;
   THEM_MON_AN(v_mon_an_id, 'Tacos', 'bánh mì bằng bột mỳ bên trong có thịt bò hoặc gà, rau và sốt.', 'do an',15);
   v_mon_an_id := v_mon_an_id + 1;
   THEM_MON_AN(v_mon_an_id, 'Hot dogs', 'bánh mì kẹp xúc xích, thường được phục vụ với nước sốt cà chua và khoai tây chiên.', 'do an',10);
   v_mon_an_id := v_mon_an_id + 1;
   THEM_MON_AN(v_mon_an_id, 'Burritos', 'bánh mì bằng bột mỳ bên trong có thịt bò hoặc gà, rau, quả bơ và sốt.', 'do an',20);
   v_mon_an_id := v_mon_an_id + 1;
   THEM_MON_AN(v_mon_an_id, 'Sandwiches', 'bánh mì kẹp thịt, rau và sốt.', 'do an',11);
   v_mon_an_id := v_mon_an_id + 1;
   THEM_MON_AN(v_mon_an_id, 'Milkshakes', 'nước sốt pha chế với sữa và kem.', 'do uong',15);
   v_mon_an_id := v_mon_an_id + 1;
   THEM_MON_AN(v_mon_an_id, 'Fish and chips', 'tôm và khoai tây chiên giòn, thường được phục vụ với sốt tartar.', 'do an',18);
   v_mon_an_id := v_mon_an_id + 1;
   THEM_MON_AN(v_mon_an_id, 'Onion rings', 'những chiếc nhẫn hành chiên giòn.', 'do an',12);
   v_mon_an_id := v_mon_an_id + 1;
   THEM_MON_AN(v_mon_an_id, 'Fried shrimp', 'tôm chiên giòn.', 'do an',17);
   v_mon_an_id := v_mon_an_id + 1;
   THEM_MON_AN(v_mon_an_id, 'Coffee', 'Một loại đồ uống phổ biến trên toàn cầu được pha từ hạt cà phê rang và nước nóng hoặc đá. Cà phê có vị đắng và có thể được ăn kèm với đường hoặc sữa.', 'do uong',8);
v_mon_an_id := v_mon_an_id + 1;
THEM_MON_AN(v_mon_an_id, 'Tea', 'Một loại đồ uống được pha từ lá trà và nước nóng hoặc lạnh. Trà có nhiều loại khác nhau, bao gồm trà đen, trà xanh và trà hoa cúc.', 'do uong',9);
v_mon_an_id := v_mon_an_id + 1;
THEM_MON_AN(v_mon_an_id, 'Orange juice', 'Một loại đồ uống được làm từ cam ép và nước hoặc đường để tăng thêm hương vị.', 'do uong',12);
v_mon_an_id := v_mon_an_id + 1;
THEM_MON_AN(v_mon_an_id, 'Soy milk', 'Một loại đồ uống được làm từ đậu nành, nước và đường. Sữa đậu nành có vị ngọt và giàu chất dinh dưỡng.', 'do uong',15);
END;






--them du lieu mau

--------------------------------------------------------------------------------
INSERT INTO KHACH_HANG(ID, SO_DIEN_THOAI, NGAY_THAM_GIA, TEN)
VALUES (1, '0987654321', TO_DATE('2022-01-01', 'YYYY-MM-DD'), 'Nguyen Van A');

INSERT INTO KHACH_HANG(ID, SO_DIEN_THOAI, NGAY_THAM_GIA, TEN)
VALUES (2, '0123456789', TO_DATE('2022-02-01', 'YYYY-MM-DD'), 'Tran Thi B');
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
INSERT INTO NGUYEN_LIEU (ID, TEN, DON_VI, SO_LUONG_TRONG_KHO, GIA_NL)
VALUES (1, 'Thịt bò', 'Kg', 50, 5);

INSERT INTO NGUYEN_LIEU (ID, TEN, DON_VI, SO_LUONG_TRONG_KHO, GIA_NL)
VALUES (2, 'Gà', 'Kg', 30, 4);

INSERT INTO NGUYEN_LIEU (ID, TEN, DON_VI, SO_LUONG_TRONG_KHO, GIA_NL)
VALUES (3, 'Tôm', 'Kg', 40, 6);

INSERT INTO NGUYEN_LIEU (ID, TEN, DON_VI, SO_LUONG_TRONG_KHO, GIA_NL)
VALUES (4, 'Hành tây', 'Củ', 20, 1);

INSERT INTO NGUYEN_LIEU (ID, TEN, DON_VI, SO_LUONG_TRONG_KHO, GIA_NL)
VALUES (5, 'Bột mỳ', 'Gói', 100, 1);


   INSERT INTO NGUYEN_LIEU (ID, TEN, DON_VI, SO_LUONG_TRONG_KHO, GIA_NL)
   VALUES (7, 'Thịt bò', 'Kg', 50, 150000);

   INSERT INTO NGUYEN_LIEU (ID, TEN, DON_VI, SO_LUONG_TRONG_KHO, GIA_NL)
   VALUES (8, 'Bánh mì', 'Cái', 100, 10000);

   INSERT INTO NGUYEN_LIEU (ID, TEN, DON_VI, SO_LUONG_TRONG_KHO, GIA_NL)
   VALUES (9, 'Rau xà lách', 'Cái', 30, 5000);

   INSERT INTO NGUYEN_LIEU (ID, TEN, DON_VI, SO_LUONG_TRONG_KHO, GIA_NL)
   VALUES (10, 'Cà chua', 'Quả', 40, 3000);

   INSERT INTO NGUYEN_LIEU (ID, TEN, DON_VI, SO_LUONG_TRONG_KHO, GIA_NL)
   VALUES (11, 'Hành tây', 'Quả', 20, 2000);





--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
INSERT INTO CHUONG_TRINH_KM (ID, MO_TA, NGAY_BAT_DAU, NGAY_KET_THUC, MA_GIAM_GIA, PHAN_TRAM_GIAM_GIA)
VALUES (1, 'Giảm giá 10% cho đơn hàng trên 1 triệu đồng', SYSDATE, SYSDATE+30, 'GIAM10', 10);

INSERT INTO CHUONG_TRINH_KM (ID, MO_TA, NGAY_BAT_DAU, NGAY_KET_THUC, MA_GIAM_GIA, PHAN_TRAM_GIAM_GIA)
VALUES (2, 'Miễn phí vận chuyển cho đơn hàng trên 500 ngàn đồng', SYSDATE-10, SYSDATE+20, 'FREESHIP', 0);
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
INSERT INTO NHA_CUNG_CAP(ID, TEN, SO_DIEN_THOAI, EMAIL, DIA_CHI)
VALUES (1, 'Nhà cung cấp thịt bò XYZ', '0987654321', 'thitboxyz@gmail.com', '123 Đường ABC, Quận 1, TP. Hồ Chí Minh');

INSERT INTO NHA_CUNG_CAP(ID, TEN, SO_DIEN_THOAI, EMAIL, DIA_CHI)
VALUES (2, 'Nhà cung cấp rau xanh ABC', '0123456789', 'rauxanhabc@gmail.com', '456 Đường DEF, Quận 2, TP. Hồ Chí Minh');

INSERT INTO NHA_CUNG_CAP(ID, TEN, SO_DIEN_THOAI, EMAIL, DIA_CHI)
VALUES (3, 'Nhà cung cấp sốt GHI', '0987654321', 'sotghi@gmail.com', '789 Đường GHI, Quận 3, TP. Hồ Chí Minh');

INSERT INTO NHA_CUNG_CAP(ID, TEN, SO_DIEN_THOAI, EMAIL, DIA_CHI)
VALUES (4, 'Nhà cung cấp thịt xúc xích JK', '0123456789', 'thitxucxichjk@gmail.com', '1011 Đường JKL, Quận 4, TP. Hồ Chí Minh');

INSERT INTO NHA_CUNG_CAP(ID, TEN, SO_DIEN_THOAI, EMAIL, DIA_CHI)
VALUES (5, 'Nhà cung cấp sốt cà chua MNO', '0987654321', 'sotcachua.mno@gmail.com', '1213 Đường MNO, Quận 5, TP. Hồ Chí Minh');
--------------------------------------------------------------------------------
INSERT INTO NHAN_VIEN (ID, TEN, SO_DIEN_THOAI, CHUC_VU, LUONG, ID_QUAN_LY) VALUES
  (1, 'Nguyen Van A', '0987654321', 'Quản lý', 15000000, NULL);

INSERT INTO NHAN_VIEN (
    ID,
    TEN,
    SO_DIEN_THOAI,
    CHUC_VU,
    LUONG,
    ID_QUAN_LY
) VALUES (
    2,
    'Tran Thi B',
    '0912345678',
    'Đầu bếp',
    12000000,
    1
);

INSERT INTO NHAN_VIEN (
    ID,
    TEN,
    SO_DIEN_THOAI,
    CHUC_VU,
    LUONG,
    ID_QUAN_LY
) VALUES (
    3,
    'Le Van C',
    '0965432198',
    'Thu ngân',
    8000000,
    1
);

INSERT INTO NHAN_VIEN (
    ID,
    TEN,
    SO_DIEN_THOAI,
    CHUC_VU,
    LUONG,
    ID_QUAN_LY
) VALUES (
    4,
    'Nguyen Thi D',
    '0932176543',
    'Thu ngân',
    8000000,
    1
);

INSERT INTO NHAN_VIEN (
    ID,
    TEN,
    SO_DIEN_THOAI,
    CHUC_VU,
    LUONG,
    ID_QUAN_LY
) VALUES (
    5,
    'Hoang Van E',
    '0987654321',
    'Quản lý',
    15000000,
    NULL
);

INSERT INTO NHAN_VIEN (
    ID,
    TEN,
    SO_DIEN_THOAI,
    CHUC_VU,
    LUONG,
    ID_QUAN_LY
) VALUES (
    6,
    'Tran Van F',
    '0912345678',
    'Đầu bếp',
    12000000,
    5
);

INSERT INTO NHAN_VIEN (
    ID,
    TEN,
    SO_DIEN_THOAI,
    CHUC_VU,
    LUONG,
    ID_QUAN_LY
) VALUES (
    7,
    'Le Thi G',
    '0965432198',
    'Thu ngân',
    8000000,
    5
);

INSERT INTO NHAN_VIEN (
    ID,
    TEN,
    SO_DIEN_THOAI,
    CHUC_VU,
    LUONG,
    ID_QUAN_LY
) VALUES (
    8,
    'Nguyen Van H',
    '0932176543',
    'Thu ngân',
    8000000,
    5
);

INSERT INTO NHAN_VIEN (
    ID,
    TEN,
    SO_DIEN_THOAI,
    CHUC_VU,
    LUONG,
    ID_QUAN_LY
) VALUES (
    9,
    'Pham Thi I',
    '0987654321',
    'Quản lý',
    15000000,
    NULL
);

INSERT INTO NHAN_VIEN (
    ID,
    TEN,
    SO_DIEN_THOAI,
    CHUC_VU,
    LUONG,
    ID_QUAN_LY
) VALUES (
    10,
    'Nguyen Van K',
    '0912345678',
    'Đầu bếp',
    12000000,
    9
);


 INSERT INTO TAIKHOAN_NV (USERNAME, PASSWORD, ID_NV)
    VALUES ('thib', 123, 2);

INSERT INTO NHANVIEN_LAMVIEC (
    ID,
    ID_NHANVIEN,
    THOIGIAN_BATDAU,
    THOIGIAN_KETTHUC,
    TONG_THOIGIAN
)
SELECT
    ROWNUM,
    NV.ID,
    TRUNC(SYSDATE) - (ROWNUM * 3),
    TRUNC(SYSDATE) - (ROWNUM * 3) + 7,
    56
FROM
    NHAN_VIEN NV
WHERE
    ROWNUM <= 30;


--------------------------------------------------------------------------------
INSERT INTO DON_HANG(ID, ID_KH, ID_KM, ID_THU_NGAN, TONG_TIEN, SO_BAN_TAO_DON, HINH_THUC_THANH_TOAN, TRANG_THAI, DAT_ONLINE, NGAY_DAT, GHI_CHU)
VALUES (1, 1, 1, 3, 110000, 2, 'Tiền mặt', 'Đã thanh toán', 0, TO_DATE('2023-04-14', 'YYYY-MM-DD'), 'Không có');

INSERT INTO DON_HANG(ID, ID_KH, ID_KM, ID_THU_NGAN, TONG_TIEN, SO_BAN_TAO_DON, HINH_THUC_THANH_TOAN, TRANG_THAI, DAT_ONLINE, NGAY_DAT, GHI_CHU)
VALUES (2, 2, 2, 4, 300000, 3, 'Tiền mặt', 'Đã thanh toán', 0, TO_DATE('2023-04-14', 'YYYY-MM-DD'), 'Giao hàng sớm hơn dự kiến 15 phút');

INSERT INTO DON_HANG(ID, ID_KH, ID_KM, ID_THU_NGAN, TONG_TIEN, SO_BAN_TAO_DON, HINH_THUC_THANH_TOAN, TRANG_THAI, DAT_ONLINE, NGAY_DAT, GHI_CHU)
VALUES (3, 1, NULL, 3, 90000, 1, 'Tiền mặt', 'Đã thanh toán', 0, TO_DATE('2023-04-14', 'YYYY-MM-DD'), 'Không có');

INSERT INTO DON_HANG(ID, ID_KH, ID_KM, ID_THU_NGAN, TONG_TIEN, SO_BAN_TAO_DON, HINH_THUC_THANH_TOAN, TRANG_THAI, DAT_ONLINE, NGAY_DAT, GHI_CHU)
VALUES (4, 2, NULL,  4, 250000, 2, 'Tiền mặt', 'Đã thanh toán', 0, TO_DATE('2023-04-14', 'YYYY-MM-DD'), 'Không có');

INSERT INTO DON_HANG(ID, ID_KH, ID_KM, ID_THU_NGAN, TONG_TIEN, SO_BAN_TAO_DON, HINH_THUC_THANH_TOAN, TRANG_THAI, DAT_ONLINE, NGAY_DAT, GHI_CHU)
VALUES (5, 1, NULL,  3, 150000, 2, 'Tiền mặt', 'Đã thanh toán', 1, SYSDATE, 'Ghi chú cho đơn hàng 5');
------------------------------------------------------------------------------T--

--------------------------------------------------------------------------------

--create view

INSERT INTO NGUYEN_LIEU_MON_AN (ID_NL, ID_MON, SO_LUONG)
VALUES (1, 1, 2);

INSERT INTO NGUYEN_LIEU_MON_AN (ID_NL, ID_MON, SO_LUONG)
VALUES (1, 2, 200);

INSERT INTO NGUYEN_LIEU_MON_AN (ID_NL, ID_MON, SO_LUONG)
VALUES (2, 1, 1);

INSERT INTO NGUYEN_LIEU_MON_AN (ID_NL, ID_MON, SO_LUONG)
VALUES (2, 2, 2);

INSERT INTO NGUYEN_LIEU_MON_AN (ID_NL, ID_MON, SO_LUONG)
VALUES (3, 2, 1);

INSERT INTO NGUYEN_LIEU_MON_AN (ID_NL, ID_MON, SO_LUONG)
VALUES (4, 3, 3);

INSERT INTO NGUYEN_LIEU_MON_AN (ID_NL, ID_MON, SO_LUONG)
VALUES (5, 3, 2);

INSERT INTO NGUYEN_LIEU_MON_AN (ID_NL, ID_MON, SO_LUONG)
VALUES (7, 1, 1);

INSERT INTO NGUYEN_LIEU_MON_AN (ID_NL, ID_MON, SO_LUONG)
VALUES (8, 1, 2);

INSERT INTO NGUYEN_LIEU_MON_AN (ID_NL, ID_MON, SO_LUONG)
VALUES (9, 1, 1);

INSERT INTO NGUYEN_LIEU_MON_AN (ID_NL, ID_MON, SO_LUONG)
VALUES (10, 1, 3);



-- Nhà cung cấp thịt bò XYZ cung cấp Thịt bò
INSERT INTO NCC_NL (ID, ID_NHA_CUNG_CAP, ID_NGUYEN_LIEU)
VALUES (1, 1, 1);

-- Nhà cung cấp rau xanh ABC cung cấp Hành tây
INSERT INTO NCC_NL (ID, ID_NHA_CUNG_CAP, ID_NGUYEN_LIEU)
VALUES (2, 2, 4);

-- Nhà cung cấp rau xanh ABC cung cấp Bột mỳ
INSERT INTO NCC_NL (ID, ID_NHA_CUNG_CAP, ID_NGUYEN_LIEU)
VALUES (3, 2, 5);

-- Nhà cung cấp sốt GHI cung cấp Bột mỳ
INSERT INTO NCC_NL (ID, ID_NHA_CUNG_CAP, ID_NGUYEN_LIEU)
VALUES (4, 3, 5);

-- Nhà cung cấp thịt xúc xích JK cung cấp Thịt bò
INSERT INTO NCC_NL (ID, ID_NHA_CUNG_CAP, ID_NGUYEN_LIEU)
VALUES (5, 4, 1);

-- Nhà cung cấp thịt xúc xích JK cung cấp Gà
INSERT INTO NCC_NL (ID, ID_NHA_CUNG_CAP, ID_NGUYEN_LIEU)
VALUES (6, 4, 2);

-- Nhà cung cấp sốt cà chua MNO cung cấp Tôm
INSERT INTO NCC_NL (ID, ID_NHA_CUNG_CAP, ID_NGUYEN_LIEU)
VALUES (7, 5, 3);

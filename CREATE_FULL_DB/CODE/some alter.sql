CREATE OR REPLACE VIEW XU_LY_DON_HANG AS
    SELECT
        DON_HANG.ID,
        DON_HANG.ID_KH             AS ID_KH,
        KHACH_HANG.TEN             AS TEN_KH,
        DON_HANG.ID_THU_NGAN       AS ID_TN,
        NHAN_VIEN.TEN              AS TEN_TN,
        DON_HANG.SO_BAN_TAO_DON,
        DON_HANG.TONG_TIEN,
        DON_HANG.HINH_THUC_THANH_TOAN,
        DON_HANG.TRANG_THAI,
        DON_HANG.DAT_ONLINE,
        DON_HANG.NGAY_DAT,
        DON_HANG.GHI_CHU
    FROM
        DON_HANG
        LEFT JOIN KHACH_HANG
        ON DON_HANG.ID_KH = KHACH_HANG.ID LEFT JOIN NHAN_VIEN
        ON DON_HANG.ID_THU_NGAN = NHAN_VIEN.ID;
        
CREATE OR REPLACE VIEW VIEW_THOI_GIAN_NHAN_VIEN_LAM_VIEC AS
    SELECT
        NV.ID  AS ID_NHANVIEN,
        NV.TEN AS TEN_NHANVIEN,
        SUM(NVL(NL.TONG_THOIGIAN,
        0))    AS TONG_THOIGIAN_LAMVIEC
    FROM
        NHAN_VIEN        NV
        LEFT JOIN NHANVIEN_LAMVIEC NL
        ON NV.ID = NL.ID_NHANVIEN
    WHERE
        EXTRACT(MONTH FROM NL.THOIGIAN_BATDAU) = EXTRACT(MONTH FROM SYSDATE)
        AND EXTRACT(YEAR FROM NL.THOIGIAN_BATDAU) = EXTRACT(YEAR FROM SYSDATE)
    GROUP BY
        NV.ID,
        NV.TEN;



CREATE OR REPLACE VIEW VIEW_AVALAIBLE_FOOD AS
    SELECT
        *
    FROM
        MON_AN MA,
        (
            SELECT
                ID1
            FROM
                (
                    SELECT
                        ID_MON        AS ID1,
                        COUNT(ID_MON) AS SL1
                    FROM
                        NGUYEN_LIEU_MON_AN
                        LEFT JOIN NGUYEN_LIEU
                        ON NGUYEN_LIEU_MON_AN.ID_NL = NGUYEN_LIEU.ID
                        AND NGUYEN_LIEU_MON_AN.SO_LUONG <= NGUYEN_LIEU.SO_LUONG_TRONG_KHO
                    WHERE
                        NGUYEN_LIEU.TEN IS NOT NULL
                    GROUP BY
                        ID_MON
                ) X1,
                (
                    SELECT
                        ID_MON        AS ID2,
                        COUNT(ID_MON) AS SL2
                    FROM
                        NGUYEN_LIEU_MON_AN
                    GROUP BY
                        NGUYEN_LIEU_MON_AN.ID_MON
                ) X2
            WHERE
                X1.SL1 = X2.SL2
                AND X1.ID1 = X2.ID2
        )      X
    WHERE
        X.ID1 = MA.ID;

// SỬA LẠI TABLE NHACUNGCAP_NGUYENLIEU_QUANLY_BEP
ALTER TABLE NHACUNGCAP_NGUYENLIEU_QUANLY_BEP ADD ID INT;
ALTER TABLE NHACUNGCAP_NGUYENLIEU_QUANLY_BEP DROP CONSTRAINT PK_NCCNLQLB;
DELETE FROM NHACUNGCAP_NGUYENLIEU_QUANLY_BEP;
ALTER TABLE NHACUNGCAP_NGUYENLIEU_QUANLY_BEP ADD CONSTRAINT PK_NCCNLQLB PRIMARY KEY (ID);
ALTER TABLE NHACUNGCAP_NGUYENLIEU_QUANLY_BEP ADD NGAY_VIET_PHIEU DATE;


GRANT DROP ANY DIRECTORY TO SYSTEM;
GRANT CREATE ANY DIRECTORY TO SYSTEM;
CREATE OR REPLACE PROCEDURE UPDATE_MON(IMAGE IN VARCHAR2, ID_ IN INTEGER,IMAGEPATH IN VARCHAR2) IS
  l_blob BLOB;
  l_bfile BFILE;
  l_dest_offset INTEGER := 1;
  l_src_offset INTEGER := 1;
  l_lobmaxsize CONSTANT INTEGER := DBMS_LOB.LOBMAXSIZE;
BEGIN
  EXECUTE IMMEDIATE 'CREATE DIRECTORY DIRECT AS ''' || IMAGEPATH || '''';  
  UPDATE MON_AN
  SET HINH_ANH = EMPTY_BLOB()
  WHERE ID = ID_
  RETURNING HINH_ANH INTO l_blob;
  
  l_bfile := BFILENAME('DIRECT', IMAGE);
  DBMS_LOB.FILEOPEN(l_bfile, DBMS_LOB.FILE_READONLY);
  DBMS_LOB.LOADBLOBFROMFILE(l_blob, l_bfile, l_lobmaxsize, l_dest_offset, l_src_offset);
  DBMS_LOB.FILECLOSE(l_bfile);
  DBMS_OUTPUT.PUT_LINE('SIZE OF THE IMAGE IS: ' || DBMS_LOB.GETLENGTH(l_blob));
  EXECUTE IMMEDIATE 'DROP DIRECTORY DIRECT';
  COMMIT;
END;	
/

---Món ?n
-- Thêm 
create or replace PROCEDURE THEM_MON_AN (
    P_ID IN NUMBER,
    P_TEN_MON IN NVARCHAR2,
    P_MO_TA IN NVARCHAR2,
    P_LOAI IN NVARCHAR2,
    P_TEN_ANH IN VARCHAR2
) IS
    L_BLOB BLOB;
    L_BFILE       BFILE;
    L_DEST_OFFSET INTEGER:=1;
    L_SRC_OFFSET  INTEGER:=1;
    L_LOBMAXSIZE  CONSTANT INTEGER := DBMS_LOB.LOBMAXSIZE;
BEGIN
    INSERT INTO MON_AN (
        ID,
        TEN_MON,
        MO_TA,
        LOAI,
        HINH_ANH
    ) VALUES (
        P_ID,
        P_TEN_MON,
        P_MO_TA,
        P_LOAI,
        EMPTY_BLOB()
    ) RETURN HINH_ANH INTO L_BLOB;
    L_BFILE := BFILENAME('ANH_MON_AN', P_TEN_ANH);
    DBMS_LOB.FILEOPEN(L_BFILE, DBMS_LOB.FILE_READONLY);
    DBMS_LOB.LOADBLOBFROMFILE (L_BLOB, L_BFILE, L_LOBMAXSIZE, L_DEST_OFFSET, L_SRC_OFFSET);
    DBMS_LOB.FILECLOSE(L_BFILE);
    DBMS_OUTPUT.PUT_LINE('SIZE OF THE IMAGE IS: '
        || DBMS_LOB.GETLENGTH(L_BLOB));
    COMMIT;
END;

-- C?p nh?t 
create or replace PROCEDURE UPDATE_MON_AN (
    P_ID IN NUMBER,
    P_TEN_MON IN NVARCHAR2,
    P_MO_TA IN NVARCHAR2,
    P_LOAI IN NVARCHAR2,
    P_TEN_ANH IN VARCHAR2
) IS
    L_BLOB BLOB;
    L_BFILE BFILE;
    L_DEST_OFFSET INTEGER:=1;
    L_SRC_OFFSET INTEGER:=1;
    L_LOBMAXSIZE CONSTANT INTEGER := DBMS_LOB.LOBMAXSIZE;
BEGIN
    UPDATE MON_AN SET
        TEN_MON = P_TEN_MON,
        MO_TA = P_MO_TA,
        LOAI = P_LOAI,
        HINH_ANH = EMPTY_BLOB()
    WHERE ID = P_ID
    RETURNING HINH_ANH INTO L_BLOB;

    L_BFILE := BFILENAME('ANH_MON_AN', P_TEN_ANH);
    DBMS_LOB.FILEOPEN(L_BFILE, DBMS_LOB.FILE_READONLY);
    DBMS_LOB.LOADBLOBFROMFILE(L_BLOB, L_BFILE, L_LOBMAXSIZE, L_DEST_OFFSET, L_SRC_OFFSET);
    DBMS_LOB.FILECLOSE(L_BFILE);

    DBMS_OUTPUT.PUT_LINE('SIZE OF THE IMAGE IS: ' || DBMS_LOB.GETLENGTH(L_BLOB));
    COMMIT;
END;

-- Xóa
CREATE OR REPLACE PROCEDURE XOA_MON_AN(
   p_id IN MON_AN.ID%TYPE
)
IS
BEGIN
   DELETE FROM MON_AN
   WHERE ID = p_id;
END;
---Xuat cac mon mon an co the nau dua vao nguyen lieu trong kho (id,soluong)
---xuat ra man hinh id va so luong mon an co the nau va con tro chua id,soluong moanan
create or replace PROCEDURE MON_AN_FROM_NGUYEN_LIEU(P_CUR OUT SYS_REFCURSOR) AS
    V_ID number;
    V_SO_LUONG NGUYEN_LIEU_MON_AN.SO_LUONG%TYPE;
BEGIN
    OPEN P_CUR FOR
        SELECT NLM.ID_MON, MIN(NL.SO_LUONG_TRONG_KHO / NLM.SO_LUONG) 
        FROM NGUYEN_LIEU_MON_AN NLM, NGUYEN_LIEU NL 
        where NL.ID = NLM.ID_NL
        GROUP BY NLM.ID_MON;
    loop
     fetch p_cur into v_id,v_so_luong;
       exit when p_cur%NOTFOUND;
       DBMS_OUTPUT.PUT_LINE('ID_MON: ' || V_ID || ', SO_LUONG_MON_AN: ' || V_SO_LUONG);
    end loop;
    close P_CUR;
end;

--- b?ng NHAN_VIEN
-- Thêm
CREATE OR REPLACE PROCEDURE InsertNhanVien(
    p_ID IN NUMBER,
    p_TEN IN VARCHAR2,
    p_SO_DIEN_THOAI IN VARCHAR2,
    p_CHUC_VU IN VARCHAR2,
    p_LUONG IN NUMBER,
    p_ID_QUAN_LY IN NUMBER
) AS
BEGIN
    -- Thực hiện câu lệnh INSERT INTO để chèn dữ liệu vào bảng NHAN_VIEN
    INSERT INTO NHAN_VIEN (ID, TEN, SO_DIEN_THOAI, CHUC_VU, LUONG, ID_QUAN_LY)
    VALUES (p_ID, p_TEN, p_SO_DIEN_THOAI, p_CHUC_VU, p_LUONG, p_ID_QUAN_LY);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Đã chèn dữ liệu vào bảng NHAN_VIEN thành công');
    
    -- Thực hiện câu lệnh INSERT INTO để chèn dữ liệu vào bảng TAIKHOAN_NV
    INSERT INTO TAIKHOAN_NV (username, password, id_nv)
    VALUES (p_TEN, p_TEN, p_ID);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Đã tạo tài khoản thành công');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Có lỗi xảy ra trong quá trình chèn dữ liệu');
        ROLLBACK;
END;
/

-- C?p nh?t
CREATE OR REPLACE PROCEDURE CAP_NHAT_NHAN_VIEN(
   p_id IN NHAN_VIEN.ID%TYPE,
   p_ten IN NHAN_VIEN.TEN%TYPE,
   p_don_vi IN NHAN_VIEN.DON_VI%TYPE,
   p_so_dien_thoai IN NHAN_VIEN.SO_DIEN_THOAI%TYPE,
   p_chuc_vu IN NHAN_VIEN.CHUC_VU%TYPE,
   p_id_quan_ly IN NHAN_VIEN.ID_QUAN_LY%TYPE
)
IS
BEGIN
   UPDATE NHAN_VIEN SET TEN = p_ten, DON_VI = p_don_vi, SO_DIEN_THOAI = p_so_dien_thoai, CHUC_VU = p_chuc_vu, ID_QUAN_LY = p_id_quan_ly 
   WHERE ID = p_id;
END;

-- Xóa
    p_ID IN NUMBER
) AS
BEGIN
    DELETE FROM TAIKHOAN_NV WHERE id_nv = p_ID;
    
    DELETE FROM NHAN_VIEN WHERE ID = p_ID;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('da xoa nhan vien va tai khoan nhan vien thanh cong');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('da co loi xay ra');
        ROLLBACK;
END;
/

--Nguyen lieu mon
--procedure chinh sua nguyen lieu mon
CREATE OR REPLACE PROCEDURE EDITNLOFMON(
    ID_MON IN NUMBER,
    ID_NL IN NUMBER,
    SOLUONG IN NUMBER
) AS
BEGIN
    UPDATE NGUYEN_LIEU_MON_AN
    SET
        SO_LUONG=SOLUONG
    WHERE
        ID_MON=ID_MON
        AND ID_NL=ID_NL;
END;
/

--bang voucher


--procedure them voucher
CREATE OR REPLACE PROCEDURE INSVC(
    ID_ IN NUMBER,
    MOTA IN VARCHAR2,
    PHANTRAMGIAMGIA IN VARCHAR2,
    MAGIAMGIA IN VARCHAR2,
    NGAYBATDAU IN DATE,
    NGAYKETTHUC IN DATE
) AS
BEGIN
    INSERT INTO CHUONG_TRINH_KM (
        ID,
        MO_TA,
        NGAY_BAT_DAU,
        NGAY_KET_THUC,
        MA_GIAM_GIA,
        PHAN_TRAM_GIAM_GIA
    ) VALUES (
        ID_,
        MOTA,
        NGAYBATDAU,
        NGAYKETTHUC,
        MAGIAMGIA,
        PHANTRAMGIAMGIA
    );
END;
/

--procedure update voucher
CREATE OR REPLACE PROCEDURE UPTVC(
    ID_ IN NUMBER,
    MOTA IN VARCHAR2,
    PHANTRAMGIAMGIA IN VARCHAR2,
    MAGIAMGIA IN VARCHAR2,
    NGAYBATDAU IN DATE,
    NGAYKETTHUC IN DATE
) AS
BEGIN
    UPDATE CHUONG_TRINH_KM
    SET
        MO_TA=MOTA,
        NGAY_BAT_DAU=NGAYBATDAU,
        NGAY_KET_THUC=NGAYKETTHUC,
        MA_GIAM_GIA=MAGIAMGIA,
        PHAN_TRAM_GIAM_GIA=PHANTRAMGIAMGIA
    WHERE
        ID=ID_;
END;
/

--bang nha cung cap
--procedure them nha cung cap
CREATE OR REPLACE PROCEDURE INSNCC(
    ID_ IN NUMBER,
    TEN IN VARCHAR2,
    SDT IN VARCHAR2,
    EMAIL IN VARCHAR2,
    DIACHI IN VARCHAR2
) AS
BEGIN
    INSERT INTO NHA_CUNG_CAP (
        ID,
        TEN,
        SO_DIEN_THOAI,
        EMAIL,
        DIA_CHI
    ) VALUES (
        ID_,
        TEN,
        SDT,
        EMAIL,
        DIACHI
    );
END;
/
--procedure sua nha cung cap
CREATE OR REPLACE PROCEDURE UPTNCC(
    ID_ IN NUMBER,
    TEN IN VARCHAR2,
    SDT IN VARCHAR2,
    EMAIL IN VARCHAR2,
    DIACHI IN VARCHAR2
) AS
BEGIN
    UPDATE NHA_CUNG_CAP
    SET
        TEN=TEN,
        SO_DIEN_THOAI=SDT,
        EMAIL=EMAIL,
        DIA_CHI=DIACHI
    WHERE
        ID=ID_;
END;
/

--bang nguyen lieu

--procedure them Nl
CREATE OR REPLACE PROCEDURE INSNL(
    ID_ IN NUMBER,
    TEN IN VARCHAR2,
    DONVI IN VARCHAR2,
    SL IN NUMBER,
    GIA IN NUMBER
) AS
BEGIN
    INSERT INTO NGUYEN_LIEU (
        ID,
        TEN,
        DON_VI,
        SO_LUONG_TRONG_KHO,
        GIA_NL
    ) VALUES (
        ID_,
        TEN,
        DONVI,
        SL,
        GIA
    );
END;
/
--procedure sua nL
CREATE OR REPLACE PROCEDURE uptNL(
    ID_ IN NUMBER,
    TEN IN VARCHAR2,
    DONVI IN VARCHAR2,
    SL IN NUMBER,
    GIA IN NUMBER
) AS
BEGIN
    UPDATE NGUYEN_LIEU
    SET
        TEN=TEN,
        DON_VI=DONVI,
        SO_LUONG_TRONG_KHO=SL,
        GIA_NL=GIA
    WHERE
        ID=ID_;
END;
/

--Procedure nau mon an
CREATE OR REPLACE PROCEDURE UpdateNguyenLieu(
    p_ID_MON IN NUMBER
) AS
    v_ID_NL NGUYEN_LIEU_MON_AN.ID_NL%TYPE;
    v_SO_LUONG NGUYEN_LIEU_MON_AN.SO_LUONG%TYPE;
BEGIN
    -- Lấy ID_NL và SO_LUONG từ bảng NGUYEN_LIEU_MON_AN dựa trên ID_MON
    SELECT ID_NL, SO_LUONG INTO v_ID_NL, v_SO_LUONG
    FROM NGUYEN_LIEU_MON_AN
    WHERE ID_MON = p_ID_MON;

    -- Cập nhật bảng NGUYEN_LIEU bằng cách giảm SO_LUONG_TRONG_KHO
    UPDATE NGUYEN_LIEU
    SET SO_LUONG_TRONG_KHO = SO_LUONG_TRONG_KHO - v_So_Luong
    WHERE ID = v_ID_NL;
    
    COMMIT;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Khong tim thay nguyen lieu tuong ung voi mon an');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Co loi xay ra trong qua trinh cap nhat');
        ROLLBACK;
END;
/

--bang donhang

--Procedure update trang thai don hang cho dau bep
CREATE OR REPLACE PROCEDURE UpdateDonHangForChef(
    p_TRANG_THAI IN VARCHAR2,
    p_ID IN NUMBER
) AS
BEGIN
    UPDATE DON_HANG
    SET TRANG_THAI = p_TRANG_THAI
    WHERE ID = p_ID;    
    COMMIT;    
    DBMS_OUTPUT.PUT_LINE('cap nhat thanh cong');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('da co loi xay ra');
        ROLLBACK;
END;
/


--Procedure update trang thai don hang cho thu ngan
CREATE OR REPLACE PROCEDURE UpdateDonHang(
    p_TRANG_THAI IN VARCHAR2,
    p_HINH_THUC_THANH_TOAN IN VARCHAR2,
    p_ID IN NUMBER
) AS
BEGIN
    UPDATE DON_HANG
    SET TRANG_THAI = p_TRANG_THAI,
        HINH_THUC_THANH_TOAN = p_HINH_THUC_THANH_TOAN
    WHERE ID = p_ID;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('cap nhat thanh cong');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('da co loi xay ra');
        ROLLBACK;
END;

/

--Procedure them don hang
CREATE OR REPLACE PROCEDURE INSERT_DON_HANG (
    P_ID IN DON_HANG.ID%TYPE,
    P_ID_KH IN DON_HANG.ID_KH%TYPE,
    P_ID_KM IN DON_HANG.ID_KM%TYPE,
    P_ID_THU_NGAN IN DON_HANG.ID_THU_NGAN%TYPE,
    P_TONG_TIEN IN DON_HANG.TONG_TIEN%TYPE,
    P_SO_BAN IN DON_HANG.SO_BAN_TAO_DON%TYPE,
    P_HINH_THUC IN DON_HANG.HINH_THUC_THANH_TOAN%TYPE,
    P_TRANG_THAI IN DON_HANG.TRANG_THAI%TYPE,
    P_DAT_ONLINE IN DON_HANG.DAT_ONLINE%TYPE,
    P_NGAY_DAT IN DON_HANG.NGAY_DAT%TYPE,
    P_GHI_CHU IN DON_HANG.GHI_CHU%TYPE
) AS
BEGIN
    INSERT INTO DON_HANG (
        ID,
        ID_KH,
        ID_KM,
        ID_THU_NGAN,
        TONG_TIEN,
        SO_BAN_TAO_DON,
        HINH_THUC_THANH_TOAN,
        TRANG_THAI,
        DAT_ONLINE,
        NGAY_DAT,
        GHI_CHU
    ) VALUES (
        P_ID,
        P_ID_KH,
        P_ID_KM,
        P_ID_THU_NGAN,
        P_TONG_TIEN,
        P_SO_BAN,
        P_HINH_THUC,
        P_TRANG_THAI,
        P_DAT_ONLINE,
        P_NGAY_DAT,
        P_GHI_CHU
    );
    COMMIT;
END;
/

--bang chi tiet don
--Procedure them chi tiet don
CREATE OR REPLACE PROCEDURE InsertChitietDon (
    p_ID_DON IN NUMBER,
    p_ID_MON IN NUMBER,
    p_SOLUONG IN NUMBER
) AS
BEGIN
    INSERT INTO CHITIET_DON (ID_DON, ID_MON, SOLUONG)
    VALUES (p_ID_DON, p_ID_MON, p_SOLUONG);
    COMMIT;
END;
/

--bang nhacungcap_nguyenlieu_quanly_bep hay con goi la phieu dat nguyen lieu

--Procedure them phieu dat nguyen lieu
CREATE OR REPLACE PROCEDURE InsertRequest (
    p_ID_NL IN NUMBER,
    p_ID_NCC IN NUMBER,
    p_ID_QUAN_LY IN NUMBER,
    p_ID_BEP IN NUMBER,
    p_TONG_TIEN IN NUMBER,
    p_SOLUONG IN NUMBER,
    p_NGAY_NL_NHAP_KHO IN DATE
) AS
p_maxid NUMBER;
BEGIN
    SELECT MAX(ID) INTO p_maxid FROM NHACUNGCAP_NGUYENLIEU_QUANLY_BEP;
    p_maxid:=p_maxid+1;
    INSERT INTO NHACUNGCAP_NGUYENLIEU_QUANLY_BEP (
        ID, ID_NL, ID_NCC, ID_QUAN_LY, ID_BEP, TONG_TIEN, SOLUONG,
        NGAY_NL_NHAP_KHO, NGAY_VIET_PHIEU
    )
    VALUES (
        p_maxid, p_ID_NL, p_ID_NCC, p_ID_QUAN_LY, p_ID_BEP, p_TONG_TIEN, p_SOLUONG,
        p_NGAY_NL_NHAP_KHO, SYSDATE
    );
END;
/

--bang ncc_nl

--Procedure update ncc_nl
CREATE OR REPLACE PROCEDURE UpdateNccNl(
    p_TEN_NGUYEN_LIEU IN VARCHAR2,
    p_ID_NHA_CUNG_CAP IN NUMBER
) AS
    v_ID_NGUYEN_LIEU NGUYEN_LIEU.ID%TYPE;
BEGIN
    SELECT ID INTO v_ID_NGUYEN_LIEU
    FROM NGUYEN_LIEU
    WHERE TEN = p_TEN_NGUYEN_LIEU;
    UPDATE NCC_NL
    SET ID_NGUYEN_LIEU = v_ID_NGUYEN_LIEU
    WHERE ID_NHA_CUNG_CAP = p_ID_NHA_CUNG_CAP;

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('khong tim thay nguyen lieu cua nha cung cap tuong ung');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('da xay ra loi');
        ROLLBACK;
END;
/

--Procedure Insert NCC_NL
CREATE OR REPLACE PROCEDURE InsertNccNl(
    p_ID IN NUMBER,
    p_ID_NHA_CUNG_CAP IN NUMBER,
    p_ID_NGUYEN_LIEU IN NUMBER
) AS
BEGIN
    INSERT INTO NCC_NL (ID, ID_NHA_CUNG_CAP, ID_NGUYEN_LIEU)
    VALUES (p_ID, p_ID_NHA_CUNG_CAP, p_ID_NGUYEN_LIEU);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('da them moi thanh cong');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('da co loi xay ra');
        ROLLBACK;
END;
/


--bang nha cung cap

--Procedure xoa ncc
CREATE OR REPLACE PROCEDURE DeleteNhaCungCap(
    p_ID_NHA_CUNG_CAP IN NUMBER
) AS
BEGIN
    DELETE FROM NCC_NL
    WHERE ID_NHA_CUNG_CAP = p_ID_NHA_CUNG_CAP;

    DELETE FROM NHA_CUNG_CAP
    WHERE ID = p_ID_NHA_CUNG_CAP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('xoa ncc thanh cong');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('da co loi xay ra');
        ROLLBACK;
END;
/




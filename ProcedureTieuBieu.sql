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
CREATE OR REPLACE PROCEDURE THEM_NHAN_VIEN(
   p_id NHAN_VIEN.ID%TYPE,
   p_ten IN NHAN_VIEN.TEN%TYPE,
   p_don_vi IN NHAN_VIEN.DON_VI%TYPE,
   p_so_dien_thoai IN NHAN_VIEN.SO_DIEN_THOAI%TYPE,
   p_chuc_vu IN NHAN_VIEN.CHUC_VU%TYPE,
   p_id_quan_ly IN NHAN_VIEN.ID_QUAN_LY%TYPE
)
IS
BEGIN
   SELECT NHAN_VIEN_SEQ.NEXTVAL INTO v_id FROM DUAL;
   INSERT INTO NHAN_VIEN(ID, TEN, DON_VI, SO_DIEN_THOAI, CHUC_VU, ID_QUAN_LY) 
   VALUES (v_id, p_ten, p_don_vi, p_so_dien_thoai, p_chuc_vu, p_id_quan_ly);
END;

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
CREATE OR REPLACE PROCEDURE XOA_NHAN_VIEN(
   p_id IN NHAN_VIEN.ID%TYPE
)
IS
BEGIN
   DELETE FROM NHAN_VIEN 
   WHERE ID = p_id;
END;

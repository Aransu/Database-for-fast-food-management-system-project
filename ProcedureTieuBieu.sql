---Món ?n
-- Thêm 
CREATE OR REPLACE PROCEDURE THEM_MON_AN(
    p_id IN MON_AN.ID%TYPE,
   p_ten_mon IN MON_AN.TEN_MON%TYPE,
   p_mo_ta IN MON_AN.MO_TA%TYPE,
   p_loai IN MON_AN.LOAI%TYPE,
   p_hinh_anh IN BLOB
)
IS
BEGIN
   INSERT INTO MON_AN(ID, TEN_MON, MO_TA, LOAI, HINH_ANH) 
   VALUES (p_id, p_ten_mon, p_mo_ta, p_loai, p_hinh_anh);
END;

-- C?p nh?t 
CREATE OR REPLACE PROCEDURE CAP_NHAT_MON_AN(
   p_id IN MON_AN.ID%TYPE,
   p_ten_mon IN MON_AN.TEN_MON%TYPE,
   p_mo_ta IN MON_AN.MO_TA%TYPE,
   p_loai IN MON_AN.LOAI%TYPE,
   p_hinh_anh IN BLOB
)
IS
BEGIN
   UPDATE MON_AN SET TEN_MON = p_ten_mon, MO_TA = p_mo_ta, LOAI = p_loai, HINH_ANH = p_hinh_anh 
   WHERE ID = p_id;
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
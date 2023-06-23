CREATE OR REPLACE TRIGGER CHECk_CHUC_VU
BEFORE INSERT OR UPDATE ON NHAN_VIEN
FOR EACH ROW
BEGIN 
    IF (:NEW.CHUC_VU NOT IN ('Đầu bếp','Quản lý','Thu ngân')) THEN
    RAISE_APPLICATION_ERROR(-20000,'CHUC VU CUA NHAN VIEN PHAI LA BEP HOAC QUAN_LY HOAC THU_NGAN');
    END IF;
END;

CREATE OR REPLACE TRIGGER CHECK_DAT_ONLINE
BEFORE INSERT OR UPDATE ON DON_HANG
FOR EACH ROW
BEGIN 
    IF( :NEW.DAT_ONLINE NOT IN (1,0)) THEN
    RAISE_APPLICATION_ERROR(-20000,'Trang thai dat online chi co the la 1 hoac 0');
    END IF;
END;   



CREATE OR REPLACE TRIGGER CHECK_QUAN_LY 
BEFORE INSERT OR UPDATE ON NHAN_VIEN 
FOR EACH ROW
DECLARE
  cnt NUMBER;
BEGIN 
  SELECT COUNT(*) INTO cnt FROM NHAN_VIEN WHERE ID = :NEW.ID_QUAN_LY;
  IF(cnt = 0 AND :NEW.CHUC_VU!='Quản lý') THEN
    RAISE_APPLICATION_ERROR(-20000,'Nhan vien quan ly phai la 1 nhan vien (id cua nhan vien quan ly phai nam trong id cua nhan vien)');
  END IF;
END;


CREATE OR REPLACE TRIGGER CHECK_SO_BAN
BEFORE INSERT OR UPDATE ON DON_HANG
FOR EACH ROW
DECLARE
TOTAL NUMBER;
BEGIN 
    SELECT DISTINCT COUNT(SO_BAN_TAO_DON) INTO TOTAL FROM DON_HANG;
    IF(TOTAL >=30) THEN
    RAISE_APPLICATION_ERROR(-20000,'Hien quan da het ban xin quy khach vui long doi den khi co ban trong');
    END IF;
END;


CREATE OR REPLACE TRIGGER CHECK_DANG_QUAN_LY
BEFORE DELETE ON NHAN_VIEN
FOR EACH ROW
DECLARE 
TOTAL INT:=0;
BEGIN
    IF:OLD.CHUC_VU='Quản lý' THEN
    SELECT COUNT(*) INTO TOTAL FROM NHAN_VIEN WHERE id_quan_ly=:OLD.id;
    IF TOTAL > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Không thể xóa quản lý đang quản lý nhân viên!');
    END IF;
  END IF;
END;



CREATE OR REPLACE TRIGGER UPDATE_SO_LUONG_TRONG_KHO  
AFTER INSERT ON NHACUNGCAP_NGUYENLIEU_QUANLY_BEP  
FOR EACH ROW  
BEGIN  
    UPDATE NGUYEN_LIEU  
    SET SO_LUONG_TRONG_KHO = SO_LUONG_TRONG_KHO + :NEW.SOLUONG  
	    WHERE ID = :NEW.ID_NL;  
END;  
/  


--TRIGGER TINH_TONG_LAMVIEC
CREATE OR REPLACE TRIGGER UPDATE_TONG_THOIGIAN  
BEFORE INSERT ON NHANVIEN_LAMVIEC  
FOR EACH ROW  
BEGIN  
    :NEW.TONG_THOIGIAN := 24*(:NEW.THOIGIAN_KETTHUC - :NEW.THOIGIAN_BATDAU);  
END;  
/  
----- trigger tính tổng tiền của bill dựa vào chi tiết hóa đơn
CREATE OR REPLACE TRIGGER TRG_TONG_TIEN
FOR INSERT OR UPDATE OR DELETE ON CHITIET_DON
COMPOUND TRIGGER

    v_affected_id number;
    AFTER EACH ROW IS
    BEGIN
        IF INSERTING OR UPDATING THEN
            v_affected_id := :NEW.id_don;
        ELSE
            v_affected_id := :OLD.id_don;
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
        v_total NUMBER(38,0);
    BEGIN
            SELECT NVL(SUM(SOLUONG * GIA),0)
            INTO v_total
            FROM CHITIET_DON CD
            JOIN MON_AN MA ON CD.ID_MON = MA.ID
            WHERE CD.ID_DON = v_affected_id;

            -- Cập nhật tổng tiền trong bảng DON_HANG
            UPDATE DON_HANG
            SET TONG_TIEN = v_total
            WHERE ID = v_affected_id;

    END AFTER STATEMENT;

END TRG_TONG_TIEN;
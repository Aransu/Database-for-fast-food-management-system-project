
--FUNCTION SO TIEN THU TRONG NGAY
CREATE OR REPLACE FUNCTION SUMTHU_NGAY
    RETURN NUMBER IS
        TOTAL NUMBER;    
    BEGIN
        SELECT SUM(TONG_TIEN) INTO TOTAL FROM DON_HANG WHERE TRUNC(NGAY_DAT) = TRUNC(SYSDATE);
        DBMS_OUTPUT.PUT_LINE('SO TIEN THU TRONG NGAY '||TOTAL);
        RETURN TOTAL;
    END;
--FUNCTION SO TIEN THU TRONG NAM
CREATE OR REPLACE FUNCTION SUMTHU_THANG
    RETURN SYS_REFCURSOR IS
        TOTAL NUMBER;
        MY_CURSOR SYS_REFCURSOR;
        THANG NUMBER;
    BEGIN 
        OPEN MY_CURSOR FOR 
        SELECT EXTRACT(MONTH FROM NGAY_DAT),SUM(TONG_TIEN) FROM DON_HANG WHERE EXTRACT(YEAR FROM NGAY_DAT)=EXTRACT(YEAR FROM SYSDATE) GROUP BY EXTRACT(MONTH FROM NGAY_DAT);
            LOOP
            FETCH MY_CURSOR INTO THANG,TOTAL;
                EXIT WHEN MY_CURSOR%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('THANG ' ||THANG ||' CO TONG TIEN CHI LA'||TOTAL);
            END LOOP;
        CLOSE MY_CURSOR;
        RETURN MY_CURSOR;
        END;

--FUNCTION SO TIEN CHI TRONG NGAY (MAC DINH NGAY TRA LUONG CHO NHAN VIEN LA NGAY 25 MOI THANG)
    CREATE OR REPLACE FUNCTION SUMCHI_NGAY
    RETURN NUMBER IS 
        TOTAL NUMBER;
        LUONG_TOTAL NUMBER;
        NL_TOTAL NUMBER;
    BEGIN 
        SELECT SUM(LUONG) INTO LUONG_TOTAL FROM NHAN_VIEN ;
        SELECT SUM(GIA_NL) INTO NL_TOTAL FROM NGUYEN_LIEU N INNER JOIN NHACUNGCAP_NGUYENLIEU_QUANLY_BEP M ON M.ID_NL=N.ID WHERE TRUNC(NGAY_NL_NHAP_KHO)=TRUNC(SYSDATE);
        IF EXTRACT(DAY FROM SYSDATE) = 25 THEN
        TOTAL:=LUONG_TOTAL+NL_TOTAL;
        ELSE 
        TOTAL:=NL_TOTAL;
        END IF;
        DBMS_OUTPUT.PUT_LINE('SO TIEN CHI TRONG NGAY '|| TOTAL);
        RETURN TOTAL;
    END;
--FUNCTION SO TIEN CHI TRONG NAM
    CREATE OR REPLACE FUNCTION SUMCHI_THANG
    RETURN SYS_REFCURSOR IS 
        TOTAL NUMBER;
        LUONG_TOTAL NUMBER;
        NGUYENLIEU_TOTAL NUMBER;
        THANG NUMBER;
        MY_CURSOR SYS_REFCURSOR;
    BEGIN 
        SELECT SUM(LUONG) INTO LUONG_TOTAL FROM NHAN_VIEN;
        OPEN MY_CURSOR FOR SELECT EXTRACT(MONTH FROM NGAY_NL_NHAP_KHO), SUM(GIA_NL) FROM NGUYEN_LIEU N INNER JOIN NHACUNGCAP_NGUYENLIEU_QUANLY_BEP M ON N.ID=M.ID_NL WHERE EXTRACT(YEAR FROM NGAY_NL_NHAP_KHO)=EXTRACT(YEAR FROM SYSDATE) 
        GROUP BY EXTRACT(MONTH FROM NGAY_NL_NHAP_KHO);
        LOOP
            FETCH MY_CURSOR INTO THANG,NGUYENLIEU_TOTAL;
            EXIT WHEN(MY_CURSOR%NOTFOUND);
                TOTAL:=LUONG_TOTAL+NGUYENLIEU_TOTAL;
                DBMS_OUTPUT.PUT_LINE('THANG ' || THANG || 'SO TIEN  '||TOTAL);
        END LOOP;
        CLOSE MY_CURSOR;
        RETURN MY_CURSOR;
    END;

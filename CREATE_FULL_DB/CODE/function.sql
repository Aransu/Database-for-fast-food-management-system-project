
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

--FUNCTION TÌM SỐ NGUYÊN LIỆU ĐỂ CHẾ BIẾN MÓN ĂN
CREATE OR REPLACE FUNCTION GET_INGREDIENTS_FOR_DISH(
    P_DISH_ID IN INT
) RETURN SYS_REFCURSOR IS
    V_INGREDIENTS SYS_REFCURSOR;
BEGIN
    OPEN V_INGREDIENTS FOR
        SELECT
            NGUYEN_LIEU.*
        FROM
            NGUYEN_LIEU
            INNER JOIN NGUYEN_LIEU_MON_AN
            ON NGUYEN_LIEU_MON_AN.ID_NL = NGUYEN_LIEU.ID
        WHERE
            NGUYEN_LIEU_MON_AN.ID_MON = P_DISH_ID;
    RETURN V_INGREDIENTS;
END;

--FUNCTION TÍNH TỔNG TIỀN ĐƠN HÀNG
CREATE OR REPLACE FUNCTION TONG_TIEN_DON_HANG(
    P_ORDER_ID IN INT
) RETURN NUMBER IS
    V_TOTAL NUMBER;
BEGIN
    SELECT
        SUM(GIA * SOLUONG) INTO V_TOTAL
    FROM
        MON_AN
        INNER JOIN CHITIET_DON
        ON CHITIET_DON.ID_MON = MON_AN.ID
    WHERE
        CHITIET_DON.ID_DON = P_ORDER_ID;
    RETURN V_TOTAL;
END;
--Tính số lượng nhân viên theo chức vụ
CREATE OR REPLACE FUNCTION GetEmployeeCountByPosition(chuc_vu IN NHAN_VIEN.chuc_vu%TYPE)
RETURN NUMBER IS
  v_employee_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_employee_count
  FROM NHAN_VIEN
  WHERE chuc_vu = chuc_vu;
  
  RETURN v_employee_count;
END;
--Lấy chi tiết đơn của 1 đơn hàng
CREATE OR REPLACE FUNCTION GetOrderDetails(id_don IN DON_HANG.id_don%TYPE)
RETURN SYS_REFCURSOR IS
  v_cursor SYS_REFCURSOR;
BEGIN
  OPEN v_cursor FOR
    SELECT M.id, M.ten_mon, C.soluong
    FROM DON_HANG D
    JOIN CHITIET_DON C ON D.id_don = C.id_don
    JOIN MON_AN M ON C.id_mon = M.id
    WHERE D.id_don = id_don;
  
  RETURN v_cursor;
END;
--Kiểm tra xem một chương trình khuyến mãi còn hiệu lực hay không
CREATE OR REPLACE FUNCTION GetProgramActiveStatus(id_km IN CHUONG_TRINH_KM.id%TYPE)
RETURN NUMBER IS
  v_active_status NUMBER;
BEGIN
  SELECT CASE
           WHEN SYSDATE BETWEEN ngay_bat_dau AND ngay_ket_thuc THEN 1
           ELSE 0
         END INTO v_active_status
  FROM CHUONG_TRINH_KM
  WHERE id = id_km;
  RETURN v_active_status;
END;
--Tìm quản lý của 1 nhân viên
CREATE OR REPLACE FUNCTION GetEmployeeSubordinates(id_nv IN NHAN_VIEN.id%TYPE)
RETURN SYS_REFCURSOR IS
  v_cursor SYS_REFCURSOR;
BEGIN
  OPEN v_cursor FOR
    SELECT id, ten, don_vi, so_dien_thoai, chuc_vu, luong, id_quan_ly
    FROM NHAN_VIEN
    WHERE id_quan_ly = id_nv;
  
  RETURN v_cursor;
END;
--Tính số lượng đơn hàng của khách hàng
CREATE OR REPLACE FUNCTION GetOrderCountByCustomer(id_KH IN KHACH_HANG.id%TYPE)
RETURN NUMBER IS
  v_order_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_order_count
  FROM DON_HANG
  WHERE id_KH = id_KH;
  
  RETURN v_order_count;
END;
--Tính tổng tiền được dùng để mua nguyên liệu từ nhà cung cấp trong tháng này
CREATE OR REPLACE FUNCTION GetSupplierTotalPurchases(id_ncc1 IN NHA_CUNG_CAP.id%TYPE)
RETURN NUMBER IS
  v_total_purchases NUMBER;
BEGIN
  SELECT SUM(TONG_TIEN) INTO v_total_purchases FROM NHACUNGCAP_NGUYENLIEU_QUANLY_BEP 
WHERE ID_NCC=id_ncc1 AND to_char(NGAY_NL_NHAP_KHO,'mm') =to_char(SYSDATE,'mm');
    RETURN v_total_purchases;
END;
--Nhập vào id nhân viên, lấy ra các đơn hàng nv đó chế biến
CREATE OR REPLACE FUNCTION GetEmployeeTotalOrder(id_nv IN NHAN_VIEN.id%TYPE)
RETURN SYS_REFCURSOR IS
  v_order SYS_REFCURSOR;
BEGIN   
    OPEN v_order FOR
  SELECT * FROM DON_HANG WHERE ID_THU_NGAN=id_nv;
  
  RETURN v_order;
END;
--Tìm nhân viên theo id
CREATE OR REPLACE FUNCTION GetEmployeeWithId(id_nv IN NHAN_VIEN.id%TYPE)
RETURN SYS_REFCURSOR IS
  v_nv SYS_REFCURSOR;
BEGIN   
    OPEN v_nv FOR
  SELECT * FROM NHAN_VIEN WHERE ID=id_nv;
  
  RETURN v_nv;
END;
--Tìm nhân viên theo tên
CREATE OR REPLACE FUNCTION GetEmployeeWithName(tennv IN NHAN_VIEN.TEN%TYPE)
RETURN SYS_REFCURSOR IS
  v_nv SYS_REFCURSOR;
BEGIN   
    OPEN v_nv FOR
  SELECT * FROM NHAN_VIEN WHERE TEN=tennv;
  
  RETURN v_nv;
END;
--Nhập vào một mức giá, tìm ra các đơn hàng có tổng tiền 
lơn hơn mức giá đó
CREATE OR REPLACE FUNCTION GetOrderWithTotal(tien IN DON_HANG.TONG_TIEN%TYPE)
RETURN SYS_REFCURSOR IS
  V_ORDER SYS_REFCURSOR;
BEGIN   
    OPEN V_ORDER FOR
  SELECT * FROM DON_HANG WHERE TONG_TIEN>tien;
  
  RETURN V_ORDER;
END;
--Tìm nhân viên làm việc nhiều nhất tháng
CREATE OR REPLACE FUNCTION GetEmployeeWithMostHours
RETURN NHAN_VIEN%ROWTYPE IS
  v_employee NHAN_VIEN%ROWTYPE;
BEGIN
  SELECT NV.id, NV.ten, NV.so_dien_thoai, NV.chuc_vu, NV.luong, NV.id_quan_ly
  INTO v_employee
  FROM NHAN_VIEN NV
  JOIN NHANVIEN_LAMVIEC NVLV ON NV.id = NVLV.ID_NHANVIEN
  WHERE EXTRACT(MONTH FROM NVLV.THOIGIAN_KETTHUC) = EXTRACT(MONTH FROM SYSDATE)
  AND EXTRACT(YEAR FROM NVLV.THOIGIAN_KETTHUC) = EXTRACT(YEAR FROM SYSDATE)
  GROUP BY NV.id, NV.ten, NV.so_dien_thoai, NV.chuc_vu, NV.luong, NV.id_quan_ly
  ORDER BY SUM(NVLV.TONG_THOIGIAN) DESC
  FETCH FIRST ROW ONLY;
  RETURN v_employee;
END;

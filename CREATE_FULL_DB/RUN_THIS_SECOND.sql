
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


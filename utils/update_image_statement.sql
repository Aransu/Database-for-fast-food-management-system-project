

CREATE or replace DIRECTORY DIRECT_OF_IMAGE AS 'D:\LIST_MENU\food'; --Tạo đường dẫn tới file chứa file ảnh ở đây là file pictosave chứa ảnh quysung.jpg


SELECT * FROM DBA_DIRECTORIES; --kiểm tra xem đã tạo đường dẫn thành công chưa

--Sau đây là đoạn code để insert ảnh 
COMMIT;
set serveroutput on;
DECLARE
l_blob BLOB;
l_bfile BFILE;
l_dest_offset INTEGER:=1;
l_src_offset INTEGER:=1;
l_lobmaxsize CONSTANT INTEGER := DBMS_LOB.LOBMAXSIZE;
BEGIN
update MON_AN
set MON_AN.HINH_ANH = empty_blob()
where MON_AN.TEN_MON = 'French fries'
RETURNING MON_AN.HINH_ANH INTO l_blob;
l_bfile := BFILENAME('DIRECT_OF_IMAGE', 'French_fries.png');
DBMS_LOB.FILEOPEN(l_bfile, DBMS_LOB.file_readonly);
DBMS_LOB.loadblobfromfile (l_blob,l_bfile,l_lobmaxsize, l_dest_offset, l_src_offset);
DBMS_LOB.fileclose(l_bfile);
DBMS_OUTPUT.PUT_LINE('SIZE OF THE IMAGE IS: '|| DBMS_LOB.GETLENGTH(l_blob));
COMMIT;
END;

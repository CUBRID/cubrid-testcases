--[er]test to_number function using int and other type as its operand
SELECT TO_NUMBER(222,'char') FROM db_root;
SELECT TO_NUMBER(222,n'nchar') FROM db_root;
SELECT TO_NUMBER(222,date'2/2/2002') FROM db_root;
SELECT TO_NUMBER(222,time'1:1:1 am') FROM db_root;
SELECT TO_NUMBER(222,timestamp'1/1/2001 1:1:1 am') FROM db_root;
SELECT TO_NUMBER(222,{1,2}) FROM db_root;
SELECT TO_NUMBER(222,b'0001010101010') FROM db_root;
SELECT TO_NUMBER(222,111) FROM db_root;
SELECT TO_NUMBER(222,12.32423) FROM db_root;

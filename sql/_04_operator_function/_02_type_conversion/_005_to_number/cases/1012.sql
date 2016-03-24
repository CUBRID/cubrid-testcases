--[er]test to_number function using numeric and other type as its operand
SELECT TO_NUMBER(88.99,'char') FROM db_root;
SELECT TO_NUMBER(88.99,n'nchar') FROM db_root;
SELECT TO_NUMBER(88.99,date'2/2/2002') FROM db_root;
SELECT TO_NUMBER(88.99,time'1:1:1 am') FROM db_root;
SELECT TO_NUMBER(88.99,timestamp'1/1/2001 1:1:1 am') FROM db_root;
SELECT TO_NUMBER(88.99,{1,2}) FROM db_root;
SELECT TO_NUMBER(88.99,b'0001010101010') FROM db_root;
SELECT TO_NUMBER(88.99,111) FROM db_root;
SELECT TO_NUMBER(88.99,12.32423) FROM db_root;

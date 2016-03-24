--[er]test to_number function using bit and other type as its operand
SELECT TO_NUMBER(b'0010101010','char') FROM db_root;
SELECT TO_NUMBER(b'0010101010',n'nchar') FROM db_root;
SELECT TO_NUMBER(b'0010101010',date'2/2/2002') FROM db_root;
SELECT TO_NUMBER(b'0010101010',time'1:1:1 am') FROM db_root;
SELECT TO_NUMBER(b'0010101010',timestamp'1/1/2001 1:1:1 am') FROM db_root;
SELECT TO_NUMBER(b'0010101010',{1,2}) FROM db_root;
SELECT TO_NUMBER(b'0010101010',b'0001010101010') FROM db_root;
SELECT TO_NUMBER(b'0010101010',111) FROM db_root;
SELECT TO_NUMBER(b'0010101010',12.32423) FROM db_root;

--[er]test to_number function using char,nchar and other type as its operand
SELECT TO_NUMBER('','') FROM db_root;
SELECT TO_NUMBER('char','char') FROM db_root;
SELECT TO_NUMBER('char',n'nchar') FROM db_root;
SELECT TO_NUMBER('char',date'2/2/2002') FROM db_root;
SELECT TO_NUMBER('char',time'1:1:1 am') FROM db_root;
SELECT TO_NUMBER('char',timestamp'1/1/2001 1:1:1 am') FROM db_root;
SELECT TO_NUMBER('char',{1,2}) FROM db_root;
SELECT TO_NUMBER('char',b'0001010101010') FROM db_root;
SELECT TO_NUMBER('char',111) FROM db_root;
SELECT TO_NUMBER('char',12.32423) FROM db_root;

SELECT TO_NUMBER('10.234','char') FROM db_root;
SELECT TO_NUMBER('10.234',n'nchar') FROM db_root;
SELECT TO_NUMBER('10.234',date'2/2/2002') FROM db_root;
SELECT TO_NUMBER('10.234',time'1:1:1 am') FROM db_root;
SELECT TO_NUMBER('10.234',timestamp'1/1/2001 1:1:1 am') FROM db_root;
SELECT TO_NUMBER('10.234',{1,2}) FROM db_root;
SELECT TO_NUMBER('10.234',b'0001010101010') FROM db_root;
SELECT TO_NUMBER('10.234',111) FROM db_root;
SELECT TO_NUMBER('10.234',12.32423) FROM db_root;

SELECT TO_NUMBER(n'10.234','char') FROM db_root;
SELECT TO_NUMBER(n'10.234',n'nchar') FROM db_root;
SELECT TO_NUMBER(n'10.234',date'2/2/2002') FROM db_root;
SELECT TO_NUMBER(n'10.234',time'1:1:1 am') FROM db_root;
SELECT TO_NUMBER(n'10.234',timestamp'1/1/2001 1:1:1 am') FROM db_root;
SELECT TO_NUMBER(n'10.234',{1,2}) FROM db_root;
SELECT TO_NUMBER(n'10.234',b'0001010101010') FROM db_root;
SELECT TO_NUMBER(n'10.234',111) FROM db_root;
SELECT TO_NUMBER(n'10.234',12.32423) FROM db_root;




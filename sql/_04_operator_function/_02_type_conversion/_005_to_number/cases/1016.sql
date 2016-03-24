--[er]test to_number function using date and other type as its operand
SELECT TO_NUMBER(date'2/2/2008','char') FROM db_root;
SELECT TO_NUMBER(date'2/2/2008',n'nchar') FROM db_root;
SELECT TO_NUMBER(date'2/2/2008',date'2/2/2002') FROM db_root;
SELECT TO_NUMBER(date'2/2/2008',time'1:1:1 am') FROM db_root;
SELECT TO_NUMBER(date'2/2/2008',timestamp'1/1/2001 1:1:1 am') FROM db_root;
SELECT TO_NUMBER(date'2/2/2008',{1,2}) FROM db_root;
SELECT TO_NUMBER(date'2/2/2008',b'0001010101010') FROM db_root;
SELECT TO_NUMBER(date'2/2/2008',111) FROM db_root;
SELECT TO_NUMBER(date'2/2/2008',12.32423) FROM db_root;

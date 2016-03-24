--[er]test to_number function using time and other type as its operand
SELECT TO_NUMBER(time'8:8:9 am','char') FROM db_root;
SELECT TO_NUMBER(time'8:8:9 am',n'nchar') FROM db_root;
SELECT TO_NUMBER(time'8:8:9 am',date'2/2/2002') FROM db_root;
SELECT TO_NUMBER(time'8:8:9 am',time'1:1:1 am') FROM db_root;
SELECT TO_NUMBER(time'8:8:9 am',timestamp'1/1/2001 1:1:1 am') FROM db_root;
SELECT TO_NUMBER(time'8:8:9 am',{1,2}) FROM db_root;
SELECT TO_NUMBER(time'8:8:9 am',b'0001010101010') FROM db_root;
SELECT TO_NUMBER(time'8:8:9 am',111) FROM db_root;
SELECT TO_NUMBER(time'8:8:9 am',12.32423) FROM db_root;

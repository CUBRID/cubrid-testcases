--[er]test to_number function using timestamp and other type as its operand
SELECT TO_NUMBER(timestamp'5/5/2001 9:9:1 am','char') FROM db_root;
SELECT TO_NUMBER(timestamp'5/5/2001 9:9:1 am',n'nchar') FROM db_root;
SELECT TO_NUMBER(timestamp'5/5/2001 9:9:1 am',date'2/2/2002') FROM db_root;
SELECT TO_NUMBER(timestamp'5/5/2001 9:9:1 am',time'1:1:1 am') FROM db_root;
SELECT TO_NUMBER(timestamp'5/5/2001 9:9:1 am',timestamp'1/1/2001 1:1:1 am') FROM db_root;
SELECT TO_NUMBER(timestamp'5/5/2001 9:9:1 am',{1,2}) FROM db_root;
SELECT TO_NUMBER(timestamp'5/5/2001 9:9:1 am',b'0001010101010') FROM db_root;
SELECT TO_NUMBER(timestamp'5/5/2001 9:9:1 am',111) FROM db_root;
SELECT TO_NUMBER(timestamp'5/5/2001 9:9:1 am',12.32423) FROM db_root;

--[er]test to_number function using set and other type as its operand
SELECT TO_NUMBER({8,9,10},'char') FROM db_root;
SELECT TO_NUMBER({8,9,10},n'nchar') FROM db_root;
SELECT TO_NUMBER({8,9,10},date'2/2/2002') FROM db_root;
SELECT TO_NUMBER({8,9,10},time'1:1:1 am') FROM db_root;
SELECT TO_NUMBER({8,9,10},timestamp'1/1/2001 1:1:1 am') FROM db_root;
SELECT TO_NUMBER({8,9,10},{1,2}) FROM db_root;
SELECT TO_NUMBER({8,9,10},b'0001010101010') FROM db_root;
SELECT TO_NUMBER({8,9,10},111) FROM db_root;
SELECT TO_NUMBER({8,9,10},12.32423) FROM db_root;

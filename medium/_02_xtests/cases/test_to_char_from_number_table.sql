autocommit off;
create table test_to_char_table(
    n1 numeric(10,5),
    c2 varchar(500),
    n3 numeric(10,5),
    c4 varchar(500)
);
insert into test_to_char_table (n1,c2) values(124.5,'0000 9999 9,999 9,9,9,9, s999999 s00000 c99999 c00000 sc99999 sc00000 9.9eeee 9.99eeee 0.99eeee 00.9eeee sc0.eeee 999 000 000.0 99.9 ');
SELECT n1, to_char( n1) FROM test_to_char_table;
SELECT n1,'0000 9999 9,999 9,9,9,9, s999999 s00000 c99999 c00000 sc99999 sc00000 9.9eeee 9.99eeee 0.99eeee 00.9eeee sc0.eeee 999 000 000.0 99.9 ', to_char( n1,'0000 9999 9,999 9,9,9,9, s999999 s00000 c99999 c00000 sc99999 sc00000 9.9eeee 9.99eeee 0.99eeee 00.9eeee sc0.eeee 999 000 000.0 99.9 ') FROM test_to_char_table;
SELECT 124.5,c2, to_char( 124.5,c2) FROM test_to_char_table;
SELECT n1,c2, to_char( n1,c2) FROM test_to_char_table;
SELECT n3, to_char( n3) FROM test_to_char_table;
SELECT n1,c4, to_char( n1,c4) FROM test_to_char_table;
SELECT n3,c2, to_char( n3,c2) FROM test_to_char_table;
SELECT n3,c4, to_char( n3,c4) FROM test_to_char_table;
drop table test_to_char_table;
rollback;

autocommit off;
set names utf8;
create table test_rpad_table(
    c1 varchar(50) charset utf8,
    i2 integer,
    c3 varchar(50) charset utf8,
    i4 integer,
	c5 varchar(50) charset utf8
);
insert into test_rpad_table (c1,i2,c3) values('Choikonghun',24,'최');
SELECT 'Choikonghun',i2, rpad( 'Choikonghun',i2) FROM test_rpad_table;
SELECT c1,24, rpad( c1,24) FROM test_rpad_table;
SELECT c1,i2, rpad( c1,i2) FROM test_rpad_table;
SELECT 'Choikonghun',i2,c3, rpad( 'Choikonghun',i2,c3) FROM test_rpad_table;
SELECT c1,24,c3, rpad( c1,24,c3) FROM test_rpad_table;
SELECT c1,i2,'최', rpad( c1,i2,'최') FROM test_rpad_table;
SELECT 'Choikonghun',24,c3, rpad( 'Choikonghun',24,c3) FROM test_rpad_table;
SELECT 'Choikonghun',i2,'최', rpad( 'Choikonghun',i2,'최') FROM test_rpad_table;
SELECT c1,24,'최', rpad( c1,24,'최') FROM test_rpad_table;
SELECT c1,i2,c3, rpad( c1,i2,c3) FROM test_rpad_table;
SELECT 'Choikonghun',i4, rpad( 'Choikonghun',i4) FROM test_rpad_table;
SELECT c5,24, rpad( c5,24) FROM test_rpad_table;
SELECT c5,i4, rpad( c5,i4) FROM test_rpad_table;
SELECT 'Choikonghun',24,c5, rpad( 'Choikonghun',24,c5) FROM test_rpad_table;
SELECT 'Choikonghun',i4,'최', rpad( 'Choikonghun',i4,'최') FROM test_rpad_table;
SELECT c5,24,'최', rpad( c5,24,'최') FROM test_rpad_table;
SELECT 'Choikonghun',i4,c5, rpad( 'Choikonghun',i4,c5) FROM test_rpad_table;
SELECT c5,24,c5, rpad( c5,24,c5) FROM test_rpad_table;
SELECT c5,i4,'최', rpad( c5,i4,'최') FROM test_rpad_table;
SELECT c5,i4,c5, rpad( c5,i4,c5) FROM test_rpad_table;
drop table test_rpad_table;
set names iso88591;
rollback;

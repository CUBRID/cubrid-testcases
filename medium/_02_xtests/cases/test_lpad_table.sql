autocommit off;
set names utf8;
create table test_lpad_table(
    c1 varchar(50) charset utf8,
    i2 integer,
    c3 varchar(50) charset utf8,
    i4 integer,
	c5 varchar(50) charset utf8
);
insert into test_lpad_table (c1,i2,c3) values('Choikonghun',24,'최');
SELECT 'Choikonghun',i2, lpad('Choikonghun',i2) FROM test_lpad_table;
SELECT c1, 24, lpad(c1,24) FROM test_lpad_table;
SELECT c1, i2, lpad(c1,i2) FROM test_lpad_table;
SELECT 'Choikonghun',i2, c3, lpad('Choikonghun',i2,c3) FROM test_lpad_table;
SELECT c1, 24, c3, lpad(c1,24,c3) FROM test_lpad_table;
SELECT c1, i2, '최', lpad(c1,i2,'최') FROM test_lpad_table;
SELECT 'Choikonghun',24,c3, lpad('Choikonghun',24,c3) FROM test_lpad_table;
SELECT 'Choikonghun',i2,'최', lpad('Choikonghun',i2,'최') FROM test_lpad_table;
SELECT c1,24,'최', lpad(c1,24,'최') FROM test_lpad_table;
SELECT c1, i2, c3, lpad(c1,i2,c3) FROM test_lpad_table;
SELECT 'Choikonghun',i4, lpad('Choikonghun',i4) FROM test_lpad_table;
SELECT c5,24, lpad(c5,24) FROM test_lpad_table;
SELECT c5, i4, lpad(c5,i4) FROM test_lpad_table;
SELECT 'Choikonghun',24,c5, lpad('Choikonghun',24,c5) FROM test_lpad_table;
SELECT 'Choikonghun',i4,'최', lpad('Choikonghun',i4,'최') FROM test_lpad_table;
SELECT c5,24,'최', lpad(c5,24,'최') FROM test_lpad_table;
SELECT 'Choikonghun',i4,c5, lpad('Choikonghun',i4,c5) FROM test_lpad_table;
SELECT c5,24,c5, lpad(c5,24,c5) FROM test_lpad_table;
SELECT c5,i4,'최', lpad(c5,i4,'최') FROM test_lpad_table;
SELECT c5,i4,c5, lpad(c5,i4,c5) FROM test_lpad_table;
drop table test_lpad_table;
set names iso88591;
rollback;

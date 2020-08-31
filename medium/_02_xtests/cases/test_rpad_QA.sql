autocommit off;
set names utf8;
create table tb (
	dummy varchar(1)
);
insert into tb values ('X');
create table test_rpad (
	type_char char(10) charset utf8,
	type_varchar varchar(10) charset utf8,
	type_nchar nchar(10) charset utf8,
	type_nchar_varying nchar varying(10) charset utf8
);
insert into test_rpad (type_char) values ('choi');
SELECT type_char, type_varchar,RPAD(type_char, 6, type_varchar) FROM test_rpad;
SELECT type_char, type_varchar,RPAD(type_char, 6, NULL) FROM test_rpad;
SELECT RPAD(NULL, 6, NULL) FROM tb;
SELECT RPAD('a', 6, NULL) FROM tb;
SELECT RPAD(NULL, 6, 'a') FROM tb;
SELECT RPAD('Chun', 5, '최') FROM tb;
/*	Normal			*/
SELECT RPAD('최공훈', 4, ' ') FROM tb;
SELECT RPAD('최공훈', 6, ' ') FROM tb;
SELECT RPAD('최공훈', 8, ' ') FROM tb;
SELECT RPAD('Choikonghun', 10,'choi') FROM tb;
SELECT RPAD('Choikonghun', 11,'choi') FROM tb;
SELECT RPAD('Choikonghun', 12,'choi') FROM tb;
SELECT RPAD('Choikonghun', 13,'choi') FROM tb;
SELECT RPAD('Choikonghun', 14,'choi') FROM tb;
SELECT RPAD('Choikonghun', 15,'choi') FROM tb;
SELECT RPAD('Choikonghun', 16,'choi') FROM tb;
SELECT RPAD('Choikonghun', 17,'choi') FROM tb;
select rpad(NULL,NULL) from tb;
select rpad(NULL,NULL,NULL) from tb;
drop table tb;
drop table test_rpad;
set names iso88591;
rollback;

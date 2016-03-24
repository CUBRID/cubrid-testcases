autocommit off;
set names utf8;
create table dual (
	dummy varchar(1)
);
insert into dual values ('X');
create table test_rpad (
	type_char char(10) charset utf8,
	type_varchar varchar(10) charset utf8,
	type_nchar nchar(10) charset utf8,
	type_nchar_varying nchar varying(10) charset utf8
);
insert into test_rpad (type_char) values ('choi');
SELECT type_char, type_varchar,RPAD(type_char, 6, type_varchar) FROM test_rpad;
SELECT type_char, type_varchar,RPAD(type_char, 6, NULL) FROM test_rpad;
SELECT RPAD(NULL, 6, NULL) FROM dual;
SELECT RPAD('a', 6, NULL) FROM dual;
SELECT RPAD(NULL, 6, 'a') FROM dual;
SELECT RPAD('Chun', 5, '최') FROM dual;
/*	Normal			*/
SELECT RPAD('최공훈', 4, ' ') FROM dual;
SELECT RPAD('최공훈', 6, ' ') FROM dual;
SELECT RPAD('최공훈', 8, ' ') FROM dual;
SELECT RPAD('Choikonghun', 10,'choi') FROM dual;
SELECT RPAD('Choikonghun', 11,'choi') FROM dual;
SELECT RPAD('Choikonghun', 12,'choi') FROM dual;
SELECT RPAD('Choikonghun', 13,'choi') FROM dual;
SELECT RPAD('Choikonghun', 14,'choi') FROM dual;
SELECT RPAD('Choikonghun', 15,'choi') FROM dual;
SELECT RPAD('Choikonghun', 16,'choi') FROM dual;
SELECT RPAD('Choikonghun', 17,'choi') FROM dual;
select rpad(NULL,NULL) from dual;
select rpad(NULL,NULL,NULL) from dual;
drop table dual;
drop table test_rpad;
set names iso88591;
rollback;

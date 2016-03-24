autocommit off;
set names utf8;
create table dual (
	dummy varchar(1)
);
insert into dual values ('X');
create table test_lpad (
	type_char char(10) charset utf8,
	type_varchar varchar(10) charset utf8,
	type_nchar nchar(10) charset utf8,
	type_nchar_varying nchar varying(10) charset utf8
);
insert into test_lpad (type_char) SELECT LPAD('�ְ���', 5, ' ') FROM dual;
SELECT LPAD('�ְ���', 5, ' ') FROM dual;
SELECT type_char, RPAD(type_char,2,' ') FROM test_lpad ;
SELECT LPAD('Choikonghun', 12,'��') FROM dual;
SELECT LPAD('�ְ���', 4, ' ') FROM dual;
SELECT LPAD('�ְ���', 6, ' ') FROM dual;
SELECT LPAD('�ְ���', 8, ' ') FROM dual;
SELECT LPAD('Choikonghun', 12,'choi') FROM dual;
SELECT LPAD('i', 1, '*') FROM dual;
SELECT LPAD('i am a boy', 9, '*') FROM dual;
SELECT LPAD('1234567890', 10, '*') FROM dual;
SELECT LPAD('1234567890', 11, '*') FROM dual;
select lpad('�ְ���',10) from dual; 
select lpad(NULL,NULL) from dual;
select lpad(NULL,NULL,NULL) from dual;
drop table dual;
drop table test_lpad;
set names iso88591;
rollback;

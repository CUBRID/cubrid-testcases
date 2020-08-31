autocommit off;
set names utf8;
create table tb (
	dummy varchar(1)
);
insert into tb values ('X');
create table test_lpad (
	type_char char(10) charset utf8,
	type_varchar varchar(10) charset utf8,
	type_nchar nchar(10) charset utf8,
	type_nchar_varying nchar varying(10) charset utf8
);
insert into test_lpad (type_char) SELECT LPAD('�ְ���', 5, ' ') FROM tb;
SELECT LPAD('�ְ���', 5, ' ') FROM tb;
SELECT type_char, RPAD(type_char,2,' ') FROM test_lpad ;
SELECT LPAD('Choikonghun', 12,'��') FROM tb;
SELECT LPAD('�ְ���', 4, ' ') FROM tb;
SELECT LPAD('�ְ���', 6, ' ') FROM tb;
SELECT LPAD('�ְ���', 8, ' ') FROM tb;
SELECT LPAD('Choikonghun', 12,'choi') FROM tb;
SELECT LPAD('i', 1, '*') FROM tb;
SELECT LPAD('i am a boy', 9, '*') FROM tb;
SELECT LPAD('1234567890', 10, '*') FROM tb;
SELECT LPAD('1234567890', 11, '*') FROM tb;
select lpad('�ְ���',10) from tb; 
select lpad(NULL,NULL) from tb;
select lpad(NULL,NULL,NULL) from tb;
drop table tb;
drop table test_lpad;
set names iso88591;
rollback;

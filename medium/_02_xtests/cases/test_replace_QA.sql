autocommit off;
set names utf8;
create table dual (
	dummy varchar(1)
) charset euckr;
insert into dual values ('X');
SELECT REPLACE('JACK and JUE','','BL')  FROM DUAL 
SELECT REPLACE(NULL,NULL,NULL)  FROM DUAL;
SELECT REPLACE('최공훈이  ','최','최c') FROM DUAL;
create table test_replace (
	type_char char(20),
	type_varchar varchar(10),
	type_nchar nchar(10),
	type_nchar_varying nchar varying(10)
) charset euckr;
insert into test_replace (type_char) SELECT REPLACE('최공훈이 ','공','공 ') FROM DUAL;
select type_char from test_replace;
SELECT REPLACE('최공훈이  ','최','최c') FROM DUAL;
SELECT REPLACE('최최공훈이','최공')  FROM DUAL;		
SELECT REPLACE('Choikonghun','kon')  FROM DUAL;	
SELECT REPLACE('Choikonghun','kong','qwer')  FROM DUAL;  
SELECT REPLACE('최공훈 멋쟁','공훈','창민')  FROM DUAL; 
SELECT REPLACE('JACK and JUE',NULL,'BL')  FROM DUAL 
SELECT REPLACE('JACK and JUE',NULL,'')  FROM DUAL 
SELECT REPLACE('JACK and JUE',NULL,NULL)  FROM DUAL 
SELECT REPLACE('',NULL,NULL)  FROM DUAL;
SELECT REPLACE('',NULL,'')  FROM DUAL;
SELECT REPLACE('최최공훈이 ','이 ','최')  FROM DUAL;
SELECT REPLACE('최최공훈이 ','이 ')  FROM DUAL;
select replace(NULL,NULL) from dual;
select replace(NULL,NULL,NULL) from dual;
drop table dual;
drop table test_replace;
set names iso88591;
rollback;

autocommit off;
set names utf8;
create table tb (
	dummy varchar(1)
) charset euckr;
insert into tb values ('X');
SELECT REPLACE('JACK and JUE','','BL')  FROM tb 
SELECT REPLACE(NULL,NULL,NULL)  FROM tb;
SELECT REPLACE('최공훈이  ','최','최c') FROM tb;
create table test_replace (
	type_char char(20),
	type_varchar varchar(10),
	type_nchar nchar(10),
	type_nchar_varying nchar varying(10)
) charset euckr;
insert into test_replace (type_char) SELECT REPLACE('최공훈이 ','공','공 ') FROM tb;
select type_char from test_replace;
SELECT REPLACE('최공훈이  ','최','최c') FROM tb;
SELECT REPLACE('최최공훈이','최공')  FROM tb;		
SELECT REPLACE('Choikonghun','kon')  FROM tb;	
SELECT REPLACE('Choikonghun','kong','qwer')  FROM tb;  
SELECT REPLACE('최공훈 멋쟁','공훈','창민')  FROM tb; 
SELECT REPLACE('JACK and JUE',NULL,'BL')  FROM tb 
SELECT REPLACE('JACK and JUE',NULL,'')  FROM tb 
SELECT REPLACE('JACK and JUE',NULL,NULL)  FROM tb 
SELECT REPLACE('',NULL,NULL)  FROM tb;
SELECT REPLACE('',NULL,'')  FROM tb;
SELECT REPLACE('최최공훈이 ','이 ','최')  FROM tb;
SELECT REPLACE('최최공훈이 ','이 ')  FROM tb;
select replace(NULL,NULL) from tb;
select replace(NULL,NULL,NULL) from tb;
drop table tb;
drop table test_replace;
set names iso88591;
rollback;

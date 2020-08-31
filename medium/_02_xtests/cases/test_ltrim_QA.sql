autocommit off;
set names utf8;
create table tb (
    dummy varchar(1)
) charset euckr;
insert into tb values ('X');
SELECT LTRIM('占쌍곤옙占쏙옙 ') FROM tb;
SELECT LTRIM(' 占쌍곤옙占쏙옙 ') FROM tb;
SELECT LTRIM('占쌍곤옙占쏙옙 ','占쏙옙') FROM tb;
SELECT LTRIM('占쏙옙 占쌍곤옙占쏙옙 ','占쏙옙') FROM tb;
SELECT LTRIM(' 占쏙옙 占쌍곤옙占쏙옙 ','占쏙옙') FROM tb;
SELECT LTRIM('占쌍곤옙占쏙옙 ',' 占쏙옙') FROM tb;
SELECT LTRIM('占쌍곤옙占쏙옙 ','占쏙옙 ') FROM tb;
SELECT LTRIM('占쌍곤옙占쏙옙 ','  占쏙옙 ') FROM tb;

SELECT LTRIM('c占쌍곤옙占쏙옙 ',' c占쏙옙 ') FROM tb;
SELECT LTRIM('c 占쏙옙h占쏙옙 占쏙옙 ','占쏙옙 h占쏙옙c') FROM tb;

SELECT LTRIM('					
	   	占쌍곤옙占쏙옙 ') FROM tb;
SELECT LTRIM(' 
		占쌍곤옙占쏙옙 ',' 占쌍곤옙') FROM tb;

SELECT LTRIM('          占쌍곤옙占쏙옙 ') FROM tb;

SELECT LTRIM('','') FROM tb;
SELECT LTRIM('','占쏙옙') FROM tb;
SELECT LTRIM('占쏙옙','') FROM tb;

create table test_ltrim (
	type_char char(10),
	type_varchar varchar(10)
) charset euckr;
insert into test_ltrim (type_char) values (' ');
SELECT  LTRIM(type_varchar) FROM test_ltrim;
SELECT  LTRIM(type_char,type_varchar) FROM test_ltrim;
SELECT  LTRIM(type_varchar,type_varchar) FROM test_ltrim;
SELECT  LTRIM(type_varchar,type_char) FROM test_ltrim;
select ltrim(NULL) from tb;
select ltrim(NULL,NULL) from tb;

drop table tb;
drop table test_ltrim;
set names iso88591;
rollback;

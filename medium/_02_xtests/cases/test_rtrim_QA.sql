autocommit off;
set names utf8;
create table dual (
	dummy varchar(1)
) charset euckr;
insert into dual values ('X');
SELECT RTRIM(' 占쌍곤옙占쏙옙 ') FROM dual;
SELECT RTRIM(' 占쌍곤옙占쏙옙 ') FROM dual;
SELECT RTRIM(' 占쌍곤옙占쏙옙','占쏙옙') FROM dual;
SELECT RTRIM('占쏙옙 占쌍곤옙占쏙옙 占쏙옙','占쏙옙') FROM dual;
SELECT RTRIM(' 占쏙옙 占쌍곤옙占쏙옙 ','占쏙옙') FROM dual;
SELECT RTRIM('占쌍곤옙占쏙옙 ',' 占쏙옙') FROM dual;
SELECT RTRIM(' 占쌍곤옙占쏙옙 ','占쏙옙 ') FROM dual;
SELECT RTRIM('占쌍곤옙 占쏙옙 ',' 占쏙옙') FROM dual;
SELECT RTRIM('占쌍곤옙c占쏙옙 ',' c占쏙옙') FROM dual;
SELECT RTRIM('c 占쏙옙h占쏙옙h 占쏙옙c ','占쏙옙 h占쏙옙c') FROM dual;
/*	CR/LF				*/
SELECT RTRIM('	占쌍곤옙 占쏙옙
	   		') FROM dual;
SELECT RTRIM('  占쌍곤옙占쏙옙	 ',' 占싣곤옙') FROM dual;
/* 占쏙옙占쏙옙占쏙옙占쏙옙 space		*/
SELECT RTRIM(' 占쌍곤옙占쏙옙         ') FROM dual;
/*	NULL				*/
SELECT RTRIM('','') FROM dual;
SELECT RTRIM('','占쏙옙') FROM dual;
SELECT RTRIM('占쏙옙','') FROM dual;
create table test_rtrim (
	type_char char(10),
	type_varchar varchar(10)
) charset euckr;
insert into test_rtrim (type_char) values (' ');
/*	NULL				*/
SELECT  RTRIM(type_varchar) FROM test_rtrim;
SELECT  RTRIM(type_char,type_varchar) FROM test_rtrim;
SELECT  RTRIM(type_varchar,type_varchar) FROM test_rtrim;
SELECT  RTRIM(type_varchar,type_char) FROM test_rtrim;
select rtrim(NULL) from dual;
select rtrim(NULL,NULL) from dual;

drop table dual;
drop table test_rtrim;
set names iso88591;
rollback;

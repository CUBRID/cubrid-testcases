--+ holdcas on;
set names binary;

SELECT REPLACE('12345abcdeabcde','abcde',NULL);
SELECT REPLACE('12345abcdeabcde',NULL,'abcde');
SELECT REPLACE(NULL,'12345abcdeabcde','abcde');

SELECT REPLACE('12345abcdeabcde','abcde','ABCDE');
SELECT REPLACE('12345abcdeabcde','abcde');

SELECT REPLACE('문자열','문자','문자열');
SELECT REPLACE('문자열','문자');
SELECT REPLACE('문자열','자문','string');

SELECT REPLACE('你好我好大家好','好','开心');
SELECT REPLACE('你好我好大家好','好');

select coercibility(_binary'abcdefg'), coercibility(cast(_utf8'abc' as string charset euckr)),  coercibility(_utf8'abc' ), coercibility(cast(_utf8'def'as string charset iso88591));
select replace(_binary'abcdefg', cast(_utf8'abc' as string charset euckr), cast(_utf8'def'as string charset euckr));
select replace(_binary'abcdefg', cast(_utf8'abc' as string charset iso88591), cast(_utf8'def'as string charset iso88591));
select replace(_binary'abcdefg', _utf8'' , _utf8'def');
--expect return error
select replace(_binary'abcdefg', cast(_utf8'abc' as string charset euckr), cast(_utf8'def'as string charset iso88591));

drop table if exists tbl;
CREATE TABLE tbl (cmt_no INT PRIMARY KEY, cmt VARCHAR(1024));
INSERT INTO tbl VALUES (1234,
'This is a test for

 new line.');
SELECT REPLACE(cmt, CHR(10), '\n') FROM tbl WHERE cmt_no=1234;

drop tbl;

set names utf8;
drop table if exists t;
create table t (
id int AUTO_INCREMENT , 
col_binary varchar(100) collate binary, 
col_euckr  varchar(100) collate euckr_bin, 
col_utf8    varchar(100) collate utf8_bin, 
col_iso      varchar(100) collate iso88591_bin);
insert into t values(null, '큐브리드', '큐브리드', '큐브리드', '큐브리드');
insert into t values(null,'你好我好大家好', '你好我好大家好', '你好我好大家好', '你好我好大家好');
insert into t values(null, 'CUBRID', 'CUBRID', 'CUBRID',  'CUBRID');
insert into t values(null, 'ÀÀÏ', 'ÀÀÏ', 'ÀÀÏ',  'ÀÀÏ');

set names binary;
select id, replace(col_binary, col_binary), replace(col_binary, col_binary, col_euckr) from t order by id;
select id, replace(col_binary, col_euckr,col_binary+ col_euckr), replace(col_binary, col_utf8,col_binary+ col_utf8),replace(col_binary, col_iso,col_binary+ col_iso) from t order by id;


SELECT id,
REPLACE(col_binary,cast(_utf8'큐브' as string charset euckr) ,cast( _utf8'다이아' as string charset euckr)), 
REPLACE(col_euckr, cast(_utf8'큐브' as string charset euckr ), cast(_utf8'다이아' as string charset euckr) ), 
REPLACE(col_utf8, '큐브' , '다이아'  ), 
REPLACE(col_iso, cast(_utf8'큐브' as string charset euckr ), cast(_utf8'다이아' as string charset euckr)) from t where id=1;
SELECT id, 
REPLACE(col_binary,cast(_utf8'好' as string charset euckr) ,cast( _utf8'开心' as string charset euckr)), 
HEX(REPLACE(col_euckr, cast(_utf8'好' as string charset euckr) , cast(_utf8'开心' as string charset euckr) )), 
REPLACE(col_utf8, '好' , '开心'  ), 
REPLACE(col_iso, cast(_utf8'好' as string charset euckr) ,cast( _utf8'开心' as string charset euckr)) from t where id=2;

insert into t values(null,'abcdef', 'def', 'abcdef',  'abc');
select replace( col_binary, col_iso, col_euckr) from t where id=5;

drop t;
set names iso88591;
--+ holdcas off;

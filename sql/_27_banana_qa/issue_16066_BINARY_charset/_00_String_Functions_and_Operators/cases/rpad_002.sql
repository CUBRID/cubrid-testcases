
--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (col_binary varchar(100) collate binary, col_euckr varchar(100) collate euckr_bin, col_utf8 varchar(100) collate utf8_bin, col_iso varchar(100) collate iso88591_bin);
insert into t values('큐브리드', '큐브리드', '큐브리드', 'ÀÀÏ');
insert into t values('你好我好大家好', '你好我好大家好', '你好我好大家好', 'ÀÀÏ');
insert into t values('CUBRID', 'CUBRID', 'CUBRID', 'ÀÀÏ');


set names binary;
SELECT RPAD(col_binary,3,'?'), HEX(RPAD(col_euckr,3,'?')), RPAD(col_utf8,3,'?'), RPAD(col_iso,3,'?') from t order by 1;
SELECT RPAD(col_binary,4,'?'), HEX(RPAD(col_euckr,4,'?')), RPAD(col_utf8,4,'?'), RPAD(col_iso,4,'?') from t order by 1;
SELECT RPAD(col_binary,30,'?'), HEX(RPAD(col_euckr,30,'?')), RPAD(col_utf8,30,'?'), RPAD(col_iso,30,'?') from t order by 1;
SELECT RPAD(col_binary,30), HEX(RPAD(col_euckr,30)), RPAD(col_utf8,30), RPAD(col_iso,30) from t order by 1;

--CUBRIDSUS-17837
SELECT RPAD(col_binary,20,'a'), HEX(RPAD(col_euckr,20,'드')), RPAD(col_utf8,20,'好'), RPAD(col_iso,20,'Ï') from t order by 1;
SELECT RPAD(col_binary,3,'?'), Length(RPAD(col_binary,3,'?')), HEX(RPAD(col_euckr,3,'?')), Length(RPAD(col_euckr,3,'?'))from t order by 1;
SELECT RPAD(col_utf8,3,'?'), Length(RPAD(col_utf8,3,'?')),RPAD(col_iso,3,'?'), Length(RPAD(col_iso,3,'?')) from t order by 1;

drop table t;
set names iso88591;
--+ holdcas off;
--+ holdcas on;
set names binary;

SELECT RIGHT('CUBRID', 3), length(RIGHT('CUBRID', 3));
SELECT RIGHT ('CUBRID', 10), length(RIGHT ('CUBRID', 10));
SELECT RIGHT ('', 10), length(RIGHT ('', 10));
SELECT RIGHT ('CUBRID', null);
SELECT RIGHT(null , 3);

set names utf8;
drop table if exists t;
create table t (col_binary varchar(30) collate binary, col_euckr varchar(30) collate euckr_bin, col_utf8 varchar(30) collate utf8_bin, col_iso varchar(30) collate iso88591_bin);
insert into t values('큐브리드', '큐브리드', '큐브리드', 'ÀÀÏÏ');
insert into t values('你好我好大家好', '你好我好大家好', '你好我好大家好', 'ÀÀÏÏ');
insert into t values('CUBRID', 'CUBRID', 'CUBRID', 'ÀÀÏÏ');
create index i on t(col_binary);

SELECT RIGHT(col_binary,3), RIGHT(col_euckr,3), RIGHT(col_utf8,3), RIGHT(col_iso,3) from t order by 1;
SELECT RIGHT(col_binary,10), HEX(RIGHT(col_euckr,10)), RIGHT(col_utf8,10), RIGHT(col_iso,10) from t order by 1;
SELECT RIGHT(col_binary,null), RIGHT(col_euckr,null), RIGHT(col_utf8,null), RIGHT(col_iso,null) from t order by 1;

drop t;
set names iso88591;
--+ holdcas off;

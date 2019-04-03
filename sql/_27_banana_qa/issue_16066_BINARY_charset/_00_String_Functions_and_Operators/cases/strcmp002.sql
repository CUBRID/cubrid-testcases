--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (id int,col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values(1,'문자열', '문자열', '문자열', 'ÀÏ');
insert into t1 values(2,cast( _utf8'문자열' as string charset euckr), '문자열', '문자열', 'ÀÏ');
insert into t1 values(3,cast( _utf8'ÀÏ' as string charset iso88591), '문자열', '문자열', 'ÀÏ');

SELECT id,strcmp(col_binary , col_euckr) from t1 order by 1;
SELECT id,strcmp(col_binary , col_utf8 ) from t1 order by 1;
SELECT id,strcmp(col_binary , col_iso ) from t1 order by 1;
SELECT id,strcmp(col_euckr , col_utf8 ) from t1 order by 1;
SELECT id,strcmp(col_euckr , col_iso ) from t1 order by 1;
SELECT id,strcmp(col_utf8 , col_iso ) from t1 order by 1;

set names binary;
SELECT id,strcmp(col_binary , col_euckr) from t1 order by 1;
SELECT id,strcmp(col_binary , col_utf8 ) from t1 order by 1;
SELECT id,strcmp(col_binary , col_iso ) from t1 order by 1;
SELECT id,strcmp(col_euckr , col_utf8 ) from t1 order by 1;
SELECT id,strcmp(col_euckr , col_iso ) from t1 order by 1;
SELECT id,strcmp(col_utf8 , col_iso ) from t1 order by 1;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;

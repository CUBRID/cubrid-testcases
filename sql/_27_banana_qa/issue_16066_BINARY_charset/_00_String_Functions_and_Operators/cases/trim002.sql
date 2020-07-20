--+ holdcas on;
--CUBRIDSUS-17796

set names utf8;
drop table if exists t1;
create table t1 (id int,col_binary varchar(20) collate binary, col_euckr varchar(20) collate euckr_bin, col_utf8 varchar(20) collate utf8_bin, col_iso varchar(20) collate iso88591_bin);
insert into t1 values(1,'     문자열      ', '     문자열    ', '    문자열    ', '    ÀÏ   ');
insert into t1 values(2,cast( _utf8'문자열' as string charset euckr), '문자열', '문자열', 'ÀÏ');
insert into t1 values(3,cast( _utf8'ÀÏ' as string charset iso88591), '문자열', '문자열', 'ÀÏ');

SELECT id,trim(col_binary) from t1 order by 1;
SELECT id,trim(col_utf8 ) from t1 order by 1;
SELECT id,trim(col_euckr ) from t1 order by 1;
SELECT id,trim(col_iso ) from t1 order by 1;

SELECT id,trim('문'  from col_euckr) from t1 order by 1;
SELECT id,trim('문' from col_utf8 ) from t1 order by 1;
SELECT id,trim('문' from col_iso ) from t1 order by 1;


SELECT id,trim(LEADING '문' from col_euckr) from t1 order by 1;
SELECT id,trim(LEADING '문' from col_utf8 ) from t1 order by 1;
SELECT id,trim(LEADING '문' from col_iso ) from t1 order by 1;

SELECT id,trim(TRAILING '문' from col_euckr) from t1 order by 1;
SELECT id,trim(TRAILING '문' from col_utf8 ) from t1 order by 1;
SELECT id,trim(TRAILING '문' from col_iso ) from t1 order by 1;


SELECT id,trim(col_binary  from col_euckr) from t1 order by 1;
SELECT id,trim(col_binary from col_utf8 ) from t1 order by 1;
SELECT id,trim(col_binary from col_iso ) from t1 order by 1;
SELECT id,trim(col_euckr  from col_utf8 ) from t1 order by 1;
SELECT id,trim(col_euckr  from col_iso ) from t1 order by 1;
SELECT id,trim(col_utf8 from col_iso ) from t1 order by 1;


SELECT id,trim(TRAILING 'chr(0)' from col_euckr) from t1 order by 1;
SELECT id,trim(TRAILING 'chr(0)' from col_utf8 ) from t1 order by 1;
SELECT id,trim(TRAILING 'chr(0)' from col_iso ) from t1 order by 1;


set names binary;
SELECT id,trim(col_binary) from t1 order by 1;
SELECT id,trim(col_utf8 ) from t1 order by 1;
SELECT id,trim(col_euckr ) from t1 order by 1;
SELECT id,trim(col_iso ) from t1 order by 1;

SELECT id,trim('문'  from col_euckr) from t1 order by 1;
SELECT id,trim('문' from col_utf8 ) from t1 order by 1;
SELECT id,trim('문' from col_iso ) from t1 order by 1;


SELECT id,trim(LEADING '문' from col_euckr) from t1 order by 1;
SELECT id,trim(LEADING '문' from col_utf8 ) from t1 order by 1;
SELECT id,trim(LEADING '문' from col_iso ) from t1 order by 1;

SELECT id,trim(TRAILING '문' from col_euckr) from t1 order by 1;
SELECT id,trim(TRAILING '문' from col_utf8 ) from t1 order by 1;
SELECT id,trim(TRAILING '문' from col_iso ) from t1 order by 1;


SELECT id,trim(col_binary  from col_euckr) from t1 order by 1;
SELECT id,trim(col_binary from col_utf8 ) from t1 order by 1;
SELECT id,trim(col_binary from col_iso ) from t1 order by 1;
SELECT id,trim(col_euckr  from col_utf8 ) from t1 order by 1;
SELECT id,trim(col_euckr  from col_iso ) from t1 order by 1;
SELECT id,trim(col_utf8 from col_iso ) from t1 order by 1;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;

--+ holdcas on;
--CUBRIDSUS-17796

set names utf8;
drop table if exists t1;
create table t1 (col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values('     문자열      ', '     문자열    ', '    문자열    ', '    ÀÏ   ');
insert into t1 values(cast( _utf8'문자열' as string charset euckr), '문자열', '문자열', 'ÀÏ');
insert into t1 values(cast( _utf8'ÀÏ' as string charset iso88591), '문자열', '문자열', 'ÀÏ');

SELECT trim(col_binary) from t1;
SELECT trim(col_utf8 ) from t1;
SELECT trim(col_euckr ) from t1;
SELECT trim(col_iso ) from t1;

SELECT trim('문'  from col_euckr) from t1;
SELECT trim('문' from col_utf8 ) from t1;
SELECT trim('문' from col_iso ) from t1;


SELECT trim(LEADING '문' from col_euckr) from t1;
SELECT trim(LEADING '문' from col_utf8 ) from t1;
SELECT trim(LEADING '문' from col_iso ) from t1;

SELECT trim(TRAILING '문' from col_euckr) from t1;
SELECT trim(TRAILING '문' from col_utf8 ) from t1;
SELECT trim(TRAILING '문' from col_iso ) from t1;


SELECT trim(col_binary  from col_euckr) from t1;
SELECT trim(col_binary from col_utf8 ) from t1;
SELECT trim(col_binary from col_iso ) from t1;
SELECT trim(col_euckr  from col_utf8 ) from t1;
SELECT trim(col_euckr  from col_iso ) from t1;
SELECT trim(col_utf8 from col_iso ) from t1;


SELECT trim(TRAILING 'chr(0)' from col_euckr) from t1;
SELECT trim(TRAILING 'chr(0)' from col_utf8 ) from t1;
SELECT trim(TRAILING 'chr(0)' from col_iso ) from t1;


set names binary;
SELECT trim(col_binary) from t1;
SELECT trim(col_utf8 ) from t1;
SELECT trim(col_euckr ) from t1;
SELECT trim(col_iso ) from t1;

SELECT trim('문'  from col_euckr) from t1;
SELECT trim('문' from col_utf8 ) from t1;
SELECT trim('문' from col_iso ) from t1;


SELECT trim(LEADING '문' from col_euckr) from t1;
SELECT trim(LEADING '문' from col_utf8 ) from t1;
SELECT trim(LEADING '문' from col_iso ) from t1;

SELECT trim(TRAILING '문' from col_euckr) from t1;
SELECT trim(TRAILING '문' from col_utf8 ) from t1;
SELECT trim(TRAILING '문' from col_iso ) from t1;


SELECT trim(col_binary  from col_euckr) from t1;
SELECT trim(col_binary from col_utf8 ) from t1;
SELECT trim(col_binary from col_iso ) from t1;
SELECT trim(col_euckr  from col_utf8 ) from t1;
SELECT trim(col_euckr  from col_iso ) from t1;
SELECT trim(col_utf8 from col_iso ) from t1;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;

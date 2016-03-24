--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values('문자열문자열문자열', '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(cast( _utf8'문자열문자열문자열' as string charset euckr), '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(cast( _utf8'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ' as string charset iso88591), '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');

SELECT SUBSTRING(col_binary from 6 for 4) from t1;
SELECT SUBSTRING(col_euckr from 6 for 4 ) from t1;
SELECT SUBSTRING(col_utf8 from 6 for 4) from t1;
SELECT SUBSTRING(col_iso from 6 for 4 ) from t1;

SELECT SUBSTRING(col_binary from -6 for 4) from t1;
SELECT SUBSTRING(col_euckr from -6 for 4 ) from t1;
SELECT SUBSTRING(col_utf8 from -6 for 4) from t1;
SELECT SUBSTRING(col_iso from -6 for 4 ) from t1;


SELECT SUBSTRING(col_binary from chr(0) for 4) from t1;
SELECT SUBSTRING(col_euckr from chr(0) for 4 ) from t1;
SELECT SUBSTRING(col_utf8 from chr(0) for 4) from t1;
SELECT SUBSTRING(col_iso from chr(0) for 4 ) from t1;



set names binary;
SELECT SUBSTRING(col_binary from 6 for 4) from t1;
SELECT SUBSTRING(col_euckr from 6 for 4 ) from t1;
SELECT SUBSTRING(col_utf8 from 6 for 4) from t1;
SELECT SUBSTRING(col_iso from 6 for 4 ) from t1;

SELECT SUBSTRING(col_binary from -6 for 4) from t1;
SELECT SUBSTRING(col_euckr from -6 for 4 ) from t1;
SELECT SUBSTRING(col_utf8 from -6 for 4) from t1;
SELECT SUBSTRING(col_iso from -6 for 4 ) from t1;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;

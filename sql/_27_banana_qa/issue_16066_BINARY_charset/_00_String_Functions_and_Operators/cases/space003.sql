--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values('문자열', '문자열', '문자열', 'ÀÏ');
insert into t1 values(cast( _utf8'문자열' as string charset euckr), '문자열', '문자열', 'ÀÏ');
insert into t1 values(cast( _utf8'ÀÏ' as string charset iso88591), '문자열', '문자열', 'ÀÏ');

SELECT space(col_binary) from t1;
SELECT space(col_euckr ) from t1;
SELECT space(col_iso ) from t1;

set names utf8;
SELECT space(col_binary) from t1;
SELECT space(col_euckr ) from t1;
SELECT space(col_iso ) from t1;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;

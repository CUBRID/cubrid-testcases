--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values('문자열문자열문자열', '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(cast( _utf8'문자열문자열문자열' as string charset euckr), '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(cast( _utf8'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ' as string charset iso88591), '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');

SELECT TO_BASE64(col_binary) , FROM_BASE64(TO_BASE64(col_binary))  from t1;
SELECT TO_BASE64(col_euckr) , FROM_BASE64(TO_BASE64(col_euckr))  from t1;
SELECT TO_BASE64(col_utf8) , FROM_BASE64(TO_BASE64(col_utf8))  from t1;
SELECT TO_BASE64(col_iso) , FROM_BASE64(TO_BASE64(col_iso))  from t1;



set names binary;
SELECT TO_BASE64(col_binary) , FROM_BASE64(TO_BASE64(col_binary))  from t1;
SELECT TO_BASE64(col_euckr) , FROM_BASE64(TO_BASE64(col_euckr))  from t1;
SELECT TO_BASE64(col_utf8) , FROM_BASE64(TO_BASE64(col_utf8))  from t1;
SELECT TO_BASE64(col_iso) , FROM_BASE64(TO_BASE64(col_iso))  from t1;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;

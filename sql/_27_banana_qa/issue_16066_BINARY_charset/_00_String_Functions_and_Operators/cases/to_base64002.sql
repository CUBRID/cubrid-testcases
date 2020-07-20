--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (id int,col_binary varchar(30) collate binary, col_euckr varchar(30) collate euckr_bin, col_utf8 varchar(30) collate utf8_bin, col_iso varchar(30) collate iso88591_bin);
insert into t1 values(1,'문자열문자열문자열', '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(2,cast( _utf8'문자열문자열문자열' as string charset euckr), '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(3,cast( _utf8'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ' as string charset iso88591), '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');

SELECT id,TO_BASE64(col_binary) , FROM_BASE64(TO_BASE64(col_binary))  from t1 order by 1;
SELECT id,TO_BASE64(col_euckr) , FROM_BASE64(TO_BASE64(col_euckr))  from t1 order by 1;
SELECT id,TO_BASE64(col_utf8) , FROM_BASE64(TO_BASE64(col_utf8))  from t1 order by 1;
SELECT id,TO_BASE64(col_iso) , FROM_BASE64(TO_BASE64(col_iso))  from t1 order by 1;



set names binary;
SELECT id,TO_BASE64(col_binary) , FROM_BASE64(TO_BASE64(col_binary))  from t1 order by 1;
SELECT id,TO_BASE64(col_euckr) , FROM_BASE64(TO_BASE64(col_euckr))  from t1 order by 1;
SELECT id,TO_BASE64(col_utf8) , FROM_BASE64(TO_BASE64(col_utf8))  from t1 order by 1;
SELECT id,TO_BASE64(col_iso) , FROM_BASE64(TO_BASE64(col_iso))  from t1 order by 1;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;

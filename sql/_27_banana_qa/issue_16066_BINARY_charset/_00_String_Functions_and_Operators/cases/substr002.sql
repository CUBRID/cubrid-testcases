--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values('문자열문자열문자열', '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(cast( _utf8'문자열문자열문자열' as string charset euckr), '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(cast( _utf8'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ' as string charset iso88591), '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(chr(0), chr(0), chr(0), chr(0));


SELECT substr(col_binary , 6,4) from t1;
SELECT substr(col_euckr ,  6,4 ) from t1;
SELECT substr(col_utf8 ,  6,4) from t1;
SELECT substr(col_iso ,  6,4 ) from t1;

SELECT substr(col_binary , chr(0),4) from t1;
SELECT substr(col_euckr ,  chr(0),4 ) from t1;
SELECT substr(col_utf8 , chr(0),4) from t1;
SELECT substr(col_iso ,  chr(0),4 ) from t1;

SELECT substr(col_binary , -6,4) from t1;
SELECT substr(col_euckr ,  -6,4 ) from t1;
SELECT substr(col_utf8 ,  -6,4) from t1;
SELECT substr(col_iso , -6,4 ) from t1;


set names binary;
SELECT substr(col_binary , 6,4) from t1;
SELECT substr(col_euckr ,  6,4 ) from t1;
SELECT substr(col_utf8 ,  6,4) from t1;
SELECT substr(col_iso ,  6,4 ) from t1;

SELECT substr(col_binary , -6,4) from t1;
SELECT substr(col_euckr ,  -6,4 ) from t1;
SELECT substr(col_utf8 ,  -6,4) from t1;
SELECT substr(col_iso , -6,4 ) from t1;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;

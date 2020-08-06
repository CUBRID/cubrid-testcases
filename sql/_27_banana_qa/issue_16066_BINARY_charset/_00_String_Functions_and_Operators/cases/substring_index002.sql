--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (id int,col_binary varchar(30) collate binary, col_euckr varchar(30) collate euckr_bin, col_utf8 varchar(30) collate utf8_bin, col_iso varchar(30) collate iso88591_bin);
insert into t1 values(1,'문자열.문자열.문자열', '문자열.문자열.문자열', '문자열.문자열.문자열', 'ÀÏÀÏ.ÀÏÀÏ.ÀÏÀÏÀÏÀÏ');
insert into t1 values(2,cast( _utf8'문자열.문자열.문자열' as string charset euckr), '문자열.문자열.문자열', '문자열.문자열.문자열', 'ÀÏÀÏ.ÀÏÀÏ.ÀÏÀÏÀÏÀÏ');
insert into t1 values(3,cast( _utf8'ÀÏÀÏ.ÀÏÀÏ.ÀÏÀÏÀÏÀÏ' as string charset iso88591), '문자열.문자열.문자열', '문자열.문자열.문자열', 'ÀÏÀÏ.ÀÏÀÏ.ÀÏÀÏÀÏÀÏ');

SELECT id,SUBSTRING_INDEX(col_binary , '.','2') from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_euckr ,  '.','2' ) from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_utf8 ,  '.','2') from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_iso ,  '.','2' ) from t1 order by 1;

SELECT id,SUBSTRING_INDEX(col_binary , '문자열','2') from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_euckr ,'문자열' ,'2' ) from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_utf8 ,  '문자열','2') from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_iso , 'ÀÏÀÏ','2' ) from t1 order by 1;


SELECT id,SUBSTRING_INDEX(col_binary , chr(0),4) from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_euckr ,  chr(0),4 ) from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_utf8 , chr(0),4) from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_iso ,  chr(0),4 ) from t1 order by 1;


set names binary;
SELECT id,SUBSTRING_INDEX(col_binary , '.','2') from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_euckr ,  '.','2' ) from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_utf8 ,  '.','2') from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_iso ,  '.','2' ) from t1 order by 1;

SELECT id,SUBSTRING_INDEX(col_binary , '문자열','2') from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_euckr ,  '문자열','2' ) from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_utf8 ,  '문자열','2') from t1 order by 1;
SELECT id,SUBSTRING_INDEX(col_iso , 'ÀÏÀÏ','2' ) from t1 order by 1;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;

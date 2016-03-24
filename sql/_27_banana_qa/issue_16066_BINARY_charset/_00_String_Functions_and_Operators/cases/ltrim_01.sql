--+ holdcas on;
set names binary;
--CUBRIDSUS-17796
SELECT LTRIM('   123我我们');
SELECT LTRIM('안안123abc안' collate utf8_bin,'안');
SELECT LTRIM(_iso88591'123abc',_utf8'123');

-- prepare clause
prepare st1 from 'select ltrim(?,?)';
set names binary;
execute st1 using '我们', '我';
execute st1 using _utf8'abcdef', 'abcd';
drop prepare st1;

set names utf8;
drop table if exists t1;
create table t1 (col1 char(20) collate binary, col2 varchar(20), col3 string collate euckr_bin);
insert into t1 values('我们我中中国','ÀÏàó123abc',chr(0)||'안녕'||chr(0)||'하세요');

SELECT LTRIM(col1,'我') from t1;
SELECT LTRIM(col2,'À') from t1;
SELECT LTRIM(col2,_binary'À') from t1;
SELECT LTRIM(col3,chr(0)) from t1;

-- prepare clause
prepare st1 from 'select ltrim(col1,?) from t1';
prepare st2 from 'select ltrim(col2,?) from t1';
set names binary;
execute st1 using '我们';
execute st2 using _utf8'ÀÏ';
drop prepare st1;
drop prepare st2;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;
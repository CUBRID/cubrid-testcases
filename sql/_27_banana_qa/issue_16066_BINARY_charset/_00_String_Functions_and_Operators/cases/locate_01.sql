--+ holdcas on;
set names binary;
SELECT LOCATE('中','123abc我我们中国中',1);
SELECT LOCATE('안','123abc안녕하세요' collate utf8_bin,1);
SELECT LOCATE(_iso88591'a',_utf8'123abc',1);
SELECT LOCATE('中',' ',1);
SELECT LOCATE('中','',1);

-- prepare clause
prepare st1 from 'select locate(?,?,1)';
set names binary;
execute st1 using '我们', '我我们中国中';
execute st1 using _utf8'ef', 'abcd';
drop prepare st1;

set names utf8;
drop table if exists t1;
create table t1 (col1 char(30) collate binary, col2 varchar(20), col3 string collate euckr_bin);
insert into t1 values('123abc我我们中国中','123abcÀÏàó','안녕'||chr(0)||'하세요');

SELECT LOCATE('中',col1,1) from t1;
SELECT LOCATE('à',col2,1) from t1;
SELECT LOCATE(_binary'à',col2,1) from t1;
SELECT LOCATE(chr(0),col3,1) from t1;

-- prepare clause
set @a=chr(0);
prepare st1 from 'select locate(?,col1,1) from t1';
prepare st2 from 'select locate(?,col2,1) from t1';
prepare st3 from 'select locate(?,col3,1) from t1';
set names binary;
execute st1 using '中';
execute st2 using 'ó';
execute st3 using @a;
drop prepare st1;
drop prepare st2;
drop prepare st3;

drop table t1;
deallocate variable @a;

set names iso88591;
commit;
--+ holdcas off;

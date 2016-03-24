--+ holdcas on;
set names binary;
SELECT LPAD('123我我们',7);
SELECT LPAD('123abc안' collate utf8_bin,10,'녕하세요');
SELECT LPAD(_iso88591'123abc',10,_utf8'def');
SELECT LPAD(' ',2,'我' collate utf8_bin);
SELECT LPAD('',1,'我');

-- prepare clause
prepare st1 from 'select lpad(?,9,?)';
set names binary;
execute st1 using '我们', '我';
execute st1 using _utf8'ef', 'abcd';
drop prepare st1;

set names utf8;
drop table if exists t1;
create table t1 (col1 char(10) collate binary, col2 varchar(20), col3 string collate euckr_bin);
insert into t1 values('123abc我','123abcÀÏàó','안녕'||chr(0)||'하세요');

SELECT LPAD(col1,13,'中') from t1;
SELECT LPAD(col2,11,'a') from t1;
SELECT LPAD(col2,11,_binary'à') from t1;
SELECT LPAD(col3,8,chr(0)) from t1;

-- prepare clause
set @a=chr(0);
prepare st1 from 'select lpad(col1,12,?) from t1';
prepare st2 from 'select lpad(col2,11,?) from t1';
prepare st3 from 'select lpad(col3,8,?) from t1';
set names binary;
execute st1 using '中';
execute st2 using 'ó';
execute st3 using @a;
drop prepare st1;
drop prepare st2;
drop prepare st3;
deallocate variable @a;
drop table t1;

set names iso88591;
commit;
--+ holdcas off;

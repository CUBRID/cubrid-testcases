--+ holdcas on;
set names binary;
SELECT LCASE('A');
SELECT LOWER('A');
SELECT LOWER(_iso88591'123ABC');

-- prepare clause
prepare st1 from 'select lcase(?)';
prepare st2 from 'select lower(?)';
set names binary;
execute st1 using 'ABC';
execute st2 using _utf8'ABC';
drop prepare st1;
drop prepare st2;

set names utf8;
drop table if exists t1;
create table t1 (col1 char(30) collate binary, col2 varchar(20), col3 string collate euckr_bin);
insert into t1 values('123ABC','123ABC','123ABC');

SELECT LOWER(col1) from t1;
SELECT LCASE(col2) from t1;
SELECT LOWER(cast(col3 as string charset binary)) from t1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;

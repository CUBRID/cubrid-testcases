--+ holdcas on;
set names binary;
SELECT LEFT('123abc我我们中国中',10);
SELECT LEFT(cast(_utf8'123abc안녕하세요' as string charset euckr) collate euckr_bin,10);

-- prepare clause
prepare st1 from 'select left(?,10)';
set names binary;
execute st1 using '我我们中国中';
execute st1 using _utf8'123abc안녕하세요';
drop prepare st1;

set names utf8;
drop table if exists t1;
create table t1 (col1 char(30) collate binary, col2 varchar(20) collate utf8_bin, col3 string collate euckr_bin);
insert into t1 values('123abc我我们中国中','123abc我我们中国中','123abc안녕하세요');

SELECT LEFT(col1,10) from t1;
SELECT LEFT(col2,10) from t1;
SELECT cast(LEFT(cast(col3 as string charset binary),10) as string collate euckr_bin) from t1;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;

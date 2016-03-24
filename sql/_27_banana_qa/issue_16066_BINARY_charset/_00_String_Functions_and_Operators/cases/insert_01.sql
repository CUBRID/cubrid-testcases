--+ holdcas on;
set names binary;
SELECT INSERT('我我们中国中',2,2,'测试');
SELECT INSERT('다운로드' collate euckr_bin,2,2,'라라');
SELECT INSERT(_iso88591'abcdef',2,2,_utf8'测试');

-- prepare clause
prepare st1 from 'select insert(?,2,2,?)';
set names binary;
execute st1 using '我我们中国中', '이상';
-- CUBRIDSUS-17865
execute st1 using _utf8'abcd', 'ef';
drop prepare st1;

set names utf8;
drop table if exists t1;
create table t1 (col1 char(30) collate binary, col2 varchar(20), col3 string collate euckr_bin);
insert into t1 values('中国中我我们','中国我中我们','최신확장라');

SELECT INSERT(col1,2,2,'测试') from t1;
SELECT INSERT(col2,2,2,_binary'测试') from t1;

-- prepare clause
set @a=cast( _utf8'확장' as string charset euckr);
prepare st1 from 'select insert(col1, 2,2,?) from t1';
prepare st2 from 'select insert(col2, 2,2,?) from t1';
prepare st3 from 'select insert(col3, 2,2,?) from t1';
set names binary;
execute st1 using '测试';
execute st2 using '라';
execute st3 using @a;
drop prepare st1;
drop prepare st2;
drop prepare st3;

drop table t1;
deallocate variable @a;

set names iso88591;
commit;
--+ holdcas off;

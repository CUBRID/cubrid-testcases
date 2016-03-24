--+ holdcas on;
set names binary;
SELECT INSTR('123abc我我们中国中','中',1);
SELECT INSTR('123abc안녕하세요' collate euckr_bin,'안',1);
SELECT INSTR(_iso88591'123abc',_utf8'a',1);
SELECT INSTR(' ','中',1);
SELECT INSTR('','中',1);

-- prepare clause
prepare st1 from 'select instr(?,?,1)';
set names binary;
execute st1 using '我我们中国中', '我们';
execute st1 using _utf8'abcd', 'ef';
drop prepare st1;

set names utf8;
drop table if exists t1;
create table t1 (col1 char(30) collate binary, col2 varchar(20), col3 string collate euckr_bin);
insert into t1 values('123abc我我们中国中','123abc我我们中国中','123abc안녕하세요');

SELECT INSTR(col1,'中',1) from t1;
SELECT INSTR(col2,'中',1) from t1;
SELECT INSTR(col2,_binary'中',1) from t1;
SELECT INSTR(col3,'안',1) from t1;

-- prepare clause
set @a=cast( _utf8'안녕' as string charset euckr);
prepare st1 from 'select instr(col1, ?,1) from t1';
prepare st2 from 'select instr(col2, ?,1) from t1';
prepare st3 from 'select instr(col3, ?,1) from t1';
set names binary;
execute st1 using '中';
execute st2 using '我们';
execute st3 using @a;
drop prepare st1;
drop prepare st2;
drop prepare st3;

drop table t1;
deallocate variable @a;

set names iso88591;
commit;
--+ holdcas off;

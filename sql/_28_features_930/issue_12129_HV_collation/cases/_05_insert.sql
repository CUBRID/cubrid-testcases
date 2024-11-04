set names iso88591;


prepare s from 'select insert(?,?,?,?), collation (insert(?,?,?,?))';
execute s using '123456','1','2','xx', '123456','1','2','xx';

set names utf8;
execute s using '123456','1','2','xx', '123456','1','2','xx';

set names euckr;
execute s using '123456','1','2','xx', '123456','1','2','xx';

set names iso88591;
execute s using '123456','1','2',_utf8'xx', '123456','1','2',_utf8'xx';

execute s using _utf8'123456','1','2','xx', _utf8'123456','1','2','xx';

execute s using _utf8'123456','1','2',_euckr'xx', _utf8'123456','1','2',_euckr'xx';

drop table if exists t1;
create table t1 (s1 string collate utf8_en_ci);
insert into t1 values('a');
insert into t1 values('A');

prepare s from 'select insert(s1,?,?,?), collation (insert(s1,?,?,?)) from t1 order by 1';

execute s using '1','2',_euckr'xx', '1','2',_euckr'xx';

execute s using '1','2',_utf8'xx', '1','2',_utf8'xx';

execute s using '1','2',_iso88591'xx', '1','2',_iso88591'xx';

deallocate prepare s;

drop table t1;

set names iso88591;


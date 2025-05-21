set names iso88591;

drop table if exists t1;
create table t1 (i1 enum('a','b') collate utf8_en_ci, d1 double);
insert into t1 values(1, 1),(2,2);
select * from t1 order by 1;

prepare st from 'select group_concat(i1+? order by 1) , collation (group_concat(i1+? order by 1)) from t1 group by d1';
execute st using 2.2, 2.2;

execute st using 'x','x';

execute st using _utf8'x',_utf8'x';
execute st using _euckr'x',_euckr'x';
deallocate prepare st;

drop table t1;

set names iso88591;



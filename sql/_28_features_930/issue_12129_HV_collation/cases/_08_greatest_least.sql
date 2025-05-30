set names iso88591;

prepare s from 'select greatest (? , ? , ?), collation (greatest (? , ? , ?))';

execute s using 'a', 1, 2, 'a', 1, 2;

-- error:
execute s using _utf8'a', _iso88591'b', 2, _utf8'a', _iso88591'b', 2;

execute s using NULL, 1, 2, NULL, 1, 2;
deallocate prepare s;

drop table if exists t1;
create table t1 (s1 string collate utf8_en_ci);
insert into t1 values ('A'),('a');


prepare s from 'select greatest (? , s1 , ?), collation (greatest (? , s1 , ?)) from t1';
execute s using 'b', 1, 'b', 1;

execute s using 'b', NULL, 'b', NULL;

execute s using _euckr'b', 1, _euckr'b', 1;

execute s using _euckr'b', _utf8'A', _euckr'b', _utf8'A';
drop table t1;
deallocate prepare s;



-- LEAST

prepare s from 'select least (? , ? , ?), collation (least (? , ? , ?))';

execute s using 'a', 1, 2, 'a', 1, 2;

-- error:
execute s using _utf8'a', _iso88591'b', 2, _utf8'a', _iso88591'b', 2;

execute s using NULL, 1, 2, NULL, 1, 2;


create table t1 (s1 string collate utf8_en_ci);
insert into t1 values ('A'),('a');
deallocate prepare s;


prepare s from 'select least (? , s1 , ?), collation (least (? , s1 , ?)) from t1 order by 1,2';
execute s using 'b', 1, 'b', 1;

execute s using 'b', NULL, 'b', NULL;

execute s using _euckr'b', 1, _euckr'b', 1;
execute s using _euckr'b', _utf8'B', _euckr'b', _utf8'B';
deallocate prepare s;

drop table t1;


set names iso88591;



create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('cAbc'), ('caac');

insert into t2 values ('cAbc'), ('caac');


select trim ('c' FROM s1) from t1 order by 1;
select trim ('c' FROM s1) from t2 order by 1;


select trim ('c' FROM cast (s1 as string collate utf8_en_cs)) from t1 order by 1;
select trim ('c' FROM cast (s1 as string collate utf8_en_ci)) from t2 order by 1;


-- late binding
prepare s from 'select trim(? from s1 ) from t1 order by 1';
execute s using 'c';
deallocate prepare s;

prepare s from 'select trim( ? from s1 + ?) from t1 order by 1';
execute s using 'c', 'A';
deallocate prepare s;

prepare s from 'select trim(? from s1 + ?) from t2 order by 1';
execute s using 'c','A';
deallocate prepare s;


prepare s from 'select trim( ? from cast ((s1 + ?) as string collate utf8_en_ci)) from t2 order by 1';
execute s using 'c','A';
deallocate prepare s;


drop table t1;
drop table t2;

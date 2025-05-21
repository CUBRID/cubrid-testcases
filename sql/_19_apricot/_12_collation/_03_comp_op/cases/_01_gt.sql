create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Ab'),( 'aa');

insert into t2 values ('Ab'),( 'aa');


select * from t1 where s1 > 'AA'  order by 1;

prepare s from 'select * from t1 where s1 > ?  order by 1';
execute s using 'AA';
deallocate prepare s;

prepare s from 'select * from t1 where s1 > ? + ?  order by 1';
execute s using 'AA','0';
deallocate prepare s;


select * from t2 where s1 > 'AA' order by 1;

prepare s from 'select * from t2 where s1 > ?  order by 1';
execute s using 'AA';
deallocate prepare s;

prepare s from 'select * from t2 where s1 > ? + ?  order by 1';
execute s using 'AA','0';
deallocate prepare s;

select s1 from t1 where cast (s1 as string collate utf8_en_ci) > 'AA' order by 1;

select s1 from t1 where cast (s1 as string collate utf8_en_cs) > 'AA' order by 1;


drop table t1;
drop table t2;

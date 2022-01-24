create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('cdAb'), ('xxaa');

insert into t2 values ('cdAb'), ('xxaa');


select right (s1,2) from t1 order by 1;
select right (s1,2) from t2 order by 1;


select right (cast (s1 as string collate utf8_en_cs),2) from t1 order by 1;
select right (cast (s1 as string collate utf8_en_ci),2) from t2 order by 1;


-- late binding
prepare s from 'select right(? , ?)';
execute s using 'cdeAb',2;

prepare s from 'select right(s1 , ?) from t1 order by 1';
execute s using 2;

prepare s from 'select right(s1 , ?) from t2 order by 1';
execute s using 2;

prepare s from 'select right(? + s1,?) from t1 order by 1';
execute s using 'A','2';

prepare s from 'select right(? + s1,?) from t2 order by 1';
execute s using 'A',2;

prepare s from 'select right(cast ((? + s1) as string collate utf8_en_ci),?) from t2 order by 1';
execute s using 'A',2;


drop table t1;
drop table t2;

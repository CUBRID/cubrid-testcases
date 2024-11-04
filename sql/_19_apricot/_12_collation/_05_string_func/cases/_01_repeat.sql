create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Ab'), ('aa');

insert into t2 values ('Ab'), ('aa');


select repeat (s1,2) from t1 order by 1;
select repeat (s1,2) from t2 order by 1;


select repeat (cast (s1 as string collate utf8_en_cs),2) from t1 order by 1;
select repeat (cast (s1 as string collate utf8_en_ci),2) from t2 order by 1;


-- late binding
prepare s from 'select repeat(s1 + ?,2) from t1 order by 1';
execute s using 'A';
deallocate prepare s;

prepare s from 'select repeat(s1 + ?,2) from t2 order by 1';
execute s using 'A';
deallocate prepare s;


prepare s from 'select repeat(cast ((s1 + ?) as string collate utf8_en_ci),2) from t2 order by 1';
execute s using 'A';
deallocate prepare s;


drop table t1;
drop table t2;

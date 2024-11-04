create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Ab'), ('aa');

insert into t2 values ('Ab'), ('aa');


-- doesn't take into account collation for searching
select substring_index (s1,'.',1) from t1 order by 1;
select substring_index (s1,'.',1) from t2 order by 1;


-- late binding
prepare s from 'select substring_index(s1 ,?,?) from t1 order by 1';
execute s using '.',1;
deallocate prepare s;


select substring_index(t1.s1, t2.s1, 1) from t1,t2 order by 1;

select substring_index(t1.s1, cast (t2.s1 as string collate utf8_en_ci),1) from t1,t2 order by 1;


drop table t1;
drop table t2;

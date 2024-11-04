create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Ab'),( 'aa');

insert into t2 values ('Ab'),( 'aa');


select greatest (s1,'a') from t1 order by 1;
select greatest (s1,'a') from t2 order by 1;

prepare s from 'select greatest (s1,?) from t1 order by 1';
execute s using 'a';
deallocate prepare s;

prepare s from 'select greatest (s1,?) from t2 order by 1';
execute s using 'a';
deallocate prepare s;

select t1.s1,t2.s1,greatest (t1.s1,t2.s1) from t1,t2 order by 3;

select t1.s1,t2.s1,greatest (t1.s1,cast (t2.s1 as string collate utf8_en_ci)) from t1,t2 order by 1,2,3;

select t1.s1,t2.s1,greatest (cast (t1.s1 as string collate utf8_en_cs),t2.s1) from t1,t2 order by 1,2,3;


drop table t1;
drop table t2;

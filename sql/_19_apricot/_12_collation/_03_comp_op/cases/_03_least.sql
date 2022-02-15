create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Ab'),( 'aa');

insert into t2 values ('Ab'),( 'aa');


select least (s1,'a') from t1 order by 1;
select least (s1,'a') from t2 order by 1;

prepare s from 'select least (s1,?) from t1 order by 1';
execute s using 'a';

prepare s from 'select least (s1,?) from t2 order by 1';
execute s using 'a';

select t1.s1,t2.s1,least (t1.s1,t2.s1) from t1,t2 order by 1,2,3;

select t1.s1,t2.s1,least (t1.s1,cast (t2.s1 as string collate utf8_en_ci)) from t1,t2 order by 1,2,3;

select t1.s1,t2.s1,least (cast (t1.s1 as string collate utf8_en_cs),t2.s1) from t1,t2 order by 1,2,3;


drop table t1;
drop table t2;

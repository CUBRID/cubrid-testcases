create table t1 (s1 string collate utf8_en_ci, i integer);
create table t2 (s1 string collate utf8_en_cs, i integer);

insert into t1 values ('Aby', 1), ('aay',10);
insert into t1 values ('Aby', 2), ('aay',20);

insert into t2 values ('Aby', 1), ('aay',10);
insert into t2 values ('Aby', 2), ('aay',20);

select s1,i from t1 where s1 like 'a%' order by 1,2;

select s1,i from t1 where s1 like 'A%' order by 1,2;


select s1,i from t2 where s1 like 'a%' order by 1,2;

select s1,i from t2 where s1 like 'A%' order by 1,2;

prepare s from 'select s1,i from t1 where s1 like ? order by 1,2';
execute s using 'A%';
deallocate prepare s;

prepare s from 'select s1,i from t1 where s1 like ? order by 1,2';
execute s using 'a%';
deallocate prepare s;

select 1 from db_root where cast ('AA' as string collate utf8_en_ci) like 'a%';

select 1 from db_root where cast ('AA' as string collate utf8_en_ci) like 'A%';

drop table t1;
drop table t2;

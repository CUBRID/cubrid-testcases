drop table if exists t1;
create table t1(type int, a json);
insert into t1 values (1, json_object('age', 20));
insert into t1 values (2, json_object('age', 15));
insert into t1 values (2, json_object('age', 20));
insert into t1 values (2, json_object('age', 30));

select type, count(*), max(a->'$.age'), min(a->'$.age') from t1 group by type order by 1;
select type, count(*), max(cast(a->'$.age' as int)), min(cast(a->'$.age' as int)) from t1 group by type order by 1;

drop table if exists t1;


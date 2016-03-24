--conversion from enum to numeric types;
create table t1(e1 enum('a', 'b', 'c'));
insert into t1 values (3), (1), (2);

create table  t2(s smallint, i int, b bigint, f float, d double, n numeric, m monetary);
insert into t2 select e1, e1, e1, e1, e1, e1, e1 from t1;
select * from t2 order by 1, 2, 3, 4, 5, 6, 7;

select cast(e1 as smallint), cast(e1 as int), cast(e1 as bigint), cast(e1 as float), cast(e1 as double), cast(e1 as numeric), cast(e1 as monetary) from t1 order by 1;

drop table t1;
drop table t2;
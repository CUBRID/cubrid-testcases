--TEST: [Merge Statement] WITH CHECK OPTION condition is not checked when merging into a view.

autocommit on;

drop table if exists t1;
drop table if exists t2;

create table t1(a int, b int);
insert into t1 values(1, 100);

create table t2(a int, b int);
insert into t2 values(1, 200);
insert into t2 values(2, 200);

create view v as select * from t1 where b < 150 with check option;

--[er]
merge into v
using t2
on (t2.a=v.a)
when matched then
update
set v.b=t2.b;

--[er]
merge into v
using t2
on (t2.a=v.a)
when not matched then
insert values(t2.a, t2.b);

--[er]
insert into v values(1, 500);

select if(count(*)=0, 'ok', 'nok') from t1 where b in (200, 500);

drop view v;
drop table t1, t2;



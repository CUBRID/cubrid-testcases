--TEST: [Merge Statement] 'Resources exhausted in query generation.' error occurs when trying to update a non-updatable view in a merge statement.

drop table if exists t1;
drop table if exists t2;

create table t1(a int, b char(10));
create table t2(a int, b char(10));

create view v as select t2.a, t2.b from t1 inner join t2 on t1.a=t2.a;

--[er] update only
merge into v t
using t1 s
on(t.a=s.a)
when matched then
update set t.a=s.a, t.b=s.b;

--[er] insert only
merge into v t
using t1 s
on(t.a=s.a)
when not matched then
insert
values(s.a, s.b);

--[er] update+insert
merge into v t
using t1 s
on(t.a=s.a)
when matched then
update set t.a=s.a, t.b=s.b
when not matched then
insert
values(s.a, s.b);

drop view v;
drop table t1, t2;



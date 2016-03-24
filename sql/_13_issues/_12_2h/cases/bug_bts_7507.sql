--TEST: [Merge Statement] Segmentation fault occurs and core file dumped when using merge statement as a trigger action.

drop table if exists t1;
drop table if exists t2;

create table t1(a int, b int);
insert into t1 values(1, 22);
insert into t1 values(2, 22);

create table t2(a int, b int);
insert into t2 values(1, 10);
insert into t2 values(2, 10);

create trigger bef_upd before update on t1 execute
merge into t1
using t2
on (t2.a=t1.a)
when matched then
update
set t1.b=t2.b
when not matched then
insert
values(t2.a, t2.b);

--[er]
merge into t1
using t2
on (t2.a=t1.a)
when matched then
update
set t1.b=t2.b;

drop trigger bef_upd;
drop table t1, t2;

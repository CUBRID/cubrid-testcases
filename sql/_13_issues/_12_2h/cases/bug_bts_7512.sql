--TEST: [Merge Statement] the column that is referenced in the ON condition can be updated in a merge statement.

drop table if exists t1;
drop table if exists t2;

create table t1(a int, b int);
insert into t1 values(1, 22);

create table t2(a int, b int);
insert into t2 values(1, 10);
insert into t2 values(2, 100);

merge into t1
using t2
on (t2.a=t1.a)
when matched then
update
set t1.a=t2.a;


merge into t1
using t2
on (t2.a=t1.a)
when matched then
update
set t1.a=t2.a
when not matched then
insert values(t2.a, t2.b);

drop table t1, t2;





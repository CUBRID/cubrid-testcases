--TEST: [Merge Statement] Error message is too long in a merge statement when the attribute names are incorrect. NOT A BUG

drop table if exists t1;
drop table if exists t2;

create table t1(c int, d int);
create table t2(c int, d int);

merge into t1
using t2
on (t2.a=t1.a)
when matched then
update
set t1.b=t2.b
when not matched then
insert
values(t2.a, t2.b);

drop table t1, t2;

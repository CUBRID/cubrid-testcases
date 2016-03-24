--TEST: [Merge Statement] Check option error is not checked when merging into a view.


drop table if exists t1, t2;

create table t1(a int, b int);
insert into t1 values(1, 500);
create table t2(a int, b int);
insert into t2 values(1, 400);
insert into t2 values(2, 200);

create view v as select * from t1 where b < 300 with check option;


--check option exception should occur, but it succeeds.
merge into v
using t2
on (t2.a=v.a)
when not matched then
insert values(t2.a, t2.b);


select * from t1 order by 1;


drop view v;
drop table t1, t2;

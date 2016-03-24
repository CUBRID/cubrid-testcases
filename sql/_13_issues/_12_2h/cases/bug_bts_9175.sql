--TEST: [Merge Statement] In autocommit off mode, invalid value can be inserted into the target after 'check option exception' error occurred.



autocommit off;

create table t1(a int, b int);
insert into t1 values(1, 100);

create table t2(a int, b int);
insert into t2 values(1, 200);
insert into t2 values(2, 200);

create view v as select * from t1 where b < 150 with check option;

--[er] check option errlr
merge into v
using t2
on (t2.a=v.a)
when not matched then
insert values(t2.a, t2.b);

select * from t1 order by 1;


drop view v;
drop table t1, t2;

commit;

autocommit on;

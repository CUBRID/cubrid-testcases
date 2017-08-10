--TEST: [Merge Statement] Result is inconsistent with Oracle when the target and the source is the same table.


drop table if exists t;

create table t(a int, b char(10));

insert into t values(1, 'a');
insert into t values(2, 'b');


--inconsistent with Oracle
merge into t t
using t s
on (t.a=s.a)
when matched then 
update set t.b='updated';


select * from t order by 1;

drop table t;

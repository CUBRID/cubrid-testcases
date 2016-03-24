--TEST: [Merge Statement] Error occurs when preparing a merge statement with host variables.

drop table if exists t1;
drop table if exists t2;

create table t1(a int, b int);
create table t2(a int, b int);

insert into t1 values(1, 1);
insert into t1 values(2, 2);

insert into t2 values(1, 100);
insert into t2 values(2, 200);
insert into t2 values(3, 300);
insert into t2 values(4, 400);

prepare st from 'merge into t1
using t2
on (t2.a=t1.a)
when matched then
update set t1.b=t2.b where t2.b>?
when not matched then
insert values(?, ?)';
execute st using 90, 9, 900;
deallocate prepare st;


select if(count(*)=4, 'ok', 'nok') from t1 where b in (100, 200, 900);


drop table t1, t2;


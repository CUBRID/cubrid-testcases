set system parameters 'create_table_reuseoid=no';
--TEST: [Merge Statement] 'Check option exception' error occurs when merging into a view though there is no check option conflict.

drop table if exists t1, t2;

create table t1(a int, b int);
insert into t1 values(1, 100);
insert into t1 values(2, 200);

create table t2(a int, b int);
insert into t2 values(1, 99);
insert into t2 values(2, 999);

create view v as select * from t1 where b < 150 with check option;

merge into v
using t2
on (t2.a=v.a)
when matched then
update
set v.b=t2.b;

select * from v order by 1, 2;
select * from t1 order by 1, 2;

drop view v;
drop table t1, t2;
set system parameters 'create_table_reuseoid=yes';

--TEST: [Multi-table Update] Result becomes null when updating 2 tables with analytic functions.

drop table if exists t1;
drop table if exists t2;

create table t1(a int, b varchar, c smallint);
insert into t1 values(1, 'aaa', 33), (2, 'bbb', 11), (3, 'ccc', 11);

create table t2(a int, b varchar, c smallint);
insert into t2 values(1, 'a', 11), (2, 'a', 22), (3, 'ccc', 22);

update t1, t2 set t2.a=max(t1.a) over(), t1.a=max(t2.a) over() where t1.a=t2.a;
select * from t1 order by 1,2 asc,3 desc;
select * from t2 order by 1,2,3;


update t1, t2 set t2.a=count(*) over(partition by t1.c)+1000, t1.b=min(t2.b) over(partition by t1.b order by t1.c)||'ABC' where t1.a=t2.a;
select * from t1 order by 1,2,3 desc;
select * from t2 order by 1,2,3;


drop table t1, t2;



--TEST: [Multi-table Update] Inconsistent behaviour in multi-table update with single-table update when updating with analytic functions.


drop table if exists t;
drop table if exists t1;

create table t(a int);
insert into t values(1), (2), (3);

create table t1(a int);
insert into t1 values(1), (2), (3);

--update single table
update t set a=max(a) over();
--update multiple tables
update t t1, t t2 set t2.a=max(t1.a) over() where t1.a=t2.a;
select * from t order by 1;
select * from t1 order by 1;

--update single table
update t set a=max(a) over(order by a);
--update multiple tables
update t t1, t t2 set t2.a=max(t1.a) over(partition by t2.a) where t1.a=t2.a;
select * from t order by 1;
select * from t1 order by 1;


drop table t;
drop table t1;


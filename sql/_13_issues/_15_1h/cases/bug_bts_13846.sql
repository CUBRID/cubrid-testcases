-- Core is dumped when selecting analytic functions with IN expression.

-- setup env
drop table if exists t1;
create table t1 (a int, b int);
insert into t1 values (1,3),(5,1);

-- shall be OK
select a, b, avg(a) over (partition by b) in (select 1) from t1 order by 1, 2;
select a, b, avg(a) over (partition by b) in ((select 1)) from t1 order by 1, 2;

-- shall fail
select a, b, avg(a) over (partition by b) in (select b from t1) from t1 order by 1, 2;
select a, b, avg(a) over (partition by b) in ((select b from t1)) from t1 order by 1, 2;

-- shall be OK
select a, b, max(a) over (partition by b) in (select b from t1 where b=1) from t1 order by 1, 2;
select a, b, max(a) over (partition by b) in (select b from t1 where b=3) from t1 order by 1, 2;
select a, b, max(a) over (partition by b) in (select b from t1 where b=5) from t1 order by 1, 2;

-- shall be OK
select a, b, max(a) over (partition by b) in (select 1) from t1 order by 1, 2;
select a, b, max(a) over (partition by b) in ((select 1)) from t1 order by 1, 2;

-- shall fail
select a, b, max(a) over (partition by b) in (select b from t1) from t1 order by 1, 2;
select a, b, max(a) over (partition by b) in ((select b from t1)) from t1 order by 1, 2;

-- shall be OK
select a, b, max(a) over (partition by b) in (select b from t1 where b=1) from t1 order by 1, 2;
select a, b, max(a) over (partition by b) in (select b from t1 where b=3) from t1 order by 1, 2;
select a, b, max(a) over (partition by b) in (select b from t1 where b=5) from t1 order by 1, 2;

drop table if exists t1;

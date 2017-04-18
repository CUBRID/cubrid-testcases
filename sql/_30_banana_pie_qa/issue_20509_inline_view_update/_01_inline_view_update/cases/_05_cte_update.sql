-- TEST CASE For:
-- [CBRD-20509] Inline View Update : Update by using CTE

drop table if exists t1;

create table t1(f1 int, f2 int);

insert into t1 values(1,1);
select * from t1;

--  [NOK] cte update: not allowed ;
with cte (f1,f2) as (select f1,f2 from t1) update cte set f2=f2+1;

--  [NOK] cte inline view update: not allowed ;
with cte (f1,f2) as (select f1,f2 from t1) update (select f2 from cte) set f2=f2+1;

--  [NOK] cte inline view update (column alias) not allowed ;
with cte (f1,f2) as (select f1,f2 from t1) update (select f2 from cte) set f2=f2+1;
select * from t1;

drop table t1;


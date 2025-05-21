-- Verified for CBRD-25680
-- Check whether normal results are output when using correlated subqueries including external table columns in the select clause.
drop table if exists t1, t2, t3;
 
create table t1 (c1 int, c2 int);
insert into t1 select rownum, rownum       from db_class limit 10;
insert into t1 select rownum, rownum * -1  from db_class limit 10;
 
create table t2 (c1 int, c2 int);
insert into t2 select rownum, rownum * 100 from db_class limit 10;

create table t3(c1 int, c2 json);
insert into t3 values(1, '["a", "b"]');

evaluate 'subquery in select clause';
select /*+ recompile */ COUNT(DISTINCT (select a.c2 || b.c2 from t2 b where b.c1 = a.c1)) cnt from t1 a;
select /*+ recompile */ COUNT(DISTINCT (select a.c2 from t2 b where b.c1 = a.c1)) cnt from t1 a;
evaluate 'nested subquery';
select /*+ recompile */ COUNT(DISTINCT (select (select a.c2 from t2 c where c.c2=b.c2)  from t2 b where b.c1 = a.c1)) cnt from t1 a;
evaluate 'subquery in cte';
with cte_1 as (select /*+ recompile */ COUNT(DISTINCT (select a.c2 from t2 b where b.c1 = a.c1)) cnt from t1 a)
select * from cte_1;
evaluate 'subquery in where clause';
select /*+ recompile */ COUNT(a.c2) cnt from t1 a where a.c2=(select a.c2 from t2 b where a.c1=b.c1);
evaluate 'subquery in in clause';
select /*+ recompile */ COUNT(c.c2) cnt from t1 c where c.c2 in (select (select a.c2 from t2 b where a.c1=b.c1) from t1 a);
evaluate 'subquery in inline view';
select /*+ recompile */ COUNT(a.c1) cnt from t1 a, (select distinct (select a.c2 c2 from t2 b where a.c1=b.c1) c2 from t1 a) v where a.c2=v.c2;
evaluate 'with json_merge';
select /*+ recompile */ distinct (select json_merge(json_object(a.c2,'a'),b.c2) from t3 b where b.c1 = a.c1) code from t1 a where a.c1=1;

drop table if exists t1, t2, t3;

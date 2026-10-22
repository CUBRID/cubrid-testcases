/*
 * CBRD-27716: a correlated subquery that is a set operation (UNION, DIFFERENCE)
 * with a constant-false arm.
 *
 * Folding away the false arm left the remaining arm with the correlation level
 * of the inner scope, so the subquery was evaluated only once and every outer
 * row saw the first row's value. The folded query also shared its XASL cache
 * entry with the same query without the false arm.
 */
drop table if exists t_27716, one_27716, u_27716, c_27716;
create table t_27716 (v int);
insert into t_27716 values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
create table one_27716 (x int);
insert into one_27716 values (1);
create table u_27716 (v int, w int);
insert into u_27716 select v, 0 from t_27716;
create table c_27716 (v int);
insert into c_27716 select v from t_27716;

-- XASL cache: the false-arm query compiles first, then the plain query reuses its entry (both 10)
select count(*) from c_27716 t where (select t.v from db_root union all select 2 from db_root where 1 = 0) = t.v;
select count(*) from c_27716 t where (select t.v from db_root) = t.v;

-- scalar subquery in WHERE and in the SELECT list (10, s = v)
select /*+ recompile */ count(*) from t_27716 t where (select t.v from db_root union all select 2 from db_root where 1 = 0) = t.v;
select /*+ recompile */ v, (select t.v from db_root union all select 2 from db_root where 1 = 0) s from t_27716 t order by v;

-- false arm on the left, UNION distinct, DIFFERENCE (10 each)
select /*+ recompile */ count(*) from t_27716 t where (select 2 from db_root where 1 = 0 union all select t.v from db_root) = t.v;
select /*+ recompile */ count(*) from t_27716 t where (select t.v from one_27716 union select 2 from one_27716 where 1 = 0) = t.v;
select /*+ recompile */ count(*) from t_27716 t where (select t.v from one_27716 difference select 2 from one_27716 where 1 = 0) = t.v;

-- the remaining arm is itself a UNION (10)
select /*+ recompile */ count(*) from t_27716 t
 where (select t.v from one_27716 where t.v >= 0 union (select t.v from one_27716 union all select 2 from one_27716 where 1 = 0)) = t.v;

-- correlated subquery nested in the remaining arm (s = v)
select /*+ recompile */ v, (select (select t.v from db_root) from one_27716 union all select 2 from one_27716 where 1 = 0) s from t_27716 t order by v;

-- two levels of correlation (10)
select /*+ recompile */ count(*) from t_27716 t
 where exists (select 1 from one_27716 o where (select t.v + o.x from db_root union all select 2 from db_root where 1 = 0) = t.v + 1);

-- EXISTS (5) and IN (10)
select /*+ recompile */ count(*) from t_27716 t where exists (select 1 from one_27716 where t.v < 5 union all select 1 from one_27716 where 1 = 0);
select /*+ recompile */ count(*) from t_27716 t where t.v in (select t.v from one_27716 union all select 2 from one_27716 where 1 = 0);

-- false arm folded inside a derived table (s = 2v)
select /*+ recompile */ v, (select z from (select t.v * 2 z from one_27716 union all select 7 from one_27716 where 1 = 0) d) s from t_27716 t order by v;

-- ORDER BY and LIMIT of the folded set operation (s = v)
select /*+ recompile */ v, (select t.v from one_27716 union all select 2 from one_27716 where 1 = 0 order by 1 limit 1) s from t_27716 t order by v;

-- UPDATE (10 rows with w = v) and DELETE (all 10 rows)
update u_27716 u set w = (select u.v from one_27716 union all select 2 from one_27716 where 1 = 0);
select count(*) from u_27716 where w = v;
delete from u_27716 u where (select u.v from one_27716 union all select 2 from one_27716 where 1 = 0) = u.v;
select count(*) from u_27716;

-- controls: uncorrelated (10), both arms false (0)
select /*+ recompile */ count(*) from t_27716 t where (select 1 from db_root union all select 2 from db_root where 1 = 0) = 1;
select /*+ recompile */ count(*) from t_27716 t where (select t.v from one_27716 where 1 = 0 union all select 2 from one_27716 where 1 = 0) is not null;

drop table t_27716, one_27716, u_27716, c_27716;

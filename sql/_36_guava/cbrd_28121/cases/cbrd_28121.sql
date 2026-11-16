-- Verification for CBRD-28121 : A nested-loop join is driven by a full parallel heap scan instead of a one-key primary-key lookup
-- because the parallel cost discount ignores the driving scan's row count.
-- The workers of a parallel nested loop share the chain by the rows of its driving scan, so a driving scan
-- estimated to return one row cannot divide the work of the joins above it among them.
-- t_28121_3.b = 'X' reads no key of pk_t_28121_3_b_c: it must be an index scan, not a parallel full scan.
-- A driving scan returning many rows keeps the parallel nested loop.
-- Q1/Q2 fix the join method to nested loops so that no heap scan of the other tables runs (or not) in parallel
-- with the server's free workers: only the access to t_28121_3 decides the plan shown.

drop table if exists t_28121_1;
drop table if exists t_28121_2;
drop table if exists t_28121_3;
create table t_28121_1 (a int primary key, x int);
create table t_28121_2 (a int primary key, b varchar(10));
create table t_28121_3 (b varchar(10), c int, primary key (b, c));

insert into t_28121_1
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 400)
select rownum, rownum from cte a, cte b limit 100000;

insert into t_28121_2
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 400)
select rownum, case when mod (rownum, 2) = 0 then 'X' else 'Y' end from cte a, cte b limit 100000;

insert into t_28121_3
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 400)
select 'K' || rownum, rownum from cte a, cte b limit 120000;

update statistics on t_28121_1, t_28121_2, t_28121_3 with fullscan;

set trace on;

evaluate 'Q1. key condition in the ON clause: index scan of t_28121_3';
select /*+ recompile USE_NL */ count (*)
from t_28121_1 t1 inner join t_28121_2 t2 on t1.a = t2.a inner join t_28121_3 t3 on t2.b = t3.b and t3.b = 'X';
show trace;

evaluate 'Q2. key condition derived from the WHERE clause: index scan of t_28121_3';
select /*+ recompile USE_NL */ count (*)
from t_28121_1 t1 inner join t_28121_2 t2 on t1.a = t2.a inner join t_28121_3 t3 on t2.b = t3.b
where t2.b = 'X';
show trace;

evaluate 'Q3. selected rows: index scan of t_28121_3';
select /*+ recompile */ t1.a, t2.b, t3.c
from t_28121_1 t1 inner join t_28121_2 t2 on t1.a = t2.a inner join t_28121_3 t3 on t2.b = t3.b and t3.b = 'X'
order by 1;
show trace;

evaluate 'Q4. many driving rows: the parallel nested loop stays';
select /*+ recompile USE_NL */ count (*)
from t_28121_3 t3 inner join t_28121_2 t2 on t2.a = t3.c inner join t_28121_1 t1 on t1.a = t2.a
where t3.c <= 20000;
show trace;

set trace off;

drop table t_28121_1;
drop table t_28121_2;
drop table t_28121_3;

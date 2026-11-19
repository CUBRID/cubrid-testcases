-- Verification for CBRD-28121 : A nested-loop join is driven by a full parallel heap scan instead of a one-key primary-key lookup
-- because the parallel cost discount ignores the driving scan's row count.
-- The workers of a parallel nested loop share the chain by the rows of its driving scan, so a driving scan
-- estimated to return fewer than 256 rows does not make the chain parallel and the joins above it are not discounted.
-- t_28121_3.b = 'X' reads no key of pk_t_28121_3_b_c: it must be an index scan, not a parallel full scan.
-- Q1-Q3 fix the join method to nested loops so that the trace does not depend on a hash join input read in parallel
-- (with the free workers of the server, and with CBRD-28112): only the access to t_28121_3 decides the plan shown.
-- Q4/Q5 show the planner's own plan: a driving scan estimated to return 255 rows (NDV 470 of 120000) keeps the nested
-- loop serial and its scan marked parallel, one estimated to return 261 rows (NDV 460) makes the nested loop parallel.

drop table if exists t_28121_1;
drop table if exists t_28121_2;
drop table if exists t_28121_3;
drop table if exists t_28121_4;
create table t_28121_1 (a int primary key, x int);
create table t_28121_2 (a int primary key, b varchar(10));
create table t_28121_3 (b varchar(10), c int, primary key (b, c));
create table t_28121_4 (a int, g470 int, g460 int, pad char(200));

insert into t_28121_1
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 400)
select rownum, rownum from cte a, cte b limit 100000;

insert into t_28121_2
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 400)
select rownum, case when mod (rownum, 2) = 0 then 'X' else 'Y' end from cte a, cte b limit 100000;

insert into t_28121_3
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 400)
select 'K' || rownum, rownum from cte a, cte b limit 120000;

insert into t_28121_4
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 400)
select rownum, mod (rownum, 470), mod (rownum, 460), 'p' from cte a, cte b limit 120000;

update statistics on t_28121_1, t_28121_2, t_28121_3, t_28121_4 with fullscan;

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
select /*+ recompile USE_NL */ t1.a, t2.b, t3.c
from t_28121_1 t1 inner join t_28121_2 t2 on t1.a = t2.a inner join t_28121_3 t3 on t2.b = t3.b and t3.b = 'X'
order by 1;
show trace;

set trace off;

evaluate 'Q4. driving scan estimated to return 255 rows: serial nested loop over a parallel scan';
--@queryplan
select /*+ recompile ORDERED USE_NL */ count (*)
from t_28121_4 t4, t_28121_2 t2
where t4.g470 = 7 and t2.a = t4.a;

evaluate 'Q5. driving scan estimated to return 261 rows: parallel nested loop';
--@queryplan
select /*+ recompile ORDERED USE_NL */ count (*)
from t_28121_4 t4, t_28121_2 t2
where t4.g460 = 7 and t2.a = t4.a;

drop table t_28121_1;
drop table t_28121_2;
drop table t_28121_3;
drop table t_28121_4;

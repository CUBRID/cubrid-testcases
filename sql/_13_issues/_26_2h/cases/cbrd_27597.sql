/**
 *  This test case verifies CBRD-27597: a parallel list scan over a CTE result must read
 *  every row when the CTE body itself ran as a parallel heap scan.
 *
 *  A parallel heap scan leaves its rows in one list file per worker, chained to the first
 *  one. The CTE result is kept by two list ids, the CTE and its non-recursive part, and only
 *  one of them kept that chain. A parallel list scan over the other one read the first
 *  worker file only, so the outer query over a recursive CTE and a CTE that reads another
 *  CTE lost rows without an error. The fix gives both list ids the chain.
 *
 *  Every tested query is followed by the same query with no_parallel_scan in the CTE body,
 *  which leaves a single list file, and the two result blocks must match. CTP runs with
 *  test_mode=yes, which masks volatile trace values to '?'. The traces show the parallel
 *  heap scan of the CTE body and the parallel temp scan of the CTE result.
 *
 *  Coverage:
 *    Case 1:  the outer query aggregates a recursive CTE
 *    Case 2:  the outer query groups a recursive CTE by level
 *    Case 3:  a materialized CTE aggregates another materialized CTE
 *    Case 4:  a materialized CTE groups another materialized CTE
 *    Case 5:  the outer query and another CTE read the same materialized CTE
 *    Case 6:  a materialized CTE groups a recursive CTE, which was read in full before the fix
 *    Case 7:  the CTE runs as a parallel subquery job before the outer query reads it
 */

drop table if exists t_digit, t_src;

create table t_digit (v int);
insert into t_digit values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

-- 40000 rows of 128 hex characters: the heap and every CTE result list span more than ten
-- times the parallel scan threshold of test_mode (32 pages)
create table t_src (id int, pad varchar(128));
insert into t_src select rownum, sha2 (rownum, 512) from t_digit a, t_digit b, t_digit c, t_digit d, t_digit e limit 40000;
update statistics on t_src with fullscan;

set trace on;


evaluate 'Case 1: the outer query aggregates a recursive CTE; result = no_parallel_scan in the CTE body';
with recursive r (id, pad, lvl) as (select id, pad, 1 from t_src union all select id, pad, lvl + 1 from r where lvl < 3 and mod (id, lvl * 2) = 0) select /*+ recompile */ count(*), sum (lvl) from r;
show trace;
with recursive r (id, pad, lvl) as (select /*+ no_parallel_scan */ id, pad, 1 from t_src union all select id, pad, lvl + 1 from r where lvl < 3 and mod (id, lvl * 2) = 0) select /*+ recompile */ count(*), sum (lvl) from r;


evaluate 'Case 2: the outer query groups a recursive CTE by level; result = no_parallel_scan in the CTE body';
with recursive r (id, pad, lvl) as (select id, pad, 1 from t_src union all select id, pad, lvl + 1 from r where lvl < 3 and mod (id, lvl * 2) = 0) select /*+ recompile */ lvl, count(*), sum (mod (id, 7)) from r group by lvl order by lvl;
show trace;
with recursive r (id, pad, lvl) as (select /*+ no_parallel_scan */ id, pad, 1 from t_src union all select id, pad, lvl + 1 from r where lvl < 3 and mod (id, lvl * 2) = 0) select /*+ recompile */ lvl, count(*), sum (mod (id, 7)) from r group by lvl order by lvl;


evaluate 'Case 3: a materialized CTE aggregates another materialized CTE; result = no_parallel_scan in the CTE body';
with c_all as (select /*+ materialize */ id, pad from t_src), c_cnt as (select /*+ materialize */ count(*) cnt, sum (mod (id, 7)) s from c_all) select /*+ recompile */ cnt, s from c_cnt;
show trace;
with c_all as (select /*+ materialize no_parallel_scan */ id, pad from t_src), c_cnt as (select /*+ materialize */ count(*) cnt, sum (mod (id, 7)) s from c_all) select /*+ recompile */ cnt, s from c_cnt;


evaluate 'Case 4: a materialized CTE groups another materialized CTE; result = no_parallel_scan in the CTE body';
with c_all as (select /*+ materialize */ id, pad from t_src), c_grp as (select /*+ materialize */ case when id <= 5000 then 'a' when id <= 15000 then 'b' else 'c' end g, count(*) cnt from c_all group by g) select /*+ recompile */ g, cnt from c_grp order by g;
show trace;
with c_all as (select /*+ materialize no_parallel_scan */ id, pad from t_src), c_grp as (select /*+ materialize */ case when id <= 5000 then 'a' when id <= 15000 then 'b' else 'c' end g, count(*) cnt from c_all group by g) select /*+ recompile */ g, cnt from c_grp order by g;


evaluate 'Case 5: the outer query and another CTE read the same materialized CTE; result = no_parallel_scan in the CTE body';
with c_all as (select /*+ materialize */ id, pad from t_src), c_cnt as (select /*+ materialize */ count(*) cnt from c_all) select /*+ recompile */ 'by outer query' src, count(*) cnt from c_all union all select 'by another CTE', cnt from c_cnt order by src;
show trace;
with c_all as (select /*+ materialize no_parallel_scan */ id, pad from t_src), c_cnt as (select /*+ materialize */ count(*) cnt from c_all) select /*+ recompile */ 'by outer query' src, count(*) cnt from c_all union all select 'by another CTE', cnt from c_cnt order by src;


evaluate 'Case 6: a materialized CTE groups a recursive CTE; result = no_parallel_scan in the CTE body';
with recursive r (id, pad, lvl) as (select id, pad, 1 from t_src union all select id, pad, lvl + 1 from r where lvl < 3 and mod (id, lvl * 2) = 0), c_lvl as (select /*+ materialize */ lvl, count(*) cnt from r group by lvl) select /*+ recompile */ lvl, cnt from c_lvl order by lvl;
show trace;
with recursive r (id, pad, lvl) as (select /*+ no_parallel_scan */ id, pad, 1 from t_src union all select id, pad, lvl + 1 from r where lvl < 3 and mod (id, lvl * 2) = 0), c_lvl as (select /*+ materialize */ lvl, count(*) cnt from r group by lvl) select /*+ recompile */ lvl, cnt from c_lvl order by lvl;


-- the CTE and the derived table are two uncorrelated subqueries without a list read between them,
-- so they run as parallel subquery jobs and SUBQUERY shows its own parallel workers line
evaluate 'Case 7: the CTE runs as a parallel subquery job before the outer query reads it; result = no_parallel_scan in the CTE body';
with c_all as (select /*+ materialize */ id, pad from t_src) select /*+ recompile */ count(*), sum (mod (c_all.id, 7)), max (x.cnt) from c_all, (select /*+ no_merge */ count(*) cnt from t_digit) x;
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
with c_all as (select /*+ materialize no_parallel_scan */ id, pad from t_src) select /*+ recompile */ count(*), sum (mod (c_all.id, 7)), max (x.cnt) from c_all, (select /*+ no_merge */ count(*) cnt from t_digit) x;

drop table t_digit, t_src;

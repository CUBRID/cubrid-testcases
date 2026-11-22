/**
 *  This test case verifies CBRD-28155: a query whose two derived tables each hold a
 *  correlated UNION IN subquery returns its row in client-server mode.
 *
 *  Before the fix the UNION of the IN subquery, which the inner scan of the join in each
 *  derived table evaluates per row, got a parallel subquery executor of its own, and the
 *  query never returned. Now no executor is made inside that subquery, and the two
 *  derived tables still run as parallel subquery jobs (fixed by CUBRID/cubrid#8556).
 *
 *  Each query is followed by its NO_PARALLEL_SUBQUERY twin, whose result block must be
 *  identical. CTP masks digits, so only trace tokens are checked.
 *
 *  Coverage:
 *    Case 1:  the issue query, both derived tables hold the IN subquery
 *    Case 2:  only the first derived table holds it, the second is a plain count
 */

drop table if exists t_drv, t_probe, t_key;

-- the issue data: the hang needs no data size, only the correlated UNION under a join
create table t_drv (col_a int, col_b int);
create table t_probe (col_a int);
create table t_key (col_x int, col_y int);
insert into t_drv values (1, 2), (5, 3);
insert into t_probe values (2), (3);
insert into t_key values (2, 9), (3, 9), (3, 7);
update statistics on t_drv, t_probe, t_key with fullscan;

set trace on;


evaluate 'Case 1: the issue query; result = no_parallel_subquery';
select /*+ recompile */ q.c, o.c from (select count(*) c from t_drv, t_probe where t_probe.col_a in (select col_x from t_key where t_key.col_y = t_drv.col_a union select col_x from t_key where t_key.col_x = t_drv.col_b)) q, (select count(*) c from t_drv, t_probe where t_probe.col_a in (select col_x from t_key where t_key.col_y = t_drv.col_a union select col_x from t_key where t_key.col_x = t_drv.col_b)) o;
show trace;
select /*+ no_parallel_subquery */ q.c, o.c from (select count(*) c from t_drv, t_probe where t_probe.col_a in (select col_x from t_key where t_key.col_y = t_drv.col_a union select col_x from t_key where t_key.col_x = t_drv.col_b)) q, (select count(*) c from t_drv, t_probe where t_probe.col_a in (select col_x from t_key where t_key.col_y = t_drv.col_a union select col_x from t_key where t_key.col_x = t_drv.col_b)) o;


evaluate 'Case 2: the second derived table is a plain count; result = no_parallel_subquery';
select /*+ recompile */ q.c, o.c from (select count(*) c from t_drv, t_probe where t_probe.col_a in (select col_x from t_key where t_key.col_y = t_drv.col_a union select col_x from t_key where t_key.col_x = t_drv.col_b)) q, (select count(*) c from t_drv) o;
show trace;
-- trace goes off before the last twin: its plan would stay in the session
set trace off;
select /*+ no_parallel_subquery */ q.c, o.c from (select count(*) c from t_drv, t_probe where t_probe.col_a in (select col_x from t_key where t_key.col_y = t_drv.col_a union select col_x from t_key where t_key.col_x = t_drv.col_b)) q, (select count(*) c from t_drv) o;

drop table t_drv, t_probe, t_key;

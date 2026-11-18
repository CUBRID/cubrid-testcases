/**
 *  This test case verifies CBRD-28126: a parallel subquery that runs after the first
 *  executor of the statement finished waiting returns its rows, and a correlated
 *  subquery evaluated per row of a joined scan keeps the outer row intact.
 *
 *  Before the fix the first executor closed the shared job queue when its jobs ended,
 *  so a later executor, such as a WHERE subquery evaluated during the scan, waited
 *  forever for jobs the queue had dropped (CBRD-27823). Now that executor runs its
 *  jobs itself and its trace line carries no parallel workers token. A correlated
 *  subquery over a UNION under a joined scan got an executor whose jobs cleared the
 *  outer row values. It now runs without one while the rest stays parallel.
 *
 *  Each query is followed by its NO_PARALLEL_SUBQUERY twin, whose result block must
 *  be identical. CTP masks digits, so only trace tokens are checked.
 *
 *  Coverage:
 *    Case 1:  WHERE subquery over a UNION after the FROM UNION finished
 *    Case 2:  select list subquery over a UNION after the FROM UNION finished
 *    Case 3:  NOT IN subquery over a UNION
 *    Case 4:  WHERE subquery over an inline UNION derived table
 *    Case 5:  select list subquery with a join of two UNION views
 *    Case 6:  nested parallel subqueries, UNION arms that hold UNIONs
 *    Case 7:  one arm fails, the error is the same and the next query runs
 *    Case 8:  correlated subquery over a UNION under a joined scan
 *    Case 9:  the same subquery inside an arm of a parallel UNION
 *    Case 10: the same subquery in the WHERE of the joined scan
 */

drop view if exists v_both;
drop table if exists t_lo, t_hi, t_mix;

-- two rows per table: the executor needs no data size, only two or more UNION arms
create table t_lo (col_a int);
create table t_hi (col_a int);
create table t_mix (col_a int, col_b varchar(10));
insert into t_lo values (1), (2);
insert into t_hi values (3), (4);
insert into t_mix values (1, 'a'), (3, 'b'), (5, 'c');
create view v_both as select col_a from t_lo union all select col_a from t_hi;
update statistics on t_lo, t_hi, t_mix with fullscan;

set trace on;


evaluate 'Case 1: WHERE subquery after the FROM UNION; result = no_parallel_subquery';
select /*+ recompile */ a.col_a from v_both a where a.col_a = (select max (b.col_a) from v_both b) order by 1;
show trace;
select /*+ no_parallel_subquery */ a.col_a from v_both a where a.col_a = (select max (b.col_a) from v_both b) order by 1;


evaluate 'Case 2: select list subquery after the FROM UNION; result = no_parallel_subquery';
select /*+ recompile */ a.col_a, (select max (b.col_a) from v_both b) from v_both a order by 1;
show trace;
select /*+ no_parallel_subquery */ a.col_a, (select max (b.col_a) from v_both b) from v_both a order by 1;


evaluate 'Case 3: NOT IN subquery over a UNION; result = no_parallel_subquery';
select /*+ recompile */ a.col_a from v_both a where a.col_a not in (select b.col_a from v_both b where b.col_a >= 3) order by 1;
show trace;
select /*+ no_parallel_subquery */ a.col_a from v_both a where a.col_a not in (select b.col_a from v_both b where b.col_a >= 3) order by 1;


evaluate 'Case 4: WHERE subquery over an inline UNION; result = no_parallel_subquery';
select /*+ recompile */ a.col_a from v_both a where a.col_a = (select max (x.col_a) from (select col_a from t_lo union all select col_a from t_hi) x) order by 1;
show trace;
select /*+ no_parallel_subquery */ a.col_a from v_both a where a.col_a = (select max (x.col_a) from (select col_a from t_lo union all select col_a from t_hi) x) order by 1;


evaluate 'Case 5: select list subquery with a join of two UNION views; result = no_parallel_subquery';
select /*+ recompile */ a.col_a, (select max (col_a) from v_both) from v_both a, v_both b where a.col_a = b.col_a order by 1;
show trace;
select /*+ no_parallel_subquery */ a.col_a, (select max (col_a) from v_both) from v_both a, v_both b where a.col_a = b.col_a order by 1;


evaluate 'Case 6: nested parallel subqueries; result = no_parallel_subquery';
select /*+ recompile */ x.col_a, y.col_a from (select col_a from v_both union all select col_a from t_mix) x, (select col_a from t_mix union all select col_a from v_both) y where x.col_a = y.col_a order by 1, 2;
show trace;
select /*+ no_parallel_subquery */ x.col_a, y.col_a from (select col_a from v_both union all select col_a from t_mix) x, (select col_a from t_mix union all select col_a from v_both) y where x.col_a = y.col_a order by 1, 2;


evaluate 'Case 7: one arm fails; result = the same error, then rows';
-- no trace here: which arm the error stops before it scans depends on timing
select x.col_a from (select col_a / 0 as col_a from t_lo union all select col_a from t_hi) x, (select col_a from t_mix union all select col_a from t_lo) y where x.col_a = y.col_a;
select /*+ no_parallel_subquery */ x.col_a from (select col_a / 0 as col_a from t_lo union all select col_a from t_hi) x, (select col_a from t_mix union all select col_a from t_lo) y where x.col_a = y.col_a;
select a.col_a from v_both a order by 1;


evaluate 'Case 8: correlated subquery under a joined scan; result = no_parallel_subquery';
select /*+ recompile */ a.col_a, (select count (*) from v_both v where v.col_a >= a.col_a) cnt from v_both a, t_mix b where a.col_a = b.col_a order by 1;
show trace;
select /*+ no_parallel_subquery */ a.col_a, (select count (*) from v_both v where v.col_a >= a.col_a) cnt from v_both a, t_mix b where a.col_a = b.col_a order by 1;


evaluate 'Case 9: the same subquery inside an arm of a parallel UNION; result = no_parallel_subquery';
select /*+ recompile */ * from (select a.col_a, (select count (*) from v_both v where v.col_a >= a.col_a) cnt from t_lo a, t_mix b where a.col_a = b.col_a union all select col_a, 0 from t_hi union all select col_a, 0 from t_lo) z order by 1, 2;
show trace;
select /*+ no_parallel_subquery */ * from (select a.col_a, (select count (*) from v_both v where v.col_a >= a.col_a) cnt from t_lo a, t_mix b where a.col_a = b.col_a union all select col_a, 0 from t_hi union all select col_a, 0 from t_lo) z order by 1, 2;


evaluate 'Case 10: the same subquery in the WHERE of the joined scan; result = no_parallel_subquery';
select /*+ recompile */ a.col_a, b.col_b from v_both a, t_mix b where a.col_a = b.col_a and b.col_a <= (select count (*) from v_both v where v.col_a >= a.col_a) order by 1;
show trace;
-- trace goes off before the last twin: its plan would stay in the session
set trace off;
select /*+ no_parallel_subquery */ a.col_a, b.col_b from v_both a, t_mix b where a.col_a = b.col_a and b.col_a <= (select count (*) from v_both v where v.col_a >= a.col_a) order by 1;

drop view v_both;
drop table t_lo, t_hi, t_mix;

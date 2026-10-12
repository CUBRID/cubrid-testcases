/*
 * This test case verifies CBRD-27488 : the multi range optimization (MRO)
 * eligibility checks were reordered so that the constant-time checks run
 * before pt_has_aggregate().
 *
 * qo_check_iscan_for_multi_range_opt() (optimizer/plan_generation.c) is
 * called for every candidate index scan plan. It used to call
 * pt_has_aggregate(), which walks the whole parse tree, before the
 * constant-time tests "has ORDER BY", "not DISTINCT" and "has a LIMIT /
 * ORDERBY_NUM bound". MRO needs all three, so a query without ORDER BY or
 * LIMIT paid a full tree walk per candidate plan for nothing, and because
 * pt_has_aggregate() caches only a positive result, the walk repeated for
 * every candidate (multi-table joins: more candidates and a bigger tree,
 * so the compile time grew with their product). The change only moves the
 * constant-time tests in front of pt_has_aggregate(), the decision itself is
 * unchanged. This case pins that decision: every query shape that was
 * MRO-eligible must still show "(multi_range_opt)" in the plan, every
 * ineligible shape (aggregate, DISTINCT, no LIMIT, LIMIT above
 * multi_range_optimization_limit, NO_MULTI_RANGE_OPT hint) must not, and the
 * rows must be right. The plan is printed with --@queryplan (cost and
 * cardinality are masked by CTP, identifiers contain no digits so nothing
 * else is masked) and the statements carry the recompile hint so a cached
 * plan can never be served.
 *
 * MRO shape: WHERE col_a IN (...) [AND col_b = ...] ORDER BY next index
 * column LIMIT n, with n <= multi_range_optimization_limit (default 100),
 * on an index that starts with the equality / IN columns and continues
 * with the ORDER BY columns.
 *
 * Data: 20,000 rows, c = id = 1..20000 (unique), a = id mod 10,
 *       b = (id / 10) mod 100 (integer division), indexes (a, c) and (a, b, c).
 *
 *   Case 1: a IN (1,2,3) ORDER BY c LIMIT 10              -> MRO on (a, c)
 *   Case 2: a IN (1,2,3) ORDER BY c DESC LIMIT 5          -> MRO, descending
 *   Case 3: a = 1 AND b IN (10,20,30) ORDER BY c LIMIT 10 -> MRO on (a, b, c)
 *   Case 4: aggregate (GROUP BY a, MAX(c))                -> no MRO
 *   Case 5: DISTINCT                                      -> no MRO
 *   Case 6: no LIMIT                                      -> no MRO
 *   Case 7: LIMIT 10 with multi_range_optimization_limit=5 -> no MRO,
 *           LIMIT 5 -> MRO again
 *   Case 8: NO_MULTI_RANGE_OPT hint                       -> no MRO
 */

drop table if exists mro_t;

create table mro_t (a int, b int, c int, pad char(100));
insert into mro_t
  select mod(rownum, 10), mod(rownum / 10, 100), rownum, lpad('x', 100, 'x')
  from db_class x, db_class y, db_class z, db_class w limit 20000;

create index idx_mro_ac on mro_t (a, c);
create index idx_mro_abc on mro_t (a, b, c);
update statistics on mro_t with fullscan;

select count(*), count(distinct a), count(distinct b), min(c), max(c) from mro_t;

-- Case 1: IN list on the first index column, ORDER BY the next one, LIMIT 10 -> MRO
--         expected rows: (1,1) (2,2) (3,3) (1,11) (2,12) (3,13) (1,21) (2,22) (3,23) (1,31)
evaluate '[1] a IN (1,2,3) ORDER BY c LIMIT 10 -> (multi_range_opt)';
--@queryplan
select /*+ recompile */ a, c from mro_t where a in (1, 2, 3) order by c limit 10;

-- Case 2: same with ORDER BY c DESC -> MRO with the descending index scan
--         expected rows: (3,19993) (2,19992) (1,19991) (3,19983) (2,19982)
evaluate '[2] a IN (1,2,3) ORDER BY c DESC LIMIT 5 -> (multi_range_opt)';
--@queryplan
select /*+ recompile */ a, c from mro_t where a in (1, 2, 3) order by c desc limit 5;

-- Case 3: equality prefix, IN list on the second column, ORDER BY the third -> MRO on (a, b, c)
--         expected rows: c = 101 201 301 1101 1201 1301 2101 2201 2301 3101 (a = 1, b = 10/20/30)
evaluate '[3] a = 1 AND b IN (10,20,30) ORDER BY c LIMIT 10 -> (multi_range_opt)';
--@queryplan
select /*+ recompile */ a, b, c from mro_t where a = 1 and b in (10, 20, 30) order by c limit 10;

-- Case 4: aggregate query -> MRO stays disabled (CBRD-22696 guard, now tested last)
--         expected rows: (1,19991,2000) (2,19992,2000) (3,19993,2000)
evaluate '[4] aggregate: GROUP BY a with MAX(c) -> no (multi_range_opt)';
--@queryplan
select /*+ recompile */ a, max(c) max_c, count(*) cnt from mro_t where a in (1, 2, 3) group by a order by a limit 10;

-- Case 5: DISTINCT -> no MRO, same rows as case 1
evaluate '[5] DISTINCT -> no (multi_range_opt)';
--@queryplan
select /*+ recompile */ distinct a, c from mro_t where a in (1, 2, 3) order by c limit 10;

-- Case 6: no LIMIT -> no MRO, expected rows: (1,1) (2,2) (3,3) (1,11) (2,12) (3,13)
evaluate '[6] no LIMIT -> no (multi_range_opt)';
--@queryplan
select /*+ recompile */ a, c from mro_t where a in (1, 2, 3) and c <= 13 order by c;

-- Case 7: the LIMIT must not exceed multi_range_optimization_limit
--         expected rows: as case 1 (10 rows) then its first 5 rows
evaluate '[7] LIMIT 10 with multi_range_optimization_limit=5 -> no (multi_range_opt); LIMIT 5 -> (multi_range_opt)';
set system parameters 'multi_range_optimization_limit=5';
--@queryplan
select /*+ recompile */ a, c from mro_t where a in (1, 2, 3) order by c limit 10;
--@queryplan
select /*+ recompile */ a, c from mro_t where a in (1, 2, 3) order by c limit 5;
set system parameters 'multi_range_optimization_limit=default';

-- Case 8: NO_MULTI_RANGE_OPT hint -> no MRO, same rows as case 1
evaluate '[8] NO_MULTI_RANGE_OPT hint -> no (multi_range_opt)';
--@queryplan
select /*+ recompile NO_MULTI_RANGE_OPT */ a, c from mro_t where a in (1, 2, 3) order by c limit 10;

drop table mro_t;

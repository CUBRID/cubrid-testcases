/**
 * This test case verifies CBRD-27351: a view referenced more than once in a query is executed once
 * Scenario file: results that sharing the view must not change
 * Description: Results that a wrong sharing of the view result would change.
 *              R1: a view with ORDER BY read by a select-list subquery and by the FROM clause; the rows of both
 *              must keep the order of the view.
 *              R2: a shared view read by an uncorrelated subquery inside a derived table of the FROM clause. The
 *              view must be fully built before it is read, also when the subqueries of the statement may run in
 *              parallel (an empty result read too early gives 0 rows).
 *              R3: a query sharing a view and a query reading two views that differ only in a constant print alike
 *              in the XASL cache key once the views are expanded and the constants made host variables. The second
 *              query must not use the plan of the first one (it would read the result of one view for both).
 *              R4: the shared view is executed before the statement. An error of the view body shows even where
 *              each reference would not have been executed before the fix (here, the outer table is empty).
 *              R5-R7: the workers of a parallel scan run again a subquery that reads the shared view: an IN
 *              subquery under OR (R5), a scalar subquery in a condition pushed into the input of a hash join (R6),
 *              a scalar subquery alone in the select list (R7). Each worker must read the result the statement
 *              made, not an empty copy (before the fix: 0 rows, or NULL for R7). The table is large enough for a
 *              parallel scan; each query is followed by its PARALLEL(0) twin, whose result must be the same.
 * Coverage: ORDER BY view, parallel subquery execution of a statement that shares a view, XASL cache, error of a
 *           view executed first, subqueries run again by the workers of a parallel scan
 */

--
-- test data
--

drop view if exists v_27351_ord;
drop view if exists v_27351_rev;
drop view if exists v_27351_hv;
drop view if exists v_27351_hw;
drop view if exists v_27351_zero;
drop view if exists v_27351_pv;
drop table if exists t_27351_ord;
drop table if exists t_27351_li;
drop table if exists t_27351_su;
drop table if exists t_27351_hv;
drop table if exists t_27351_empty;
drop table if exists t_27351_pt;
drop table if exists t_27351_pu;

create table t_27351_ord (a int, b varchar(10));
insert into t_27351_ord values (1, 'z'), (2, 'y'), (3, 'x');
create view v_27351_ord (a, b) as select a, b from t_27351_ord order by b;

create table t_27351_su (s_suppkey int primary key, s_name varchar(25));
insert into t_27351_su select level, 'Supplier#' || level from db_root connect by level <= 1000;

create table t_27351_li (l_suppkey int, l_shipdate date, l_price int, l_disc int);
insert into t_27351_li
  select mod(level, 1000) + 1, date'2020-01-01' + mod(level, 120), mod(level * 7, 97) * 10, mod(level, 10)
  from db_root connect by level <= 20000;

update statistics on t_27351_li, t_27351_su with fullscan;

create view v_27351_rev (supplier_no, total_revenue) as
  select l_suppkey, sum(l_price * (100 - l_disc)) from t_27351_li
  where l_shipdate >= date'2020-01-01' and l_shipdate < date'2020-04-01' group by l_suppkey;

create table t_27351_hv (k int, x int);
insert into t_27351_hv select mod(level, 10), level from db_root connect by level <= 1000;
create view v_27351_hv (k, s) as select k, sum(x) from t_27351_hv where x > 100 group by k;
create view v_27351_hw (k, s) as select k, sum(x) from t_27351_hv where x > 900 group by k;

create table t_27351_empty (k int);
create view v_27351_zero (k, q) as select k, sum(x) / min(x - x) from t_27351_hv group by k;

create table t_27351_pt (k int, x int);
insert into t_27351_pt select mod(level, 1000), mod(level, 97) from db_root connect by level <= 300000;
create table t_27351_pu (k int, y int);
insert into t_27351_pu select mod(level, 1000), mod(level, 89) from db_root connect by level <= 300000;
update statistics on t_27351_pt, t_27351_pu with fullscan;
create view v_27351_pv (k, s) as select k, sum(y) from t_27351_pu group by k;

evaluate 'R1: ORDER BY view, select-list subquery reference and FROM reference (expected 3,2,1)';
select /*+ recompile */ (select group_concat(s.a) from v_27351_ord s) g1, group_concat(x.b) g2, max(x.a)
from v_27351_ord x;

select /*+ recompile */ d.g, x.a, x.b
from (select group_concat(s.a) g from v_27351_ord s) d, v_27351_ord x
order by x.a;

evaluate 'R2: view read by an uncorrelated subquery inside a derived table (expected 1000, 500500)';
set trace on;
select /*+ recompile parallel(4) no_parallel_scan */ count(*), sum(x.c)
from v_27351_rev a,
     (select /*+ ordered use_nl */ distinct s1.s_suppkey c
      from t_27351_su s1, t_27351_su s2
      where s1.s_suppkey = s2.s_suppkey
        and s2.s_suppkey <= (select count(*) from v_27351_rev r)) x
where a.supplier_no = x.c;
show trace;
set trace off;

select /*+ recompile parallel(4) */ count(*), sum(x.c)
from v_27351_rev a,
     (select /*+ ordered use_nl */ distinct s1.s_suppkey c
      from t_27351_su s1, t_27351_su s2
      where s1.s_suppkey = s2.s_suppkey
        and s2.s_suppkey <= (select count(*) from v_27351_rev r)) x
where a.supplier_no = x.c;

evaluate 'R3: XASL cache, a query sharing a view and then a query reading two views that differ in a constant';
select count(*), sum(a.s), sum(b.s) from v_27351_hv a, v_27351_hv b where a.k = b.k;
select count(*), sum(a.s), sum(b.s) from v_27351_hv a, v_27351_hw b where a.k = b.k;
select count(*), sum(a.s), sum(b.s) from v_27351_hw a, v_27351_hv b where a.k = b.k;

evaluate 'R4: an error of the shared view body shows although the outer table is empty';
select /*+ recompile */ (select max(q) from v_27351_zero), (select min(q) from v_27351_zero) from t_27351_empty;

evaluate 'R5: IN subquery under OR run again by the workers of a parallel scan (expected the same as PARALLEL(0))';
select /*+ recompile parallel(4) */ count(*), sum(t.x)
from t_27351_pt t, v_27351_pv a where t.k = a.k and (t.k in (select b.k from v_27351_pv b) or t.x = -1);
select /*+ recompile parallel(0) */ count(*), sum(t.x)
from t_27351_pt t, v_27351_pv a where t.k = a.k and (t.k in (select b.k from v_27351_pv b) or t.x = -1);

evaluate 'R6: scalar subquery in a condition pushed into the input of a hash join (expected the same as PARALLEL(0))';
select /*+ recompile parallel(4) */ count(*), sum(t.x)
from t_27351_pt t, v_27351_pv a where t.k = a.k and t.x >= (select min(b.s) / 1000 from v_27351_pv b);
select /*+ recompile parallel(0) */ count(*), sum(t.x)
from t_27351_pt t, v_27351_pv a where t.k = a.k and t.x >= (select min(b.s) / 1000 from v_27351_pv b);

evaluate 'R7: scalar subquery alone in the select list run by the workers of a parallel scan (expected no NULL)';
select /*+ recompile parallel(4) */ t.k, (select max(b.s) from v_27351_pv b) sq, a.s
from t_27351_pt t, v_27351_pv a where t.k = a.k and t.x = 7 and t.k < 3 order by 1, 2, 3;
select /*+ recompile parallel(0) */ t.k, (select max(b.s) from v_27351_pv b) sq, a.s
from t_27351_pt t, v_27351_pv a where t.k = a.k and t.x = 7 and t.k < 3 order by 1, 2, 3;

--
-- clean up test data
--

drop view v_27351_ord;
drop view v_27351_rev;
drop view v_27351_hv;
drop view v_27351_hw;
drop view v_27351_zero;
drop view v_27351_pv;
drop table t_27351_ord;
drop table t_27351_li;
drop table t_27351_su;
drop table t_27351_hv;
drop table t_27351_empty;
drop table t_27351_pt;
drop table t_27351_pu;

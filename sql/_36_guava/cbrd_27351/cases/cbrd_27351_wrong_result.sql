/**
 * This test case verifies CBRD-27351: a view referenced more than once in a query is executed once
 * Scenario file: results that sharing the view must not change
 * Description: Results that a wrong sharing of the view result would change.
 *              R1: a view with ORDER BY. A select-list subquery reference is generated before the FROM reference and
 *              does not reuse its result; its rows must keep the order of the view.
 *              R2: a shared view read by an uncorrelated subquery inside a derived table of the FROM clause. The
 *              view must be fully built before it is read, also when the subqueries of the statement may run in
 *              parallel (an empty result read too early gives 0 rows).
 *              R3: a reference in a correlated subquery of a query scanned in parallel. The workers run the subquery
 *              on their own copy of the plan, where the view is not built.
 *              R4: a member in an uncorrelated subquery of the expression of a query scanned in parallel. The
 *              workers evaluate the expression on their own copy of the plan, where the view is not built.
 * Coverage: ORDER BY view, parallel subquery execution of a statement that shares a view, parallel heap scan of a
 *           query with a reference in a correlated or uncorrelated subquery
 */

--
-- test data
--

drop view if exists v_27351_ord;
drop view if exists v_27351_rev;
drop table if exists t_27351_ord;
drop table if exists t_27351_li;
drop table if exists t_27351_su;
drop view if exists v_27351_px;
drop table if exists t_27351_px;

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

create table t_27351_px (k int, x int);
insert into t_27351_px
  select (rownum - 1) mod 1000, rownum mod 97
  from (select level from db_root connect by level <= 1000) a, (select level from db_root connect by level <= 300) b;
create view v_27351_px (k, s, c) as select k, sum(x), count(*) from t_27351_px group by k;
update statistics on t_27351_px with fullscan;

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

select /*+ recompile parallel(4) */ count(*), sum(x.c)
from v_27351_rev a,
     (select /*+ ordered use_nl */ distinct s1.s_suppkey c
      from t_27351_su s1, t_27351_su s2
      where s1.s_suppkey = s2.s_suppkey
        and s2.s_suppkey <= (select count(*) from v_27351_rev r)) x
where a.supplier_no = x.c;

evaluate 'R3: reference in a correlated subquery of a query scanned in parallel (expected 157742, 3943575)';
select /*+ recompile parallel(4) */ count(*), sum(t.x)
from v_27351_px a, t_27351_px t
where a.k = t.k and t.x <= (select max(b.c) - 250 + 0 * t.x from v_27351_px b);

evaluate 'R4: member in an uncorrelated subquery of a query scanned in parallel (expected 300000, 14399278)';
select /*+ recompile parallel(4) */ count(*), sum(t.x)
from t_27351_px t, v_27351_px a
where t.k = a.k and (exists (select 1 from v_27351_px b where 1 = 1) or t.x = -1);

--
-- clean up test data
--

drop view v_27351_ord;
drop view v_27351_rev;
drop table t_27351_ord;
drop table t_27351_li;
drop table t_27351_su;
drop view v_27351_px;
drop table t_27351_px;

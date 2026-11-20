/**
 * This test case verifies CBRD-27351: a view referenced more than once in a query is executed once
 * Scenario file: references that share one result of the view
 * Description: When a view is not merged into the query and no predicate is pushed into any of its references, and
 *              one of its references is in the FROM clause of the statement, the view is executed once and every
 *              reference reads that result. The trace shows one execution of the view and the other references
 *              scanning the result list (before the fix: one execution per reference).
 * Coverage: FROM + uncorrelated subquery, 3 references, derived table, UNION ALL / INTERSECT / DIFFERENCE operands,
 *           outer join, hash/merge join, references using a subset of the columns of the representative in a
 *           different order, a select-list subquery generated before the representative, owner name and synonym,
 *           DISTINCT view, ORDER BY view, ALL over a view without subviews
 */

--
-- test data
--

drop synonym if exists s_27351_rev;
drop view if exists v_27351_rev;
drop view if exists v_27351_dist;
drop view if exists v_27351_ordv;
drop table if exists t_27351_li;
drop table if exists t_27351_su;

create table t_27351_su (s_suppkey int primary key, s_name varchar(25));
insert into t_27351_su select level, 'Supplier#' || level from db_root connect by level <= 20;

create table t_27351_li (l_suppkey int, l_shipdate date, l_price int, l_disc int);
insert into t_27351_li
  select mod(level, 20) + 1, date'2020-01-01' + mod(level, 120), mod(level * 7, 97) * 10, mod(level, 10)
  from db_root connect by level <= 2000;

update statistics on t_27351_li, t_27351_su with fullscan;

create view v_27351_rev (supplier_no, total_revenue) as
  select l_suppkey, sum(l_price * (100 - l_disc)) from t_27351_li
  where l_shipdate >= date'2020-01-01' and l_shipdate < date'2020-04-01' group by l_suppkey;

create view v_27351_dist (k) as select distinct l_suppkey from t_27351_li;
create view v_27351_ordv (k, p) as select l_suppkey, sum(l_price) from t_27351_li group by l_suppkey order by 2;

create synonym s_27351_rev for v_27351_rev;

set trace on;

evaluate 'S1: FROM reference + uncorrelated subquery reference (TPC-H Q15 shape)';
select /*+ recompile parallel(0) */ s_suppkey, s_name, total_revenue
from t_27351_su, v_27351_rev
where s_suppkey = supplier_no and total_revenue = (select max(total_revenue) from v_27351_rev)
order by s_suppkey;
show trace;

evaluate 'S2: three FROM references';
select /*+ recompile parallel(0) */ count(*), sum(a.total_revenue), sum(c.total_revenue)
from v_27351_rev a, v_27351_rev b, v_27351_rev c
where a.supplier_no = b.supplier_no and b.supplier_no = c.supplier_no;
show trace;

evaluate 'S3: FROM reference + reference in a derived table that follows it';
select /*+ recompile parallel(0) */ count(*)
from v_27351_rev r, (select distinct supplier_no from v_27351_rev) d
where d.supplier_no = r.supplier_no;
show trace;

evaluate 'S3b: control, the reference in a derived table before the FROM reference is generated first and does not reuse';
select /*+ recompile parallel(0) */ count(*)
from (select distinct supplier_no from v_27351_rev) d, v_27351_rev r
where d.supplier_no = r.supplier_no;
show trace;

evaluate 'S4: one reference in each UNION ALL operand';
select /*+ recompile parallel(0) */ max(total_revenue) from v_27351_rev
union all
select min(total_revenue) from v_27351_rev
order by 1;
show trace;

evaluate 'S5: INTERSECT and DIFFERENCE operands';
select /*+ recompile parallel(0) */ supplier_no from v_27351_rev
intersect
select supplier_no from v_27351_rev
order by 1;
show trace;

select /*+ recompile parallel(0) */ supplier_no from v_27351_rev
difference
select supplier_no from v_27351_rev;
show trace;

evaluate 'S6: left outer join';
select /*+ recompile parallel(0) */ count(*), count(b.supplier_no)
from v_27351_rev a left outer join v_27351_rev b on a.supplier_no = b.supplier_no + 10;
show trace;

evaluate 'S7: hash join and merge join of the references';
select /*+ recompile parallel(0) use_hash ordered */ count(*), sum(a.total_revenue - b.total_revenue)
from v_27351_rev a, v_27351_rev b where a.supplier_no = b.supplier_no;
show trace;

select /*+ recompile parallel(0) use_merge ordered */ count(*), sum(a.total_revenue - b.total_revenue)
from v_27351_rev a, v_27351_rev b where a.supplier_no = b.supplier_no;
show trace;

evaluate 'S8: references using different columns in a different order';
select /*+ recompile parallel(0) */ a.total_revenue, b.supplier_no
from v_27351_rev a, v_27351_rev b
where a.supplier_no = b.supplier_no and b.supplier_no <= (select count(*) / 4 from v_27351_rev)
order by 2;
show trace;

evaluate 'S9: select-list subquery generated before the FROM reference + WHERE subquery';
select /*+ recompile parallel(0) */ (select count(*) from v_27351_rev), count(*)
from v_27351_rev a
where a.total_revenue > (select avg(total_revenue) from v_27351_rev);
show trace;

evaluate 'S10: owner name and synonym of the same view';
select /*+ recompile parallel(0) */ count(*), sum(a.total_revenue - b.total_revenue)
from dba.v_27351_rev a, s_27351_rev b where a.supplier_no = b.supplier_no;
show trace;

evaluate 'S11: DISTINCT view';
select /*+ recompile parallel(0) */ count(*)
from v_27351_dist a, v_27351_dist b where a.k = b.k;
show trace;

evaluate 'S12: ORDER BY view';
select /*+ recompile parallel(0) */ count(*), sum(a.p) from v_27351_ordv a, v_27351_ordv b where a.k = b.k;
show trace;

evaluate 'S13: ALL over a view without subviews';
select /*+ recompile parallel(0) */ count(*) from all v_27351_rev a, all v_27351_rev b where a.supplier_no = b.supplier_no;
show trace;

set trace off;

--
-- clean up test data
--

drop synonym s_27351_rev;
drop view v_27351_dist;
drop view v_27351_ordv;
drop view v_27351_rev;
drop table t_27351_li;
drop table t_27351_su;

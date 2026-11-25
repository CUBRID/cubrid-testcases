/**
 * This test case verifies CBRD-27351: a view referenced more than once in a query is executed once
 * Scenario file: references that share one result of the view
 * Description: When a view is referenced twice or more in a SELECT statement, outside correlated subqueries, and a
 *              reference is neither merged into its query nor given a pushed predicate, the view is executed once
 *              before the statement, as a CTE, and every reference reads that result. The trace shows one execution
 *              of the view under CTE (before the fix: one execution per reference). The result is unchanged.
 * Coverage: FROM + uncorrelated subquery (TPC-H Q15 shape), 3 references, derived table, UNION ALL operands,
 *           references using different columns, IN and HAVING subqueries, nested subqueries, no reference in the
 *           FROM clause, DISTINCT view, set operation view, a predicate pushed into one of three references,
 *           references reading no column, ROWNUM view, analytic function in the statement, two share groups,
 *           UNION ALL view read by the FROM clause and a WHERE subquery (the shape cbrd_28126 Case 1 had)
 */

--
-- test data
--

drop view if exists v_27351_rev;
drop view if exists v_27351_dist;
drop view if exists v_27351_union;
drop view if exists v_27351_rownum;
drop view if exists v_27351_uall;
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
create view v_27351_union (k) as select l_suppkey from t_27351_li union select s_suppkey from t_27351_su;
create view v_27351_rownum (k, m) as select l_suppkey, max(l_price) from t_27351_li where rownum <= 1000 group by l_suppkey;
create view v_27351_uall (k) as select l_suppkey from t_27351_li union all select s_suppkey from t_27351_su;

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

evaluate 'S3: FROM reference + reference in a derived table';
select /*+ recompile parallel(0) */ count(*)
from v_27351_rev r, (select distinct supplier_no from v_27351_rev) d
where d.supplier_no = r.supplier_no;
show trace;

evaluate 'S4: one reference in each UNION ALL operand';
select /*+ recompile parallel(0) */ max(total_revenue) from v_27351_rev
union all
select min(total_revenue) from v_27351_rev
order by 1;
show trace;

evaluate 'S5: references using different columns';
select /*+ recompile parallel(0) */ a.total_revenue, b.supplier_no
from v_27351_rev a, v_27351_rev b
where a.supplier_no = b.supplier_no and b.supplier_no <= (select count(*) / 4 from v_27351_rev)
order by 2;
show trace;

evaluate 'S6: references in IN and HAVING subqueries';
select /*+ recompile parallel(0) */ count(*) from t_27351_su
where s_suppkey in (select supplier_no from v_27351_rev where total_revenue > (select avg(total_revenue) from v_27351_rev));
show trace;

select /*+ recompile parallel(0) */ mod(s_suppkey, 3), count(*) from t_27351_su
group by mod(s_suppkey, 3)
having count(*) < (select count(*) from v_27351_rev) and max(s_suppkey) <= (select max(supplier_no) from v_27351_rev)
order by 1;
show trace;

evaluate 'S7: references in nested subqueries';
select /*+ recompile parallel(0) */ count(*) from t_27351_su
where s_suppkey in (select supplier_no from v_27351_rev
                    where total_revenue >= (select avg(total_revenue) from v_27351_rev
                                            where supplier_no <= (select count(*) / 2 from v_27351_rev)));
show trace;

evaluate 'S8: no reference in the FROM clause of the statement';
select /*+ recompile parallel(0) */ (select count(*) from v_27351_rev) - (select count(distinct supplier_no) from v_27351_rev)
from db_root;
show trace;

evaluate 'S9: DISTINCT view, every column is kept';
select /*+ recompile parallel(0) */ count(*)
from v_27351_dist a, v_27351_dist b where a.k = b.k;
show trace;

evaluate 'S10: view defined as a set operation';
select /*+ recompile parallel(0) */ count(*) from v_27351_union a, v_27351_union b where a.k = b.k;
show trace;

evaluate 'S11: a predicate pushed into one of three references, the other two share';
select /*+ recompile parallel(0) */ count(*), sum(c.total_revenue)
from v_27351_rev a, v_27351_rev b, v_27351_rev c
where a.supplier_no = b.supplier_no and c.supplier_no = 5 and a.total_revenue >= c.total_revenue;
show trace;

evaluate 'S12: references reading no column of the view';
select /*+ recompile parallel(0) */ (select count(*) from v_27351_rev) + (select count(*) from v_27351_rev) from db_root;
show trace;

evaluate 'S13: ROWNUM view, whose result is fixed within a statement';
select /*+ recompile parallel(0) */ count(*) from v_27351_rownum a, v_27351_rownum b where a.k = b.k;
show trace;

evaluate 'S14: analytic function in the statement';
select /*+ recompile parallel(0) */ a.supplier_no, rank () over (order by a.total_revenue) r
from v_27351_rev a, v_27351_rev b where a.supplier_no = b.supplier_no
order by 1 limit 3;
show trace;

evaluate 'S15: two views each read twice, two share groups';
select /*+ recompile parallel(0) */ count(*), sum(a.total_revenue), count(d.k)
from v_27351_rev a, v_27351_rev b, v_27351_dist c, v_27351_dist d
where a.supplier_no = b.supplier_no and b.supplier_no = c.k and c.k = d.k;
show trace;

evaluate 'S16: UNION ALL view read by the FROM clause and a WHERE subquery, the shape cbrd_28126 Case 1 had';
select /*+ recompile */ count(*), max(a.k) from v_27351_uall a where a.k = (select max(b.k) from v_27351_uall b);
show trace;

set trace off;

--
-- clean up test data
--

drop view v_27351_rev;
drop view v_27351_dist;
drop view v_27351_union;
drop view v_27351_rownum;
drop view v_27351_uall;
drop table t_27351_li;
drop table t_27351_su;

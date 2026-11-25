/**
 * This test case verifies CBRD-27351: a view referenced more than once in a query is executed once
 * Scenario file: references that must not share the result of the view
 * Description: The result of a view is not shared when a reference reads other rows than the others (merged into
 *              its query, a pushed predicate, a correlated subquery), when evaluating the view once would change
 *              what each reference reads or the database state (random value, serial, stored function, BENCHMARK),
 *              when the view is not read as one result (ALL over a view hierarchy, VALUES, a view inside the body of
 *              another view, an inline view), and in statements other than SELECT. Each reference executes the view
 *              as before the fix, and the result is unchanged.
 * Coverage: control, merged view, pushed predicates, correlated subquery, DRANDOM, serial, stored function, BENCHMARK,
 *           ALL over a view hierarchy, VALUES view, nested view, inline views of the same text, INSERT / UPDATE,
 *           the columns of the references whose group breaks up (each selects the columns it reads, as before the fix)
 */

--
-- test data
--

drop view if exists v_27351_rev;
drop view if exists v_27351_child;
drop view if exists v_27351_parent;
drop view if exists v_27351_plain;
drop view if exists v_27351_drandom;
drop view if exists v_27351_next;
drop view if exists v_27351_func;
drop view if exists v_27351_bench;
drop view if exists v_27351_val;
drop view if exists v_27351_nest;
drop view if exists v_27351_wide;
drop serial if exists s_27351;
drop table if exists t_27351_ins;
drop table if exists t_27351_li;
drop table if exists t_27351_su;

create table t_27351_su (s_suppkey int primary key, s_name varchar(25));
insert into t_27351_su select level, 'Supplier#' || level from db_root connect by level <= 20;

create table t_27351_li (l_suppkey int, l_shipdate date, l_price int, l_disc int);
insert into t_27351_li
  select mod(level, 20) + 1, date'2020-01-01' + mod(level, 120), mod(level * 7, 97) * 10, mod(level, 10)
  from db_root connect by level <= 2000;

create table t_27351_ins (a int, b bigint);

update statistics on t_27351_li, t_27351_su with fullscan;

create serial s_27351;

create or replace function f_27351 (x int) return int as begin return x; end;

create view v_27351_rev (supplier_no, total_revenue) as
  select l_suppkey, sum(l_price * (100 - l_disc)) from t_27351_li
  where l_shipdate >= date'2020-01-01' and l_shipdate < date'2020-04-01' group by l_suppkey;

create view v_27351_parent (k int) as select s_suppkey from t_27351_su where s_suppkey <= 2;
create view v_27351_child under v_27351_parent as select s_suppkey from t_27351_su where s_suppkey = 2;

create view v_27351_plain (k, p) as select l_suppkey, l_price from t_27351_li where l_disc <= 2;
create view v_27351_drandom (k, r) as select l_suppkey, sum(l_price) + drandom () from t_27351_li group by l_suppkey;
create view v_27351_next (k, n) as select l_suppkey, s_27351.next_value from t_27351_li group by l_suppkey;
create view v_27351_func (k, f) as select l_suppkey, f_27351 (l_suppkey) from t_27351_li group by l_suppkey;
create view v_27351_bench (k, m) as select l_suppkey, benchmark (1, md5 ('x')) from t_27351_li group by l_suppkey;
create view v_27351_val (a, b) as values (1, 2), (3, 4);
create view v_27351_nest (k, t) as select supplier_no, total_revenue from v_27351_rev;
create view v_27351_wide (k, s, cd) as select l_suppkey, sum(l_price), count(distinct l_disc) from t_27351_li group by l_suppkey;

set trace on;

evaluate 'N0: control, the view is shared when nothing prevents it';
select /*+ recompile parallel(0) */ count(*) from v_27351_rev a, v_27351_rev b where a.supplier_no = b.supplier_no;
show trace;

evaluate 'N1: view merged into the query';
select /*+ recompile parallel(0) */ count(*) from v_27351_plain a, v_27351_plain b where a.k = b.k and a.p = b.p;
show trace;

evaluate 'N2: a predicate is pushed into every reference';
select /*+ recompile parallel(0) */ count(*) from v_27351_rev a, v_27351_rev b
where a.supplier_no = 3 and b.supplier_no = 4;
show trace;

evaluate 'N3: a reference in a correlated subquery is not counted';
select /*+ recompile parallel(0) */ count(*)
from t_27351_su, v_27351_rev m
where m.supplier_no = t_27351_su.s_suppkey
  and exists (select 1 from v_27351_rev r where r.supplier_no = t_27351_su.s_suppkey and r.total_revenue >= m.total_revenue);
show trace;

evaluate 'N4: views whose values differ at each execution, that change the database state or whose run is their result';
select /*+ recompile parallel(0) */ count(*) from v_27351_drandom a, v_27351_drandom b where a.k = b.k and a.r = b.r;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_next a, v_27351_next b where a.k = b.k and a.n = b.n;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.f), count(b.f) from v_27351_func a, v_27351_func b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.m), count(b.m) from v_27351_bench a, v_27351_bench b where a.k = b.k;
show trace;

evaluate 'N5: ALL over a view hierarchy';
select /*+ recompile parallel(0) */ count(*) from all v_27351_parent a, all v_27351_parent b where a.k = b.k;
show trace;

evaluate 'N6: VALUES view';
select /*+ recompile parallel(0) */ count(*) from v_27351_val a, v_27351_val b where a.a = b.a;
show trace;

evaluate 'N7: a view referenced inside the body of another view is not counted';
select /*+ recompile parallel(0) */ (select max(t) from v_27351_nest), (select max(total_revenue) from v_27351_rev) from db_root;
show trace;

evaluate 'N8: inline views of the same text';
select /*+ recompile parallel(0) */ count(*)
from (select l_suppkey k, sum(l_price) s from t_27351_li group by l_suppkey) a,
     (select l_suppkey k, sum(l_price) s from t_27351_li group by l_suppkey) b
where a.k = b.k;
show trace;

evaluate 'N10: a predicate pushed into one of two references breaks up the group, the other selects only what it reads';
select /*+ recompile parallel(0) */ a.k, a.cd from v_27351_wide a where a.k = 3 and a.s >= (select min(b.s) from v_27351_wide b);
show trace;

evaluate 'N11: the reference with the pushed predicate keeps the column read only by that predicate';
select /*+ recompile parallel(0) */ a.cd from v_27351_wide a where a.k = 3 and a.s >= (select min(b.s) from v_27351_wide b);
show trace;

evaluate 'N9: statements other than SELECT keep executing each reference';
insert into t_27351_ins
  select a.supplier_no, b.total_revenue from v_27351_rev a, v_27351_rev b where a.supplier_no = b.supplier_no;
show trace;
select count(*), sum(b) from t_27351_ins;

update t_27351_ins set b = 0
where a in (select a.supplier_no from v_27351_rev a, v_27351_rev b
            where a.supplier_no = b.supplier_no and a.total_revenue >= (select avg(total_revenue) from v_27351_rev));
show trace;

set trace off;

select count(*) from t_27351_ins where b = 0;

--
-- clean up test data
--

drop view v_27351_nest;
drop view v_27351_wide;
drop view v_27351_rev;
drop view v_27351_child;
drop view v_27351_parent;
drop view v_27351_plain;
drop view v_27351_drandom;
drop view v_27351_next;
drop view v_27351_func;
drop view v_27351_bench;
drop view v_27351_val;
drop function f_27351;
drop serial s_27351;
drop table t_27351_ins;
drop table t_27351_li;
drop table t_27351_su;

/**
 * This test case verifies CBRD-27351: a view referenced more than once in a query is executed once
 * Scenario file: references that must not share the result of the view
 * Description: The result of a view is not shared when a reference could produce different rows or when the view
 *              would be executed where it was not before. Each reference executes the view as before the fix, and
 *              the result is unchanged.
 * Coverage: merged view, unused columns of references that do not share (serial, nested view), pushed predicates,
 *           no reference in the FROM clause of the statement, a reference in a correlated subquery, view defined as
 *           a set operation, ALL over a view hierarchy, references in the WITH clause, statements other than SELECT,
 *           and views whose result
 *           can differ at each execution or that have a side effect (LIMIT, CONNECT BY, analytic function,
 *           ROWNUM / INST_NUM / ORDERBY_NUM / GROUPBY_NUM, RAND / DRAND / RANDOM / DRANDOM, SYS_GUID, UUID,
 *           serial, SLEEP, BENCHMARK, LAST_INSERT_ID, EXEC_STATS, TRACE_STATS, LOB conversion, stored function)
 */

--
-- test data
--

drop view if exists v_27351_rev;
drop view if exists v_27351_child;
drop view if exists v_27351_parent;
drop view if exists v_27351_plain;
drop view if exists v_27351_union;
drop view if exists v_27351_limit;
drop view if exists v_27351_setlimit;
drop view if exists v_27351_connect;
drop view if exists v_27351_analytic;
drop view if exists v_27351_rownum;
drop view if exists v_27351_instnum;
drop view if exists v_27351_obnum;
drop view if exists v_27351_gbnum;
drop view if exists v_27351_rand;
drop view if exists v_27351_drand;
drop view if exists v_27351_random;
drop view if exists v_27351_drandom;
drop view if exists v_27351_guid;
drop view if exists v_27351_uuid;
drop view if exists v_27351_next;
drop view if exists v_27351_curr;
drop view if exists v_27351_sleep;
drop view if exists v_27351_bench;
drop view if exists v_27351_lastid;
drop view if exists v_27351_execstats;
drop view if exists v_27351_tracestats;
drop view if exists v_27351_cblob;
drop view if exists v_27351_cclob;
drop view if exists v_27351_bblob;
drop view if exists v_27351_func;
drop serial if exists s_27351;
drop serial if exists s_27351_c;
drop view if exists v_27351_sx;
drop view if exists v_27351_out;
drop view if exists v_27351_in;
drop view if exists v_27351_c;
drop view if exists v_27351_c_out;
drop view if exists v_27351_c_in;
drop view if exists v_27351_multi;
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
create serial s_27351_c;

create or replace function f_27351 (x int) return int as begin return x; end;

create view v_27351_rev (supplier_no, total_revenue) as
  select l_suppkey, sum(l_price * (100 - l_disc)) from t_27351_li
  where l_shipdate >= date'2020-01-01' and l_shipdate < date'2020-04-01' group by l_suppkey;

create view v_27351_parent (k int) as select s_suppkey from t_27351_su where s_suppkey <= 2;
create view v_27351_child under v_27351_parent as select s_suppkey from t_27351_su where s_suppkey = 2;

create view v_27351_sx (k, n) as select l_suppkey, s_27351_c.next_value from t_27351_li group by l_suppkey;
create view v_27351_in (k, n) as select l_suppkey, s_27351_c.next_value from t_27351_li group by l_suppkey;
create view v_27351_out (k, n, c) as select k, max(n), count(*) from v_27351_in group by k;

create view v_27351_c (k, sx, sy) as select l_suppkey, sum(l_price), sum(l_disc) from t_27351_li group by l_suppkey;
create view v_27351_c_in (k, sx, sy) as select l_suppkey, sum(l_price), sum(l_disc) from t_27351_li group by l_suppkey;
create view v_27351_c_out (k, mx, my) as select k, max(sx), max(sy) from v_27351_c_in group by k;
create view v_27351_multi (k) as select s_suppkey from t_27351_su where s_suppkey < 3;
alter view v_27351_multi add query select s_suppkey from t_27351_su where s_suppkey > 17;

create view v_27351_plain (k, p) as select l_suppkey, l_price from t_27351_li where l_disc <= 2;
create view v_27351_union (k) as select l_suppkey from t_27351_li union select s_suppkey from t_27351_su;
create view v_27351_limit (k, m) as
  select l_suppkey, max(l_price) from t_27351_li
  where l_suppkey in (select s_suppkey from t_27351_su order by s_suppkey limit 5) group by l_suppkey;
create view v_27351_setlimit (k, m) as
  select k, count(*) from (select s_suppkey k from t_27351_su union all select l_suppkey from t_27351_li limit 25) x
  group by k;
create view v_27351_connect (k, m) as
  select s_suppkey, count(*) from t_27351_su start with s_suppkey = 1 connect by prior s_suppkey + 1 = s_suppkey
  group by s_suppkey;
create view v_27351_analytic (k, r) as
  select l_suppkey, rank () over (order by l_suppkey) from t_27351_li group by l_suppkey;
create view v_27351_rownum (k, m) as select l_suppkey, max(l_price) from t_27351_li where rownum <= 1000 group by l_suppkey;
create view v_27351_instnum (k, m) as
  select l_suppkey, max(l_price) from t_27351_li
  where l_suppkey in (select s_suppkey from t_27351_su where inst_num () <= 5) group by l_suppkey;
create view v_27351_obnum (k, m) as
  select l_suppkey, max(l_price) from t_27351_li
  where l_suppkey in (select s_suppkey from t_27351_su order by s_suppkey for orderby_num () <= 5) group by l_suppkey;
create view v_27351_gbnum (k, g) as select l_suppkey, groupby_num () from t_27351_li group by l_suppkey;
create view v_27351_rand (k, r) as select l_suppkey, sum(l_price) + rand () from t_27351_li group by l_suppkey;
create view v_27351_drand (k, r) as select l_suppkey, sum(l_price) + drand () from t_27351_li group by l_suppkey;
create view v_27351_random (k, r) as select l_suppkey, sum(l_price) + random () from t_27351_li group by l_suppkey;
create view v_27351_drandom (k, r) as select l_suppkey, sum(l_price) + drandom () from t_27351_li group by l_suppkey;
create view v_27351_guid (k, g) as select l_suppkey, sys_guid () from t_27351_li group by l_suppkey;
create view v_27351_uuid (k, g) as select l_suppkey, uuid () from t_27351_li group by l_suppkey;
create view v_27351_next (k, n) as select l_suppkey, s_27351.next_value from t_27351_li group by l_suppkey;
create view v_27351_curr (k, n) as select l_suppkey, s_27351.current_value from t_27351_li group by l_suppkey;
create view v_27351_sleep (k, z) as select l_suppkey, sleep (0) from t_27351_li group by l_suppkey;
create view v_27351_bench (k, m) as select l_suppkey, benchmark (1, md5 ('x')) from t_27351_li group by l_suppkey;
create view v_27351_lastid (k, l) as select l_suppkey, last_insert_id () from t_27351_li group by l_suppkey;
create view v_27351_execstats (k, e) as
  select l_suppkey, exec_stats ('Num_data_page_fetches') from t_27351_li group by l_suppkey;
create view v_27351_tracestats (k, t) as select l_suppkey, trace_stats () from t_27351_li group by l_suppkey;
create view v_27351_cblob (k, b) as select l_suppkey, char_to_blob (max(l_suppkey) || '') from t_27351_li group by l_suppkey;
create view v_27351_cclob (k, c) as select l_suppkey, char_to_clob (max(l_suppkey) || '') from t_27351_li group by l_suppkey;
create view v_27351_bblob (k, b) as select l_suppkey, bit_to_blob (X'01') from t_27351_li group by l_suppkey;
create view v_27351_func (k, f) as select l_suppkey, f_27351 (l_suppkey) from t_27351_li group by l_suppkey;

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

evaluate 'N3: a predicate is pushed into the FROM reference, the other reference stays alone';
select /*+ recompile parallel(0) */ count(*) from v_27351_rev a
where a.supplier_no = 3 and a.total_revenue <= (select max(total_revenue) from v_27351_rev);
show trace;

select /*+ recompile parallel(0) */ count(*), sum(c.total_revenue)
from v_27351_rev a, v_27351_rev b, v_27351_rev c
where a.supplier_no = b.supplier_no and c.supplier_no = 5 and a.total_revenue >= c.total_revenue;
show trace;

evaluate 'N4: no reference in the FROM clause of the statement';
select /*+ recompile parallel(0) */ (select count(*) from v_27351_rev) - (select count(distinct supplier_no) from v_27351_rev)
from db_root;
show trace;

select /*+ recompile parallel(0) */ count(*)
from (select distinct a.supplier_no from v_27351_rev a, v_27351_rev b where a.supplier_no = b.supplier_no) d;
show trace;

evaluate 'N5: view defined as a set operation';
select /*+ recompile parallel(0) */ count(*) from v_27351_union a, v_27351_union b where a.k = b.k;
show trace;

evaluate 'N5b: view with two query specifications';
select /*+ recompile parallel(0) */ count(*) from v_27351_multi a, v_27351_multi b where a.k = b.k;
show trace;

evaluate 'N6: ALL over a view hierarchy';
select /*+ recompile parallel(0) */ count(*) from all v_27351_parent a, all v_27351_parent b where a.k = b.k;
show trace;

evaluate 'N7: references in the WITH clause are not counted';
with c as (select supplier_no from v_27351_rev)
select /*+ recompile parallel(0) */ count(*) from c x, c y, v_27351_rev z
where x.supplier_no = y.supplier_no and y.supplier_no = z.supplier_no;
show trace;

evaluate 'N8: views whose result can differ at each execution or that have a side effect';
select /*+ recompile parallel(0) */ count(*) from v_27351_limit a, v_27351_limit b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_setlimit a, v_27351_setlimit b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_connect a, v_27351_connect b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.r), count(b.r) from v_27351_analytic a, v_27351_analytic b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_rownum a, v_27351_rownum b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_instnum a, v_27351_instnum b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_obnum a, v_27351_obnum b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.g), count(b.g) from v_27351_gbnum a, v_27351_gbnum b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_rand a, v_27351_rand b where a.k = b.k and a.r = b.r;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_drand a, v_27351_drand b where a.k = b.k and a.r = b.r;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_random a, v_27351_random b where a.k = b.k and a.r = b.r;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_drandom a, v_27351_drandom b where a.k = b.k and a.r = b.r;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_guid a, v_27351_guid b where a.k = b.k and a.g = b.g;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_uuid a, v_27351_uuid b where a.k = b.k and a.g = b.g;
show trace;
select /*+ recompile parallel(0) */ count(*) from v_27351_next a, v_27351_next b where a.k = b.k and a.n = b.n;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.n), count(b.n) from v_27351_curr a, v_27351_curr b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.z), count(b.z) from v_27351_sleep a, v_27351_sleep b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.m), count(b.m) from v_27351_bench a, v_27351_bench b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.l), count(b.l) from v_27351_lastid a, v_27351_lastid b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.e), count(b.e) from v_27351_execstats a, v_27351_execstats b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.t), count(b.t) from v_27351_tracestats a, v_27351_tracestats b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.b), count(b.b) from v_27351_cblob a, v_27351_cblob b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.c), count(b.c) from v_27351_cclob a, v_27351_cclob b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.b), count(b.b) from v_27351_bblob a, v_27351_bblob b where a.k = b.k;
show trace;
select /*+ recompile parallel(0) */ count(*), count(a.f), count(b.f) from v_27351_func a, v_27351_func b where a.k = b.k;
show trace;

evaluate 'N10: a reference in a correlated subquery builds the view by itself';
select /*+ recompile parallel(0) */ count(*)
from t_27351_su, v_27351_rev m
where m.supplier_no = t_27351_su.s_suppkey
  and exists (select 1 from v_27351_rev r where r.supplier_no = t_27351_su.s_suppkey and r.total_revenue >= m.total_revenue);
show trace;

evaluate 'N12: references that do not share keep the column used only by the outer join condition';
select /*+ recompile parallel(0) */
  (select count(*) from v_27351_c a left outer join v_27351_c b on a.k = b.k and b.sy > 50),
  (select count(b.k) from v_27351_c a left outer join v_27351_c b on a.k = b.k and b.sy > 50)
from db_root;
show trace;

evaluate 'N13: a nested view inside references that do not share keeps only the columns used';
select /*+ recompile parallel(0) */ (select count(*) from v_27351_c_out) + (select count(*) from v_27351_c_out) from db_root;
show trace;

evaluate 'N14: references that do not share and use every column';
select /*+ recompile parallel(0) */ (select sum(k + sx + sy) from v_27351_c) - (select sum(k + sx + sy) from v_27351_c) from db_root;
show trace;

set trace off;

evaluate 'N11: a column the query does not use is not evaluated (serial stays as before the fix)';
select /*+ recompile */ count(*) from v_27351_sx a, v_27351_sx b where a.k = b.k;
select s_27351_c.current_value from db_root;
select /*+ recompile */ count(*) from v_27351_out a, v_27351_out b where a.k = b.k;
select s_27351_c.current_value from db_root;
select /*+ recompile */ count(*) from v_27351_rev a, v_27351_rev b where a.supplier_no = 3 and b.supplier_no = 4;
select s_27351_c.current_value from db_root;

evaluate 'N9: statements other than SELECT keep executing each reference';
insert into t_27351_ins
  select a.supplier_no, b.total_revenue from v_27351_rev a, v_27351_rev b where a.supplier_no = b.supplier_no;
select count(*), sum(b) from t_27351_ins;

update t_27351_ins set b = 0
where a in (select a.supplier_no from v_27351_rev a, v_27351_rev b
            where a.supplier_no = b.supplier_no and a.total_revenue >= (select avg(total_revenue) from v_27351_rev));
select count(*) from t_27351_ins where b = 0;

delete from t_27351_ins
where a in (select a.supplier_no from v_27351_rev a, v_27351_rev b
            where a.supplier_no = b.supplier_no and a.total_revenue < (select avg(total_revenue) from v_27351_rev));
select count(*) from t_27351_ins;

update t_27351_ins s, v_27351_rev a, v_27351_rev b set s.b = a.total_revenue + b.total_revenue
where s.a = a.supplier_no and a.supplier_no = b.supplier_no;
select count(*), sum(b) from t_27351_ins;

delete s from t_27351_ins s, v_27351_rev a, v_27351_rev b
where s.a = a.supplier_no and a.supplier_no = b.supplier_no and a.supplier_no > 15;
select count(*) from t_27351_ins;

merge into t_27351_ins t
using (select a.supplier_no k, b.total_revenue r from v_27351_rev a, v_27351_rev b where a.supplier_no = b.supplier_no) s
on (t.a = s.k)
when matched then update set t.b = s.r
when not matched then insert values (s.k, s.r);
select count(*), sum(b) from t_27351_ins;

--
-- clean up test data
--

drop view v_27351_rev;
drop view v_27351_child;
drop view v_27351_parent;
drop view v_27351_plain;
drop view v_27351_union;
drop view v_27351_limit;
drop view v_27351_setlimit;
drop view v_27351_connect;
drop view v_27351_analytic;
drop view v_27351_rownum;
drop view v_27351_instnum;
drop view v_27351_obnum;
drop view v_27351_gbnum;
drop view v_27351_rand;
drop view v_27351_drand;
drop view v_27351_random;
drop view v_27351_drandom;
drop view v_27351_guid;
drop view v_27351_uuid;
drop view v_27351_next;
drop view v_27351_curr;
drop view v_27351_sleep;
drop view v_27351_bench;
drop view v_27351_lastid;
drop view v_27351_execstats;
drop view v_27351_tracestats;
drop view v_27351_cblob;
drop view v_27351_cclob;
drop view v_27351_bblob;
drop view v_27351_func;
drop function f_27351;
drop serial s_27351;
drop view v_27351_sx;
drop view v_27351_out;
drop view v_27351_in;
drop view v_27351_c;
drop view v_27351_c_out;
drop view v_27351_c_in;
drop view v_27351_multi;
drop serial s_27351_c;
drop table t_27351_ins;
drop table t_27351_li;
drop table t_27351_su;

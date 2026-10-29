/**
 *  CBRD-25984: covered index scan and key filter on function indexes.
 *
 *  Bug: a function index (e.g. (i1, sqrt(d1))) stores only the function result in the key, so the
 *       optimizer refused covering scans and key filters whenever the indexed expression appeared.
 *  Fix: the projected / key-filtered expression is read from the precomputed result slot of the key
 *       through a dedicated result attribute. Covering stays disabled when the raw argument is needed
 *       (raw projection, join or subquery referencing the expression, GROUP BY / aggregates,
 *       UPDATE / DELETE / FOR UPDATE targets, which the server re-evaluates from the heap).
 *       When the argument itself is a key column (e.g. (d1, sqrt(d1))) the result is still read from
 *       the key. CONNECT BY and click counter queries never use the result slot, and a scan whose
 *       rows reach the join through a list file (merge / hash join input) is not covered when the
 *       argument is missing from the key.
 *
 *  Coverage: each check compares the plain query against the same query with the NO_COVERING_IDX
 *            hint and emits PASS / FAIL; plans are dumped where the shape itself is the contract.
 *    1. covering + function key filter (two-column, single-column and multi-argument indexes)
 *    2. raw argument also projected / filtered / ordered -> no covering, correct values
 *    3. expression inside a scalar subquery, EXISTS subquery, NL / hash / outer join condition
 *    4. key filter only (collation term left as data filter) -> no covering, no error
 *    5. UPDATE assignment, DELETE and SELECT ... FOR UPDATE using the expression
 *    6. argument also a key column (d1, sqrt(d1)): projection, key filter, raw argument, ORDER BY
 *    7. CONNECT BY over (i1, sqrt(d1)) and (d1, sqrt(d1)) forced by USING INDEX: values at every level
 *    8. merge / hash join hints over a covered function index scan (list file input)
 *    9. click counter (INCR) joined with a function index scan: each twin increments its own counter
 *       row and checks the expression against 4 * i1 in the same row
 *  Sizing: 20 rows are enough; every scan is a short key range, no parallelism involved.
 */

drop table if exists fi_t, fi_u, fi_m, fi_c, fi_d, fi_w, fi_k;

create table fi_t (i1 int, d1 double, k int);
insert into fi_t select rownum, rownum * rownum * 16, rownum % 3 from db_class limit 20;
create index idx_fi_t on fi_t (i1, sqrt(d1));

create table fi_u (x int, y double);
insert into fi_u values (1, 4), (2, 8), (3, 12), (4, 2);

create table fi_m (a int, b int);
insert into fi_m select rownum, rownum % 7 + 1 from db_class limit 20;
create index idx_fi_m on fi_m (a, mod(a, b));

create table fi_c (s varchar(20) collate utf8_bin, d1 double);
insert into fi_c select 'v' || rownum, rownum * rownum * 16 from db_class limit 20;
create index idx_fi_c on fi_c (s, sqrt(d1));

create table fi_d (id int, d1 double);
insert into fi_d select rownum, rownum * rownum * 16 from db_class limit 20;
create index idx_fi_d on fi_d (d1, sqrt(d1));

create table fi_w (x int, y double);
insert into fi_w values (1, 16), (2, 64), (3, 144), (4, 256), (5, 400);

create table fi_k (x int primary key, cnt int);
insert into fi_k values (1, 0), (2, 0), (3, 0), (4, 0);

update statistics on fi_t, fi_u, fi_m, fi_c, fi_d, fi_w, fi_k with fullscan;

evaluate '[1-1] covering + key filter on (i1, sqrt(d1))';
--@queryplan
select i1, sqrt(d1) r from fi_t where i1 between 1 and 10 and sqrt(d1) > 20 order by 1;
select case when count(*) = 5 then 'PASS' else 'FAIL' end as result
from (select i1, sqrt(d1) r from fi_t where i1 between 1 and 10 and sqrt(d1) > 20) p
     join (select /*+ NO_COVERING_IDX */ i1, sqrt(d1) r from fi_t where i1 between 1 and 10 and sqrt(d1) > 20) s
     on p.i1 = s.i1 and p.r <=> s.r;

evaluate '[1-2] nested expression and CASE over the indexed expression';
select case when count(*) = 3 then 'PASS' else 'FAIL' end as result
from (select i1, sqrt(d1) + 1 r, case when sqrt(d1) > 8 then 'big' else 'small' end c from fi_t where i1 between 1 and 3) p
     join (select /*+ NO_COVERING_IDX */ i1, sqrt(d1) + 1 r, case when sqrt(d1) > 8 then 'big' else 'small' end c from fi_t where i1 between 1 and 3) s
     on p.i1 = s.i1 and p.r <=> s.r and p.c <=> s.c;

evaluate '[1-3] analytic function over the indexed expression';
select case when count(*) = 3 then 'PASS' else 'FAIL' end as result
from (select i1, sqrt(d1) r, sum(sqrt(d1)) over () sm from fi_t where i1 between 1 and 3) p
     join (select /*+ NO_COVERING_IDX */ i1, sqrt(d1) r, sum(sqrt(d1)) over () sm from fi_t where i1 between 1 and 3) s
     on p.i1 = s.i1 and p.r <=> s.r and p.sm <=> s.sm;

evaluate '[1-4] single-column function index: key range + key filter on the expression';
create index idx_fi_t_s on fi_t (sqrt(d1));
--@queryplan
select sqrt(d1) r from fi_t where sqrt(d1) between 4 and 12 and sqrt(d1) <> 8 order by 1;
select case when count(*) = 2 then 'PASS' else 'FAIL' end as result
from (select sqrt(d1) r from fi_t where sqrt(d1) between 4 and 12 and sqrt(d1) <> 8) p
     join (select /*+ NO_COVERING_IDX */ sqrt(d1) r from fi_t where sqrt(d1) between 4 and 12 and sqrt(d1) <> 8) s
     on p.r <=> s.r;
drop index idx_fi_t_s on fi_t;

evaluate '[1-5] multi-argument expression mod(a, b) where a is also a key column';
--@queryplan
select a, mod(a, b) m from fi_m where a between 5 and 9 and mod(a, b) > 1 order by 1;
select case when count(*) = 5 then 'PASS' else 'FAIL' end as result
from (select a, mod(a, b) m from fi_m where a between 5 and 9) p
     join (select /*+ NO_COVERING_IDX */ a, mod(a, b) m from fi_m where a between 5 and 9) s
     on p.a = s.a and p.m <=> s.m;

evaluate '[2-1] raw argument projected with the expression -> no covering';
--@queryplan
select i1, d1, sqrt(d1) r from fi_t where i1 between 1 and 3 order by 1;
select case when count(*) = 3 then 'PASS' else 'FAIL' end as result
from (select i1, d1, sqrt(d1) r from fi_t where i1 between 1 and 3) p
     join (select /*+ NO_COVERING_IDX */ i1, d1, sqrt(d1) r from fi_t where i1 between 1 and 3) s
     on p.i1 = s.i1 and p.d1 <=> s.d1 and p.r <=> s.r;

evaluate '[2-2] raw argument in a data filter / ORDER BY -> no covering';
select case when count(*) = 2 then 'PASS' else 'FAIL' end as result
from (select i1, sqrt(d1) r from fi_t where i1 between 1 and 3 and d1 > 20) p
     join (select /*+ NO_COVERING_IDX */ i1, sqrt(d1) r from fi_t where i1 between 1 and 3 and d1 > 20) s
     on p.i1 = s.i1 and p.r <=> s.r;
select i1, sqrt(d1) r from fi_t where i1 between 1 and 3 order by d1 desc;

evaluate '[3-1] expression inside a scalar subquery of the select list';
--@queryplan
select sqrt(d1) r, (select sqrt(fi_t.d1) from db_root) sub from fi_t where i1 between 1 and 3 order by 1;
select case when count(*) = 3 then 'PASS' else 'FAIL' end as result
from (select i1, sqrt(d1) r, (select sqrt(fi_t.d1) from db_root) sub from fi_t where i1 between 1 and 3) p
     join (select /*+ NO_COVERING_IDX */ i1, sqrt(d1) r, (select sqrt(fi_t.d1) from db_root) sub from fi_t where i1 between 1 and 3) s
     on p.i1 = s.i1 and p.r <=> s.r and p.sub <=> s.sub;

evaluate '[3-2] expression inside a correlated EXISTS subquery';
select case when count(*) = 3 then 'PASS' else 'FAIL' end as result
from (select i1, sqrt(d1) r from fi_t where i1 between 1 and 5 and exists (select 1 from db_root where sqrt(fi_t.d1) > 8)) p
     join (select /*+ NO_COVERING_IDX */ i1, sqrt(d1) r from fi_t where i1 between 1 and 5 and exists (select 1 from db_root where sqrt(fi_t.d1) > 8)) s
     on p.i1 = s.i1 and p.r <=> s.r;

evaluate '[3-3] expression in a nested-loop join condition';
--@queryplan
select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y order by 1;
select case when count(*) = 3 then 'PASS' else 'FAIL' end as result
from (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_nl NO_COVERING_IDX */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1 and p.r <=> s.r and p.x <=> s.x;

evaluate '[3-4] expression in a hash join condition';
select /*+ ordered use_nl */ case when count(*) = 3 then 'PASS' else 'FAIL' end as result
from (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_hash NO_COVERING_IDX */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1 and p.r <=> s.r and p.x <=> s.x;

evaluate '[3-5] expression in an outer join ON condition';
select case when count(*) = 3 then 'PASS' else 'FAIL' end as result
from (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t left join fi_u u on sqrt(t.d1) = u.y where t.i1 between 1 and 3) p
     join (select /*+ ordered use_nl NO_COVERING_IDX */ t.i1, sqrt(t.d1) r, u.x from fi_t t left join fi_u u on sqrt(t.d1) = u.y where t.i1 between 1 and 3) s
     on p.i1 = s.i1 and p.r <=> s.r and p.x <=> s.x;

evaluate '[4-1] key filter without covering: collation term stays a data filter';
--@queryplan
select s, sqrt(d1) r from fi_c where s > 'v1' and sqrt(d1) > 20 and s collate utf8_en_ci > 'V2' order by 1;
select case when count(*) = 5 then 'PASS' else 'FAIL' end as result
from (select s, sqrt(d1) r from fi_c where s > 'v1' and sqrt(d1) > 20 and s collate utf8_en_ci > 'V2') p
     join (select /*+ NO_COVERING_IDX */ s, sqrt(d1) r from fi_c where s > 'v1' and sqrt(d1) > 20 and s collate utf8_en_ci > 'V2') s
     on p.s = s.s and p.r <=> s.r;

evaluate '[5-1] UPDATE assignment from the indexed expression';
--@queryplan
update fi_t set k = sqrt(d1) where i1 between 6 and 8 and sqrt(d1) > 20;
select i1, k from fi_t where i1 between 6 and 8 order by 1;
update fi_t set k = i1 % 3 where i1 between 6 and 8;

evaluate '[5-2] DELETE with the indexed expression in the condition';
delete from fi_t where i1 between 6 and 10 and sqrt(d1) > 20;
select case when count(*) = 15 then 'PASS' else 'FAIL' end as result from fi_t;
insert into fi_t select rownum + 5, (rownum + 5) * (rownum + 5) * 16, (rownum + 5) % 3 from db_class limit 5;

evaluate '[5-3] SELECT ... FOR UPDATE with the indexed expression';
--@queryplan
select i1, sqrt(d1) r from fi_t where i1 between 1 and 10 and sqrt(d1) > 20 order by 1 for update;
commit;

evaluate '[6-1] (d1, sqrt(d1)): expression projected over a key range on the argument';
--@queryplan
select sqrt(d1) r from fi_d where d1 between 16 and 1600 order by 1;
select case when count(*) = 10 then 'PASS' else 'FAIL' end as result
from (select /*+ NO_MERGE */ sqrt(d1) r from fi_d where d1 between 16 and 1600) p
     join (select /*+ NO_MERGE NO_COVERING_IDX */ sqrt(d1) r from fi_d where d1 between 16 and 1600) s
     on p.r <=> s.r;

evaluate '[6-2] (d1, sqrt(d1)): key filter on the expression';
--@queryplan
select sqrt(d1) r from fi_d where d1 > 0 and sqrt(d1) > 20 and sqrt(d1) < 60 order by 1;
select case when count(*) = 9 then 'PASS' else 'FAIL' end as result
from (select /*+ NO_MERGE */ sqrt(d1) r from fi_d where d1 > 0 and sqrt(d1) > 20 and sqrt(d1) < 60) p
     join (select /*+ NO_MERGE NO_COVERING_IDX */ sqrt(d1) r from fi_d where d1 > 0 and sqrt(d1) > 20 and sqrt(d1) < 60) s
     on p.r <=> s.r;

evaluate '[6-3] (d1, sqrt(d1)): raw argument projected and filtered with the expression';
--@queryplan
select d1, sqrt(d1) r from fi_d where d1 between 16 and 1600 and mod(d1, 32) = 0 order by 1;
select case when count(*) = 5 then 'PASS' else 'FAIL' end as result
from (select /*+ NO_MERGE */ d1, sqrt(d1) r from fi_d where d1 between 16 and 1600 and mod(d1, 32) = 0) p
     join (select /*+ NO_MERGE NO_COVERING_IDX */ d1, sqrt(d1) r from fi_d where d1 between 16 and 1600 and mod(d1, 32) = 0) s
     on p.d1 <=> s.d1 and p.r <=> s.r;

evaluate '[6-4] (d1, sqrt(d1)): ORDER BY the argument / the expression, with LIMIT';
select sqrt(d1) r from fi_d where d1 between 16 and 1600 order by d1 desc;
select sqrt(d1) r from fi_d where d1 between 16 and 1600 order by sqrt(d1) desc limit 3;
select case when count(*) = 3 then 'PASS' else 'FAIL' end as result
from (select /*+ NO_MERGE */ sqrt(d1) r from fi_d where d1 between 16 and 1600 order by sqrt(d1) desc limit 3) p
     join (select /*+ NO_MERGE NO_COVERING_IDX */ sqrt(d1) r from fi_d where d1 between 16 and 1600 order by sqrt(d1) desc limit 3) s
     on p.r <=> s.r;

evaluate '[7-1] CONNECT BY over (i1, sqrt(d1)) forced by USING INDEX';
select i1, sqrt(d1) r, level lv from fi_t where i1 between 2 and 6 and sqrt(d1) < 100
start with i1 = 2 connect by prior sqrt(d1) + 4 = sqrt(d1) using index idx_fi_t(+) order by 1;
select case when count(*) = 5 then 'PASS' else 'FAIL' end as result
from (select i1, sqrt(d1) r, level lv from fi_t where i1 between 2 and 6 and sqrt(d1) < 100
      start with i1 = 2 connect by prior sqrt(d1) + 4 = sqrt(d1) using index idx_fi_t(+)) p
     join (select /*+ NO_COVERING_IDX */ i1, sqrt(d1) r, level lv from fi_t where i1 between 2 and 6 and sqrt(d1) < 100
           start with i1 = 2 connect by prior sqrt(d1) + 4 = sqrt(d1) using index idx_fi_t(+)) s
     on p.i1 = s.i1 and p.r <=> s.r and p.lv = s.lv;

evaluate '[7-2] CONNECT BY over (d1, sqrt(d1)): raw argument and expression at every level';
select d1, sqrt(d1) r, level lv from fi_d where d1 between 16 and 1600
start with d1 = 16 connect by prior sqrt(d1) + 4 = sqrt(d1) using index idx_fi_d(+) order by 1;
select case when count(*) = 10 then 'PASS' else 'FAIL' end as result
from (select d1, sqrt(d1) r, level lv from fi_d where d1 between 16 and 1600
      start with d1 = 16 connect by prior sqrt(d1) + 4 = sqrt(d1) using index idx_fi_d(+)) p
     join (select /*+ NO_COVERING_IDX */ d1, sqrt(d1) r, level lv from fi_d where d1 between 16 and 1600
           start with d1 = 16 connect by prior sqrt(d1) + 4 = sqrt(d1) using index idx_fi_d(+)) s
     on p.d1 = s.d1 and p.r <=> s.r and p.lv = s.lv;

evaluate '[7-3] CONNECT BY over (d1, sqrt(d1)): expression only, with a filter on it';
select case when count(*) = 7 then 'PASS' else 'FAIL' end as result
from (select sqrt(d1) r, level lv from fi_d where d1 between 16 and 1600 and sqrt(d1) < 30
      start with d1 = 16 connect by prior sqrt(d1) + 4 = sqrt(d1) using index idx_fi_d(+)) p
     join (select /*+ NO_COVERING_IDX */ sqrt(d1) r, level lv from fi_d where d1 between 16 and 1600 and sqrt(d1) < 30
           start with d1 = 16 connect by prior sqrt(d1) + 4 = sqrt(d1) using index idx_fi_d(+)) s
     on p.r <=> s.r and p.lv = s.lv;

evaluate '[8-1] merge join over the (i1, sqrt(d1)) scan, expression only projected';
--@queryplan
select /*+ USE_MERGE */ w.x, sqrt(t.d1) r from fi_t t, fi_w w where t.i1 = w.x and t.i1 between 1 and 5 and sqrt(t.d1) > 2 order by 1;
select /*+ ordered use_nl */ case when count(*) = 5 then 'PASS' else 'FAIL' end as result
from (select /*+ NO_MERGE USE_MERGE */ w.x, sqrt(t.d1) r from fi_t t, fi_w w where t.i1 = w.x and t.i1 between 1 and 5 and sqrt(t.d1) > 2) p
     join (select /*+ NO_MERGE USE_MERGE NO_COVERING_IDX */ w.x, sqrt(t.d1) r from fi_t t, fi_w w where t.i1 = w.x and t.i1 between 1 and 5 and sqrt(t.d1) > 2) s
     on p.x = s.x and p.r <=> s.r;

evaluate '[8-2] hash join over the (i1, sqrt(d1)) scan, both build orders';
--@queryplan
select /*+ USE_HASH */ w.x, sqrt(t.d1) r from fi_t t, fi_w w where t.i1 = w.x and t.i1 between 1 and 5 and sqrt(t.d1) > 2 order by 1;
select /*+ ordered use_nl */ case when count(*) = 5 then 'PASS' else 'FAIL' end as result
from (select /*+ NO_MERGE USE_HASH */ w.x, sqrt(t.d1) r from fi_t t, fi_w w where t.i1 = w.x and t.i1 between 1 and 5 and sqrt(t.d1) > 2) p
     join (select /*+ NO_MERGE USE_HASH NO_COVERING_IDX */ w.x, sqrt(t.d1) r from fi_t t, fi_w w where t.i1 = w.x and t.i1 between 1 and 5 and sqrt(t.d1) > 2) s
     on p.x = s.x and p.r <=> s.r;
select /*+ ordered use_nl */ case when count(*) = 5 then 'PASS' else 'FAIL' end as result
from (select /*+ NO_MERGE ORDERED USE_HASH */ w.x, sqrt(t.d1) r from fi_w w, fi_t t where t.i1 = w.x and t.i1 between 1 and 5 and sqrt(t.d1) > 2) p
     join (select /*+ NO_MERGE ORDERED USE_HASH NO_COVERING_IDX */ w.x, sqrt(t.d1) r from fi_w w, fi_t t where t.i1 = w.x and t.i1 between 1 and 5 and sqrt(t.d1) > 2) s
     on p.x = s.x and p.r <=> s.r;

evaluate '[8-3] merge / hash join over the (d1, sqrt(d1)) scan joined on the argument';
select /*+ ordered use_nl */ case when count(*) = 5 then 'PASS' else 'FAIL' end as result
from (select /*+ NO_MERGE USE_MERGE */ w.x, sqrt(d.d1) r from fi_d d, fi_w w where d.d1 = w.y and d.d1 between 16 and 2000) p
     join (select /*+ NO_MERGE USE_MERGE NO_COVERING_IDX */ w.x, sqrt(d.d1) r from fi_d d, fi_w w where d.d1 = w.y and d.d1 between 16 and 2000) s
     on p.x = s.x and p.r <=> s.r;
select /*+ ordered use_nl */ case when count(*) = 5 then 'PASS' else 'FAIL' end as result
from (select /*+ NO_MERGE USE_HASH */ w.x, sqrt(d.d1) r from fi_d d, fi_w w where d.d1 = w.y and d.d1 between 16 and 2000) p
     join (select /*+ NO_MERGE USE_HASH NO_COVERING_IDX */ w.x, sqrt(d.d1) r from fi_d d, fi_w w where d.d1 = w.y and d.d1 between 16 and 2000) s
     on p.x = s.x and p.r <=> s.r;

evaluate '[9-1] click counter on the other table of a join, function index scan first';
select /*+ ORDERED */ t.i1, sqrt(t.d1) r, incr(k.cnt) c, case when sqrt(t.d1) = 4 * t.i1 then 'PASS' else 'FAIL' end chk from fi_t t, fi_k k where k.x = 1 and t.i1 between 3 and 3 and sqrt(t.d1) > 1;
select /*+ ORDERED NO_COVERING_IDX */ t.i1, sqrt(t.d1) r, incr(k.cnt) c, case when sqrt(t.d1) = 4 * t.i1 then 'PASS' else 'FAIL' end chk from fi_t t, fi_k k where k.x = 2 and t.i1 between 3 and 3 and sqrt(t.d1) > 1;

evaluate '[9-2] click counter on the other table of a join, function index scan second';
select /*+ ORDERED */ incr(k.cnt) c, t.i1, sqrt(t.d1) r, case when sqrt(t.d1) = 4 * t.i1 then 'PASS' else 'FAIL' end chk from fi_k k, fi_t t where k.x = 3 and t.i1 between 3 and 3 and sqrt(t.d1) > 1;
select /*+ ORDERED NO_COVERING_IDX */ incr(k.cnt) c, t.i1, sqrt(t.d1) r, case when sqrt(t.d1) = 4 * t.i1 then 'PASS' else 'FAIL' end chk from fi_k k, fi_t t where k.x = 4 and t.i1 between 3 and 3 and sqrt(t.d1) > 1;
select case when count(*) = 4 and min(cnt) = 1 and max(cnt) = 1 then 'PASS' else 'FAIL' end as result from fi_k;

drop table if exists fi_t, fi_u, fi_m, fi_c, fi_d, fi_w, fi_k;

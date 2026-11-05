/**
 *  CBRD-25984: covered index scan and key filter on function indexes.
 *
 *  Bug: a function index (e.g. (i1, sqrt(d1))) stores only the function result in the key, so the
 *       optimizer refused covering scans and key filters whenever the indexed expression appeared.
 *  Fix: the projected / key-filtered expression is read from the precomputed result slot of the key
 *       through a dedicated result attribute, and a non-covered scan reads its key filter from that slot too.
 *       Covering stays disabled when the raw argument is needed
 *       (raw projection, join or subquery referencing the expression, GROUP BY / aggregates,
 *       UPDATE / DELETE / FOR UPDATE targets, which the server re-evaluates from the heap).
 *       When the argument itself is a key column (e.g. (d1, sqrt(d1))) the result is still read from
 *       the key. CONNECT BY and click counter queries never use the result slot, and a scan whose
 *       rows reach the join through a list file (merge / hash join input) is not covered when the
 *       argument is missing from the key. A function index that covers a query without the expression
 *       anywhere in it (e.g. max(d1) with the index (d1, sqrt(d1))) is covered without the result attribute.
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
 *   10. covering without the expression in the query: aggregate / analytic over key columns, the
 *       expression only in a key filter, only in a subquery over another table, inline view -
 *       results over fi_d are also checked against its heap-only copy fi_dh
 *   11. multi-range optimization (IN list + ORDER BY ... LIMIT / FOR ORDERBY_NUM ()) covered by
 *       (i1, j, sqrt(d1)): the expression read back from the kept top-N keys, also in the key filter
 *       and in descending order; each row checks the expression against 4 * (1000 - j) and the
 *       NO_COVERING_IDX twin (without the optimization for the key filter) prints the same rows
 *   12. covering decisions that must follow what is read from the key: a self join mixing both aliases
 *       in mod(a, b), a plain index (d) next to a function index on sqrt(d), FOR UPDATE / DELETE without
 *       the expression (key filter kept), to_datetime_tz and utf8_en_ci results whose equal keys differ,
 *       during / after join terms of an outer join, a loose index scan under hash / merge join, and
 *       single-column indexes over two arguments (mod(a, b), left(s, n)) read from the key; an expression
 *       whose value depends on the session time zone or date language (date_format over a TIMESTAMP,
 *       date_format(d, '%W')) is not read from the key, and the parameters are restored afterwards
 *   13. key filter on a non-covered function index scan (a column outside the key is read from the heap):
 *       the expression and a plain key column (c3 of (c1, abs(c2), c3)) as key filters, a merged derived
 *       table, a raw argument term next to the expression; session dependent, to_datetime_tz and
 *       utf8_en_ci expressions and UPDATE / DELETE / FOR UPDATE keep it a data filter; every query is
 *       compared with its USING INDEX NONE twin
 *  Sizing: 20 rows are enough; every scan is a short key range, no parallelism involved.
 */

drop table if exists fi_t, fi_u, fi_m, fi_c, fi_d, fi_dh, fi_w, fi_k, fi_r, fi_s, fi_p, fi_q, fi_z, fi_e, fi_g, fi_h, fi_v, fi_n, fi_l, fi_mo, fi_ls,
  fi_ts, fi_dl, fi_a, fi_b, fi_x, fi_y, fi_i;

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
create table fi_dh as select * from fi_d;

create table fi_w (x int, y double);
insert into fi_w values (1, 16), (2, 64), (3, 144), (4, 256), (5, 400);

create table fi_k (x int primary key, cnt int);
insert into fi_k values (1, 0), (2, 0), (3, 0), (4, 0);

create table fi_r (i1 int, j int, d1 double);
insert into fi_r select rownum % 5, 1000 - rownum, rownum * rownum * 16 from db_class limit 20;
create index idx_fi_r on fi_r (i1, j, sqrt(d1));

create table fi_s (k int, a int, b int);
insert into fi_s select rownum, rownum + 6, rownum % 4 + 2 from db_class limit 5;
create index idx_fi_s on fi_s (k, mod(a, b));

create table fi_p (d double);
insert into fi_p values (1), (4), (9);
create index idx_fi_pd on fi_p (d);
create index idx_fi_pf on fi_p (sqrt(d));

create table fi_q (i int, j int, d double);
insert into fi_q values (1, 1, 1), (2, 3, 4), (3, 2, 9), (4, 3, 16);
create index idx_fi_q on fi_q (i, j, sqrt(d));

create table fi_z (i int, s varchar(40));
insert into fi_z values (1, '2020-01-01 10:00:00 +09:00'), (1, '2020-01-01 01:00:00 +00:00');
create index idx_fi_z on fi_z (i, to_datetime_tz(s));

create table fi_e (n int, s varchar(10) collate utf8_bin);
insert into fi_e values (1, 'ABC'), (1, 'abc');
create index idx_fi_e on fi_e (n, s collate utf8_en_ci);

create table fi_g (x int, d double);
insert into fi_g values (1, 4), (2, 0.25);
create index idx_fi_g on fi_g (x, sqrt(d));
create table fi_h (k int);
insert into fi_h values (1), (2);

create table fi_v (x int);
insert into fi_v values (1), (2), (3);
create table fi_n (k int, d double);
insert into fi_n values (1, 4), (3, 9);
create index idx_fi_n on fi_n (k, d, sqrt(d));

create table fi_l (a int, d double, j int);
insert into fi_l values (1, 4, 1), (1, 4, 2), (2, 9, 1);
create index idx_fi_l on fi_l (a, sqrt(d), j);

create table fi_mo (a int, b int);
insert into fi_mo values (7, 3), (9, 4), (8, 4);
create index idx_fi_mo on fi_mo (mod(a, b));

create table fi_ls (s varchar(20), n int);
insert into fi_ls values ('abcdef', 3), ('xyz', 2), ('ab', 1);
create index idx_fi_ls on fi_ls (left(s, n));

update statistics on fi_t, fi_u, fi_m, fi_c, fi_d, fi_dh, fi_w, fi_k, fi_r, fi_s, fi_p, fi_q, fi_z, fi_e, fi_g, fi_h, fi_v, fi_n, fi_l, fi_mo, fi_ls with fullscan;

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

evaluate '[10-1] (d1, sqrt(d1)) covering an aggregate over the argument only';
--@queryplan
select max(d1) mx, count(*) c from fi_d where d1 > 0 using index idx_fi_d;
select case when p.mx <=> s.mx and p.mx <=> h.mx and p.c = s.c and p.c = h.c then 'PASS' else 'FAIL' end as result
from (select max(d1) mx, count(*) c from fi_d where d1 > 0 using index idx_fi_d) p,
     (select /*+ NO_COVERING_IDX */ max(d1) mx, count(*) c from fi_d where d1 > 0 using index idx_fi_d) s,
     (select max(d1) mx, count(*) c from fi_dh where d1 > 0) h;

evaluate '[10-2] (d1, sqrt(d1)) covering min / max / count over a key range of the argument';
--@queryplan
select max(d1) mx, min(d1) mn, count(*) c from fi_d where d1 between 16 and 1600 using index idx_fi_d;
select case when p.mx <=> s.mx and p.mx <=> h.mx and p.mn <=> s.mn and p.mn <=> h.mn and p.c = s.c and p.c = h.c then 'PASS' else 'FAIL' end as result
from (select max(d1) mx, min(d1) mn, count(*) c from fi_d where d1 between 16 and 1600 using index idx_fi_d) p,
     (select /*+ NO_COVERING_IDX */ max(d1) mx, min(d1) mn, count(*) c from fi_d where d1 between 16 and 1600 using index idx_fi_d) s,
     (select max(d1) mx, min(d1) mn, count(*) c from fi_dh where d1 between 16 and 1600) h;

evaluate '[10-3] (i1, sqrt(d1)) covering an analytic function over the leading key column';
--@queryplan
select i1, max(i1) over () mx from fi_t where i1 between 1 and 5 using index idx_fi_t order by 1;
select case when count(*) = 5 then 'PASS' else 'FAIL' end as result
from (select i1, max(i1) over () mx from fi_t where i1 between 1 and 5 using index idx_fi_t) p
     join (select /*+ NO_COVERING_IDX */ i1, max(i1) over () mx from fi_t where i1 between 1 and 5 using index idx_fi_t) s
     on p.i1 = s.i1 and p.mx <=> s.mx;

evaluate '[10-4] (i1, sqrt(d1)) expression only in the key filter, not projected';
--@queryplan
select i1 from fi_t where i1 between 1 and 10 and sqrt(d1) > 20 using index idx_fi_t order by 1;
select case when count(*) = 5 then 'PASS' else 'FAIL' end as result
from (select i1 from fi_t where i1 between 1 and 10 and sqrt(d1) > 20 using index idx_fi_t) p
     join (select /*+ NO_COVERING_IDX */ i1 from fi_t where i1 between 1 and 10 and sqrt(d1) > 20 using index idx_fi_t) s
     on p.i1 = s.i1;

evaluate '[10-5] (d1, sqrt(d1)) expression only in a subquery over the heap-only copy';
--@queryplan
select max(d1) mx from fi_d where d1 > 0 and d1 < (select max(sqrt(d1)) * 25 from fi_dh) using index idx_fi_d;
select case when p.mx <=> s.mx and p.mx <=> h.mx then 'PASS' else 'FAIL' end as result
from (select max(d1) mx from fi_d where d1 > 0 and d1 < (select max(sqrt(d1)) * 25 from fi_dh) using index idx_fi_d) p,
     (select /*+ NO_COVERING_IDX */ max(d1) mx from fi_d where d1 > 0 and d1 < (select max(sqrt(d1)) * 25 from fi_dh) using index idx_fi_d) s,
     (select max(d1) mx from fi_dh where d1 > 0 and d1 < (select max(sqrt(d1)) * 25 from fi_dh)) h;

evaluate '[10-6] (d1, sqrt(d1)) covered scan inside an inline view, argument only';
--@queryplan
select max(x) mx from (select d1 x from fi_d where d1 > 0 using index idx_fi_d) v;
select case when p.mx <=> s.mx and p.mx <=> h.mx then 'PASS' else 'FAIL' end as result
from (select max(x) mx from (select d1 x from fi_d where d1 > 0 using index idx_fi_d) v) p,
     (select /*+ NO_COVERING_IDX */ max(x) mx from (select d1 x from fi_d where d1 > 0 using index idx_fi_d) v) s,
     (select max(x) mx from (select d1 x from fi_dh where d1 > 0) v) h;

evaluate '[11-1] (i1, j, sqrt(d1)) multi-range optimization projecting the expression';
--@queryplan
select j, sqrt(d1) r, case when sqrt(d1) = 4 * (1000 - j) then 'PASS' else 'FAIL' end chk from fi_r where i1 in (1, 2) order by j limit 5;
select /*+ NO_COVERING_IDX */ j, sqrt(d1) r, case when sqrt(d1) = 4 * (1000 - j) then 'PASS' else 'FAIL' end chk from fi_r where i1 in (1, 2) order by j limit 5;

evaluate '[11-2] (i1, j, sqrt(d1)) multi-range optimization with the expression in the key filter';
--@queryplan
select j, sqrt(d1) r, case when sqrt(d1) = 4 * (1000 - j) then 'PASS' else 'FAIL' end chk from fi_r where i1 in (1, 2) and sqrt(d1) > 20 order by j limit 5;
select /*+ NO_COVERING_IDX NO_MULTI_RANGE_OPT */ j, sqrt(d1) r, case when sqrt(d1) = 4 * (1000 - j) then 'PASS' else 'FAIL' end chk from fi_r where i1 in (1, 2) and sqrt(d1) > 20 order by j limit 5;

evaluate '[11-3] (i1, j, sqrt(d1)) multi-range optimization in descending order';
--@queryplan
select i1, j, sqrt(d1) r, case when sqrt(d1) = 4 * (1000 - j) and i1 = (1000 - j) % 5 then 'PASS' else 'FAIL' end chk from fi_r where i1 in (1, 2) order by j desc limit 5;
select /*+ NO_COVERING_IDX */ i1, j, sqrt(d1) r, case when sqrt(d1) = 4 * (1000 - j) and i1 = (1000 - j) % 5 then 'PASS' else 'FAIL' end chk from fi_r where i1 in (1, 2) order by j desc limit 5;

evaluate '[11-4] (i1, j, sqrt(d1)) multi-range optimization by FOR ORDERBY_NUM ()';
--@queryplan
select j, sqrt(d1) r, case when sqrt(d1) = 4 * (1000 - j) then 'PASS' else 'FAIL' end chk from fi_r where i1 in (1, 2) order by j for orderby_num () <= 5;
select /*+ NO_COVERING_IDX */ j, sqrt(d1) r, case when sqrt(d1) = 4 * (1000 - j) then 'PASS' else 'FAIL' end chk from fi_r where i1 in (1, 2) order by j for orderby_num () <= 5;

evaluate '[12-1] self join over (k, mod(a, b)): an expression mixing both aliases is not read from the key';
--@queryplan
select o.k, mod(o.a, o.b) r, mod(o.a, i.b) m, case when mod(o.a, i.b) <=> mod(o.a, o.b) then 'PASS' else 'FAIL' end chk from fi_s o, fi_s i where o.k > 0 and i.k = o.k order by 1;
select /*+ NO_COVERING_IDX */ o.k, mod(o.a, o.b) r, mod(o.a, i.b) m, case when mod(o.a, i.b) <=> mod(o.a, o.b) then 'PASS' else 'FAIL' end chk from fi_s o, fi_s i where o.k > 0 and i.k = o.k order by 1;
select o.k, mod(o.a, o.b) r, mod(i.a, o.b) m, case when mod(i.a, o.b) <=> mod(o.a, o.b) then 'PASS' else 'FAIL' end chk from fi_s o, fi_s i where o.k > 0 and i.k = o.k order by 1;

evaluate '[12-2] plain index (d) of a table with a function index on sqrt(d): not covered, as before';
--@queryplan
select sqrt(d) r from fi_p where d > 0 using index idx_fi_pd order by 1;
select /*+ NO_COVERING_IDX */ sqrt(d) r from fi_p where d > 0 using index idx_fi_pd order by 1;

evaluate '[12-3] (i, j, sqrt(d)) without the expression: FOR UPDATE / DELETE keep the key filter';
--@queryplan
select i, j from fi_q where i > 0 and j <> 3 order by 1 for update;
commit;
--@queryplan
delete from fi_q where i > 0 and j <> 3;
select case when count(*) = 2 and min(j) = 3 then 'PASS' else 'FAIL' end as result from fi_q;

evaluate '[12-4] (i, to_datetime_tz(s)): equal keys of different time zones are not read from the key';
--@queryplan
select to_char(to_datetime_tz(s), 'YYYY-MM-DD HH24:MI:SS TZH:TZM') r from fi_z where i = 1 order by 1;
select /*+ NO_COVERING_IDX */ to_char(to_datetime_tz(s), 'YYYY-MM-DD HH24:MI:SS TZH:TZM') r from fi_z where i = 1 order by 1;
select i from fi_z where i = 1 and to_char(to_datetime_tz(s), 'TZH:TZM') = '+00:00';
select /*+ NO_COVERING_IDX */ i from fi_z where i = 1 and to_char(to_datetime_tz(s), 'TZH:TZM') = '+00:00';
select case when p.g = s.g then 'PASS' else 'FAIL' end as result
from (select group_concat(r order by r separator ',') g from (select /*+ NO_MERGE */ to_char(to_datetime_tz(s), 'TZH:TZM') r from fi_z where i = 1) v) p,
     (select group_concat(r order by r separator ',') g from (select /*+ NO_MERGE NO_COVERING_IDX */ to_char(to_datetime_tz(s), 'TZH:TZM') r from fi_z where i = 1) v) s;

evaluate '[12-5] (n, s collate utf8_en_ci): case-insensitive equal keys are not read from the key';
--@queryplan
select ascii(s collate utf8_en_ci) a from fi_e where n > 0 using index idx_fi_e(+) order by 1;
select /*+ NO_COVERING_IDX */ ascii(s collate utf8_en_ci) a from fi_e where n > 0 using index idx_fi_e(+) order by 1;

evaluate '[12-6] outer join: expression in the ON condition of the preserved side (during join)';
--@queryplan
select o.x, i.k from fi_g o left join fi_h i on o.x = i.k and sqrt(o.d) > 1 where o.x > 0 order by 1;
select /*+ NO_COVERING_IDX */ o.x, i.k from fi_g o left join fi_h i on o.x = i.k and sqrt(o.d) > 1 where o.x > 0 order by 1;

evaluate '[12-7] outer join: expression in the WHERE clause of the null-supplying side (after join)';
--@queryplan
select o.x, sqrt(i.d) r from fi_v o left join fi_n i on o.x = i.k where sqrt(i.d) is null order by 1;
select /*+ NO_COVERING_IDX */ o.x, sqrt(i.d) r from fi_v o left join fi_n i on o.x = i.k where sqrt(i.d) is null order by 1;

evaluate '[12-8] loose index scan under a hash / merge join with the expression projected';
--@queryplan
select /*+ INDEX_LS USE_HASH */ distinct o.a, sqrt(o.d) r from fi_l o, fi_h i where o.a = i.k and o.a > 0 order by 1;
select /*+ INDEX_LS USE_MERGE */ distinct o.a, sqrt(o.d) r from fi_l o, fi_h i where o.a = i.k and o.a > 0 order by 1;
select /*+ NO_COVERING_IDX */ distinct o.a, sqrt(o.d) r from fi_l o, fi_h i where o.a = i.k and o.a > 0 order by 1;

evaluate '[12-9] single-column function index over two arguments: mod(a, b)';
--@queryplan
select mod(a, b) r from fi_mo where mod(a, b) > 0 using index idx_fi_mo(+) order by 1;
select /*+ NO_COVERING_IDX */ mod(a, b) r from fi_mo where mod(a, b) > 0 using index idx_fi_mo(+) order by 1;

evaluate '[12-10] single-column function index over two arguments: left(s, n)';
--@queryplan
select left(s, n) r from fi_ls where left(s, n) > 'a' using index idx_fi_ls(+) order by 1;
select /*+ NO_COVERING_IDX */ left(s, n) r from fi_ls where left(s, n) > 'a' using index idx_fi_ls(+) order by 1;

evaluate '[12-11] (i, date_format(ts, ''%H'')) over a TIMESTAMP stored in another session time zone';
set system parameters 'timezone=+09:00';
create table fi_ts (i int, ts timestamp);
create index idx_fi_ts on fi_ts (i, date_format(ts, '%H'));
insert into fi_ts values (1, timestamp'2015-02-24 12:30');
set system parameters 'timezone=+00:00';
--@queryplan
select /*+ recompile */ i from fi_ts where i = 1 and date_format(ts, '%H') <> '12' using index idx_fi_ts;
select /*+ recompile NO_COVERING_IDX */ i from fi_ts where i = 1 and date_format(ts, '%H') <> '12' using index idx_fi_ts;
--@queryplan
select /*+ recompile */ date_format(ts, '%H') r from fi_ts where i = 1 using index idx_fi_ts;
select /*+ recompile NO_COVERING_IDX */ date_format(ts, '%H') r from fi_ts where i = 1 using index idx_fi_ts;
set system parameters 'timezone=default';

evaluate '[12-12] (i, date_format(d, ''%W'')) read in another session date language';
create table fi_dl (i int, d date);
create index idx_fi_dl on fi_dl (i, date_format(d, '%W'));
insert into fi_dl values (1, date '2020-01-06');
set system parameters 'intl_date_lang=ko_KR';
--@queryplan
select /*+ recompile */ date_format(d, '%W') r from fi_dl where i = 1;
select /*+ recompile NO_COVERING_IDX */ date_format(d, '%W') r from fi_dl where i = 1;
--@queryplan
select /*+ recompile */ i from fi_dl where i = 1 and date_format(d, '%W') <> 'Monday';
select /*+ recompile NO_COVERING_IDX */ i from fi_dl where i = 1 and date_format(d, '%W') <> 'Monday';
set system parameters 'intl_date_lang=en_US';

evaluate '[13-1] non-covered (i, sqrt(d)) scan: the expression is a key filter while p is read from the heap';
create table fi_a (i int, d double, p varchar(10));
insert into fi_a select rownum % 4, rownum * rownum * 16, 'p' || rownum from db_class limit 20;
create index idx_fi_a on fi_a (i, sqrt(d));
update statistics on fi_a with fullscan;
--@queryplan
select p from fi_a where i between 1 and 2 and sqrt(d) > 20 using index idx_fi_a order by 1;
select /*+ NO_COVERING_IDX */ p from fi_a where i between 1 and 2 and sqrt(d) > 20 using index idx_fi_a order by 1;
select p from fi_a where i between 1 and 2 and sqrt(d) > 20 using index none order by 1;

evaluate '[13-2] (c1, abs(c2), c3) with c4 outside the key: function and plain column key filters';
create table fi_b (c1 int, c2 int, c3 int, c4 varchar(10));
insert into fi_b values (1, 1, -1, 'a'), (1, 2, -2, 'b'), (1, 3, -3, 'c'), (1, -4, -3, 'd'), (1, 0, -3, 'e'), (2, 3, -3, 'f');
create index idx_fi_b on fi_b (c1, abs(c2), c3);
update statistics on fi_b with fullscan;
--@queryplan
select c1, c4 from fi_b where c1 = 1 and abs(c2) > 1 and c3 = -3 using index idx_fi_b order by 2;
select c1, c4 from fi_b where c1 = 1 and abs(c2) > 1 and c3 = -3 using index none order by 2;
--@queryplan
select c4 from fi_b where c1 = 1 and c3 = -3 using index idx_fi_b order by 1;
select c4 from fi_b where c1 = 1 and c3 = -3 using index none order by 1;

evaluate '[13-3] key filter of a merged derived table (parenthesized expression)';
--@queryplan
select x.p from (select p, i, d from fi_a where i between 1 and 2 using index idx_fi_a) x where sqrt(x.d) > 20 order by 1;
select x.p from (select p, i, d from fi_a where i between 1 and 2 using index none) x where sqrt(x.d) > 20 order by 1;

evaluate '[13-4] key filter next to a raw argument term (d < 5000 stays a data filter)';
--@queryplan
select p from fi_a where i between 1 and 3 and sqrt(d) > 20 and d < 5000 using index idx_fi_a order by 1;
select p from fi_a where i between 1 and 3 and sqrt(d) > 20 and d < 5000 using index none order by 1;

evaluate '[13-5] (i, date_format(d, ''%W'')) read in another session date language: data filter';
create table fi_x (i int, d date, p varchar(10));
insert into fi_x values (1, date '2020-01-06', 'mon'), (1, date '2020-01-07', 'tue'), (2, date '2020-01-06', 'mon2');
create index idx_fi_x on fi_x (i, date_format(d, '%W'));
update statistics on fi_x with fullscan;
set system parameters 'intl_date_lang=ko_KR';
--@queryplan
select /*+ recompile */ p from fi_x where i = 1 and date_format(d, '%W') <> 'Monday' using index idx_fi_x order by 1;
select /*+ recompile */ p from fi_x where i = 1 and date_format(d, '%W') <> 'Monday' using index none order by 1;
set system parameters 'intl_date_lang=en_US';

evaluate '[13-6] to_datetime_tz and utf8_en_ci results whose equal keys differ: data filter';
create table fi_y (i int, s varchar(40), p varchar(10));
insert into fi_y values (1, '2020-01-01 10:00:00 +09:00', 'kst'), (1, '2020-01-01 01:00:00 +00:00', 'utc');
create index idx_fi_y on fi_y (i, to_datetime_tz(s));
create table fi_i (i int, s varchar(20) collate utf8_en_ci, p varchar(10));
insert into fi_i values (1, 'Ab', 'upper'), (1, 'ab', 'lower'), (2, 'AB', 'other');
create index idx_fi_i on fi_i (i, trim(s));
update statistics on fi_y, fi_i with fullscan;
--@queryplan
select p from fi_y where i = 1 and to_char(to_datetime_tz(s), 'TZH:TZM') = '+00:00' using index idx_fi_y order by 1;
select p from fi_y where i = 1 and to_char(to_datetime_tz(s), 'TZH:TZM') = '+00:00' using index none order by 1;
--@queryplan
select p from fi_i where i = 1 and ascii(trim(s)) = 97 using index idx_fi_i order by 1;
select p from fi_i where i = 1 and ascii(trim(s)) = 97 using index none order by 1;

evaluate '[13-7] UPDATE / DELETE / FOR UPDATE keep the expression as a data filter (heap re-evaluation)';
--@queryplan
select p from fi_a where i between 1 and 2 and sqrt(d) > 20 using index idx_fi_a order by 1 for update;
commit;
--@queryplan
update fi_a set p = p || 'u' where i between 1 and 2 and sqrt(d) > 20 using index idx_fi_a;
select case when count(*) = 7 then 'PASS' else 'FAIL' end as result from fi_a where p like '%u';
--@queryplan
delete from fi_a where i >= 3 and sqrt(d) > 20 using index idx_fi_a;
select case when count(*) = 16 and count(case when i = 3 then 1 end) = 1 then 'PASS' else 'FAIL' end as result from fi_a;

drop table if exists fi_t, fi_u, fi_m, fi_c, fi_d, fi_dh, fi_w, fi_k, fi_r, fi_s, fi_p, fi_q, fi_z, fi_e, fi_g, fi_h, fi_v, fi_n, fi_l, fi_mo, fi_ls,
  fi_ts, fi_dl, fi_a, fi_b, fi_x, fi_y, fi_i;

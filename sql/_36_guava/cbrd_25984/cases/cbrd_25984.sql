/**
 *  CBRD-25984: covered index scan and key filter on function indexes.
 *
 *  Bug: a function index (e.g. (i1, sqrt(d1))) stores only the function result in the key, so the
 *       optimizer refused covering scans and key filters whenever the indexed expression appeared.
 *  Fix: the projected / key-filtered expression is read from the precomputed result slot of the key
 *       through a dedicated result attribute. Covering stays disabled when the raw argument is needed
 *       (raw projection, join or subquery referencing the expression, GROUP BY / aggregates,
 *       UPDATE / DELETE / FOR UPDATE targets, which the server re-evaluates from the heap).
 *
 *  Coverage: each check compares the plain query against the same query with the NO_COVERING_IDX
 *            hint and emits PASS / FAIL; plans are dumped where the shape itself is the contract.
 *    1. covering + function key filter (two-column, single-column and multi-argument indexes)
 *    2. raw argument also projected / filtered / ordered -> no covering, correct values
 *    3. expression inside a scalar subquery, EXISTS subquery, NL / hash / outer join condition
 *    4. key filter only (collation term left as data filter) -> no covering, no error
 *    5. UPDATE assignment, DELETE and SELECT ... FOR UPDATE using the expression
 *  Sizing: 20 rows are enough; every scan is a short key range, no parallelism involved.
 */

drop table if exists fi_t, fi_u, fi_m, fi_c;

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

update statistics on fi_t, fi_u, fi_m, fi_c with fullscan;

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

drop table if exists fi_t, fi_u, fi_m, fi_c;

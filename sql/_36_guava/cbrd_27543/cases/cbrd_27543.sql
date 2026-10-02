-- CBRD-27543: the optimizer skips NL join memoize when statistics show the outer key hardly repeats
--
-- The executor memoizes every NL inner and gives up at run time when the hit ratio stays low.
-- When an outer key column is near-unique in its table (NDV >= 90% of its rows) and the expected
-- hit ratio of the inner calls is under 10%, the optimizer marks the inner scan not to memoize.
--
-- near_uniq repeats only in the first 3000 rows (100 values) and is unique after them: NDV is 97100 of
-- 100000 rows. With statistics the optimizer skips memoize, so the repeated keys of the first 3000 rows
-- all reach the inner index (readkeys 3000 instead of 100; the trace counters are masked here). Without
-- statistics the run-time check memoizes them and gives up once the unique keys follow.
--
-- Covers:
--   - near-unique outer key with statistics: no MEMOIZE (serial and parallel)
--   - the same key without statistics: decided at run time
--   - low NDV outer key: MEMOIZE printed
--   - near-unique key repeated by join fan-out in the outer: MEMOIZE printed on the last inner
--   - results equal with memoize enabled and disabled

drop table if exists t_outer;
drop table if exists t_fan;
drop table if exists t_inner;
drop table if exists t_outer_nostat;

create table t_outer (id int primary key, near_uniq int, low_ndv int);
insert into t_outer select rownum, case when rownum <= 3000 then rownum % 100 else rownum end, rownum % 300
from db_class a, db_class b, db_class c, db_class d, db_class e limit 100000;

create table t_outer_nostat (id int, near_uniq int);
insert into t_outer_nostat select rownum, case when rownum <= 3000 then rownum % 100 else rownum end
from db_class a, db_class b, db_class c, db_class d, db_class e limit 100000;

create table t_fan (oid int, v int);
insert into t_fan select o.id, f.n from t_outer o, (select 1 n union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9 union all select 10) f where o.id <= 3000;
create index i_fan_oid on t_fan (oid);

create table t_inner (k int, v int);
insert into t_inner select rownum, rownum from db_class a, db_class b, db_class c limit 3000;
create index i_inner_k on t_inner (k);

update statistics on t_outer, t_fan, t_inner with fullscan;

set trace on;
set system parameters 'memoize_memory_limit=64M';

evaluate 'near-unique key with statistics - expect: no MEMOIZE';
select /*+ recompile parallel(0) ordered use_nl(i) */ count(*), sum(i.v) from t_outer o, t_inner i where i.k = o.near_uniq;
show trace;

evaluate 'near-unique key with statistics, parallel - expect: no MEMOIZE';
select /*+ recompile parallel(4) ordered use_nl(i) */ count(*), sum(i.v) from t_outer o, t_inner i where i.k = o.near_uniq;
show trace;

evaluate 'near-unique key without statistics - expect: run-time decision, no MEMOIZE after it gives up';
select /*+ recompile parallel(0) ordered use_nl(i) */ count(*), sum(i.v) from t_outer_nostat o, t_inner i where i.k = o.near_uniq;
show trace;

evaluate 'low NDV key - expect: MEMOIZE';
select /*+ recompile parallel(0) ordered use_nl(i) */ count(*), sum(i.v) from t_outer o, t_inner i where i.k = o.low_ndv;
show trace;

evaluate 'near-unique key repeated 10 times by join fan-out - expect: MEMOIZE on t_inner only';
select /*+ recompile parallel(0) ordered use_nl(f, i) */ count(*), sum(f.v + i.v) from t_outer o, t_fan f, t_inner i where f.oid = o.id and i.k = o.id;
show trace;

set trace off;

evaluate 'results with memoize enabled and disabled';
select /*+ recompile parallel(0) ordered use_nl(i) */ count(*), sum(i.v) from t_outer o, t_inner i where i.k = o.near_uniq;
select /*+ recompile parallel(0) ordered use_nl(f, i) */ count(*), sum(f.v + i.v) from t_outer o, t_fan f, t_inner i where f.oid = o.id and i.k = o.id;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl(i) */ count(*), sum(i.v) from t_outer o, t_inner i where i.k = o.near_uniq;
select /*+ recompile parallel(0) ordered use_nl(f, i) */ count(*), sum(f.v + i.v) from t_outer o, t_fan f, t_inner i where f.oid = o.id and i.k = o.id;

set system parameters 'memoize_memory_limit=default';

drop table t_outer;
drop table t_fan;
drop table t_inner;
drop table t_outer_nostat;

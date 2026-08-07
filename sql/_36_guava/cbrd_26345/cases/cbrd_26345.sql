-- CBRD-26345: Implement memoize
--
-- For NLJ with repeated join keys on the inner table,
-- caches inner scan results keyed by join column value.
-- Verify memoize activation behavior with various column types
-- (different NDV ratios) under enabled/disabled memory limit settings.

-- cleanup
drop table if exists outer_tbl;
drop table if exists inner_tbl;

create table outer_tbl (uniq_int int, low_ndv_int int, mid_ndv_int int, mid_ndv_varchar varchar(20), high_ndv_numeric numeric(20,10), uniq_varchar varchar(20), half_ndv_varchar varchar(20), third_ndv_varchar varchar(20));
insert into outer_tbl select
  rownum,
  rownum % 10,
  rownum % 100,
  lpad(to_char(rownum % 300), 20, '0'),
  rownum % 10000,
  lpad(to_char(rownum), 20, '0'),
  lpad(to_char(rownum % 49999), 20, '0'),
  lpad(to_char(rownum % 33333), 20, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e, db_class f, db_class g
limit 100000;

create table inner_tbl (join_key int);
insert into inner_tbl select rownum from db_class a, db_class b, db_class c, db_class d, db_class e, db_class f, db_class g limit 10;
update statistics on outer_tbl, inner_tbl with fullscan;

evaluate 'memoize enabled (memoize_memory_limit=64M)';

set trace on;
set system parameters 'memoize_memory_limit=64M';

evaluate 'uniq_int (INT, NDV=100000, unique) - expect: no memoize';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.uniq_int = inner_tbl.join_key;
show trace;
evaluate 'low_ndv_int (INT, NDV=10) - expect: memoize enabled';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.low_ndv_int = inner_tbl.join_key;
show trace;
evaluate 'mid_ndv_int (INT, NDV=100) - expect: memoize enabled';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.mid_ndv_int = inner_tbl.join_key;
show trace;
evaluate 'mid_ndv_varchar (VARCHAR, NDV=300) - expect: memoize enabled';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.mid_ndv_varchar = inner_tbl.join_key;
show trace;
evaluate 'high_ndv_numeric (NUMERIC, NDV=10000) - expect: no memoize';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.high_ndv_numeric = inner_tbl.join_key;
show trace;
evaluate 'uniq_varchar (VARCHAR, NDV=100000, unique) - expect: no memoize';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.uniq_varchar = inner_tbl.join_key;
show trace;
evaluate 'half_ndv_varchar (VARCHAR, NDV=49999) - expect: no memoize';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.half_ndv_varchar = inner_tbl.join_key;
show trace;
evaluate 'third_ndv_varchar (VARCHAR, NDV=33333) - expect: no memoize';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.third_ndv_varchar = inner_tbl.join_key;
show trace;

evaluate 'memoize disabled (memoize_memory_limit=0)';

set system parameters 'memoize_memory_limit=0';

evaluate 'uniq_int (INT, NDV=100000, unique) - expect: no memoize (disabled)';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.uniq_int = inner_tbl.join_key;
show trace;
evaluate 'low_ndv_int (INT, NDV=10) - expect: no memoize (disabled)';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.low_ndv_int = inner_tbl.join_key;
show trace;
evaluate 'mid_ndv_int (INT, NDV=100) - expect: no memoize (disabled)';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.mid_ndv_int = inner_tbl.join_key;
show trace;
evaluate 'mid_ndv_varchar (VARCHAR, NDV=300) - expect: no memoize (disabled)';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.mid_ndv_varchar = inner_tbl.join_key;
show trace;
evaluate 'high_ndv_numeric (NUMERIC, NDV=10000) - expect: no memoize (disabled)';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.high_ndv_numeric = inner_tbl.join_key;
show trace;
evaluate 'uniq_varchar (VARCHAR, NDV=100000, unique) - expect: no memoize (disabled)';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.uniq_varchar = inner_tbl.join_key;
show trace;
evaluate 'half_ndv_varchar (VARCHAR, NDV=49999) - expect: no memoize (disabled)';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.half_ndv_varchar = inner_tbl.join_key;
show trace;
evaluate 'third_ndv_varchar (VARCHAR, NDV=33333) - expect: no memoize (disabled)';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.third_ndv_varchar = inner_tbl.join_key;
show trace;

set trace off;
set system parameters 'memoize_memory_limit=default';

-- additional scenarios covering the runtime-activation cases and constraints
-- listed in the JIRA description.
-- cache-full -> enabled:false is intentionally excluded: only observable on
-- CUBRID builds between #6652(2025-12-01) and #6877(2026-03-09); unreproducible
-- on any current/future build.
drop table if exists extra_join_tbl;
drop table if exists set_col_tbl;
drop table if exists multiset_col_tbl;
drop table if exists sequence_col_tbl;
drop view if exists low_ndv_view;

create table extra_join_tbl (dup_key int, seq int);
insert into extra_join_tbl select rownum % 100, rownum from db_class a, db_class b, db_class c, db_class d, db_class e, db_class f, db_class g limit 100;
update statistics on extra_join_tbl with fullscan;

create table set_col_tbl (id int, s set(int));
insert into set_col_tbl values (1, {1,2}), (2, {3,4}), (3, {5,6}), (4, {7,8}), (5, {9,10});

create table multiset_col_tbl (id int, ms multiset(int));
insert into multiset_col_tbl values (1, multiset{1,1,2}), (2, multiset{3,3,4}), (3, multiset{5,5,6}), (4, multiset{7,7,8}), (5, multiset{9,9,10});

create table sequence_col_tbl (id int, sq sequence(int));
insert into sequence_col_tbl values (1, sequence{1,2}), (2, sequence{3,4}), (3, sequence{5,6}), (4, sequence{7,8}), (5, sequence{9,10});

create view low_ndv_view as select low_ndv_int, uniq_int from outer_tbl;

set trace on;
set system parameters 'memoize_memory_limit=64M';

evaluate '3-way join -> runtime memoize activation on both joins';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl, extra_join_tbl) */ count(*)
from outer_tbl inner join inner_tbl on outer_tbl.low_ndv_int = inner_tbl.join_key
              inner join extra_join_tbl on outer_tbl.mid_ndv_int = extra_join_tbl.dup_key;
show trace;

evaluate 'view-to-table join -> runtime memoize activation (view exposes no NDV stats)';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from low_ndv_view inner join inner_tbl on low_ndv_view.low_ndv_int = inner_tbl.join_key;
show trace;

evaluate 'constraint#4: cartesian product (no join condition) - expect: no memoize';
select /*+ recompile parallel(0) */ count(*) from outer_tbl, inner_tbl;
show trace;

evaluate 'constraint#2: TARGET_SET-derived TABLE() inner - expect: no memoize';
select /*+ recompile parallel(0) ordered use_nl(t) */ count(*) from outer_tbl inner join TABLE({1,2,3,4,5,6,7,8,9,10}) t(x) on outer_tbl.low_ndv_int = t.x;
show trace;

evaluate 'constraint#3: SET column real projection - expect: no memoize';
select /*+ recompile parallel(0) ordered use_nl(set_col_tbl) */ outer_tbl.low_ndv_int, set_col_tbl.s from outer_tbl inner join set_col_tbl on outer_tbl.low_ndv_int = set_col_tbl.id limit 5;
show trace;

evaluate 'constraint#3: MULTISET column real projection - expect: no memoize';
select /*+ recompile parallel(0) ordered use_nl(multiset_col_tbl) */ outer_tbl.low_ndv_int, multiset_col_tbl.ms from outer_tbl inner join multiset_col_tbl on outer_tbl.low_ndv_int = multiset_col_tbl.id limit 5;
show trace;

evaluate 'constraint#3: SEQUENCE column real projection - expect: no memoize';
select /*+ recompile parallel(0) ordered use_nl(sequence_col_tbl) */ outer_tbl.low_ndv_int, sequence_col_tbl.sq from outer_tbl inner join sequence_col_tbl on outer_tbl.low_ndv_int = sequence_col_tbl.id limit 5;
show trace;

evaluate 'memoize with index scan on inner table';
create index idx_inner_tbl_key on inner_tbl (join_key);
update statistics on inner_tbl with fullscan;
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.low_ndv_int = inner_tbl.join_key;
show trace;
drop index idx_inner_tbl_key on inner_tbl;

set trace off;
set system parameters 'memoize_memory_limit=default';

-- cleanup
drop view if exists low_ndv_view;
drop table if exists sequence_col_tbl;
drop table if exists multiset_col_tbl;
drop table if exists set_col_tbl;
drop table if exists extra_join_tbl;
drop table if exists outer_tbl;
drop table if exists inner_tbl;

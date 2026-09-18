-- CBRD-26345: Implement memoize
--
-- For NLJ with repeated join keys on the inner table,
-- caches inner scan results keyed by join column value.
--
-- Covers:
--   - activation behavior with various column types (different NDV
--     ratios) under enabled/disabled memory limit settings
--   - activation across join shapes (3-way join, view-to-table join,
--     indexed inner scan)
--   - cases where memoize must not activate (cartesian product,
--     TABLE()-derived inner, untyped SET column projection)
--   - element-typed collection columns (SET(INT)/MULTISET(INT)/SEQUENCE(INT))
--     are NOT excluded and get memoized like any other type once enough
--     repeated keys are read - separated from the hit=0 case (no repeated
--     keys read yet) so neither is mistaken for the other
--   - multi-row-per-key cache correctness (row-level output compared
--     between memoize enabled and disabled)

-- cleanup
drop table if exists outer_tbl;
drop table if exists inner_tbl;

-- mid_ndv_varchar uses NDV=300, chosen relative to
-- MEMOIZE_FREE_ITERATION_LIMIT=1000 (memoize.hpp): with only 300 distinct
-- values, the runtime hit-ratio check is guaranteed a minimum hit ratio of
-- (limit-NDV)/limit = 70% within the first `limit` probes, regardless of
-- physical heap scan order. If this constant changes in the future, NDV
-- must be re-evaluated to keep (limit-NDV)/limit > 0.5.
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
evaluate 'half_ndv_varchar (VARCHAR, NDV=49999) - expect: no memoize (NDV exceeds the 1000-probe free-iteration limit; the 0.50001 duplicate ratio is irrelevant to the current runtime check)';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.half_ndv_varchar = inner_tbl.join_key;
show trace;
evaluate 'third_ndv_varchar (VARCHAR, NDV=33333) - expect: no memoize (NDV exceeds the 1000-probe free-iteration limit; the 0.667 duplicate ratio is irrelevant to the current runtime check)';
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
-- on any current/future build, because clear_memoize_storage() (memoize.cpp,
-- called from storage::put()/put_nullptr() on disable) frees the storage and
-- resets the pointer to null the instant it would go disabled, and the trace
-- printer (query_dump.c) only emits the MEMOIZE line when the pointer is
-- non-null and hit > 0 - so a disabled cache produces no trace output at all
-- on these builds, identical to a cache that was simply never created.
--
-- Note on the "expect: no memoize" scenarios in general: they cannot
-- distinguish "memoize was never created for this scan" from "it was created
-- and then disabled at runtime" from "it was created and enabled but never
-- got a hit" - all three produce the same observable output (no MEMOIZE line).
-- Regression coverage against memoize being disabled globally comes from the
-- "expect: memoize enabled" scenarios above, not from these negative ones.
drop table if exists extra_join_tbl;
drop table if exists set_col_tbl;
drop table if exists multiset_col_tbl;
drop table if exists sequence_col_tbl;
drop table if exists inner_dup;
drop table if exists untyped_tbl;
drop table if exists unique_outer;
drop view if exists ordered_outer_view;
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

-- untyped_tbl's SET column has no declared element type, unlike set_col_tbl's
-- SET(INT) above. Per CBRD-26345's 2026-09-15 description update, this is the
-- only shape the exclusion check actually catches: possible_check() (memoize.cpp)
-- keys off the placeholder value's own domain type, but an element-typed
-- collection's placeholder gets initialized to the element type instead of
-- SET/MULTISET/SEQUENCE (parse_dbi.c pt_data_type_init_value), so only an
-- untyped SET is recognized and excluded - SET(INT)/MULTISET(INT)/SEQUENCE(INT)
-- are not.
create table untyped_tbl (id int, s set);
insert into untyped_tbl values (1,{11,12}), (2,{21,22,23}), (3,{31,32}), (4,{41,42,43}), (5,{51,52});

-- unique_outer has 5 rows with 5 distinct keys matching set_col_tbl/
-- multiset_col_tbl/sequence_col_tbl's ids 1..5, none repeated - every probe is
-- a first-time key, so hit is always 0 and no MEMOIZE trace can appear here
-- regardless of column type. Isolates the hit=0 case so it is never confused
-- with an actual type-based exclusion (query_dump.c only prints MEMOIZE when
-- storage != nullptr AND hit > 0 - hit=0 looks identical to "never created").
create table unique_outer (id int);
insert into unique_outer values (1),(2),(3),(4),(5);

-- inner_dup has duplicate join keys (unlike inner_tbl, whose join_key is
-- unique 1..10), so a cache hit for a given key must return more than one
-- row. count(*)/limit-only assertions elsewhere in this file never exercise
-- that path; here the actual row-level output is compared between
-- memoize_memory_limit=64M (on) and =0 (off) so a bug in the multi-row cache
-- path would show up as a result mismatch, not just a missing trace line.
create table inner_dup (join_key int, payload varchar(10));
insert into inner_dup values (1,'a'),(2,'a'),(3,'a'),(3,'b'),(3,'c'),(4,'a'),(5,'a'),(6,'a'),(7,'a'),(7,'b'),(8,'a'),(9,'a'),(10,'a'),(null,'z');
update statistics on inner_dup with fullscan;

create view low_ndv_view as select low_ndv_int, uniq_int from outer_tbl;

set trace on;
set system parameters 'memoize_memory_limit=64M';

evaluate '3-way join - expect: memoize enabled on both joins';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl, extra_join_tbl) */ count(*)
from outer_tbl inner join inner_tbl on outer_tbl.low_ndv_int = inner_tbl.join_key
              inner join extra_join_tbl on outer_tbl.mid_ndv_int = extra_join_tbl.dup_key;
show trace;

evaluate 'view-to-table join (view exposes no NDV stats) - expect: memoize enabled';
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from low_ndv_view inner join inner_tbl on low_ndv_view.low_ndv_int = inner_tbl.join_key;
show trace;

evaluate 'cartesian product (no join condition) - expect: no memoize';
select /*+ recompile parallel(0) */ count(*) from outer_tbl, inner_tbl;
show trace;

evaluate 'TARGET_SET-derived TABLE() inner - expect: no memoize';
select /*+ recompile parallel(0) ordered use_nl(t) */ count(*) from outer_tbl inner join TABLE({1,2,3,4,5,6,7,8,9,10}) t(x) on outer_tbl.low_ndv_int = t.x;
show trace;

-- CBRD-26345 description (2026-09-15 update): an element-typed collection
-- (SET(INT)/MULTISET(INT)/SEQUENCE(INT)) is NOT excluded from memoize - only
-- an untyped SET is. Following the JIRA's attached test.md verification
-- design (T1-T6) as closely as possible, in the same order as test.md's own
-- SQL (MULTISET, SET, SEQUENCE - each through LIMIT 5 / LIMIT 50 / ORDER BY
-- LIMIT 5 / no LIMIT, at both memoize_memory_limit=64M and =0).

-- developer review: LIMIT 5/50 without an order by returns whatever rows the
-- physical heap scan happens to visit first, which is not guaranteed stable
-- across environments/runs - freezing that into a fixed .answer is unsafe.
-- ordered_outer_view pre-sorts by uniq_int with NO_MERGE (so the optimizer
-- can't fold the sort away), giving the outer NLJ a fixed row order to read
-- from while still letting the outer LIMIT terminate that NLJ early - the
-- view's own ORDER BY needs a full sort internally, but that is a one-time
-- cost paid before the outer LIMIT ever applies, not part of what the outer
-- LIMIT's early-termination is being tested against.
create view ordered_outer_view as select /*+ no_merge */ uniq_int, low_ndv_int from outer_tbl order by uniq_int;

-- ===== MULTISET(INT), 64M =====
evaluate 'MULTISET(INT) real projection, limit 5 only - no assertion on memoize state, output correctness only (memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(multiset_col_tbl) */ ordered_outer_view.low_ndv_int, multiset_col_tbl.ms from ordered_outer_view inner join multiset_col_tbl on ordered_outer_view.low_ndv_int = multiset_col_tbl.id limit 5;
show trace;

evaluate 'MULTISET(INT) real projection, limit 50 - expect: partial MEMOIZE trace may appear (memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(multiset_col_tbl) */ ordered_outer_view.low_ndv_int, multiset_col_tbl.ms from ordered_outer_view inner join multiset_col_tbl on ordered_outer_view.low_ndv_int = multiset_col_tbl.id limit 50;
show trace;

evaluate 'MULTISET(INT) real projection, order by uniq_int limit 5 - expect: memoize enabled (element-typed collection is not excluded, memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(multiset_col_tbl) */ outer_tbl.low_ndv_int, multiset_col_tbl.ms from outer_tbl inner join multiset_col_tbl on outer_tbl.low_ndv_int = multiset_col_tbl.id order by outer_tbl.uniq_int limit 5;
show trace;

evaluate 'MULTISET(INT) real projection, no limit (full scan) - expect: memoize enabled, value-fidelity baseline (memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(multiset_col_tbl) */ outer_tbl.low_ndv_int, multiset_col_tbl.ms from outer_tbl inner join multiset_col_tbl on outer_tbl.low_ndv_int = multiset_col_tbl.id;
show trace;

-- ===== SET(INT), 64M =====
evaluate 'SET(INT) real projection, limit 5 only - no assertion on memoize state, output correctness only (memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(set_col_tbl) */ ordered_outer_view.low_ndv_int, set_col_tbl.s from ordered_outer_view inner join set_col_tbl on ordered_outer_view.low_ndv_int = set_col_tbl.id limit 5;
show trace;

evaluate 'SET(INT) real projection, limit 50 - expect: partial MEMOIZE trace may appear (memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(set_col_tbl) */ ordered_outer_view.low_ndv_int, set_col_tbl.s from ordered_outer_view inner join set_col_tbl on ordered_outer_view.low_ndv_int = set_col_tbl.id limit 50;
show trace;

evaluate 'SET(INT) real projection, order by uniq_int limit 5 - expect: memoize enabled (element-typed collection is not excluded, memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(set_col_tbl) */ outer_tbl.low_ndv_int, set_col_tbl.s from outer_tbl inner join set_col_tbl on outer_tbl.low_ndv_int = set_col_tbl.id order by outer_tbl.uniq_int limit 5;
show trace;

evaluate 'SET(INT) real projection, no limit (full scan) - expect: memoize enabled, value-fidelity baseline (memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(set_col_tbl) */ outer_tbl.low_ndv_int, set_col_tbl.s from outer_tbl inner join set_col_tbl on outer_tbl.low_ndv_int = set_col_tbl.id;
show trace;

-- ===== SEQUENCE(INT), 64M =====
evaluate 'SEQUENCE(INT) real projection, limit 5 only - no assertion on memoize state, output correctness only (memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(sequence_col_tbl) */ ordered_outer_view.low_ndv_int, sequence_col_tbl.sq from ordered_outer_view inner join sequence_col_tbl on ordered_outer_view.low_ndv_int = sequence_col_tbl.id limit 5;
show trace;

evaluate 'SEQUENCE(INT) real projection, limit 50 - expect: partial MEMOIZE trace may appear (memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(sequence_col_tbl) */ ordered_outer_view.low_ndv_int, sequence_col_tbl.sq from ordered_outer_view inner join sequence_col_tbl on ordered_outer_view.low_ndv_int = sequence_col_tbl.id limit 50;
show trace;

evaluate 'SEQUENCE(INT) real projection, order by uniq_int limit 5 - expect: memoize enabled (element-typed collection is not excluded, memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(sequence_col_tbl) */ outer_tbl.low_ndv_int, sequence_col_tbl.sq from outer_tbl inner join sequence_col_tbl on outer_tbl.low_ndv_int = sequence_col_tbl.id order by outer_tbl.uniq_int limit 5;
show trace;

evaluate 'SEQUENCE(INT) real projection, no limit (full scan) - expect: memoize enabled, value-fidelity baseline (memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(sequence_col_tbl) */ outer_tbl.low_ndv_int, sequence_col_tbl.sq from outer_tbl inner join sequence_col_tbl on outer_tbl.low_ndv_int = sequence_col_tbl.id;
show trace;

set system parameters 'memoize_memory_limit=0';

-- ===== MULTISET(INT), 0 =====
evaluate 'MULTISET(INT) real projection, limit 5 only - expect: no memoize (disabled), row output must match the 64M run above exactly';
select /*+ recompile parallel(0) ordered use_nl(multiset_col_tbl) */ ordered_outer_view.low_ndv_int, multiset_col_tbl.ms from ordered_outer_view inner join multiset_col_tbl on ordered_outer_view.low_ndv_int = multiset_col_tbl.id limit 5;
show trace;

evaluate 'MULTISET(INT) real projection, limit 50 - expect: no memoize (disabled), row output must match the 64M run above exactly';
select /*+ recompile parallel(0) ordered use_nl(multiset_col_tbl) */ ordered_outer_view.low_ndv_int, multiset_col_tbl.ms from ordered_outer_view inner join multiset_col_tbl on ordered_outer_view.low_ndv_int = multiset_col_tbl.id limit 50;
show trace;

evaluate 'MULTISET(INT) real projection, order by uniq_int limit 5 - expect: no memoize (disabled), row output must match the 64M run above exactly';
select /*+ recompile parallel(0) ordered use_nl(multiset_col_tbl) */ outer_tbl.low_ndv_int, multiset_col_tbl.ms from outer_tbl inner join multiset_col_tbl on outer_tbl.low_ndv_int = multiset_col_tbl.id order by outer_tbl.uniq_int limit 5;
show trace;

evaluate 'MULTISET(INT) real projection, no limit (full scan) - expect: no memoize (disabled), value-fidelity comparison against the 64M run above';
select /*+ recompile parallel(0) ordered use_nl(multiset_col_tbl) */ outer_tbl.low_ndv_int, multiset_col_tbl.ms from outer_tbl inner join multiset_col_tbl on outer_tbl.low_ndv_int = multiset_col_tbl.id;
show trace;

-- ===== SET(INT), 0 =====
evaluate 'SET(INT) real projection, limit 5 only - expect: no memoize (disabled), row output must match the 64M run above exactly';
select /*+ recompile parallel(0) ordered use_nl(set_col_tbl) */ ordered_outer_view.low_ndv_int, set_col_tbl.s from ordered_outer_view inner join set_col_tbl on ordered_outer_view.low_ndv_int = set_col_tbl.id limit 5;
show trace;

evaluate 'SET(INT) real projection, limit 50 - expect: no memoize (disabled), row output must match the 64M run above exactly';
select /*+ recompile parallel(0) ordered use_nl(set_col_tbl) */ ordered_outer_view.low_ndv_int, set_col_tbl.s from ordered_outer_view inner join set_col_tbl on ordered_outer_view.low_ndv_int = set_col_tbl.id limit 50;
show trace;

evaluate 'SET(INT) real projection, order by uniq_int limit 5 - expect: no memoize (disabled), row output must match the 64M run above exactly';
select /*+ recompile parallel(0) ordered use_nl(set_col_tbl) */ outer_tbl.low_ndv_int, set_col_tbl.s from outer_tbl inner join set_col_tbl on outer_tbl.low_ndv_int = set_col_tbl.id order by outer_tbl.uniq_int limit 5;
show trace;

evaluate 'SET(INT) real projection, no limit (full scan) - expect: no memoize (disabled), value-fidelity comparison against the 64M run above';
select /*+ recompile parallel(0) ordered use_nl(set_col_tbl) */ outer_tbl.low_ndv_int, set_col_tbl.s from outer_tbl inner join set_col_tbl on outer_tbl.low_ndv_int = set_col_tbl.id;
show trace;

-- ===== SEQUENCE(INT), 0 =====
evaluate 'SEQUENCE(INT) real projection, limit 5 only - expect: no memoize (disabled), row output must match the 64M run above exactly';
select /*+ recompile parallel(0) ordered use_nl(sequence_col_tbl) */ ordered_outer_view.low_ndv_int, sequence_col_tbl.sq from ordered_outer_view inner join sequence_col_tbl on ordered_outer_view.low_ndv_int = sequence_col_tbl.id limit 5;
show trace;

evaluate 'SEQUENCE(INT) real projection, limit 50 - expect: no memoize (disabled), row output must match the 64M run above exactly';
select /*+ recompile parallel(0) ordered use_nl(sequence_col_tbl) */ ordered_outer_view.low_ndv_int, sequence_col_tbl.sq from ordered_outer_view inner join sequence_col_tbl on ordered_outer_view.low_ndv_int = sequence_col_tbl.id limit 50;
show trace;

drop view ordered_outer_view;

evaluate 'SEQUENCE(INT) real projection, order by uniq_int limit 5 - expect: no memoize (disabled), row output must match the 64M run above exactly';
select /*+ recompile parallel(0) ordered use_nl(sequence_col_tbl) */ outer_tbl.low_ndv_int, sequence_col_tbl.sq from outer_tbl inner join sequence_col_tbl on outer_tbl.low_ndv_int = sequence_col_tbl.id order by outer_tbl.uniq_int limit 5;
show trace;

evaluate 'SEQUENCE(INT) real projection, no limit (full scan) - expect: no memoize (disabled), value-fidelity comparison against the 64M run above';
select /*+ recompile parallel(0) ordered use_nl(sequence_col_tbl) */ outer_tbl.low_ndv_int, sequence_col_tbl.sq from outer_tbl inner join sequence_col_tbl on outer_tbl.low_ndv_int = sequence_col_tbl.id;
show trace;

set system parameters 'memoize_memory_limit=64M';

-- untyped SET (no declared element type) - the one shape that IS actually
-- excluded. Kept next to the element-typed positive cases above so a future
-- regression that disables memoize globally can't hide behind this
-- negative-only case.
evaluate 'untyped SET real projection, order by uniq_int limit 5 - expect: no memoize (only this untyped shape is actually excluded, memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(untyped_tbl) */ outer_tbl.low_ndv_int, untyped_tbl.s from outer_tbl inner join untyped_tbl on outer_tbl.low_ndv_int = untyped_tbl.id order by outer_tbl.uniq_int limit 5;
show trace;

set system parameters 'memoize_memory_limit=0';

evaluate 'untyped SET real projection, order by uniq_int limit 5 - expect: no memoize (disabled), row output and scan volume must match the 64M run above exactly';
select /*+ recompile parallel(0) ordered use_nl(untyped_tbl) */ outer_tbl.low_ndv_int, untyped_tbl.s from outer_tbl inner join untyped_tbl on outer_tbl.low_ndv_int = untyped_tbl.id order by outer_tbl.uniq_int limit 5;
show trace;

set system parameters 'memoize_memory_limit=64M';

-- hit=0 dedicated case: unique_outer's 5 keys never repeat, so every probe is
-- a first-time miss and no MEMOIZE trace can appear regardless of column type
-- - this is evidence of hit=0, not of type-based exclusion.
evaluate 'MULTISET(INT) real projection against unique (non-repeating) keys - expect: no memoize (hit=0, not a type exclusion, memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(multiset_col_tbl) */ unique_outer.id, multiset_col_tbl.ms from unique_outer inner join multiset_col_tbl on unique_outer.id = multiset_col_tbl.id order by unique_outer.id;
show trace;

evaluate 'memoize with index scan on inner table - expect: memoize enabled';
create index idx_inner_tbl_key on inner_tbl (join_key);
update statistics on inner_tbl with fullscan;
select /*+ recompile parallel(0) ordered use_nl(inner_tbl) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.low_ndv_int = inner_tbl.join_key;
show trace;
drop index idx_inner_tbl_key on inner_tbl;

evaluate 'multi-row-per-key cache path: row-level output, memoize enabled (memoize_memory_limit=64M)';
select /*+ recompile parallel(0) ordered use_nl(inner_dup) */ outer_tbl.low_ndv_int, inner_dup.payload, count(*) from outer_tbl inner join inner_dup on outer_tbl.low_ndv_int = inner_dup.join_key group by outer_tbl.low_ndv_int, inner_dup.payload order by outer_tbl.low_ndv_int, inner_dup.payload;
show trace;
select /*+ recompile parallel(0) ordered use_nl(inner_dup) */ outer_tbl.low_ndv_int, count(inner_dup.payload) from outer_tbl left outer join inner_dup on outer_tbl.low_ndv_int = inner_dup.join_key and inner_dup.payload <> 'b' group by outer_tbl.low_ndv_int order by outer_tbl.low_ndv_int;
show trace;

set system parameters 'memoize_memory_limit=0';
evaluate 'multi-row-per-key cache path: same queries, memoize disabled (memoize_memory_limit=0) - row-level output must match the enabled run above exactly';
select /*+ recompile parallel(0) ordered use_nl(inner_dup) */ outer_tbl.low_ndv_int, inner_dup.payload, count(*) from outer_tbl inner join inner_dup on outer_tbl.low_ndv_int = inner_dup.join_key group by outer_tbl.low_ndv_int, inner_dup.payload order by outer_tbl.low_ndv_int, inner_dup.payload;
select /*+ recompile parallel(0) ordered use_nl(inner_dup) */ outer_tbl.low_ndv_int, count(inner_dup.payload) from outer_tbl left outer join inner_dup on outer_tbl.low_ndv_int = inner_dup.join_key and inner_dup.payload <> 'b' group by outer_tbl.low_ndv_int order by outer_tbl.low_ndv_int;

set trace off;
set system parameters 'memoize_memory_limit=default';

-- cleanup
drop view if exists low_ndv_view;
drop table if exists inner_dup;
drop table if exists unique_outer;
drop table if exists untyped_tbl;
drop table if exists sequence_col_tbl;
drop table if exists multiset_col_tbl;
drop table if exists set_col_tbl;
drop table if exists extra_join_tbl;
drop table if exists outer_tbl;
drop table if exists inner_tbl;

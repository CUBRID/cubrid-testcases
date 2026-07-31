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
  lpad(to_char(rownum % 1000), 20, '0'),
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

select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.uniq_int = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.low_ndv_int = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.mid_ndv_int = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.mid_ndv_varchar = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.high_ndv_numeric = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.uniq_varchar = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.half_ndv_varchar = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.third_ndv_varchar = inner_tbl.join_key;
show trace;

evaluate 'memoize disabled (memoize_memory_limit=0)';

set system parameters 'memoize_memory_limit=0';

select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.uniq_int = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.low_ndv_int = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.mid_ndv_int = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.mid_ndv_varchar = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.high_ndv_numeric = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.uniq_varchar = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.half_ndv_varchar = inner_tbl.join_key;
show trace;
select /*+ recompile parallel(0) */ count(*) from outer_tbl inner join inner_tbl on outer_tbl.third_ndv_varchar = inner_tbl.join_key;
show trace;

set trace off;
set system parameters 'memoize_memory_limit=default';

-- cleanup
drop table if exists outer_tbl;
drop table if exists inner_tbl;

-- CBRD-26345: Implement memoize
--
-- For NLJ with repeated join keys on the inner table,
-- caches inner scan results keyed by join column value.
-- Verify memoize activation behavior with various column types
-- (different NDV ratios) under enabled/disabled memory limit settings.

-- cleanup
drop table if exists m1;
drop table if exists m2;

create table m1 (col1 int, col2 int, col3 int, col4 varchar(20), col5 numeric(20,10), col6 varchar(20), col7 varchar(20), col8 varchar(20));
insert into m1 select
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

create table m2 (col1 int);
insert into m2 select rownum from db_class a, db_class b, db_class c, db_class d, db_class e, db_class f, db_class g limit 10;
update statistics on m1, m2 with fullscan;

evaluate 'memoize enabled (memoize_memory_limit=64M)';

set trace on;
set system parameters 'memoize_memory_limit=64M';

select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col1 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col2 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col3 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col4 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col5 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col6 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col7 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col8 = m2.col1;
show trace;

evaluate 'memoize disabled (memoize_memory_limit=0)';

set system parameters 'memoize_memory_limit=0';

select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col1 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col2 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col3 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col4 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col5 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col6 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col7 = m2.col1;
show trace;
select /*+ recompile parallel(0) */ count(*) from m1 inner join m2 on m1.col8 = m2.col1;
show trace;

set trace off;
set system parameters 'memoize_memory_limit=default';

-- cleanup
drop table if exists m1;
drop table if exists m2;

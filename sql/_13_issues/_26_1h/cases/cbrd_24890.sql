/**
 *  This test case verifies CBRD-24890: min(), max() functions not being optimized for index scans in specific cases.
 *  This test case verifies that min()/max() are executed via index scan instead of full aggregate processing.
 */

drop table if exists t2;

create table t2 (
  col1 int,
  col2 int,
  col3 varchar(100)
);

insert into t2
select
  mod(rownum - 1, 20) + 1 as col1,
  (rownum - 1) * 10 + 100 as col2,
  concat('v', rownum)
from db_class a, db_class b
where rownum <= 500;

-- Index combinations
create index idx_col1_col2_asc_asc on t2(col1 asc, col2 asc);
create index idx_col1_col2_asc_desc on t2(col1 asc, col2 desc);
create index idx_col1_col2_desc_asc on t2(col1 desc, col2 asc);
create index idx_col1_col2_desc_desc on t2(col1 desc, col2 desc);
set trace on;

-- ============================================================================
-- Optimizable MIN/MAX queries (with partkey descending)
-- ============================================================================

evaluate 'Case 1';
select /*+ recompile */ min(col2), max(col2) from t2 FORCE INDEX (idx_col1_col2_desc_asc) where col1 = 1;
show trace;

evaluate 'Case 2';
select /*+ recompile */ max(col2), min(col2) from t2 FORCE INDEX (idx_col1_col2_asc_asc) where col1 = 1;
show trace;

evaluate 'Case 3';
select /*+ recompile */ min(col2), max(col2) from t2 FORCE INDEX (idx_col1_col2_desc_desc) where col1 = 1;
show trace;

evaluate 'Case 4';
select /*+ recompile */ max(col2), min(col2) from t2 FORCE INDEX (idx_col1_col2_desc_asc) where col1 = 1;
show trace;

-- ============================================================================
-- Range filter cases
-- ============================================================================

evaluate 'Case 5';
select /*+ recompile */ min(col2) from t2 where col1 = 1 and col2 > 200;
show trace;

evaluate 'Case 6';
select /*+ recompile */ max(col2) from t2 where col1 = 1 and col2 < 500;
show trace;

evaluate 'Case 7';
select /*+ recompile */ min(col2), max(col2) from t2 FORCE INDEX (idx_col1_col2_desc_asc) where col1 = 1;
show trace;

-- ============================================================================
-- Not optimizable: (unordered, not pure)
-- ============================================================================

evaluate 'Case 8';
select /*+ recompile index(t2 idx_col1_col2_asc_asc) */ min(col2) from t2 where col1 > 1;
show trace;

evaluate 'Case 9';
select /*+ recompile */ min(col2), max(-col2) from t2 FORCE INDEX (idx_col1_col2_desc_asc) where col1 = 1;
show trace;

-- ============================================================================
-- optimizable: filtering on non-indexed column (orderby: skip)
-- ============================================================================

evaluate 'Case 10';
select /*+ recompile */ min(col2) from t2 where col3 like 'v1%';
show trace;

-- ============================================================================
-- Not optimizable: no col1 condition
-- ============================================================================

evaluate 'Case 11';
select /*+ recompile */ min(col2) from t2;
show trace;

-- ============================================================================
-- Additional checks with alternate indexes
-- ============================================================================

evaluate 'Case 12';
select /*+ recompile */ (select min(col2) from t2 where col1 = a.col1) from t2 a limit 1;
show trace;

evaluate 'Case 13';
select /*+ recompile */(select max(col2) from t2 where col1 = a.col1) from t2 a limit 1;
show trace;

evaluate 'Case 14';
select /*+ recompile */(select min(col2) from t2 where col1 = a.col1 and col3 like 'v1%') from t2 a limit 1;
show trace;

set trace off;

drop table if exists t2_part;

create table t2_part (
  col1 int,
  col2 int,
  col3 varchar(100)
)
partition by range (col1) (
  partition p1 values less than (6),
  partition p2 values less than (11),
  partition p3 values less than (16),
  partition p4 values less than (21)
);

insert into t2_part
select
  mod(rownum - 1, 20) + 1 as col1,
  (rownum - 1) * 10 + 100 as col2,
  concat('v', rownum)
from db_class a, db_class b
where rownum <= 500;
create index idx_part_col1_col2_asc on t2_part(col1 asc, col2 asc);
create index idx_part_col1_col2_desc on t2_part(col1 desc, col2 desc);
set trace on;

-- ============================================================================
-- Not optimizable: partition
-- ============================================================================

evaluate 'Case 15';
select /*+ recompile */ min(col2), max(col2) from t2_part where col1 = 1;
show trace;

set trace off;
drop table t2;
drop table t2_part;
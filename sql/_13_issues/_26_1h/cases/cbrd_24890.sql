/**
 *  This test case verifies CBRD-24890: min(), max() functions not being optimized for index scans in specific cases.
 *  This test case verifies that min()/max() are executed via index scan instead of full aggregate processing.
 */

drop table if exists tbl;

create table tbl (
  cola int,
  colb int,
  colc varchar(100)
);

insert into tbl
select
  mod(rownum - 1, 20) + 1 as cola,
  (rownum - 1) * 10 + 100 as colb,
  concat('v', rownum)
from db_class a, db_class b
where rownum <= 500;

-- Index combinations
create index idx_cola_colb_asc_asc on tbl(cola asc, colb asc);
create index idx_cola_colb_asc_desc on tbl(cola asc, colb desc);
create index idx_cola_colb_desc_asc on tbl(cola desc, colb asc);
create index idx_cola_colb_desc_desc on tbl(cola desc, colb desc);
set trace on;

-- ============================================================================
-- Optimizable MIN/MAX queries (with partkey descending)
-- ============================================================================

evaluate 'Case 1';
select /*+ recompile */ min(colb), max(colb) from tbl FORCE INDEX (idx_cola_colb_desc_asc) where cola = 1;
show trace;

evaluate 'Case 2';
select /*+ recompile */ max(colb), min(colb) from tbl FORCE INDEX (idx_cola_colb_asc_asc) where cola = 1;
show trace;

evaluate 'Case 3';
select /*+ recompile */ min(colb), max(colb) from tbl FORCE INDEX (idx_cola_colb_desc_desc) where cola = 1;
show trace;

evaluate 'Case 4';
select /*+ recompile */ max(colb), min(colb) from tbl FORCE INDEX (idx_cola_colb_desc_asc) where cola = 1;
show trace;

-- ============================================================================
-- Range filter cases
-- ============================================================================

evaluate 'Case 5';
select /*+ recompile */ min(colb) from tbl where cola = 1 and colb > 200;
show trace;

evaluate 'Case 6';
select /*+ recompile */ max(colb) from tbl where cola = 1 and colb < 500;
show trace;

evaluate 'Case 7';
select /*+ recompile */ min(colb), max(colb) from tbl FORCE INDEX (idx_cola_colb_asc_desc) where cola = 1;
show trace;

-- ============================================================================
-- Not optimizable: (unordered, not pure)
-- ============================================================================

evaluate 'Case 8';
select /*+ recompile index(tbl idx_cola_colb_asc_asc) */ min(colb) from tbl where cola > 1;
show trace;

evaluate 'Case 9';
select /*+ recompile */ min(colb), max(-colb) from tbl FORCE INDEX (idx_cola_colb_desc_asc) where cola = 1;
show trace;

-- ============================================================================
-- optimizable: filtering on non-indexed column (orderby: skip)
-- ============================================================================

evaluate 'Case 10';
select /*+ recompile */ min(colb) from tbl where colc like 'v1%';
show trace;

-- ============================================================================
-- Not optimizable: no cola condition
-- ============================================================================

evaluate 'Case 11';
select /*+ recompile */ min(colb) from tbl;
show trace;

-- ============================================================================
-- Additional checks with alternate indexes
-- ============================================================================

evaluate 'Case 12';
select /*+ recompile */ (select min(colb) from tbl where cola = a.cola) from tbl a limit 1;
show trace;

evaluate 'Case 13';
select /*+ recompile */(select max(colb) from tbl where cola = a.cola) from tbl a limit 1;
show trace;

evaluate 'Case 14';
select /*+ recompile */(select min(colb) from tbl where cola = a.cola and colc like 'v1%') from tbl a limit 1;
show trace;

set trace off;

drop table if exists tbl_part;

create table tbl_part (
  cola int,
  colb int,
  colc varchar(100)
)
partition by range (cola) (
  partition pa values less than (6),
  partition pb values less than (11),
  partition pc values less than (16),
  partition pd values less than (21)
);

insert into tbl_part
select
  mod(rownum - 1, 20) + 1 as cola,
  (rownum - 1) * 10 + 100 as colb,
  concat('v', rownum)
from db_class a, db_class b
where rownum <= 500;
create index idx_part_cola_colb_asc on tbl_part(cola asc, colb asc);
create index idx_part_cola_colb_desc on tbl_part(cola desc, colb desc);
set trace on;

-- ============================================================================
-- Not optimizable: partition
-- ============================================================================

evaluate 'Case 15';
select /*+ recompile */ min(colb), max(colb) from tbl_part where cola = 1;
show trace;

set trace off;
drop table tbl;
drop table tbl_part;

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

evaluate 'Case 1: MIN/MAX optimized using cola DESC, colb ASC index';
select /*+ recompile */ min(colb), max(colb)
  from tbl FORCE INDEX (idx_cola_colb_desc_asc)
 where cola = 1;
show trace;

evaluate 'Case 2: MAX/MIN optimized using cola ASC, colb ASC index';
select /*+ recompile */ max(colb), min(colb)
  from tbl FORCE INDEX (idx_cola_colb_asc_asc)
 where cola = 1;
show trace;

evaluate 'Case 3: MIN/MAX optimized using cola DESC, colb DESC index';
select /*+ recompile */ min(colb), max(colb)
  from tbl FORCE INDEX (idx_cola_colb_desc_desc)
 where cola = 1;
show trace;

evaluate 'Case 4: MAX/MIN optimized using cola DESC, colb ASC index';
select /*+ recompile */ max(colb), min(colb)
  from tbl FORCE INDEX (idx_cola_colb_desc_asc)
 where cola = 1;
show trace;

-- ============================================================================
-- Range filter cases
-- ============================================================================

evaluate 'Case 5: MIN optimized with range condition on colb';
select /*+ recompile */ min(colb)
  from tbl
 where cola = 1
   and colb > 200;
show trace;

evaluate 'Case 6: MAX optimized with range condition on colb';
select /*+ recompile */ max(colb)
  from tbl
 where cola = 1
   and colb < 500;
show trace;

evaluate 'Case 7: MIN/MAX optimized using cola ASC, colb DESC index';
select /*+ recompile */ min(colb), max(colb)
  from tbl FORCE INDEX (idx_cola_colb_asc_desc)
 where cola = 1;
show trace;

-- ============================================================================
-- Not optimizable: (unordered, not pure)
-- ============================================================================

evaluate 'Case 8: not optimized with range condition on cola';
select /*+ recompile index(tbl idx_cola_colb_asc_asc) */ min(colb)
  from tbl
 where cola > 1;
show trace;

evaluate 'Case 9: not optimized with expression on colb';
select /*+ recompile */ min(colb), max(-colb)
  from tbl FORCE INDEX (idx_cola_colb_desc_asc)
 where cola = 1;
show trace;

-- ============================================================================
-- Not optimizable: no cola condition
-- ============================================================================

evaluate 'Case 10: not optimized without cola condition';
select /*+ recompile */ min(colb)
  from tbl;
show trace;

-- ============================================================================
-- Additional checks with alternate indexes
-- ============================================================================

evaluate 'Case 11: MIN optimized in correlated subquery';
select /*+ recompile */
       (select min(colb)
          from tbl
         where cola = a.cola)
  from tbl a
 order by a.cola, a.colb
 limit 1;
show trace;

evaluate 'Case 12: MAX optimized in correlated subquery';
select /*+ recompile */
       (select max(colb)
          from tbl
         where cola = a.cola)
  from tbl a
 order by a.cola, a.colb
 limit 1;
show trace;

evaluate 'Case 13: MIN optimized in correlated subquery with filter';
select /*+ recompile */
       (select min(colb)
          from tbl
         where cola = a.cola
           and colc like 'v1%')
  from tbl a
 order by a.cola, a.colb
 limit 1;
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

evaluate 'Case 14: not optimized with partitioned table';
select /*+ recompile */ min(colb), max(colb)
  from tbl_part
 where cola = 1;
show trace;

-- ============================================================================
-- Not optimizable: MIN/MAX mixed with other aggregate operations
-- ============================================================================

evaluate 'Case 15: not optimized when MIN is mixed with SUM';
select /*+ recompile */ min(colb), sum(colb)
  from tbl FORCE INDEX (idx_cola_colb_asc_asc)
 where cola = 1;
show trace;

-- ============================================================================
-- Not optimizable: GROUP BY and HAVING cases
-- ============================================================================

evaluate 'Case 16: not optimized with GROUP BY';
select /*+ recompile */ cola, min(colb)
  from tbl FORCE INDEX (idx_cola_colb_asc_asc)
 where cola in (1, 2)
 group by cola
 order by cola;
show trace;

evaluate 'Case 17: not optimized with HAVING';
select /*+ recompile */ min(colb)
  from tbl FORCE INDEX (idx_cola_colb_asc_asc)
 where cola = 1
having min(colb) > 0;
show trace;

-- ============================================================================
-- Optimizable MIN/MAX queries with NULL results and NULL values
-- ============================================================================

evaluate 'Case 18: optimized MIN/MAX returns NULL for no matching key';
select /*+ recompile */ min(colb), max(colb)
  from tbl FORCE INDEX (idx_cola_colb_asc_asc)
 where cola = 999;
show trace;

-- NULL handling: add rows while trace output is already expected in this section.
insert into tbl values (30, null, 'null_only_1');
insert into tbl values (30, null, 'null_only_2');
insert into tbl values (31, null, 'mix_null_1');
insert into tbl values (31, -5, 'mix_val');
insert into tbl values (31, null, 'mix_null_2');

evaluate 'Case 19: optimized MIN/MAX ignores NULL values when non-NULL value exists';
select /*+ recompile */ min(colb), max(colb)
  from tbl FORCE INDEX (idx_cola_colb_asc_asc)
 where cola = 31;
show trace;

evaluate 'Case 20: optimized MIN/MAX returns NULL when all target values are NULL';
select /*+ recompile */ min(colb), max(colb)
  from tbl FORCE INDEX (idx_cola_colb_asc_asc)
 where cola = 30;
show trace;

set trace off;
drop table tbl;
drop table tbl_part;

-- Verification for CBRD-26258 : Improve to allow Skip ORDER BY even for joins without index scan predicates

drop table if exists tbl_a, tbl_b;
set trace on;
create table tbl_a (cola int not null, colb int not null, colc int not null, cold int not null);
create index i1_cola_colb_colc on tbl_a (cola, colb, colc);

create table tbl_b (cole int not null, colf int not null);
create index i1_cole on tbl_b (cole);

insert into tbl_a
with recursive cte (n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
select * from (
    select rownum as cola, rownum as colb, rownum as colc, rownum as cold
    from cte
    limit 200
  )
order by cola desc;

insert into tbl_b
with recursive cte (n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
select * from (
    select ceil (rownum / 10) as cole, rownum as colf
    from cte
    limit 2000
  )
order by cole desc, colf desc;

update statistics on tbl_a, tbl_b with fullscan;

evaluate 'Q201. When an inst_num() condition is used and orderby_num() is referenced in the SELECT list, skip ORDER BY cannot be applied.';
select /*+ recompile ordered no_parallel_scan */
  'Q201', inst_num(), orderby_num(), a.*, b.*
from tbl_a a, tbl_b b
where a.cola = b.cole and inst_num() > 100 and inst_num() <= 110 using index i1_cola_colb_colc(+)
order by a.cola, a.colb;
show trace;

evaluate 'Q202. When inst_num is not used in WHERE clause but used together with orderby_num, skip ORDER BY can be applied.';
select /*+ recompile ordered no_parallel_scan */
  'Q202', inst_num(), orderby_num(), a.*, b.*
from tbl_a a, tbl_b b
where a.cola = b.cole using index i1_cola_colb_colc(+)
order by a.cola, a.colb
limit 110, 10;
show trace;

evaluate 'Q203. When both inst_num condition and for orderby_num are used, skip ORDER BY cannot be applied.';
select /*+ recompile ordered no_parallel_scan */
  'Q203', inst_num(), orderby_num(), a.*, b.*
from tbl_a a, tbl_b b
where a.cola = b.cole and inst_num() > 110 and inst_num() <= 120 using index i1_cola_colb_colc(+)
order by a.cola, a.colb for orderby_num () <= 10;
show trace;

evaluate 'Q204. When only inst_num condition is used, skip ORDER BY can be applied.';
select /*+ recompile ordered no_parallel_scan */
  'Q204', inst_num(), a.*, b.*
from tbl_a a, tbl_b b
where a.cola = b.cole and inst_num() > 130 and inst_num() <= 140 using index i1_cola_colb_colc(+)
order by a.cola, a.colb;
show trace;

evaluate 'Q205. When only orderby_num() filter is used (no inst_num, no LIMIT), skip ORDER BY can be applied.';
select /*+ recompile ordered no_parallel_scan */
  'Q205', inst_num(), orderby_num(), a.*, b.*
from tbl_a a, tbl_b b
where a.cola = b.cole using index i1_cola_colb_colc(+)
order by a.cola, a.colb
for orderby_num() > 10 and orderby_num() <= 20;
show trace;

evaluate 'Q206. When inst_num() is used only in the SELECT list, skip ORDER BY should behave the same as without inst_num().';
select /*+ recompile ordered no_parallel_scan */
  'Q206', inst_num(), a.*, b.*
from tbl_a a, tbl_b b
where a.cola = b.cole using index i1_cola_colb_colc(+)
order by a.cola, a.colb
limit 10, 10;
show trace;

set trace off;
drop table if exists tbl_a, tbl_b;


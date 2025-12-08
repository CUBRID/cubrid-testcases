-- Verification for CBRD-26263
-- Test for LEFT OUTER JOIN with view
-- The existing table-elimination optimization did not work
-- when the right-hand side was a view with distributed join conditions.
-- This test checks that the issue is fixed.

drop table if exists tbl;
create table tbl(cola int, colb int, CONSTRAINT [pk] PRIMARY KEY  (cola,colb));
insert into tbl values (1, 10), (1, 20), (2, 10), (2, 30), (3, 30), (3, 40);

-- When using LEFT OUTER JOIN
evaluate 'Case 1';
select count(*) from tbl a left outer join tbl b on b.cola = 1 and a.colb = b.colb;
evaluate 'Case 2';
select a.* from tbl a left outer join tbl b on b.cola = 1 and a.colb = b.colb order by a.cola;

-- When using LEFT OUTER JOIN with an inline view
evaluate 'Case 3';
select count(*) from tbl a left outer join (select cola, colb from tbl where cola = 1) b on a.colb = b.colb;
evaluate 'Case 4';
select a.* from tbl a left outer join (select cola, colb from tbl where cola = 1) b on a.colb = b.colb order by a.cola;

-- When using a view
create or replace view v as select cola, colb from tbl where cola = 1;
evaluate 'Case 5';
select count(*) from tbl a left outer join v b on a.colb = b.colb;
evaluate 'Case 6';
select a.* from tbl a left outer join v b on a.colb = b.colb order by a.cola;

-- Additional Test Cases
evaluate 'Case 7: right side is non-unique on join key -> elimination not allowed';
select /*+ recompile */ count(*) 
from tbl a
left outer join tbl b
on a.colb = b.colb;

evaluate 'Case 8: unique join but right-side columns used in SELECT -> elimination not allowed';
select /*+ recompile */
a.cola,
a.colb,
b.cola as b_cola,
b.colb as b_colb
from tbl a
left outer join tbl b
on b.cola = 1
and a.colb = b.colb;

evaluate 'Case 9: unique join but WHERE uses right-side column -> elimination not allowed';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on b.cola = 1
and a.colb = b.colb
where b.cola is null;

evaluate 'Case 10: uniqueness inside inner subquery (distributed) -> elimination allowed';
select /*+ recompile */ count(*)
from tbl a
left outer join (
  select cola, colb
  from (
    select cola, colb
    from tbl
    where cola = 1
  ) x
) b
on a.colb = b.colb;

evaluate 'Case 11: subquery with GROUP BY, uniqueness not trivially inferred -> elimination not allowed';
select /*+ recompile */ count(*)
from tbl a
left outer join (
  select cola,
         min(colb) as colb
  from tbl
  group by cola
) b
on a.cola = b.cola;

evaluate 'Case 12: subquery with DISTINCT, uniqueness due to DISTINCT not reliable -> elimination not allowed';
select /*+ recompile */ count(*)
from tbl a
left outer join (
  select distinct cola, colb
  from tbl
  where cola = 1
) b
on a.colb = b.colb;

evaluate 'Case 13: subquery with ORDER BY only, order does not affect uniqueness -> elimination allowed';
select /*+ recompile */ count(*)
from tbl a
left outer join (
  select cola, colb
  from tbl
  where cola = 1
  order by colb
) b
on a.colb = b.colb;

evaluate 'Case 14: simple selection-only view, join on full PK -> elimination allowed';
create or replace view v_simple as
select cola, colb
from tbl
where cola = 1;

select /*+ recompile */ count(*)
from tbl a
left outer join v_simple b
on a.cola = b.cola
and a.colb = b.colb;

evaluate 'Case 15: multi-table view (self join) -> uniqueness inference difficult, elimination not allowed';
create or replace view v_multi as
select a.cola,
       a.colb,
       b.cola as cola2,
       b.colb as colb2
from tbl a
join tbl b
on a.colb = b.colb;

select /*+ recompile */ count(*)
from tbl a
left outer join v_multi b
on a.colb = b.colb;

evaluate 'Case 16: view projects only part of PK (colb) -> elimination allowed';
create or replace view v_partial_pk as
select colb
from tbl
where cola = 1;

select /*+ recompile */ count(*)
from tbl a
left outer join v_partial_pk b
on a.colb = b.colb;

evaluate 'Case 17: partial condition inside view (cola=1) + outer join condition -> elimination allowed';
create or replace view v_cond as
select cola, colb
from tbl
where cola = 1;

select /*+ recompile */ count(*)
from tbl a
left outer join v_cond b
on a.colb = b.colb;

evaluate 'Case 18: join key wrapped by function (CAST) -> elimination not allowed';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on cast(a.colb as varchar(10)) = cast(b.colb as varchar(10))
and b.cola = 1;

evaluate 'Case 19: HAVING uses right-side column (aggregate) -> elimination not allowed';
select /*+ recompile */
a.cola,
count(*) as cnt
from tbl a
left outer join tbl b
on b.cola = 1
and a.colb = b.colb
group by a.cola
having max(b.cola) is not null;

evaluate 'Case 20: RIGHT OUTER JOIN, check elimination on left-side uniqueness -> elimination not allowed';
select /*+ recompile */ count(*)
from tbl a
right outer join tbl b
on a.cola = b.cola
and a.colb = b.colb
and a.cola = 1;

evaluate 'Case 21: WHERE applies NOT NULL on right-side column -> elimination not allowed';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on b.cola = 1
and a.colb = b.colb
where b.cola is not null;

drop table if exists tbl;

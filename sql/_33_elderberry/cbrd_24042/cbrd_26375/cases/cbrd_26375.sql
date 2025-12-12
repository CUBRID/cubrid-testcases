-- Verification for CBRD-26375 : LEFT OUTER JOIN view merge restriction

drop table if exists tbl;
create table tbl (cola int,colb int);
insert into tbl
select rownum, rownum
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 10000;

evaluate 'Case 1: LEFT OUTER JOIN with constant column (inline view vs view)';
create or replace view v_tbl as
select 1 cola from tbl;

evaluate '1-1. inline view';
select /*+ recompile use_hash */ count(*)
from tbl a, (select 1 cola from tbl) b
where a.cola = b.cola(+);

evaluate '1-2. view';
select /*+ recompile use_hash */ count(*)
from tbl a, v_tbl b
where a.cola = b.cola(+);

evaluate 'Case 2: LEFT OUTER JOIN where view returns a normal column (inline view vs view)';
-- join key is not a constant; view merge should still be allowed
acreate or replace view v_tbl as
select cola from tbl;

evaluate '2-1. inline view';
select /*+ recompile use_hash */ count(*)
from tbl a, (select cola from tbl) b
where a.cola = b.cola(+);

evaluate '2-2. view';
select /*+ recompile use_hash */ count(*)
from tbl a, v_tbl b
where a.cola = b.cola(+);

evaluate 'Case 3: constant expression in view select with outer filter (inline view vs view)';
create or replace view v_tbl_const_expr as
select cola * 0 + 1 as cola_expr
from tbl;

evaluate '3-1. inline view';
select /*+ recompile use_hash */ count(*)
from tbl a,
     (select cola * 0 + 1 as cola_expr from tbl) b
where a.cola = b.cola_expr(+)
  and a.cola between 1 and 10;

evaluate '3-2. view';
select /*+ recompile use_hash */ count(*)
from tbl a,
     v_tbl_const_expr b
where a.cola = b.cola_expr(+)
  and a.cola between 1 and 10;

evaluate 'Case 4: grouped view with constant join column (inline view vs view)';
create or replace view v_tbl_group_const as
select 1 as cola, count(*) as cnt
from tbl
group by 1;

evaluate '4-1. inline view';
select /*+ recompile use_hash */ count(*)
from tbl a,
     (select 1 as cola, count(*) as cnt from tbl group by 1) b
where a.cola = b.cola(+);

evaluate '4-2. view';
select /*+ recompile use_hash */ count(*)
from tbl a,
     v_tbl_group_const b
where a.cola = b.cola(+);

evaluate 'Case 5: LEFT OUTER JOIN vs INNER JOIN with the same constant-key view';
create or replace view v_tbl_const_key as
select 1 as cola
from tbl
where cola between 1 and 10;

evaluate '5-1. LEFT OUTER JOIN using the view';
select /*+ recompile use_hash */ count(*)
from tbl a
     left outer join v_tbl_const_key b
       on a.cola = b.cola;

evaluate '5-2. INNER JOIN using the view';
select /*+ recompile use_hash */ count(*)
from tbl a
     inner join v_tbl_const_key b
       on a.cola = b.cola;

drop table if exists tbl;

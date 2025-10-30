/**
 * This test case verifies CBRD-26099.
 * Verify that the issue where join method hints for LEFT OUTER JOIN with empty inline view results are ignored has been resolved.
**/

drop table if exists tbl;
create table tbl (cola int,colb int);
insert into tbl select rownum, rownum from db_class a,db_class b,db_class c,db_class d,db_class e limit 1000000;

evaluate '1. If there is no result of the inline view with the "= NULL" condition';
select /*+ recompile use_hash */ count(*)
 from tbl a, (select * from tbl b where b.colb = NULL) b
 where a.cola = b.cola(+);

select /*+ recompile use_hash */ count(*)
 from tbl a left outer join (select * from tbl b where b.colb = NULL) b
 on a.cola = b.cola;

select /*+ recompile use_merge */ count(*)
 from tbl a, (select * from tbl b where b.colb = NULL) b
 where a.cola = b.cola(+);

select /*+ recompile use_merge */ count(*)
 from tbl a left outer join (select * from tbl b where b.colb = NULL) b
 on a.cola = b.cola;

evaluate '"1=0" condition';
select /*+ recompile use_hash */ count(*)
 from tbl a, (select * from tbl b where 1 = 0) b
 where a.cola = b.cola(+);

select /*+ recompile use_hash */ count(*)
 from tbl a left outer join (select * from tbl b where 1 = 0) b
 on a.cola = b.cola;

select /*+ recompile use_merge */ count(*)
 from tbl a, (select * from tbl b where 1 = 0) b
 where a.cola = b.cola(+);

select /*+ recompile use_merge */ count(*)
 from tbl a left outer join (select * from tbl b where 1 = 0) b
 on a.cola = b.cola;

evaluate '1-1. Create a view and use it instead of an inline view.';
-- ERROR: operand must be logical expression.

create or replace view v_tbl as select * from tbl b where b.colb = NULL;

select /*+ recompile use_hash */ count(*)
 from tbl a, v_tbl b
 where a.cola = b.cola(+);

select /*+ recompile use_hash */ count(*)
 from tbl a left outer join v_tbl b
 on a.cola = b.cola;

select /*+ recompile use_merge */ count(*)
 from tbl a, v_tbl b
 where a.cola = b.cola(+);

select /*+ recompile use_merge */ count(*)
 from tbl a left outer join v_tbl b
 on a.cola = b.cola;

evaluate '"1=0" condition';
create or replace view v_tbl as select * from tbl b where 1 = 0;

select /*+ recompile use_hash */ count(*)
 from tbl a, v_tbl b
 where a.cola = b.cola(+);

select /*+ recompile use_hash */ count(*)
 from tbl a left outer join v_tbl b
 on a.cola = b.cola;

select /*+ recompile use_merge */ count(*)
 from tbl a, v_tbl b
 where a.cola = b.cola(+);

select /*+ recompile use_merge */ count(*)
 from tbl a left outer join v_tbl b
 on a.cola = b.cola;

evaluate '2. If there is a constant equality condition for the join column of the inline view';
select /*+ recompile use_hash */ count(*) 
 from tbl a, (select cola from tbl where cola=1) b 
 where a.cola = b.cola(+);

select /*+ recompile use_hash */ count(*) 
 from tbl a left outer join (select cola from tbl where cola=1) b 
 on a.cola = b.cola;

select /*+ recompile use_merge */ count(*) 
 from tbl a, (select cola from tbl where cola=1) b 
 where a.cola = b.cola(+);

select /*+ recompile use_merge */ count(*) 
 from tbl a left outer join (select cola from tbl where cola=1) b 
 on a.cola = b.cola;

evaluate '2-1. Create a view and use it instead of an inline view.';
create or replace view v_tbl as select * from tbl b where cola=1;

select /*+ recompile use_hash */ count(*)
 from tbl a, v_tbl b
 where a.cola = b.cola(+);

select /*+ recompile use_hash */ count(*)
 from tbl a left outer join v_tbl b
 on a.cola = b.cola;

select /*+ recompile use_merge */ count(*)
 from tbl a, v_tbl b
 where a.cola = b.cola(+);

select /*+ recompile use_merge */ count(*)
 from tbl a left outer join v_tbl b
 on a.cola = b.cola;

evaluate '3. If the SELECT clause of the inline view is a constant';
select /*+ recompile use_hash */ count(*)
 from tbl a, (select 1 cola from tbl) b 
 where a.cola = b.cola(+);

select /*+ recompile use_hash */ count(*)
 from tbl a left outer join (select 1 cola from tbl) b 
 on a.cola = b.cola;

select /*+ recompile use_merge */ count(*)
 from tbl a, (select 1 cola from tbl) b 
 where a.cola = b.cola(+);

select /*+ recompile use_merge */ count(*)
 from tbl a left outer join (select 1 cola from tbl) b 
 on a.cola = b.cola;

evaluate 'multi constant';
select /*+ recompile use_hash */ count(*)
 from tbl a, (select 1 cola, 'x' colb from tbl) b 
 where a.cola = b.cola(+);

select /*+ recompile use_hash */ count(*)
 from tbl a left outer join (select 1 cola, 'x' colb from tbl) b 
 on a.cola = b.cola;

select /*+ recompile use_merge */ count(*)
 from tbl a, (select 1 cola, 'x' colb from tbl) b 
 where a.cola = b.cola(+);

select /*+ recompile use_merge */ count(*)
 from tbl a left outer join (select 1 cola, 'x' colb from tbl) b 
 on a.cola = b.cola;

evaluate 'single row';
select /*+ recompile use_hash */ count(*)
 from tbl a, (select 1 cola) b 
 where a.cola = b.cola(+);

select /*+ recompile use_hash */ count(*)
 from tbl a left outer join (select 1 cola) b 
 on a.cola = b.cola;

select /*+ recompile use_merge */ count(*)
 from tbl a, (select 1 cola) b 
 where a.cola = b.cola(+);

select /*+ recompile use_merge */ count(*)
 from tbl a left outer join (select 1 cola) b 
 on a.cola = b.cola;

evaluate '3-1. Create a view and use it instead of an inline view.';
create or replace view v_tbl as select 1 cola from tbl;

select /*+ recompile use_hash */ count(*)
 from tbl a, v_tbl b
 where a.cola = b.cola(+);

select /*+ recompile use_hash */ count(*)
 from tbl a left outer join v_tbl b
 on a.cola = b.cola;

select /*+ recompile use_merge */ count(*)
 from tbl a, v_tbl b
 where a.cola = b.cola(+);

select /*+ recompile use_merge */ count(*)
 from tbl a left outer join v_tbl b
 on a.cola = b.cola;

evaluate 'multi constant';
create or replace view v_tbl as select 1 cola, 'x' colb from tbl;

select /*+ recompile use_hash */ count(*)
 from tbl a, v_tbl b
 where a.cola = b.cola(+);

select /*+ recompile use_hash */ count(*)
 from tbl a left outer join v_tbl b
 on a.cola = b.cola;

select /*+ recompile use_merge */ count(*)
 from tbl a, v_tbl b
 where a.cola = b.cola(+);

select /*+ recompile use_merge */ count(*)
 from tbl a left outer join v_tbl b
 on a.cola = b.cola;

evaluate 'single row';
create or replace view v_tbl as select 1 cola;

select /*+ recompile use_hash */ count(*)
 from tbl a, v_tbl b
 where a.cola = b.cola(+);

select /*+ recompile use_hash */ count(*)
 from tbl a left outer join v_tbl b
 on a.cola = b.cola;

select /*+ recompile use_merge */ count(*)
 from tbl a, v_tbl b
 where a.cola = b.cola(+);

select /*+ recompile use_merge */ count(*)
 from tbl a left outer join v_tbl b
 on a.cola = b.cola;

drop view if exists v_tbl;
drop table if exists tbl;

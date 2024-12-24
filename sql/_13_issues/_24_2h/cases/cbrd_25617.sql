-- Verified for CBRD-25617
-- Check whether the problem of column order numbers being incorrectly specified inside analytic functions when a view includes analytic functions has been resolved.

drop table if exists tbl;

create table tbl(cola int auto_increment, colb int, colc int, cold int);
insert into tbl (colb, colc, cold) values (1,1,1),(1,1,2),(1,2,2),(1,2,3);

create or replace view va as select row_number() over(partition by colc) as rn, cola, colb, colc, cold from tbl; 
create or replace view vb as select cola, colb, colc, row_number() over(partition by colc) as rn, cold from tbl; 
create or replace view vc as select row_number() over(partition by colc order by cold) as rn, cola, colb, colc, cold from tbl; 
create or replace view vd as select cola, colb, colc, cold, row_number() over(partition by colc order by cold) as rn from tbl; 

select /*+ recompile */ rn from (select row_number() over(partition by colc) as rn, cola, colb, colc, cold from tbl);
select /*+ recompile */ rn from va;

select /*+ recompile */ rn from (select cola, colb, colc, row_number() over(partition by colc) as rn, cold from tbl);
select /*+ recompile */ rn from vb;

select /*+ recompile */ rn from (select row_number() over(partition by colc order by cold) as rn, cola, colb, colc, cold from tbl);
select /*+ recompile */ rn from vc;

select /*+ recompile */ rn from (select cola, colb, colc, cold, row_number() over(partition by colc order by cold) as rn from tbl);
select /*+ recompile */ rn from vd;

drop view va, vb, vc, vd;
drop table tbl;

-- This test case verifies CBRD-24652 issue.
-- The problem performing hash list scan when VOBJECT is included in predicates.
-- Hash list scan should not be used in the result.

drop table if exists tbl;
drop view if exists v_tbl;

create table tbl(x int, y int) dont_reuse_oid;
insert into tbl values(1,1),(2,2);
create or replace view  v_tbl(p,q) as select x,y from tbl union all select x,y from tbl;

-- include VOBJECT
set trace on;
select /*+ recompile */ t.a, t.a.p from table(set(select d from v_tbl d)) t(a);
show trace;
set trace off;

drop table tbl;
drop view v_tbl;

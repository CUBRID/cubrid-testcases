-- This test case verifies CBRD-24652 issue.
-- The problem performing hash list scan when VOBJECT is included in predicates.
-- CBRD-24652 kept hash list scan off for a VOBJ key, as a VOBJ hashed by its address.
-- CBRD-28060 hashes a VOBJ by its key (the real OID), which setvobj_compare () compares,
-- so the scan may use hash list scan and must return the rows of the list scan.
-- When using UNION, there is an issue where the output is inconsistent because UNION_PROC is used instead of OBJ_FETCH_PROC for processing.

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

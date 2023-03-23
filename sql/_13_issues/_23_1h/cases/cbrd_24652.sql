-- This test case verifies CBRD-24652 issue.
-- The problem performing hash list scan when VOBJECT is included in predicates.
-- Hash list scan should not be used in the result.

drop table if exists t1;
drop view if exists v_t1;

create table t1(col1 int, col2 int) dont_reuse_oid;
insert into t1 values(1,1),(2,2);
create or replace view  v_t1(p,q) as select col1,col2 from t1 union all select col1,col2 from t1;

-- include VOBJECT
set trace on;
select /*+ recompile */ t.a, t.a.p from table(set(select d from v_t1 d)) t(a);
show trace;
set trace off;

drop table t1;
drop view v_t1;

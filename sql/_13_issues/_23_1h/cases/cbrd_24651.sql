-- This test case verifies CBRD-24651 issue.
-- Had Problem about need_count_only optimization wass applied when query has after_join predicates.
-- In the trace statics result 'count_only: true' was included caused by the problem.
-- The need_count_optimization is only available when there are no data filters.
 

drop table if exists tbl;
create table tbl (col int);
insert into tbl values(1),(1),(1);
create index idx on tbl(col);

set trace on;
select /*+ recompile */ count(*) from tbl a left outer join tbl b on a.col = b.col left outer join tbl c on a.col = c.col where c.col is null;
show trace;
set trace off;

drop table if exists tbl;

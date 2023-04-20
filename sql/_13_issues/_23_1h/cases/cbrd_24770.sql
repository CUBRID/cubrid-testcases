-- This test case verifies CBRD-24770 issue.
-- When attempting a covered index scan in a connect by query,
-- encountering 'Execute: Query execution failure'.

drop table if exists tbl;

create table tbl (pa int, ca int, cb varchar);
create index idx_tbl on tbl (pa, ca, cb);

insert into tbl values (0, 1, 'a');
insert into tbl values (1, 2, 'b');
insert into tbl values (2, 3, 'c');

insert into tbl values (0, 10, 'aa');
insert into tbl values (10, 20, 'bb');
insert into tbl values (20, 30, 'cc');

--@queryplan
select /*+ recompile */ ca, cb as path
from tbl
start with pa = 0
connect by prior ca = pa;

--@queryplan
select /*+ recompile NO_COVERING_IDX */ ca, cb as path
from tbl
start with pa = 0
connect by prior ca = pa;

drop table tbl;

-- This test case verifies CBRD-24636 issue.
-- Result error of order by limit statement in join query using USE_DESC_IDX hint.
-- Incorrect results releate to 'skip ORDER BY',
-- Incorrect results related to MRO (Multi Range Optimization) will be covered in this issue.
-- Core dump will be covered in a separate issue.


-- Incorrect results releate to 'skip ORDER BY'
drop table if exists t_a, t_b, t_c;

create table t_a (x int);
insert into t_a values (1);

create table t_b (x int, y int);
insert into t_b select a.*, b.* from table ({1}) as a, table ({1, 2, 3, 4}) as b;
create index idx_asc on t_b (x, y);
create index idx_desc on t_b (x, y desc);

create table t_c (x int, y int);
insert into t_c select a.*, b.* from table ({1}) as a, table ({1, 2, 3, 4}) as b;
create index idx_desc on t_c (x, y desc);

update statistics on all classes with fullscan;


-- use_desc_idx hint.
select /*+ recompile use_desc_idx */ t.y
from t_a inner join t_b as t on t_a.x = t.x
where t.x = 1
order by t.y desc;

-- use spcified index without hint.
select /*+ recompile */ t.y
from t_a inner join t_b as t on t_a.x = t.x
where t.x = 1
using index t.idx_desc(+)
order by t.y desc;

-- without hint.
select /*+ recompile */ t.y
from t_a inner join t_c as t on t_a.x = t.x
where t.x = 1
order by t.y desc;

-- use ordered, use_desc_idx hint
select /*+ recompile ordered use_desc_idx */ t.y
from t_a inner join t_c as t on t_a.x = t.x
where t.x = 1
order by t.y desc;

drop t_a, t_b, t_c;


-- Incorrect results related to MRO
create table t_a (x int);
insert into t_a values (1);

create table t_c (x int, y int, z int);
insert into t_c select a.*, b.*, c.* from table ({1}) as a, table ({1, 2}) as b, table ({1, 2, 3, 4}) as c;
create index idx_desc on t_c (x, y desc, z);

update statistics on all classes with fullscan;


-- multi_range_opt
select /*+ recompile use_desc_idx */ t.y, t.z
from t_a inner join t_c as t on t_a.x = t.x
where t.x in (1, 2)
order by t.y desc, z
limit 4;

select /*+ recompile use_desc_idx */ t.y, t.z
from t_c as t
where t.x in (1, 2)
order by t.y desc, z
limit 4;

drop t_a, t_c;


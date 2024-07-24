-- This test case verifies the following issue: CBRD-25428.
-- Validate that a core dump does not occur when using recursive CTEs with string compression

-- Test Case 1: Simple hierarchy with compressed strings
-- Ensures that a compressed string of 255 characters is processed correctly 
-- and the expected results are returned without memory issues (core dump).
drop if exists tbl;
create table tbl (id int, parent_id int, name varchar);
insert into tbl values(1, NULL, repeat('A', 1));
insert into tbl values(2, 1, repeat('C', 255));


-- Recursive CTE query
with recursive c as (
  select a.id, a.parent_id, a.name from tbl a where a.parent_id is null
  union all
  select /*+ use_merge */ b.id, b.parent_id, b.name from tbl b inner join c on b.parent_id = c.id
)
select /*+ recompile */ * from c order by id;

-- Test Case 2: Complex hierarchy with multiple levels of recursion
-- Verify multiple levels of recursion properly handle compressed strings 
-- and return the expected results without memory issues (core dump).
drop table tbl;
create table tbl (id int, parent_id int, name varchar);

insert into tbl values(1, NULL, repeat('A', 255));
insert into tbl values(2, NULL, repeat('B', 255));
insert into tbl values(10, 1, repeat('a', 255));
insert into tbl values(11, 1, repeat('b', 255));
insert into tbl values(20, 2, repeat('c', 255));
insert into tbl values(21, 2, repeat('d', 255));


-- Recursive CTE query
with recursive c as (
  select a.id, a.parent_id, a.name from tbl a where a.parent_id is null
  union all
  select /*+ use_merge */ b.id, b.parent_id, b.name from tbl b inner join c on b.parent_id = c.id
)
select /*+ recompile */ * from c order by id;

drop table tbl;

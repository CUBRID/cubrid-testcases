drop table if exists tb_skip_a, tb_skip_b;
set trace on;

-- Create test tables
-- tb_skip_a : driving (outer) table
-- tb_skip_b : inner table that owns the ORDER BY target column (indexed for sorting)
create table tb_skip_a (
  id int not null,
  grp int not null
);

create table tb_skip_b (
  id int not null,
  sort_key int,
  payload int
);

-- Insert test data into tb_skip_a
insert into tb_skip_a
with recursive cte (n) as (
  select 1
  union all
  select n + 1 from cte where n < 1000
)
select n, mod(n, 10)
from cte;

-- Insert test data into tb_skip_b
insert into tb_skip_b
with recursive cte (n) as (
  select 1
  union all
  select n + 1 from cte where n < 2000
)
select n, n, mod(n, 100)
from cte;

-- Create indexes
-- 1) Index on sort_key used for ORDER BY
-- 2) Composite index (sort_key, payload) for partial-match tests
create index idx_b_sort_key on tb_skip_b (sort_key);
create index idx_b_sort_key_payload on tb_skip_b (sort_key, payload);

update statistics on tb_skip_a, tb_skip_b with fullscan;

-- Q207 ~ Q209:
--   ORDER BY column is on the inner table (tb_skip_b),
--   while the driving table is the outer table (tb_skip_a).
--   Most existing test cases focus on the table that uses the index.
--   These tests verify whether skip ORDER BY can still be applied
--   when the join driving table and the ORDER BY index table are different.

evaluate 'Q207. When the ORDER BY column belongs to the inner joined table and an index exists on that column, skip ORDER BY can be applied using an index scan on the inner table.';
select /*+ recompile ordered */
  'Q207', a.id, b.sort_key, b.payload
from tb_skip_a a, tb_skip_b b
where a.id = b.id
order by b.sort_key
limit 20;
show trace;

evaluate 'Q208. When the ORDER BY column belongs to the inner joined table and is sorted in descending order, skip ORDER BY can still be applied if a descending index scan is allowed.';
select /*+ recompile ordered */
  'Q208', a.id, b.sort_key, b.payload
from tb_skip_a a, tb_skip_b b
where a.id = b.id
order by b.sort_key desc
limit 30, 10;
show trace;

evaluate 'Q209. When ORDER BY uses only columns from the inner table, the join driver can still be the outer table while skip ORDER BY is applied on the inner table index.';
select /*+ recompile ordered */
  'Q209', b.sort_key, b.payload
from tb_skip_a a, tb_skip_b b
where a.id = b.id and a.grp = 1
order by b.sort_key
limit 10;
show trace;

-- Q210 ~ Q211:
--   Multi-column ORDER BY with partial match on the composite index
--   (only the leading column matches vs. full ORDER BY not matching the index)

evaluate 'Q210. When ORDER BY (sort_key, payload) fully matches the composite index (sort_key, payload), skip ORDER BY can be applied.';
select /*+ recompile ordered */
  'Q210', a.id, b.sort_key, b.payload
from tb_skip_a a, tb_skip_b b
where a.id = b.id
order by b.sort_key, b.payload
limit 40, 10;
show trace;

evaluate 'Q211. When ORDER BY (sort_key, payload, a.id) does not fully match the composite index (sort_key, payload), skip ORDER BY should not be applied.';
select /*+ recompile ordered */
  'Q211', a.id, b.sort_key, b.payload
from tb_skip_a a, tb_skip_b b
where a.id = b.id
order by b.sort_key, b.payload, a.id
limit 50, 10;
show trace;

-- Q212 ~ Q214:
--   Skip ORDER BY behavior when actual data contains NULLs.
--   Policies for NOT NULL constraints and IS NOT NULL conditions are well-defined,
--   but these tests confirm the behavior when NULL values actually exist in the data.

-- Make some rows have NULL sort_key to create a realistic NULL scenario
update tb_skip_b
set sort_key = null
where mod(id, 100) = 0;

update statistics on tb_skip_b with fullscan;

evaluate 'Q212. When the ORDER BY leading column may contain NULL values, skip ORDER BY should not be applied.';
select /*+ recompile ordered */
  'Q212', a.id, b.sort_key, b.payload
from tb_skip_a a, tb_skip_b b
where a.id = b.id
order by b.sort_key
limit 20;
show trace;

evaluate 'Q213. When IS NOT NULL is specified on the ORDER BY column, skip ORDER BY can be applied even if the column is nullable.';
select /*+ recompile ordered */
  'Q213', a.id, b.sort_key, b.payload
from tb_skip_a a, tb_skip_b b
where a.id = b.id
  and b.sort_key is not null
order by b.sort_key
limit 20;
show trace;

evaluate 'Q214. When IS NOT NULL is specified and descending order is used, skip ORDER BY can still be applied if the index supports descending scans.';
select /*+ recompile ordered */
  'Q214', a.id, b.sort_key, b.payload
from tb_skip_a a, tb_skip_b b
where a.id = b.id
  and b.sort_key is not null
order by b.sort_key desc
limit 30, 10;
show trace;

-- Q215 ~ Q217:
--   ORDER BY mixes index columns and expressions.
--   Q130 already covers "only ORDER BY expressions → skip ORDER BY is disabled".
--   These tests add cases where expressions are mixed with index columns.

evaluate 'Q215. When ORDER BY uses (sort_key, sort_key + 10), skip ORDER BY should not be applied because the ORDER BY contains an expression on the indexed column.';
select /*+ recompile ordered */
  'Q215', a.id, b.sort_key, (b.sort_key + 10) as sort_expr, b.payload
from tb_skip_a a, tb_skip_b b
where a.id = b.id
order by b.sort_key, (b.sort_key + 10)
limit 10;
show trace;

evaluate 'Q216. When ORDER BY uses only an expression on the indexed column (sort_key + 10), skip ORDER BY should not be applied.';
select /*+ recompile ordered */
  'Q216', a.id, b.sort_key, (b.sort_key + 10) as sort_expr, b.payload
from tb_skip_a a, tb_skip_b b
where a.id = b.id
order by (b.sort_key + 10)
limit 10;
show trace;

evaluate 'Q217. When ORDER BY mixes the indexed column and an expression together with DESC, skip ORDER BY should not be applied.';
select /*+ recompile ordered */
  'Q217', a.id, b.sort_key, (b.sort_key + 10) as sort_expr, b.payload
from tb_skip_a a, tb_skip_b b
where a.id = b.id
order by b.sort_key desc, (b.sort_key + 10)
limit 20;
show trace;

set trace off;
drop table if exists tb_skip_a, tb_skip_b;

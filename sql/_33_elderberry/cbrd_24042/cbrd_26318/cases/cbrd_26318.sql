-- Verification for CBRD-26318
-- This test checks view-merge optimization and index scan behavior
-- under different subquery types:
--   1. Correlated: depends on outer column, index scan not applied.
--   2. Nested: multiple levels of subqueries with outer references.
--   3. Uncorrelated: no outer reference, index scan allowed.
--   4. Uncorrelated with multiple outer refs (aptr): still index scan possible.
-- Note: A basic uncorrelated subquery case is also covered in
--       sql/_33_elderberry/cbrd_24042/add/cases/using_index.sql.

drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
 
create index idx on ta (ca);
create index idx on tb (ca);
create index idx on tc (ca);

evaluate '1. Correlated Subquery Case';
select /*+ recompile */
  (
    select
      d.cb
    from
      tc d
    where
      c.a_ca = d.ca
  )
from
  (
    select
      a.ca,
      (select  b.cb from tb b where b.ca = a.ca limit 1) as a_ca
    from
      ta a
  ) c;

evaluate '2. Nested Subquery Case';
select /*+ recompile */
  (select b.cb
     from tb b
    where b.ca = (
            select d.ca
              from tc d
             where d.ca = 1
             limit 1
          )
  ) as nested_val
from ta a;

evaluate '3. Uncorrelated Subquery Case';
select /*+ recompile */
  (select b.cb from tb b where b.ca = 1 limit 1) as uncorr_val
from ta a;

evaluate '4. Uncorrelated Subquery with Multiple Outer References';
select /*+ recompile */
  (select b.cb
     from tb b
    where b.ca = a.ca or b.cb = a.cb
    limit 1) as uncorr_multi_outer
from ta a;

drop index idx on ta;
drop index idx on tb;
drop index idx on tc;
drop table if exists ta, tb, tc;

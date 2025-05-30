/**
 *  This test case verifies CBRD-25519 : Add partition pruning information to SQL Trace
 *  1. agl
 *  2. all partitions (range)
 *  3. all partitions (hash)
 *  4. all partitions (list)
 *  5. pruning (range)
 *  6. pruning (hash)
 *  7. pruning (list)
 *  8. pruning + limit
 *  9. pruning + inline view + limit
 * 10. partition table + nl join
 * 11. partition table + merge join
 * 12. partition table + hash join
 * 13. partition table + from list
 * 14. pruning + union
 * 15. pruning + cte
 * 16. json format output
 */

set @i = 0;

-- PREPARE TEST
drop table if exists ta_range, ta_hash, ta_list, tb;
create table ta_range (ca int, cb int, cc int, cd int, index i1 (cb, cc), primary key (ca, cd))
partition by range (ca)
(
  partition p0 values less than (1),
  partition p1 values less than (2),
  partition p2 values less than (3),
  partition p3 values less than (4),
  partition p4 values less than (5),
  partition p5 values less than (6),
  partition p6 values less than (7),
  partition p7 values less than (8),
  partition p8 values less than (9),
  partition p9 values less than MAXVALUE
);
create table ta_hash (ca int, cb int, cc int, cd int, index i1 (cb, cc), primary key (ca, cd)) partition by hash (ca) partitions 8;
create table ta_list (ca int, cb int, cc int, cd int, index i1 (cb, cc), primary key (ca, cd))
partition by list (ca)
(
  partition p0 values in (0, 1),
  partition p1 values in (2, 3),
  partition p2 values in (4, 5),
  partition p3 values in (6, 7),
  partition p4 values in (8, 9)
);
create table tb (ca int, cb int, cc int, cd int, index i1 (cb, cc), primary key (ca, cd));

insert into tb
  with recursive cte (n) as (
      select 0
      union all
      select n + 1 from cte where n < 9
    )
  select a.n, b.n, c.n, rownum from cte a, cte b, cte c;
insert into ta_range select * from tb;
insert into ta_list select * from tb;
insert into ta_hash select * from tb;

update statistics on ta_range, ta_list, ta_hash, tb with fullscan;

set trace on;

-- START TEST
do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. agl');

select /*+ recompile */ count (*)
from ta_range a
using index none;
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. all partitions (range)');

select /*+ recompile */ *
from ta_range a
using index none
order by 1
limit 1;
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. all partitions (hash)');

select /*+ recompile */ *
from ta_hash a
using index none
order by 1
limit 1;
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. all partitions (list)');

select /*+ recompile */ *
from ta_list a
using index none
order by cd desc
limit 1;
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. pruning (range)');

select /*+ recompile */ count (*)
from ta_range a
where a.ca between 1 and 4;
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. pruning (hash)');

select /*+ recompile */ count (*)
from ta_hash a
where a.ca in (2, 3);
show trace;

select /*+ recompile */ count (*)
from ta_hash a
where a.ca >= 9;
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. pruning (list)');

select /*+ recompile */ count (*)
from ta_list a
where a.ca in (5, 6);
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. pruning + limit');

select /*+ recompile */ *
from ta_range a
order by cd
limit 150, 10;
show trace;

select /*+ recompile */ *
from ta_range a
order by cd
limit 550, 10;
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. pruning + inline view + limit');

select /*+ recompile ordered */
  count(*)
from
  (
    select *
    from ta_range a
    where a.ca between 5 and 7
    limit 250
  ) a,
  tb b
where a.ca = b.ca and a.cd = b.cd;
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. partition table + nl join');

select /*+ recompile ordered use_nl */ *
from ta_range a, ta_hash b, tb c, ta_list d
where a.ca = b.ca and a.cd = b.cd and b.ca = c.ca and b.cd = c.cd and c.ca = d.ca and c.cd = d.cd
order by a.cd
limit 250, 10;
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. partition table + merge join');

select /*+ recompile ordered use_merge */ *
from ta_range a, ta_hash b, tb c, ta_list d
where a.ca = b.ca and a.cd = b.cd and b.ca = c.ca and b.cd = c.cd and c.ca = d.ca and c.cd = d.cd
order by a.cd
limit 250, 10;
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. partition table + hash join');

select /*+ recompile ordered use_hash*/ *
from ta_range a, ta_hash b, tb c, ta_list d
where a.ca = b.ca and a.cd = b.cd and b.ca = c.ca and b.cd = c.cd and c.ca = d.ca and c.cd = d.cd
order by a.cd
limit 250, 10;
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. partition table + from list');

select /*+ recompile */ count(*) 
FROM (
    select * from (ta_range, ta_list, ta_hash, tb)
  );
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. pruning + union');

select /*+ recompile */ count (*)
from (
    select *
    from ta_range a
    where a.ca in (1, 2)
    union
    select *
    from ta_list a
    where a.ca in (2, 7)
  );
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. pruning + cte');

with cte as (select * from ta_range a where a.ca between 8 and 9 limit 1500)
select /*+ recompile ordered */ count(*)
from  cte a, ta_list b
where a.ca = b.ca and a.cd = b.cd;
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. json format output');

set trace on output json;

select /*+ recompile */ count (*)
from ta_range a
where a.ca between 1 and 4;
show trace;

set trace off;

drop table if exists ta_range, ta_list, ta_hash, tb;
drop variable @i;

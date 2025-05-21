/**
 *  This test case verifies CBRD-25382: Support HASH JOIN with hint required
 *  cbrd_25382_5: trace.sql 
 *  1. empty outer
 *  2. empty inner
 *  3. empty inner + left outer join
 *  4. multiple tables
 *  5. inline views
 *  6. subqueries
 *  7. ctes (common table expressions)
 *  8. json format output
 */

set @i = 0;

drop table if exists ta, tb, tc, td;
create table ta (ca int, cb int, cc int, cd int, index i_a (ca, cb, cc), index i_b (cb, cc), index i_c (cd));
create table tb (ca int, cb int, cc int, cd int, index i_a (ca, cb, cc), index i_b (cb, cc), index i_c (cd));
create table tc (ca int, cb int, cc int, cd int, index i_a (ca, cb, cc), index i_b (cb, cc), index i_c (cd));
create table td (ca int, cb int, cc int, cd int, index i_a (ca, cb, cc), index i_b (cb, cc), index i_c (cd));

insert into ta
  with recursive cte (n) as (
      select 1
      union all
      select n + 1 from cte where n < 2000
    )
  select mod (n, 10), mod (n, 100), mod (n, 1000), n from cte;
insert into tb select * from ta;
insert into tc select * from ta;
insert into td select * from ta;

-- unnecessary
update statistics on ta, tb, tc, td with fullscan;

set trace on;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. empty outer');

--@queryplan
select /*+ recompile ordered use_hash */
  a.cd as a_cd, b.cd as b_cd
from ta a, tb b
where a.cd = b.cd and a.ca = -1
order by a.cd;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. empty inner');

--@queryplan
select /*+ recompile ordered use_hash */
  a.cd as a_cd, b.cd as b_cd
from ta a, tb b
where a.cd = b.cd and b.ca = -1
order by a.cd;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. empty inner + left outer join');

--@queryplan
select /*+ recompile ordered use_hash */
  a.cd as a_cd, b.cd as b_cd
from ta a
  left outer join tb b on b.cd = a.cd and b.ca = -1
order by a.cd
limit 1999, 1;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. multiple tables');

--@queryplan
select /*+ recompile use_hash */
  a.cd as a_cd, b.cd as b_cd, c.cd as c_cd, d.cd as d_cd
from ta a, tb b, tc c, td d
where a.cd = b.cd and b.cd = c.cd and c.cd = d.cd
  and a.cc = 1
  and b.cc = 1
  and c.cc = 1
  and d.cc = 1
order by a.cd;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. inline views');

--@queryplan
select /*+ recompile use_hash */
  a.cd as a_cd, b.cd as b_cd
from
  (select /*+ no_merge */ * from ta where cc = 2) a,
  (select /*+ no_merge */ * from tb where cc = 2) b
where a.cd = b.cd
order by a.cd;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. subqueries');

--@queryplan
select /*+ recompile use_hash */
  a.cd as a_cd, b.cd as b_cd,
  (select /*+ no_subquery_cache */ d.cd from td d where d.cd = b.cd and d.cd = b.cd) as d_cd
from
  (select /*+ no_merge */ * from ta where cc = 3) a,
  (select /*+ no_merge */ * from tb where cc = 3) b
where a.cd = b.cd
  and a.ca in (select distinct c.ca from tc c)
order by a.cd;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. ctes (common table expressions)');

--@queryplan
with cte as (
    select /*+ use_hash */
      a.ca as ca, a.cb as cb, a.cc as cc, a.cd as cd
    from ta a, tb b
    where a.cd = b.cd and a.ca = 4 and b.ca = 4
  )
select /*+ recompile use_hash */
  c.cd as c_cd, d.cd as d_cd
from cte c, td d
where c.cd = d.cd and c.cc = 4 and d.cc = 4
order by c.cd;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. json format output');

set trace on output json;

--@queryplan
select /*+ recompile use_hash */
  a.cd as a_cd, b.cd as b_cd
from ta a, tb b
where a.cd = b.cd and a.cc = 5 and b.cc = 5
order by a.cd;

show trace;
--select trace_stats ();

set trace off;

drop table ta, tb, tc, td;
drop variable @i;


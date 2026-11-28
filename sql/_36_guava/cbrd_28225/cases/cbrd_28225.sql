/*
 * CBRD-28225: sort-merge join on an expression key over a lower join result.
 *
 * Bug:
 *   When a sort-merge join (the USE_MERGE hint) joins on an expression key such
 *   as a.kb+1 = b.kb+1, and one side of it is the materialized result of another
 *   merge or hash join, the columns read by the expression were not carried into
 *   the lower join's result list. The key was computed from a stale value of
 *   another column (wrong rows) under a serial plan, and from NULL (no rows)
 *   under the parallel subquery executor.
 *
 * Fix:
 *   The columns read by an expression merge key are passed down into the lower
 *   join's result list, so the key is computed from the right values.
 *
 * Every case compares the USE_MERGE result with a USE_NL reference by
 * count(*), count(distinct) and sum, with null-safe <=>, so a wrong key that
 * happens to give the right row count is still caught. The columns k, kb and
 * kn hold different values in each row for the same reason.
 *
 * Coverage:
 *   Case 1: the Jira query, four tables, both sides of the expression key over
 *           lower merge joins (default parallelism)
 *   Case 2: Case 1 with the PARALLEL(0) hint (serial plan)
 *   Case 3: the outer side is a lower merge join, the same constant on both sides
 *   Case 4: different constants on the two sides of the key
 *   Case 5: Case 3 with the lower join side as the right operand of the key
 *   Case 6: the outer side is a lower hash join
 *   Case 7: the outer side is a lower LEFT OUTER merge join, upper() and trim()
 *           keys on a case-insensitive collation
 *   Case 8: a lower merge join on a cast() key, then a LEFT OUTER merge join
 *   Case 9: the expression key merge join itself is a RIGHT OUTER join
 */
drop table if exists ta, tu, ts;
create table ta (id int, k int, kb int, kn int);
insert into ta select level, mod(level*37,1000), mod(level*53,1000), mod(level*71,1000) from db_root connect by level <= 300;
create table tu (id int, k int, kb int, kv varchar(20) collate utf8_bin);
insert into tu select level, mod(level*7,50), mod(level*11,60), 'v'||mod(level,40) from db_root connect by level <= 400;
create table ts (id int, k int, kb int, kv varchar(20) collate utf8_bin, kvci varchar(20) collate utf8_en_ci);
insert into ts select level, mod(level*3,50), mod(level*5,60), 'v'||mod(level,40), ' V'||mod(level,40)||' ' from db_root connect by level <= 120;
update statistics on ta with fullscan;
update statistics on tu with fullscan;
update statistics on ts with fullscan;

evaluate 'Case 1: the Jira query, default parallelism';
select case when m.c <=> n.c and m.dc <=> n.dc and m.sd <=> n.sd and m.sb <=> n.sb then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE */ count(*) c, count(distinct b.id) dc, sum(d.id) sd, sum(b.id) sb
      from ta d, ta a, ta b, ta c where a.kb+1 = b.kb+1 and a.k = c.id and d.k = a.kn) m,
     (select /*+ USE_NL */ count(*) c, count(distinct b.id) dc, sum(d.id) sd, sum(b.id) sb
      from ta d, ta a, ta b, ta c where a.kb+1 = b.kb+1 and a.k = c.id and d.k = a.kn) n;

evaluate 'Case 2: the Jira query, serial';
select case when m.c <=> n.c and m.dc <=> n.dc and m.sd <=> n.sd and m.sb <=> n.sb then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE PARALLEL(0) */ count(*) c, count(distinct b.id) dc, sum(d.id) sd, sum(b.id) sb
      from ta d, ta a, ta b, ta c where a.kb+1 = b.kb+1 and a.k = c.id and d.k = a.kn) m,
     (select /*+ USE_NL */ count(*) c, count(distinct b.id) dc, sum(d.id) sd, sum(b.id) sb
      from ta d, ta a, ta b, ta c where a.kb+1 = b.kb+1 and a.k = c.id and d.k = a.kn) n;

evaluate 'Case 3: outer side is a lower merge join';
select case when m.c <=> n.c and m.dc <=> n.dc and m.sa <=> n.sa and m.sb <=> n.sb and m.sc <=> n.sc then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE ORDERED */ count(*) c, count(distinct b.id) dc, sum(a.id) sa, sum(b.id) sb, sum(c.id) sc
      from ta a, ta c, ta b where a.kb+1 = b.kb+1 and a.k = c.id) m,
     (select /*+ USE_NL ORDERED */ count(*) c, count(distinct b.id) dc, sum(a.id) sa, sum(b.id) sb, sum(c.id) sc
      from ta a, ta c, ta b where a.kb+1 = b.kb+1 and a.k = c.id) n;

evaluate 'Case 4: different constants on the two sides';
select case when m.c <=> n.c and m.dc <=> n.dc and m.sa <=> n.sa and m.sb <=> n.sb and m.sc <=> n.sc then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE ORDERED */ count(*) c, count(distinct b.id) dc, sum(a.id) sa, sum(b.id) sb, sum(c.id) sc
      from ta a, ta c, ta b where a.kb+1 = b.kb+2 and a.k = c.id) m,
     (select /*+ USE_NL ORDERED */ count(*) c, count(distinct b.id) dc, sum(a.id) sa, sum(b.id) sb, sum(c.id) sc
      from ta a, ta c, ta b where a.kb+1 = b.kb+2 and a.k = c.id) n;

evaluate 'Case 5: lower join side as the right operand of the key';
select case when m.c <=> n.c and m.dc <=> n.dc and m.sa <=> n.sa and m.sb <=> n.sb and m.sc <=> n.sc then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE */ count(*) c, count(distinct b.id) dc, sum(a.id) sa, sum(b.id) sb, sum(c.id) sc
      from ta b, ta a, ta c where b.kb+1 = a.kb+1 and a.k = c.id) m,
     (select /*+ USE_NL */ count(*) c, count(distinct b.id) dc, sum(a.id) sa, sum(b.id) sb, sum(c.id) sc
      from ta b, ta a, ta c where b.kb+1 = a.kb+1 and a.k = c.id) n;

evaluate 'Case 6: outer side is a lower hash join';
select case when m.c <=> n.c and m.dc <=> n.dc and m.sa <=> n.sa and m.sb <=> n.sb and m.sc <=> n.sc then 'PASS' else 'FAIL' end as result
from (select /*+ ORDERED USE_HASH(c) USE_MERGE(b) */ count(*) c, count(distinct b.id) dc, sum(a.id) sa, sum(b.id) sb, sum(c.id) sc
      from ta a, ta c, ta b where a.kb+1 = b.kb+1 and a.k = c.id) m,
     (select /*+ USE_NL ORDERED */ count(*) c, count(distinct b.id) dc, sum(a.id) sa, sum(b.id) sb, sum(c.id) sc
      from ta a, ta c, ta b where a.kb+1 = b.kb+1 and a.k = c.id) n;

evaluate 'Case 7: outer side is a lower LEFT OUTER merge join';
select case when m.c <=> n.c and m.dc <=> n.dc and m.sb <=> n.sb and m.ca <=> n.ca then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE */ count(*) c, count(distinct b.id) dc, sum(b.id) sb, count(a.id) ca
      from tu d left join ts a on d.kb = a.id inner join ts b on upper(d.kv) = trim(b.kvci)) m,
     (select /*+ USE_NL */ count(*) c, count(distinct b.id) dc, sum(b.id) sb, count(a.id) ca
      from tu d left join ts a on d.kb = a.id inner join ts b on upper(d.kv) = trim(b.kvci)) n;

evaluate 'Case 8: a cast() key merge join, then a LEFT OUTER merge join';
select case when m.c <=> n.c and m.dc <=> n.dc and m.sb <=> n.sb and m.cc <=> n.cc then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE */ count(*) c, count(distinct b.id) dc, sum(b.id) sb, count(c.id) cc
      from tu a inner join ts b on cast(a.kb as varchar(20)) = cast(b.id as varchar(20)) left join tu c on a.k = c.id) m,
     (select /*+ USE_NL */ count(*) c, count(distinct b.id) dc, sum(b.id) sb, count(c.id) cc
      from tu a inner join ts b on cast(a.kb as varchar(20)) = cast(b.id as varchar(20)) left join tu c on a.k = c.id) n;

evaluate 'Case 9: the expression key merge join is a RIGHT OUTER join';
select case when m.c <=> n.c and m.ca <=> n.ca and m.da <=> n.da and m.sb <=> n.sb and m.sc <=> n.sc then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE */ count(*) c, count(a.id) ca, count(distinct a.id) da, sum(b.id) sb, sum(c.id) sc
      from ta a inner join ta c on a.k = c.id right join ta b on a.kb+1 = b.kb+500) m,
     (select /*+ USE_NL */ count(*) c, count(a.id) ca, count(distinct a.id) da, sum(b.id) sb, sum(c.id) sc
      from ta a inner join ta c on a.k = c.id right join ta b on a.kb+1 = b.kb+500) n;

drop table ta, tu, ts;

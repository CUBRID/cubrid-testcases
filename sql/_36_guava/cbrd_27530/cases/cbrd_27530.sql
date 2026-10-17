/*
 * This test case verifies CBRD-27530 : sort-merge join without input sorts
 * and without the final ORDER BY sort when an index provides the join order.
 *
 * Feature: a merge-join input that is an index scan whose leading key columns
 * are the join columns (ASC) is already in join order. With
 * optimizer_enable_merge_join=yes the optimizer now declares that order on
 * the index scan, generates a range-less index scan candidate for the join
 * column, feeds the scan to the merge join as a sorted input (the executor
 * opens the input list with the covered sort list and skips the sort), and
 * skips the final ORDER BY sort when the outer input covers it. A lower
 * inner merge-join result (outer order) is accepted as a sorted input of an
 * upper merge join. With the parameter off (the default) the plan is the
 * same as before: inputs sorted, final ORDER BY sorted.
 *
 * Check design: every case runs the SAME logical query through
 * the USE_MERGE hint (sort-skipped path) and through the USE_NL hint with
 * `using index none` (ground truth) and compares the two with null-safe <=>,
 * emitting one PASS/FAIL row. ORDER BY cases are ORDER-SENSITIVE: rownum is
 * assigned on the ordered result in an outer derived table and sum(a*rn) is
 * part of the fingerprint, so a wrong output order (a skipped sort over an
 * unsorted stream) fails even when the row set is identical. Tie columns are
 * never multiplied by rn.
 *
 * Index pinning: `using index i_x(+)` is forced on the merge inputs. On
 * tables this small the cost model prefers seq scan + in-memory sort over a
 * full index scan, so without the pin the sort-skip path would not be taken
 * (false PASS: sort vs sort). The NL side is pinned to none.
 *
 * Sizing (verified): ta 1500 rows / 150 keys (10 rows per key, 15 NULL keys),
 * tb 1200 rows / 240 keys (5 rows per key, 13 NULL keys): multi-row key
 * groups on both sides (merge group advance), NULL keys on both sides, and
 * ~7300 joined rows so an order mistake cannot hide. No page threshold is
 * involved; the feature is plan-shape driven.
 *
 * Table names use letters (ta..te), not digits, because CTP masks digits in
 * the trace output to ?.
 *
 * Plan proof (set trace on / show trace, 6 blocks): with the parameter on
 * the Query Plan has no "SORT (order by)" on top (final sort skipped) and
 * the join column index is used as a range-less "INDEX SCAN" on both inputs
 * (the new full index scan candidate; without the feature tb falls back to
 * TABLE SCAN even with the (+) pin, see the last block). An input sort that
 * is really executed shows up in the trace statistics as a "(parallel
 * workers: ...)" sub-line under the input ORDERBY (parallel sort of the
 * input list); a skipped input sort has no such sub-line. The last block
 * turns the parameter off and shows the previous plan: "SORT (order by)" on
 * top, "TABLE SCAN (dba.tb)" and both input sorts executed. Counts in the
 * trace are masked by CTP; correctness is asserted only by the PASS/FAIL
 * rows.
 *
 * Coverage:
 *   C1  both inputs indexed, ORDER BY outer join column   -> inputs + final sort skipped
 *   C2  only the outer input indexed                      -> outer skip only
 *   C3  only the inner input indexed, ORDER BY outer col  -> inner skip, final sort kept
 *   C4  ORDER BY outer column DESC                        -> final sort kept (merge is ASC)
 *   C5  ORDER BY inner column / extra tie-breaker column  -> final sort kept
 *   C6  ORDER BY ... LIMIT                                -> correct
 *   C7  composite join (a,b), (a,b) indexes on both sides -> inputs skipped
 *   C8  composite join (a,b) with an (a)-only index       -> partial cover, sort kept
 *   C9  NULL join keys on both sides (inner join)         -> never join
 *   C10 LEFT OUTER join, NULL keys on the preserved side  -> NULL rows kept
 *   C11 DESC index on the join column                     -> not used as sorted input
 *   C12 sarg on the indexed join column (range + merge)   -> ordered range scan
 *   C13 PARALLEL(4) hint on the merge query               -> same result as serial
 *   C14 IN subquery / EXISTS subquery with merge          -> correct
 *   C15 derived table (GROUP BY) as one merge input       -> one-side skip
 *   C16 correlated scalar subquery in the select list     -> correct
 *   C17 three-table merge chain                           -> lower merge output reused sorted
 *   C18 GROUP BY the join column over the merge           -> correct
 *   C19 DISTINCT + ORDER BY                               -> correct
 *   C20 expression join term (ta.a = tb.a + 0)            -> not skipped, correct
 *   C21 no join hint / no pin (parameter on)              -> cost model picks the sort-free merge
 *   C22 parameter off + USE_MERGE                         -> previous behaviour: inputs sorted
 */

set system parameters 'optimizer_enable_merge_join=yes';

drop table if exists ta, tb, tc, td, te;

create table ta (a int, b int, p char(100));
insert into ta
select case when mod(rownum,97)=0 then null else mod(rownum,150) end, rownum, 'x'
from db_class x1, db_class x2, db_class x3 limit 1500;
create index i_ta_a on ta(a);

create table tb (a int, c int, q char(100));
insert into tb
select case when mod(rownum,89)=0 then null else mod(rownum,240) end, rownum*3, 'y'
from db_class x1, db_class x2, db_class x3 limit 1200;
create index i_tb_a on tb(a);

create table tc (a int, b int, d int);
insert into tc
select mod(rownum,100), mod(rownum,7), rownum
from db_class x1, db_class x2, db_class x3 limit 2000;
create index i_tc_ab on tc(a, b);
create index i_tc_a on tc(a);

create table td (a int, b int, e int);
insert into td
select mod(rownum,150), mod(rownum,7), rownum*2
from db_class x1, db_class x2, db_class x3 limit 1500;
create index i_td_ab on td(a, b);

create table te (a int, f int);
insert into te
select mod(rownum,200), rownum
from db_class x1, db_class x2, db_class x3 limit 1000;
create index i_te_a_desc on te(a desc);

update statistics on ta, tb, tc, td, te;

-- ---------------------------------------------------------------------------------
-- trace sanity (plan shape proof): C1 shape -- expect "(sorted)" on both merge inputs and
-- no sort step for the inputs nor for the final ORDER BY (skip ORDER BY)
-- ---------------------------------------------------------------------------------
set trace on;
select /*+ USE_MERGE */ ta.a, ta.b, tb.c from ta, tb where ta.a = tb.a
using index i_ta_a(+), i_tb_a(+) order by ta.a limit 1;
show trace;
set trace off;

-- C1. both inputs indexed, ORDER BY outer join column: order-sensitive fingerprint
select case when m.cnt<=>n.cnt and m.sa<=>n.sa and m.sb<=>n.sb and m.sc<=>n.sc and m.ord<=>n.ord
       then 'PASS' else 'FAIL' end as c1
from (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index i_ta_a(+), i_tb_a(+) order by ta.a) x) y) m,
     (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index none order by ta.a) x) y) n;

-- C2. only the outer input indexed (inner pinned to seq scan)
select case when m.cnt<=>n.cnt and m.sa<=>n.sa and m.sb<=>n.sb and m.sc<=>n.sc and m.ord<=>n.ord
       then 'PASS' else 'FAIL' end as c2
from (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index i_ta_a(+), tb.none order by ta.a) x) y) m,
     (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index none order by ta.a) x) y) n;

-- C3. only the inner input indexed; outer is sorted so the final ORDER BY sort must stay
select case when m.cnt<=>n.cnt and m.sa<=>n.sa and m.sb<=>n.sb and m.sc<=>n.sc and m.ord<=>n.ord
       then 'PASS' else 'FAIL' end as c3
from (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index ta.none, i_tb_a(+) order by ta.a) x) y) m,
     (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index none order by ta.a) x) y) n;

-- C4. ORDER BY outer column DESC: merge inputs are ASC, final sort must be kept
select case when m.cnt<=>n.cnt and m.sa<=>n.sa and m.sb<=>n.sb and m.sc<=>n.sc and m.ord<=>n.ord
       then 'PASS' else 'FAIL' end as c4
from (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index i_ta_a(+), i_tb_a(+) order by ta.a desc) x) y) m,
     (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index none order by ta.a desc) x) y) n;

-- C5. ORDER BY inner column and ORDER BY with a tie-breaker not covered by the index
select case when m.cnt<=>n.cnt and m.ord<=>n.ord and m.ord2<=>n.ord2 then 'PASS' else 'FAIL' end as c5
from (select count(*) cnt, sum(a*rn) ord, sum(b*rn) ord2
      from (select a, b, c, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index i_ta_a(+), i_tb_a(+) order by tb.a, ta.b, tb.c) x) y) m,
     (select count(*) cnt, sum(a*rn) ord, sum(b*rn) ord2
      from (select a, b, c, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index none order by tb.a, ta.b, tb.c) x) y) n;

-- C6. ORDER BY ... LIMIT (deterministic: full key order b, c)
select case when m.cnt<=>n.cnt and m.sa<=>n.sa and m.ord<=>n.ord then 'PASS' else 'FAIL' end as c6
from (select count(*) cnt, sum(a) sa, sum(b*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index i_ta_a(+), i_tb_a(+) order by ta.a, ta.b, tb.c limit 50) x) y) m,
     (select count(*) cnt, sum(a) sa, sum(b*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index none order by ta.a, ta.b, tb.c limit 50) x) y) n;

-- trace sanity: C7 shape -- composite (a,b) indexes on both sides, expect both inputs "(sorted)"
set trace on;
select /*+ USE_MERGE */ tc.a, tc.b, td.e from tc, td where tc.a = td.a and tc.b = td.b
using index i_tc_ab(+), i_td_ab(+) order by tc.a, tc.b limit 1;
show trace;
set trace off;

-- C7. composite join with (a,b) indexes on both sides
select case when m.cnt<=>n.cnt and m.sd<=>n.sd and m.se<=>n.se and m.ord<=>n.ord
       then 'PASS' else 'FAIL' end as c7
from (select count(*) cnt, sum(d) sd, sum(e) se, sum((a*10+b)*rn) ord
      from (select a, b, d, e, rownum rn
            from (select /*+ USE_MERGE */ tc.a a, tc.b b, tc.d d, td.e e from tc, td
                  where tc.a = td.a and tc.b = td.b
                  using index i_tc_ab(+), i_td_ab(+) order by tc.a, tc.b) x) y) m,
     (select count(*) cnt, sum(d) sd, sum(e) se, sum((a*10+b)*rn) ord
      from (select a, b, d, e, rownum rn
            from (select /*+ USE_NL */ tc.a a, tc.b b, tc.d d, td.e e from tc, td
                  where tc.a = td.a and tc.b = td.b
                  using index none order by tc.a, tc.b) x) y) n;

-- C8. composite join where the outer index covers only (a): the input sort must stay
select case when m.cnt<=>n.cnt and m.sd<=>n.sd and m.se<=>n.se and m.ord<=>n.ord
       then 'PASS' else 'FAIL' end as c8
from (select count(*) cnt, sum(d) sd, sum(e) se, sum((a*10+b)*rn) ord
      from (select a, b, d, e, rownum rn
            from (select /*+ USE_MERGE */ tc.a a, tc.b b, tc.d d, td.e e from tc, td
                  where tc.a = td.a and tc.b = td.b
                  using index i_tc_a(+), i_td_ab(+) order by tc.a, tc.b) x) y) m,
     (select count(*) cnt, sum(d) sd, sum(e) se, sum((a*10+b)*rn) ord
      from (select a, b, d, e, rownum rn
            from (select /*+ USE_NL */ tc.a a, tc.b b, tc.d d, td.e e from tc, td
                  where tc.a = td.a and tc.b = td.b
                  using index none order by tc.a, tc.b) x) y) n;

-- C9. NULL join keys on both sides never join (inner join); anchor: no NULL a in the output
select case when m.cnt<=>n.cnt and m.sb<=>n.sb and m.sc<=>n.sc and m.nn<=>0 and n.nn<=>0
       then 'PASS' else 'FAIL' end as c9
from (select count(*) cnt, sum(b) sb, sum(c) sc, sum(case when a is null then 1 else 0 end) nn
      from (select /*+ USE_MERGE */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
            using index i_ta_a(+), i_tb_a(+)) z) m,
     (select count(*) cnt, sum(b) sb, sum(c) sc, sum(case when a is null then 1 else 0 end) nn
      from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
            using index none) z) n;

-- C10. LEFT OUTER join: preserved-side rows with NULL key must survive (15 NULL keys in ta)
select case when m.cnt<=>n.cnt and m.nn<=>n.nn and m.nulls<=>15 and m.sb<=>n.sb and m.sc<=>n.sc
       then 'PASS' else 'FAIL' end as c10
from (select count(*) cnt, sum(case when c is null then 1 else 0 end) nn,
             sum(case when a is null then 1 else 0 end) nulls, sum(b) sb, sum(c) sc
      from (select /*+ USE_MERGE */ ta.a a, ta.b b, tb.c c from ta left outer join tb on ta.a = tb.a
            using index i_ta_a(+), i_tb_a(+)) z) m,
     (select count(*) cnt, sum(case when c is null then 1 else 0 end) nn,
             sum(case when a is null then 1 else 0 end) nulls, sum(b) sb, sum(c) sc
      from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c from ta left outer join tb on ta.a = tb.a
            using index none) z) n;

-- C11. DESC index on the join column: must not be used as a sorted input, result correct
select case when m.cnt<=>n.cnt and m.sf<=>n.sf and m.sb<=>n.sb and m.ord<=>n.ord then 'PASS' else 'FAIL' end as c11
from (select count(*) cnt, sum(f) sf, sum(b) sb, sum(a*rn) ord
      from (select a, b, f, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b, te.f f from ta, te where ta.a = te.a
                  using index i_ta_a(+), i_te_a_desc(+) order by ta.a) x) y) m,
     (select count(*) cnt, sum(f) sf, sum(b) sb, sum(a*rn) ord
      from (select a, b, f, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, te.f f from ta, te where ta.a = te.a
                  using index none order by ta.a) x) y) n;

-- C12. range sarg on the indexed join column (ordered range scan feeds the merge)
select case when m.cnt<=>n.cnt and m.sb<=>n.sb and m.sc<=>n.sc and m.ord<=>n.ord then 'PASS' else 'FAIL' end as c12
from (select count(*) cnt, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b, tb.c c from ta, tb
                  where ta.a = tb.a and ta.a between 50 and 120 and tb.a > 60
                  using index i_ta_a(+), i_tb_a(+) order by ta.a) x) y) m,
     (select count(*) cnt, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c from ta, tb
                  where ta.a = tb.a and ta.a between 50 and 120 and tb.a > 60
                  using index none order by ta.a) x) y) n;

-- trace sanity: C13 shape -- PARALLEL hint; the sorted merge inputs must not run as parallel scans
set trace on;
select /*+ PARALLEL(4) USE_MERGE */ ta.a, ta.b, tb.c from ta, tb where ta.a = tb.a
using index i_ta_a(+), i_tb_a(+) order by ta.a limit 1;
show trace;
set trace off;

-- C13. PARALLEL(4) on the merge query vs serial NL
select case when m.cnt<=>n.cnt and m.sa<=>n.sa and m.sb<=>n.sb and m.sc<=>n.sc and m.ord<=>n.ord
       then 'PASS' else 'FAIL' end as c13
from (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ PARALLEL(4) USE_MERGE */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index i_ta_a(+), i_tb_a(+) order by ta.a) x) y) m,
     (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ NO_PARALLEL_SCAN USE_NL */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index none order by ta.a) x) y) n;

-- C14. IN subquery and EXISTS subquery
select case when m.cnt<=>n.cnt and m.sb<=>n.sb and m.ord<=>n.ord and m2.cnt<=>n2.cnt and m2.sb<=>n2.sb
       then 'PASS' else 'FAIL' end as c14
from (select count(*) cnt, sum(b) sb, sum(a*rn) ord
      from (select a, b, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b from ta where ta.a in (select tb.a from tb)
                  using index i_ta_a(+) order by ta.a) x) y) m,
     (select count(*) cnt, sum(b) sb, sum(a*rn) ord
      from (select a, b, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b from ta where ta.a in (select tb.a from tb)
                  using index none order by ta.a) x) y) n,
     (select count(*) cnt, sum(ta.b) sb from ta
      where exists (select /*+ USE_MERGE */ 1 from tb where tb.a = ta.a using index i_tb_a(+))) m2,
     (select count(*) cnt, sum(ta.b) sb from ta
      where exists (select /*+ USE_NL */ 1 from tb where tb.a = ta.a using index none)) n2;

-- C15. derived table (GROUP BY on tb) as the inner merge input: only the outer can skip
select case when m.cnt<=>n.cnt and m.sb<=>n.sb and m.ss<=>n.ss and m.ord<=>n.ord then 'PASS' else 'FAIL' end as c15
from (select count(*) cnt, sum(b) sb, sum(s) ss, sum(a*rn) ord
      from (select a, b, s, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b, d.s s
                  from ta, (select a, sum(c) s from tb group by a) d where ta.a = d.a
                  using index i_ta_a(+) order by ta.a) x) y) m,
     (select count(*) cnt, sum(b) sb, sum(s) ss, sum(a*rn) ord
      from (select a, b, s, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, d.s s
                  from ta, (select a, sum(c) s from tb group by a) d where ta.a = d.a
                  using index none order by ta.a) x) y) n;

-- C16. correlated scalar subquery in the select list over the merge
select case when m.cnt<=>n.cnt and m.sv<=>n.sv and m.ord<=>n.ord then 'PASS' else 'FAIL' end as c16
from (select count(*) cnt, sum(v) sv, sum(a*rn) ord
      from (select a, v, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, (select count(*) from te where te.a = ta.a) v
                  from ta, tb where ta.a = tb.a
                  using index i_ta_a(+), i_tb_a(+) order by ta.a) x) y) m,
     (select count(*) cnt, sum(v) sv, sum(a*rn) ord
      from (select a, v, rownum rn
            from (select /*+ USE_NL */ ta.a a, (select count(*) from te where te.a = ta.a) v
                  from ta, tb where ta.a = tb.a
                  using index none order by ta.a) x) y) n;

-- trace sanity: C17 shape -- the upper merge reads the lower merge result without sorting it
-- (ORDERBY page 0 on the list-scan input), both lower inputs sorted, no top ORDERBY
set trace on;
select /*+ USE_MERGE */ ta.a, ta.b, tb.c, te.f from ta, tb, te
where ta.a = tb.a and tb.a = te.a and ta.a < 60
using index i_ta_a(+), i_tb_a(+), te.none order by ta.a limit 1;
show trace;
set trace off;

-- C17. three-table merge chain on the same join column
select case when m.cnt<=>n.cnt and m.sb<=>n.sb and m.sc<=>n.sc and m.sf<=>n.sf and m.ord<=>n.ord
       then 'PASS' else 'FAIL' end as c17
from (select count(*) cnt, sum(b) sb, sum(c) sc, sum(f) sf, sum(a*rn) ord
      from (select a, b, c, f, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b, tb.c c, te.f f from ta, tb, te
                  where ta.a = tb.a and tb.a = te.a and ta.a < 60
                  using index i_ta_a(+), i_tb_a(+), te.none order by ta.a) x) y) m,
     (select count(*) cnt, sum(b) sb, sum(c) sc, sum(f) sf, sum(a*rn) ord
      from (select a, b, c, f, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c, te.f f from ta, tb, te
                  where ta.a = tb.a and tb.a = te.a and ta.a < 60
                  using index none order by ta.a) x) y) n;

-- C18. GROUP BY the join column over the merge
select case when m.cnt<=>n.cnt and m.sg<=>n.sg and m.sk<=>n.sk then 'PASS' else 'FAIL' end as c18
from (select count(*) cnt, sum(g) sg, sum(k) sk
      from (select /*+ USE_MERGE */ ta.a k, count(*) g from ta, tb where ta.a = tb.a
            group by ta.a using index i_ta_a(+), i_tb_a(+)) z) m,
     (select count(*) cnt, sum(g) sg, sum(k) sk
      from (select /*+ USE_NL */ ta.a k, count(*) g from ta, tb where ta.a = tb.a
            group by ta.a using index none) z) n;

-- C19. DISTINCT + ORDER BY over the merge
select case when m.cnt<=>n.cnt and m.sa<=>n.sa and m.ord<=>n.ord then 'PASS' else 'FAIL' end as c19
from (select count(*) cnt, sum(a) sa, sum(a*rn) ord
      from (select a, rownum rn
            from (select /*+ USE_MERGE */ distinct ta.a a from ta, tb where ta.a = tb.a
                  using index i_ta_a(+), i_tb_a(+) order by ta.a) x) y) m,
     (select count(*) cnt, sum(a) sa, sum(a*rn) ord
      from (select a, rownum rn
            from (select /*+ USE_NL */ distinct ta.a a from ta, tb where ta.a = tb.a
                  using index none order by ta.a) x) y) n;

-- C20. expression join term: no index order available, merge must still sort and be correct
select case when m.cnt<=>n.cnt and m.sb<=>n.sb and m.sc<=>n.sc and m.ord<=>n.ord then 'PASS' else 'FAIL' end as c20
from (select count(*) cnt, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a + 0
                  using index i_ta_a(+), i_tb_a(+) order by ta.a) x) y) m,
     (select count(*) cnt, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a + 0
                  using index none order by ta.a) x) y) n;


-- trace sanity: C21 shape -- no join hint, no index pin, no LIMIT: the cost model picks
-- "MERGE JOIN" over the two index scans with ORDERBY page 0 on both inputs (sorts skipped).
-- (With LIMIT or with pinned indexes the cheaper idx-join wins instead, so neither is used here.)
set trace on;
select count(*) from (select ta.a, ta.b, tb.c from ta, tb where ta.a = tb.a order by ta.a) x;
show trace;
set trace off;

-- C21. no join hint: whatever the cost model picks must be correct and ordered
select case when m.cnt<=>n.cnt and m.sa<=>n.sa and m.sb<=>n.sb and m.sc<=>n.sc and m.ord<=>n.ord
       then 'PASS' else 'FAIL' end as c21
from (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  order by ta.a) x) y) m,
     (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index none order by ta.a) x) y) n;

-- trace sanity: C22 shape -- parameter off: the develop plan comes back. Expect "SORT (order by)"
-- on top (the final sort is kept), tb as "TABLE SCAN" (no range-less index scan candidate even with
-- the (+) pin) and both inputs sorted by the executor before the merge.
-- The query text differs from the C1 trace query ('off' column) so the XASL cache cannot hand back
-- the plan compiled while the parameter was on.
set system parameters 'optimizer_enable_merge_join=no';
set trace on;
select /*+ USE_MERGE */ ta.a, ta.b, tb.c, 'off' from ta, tb where ta.a = tb.a
using index i_ta_a(+), i_tb_a(+) order by ta.a limit 1;
show trace;
set trace off;

-- C22. parameter off + USE_MERGE: same rows and order as the NL reference
select case when m.cnt<=>n.cnt and m.sa<=>n.sa and m.sb<=>n.sb and m.sc<=>n.sc and m.ord<=>n.ord
       then 'PASS' else 'FAIL' end as c22
from (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_MERGE */ ta.a a, ta.b b, tb.c c, 'off' z from ta, tb where ta.a = tb.a
                  using index i_ta_a(+), i_tb_a(+) order by ta.a) x) y) m,
     (select count(*) cnt, sum(a) sa, sum(b) sb, sum(c) sc, sum(a*rn) ord
      from (select a, b, c, rownum rn
            from (select /*+ USE_NL */ ta.a a, ta.b b, tb.c c from ta, tb where ta.a = tb.a
                  using index none order by ta.a) x) y) n;

set system parameters 'optimizer_enable_merge_join=yes';

drop table if exists ta, tb, tc, td, te;

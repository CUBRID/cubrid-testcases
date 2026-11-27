/**
 * This test case verifies CBRD-26846 : the buildvalue optimization of the
 * parallel heap scan (GROUP BY-less aggregate, "gather: buildvalue") now
 * supports 11 more aggregate functions.
 *
 * Before: only COUNT/MIN/MAX/SUM/AVG and the STDDEV/VARIANCE families qualified. A query that
 * used any other aggregate was demoted as a whole to the slower
 * "gather: row by row" path.
 *
 * Fix (engine PR #7229): BIT_AND/BIT_OR/BIT_XOR, JSON_ARRAYAGG, JSON_OBJECTAGG,
 * GROUP_CONCAT (with or without ORDER BY / DISTINCT), MEDIAN, PERCENTILE_CONT,
 * PERCENTILE_DISC, CUME_DIST and PERCENT_RANK are accepted. Workers either
 * merge partial values (BIT_*, JSON_*, GROUP_CONCAT without ORDER BY), add up
 * partial counters (CUME_DIST, PERCENT_RANK) or collect raw values into lists
 * that the main thread chains and finalizes (MEDIAN, PERCENTILE_*,
 * GROUP_CONCAT with ORDER BY, DISTINCT).
 *
 * The functions already supported before (COUNT/MIN/MAX/SUM/AVG/STDDEV/
 * VARIANCE) are covered by cbrd_26711 and are only used here next to the new
 * ones.
 *
 * Self-checking: Cases 2 to 12 and 16 to 19 and 22 to 27 run the aggregate twice
 * in one statement, a PARALLEL(8) sub-query and a NO_PARALLEL_SCAN sub-query, and
 * compare them with the null-safe <=>, emitting PASS/FAIL. Cases 13 to 15, 20, 21
 * and 29 instead run the PARALLEL(8) query and its NO_PARALLEL_SCAN twin as two
 * statements. Cases 13 to 15 print the error of each side. Cases 20, 21 and 29
 * print the values, because for most of the new aggregates no other test case prints the
 * serial values over no row or one row, so a comparison alone would have nothing
 * to stand on there. Each check runs under trace so the answer
 * also pins "gather: buildvalue" on the parallel side and no parallel workers on
 * the serial side. A run that silently fell back to a
 * serial scan would otherwise PASS while testing nothing. Worker counts and
 * row counts in the trace are masked by CTP. Case 28 starts with one such
 * comparison and then prints the value of each statement, because the cache fault
 * it checks shows only as a value that differs with and without DISTINCT, and its
 * NO_PARALLEL_SCAN statements after the first two and its view query have no trace.
 *
 * Order-sensitive results (JSON element/key order, GROUP_CONCAT without
 * ORDER BY) depend on the worker finish order, so those checks compare
 * order-insensitive properties (json_length, json_type, length) instead of
 * the value itself. Case 18 is the exception, as its comment explains.
 *
 * Table and column names have no digits so CTP does not mask them.
 * cola = id % 100 (100 values x 100), colb = lpad(id % 20, 10, 0)
 * (20 values, used as duplicate JSON keys), nval/nstr are always NULL,
 * pnull = id % 50 but NULL when id % 7 = 0, dt advances one millisecond per row.
 *
 * BIT_AND/BIT_OR over cola give the same partial value (0/127) in every
 * worker, so Case 1 and 2 add expressions where only the row id = 5000
 * differs; a wrong merge of that one partial changes the result.
 *
 * Coverage:
 *   Case 1:  all new functions in one query, values printed (deterministic),
 *            BIT_AND/BIT_OR with a single differing row
 *   Case 2:  BIT_AND/OR/XOR + MEDIAN next to COUNT/MIN/MAX/SUM/AVG,
 *            BIT_AND/BIT_OR with a single differing row
 *   Case 3:  MEDIAN with a predicate
 *   Case 4:  GROUP_CONCAT DISTINCT ORDER BY asc / desc
 *   Case 5:  GROUP_CONCAT ORDER BY without DISTINCT (raw value list)
 *   Case 6:  GROUP_CONCAT without ORDER BY (partial merge, length compared)
 *   Case 7:  PERCENTILE_CONT / PERCENTILE_DISC
 *   Case 8:  CUME_DIST / PERCENT_RANK
 *   Case 9:  JSON_ARRAYAGG / JSON_OBJECTAGG cardinality
 *   Case 10: all-NULL column (BIT_AND, MEDIAN, GROUP_CONCAT, JSON_ARRAYAGG)
 *   Case 11: list-based and partial aggregates on the same column
 *   Case 12: JSON_OBJECTAGG duplicate keys stay single-valued, never an array
 *   Case 13: PERCENTILE_CONT constant out of range -> same error on both sides
 *   Case 14: PERCENTILE_DISC sub-query out of range -> same error on both sides
 *   Case 15: JSON_OBJECTAGG NULL key in one row -> the worker error reaches the
 *            main thread, same error as serial
 *   Case 16: CUME_DIST with two sort keys, PERCENT_RANK DESC NULLS FIRST
 *   Case 17: MEDIAN / PERCENTILE_CONT / PERCENTILE_DISC skip NULLs
 *   Case 18: GROUP_CONCAT DISTINCT without ORDER BY, and the default separator
 *   Case 19: GROUP_CONCAT with a multi-character separator, without ORDER BY and
 *            with ORDER BY DESC
 *   Case 20: predicate matching no row, values printed beside the serial twin
 *   Case 21: predicate matching exactly one row, values printed beside the serial twin
 *   Case 22: interpolation over DATETIME and VARCHAR
 *   Case 23: JSON_ARRAYAGG keeps NULLs as elements, MEDIAN skips them
 *   Case 24: JSON_OBJECTAGG with a NULL value keeps the key
 *   Case 25: JSON_OBJECTAGG duplicate key keeps a value that really occurs
 *   Case 26: STDDEV and VARIANCE families next to the new aggregates
 *   Case 27: explicit PARALLEL(2) hint
 *   Case 28: MEDIAN with DISTINCT - over INT, NUMERIC and VARCHAR beside
 *            COUNT and SUM with DISTINCT, a plain MEDIAN after it and before it on
 *            a table of its own without recompile, and a view keeps DISTINCT
 *   Case 29: GROUP_CONCAT without ORDER BY cut at group_concat_max_len, values
 *            printed beside the serial twin
 *
 * Cases 20, 21, 22 and 27 are the edge shapes cbrd_26711 already applies to the
 * aggregates that were supported before this issue; they are repeated here for
 * the eleven the issue adds.
 *
 * MEDIAN with DISTINCT, Case 28, was reported on CBRD-26846 while this test case
 * was written and fixed by engine PR #8578. Before the fix it failed in two ways.
 *   - A worker wrote the operand into its distinct list without casting it to
 *     the MEDIAN result domain, so a debug server aborted and a release server
 *     returned a wrong value. The serial scan was right.
 *   - MEDIAN(DISTINCT k) was printed as median(k), and the printed query is the
 *     XASL cache key, so MEDIAN(DISTINCT k) and MEDIAN(k) on one table shared the
 *     plan that was compiled first, serial and parallel alike, and a view lost
 *     DISTINCT.
 * bvx cannot show the second fault: its cola is uniform, so MEDIAN(DISTINCT cola)
 * and MEDIAN(cola) are equal. Case 28 therefore uses two tables of its own whose k
 * gives different values with and without DISTINCT, runs the two statements in
 * both orders without a recompile hint, and checks the view text.
 * BIT_AND / BIT_OR / BIT_XOR with DISTINCT, the other fault reported there, became
 * CBRD-28153, and its test case sql/_13_issues/_26_2h/cases/cbrd_28153.sql checks
 * it on the parallel buildvalue path as well, so this file does not repeat it.
 * The DISTINCT shapes that do work are covered: GROUP_CONCAT in Cases 4 and 18,
 * alone and beside a non-DISTINCT GROUP_CONCAT, and over no row and one row in
 * Cases 20 and 21. PERCENTILE_CONT /
 * PERCENTILE_DISC / CUME_DIST / PERCENT_RANK have no DISTINCT form, and
 * JSON_ARRAYAGG / JSON_OBJECTAGG reject DISTINCT at parse time.
 */

drop table if exists bvx;
-- 10000 rows with three md5 strings each (incompressible): 117 heap pages
-- (SHOW HEAP CAPACITY), well above the parallel heap scan threshold of 32 pages
-- that CTP sets with test_mode=yes, so every scan of bvx without NO_PARALLEL_SCAN
-- runs in parallel and spreads over several workers
create table bvx (id int, cola int, colb varchar(10), nval int, nstr varchar(10), pad varchar(100),
                  pnull int, dt datetime);
insert into bvx
select rownum, rownum % 100, lpad(to_char(rownum % 20), 10, '0'), null, null,
       concat(md5(rownum), md5(rownum + 7919), md5(rownum * 31 + 7)),
       case when rownum % 7 = 0 then null else rownum % 50 end,
       to_datetime('2026-09-29 00:00:00.000', 'YYYY-MM-DD HH24:MI:SS.FF') + rownum
from db_class a, db_class b, db_class c, db_class d, db_class e limit 10000;

drop view if exists vmd;
drop table if exists bvm, bvn;
-- Case 28 only: 6000 rows with three md5 strings each, past the parallel heap scan
-- threshold of 32 pages under CTP. k is NULL in 10 percent of the rows, a multiple
-- of 4 from 0 to 96 in 25 percent and 0 in the rest, so MEDIAN with and without
-- DISTINCT differ, and n and v hold k as NUMERIC and as VARCHAR. bvn is a copy, so
-- that each of the two tables gets its first MEDIAN plan in Case 28.
create table bvm (id int, k int, n numeric(10,2), v varchar(10), pad varchar(100));
insert into bvm
select id, k, k / 4.0, cast(k as varchar(10)), pad
from (select rownum id, case when rownum % 10 = 3 then null when rownum % 4 = 0 then rownum % 100 else 0 end k,
             concat(md5(rownum), md5(rownum + 7919), md5(rownum * 31 + 7)) pad
      from db_class a, db_class b, db_class c, db_class d, db_class e limit 6000) x;
create table bvn like bvm;
insert into bvn select * from bvm;

set trace on;

evaluate 'Case 1: all new functions in one query -> gather: buildvalue';
-- DOUBLE results are cast to NUMERIC so the printed digits do not depend on the driver
select /*+ recompile PARALLEL(8) */ bit_and(cola), bit_or(cola), bit_xor(cola), cast(median(cola) as numeric(12,4)),
       cast(percentile_cont(0.3) within group (order by cola) as numeric(12,4)),
       percentile_disc(0.3) within group (order by cola),
       cast(cume_dist(50) within group (order by cola) as numeric(12,4)),
       cast(percent_rank(50) within group (order by cola) as numeric(12,4)),
       group_concat(distinct cola order by cola desc separator ','),
       json_length(json_arrayagg(colb)), json_length(json_objectagg(colb, cola)),
       bit_and(case when id = 5000 then 254 else 255 end), bit_or(case when id = 5000 then 1 else 0 end)
from bvx;
show trace;

evaluate 'Case 2: BIT_AND/OR/XOR and MEDIAN next to COUNT/MIN/MAX/SUM/AVG';
select /*+ recompile */ case when p.c<=>s.c and p.mn<=>s.mn and p.mx<=>s.mx and p.sm<=>s.sm and p.av<=>s.av
            and p.ba<=>s.ba and p.bo<=>s.bo and p.bx<=>s.bx and p.md<=>s.md
            and p.ba2<=>s.ba2 and p.bo2<=>s.bo2 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, min(cola) mn, max(cola) mx, sum(cola) sm, avg(cola) av,
             bit_and(cola) ba, bit_or(cola) bo, bit_xor(id) bx, median(cola) md,
             bit_and(case when id = 5000 then 254 else 255 end) ba2,
             bit_or(case when id = 5000 then 1 else 0 end) bo2 from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, min(cola) mn, max(cola) mx, sum(cola) sm, avg(cola) av,
             bit_and(cola) ba, bit_or(cola) bo, bit_xor(id) bx, median(cola) md,
             bit_and(case when id = 5000 then 254 else 255 end) ba2,
             bit_or(case when id = 5000 then 1 else 0 end) bo2 from bvx) s;
show trace;

evaluate 'Case 3: MEDIAN with a predicate';
select /*+ recompile */ case when p.v<=>s.v then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ median(id) v from bvx where cola > 50) p,
     (select /*+ NO_PARALLEL_SCAN */ median(id) v from bvx where cola > 50) s;
show trace;

evaluate 'Case 4: GROUP_CONCAT DISTINCT ORDER BY asc / desc';
select /*+ recompile */ case when p.a<=>s.a and p.d<=>s.d then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ group_concat(distinct cola order by cola separator ',') a,
             group_concat(distinct cola order by cola desc separator '-') d from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ group_concat(distinct cola order by cola separator ',') a,
             group_concat(distinct cola order by cola desc separator '-') d from bvx) s;
show trace;

evaluate 'Case 5: GROUP_CONCAT ORDER BY without DISTINCT';
select /*+ recompile */ case when p.g<=>s.g then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ group_concat(id order by id separator ',') g from bvx where cola = 7) p,
     (select /*+ NO_PARALLEL_SCAN */ group_concat(id order by id separator ',') g from bvx where cola = 7) s;
show trace;

evaluate 'Case 6: GROUP_CONCAT without ORDER BY (element order depends on workers)';
select /*+ recompile */ case when p.l<=>s.l then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ length(group_concat(colb separator ',')) l from bvx where id % 200 = 0) p,
     (select /*+ NO_PARALLEL_SCAN */ length(group_concat(colb separator ',')) l from bvx where id % 200 = 0) s;
show trace;

evaluate 'Case 7: PERCENTILE_CONT / PERCENTILE_DISC';
select /*+ recompile */ case when p.c<=>s.c and p.d<=>s.d and p.c2<=>s.c2 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ percentile_cont(0.5) within group (order by cola) c,
             percentile_disc(0.25) within group (order by cola) d,
             percentile_cont(0.9) within group (order by id) c2 from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ percentile_cont(0.5) within group (order by cola) c,
             percentile_disc(0.25) within group (order by cola) d,
             percentile_cont(0.9) within group (order by id) c2 from bvx) s;
show trace;

evaluate 'Case 8: CUME_DIST / PERCENT_RANK';
select /*+ recompile */ case when p.c<=>s.c and p.r<=>s.r then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ cume_dist(50) within group (order by cola) c,
             percent_rank(50) within group (order by cola) r from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ cume_dist(50) within group (order by cola) c,
             percent_rank(50) within group (order by cola) r from bvx) s;
show trace;

evaluate 'Case 9: JSON_ARRAYAGG / JSON_OBJECTAGG cardinality';
select /*+ recompile */ case when p.al<=>s.al and p.ol<=>s.ol then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ json_length(json_arrayagg(colb)) al, json_length(json_objectagg(to_char(id), cola)) ol
      from bvx where id <= 2000) p,
     (select /*+ NO_PARALLEL_SCAN */ json_length(json_arrayagg(colb)) al, json_length(json_objectagg(to_char(id), cola)) ol
      from bvx where id <= 2000) s;
show trace;

evaluate 'Case 10: all-NULL column';
select /*+ recompile */ case when p.ba<=>s.ba and p.md<=>s.md and p.gc<=>s.gc and p.jl<=>s.jl then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ bit_and(nval) ba, median(nval) md, group_concat(nstr separator ',') gc,
             json_length(json_arrayagg(nstr)) jl from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ bit_and(nval) ba, median(nval) md, group_concat(nstr separator ',') gc,
             json_length(json_arrayagg(nstr)) jl from bvx) s;
show trace;

evaluate 'Case 11: list-based and partial aggregates on the same column';
select /*+ recompile */ case when p.g<=>s.g and p.md<=>s.md and p.mn<=>s.mn and p.mx<=>s.mx and p.sm<=>s.sm
            and p.ol<=>s.ol then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ group_concat(distinct cola order by cola separator ',') g, median(cola) md,
             min(cola) mn, max(cola) mx, sum(cola) sm, json_length(json_objectagg(to_char(id), cola)) ol from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ group_concat(distinct cola order by cola separator ',') g, median(cola) md,
             min(cola) mn, max(cola) mx, sum(cola) sm, json_length(json_objectagg(to_char(id), cola)) ol from bvx) s;
show trace;

evaluate 'Case 12: JSON_OBJECTAGG duplicate keys stay single-valued';
-- which duplicate wins depends on the workers, so only the key count and the value type are compared
select /*+ recompile */ case when p.kc<=>s.kc and p.vt<=>s.vt and p.vt <> 'JSON_ARRAY' then 'PASS' else 'FAIL' end as result
from (select json_length(o) kc, json_type(json_extract(o, '$."0000000000"')) vt
      from (select /*+ PARALLEL(8) */ json_objectagg(colb, cola) o from bvx) x) p,
     (select json_length(o) kc, json_type(json_extract(o, '$."0000000000"')) vt
      from (select /*+ NO_PARALLEL_SCAN */ json_objectagg(colb, cola) o from bvx) x) s;
show trace;

evaluate 'Case 13: PERCENTILE_CONT constant out of range';
select /*+ recompile PARALLEL(8) */ percentile_cont(1.5) within group (order by cola) from bvx;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ percentile_cont(1.5) within group (order by cola) from bvx;
show trace;

evaluate 'Case 14: PERCENTILE_DISC sub-query out of range';
select /*+ recompile PARALLEL(8) */ percentile_disc((select 1.5 from db_root)) within group (order by cola) from bvx;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ percentile_disc((select 1.5 from db_root)) within group (order by cola) from bvx;
show trace;

evaluate 'Case 15: JSON_OBJECTAGG NULL key in one row';
select /*+ recompile PARALLEL(8) */ json_objectagg(case when id = 5000 then null else to_char(id) end, cola) from bvx;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ json_objectagg(case when id = 5000 then null else to_char(id) end, cola) from bvx;
show trace;

evaluate 'Case 16: CUME_DIST with two sort keys, PERCENT_RANK DESC NULLS FIRST';
select /*+ recompile */ case when p.c<=>s.c and p.r<=>s.r then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ cume_dist(50, '0000000005') within group (order by cola, colb desc) c,
             percent_rank(20) within group (order by pnull desc nulls first) r from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ cume_dist(50, '0000000005') within group (order by cola, colb desc) c,
             percent_rank(20) within group (order by pnull desc nulls first) r from bvx) s;
show trace;

evaluate 'Case 17: MEDIAN / PERCENTILE_CONT / PERCENTILE_DISC skip NULLs';
select /*+ recompile */ case when p.md<=>s.md and p.c<=>s.c and p.d<=>s.d then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ median(pnull) md, percentile_cont(0.3) within group (order by pnull) c,
             percentile_disc(0.7) within group (order by pnull desc) d from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ median(pnull) md, percentile_cont(0.3) within group (order by pnull) c,
             percentile_disc(0.7) within group (order by pnull desc) d from bvx) s;
show trace;

evaluate 'Case 18: GROUP_CONCAT DISTINCT without ORDER BY, and the default separator';
-- the fourth of the four GROUP_CONCAT shapes the issue names. Cases 4, 5 and 6
-- cover DISTINCT+ORDER BY, ORDER BY alone and neither; DISTINCT alone is the one
-- left, and it reaches the distinct-list path without a sort key. The third
-- column is the same aggregate without DISTINCT, so a distinct list and a plain
-- list are built and chained over one scan. Unlike Cases 6 and 9, the first column
-- is compared as a whole string although it has no ORDER BY: the finalize step
-- removes the duplicates of a DISTINCT list by sorting it, and without a sort key
-- it sorts by the value itself, so both sides join the values in the same order.
-- If DISTINCT stops sorting, this case fails without a defect in the merge.
-- id % 125 = 0 picks 80 rows spread over the whole heap, so more than one worker
-- holds a part of each list, and cola takes only four values among them, so the
-- distinct lists of different workers share values that the merge has to remove.
select /*+ recompile */ case when p.g<=>s.g and p.d<=>s.d and p.a<=>s.a then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ group_concat(distinct cola separator ',') g,
             group_concat(distinct cola order by 1) d,
             group_concat(cola order by 1) a from bvx where id % 125 = 0) p,
     (select /*+ NO_PARALLEL_SCAN */ group_concat(distinct cola separator ',') g,
             group_concat(distinct cola order by 1) d,
             group_concat(cola order by 1) a from bvx where id % 125 = 0) s;
show trace;

evaluate 'Case 19: GROUP_CONCAT with a multi-character separator, without ORDER BY and with ORDER BY DESC';
-- the separator lives in accumulator.value2 as metadata and is left out of the worker
-- re-home. It joins two partial strings only without ORDER BY: with ORDER BY the
-- workers collect values into lists and the main thread joins them as a serial scan
-- does. Column l has no ORDER BY and compares the length as Case 6 does, since the
-- element order depends on the workers; column g keeps ORDER BY DESC. id % 125 = 0
-- spreads 80 rows over the whole heap so more than one worker holds a partial string,
-- and keeps the result shorter than group_concat_max_len, so the whole string is
-- compared rather than a truncated prefix.
select /*+ recompile */ case when p.l<=>s.l and p.g<=>s.g then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ length(group_concat(colb separator '<>')) l,
             group_concat(colb order by 1 desc separator '<>') g from bvx where id % 125 = 0) p,
     (select /*+ NO_PARALLEL_SCAN */ length(group_concat(colb separator '<>')) l,
             group_concat(colb order by 1 desc separator '<>') g from bvx where id % 125 = 0) s;
show trace;

evaluate 'Case 20: predicate matching no row, values printed beside the serial twin';
-- every worker ends with an untouched accumulator and an empty list, and the merge has
-- to drop them all. The serial twin prints the same columns, so the answer file holds
-- the values of both and a defect shared by both still shows in the values. The
-- DISTINCT aggregates at the end merge distinct lists, a branch of their own.
select /*+ recompile PARALLEL(8) */ count(*), bit_and(cola), bit_or(cola), bit_xor(cola),
       cast(cast(median(cola) as numeric(12,4)) as varchar(20)), group_concat(cola separator ','),
       json_arrayagg(colb), json_objectagg(colb, cola),
       cast(cast(percentile_cont(0.5) within group (order by cola) as numeric(12,4)) as varchar(20)),
       percentile_disc(0.5) within group (order by cola),
       cast(cast(cume_dist(50) within group (order by cola) as numeric(12,4)) as varchar(20)),
       cast(cast(percent_rank(50) within group (order by cola) as numeric(12,4)) as varchar(20)),
       count(distinct cola), sum(distinct cola),
       group_concat(distinct cola separator ','), group_concat(distinct cola order by 1)
from bvx where cola < 0;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ count(*), bit_and(cola), bit_or(cola), bit_xor(cola),
       cast(cast(median(cola) as numeric(12,4)) as varchar(20)), group_concat(cola separator ','),
       json_arrayagg(colb), json_objectagg(colb, cola),
       cast(cast(percentile_cont(0.5) within group (order by cola) as numeric(12,4)) as varchar(20)),
       percentile_disc(0.5) within group (order by cola),
       cast(cast(cume_dist(50) within group (order by cola) as numeric(12,4)) as varchar(20)),
       cast(cast(percent_rank(50) within group (order by cola) as numeric(12,4)) as varchar(20)),
       count(distinct cola), sum(distinct cola),
       group_concat(distinct cola separator ','), group_concat(distinct cola order by 1)
from bvx where cola < 0;
show trace;

evaluate 'Case 21: predicate matching exactly one row, values printed beside the serial twin';
-- one worker holds the only row and the other seven merge empty partials, which is
-- the shape that catches a merge treating an untouched partial as a value. The row
-- id = 5037 has a cola other than 0, so a value lost in the merge does not pass for
-- the right one, and a single row fixes the JSON order, so whole values print.
-- PERCENT_RANK takes a hypothetical value above that cola and CUME_DIST one below
-- it, so for both the one row changes the result and a lost row shows. The DISTINCT
-- aggregates at the end bring a distinct list of one value from one worker and empty
-- ones from the others.
select /*+ recompile PARALLEL(8) */ count(*), bit_and(cola), bit_or(cola), bit_xor(cola),
       cast(cast(median(cola) as numeric(12,4)) as varchar(20)), group_concat(cola separator ','),
       json_arrayagg(colb), json_objectagg(colb, cola),
       cast(cast(percentile_cont(0.5) within group (order by cola) as numeric(12,4)) as varchar(20)),
       percentile_disc(0.5) within group (order by cola),
       cast(cast(cume_dist(30) within group (order by cola) as numeric(12,4)) as varchar(20)),
       cast(cast(percent_rank(40) within group (order by cola) as numeric(12,4)) as varchar(20)),
       count(distinct cola), sum(distinct cola),
       group_concat(distinct cola separator ','), group_concat(distinct cola order by 1)
from bvx where id = 5037;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ count(*), bit_and(cola), bit_or(cola), bit_xor(cola),
       cast(cast(median(cola) as numeric(12,4)) as varchar(20)), group_concat(cola separator ','),
       json_arrayagg(colb), json_objectagg(colb, cola),
       cast(cast(percentile_cont(0.5) within group (order by cola) as numeric(12,4)) as varchar(20)),
       percentile_disc(0.5) within group (order by cola),
       cast(cast(cume_dist(30) within group (order by cola) as numeric(12,4)) as varchar(20)),
       cast(cast(percent_rank(40) within group (order by cola) as numeric(12,4)) as varchar(20)),
       count(distinct cola), sum(distinct cola),
       group_concat(distinct cola separator ','), group_concat(distinct cola order by 1)
from bvx where id = 5037;
show trace;

evaluate 'Case 22: interpolation over DATETIME and VARCHAR';
-- a worker casts the value it collects into the aggregate domain on a private copy
-- before pushing it to its list. Cases 1 to 17 only interpolate over INT, so a cast
-- that is wrong for a temporal or a string domain is not reached there. dt advances
-- one millisecond per row, so all 10000 values differ.
select /*+ recompile */ case when p.md<=>s.md and p.pc<=>s.pc and p.pd<=>s.pd and p.ps<=>s.ps
            then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ median(dt) md, percentile_cont(0.3) within group (order by dt) pc,
             percentile_disc(0.7) within group (order by dt) pd,
             percentile_disc(0.5) within group (order by colb) ps from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ median(dt) md, percentile_cont(0.3) within group (order by dt) pc,
             percentile_disc(0.7) within group (order by dt) pd,
             percentile_disc(0.5) within group (order by colb) ps from bvx) s;
show trace;

evaluate 'Case 23: JSON_ARRAYAGG keeps NULLs as elements while MEDIAN skips them';
-- a NULL is wrapped into a JSON null and still becomes an element, so the array
-- length equals the row count, while MEDIAN over the same column ignores the NULLs.
-- nn < c proves pnull really does hold NULLs, so jl = c is not a vacuous identity.
select /*+ recompile */ case when p.jl<=>s.jl and p.md<=>s.md and p.c<=>s.c and p.nn<=>s.nn
            and p.jl<=>p.c and p.nn<p.c then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ json_length(json_arrayagg(pnull)) jl, median(pnull) md,
             count(*) c, count(pnull) nn from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ json_length(json_arrayagg(pnull)) jl, median(pnull) md,
             count(*) c, count(pnull) nn from bvx) s;
show trace;

evaluate 'Case 24: JSON_OBJECTAGG with a NULL value keeps the key';
-- the counterpart of Case 15: a NULL key is an error, a NULL value is wrapped into
-- a JSON null and the key survives. nval is NULL in every row and pnull in some, so
-- both the all-NULL and the mixed shape give one key per row.
select /*+ recompile */ case when p.ka<=>s.ka and p.kb<=>s.kb and p.c<=>s.c
            and p.ka<=>p.c and p.kb<=>p.c then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ json_length(json_objectagg(to_char(id), nval)) ka,
             json_length(json_objectagg(to_char(id), pnull)) kb, count(*) c from bvx where id <= 2000) p,
     (select /*+ NO_PARALLEL_SCAN */ json_length(json_objectagg(to_char(id), nval)) ka,
             json_length(json_objectagg(to_char(id), pnull)) kb, count(*) c from bvx where id <= 2000) s;
show trace;

evaluate 'Case 25: JSON_OBJECTAGG duplicate key keeps a value that really occurs';
-- Case 12 shows the duplicate key stays single-valued; which value wins is up to the
-- workers, so this checks that the survivor is one of the values that column really
-- holds for that key. A merge that combined two partial values arithmetically would
-- leave a number that occurs nowhere and still look single-valued.
select /*+ recompile */ case when p.kc<=>s.kc and p.ok<=>1 and s.ok<=>1 then 'PASS' else 'FAIL' end as result
from (select json_length(o) kc,
             case when exists (select 1 from bvx where colb = '0000000000'
                               and cola = cast(json_extract(o, '$."0000000000"') as int)) then 1 else 0 end ok
      from (select /*+ PARALLEL(8) */ json_objectagg(colb, cola) o from bvx) x) p,
     (select json_length(o) kc,
             case when exists (select 1 from bvx where colb = '0000000000'
                               and cola = cast(json_extract(o, '$."0000000000"') as int)) then 1 else 0 end ok
      from (select /*+ NO_PARALLEL_SCAN */ json_objectagg(colb, cola) o from bvx) x) s;
show trace;

evaluate 'Case 26: STDDEV and VARIANCE families next to the new aggregates';
-- the issue asks for mixed queries. Case 2 mixes COUNT/MIN/MAX/SUM/AVG with the new
-- functions; STDDEV and VARIANCE are the aggregates it leaves out, and they are the
-- ones that also carry a second accumulator (the sum of squares) through the merge
-- while the new list-based aggregates chain their lists over the same scan.
select /*+ recompile */ case when p.sd<=>s.sd and p.vp<=>s.vp and p.vs<=>s.vs and p.md<=>s.md and p.gc<=>s.gc
            and p.jl<=>s.jl and p.cd<=>s.cd then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ stddev_samp(cola) sd, var_pop(cola) vp, var_samp(cola) vs, median(cola) md,
             group_concat(distinct cola order by 1 separator ',') gc, json_length(json_arrayagg(colb)) jl,
             cume_dist(50) within group (order by cola) cd from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ stddev_samp(cola) sd, var_pop(cola) vp, var_samp(cola) vs, median(cola) md,
             group_concat(distinct cola order by 1 separator ',') gc, json_length(json_arrayagg(colb)) jl,
             cume_dist(50) within group (order by cola) cd from bvx) s;
show trace;

evaluate 'Case 27: explicit PARALLEL(2) hint';
-- two workers split the rows differently from eight, so the single differing row of
-- the BIT_AND / BIT_OR expressions lands in a different partition and the lists are
-- chained in two pieces instead of eight. CTP masks the worker count and the number
-- inside the hint, so the answer cannot tell 2 from 8; the degree is set by this
-- statement and the answer pins the gather mode and the comparison, as everywhere else.
select /*+ recompile */ case when p.ba<=>s.ba and p.bo<=>s.bo and p.md<=>s.md and p.gc<=>s.gc and p.cd<=>s.cd
            then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(2) */ bit_and(case when id = 5000 then 254 else 255 end) ba,
             bit_or(case when id = 5000 then 1 else 0 end) bo, median(cola) md,
             group_concat(distinct cola order by 1 separator ',') gc,
             cume_dist(50) within group (order by cola) cd from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ bit_and(case when id = 5000 then 254 else 255 end) ba,
             bit_or(case when id = 5000 then 1 else 0 end) bo, median(cola) md,
             group_concat(distinct cola order by 1 separator ',') gc,
             cume_dist(50) within group (order by cola) cd from bvx) s;
show trace;

evaluate 'Case 28: MEDIAN with DISTINCT - parallel equals serial, plain MEDIAN before and after it keeps its own value, a view keeps DISTINCT';
-- the comparison that found the fault, MEDIAN(DISTINCT) next to a plain MEDIAN on bvx
select /*+ recompile */ case when p.dm<=>s.dm and p.md<=>s.md then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ median(distinct cola) dm, median(cola) md from bvx) p,
     (select /*+ NO_PARALLEL_SCAN */ median(distinct cola) dm, median(cola) md from bvx) s;
show trace;
-- each MEDIAN is printed as the DOUBLE it is, not cast to NUMERIC, so that a wrong value close
-- to 0, which the release build returned before the fix, does not print as the right value 0
-- INT, NUMERIC and VARCHAR operands beside COUNT and SUM with DISTINCT and a plain MEDIAN
select /*+ recompile PARALLEL(8) */ median(distinct k), median(distinct n),
       median(distinct v), median(k), count(distinct k), sum(distinct k)
from bvm;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ median(distinct k), median(distinct n),
       median(distinct v), median(k), count(distinct k), sum(distinct k)
from bvm;
show trace;
-- the next eight statements have no recompile hint: a plan that one of them leaves in the
-- cache must not answer the other, so MEDIAN(DISTINCT) first on bvn and plain MEDIAN first on bvm
select /*+ PARALLEL(8) */ median(distinct k) from bvn;
show trace;
select /*+ PARALLEL(8) */ median(k) from bvn;
show trace;
select /*+ NO_PARALLEL_SCAN */ median(distinct k) from bvn;
select /*+ NO_PARALLEL_SCAN */ median(k) from bvn;
select /*+ PARALLEL(8) */ median(k) from bvm;
show trace;
select /*+ PARALLEL(8) */ median(distinct k) from bvm;
show trace;
select /*+ NO_PARALLEL_SCAN */ median(k) from bvm;
select /*+ NO_PARALLEL_SCAN */ median(distinct k) from bvm;
-- the view text keeps DISTINCT, and the view returns the MEDIAN over distinct values
create view vmd as select median(distinct k) m from bvm;
select vclass_def from db_vclass where vclass_name = 'vmd';
select m from vmd;
drop view vmd;

evaluate 'Case 29: GROUP_CONCAT without ORDER BY cut at group_concat_max_len, values printed beside the serial twin';
-- every worker cuts its partial string at group_concat_max_len and the main thread
-- cuts again while it joins the partials, where a serial scan cuts once. The whole
-- heap gives a result far longer than the default group_concat_max_len, which CTP
-- does not change. The element order depends on the workers, so the length is
-- printed, for the multi-character separator of Case 19 and for the default one.
select /*+ recompile PARALLEL(8) */ length(group_concat(colb separator '<>')),
       length(group_concat(cola))
from bvx;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ length(group_concat(colb separator '<>')),
       length(group_concat(cola))
from bvx;
show trace;

set trace off;

drop table if exists bvx, bvm, bvn;

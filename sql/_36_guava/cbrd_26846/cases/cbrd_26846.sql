/*
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
 * Self-checking: every check runs the aggregate twice in one statement, a
 * PARALLEL(8) sub-query and a NO_PARALLEL_SCAN sub-query, and compares them
 * with the null-safe <=>, emitting PASS/FAIL. Each check runs under trace so
 * the answer also pins "gather: buildvalue" on the parallel side and no
 * parallel workers on the serial side. A run that silently fell back to a
 * serial scan would otherwise PASS while testing nothing. Worker counts and
 * row counts in the trace are masked to ? by CTP.
 *
 * Order-sensitive results (JSON element/key order, GROUP_CONCAT without
 * ORDER BY) depend on the worker finish order, so those checks compare
 * order-insensitive properties (json_length, json_type, length) instead of
 * the value itself.
 *
 * Table sizing: 10000 rows with three md5 strings each (incompressible) give
 * about 110 heap pages, well above the parallel scan threshold that the CTP
 * test_mode=yes sets (32 pages), and large enough to spread over several
 * workers. Table and column names have no digits so CTP does not mask them.
 * cola = id % 100 (100 values x 100), colb = lpad(id % 20, 10, 0)
 * (20 values, used as duplicate JSON keys), nval/nstr are always NULL,
 * pnull = id % 50 but NULL when id % 7 = 0.
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
 */

drop table if exists bvx;
create table bvx (id int, cola int, colb varchar(10), nval int, nstr varchar(10), pad varchar(100), pnull int);
insert into bvx
select rownum, rownum % 100, lpad(to_char(rownum % 20), 10, '0'), null, null,
       concat(md5(rownum), md5(rownum + 7919), md5(rownum * 31 + 7)),
       case when rownum % 7 = 0 then null else rownum % 50 end
from db_class a, db_class b, db_class c, db_class d, db_class e limit 10000;

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

set trace off;

drop table if exists bvx;

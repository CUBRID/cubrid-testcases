/**
 *  This test case verifies CBRD-27568: an aggregate whose argument is a correlated
 *  scalar subquery must run that subquery for every row of a parallel heap scan.
 *
 *  A parallel heap scan without GROUP BY aggregates in its workers (gather: buildvalue).
 *  A worker read an operand of type constant straight from its value slot. A scalar
 *  subquery operand is of that type as well, and its slot holds the value of the current
 *  row only after the fetch has run the subquery. The worker clears the correlated
 *  subqueries after every row, so the slot held NULL, or the value of an earlier row, and
 *  the aggregate came back wrong, often different from one execution to the next.
 *
 *  The fix (engine PR #8113) reads the slot directly only for an operand without a linked
 *  subquery, and fetches the other operands as the serial aggregation does. This also
 *  covers the value operand of JSON_OBJECTAGG.
 *
 *  Every parallel query is followed by the same query with parallel(0), which runs it
 *  serially, and the two result blocks must match. CTP runs with test_mode=yes, which
 *  masks volatile trace values to '?'. The traces show the parallel scan of o with the
 *  buildvalue gather and the correlated subquery on s.
 *
 *  Coverage:
 *    Case 1:  the reported query, SUM over the subquery beside COUNT(*) and SUM over a column
 *    Case 2:  MAX, MIN, AVG, COUNT and COUNT DISTINCT over the subquery
 *    Case 3:  JSON_OBJECTAGG with the subquery as its value operand
 *    Case 4:  the subquery in a derived table that the rewriter merges into the query
 */

drop table if exists o, s, n10;

create table n10 (v int);
insert into n10 values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

-- outer table: 100000 rows, v = 0..99999, large enough to be scanned in parallel under test_mode
-- (parallel_scan_page_threshold 32). Only v = 0, 1, 2 qualify in every case below.
create table o (v int);
insert into o
select d5.v * 10000 + d4.v * 1000 + d3.v * 100 + d2.v * 10 + d1.v
  from n10 d5, n10 d4, n10 d3, n10 d2, n10 d1;

-- subquery table: 1000 rows, k = mod(v, 100). The subquery sum(s.v) where s.k < o.v gives
-- NULL for o.v = 0, 4500 for o.v = 1 and 9010 for o.v = 2.
create table s (k int, v int);
insert into s
select mod(d3.v * 100 + d2.v * 10 + d1.v, 100), d3.v * 100 + d2.v * 10 + d1.v
  from n10 d3, n10 d2, n10 d1;

update statistics on o, s with fullscan;

set trace on;


evaluate 'Case 1: the reported query, SUM over the subquery; result = parallel(0)';
select /*+ recompile */ count(*), sum(o.v), sum((select sum(s.v) from s where s.k < o.v)) from o where o.v < 3;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(o.v), sum((select sum(s.v) from s where s.k < o.v)) from o where o.v < 3;


evaluate 'Case 2: MAX, MIN, AVG, COUNT and COUNT DISTINCT over the subquery; result = parallel(0)';
select /*+ recompile */ max((select sum(s.v) from s where s.k < o.v)), min((select sum(s.v) from s where s.k < o.v)), avg((select sum(s.v) from s where s.k < o.v)), count((select sum(s.v) from s where s.k < o.v)), count(distinct (select sum(s.v) from s where s.k < o.v)) from o where o.v < 3;
show trace;
select /*+ recompile parallel(0) */ max((select sum(s.v) from s where s.k < o.v)), min((select sum(s.v) from s where s.k < o.v)), avg((select sum(s.v) from s where s.k < o.v)), count((select sum(s.v) from s where s.k < o.v)), count(distinct (select sum(s.v) from s where s.k < o.v)) from o where o.v < 3;


evaluate 'Case 3: JSON_OBJECTAGG with the subquery as its value operand; result = parallel(0)';
-- the workers build partial objects that are merged in worker order, so each key is extracted on its own
select /*+ recompile */ json_extract(json_objectagg(cast(o.v as varchar(10)), (select sum(s.v) from s where s.k < o.v)), '$."0"', '$."1"', '$."2"') from o where o.v < 3;
show trace;
select /*+ recompile parallel(0) */ json_extract(json_objectagg(cast(o.v as varchar(10)), (select sum(s.v) from s where s.k < o.v)), '$."0"', '$."1"', '$."2"') from o where o.v < 3;


evaluate 'Case 4: the subquery in a derived table merged into the query; result = parallel(0)';
select /*+ recompile */ count(*), sum(t.x) from (select (select sum(s.v) from s where s.k < o.v) x from o where o.v < 3) t;
show trace;
-- trace goes off before the last query: the plan of a traced query that no show trace reads stays in the
-- session, and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile parallel(0) */ count(*), sum(t.x) from (select (select sum(s.v) from s where s.k < o.v) x from o where o.v < 3) t;


drop table o, s, n10;

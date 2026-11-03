/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-3.2 to AC-3.4 and AC-4: statements around a hash join result, and the trace.
 *
 *  Every sub-case compares its result rows with the answer. A sub-case marked "pass through" or
 *  "no pass through" is followed by a query that counts, in the trace of the sub-case, the SCAN (temp ...)
 *  lines and those with readrows: 0. A result passed through reads no row, so the two counts are equal.
 *  Without the change every count of pass_through is 0. CTP masks the digits of a trace, so the counts
 *  are read as a result row.
 *  A sub-case marked "trace" also shows its trace: the node tree is the same as without the change.
 *
 *  Sub-cases:
 *    Sub-case     Check                        Case
 *    TC-3-02-01   result only                  RIGHT OUTER above a join of an empty input
 *    TC-3-02-02   result only                  a UNION branch is an empty join
 *    TC-3-02-03   result only                  a join of an empty input
 *    TC-3-02-04   result only                  an empty join in a derived table
 *    TC-3-02-05   result only                  a scalar subquery returns one row
 *    TC-3-02-06   result only                  a scalar subquery returns several rows
 *    TC-3-02-07   result, pass through         expression in a derived table
 *    TC-3-02-08   result only                  INSERT ... SELECT
 *    TC-3-02-09   result only                  CREATE TABLE ... AS SELECT
 *    TC-3-02-10   result only                  hash join in a correlated EXISTS subquery
 *    TC-3-03-01   result, pass through         columns, first run
 *    TC-3-03-02   result, pass through         columns, second run
 *    TC-3-03-03   result, pass through         columns, third run
 *    TC-3-03-04   result, pass through         expressions, first run
 *    TC-3-03-05   result, pass through         expressions, second run
 *    TC-3-04-01   result only                  hash join in the recursive part
 *    TC-4-01-01   result, pass through, trace  join of four tables
 *    TC-4-01-02   result, pass through, trace  join of three tables
 *    TC-4-01-03   result, pass through, trace  join of three tables, expressions
 */

drop table if exists ta, tb, tc, td;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
create table td (ca int, cb int);
insert into ta values (1, 11), (1, 11), (2, 20);
insert into tb values (1, 101), (1, 101), (3, 30);
insert into tc values (1, 1001), (4, 40);
insert into td values (1, 7), (5, 50);
update statistics on ta, tb, tc, td with fullscan;
CREATE OR REPLACE FUNCTION f_plus (x INT) RETURN INT AS BEGIN RETURN x + 1000; END;
CREATE OR REPLACE FUNCTION f_plus_px (x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x + 1000; END;

set trace on;


-- =====================================================================================================================
-- TC-3-02: joins that open no list file, and statements around a passed-through result
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-01: RIGHT OUTER above a join of an empty input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-02-01: RIGHT OUTER above a join of an empty input';
drop table if exists te;
create table te (ca int, cb int);
update statistics on te with fullscan;
select /*+ recompile use_hash */ c.cb, b.cb from te e join tb b on e.ca = b.ca right outer join tc c on b.ca = c.ca;
drop table if exists te;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-02: a UNION branch is an empty join
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-02-02: a UNION branch is an empty join';
drop table if exists te;
create table te (ca int, cb int);
update statistics on te with fullscan;
select /*+ recompile use_hash */ e.cb, b.cb from te e, tb b where e.ca = b.ca union select cb, cb from tc;
drop table if exists te;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-03: a join of an empty input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-02-03: a join of an empty input';
drop table if exists te;
create table te (ca int, cb int);
update statistics on te with fullscan;
select /*+ recompile use_hash */ e.cb, b.cb from te e, tb b where e.ca = b.ca;
drop table if exists te;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-04: an empty join in a derived table
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-02-04: an empty join in a derived table';
drop table if exists te;
create table te (ca int, cb int);
update statistics on te with fullscan;
select /*+ recompile */ * from (select /*+ use_hash */ e.cb c1, b.cb c2 from te e, tb b where e.ca = b.ca) x;
drop table if exists te;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-05: a scalar subquery returns one row
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-02-05: a scalar subquery returns one row';
select /*+ recompile */ (select /*+ use_hash */ c.cb from tc c, td d where c.ca = d.ca) from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-06: a scalar subquery returns several rows
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-02-06: a scalar subquery returns several rows';
select /*+ recompile */ (select /*+ use_hash */ a.cb from ta a, tb b where a.ca = b.ca) from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-07: expression in a derived table
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-02-07: expression in a derived table';
select /*+ recompile */ * from (select /*+ use_hash */ a.cb * 2 c1 from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca) x where c1 > 0;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-08: INSERT ... SELECT
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-02-08: INSERT ... SELECT';
drop table if exists t73;
create table t73 (c1 int, c2 int);
insert into t73 select /*+ recompile use_hash */ a.cb * 2, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select c1, c2 from t73;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-09: CREATE TABLE ... AS SELECT
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-02-09: CREATE TABLE ... AS SELECT';
drop table if exists t74;
create table t74 as select /*+ recompile use_hash */ a.cb * 2 c1, d.cb c2 from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select c1, c2 from t74;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-10: hash join in a correlated EXISTS subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-02-10: hash join in a correlated EXISTS subquery';
select /*+ recompile */ d.cb from td d where exists (select /*+ use_hash */ a.cb * 2 from ta a, tb b where a.ca = b.ca and b.ca = d.ca);

-- =====================================================================================================================
-- TC-3-03: runs on a copy from the XASL cache
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-03-01: columns, first run
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-03-01: columns, first run';
select /*+ use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-03-02: columns, second run
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-03-02: columns, second run';
select /*+ use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-03-03: columns, third run
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-03-03: columns, third run';
select /*+ use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-03-04: expressions, first run
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-03-04: expressions, first run';
select /*+ use_hash */ a.cb * 2, b.cb + c.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-03-05: expressions, second run
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-03-05: expressions, second run';
select /*+ use_hash */ a.cb * 2, b.cb + c.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- =====================================================================================================================
-- TC-3-04: the recursive part of a recursive CTE uses a hash join
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-04-01: hash join in the recursive part
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-04-01: hash join in the recursive part';
with recursive r (n) as (select 1 from db_root union all select /*+ recompile use_hash parallel(4) */ r.n + 1 from r, ta a where r.n < 3 and a.ca = r.n) select n from r;

-- =====================================================================================================================
-- TC-4-01: the node tree of the trace is the same as without the change
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-01-01: join of four tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-01-01: join of four tables';
select /*+ recompile use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
select /*+ recompile use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
show trace;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-01-02: join of three tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-01-02: join of three tables';
select /*+ recompile use_hash */ a.cb, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
select /*+ recompile use_hash */ a.cb, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
show trace;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-01-03: join of three tables, expressions
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-01-03: join of three tables, expressions';
select /*+ recompile use_hash */ a.cb * 2, b.cb + c.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
select /*+ recompile use_hash */ a.cb * 2, b.cb + c.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
show trace;


set trace off;
drop table if exists ta, tb, tc, td, t73, t74;
drop function f_plus;
drop function f_plus_px;

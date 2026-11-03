/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-2: hash join results the node above does not pass through.
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
 *    TC-2-01-01   result, no pass through      ORDER BY
 *    TC-2-01-02   result, no pass through      LIMIT
 *    TC-2-01-03   result, no pass through      GROUP BY
 *    TC-2-01-04   result, no pass through      DISTINCT
 *    TC-2-01-05   result, no pass through      aggregate functions
 *    TC-2-01-06   result, no pass through      FOR UPDATE
 *    TC-2-01-07   result only                  click counter
 *    TC-2-02-01   result, no pass through      uncorrelated subquery
 *    TC-2-02-02   result, no pass through      correlated subquery
 *    TC-2-02-03   result, no pass through      ROWNUM
 *    TC-2-02-04   result only                  reading a session variable
 *    TC-2-02-05   result only                  assigning a session variable
 *    TC-2-02-06   result only                  assigning a session variable under a PARALLEL(4) hint
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
-- TC-2-01: the result node has work the hash join cannot do
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-01: ORDER BY
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-01: ORDER BY';
select /*+ recompile use_hash */ a.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca order by a.cb, d.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-02: LIMIT
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-02: LIMIT';
select /*+ recompile use_hash */ a.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca limit 2;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-03: GROUP BY
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-03: GROUP BY';
select /*+ recompile use_hash */ a.cb, count(*) from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca group by a.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-04: DISTINCT
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-04: DISTINCT';
select /*+ recompile use_hash */ distinct a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-05: aggregate functions
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-05: aggregate functions';
select /*+ recompile use_hash */ count(*), sum(a.cb), sum(b.cb), sum(c.cb), sum(d.cb) from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-06: FOR UPDATE
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-06: FOR UPDATE';
select /*+ recompile use_hash */ a.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca for update;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-07: click counter
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-07: click counter';
drop table if exists te;
create table te (ca int, cb int, cc int);
insert into te values (1, 10, 2), (2, 10, 0);
update statistics on te with fullscan;
select /*+ recompile */ incr (e.cb) from te e where e.ca = 2;
drop table if exists te;

-- =====================================================================================================================
-- TC-2-02: select lists the hash join cannot evaluate
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-01: uncorrelated subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-02-01: uncorrelated subquery';
select /*+ recompile use_hash */ a.cb, (select max(cb) from td) from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-02: correlated subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-02-02: correlated subquery';
select /*+ recompile use_hash */ a.cb, (select max(d.cb) from td d where d.ca = a.ca) from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-03: ROWNUM
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-02-03: ROWNUM';
select /*+ recompile use_hash */ rownum, a.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-04: reading a session variable
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-02-04: reading a session variable';
set @v = 1;
select /*+ recompile use_hash */ @v, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-05: assigning a session variable
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-02-05: assigning a session variable';
set @n = 0;
select /*+ recompile use_hash */ @n := @n + 1, a.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-06: assigning a session variable under a PARALLEL(4) hint
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-02-06: assigning a session variable under a PARALLEL(4) hint';
set @n = 0;
select /*+ recompile use_hash parallel(4) */ @n := @n + 1, a.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;


set trace off;
drop table if exists ta, tb, tc, td, t73, t74;
drop function f_plus;
drop function f_plus_px;

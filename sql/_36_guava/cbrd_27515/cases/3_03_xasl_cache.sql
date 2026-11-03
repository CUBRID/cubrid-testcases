/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-3.2 to AC-3.4 and AC-4: statements around a hash join result, and the trace.
 *  TC-3-03: runs on a copy from the XASL cache.
 *
 *  Every sub-case compares its result rows with the answer. Consecutive sub-cases that read the tables
 *  ta, tb, tc and td as they are share them. A sub-case that needs other tables or other rows makes its
 *  own tables, from ta, and drops them.
 *
 *  A sub-case marked "pass through" or "no pass through" is followed by a query that counts, in the trace
 *  of the sub-case, the SCAN (temp ...) lines and those with readrows: 0. A result passed through reads no
 *  row, so the two counts are equal. Without the change every count of pass_through is 0. CTP masks the
 *  digits of a trace, so the counts are read as a result row.
 *
 *  A sub-case marked "trace" also shows its trace: the node tree is the same as without the change.
 *
 *  Sub-cases:
 *    Sub-case     Check                          Case
 *    TC-3-03-01   result, pass through           columns, first run
 *    TC-3-03-02   result, pass through           columns, second run
 *    TC-3-03-03   result, pass through           columns, third run
 *    TC-3-03-04   result, pass through           expressions, first run
 *    TC-3-03-05   result, pass through           expressions, second run
 */

set trace on;


-- =====================================================================================================================
-- TC-3-03: runs on a copy from the XASL cache
-- =====================================================================================================================

-- the tables of TC-3-03-01 to TC-3-03-05
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

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-03-01: columns, first run
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the first run caches the plan, and the result passes through
evaluate 'TC-3-03-01: columns, first run';
select /*+ use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-03-02: columns, second run
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the second run executes a copy of the cached plan, and the result passes through
evaluate 'TC-3-03-02: columns, second run';
select /*+ use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-03-03: columns, third run
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the third run executes a copy of the cached plan, and the result passes through
evaluate 'TC-3-03-03: columns, third run';
select /*+ use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-03-04: expressions, first run
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the first run caches the plan with expressions, and the result passes through
evaluate 'TC-3-03-04: expressions, first run';
select /*+ use_hash */ a.cb * 2, b.cb + c.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-03-05: expressions, second run
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the second run executes a copy of the cached plan, and the result passes through
evaluate 'TC-3-03-05: expressions, second run';
select /*+ use_hash */ a.cb * 2, b.cb + c.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;


set trace off;

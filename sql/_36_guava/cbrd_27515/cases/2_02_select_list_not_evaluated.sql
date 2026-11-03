/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-2: hash join results the node above does not pass through.
 *  TC-2-02: select lists the hash join cannot evaluate.
 *
 *  Every sub-case compares its result rows with the answer. Consecutive sub-cases that read ta, tb, tc and
 *  td unchanged share one copy of them. A sub-case that needs other tables or other rows makes its own,
 *  named from ta, and drops them afterwards.
 *
 *  Every sub-case is followed by a query that counts, in the trace of the sub-case, the SCAN (temp ...)
 *  lines (temp_scans) and those with readrows: 0 (pass_through). A passed-through result reads no rows, so
 *  the two counts are equal when every scan passes through. Without the change pass_through is 0, except
 *  where the comment of a sub-case says the counts are the same on develop. CTP masks the digits of a
 *  trace, so the counts are read as a result row. The Counts column below is temp_scans / pass_through.
 *
 *  A sub-case marked "trace" also shows its trace: the node tree is the same as without the change.
 *
 *  Sub-cases:
 *    Sub-case     Counts         Case
 *    TC-2-02-01   2 / 1          uncorrelated subquery
 *    TC-2-02-02   2 / 1          correlated subquery
 *    TC-2-02-03   2 / 1          ROWNUM
 *    TC-2-02-04   3 / 2          reading a session variable
 *    TC-2-02-05   2 / 1          assigning a session variable
 *    TC-2-02-06   2 / 1          assigning a session variable under a PARALLEL(4) hint
 */

set trace on;


-- =====================================================================================================================
-- TC-2-02: select lists the hash join cannot evaluate
-- =====================================================================================================================

-- the tables of TC-2-02-01 to TC-2-02-06
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
-- TC-2-02-01: uncorrelated subquery
--
-- expected: temp_scans 2, pass_through 1
--   The node above evaluates the uncorrelated subquery, while the joins below it pass through.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-02-01: uncorrelated subquery';
select /*+ recompile use_hash */ a.cb, (select max(cb) from td) from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-02: correlated subquery
--
-- expected: temp_scans 2, pass_through 1
--   The node above runs the correlated subquery for each row, while the joins below it pass through.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-02-02: correlated subquery';
select /*+ recompile use_hash */ a.cb, (select max(d.cb) from td d where d.ca = a.ca) from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-03: ROWNUM
--
-- expected: temp_scans 2, pass_through 1
--   The node above numbers the rows for ROWNUM, while the joins below it pass through.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-02-03: ROWNUM';
select /*+ recompile use_hash */ rownum, a.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-04: reading a session variable
--
-- expected: temp_scans 3, pass_through 2
--   The node above reads the session variable, while the joins below it pass through.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-02-04: reading a session variable';
set @v = 1;
select /*+ recompile use_hash */ @v, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-05: assigning a session variable
--
-- expected: temp_scans 2, pass_through 1
--   The node above assigns the session variable for each row, while the joins below it pass through.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-02-05: assigning a session variable';
set @n = 0;
select /*+ recompile use_hash */ @n := @n + 1, a.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-06: assigning a session variable under a PARALLEL(4) hint
--
-- expected: temp_scans 2, pass_through 1
--   The node above assigns the session variable under the PARALLEL(4) hint as well.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-02-06: assigning a session variable under a PARALLEL(4) hint';
set @n = 0;
select /*+ recompile use_hash parallel(4) */ @n := @n + 1, a.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;


set trace off;

/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-2: hash join results the node above does not pass through.
 *  TC-2-01: the result node has work the hash join cannot do.
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
 *    TC-2-01-01   result, no pass through        ORDER BY
 *    TC-2-01-02   result, no pass through        LIMIT
 *    TC-2-01-03   result, no pass through        GROUP BY
 *    TC-2-01-04   result, no pass through        DISTINCT
 *    TC-2-01-05   result, no pass through        aggregate functions
 *    TC-2-01-06   result, no pass through        FOR UPDATE
 *    TC-2-01-07   result only                    click counter
 */

set trace on;


-- =====================================================================================================================
-- TC-2-01: the result node has work the hash join cannot do
-- =====================================================================================================================

-- the tables of TC-2-01-01 to TC-2-01-06
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
-- TC-2-01-01: ORDER BY
-- expected: no pass through: the node above sorts the rows for ORDER BY; the joins below it pass through
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-01: ORDER BY';
select /*+ recompile use_hash */ a.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca order by a.cb, d.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-02: LIMIT
-- expected: no pass through: the node above counts the rows for LIMIT; the joins below it pass through
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-02: LIMIT';
select /*+ recompile use_hash */ a.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca limit 2;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-03: GROUP BY
-- expected: no pass through: the node above groups the rows; the joins below it pass through
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-03: GROUP BY';
select /*+ recompile use_hash */ a.cb, count(*) from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca group by a.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-04: DISTINCT
-- expected: no pass through: the node above removes the duplicate rows; the joins below it pass through
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-04: DISTINCT';
select /*+ recompile use_hash */ distinct a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-05: aggregate functions
-- expected: no pass through: the node above aggregates the rows; the joins below it pass through
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-05: aggregate functions';
select /*+ recompile use_hash */ count(*), sum(a.cb), sum(b.cb), sum(c.cb), sum(d.cb) from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-06: FOR UPDATE
-- expected: no pass through: a SELECT ... FOR UPDATE keeps its plan; the joins below the top pass through
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-06: FOR UPDATE';
select /*+ recompile use_hash */ a.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca for update;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-07: click counter
-- expected: result only: one table and no hash join, so nothing passes through. qo_check_pass_through_wrapper () still
-- checks the statement, and a click counter (INCR) must not trip its assert
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-07: click counter';

-- the tables of TC-2-01-07
drop table if exists ta;
create table ta (ca int, cb int, cc int);
insert into ta values (1, 10, 2), (2, 10, 0);
update statistics on ta with fullscan;

select /*+ recompile */ incr (a.cb) from ta a where a.ca = 2;

drop table if exists ta;


set trace off;

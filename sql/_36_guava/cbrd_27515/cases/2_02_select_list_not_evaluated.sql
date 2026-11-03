/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-2: hash join results the node above does not pass through.
 *  TC-2-02: select lists the hash join cannot evaluate.
 *
 *  Every sub-case makes its own tables (ta, tb, ...), compares its result rows with the answer, and drops
 *  the tables. A sub-case marked "pass through" or "no pass through" is followed by a query that counts,
 *  in the trace of the sub-case, the SCAN (temp ...) lines and those with readrows: 0. A result passed
 *  through reads no row, so the two counts are equal. Without the change every count of pass_through is 0.
 *  CTP masks the digits of a trace, so the counts are read as a result row. A sub-case marked "trace" also
 *  shows its trace: the node tree is the same as without the change.
 *
 *  Sub-cases:
 *    Sub-case     Check                          Case
 *    TC-2-02-01   result, no pass through        uncorrelated subquery
 *    TC-2-02-02   result, no pass through        correlated subquery
 *    TC-2-02-03   result, no pass through        ROWNUM
 *    TC-2-02-04   result, no pass through        reading a session variable
 *    TC-2-02-05   result, no pass through        assigning a session variable
 *    TC-2-02-06   result, no pass through        assigning a session variable under a PARALLEL(4) hint
 */

set trace on;


-- =====================================================================================================================
-- TC-2-02: select lists the hash join cannot evaluate
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-01: uncorrelated subquery
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: no pass through: the node above evaluates the uncorrelated subquery; the joins below it pass through
evaluate 'TC-2-02-01: uncorrelated subquery';
drop table if exists ta, tb, tc, td;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
create table td (ca int, cb int);
insert into ta values (1, 7), (5, 50);
insert into tb values (1, 11), (1, 11), (2, 20);
insert into tc values (1, 101), (1, 101), (3, 30);
insert into td values (1, 1001), (4, 40);
update statistics on ta, tb, tc, td with fullscan;
select /*+ recompile use_hash */ b.cb, (select max(cb) from ta) from tb b, tc c, td d where b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-02: correlated subquery
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: no pass through: the node above runs the correlated subquery for each row; the joins below it pass through
evaluate 'TC-2-02-02: correlated subquery';
drop table if exists ta, tb, tc, td;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
create table td (ca int, cb int);
insert into ta values (1, 7), (5, 50);
insert into tb values (1, 11), (1, 11), (2, 20);
insert into tc values (1, 101), (1, 101), (3, 30);
insert into td values (1, 1001), (4, 40);
update statistics on ta, tb, tc, td with fullscan;
select /*+ recompile use_hash */ b.cb, (select max(a.cb) from ta a where a.ca = b.ca) from tb b, tc c, td d where b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-03: ROWNUM
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: no pass through: the node above numbers the rows for ROWNUM; the joins below it pass through
evaluate 'TC-2-02-03: ROWNUM';
drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
insert into ta values (1, 11), (1, 11), (2, 20);
insert into tb values (1, 101), (1, 101), (3, 30);
insert into tc values (1, 1001), (4, 40);
update statistics on ta, tb, tc with fullscan;
select /*+ recompile use_hash */ rownum, a.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-04: reading a session variable
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: no pass through: the node above reads the session variable; the joins below it pass through
evaluate 'TC-2-02-04: reading a session variable';
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
set @v = 1;
select /*+ recompile use_hash */ @v, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-05: assigning a session variable
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: no pass through: the node above assigns the session variable for each row; the joins below it pass through
evaluate 'TC-2-02-05: assigning a session variable';
drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
insert into ta values (1, 11), (1, 11), (2, 20);
insert into tb values (1, 101), (1, 101), (3, 30);
insert into tc values (1, 1001), (4, 40);
update statistics on ta, tb, tc with fullscan;
set @n = 0;
select /*+ recompile use_hash */ @n := @n + 1, a.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-02-06: assigning a session variable under a PARALLEL(4) hint
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: no pass through: the node above assigns the session variable, with the PARALLEL(4) hint as well
evaluate 'TC-2-02-06: assigning a session variable under a PARALLEL(4) hint';
drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
insert into ta values (1, 11), (1, 11), (2, 20);
insert into tb values (1, 101), (1, 101), (3, 30);
insert into tc values (1, 1001), (4, 40);
update statistics on ta, tb, tc with fullscan;
set @n = 0;
select /*+ recompile use_hash parallel(4) */ @n := @n + 1, a.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb, tc;


set trace off;

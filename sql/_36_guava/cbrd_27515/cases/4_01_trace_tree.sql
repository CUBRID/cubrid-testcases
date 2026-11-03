/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-3.2 to AC-3.4 and AC-4: statements around a hash join result, and the trace.
 *  TC-4-01: the node tree of the trace is the same as without the change.
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
 *    TC-4-01-01   result, pass through, trace    join of four tables
 *    TC-4-01-02   result, pass through, trace    join of three tables
 *    TC-4-01-03   result, pass through, trace    join of three tables, expressions
 */

set trace on;


-- =====================================================================================================================
-- TC-4-01: the node tree of the trace is the same as without the change
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-01-01: join of four tables
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: both joins between joins and the top pass through, and the trace tree is that of develop
evaluate 'TC-4-01-01: join of four tables';
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
select /*+ recompile use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
select /*+ recompile use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
show trace;
drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-01-02: join of three tables
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the join between joins and the top pass through, and the trace tree is that of develop
evaluate 'TC-4-01-02: join of three tables';
drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
insert into ta values (1, 11), (1, 11), (2, 20);
insert into tb values (1, 101), (1, 101), (3, 30);
insert into tc values (1, 1001), (4, 40);
update statistics on ta, tb, tc with fullscan;
select /*+ recompile use_hash */ a.cb, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
select /*+ recompile use_hash */ a.cb, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
show trace;
drop table if exists ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-01-03: join of three tables, expressions
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the joins evaluate the expressions, and the trace tree is that of develop
evaluate 'TC-4-01-03: join of three tables, expressions';
drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
insert into ta values (1, 11), (1, 11), (2, 20);
insert into tb values (1, 101), (1, 101), (3, 30);
insert into tc values (1, 1001), (4, 40);
update statistics on ta, tb, tc with fullscan;
select /*+ recompile use_hash */ a.cb * 2, b.cb + c.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
select /*+ recompile use_hash */ a.cb * 2, b.cb + c.cb from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca;
show trace;
drop table if exists ta, tb, tc;


set trace off;

/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-3.2 to AC-3.4 and AC-4: statements around a hash join result, and the trace.
 *  TC-3-02: joins that open no list file, and statements around a passed-through result.
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
 *    TC-3-02-01   result only                    RIGHT OUTER above a join of an empty input
 *    TC-3-02-02   result only                    a UNION branch is an empty join
 *    TC-3-02-03   result only                    a join of an empty input
 *    TC-3-02-04   result only                    an empty join in a derived table
 *    TC-3-02-05   result, pass through           a scalar subquery returns one row
 *    TC-3-02-06   result, pass through           a scalar subquery returns several rows
 *    TC-3-02-07   result, pass through           expression in a derived table
 *    TC-3-02-08   result only                    INSERT ... SELECT
 *    TC-3-02-09   result only                    CREATE TABLE ... AS SELECT
 *    TC-3-02-10   result, pass through           hash join in a correlated EXISTS subquery
 */

set trace on;


-- =====================================================================================================================
-- TC-3-02: joins that open no list file, and statements around a passed-through result
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-01: RIGHT OUTER above a join of an empty input
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: result only: the join of the empty table writes no row, so the scans read 0 rows with or without pass
-- through; the RIGHT OUTER join above still fills the rows of tc
evaluate 'TC-3-02-01: RIGHT OUTER above a join of an empty input';
-- ta is empty: a join that starts from it produces no rows, and an outer join above it must still fill NULLs.
drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
insert into tb values (1, 101), (1, 101), (3, 30);
insert into tc values (1, 1001), (4, 40);
update statistics on ta, tb, tc with fullscan;
select /*+ recompile use_hash */ c.cb, b.cb from ta a join tb b on a.ca = b.ca right outer join tc c on b.ca = c.ca;
drop table if exists ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-02: a UNION branch is an empty join
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: result only: the empty join writes no row, so its scan reads 0 rows with or without pass through
evaluate 'TC-3-02-02: a UNION branch is an empty join';
-- ta is empty: a join that starts from it produces no rows, and an outer join above it must still fill NULLs.
drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
insert into tb values (1, 101), (1, 101), (3, 30);
insert into tc values (1, 1001), (4, 40);
update statistics on ta, tb, tc with fullscan;
select /*+ recompile use_hash */ a.cb, b.cb from ta a, tb b where a.ca = b.ca union select cb, cb from tc;
drop table if exists ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-03: a join of an empty input
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: result only: the join of the empty table writes no row, so its scan reads 0 rows with or without pass
-- through
evaluate 'TC-3-02-03: a join of an empty input';
-- ta is empty: a join that starts from it produces no rows, and an outer join above it must still fill NULLs.
drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into tb values (1, 101), (1, 101), (3, 30);
update statistics on ta, tb with fullscan;
select /*+ recompile use_hash */ a.cb, b.cb from ta a, tb b where a.ca = b.ca;
drop table if exists ta, tb;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-04: an empty join in a derived table
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: result only: the empty join in the derived table writes no row, so its scan reads 0 rows with or without
-- pass through
evaluate 'TC-3-02-04: an empty join in a derived table';
-- ta is empty: a join that starts from it produces no rows, and an outer join above it must still fill NULLs.
drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into tb values (1, 101), (1, 101), (3, 30);
update statistics on ta, tb with fullscan;
select /*+ recompile */ * from (select /*+ use_hash */ a.cb c1, b.cb c2 from ta a, tb b where a.ca = b.ca) x;
drop table if exists ta, tb;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-05: a scalar subquery returns one row
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the hash join in the scalar subquery passes through to the node of the subquery
evaluate 'TC-3-02-05: a scalar subquery returns one row';
drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, 1001), (4, 40);
insert into tb values (1, 7), (5, 50);
update statistics on ta, tb with fullscan;
select /*+ recompile */ (select /*+ use_hash */ a.cb from ta a, tb b where a.ca = b.ca) from db_root;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-06: a scalar subquery returns several rows
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the hash join in the scalar subquery passes through; the subquery returns several rows, so
-- the statement fails
evaluate 'TC-3-02-06: a scalar subquery returns several rows';
drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, 11), (1, 11), (2, 20);
insert into tb values (1, 101), (1, 101), (3, 30);
update statistics on ta, tb with fullscan;
select /*+ recompile */ (select /*+ use_hash */ a.cb from ta a, tb b where a.ca = b.ca) from db_root;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-07: expression in a derived table
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the hash join in the derived table passes through to the node of the derived table
evaluate 'TC-3-02-07: expression in a derived table';
drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
insert into ta values (1, 11), (1, 11), (2, 20);
insert into tb values (1, 101), (1, 101), (3, 30);
insert into tc values (1, 1001), (4, 40);
update statistics on ta, tb, tc with fullscan;
select /*+ recompile */ * from (select /*+ use_hash */ a.cb * 2 c1 from ta a, tb b, tc c where a.ca = b.ca and b.ca = c.ca) x where c1 > 0;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-08: INSERT ... SELECT
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: result only: the trace is that of the last SELECT from the target table, which has no join; the case checks
-- the rows the INSERT wrote
evaluate 'TC-3-02-08: INSERT ... SELECT';
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
drop table if exists te;
create table te (c1 int, c2 int);
insert into te select /*+ recompile use_hash */ a.cb * 2, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select c1, c2 from te;
drop table if exists ta, tb, tc, td, te;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-09: CREATE TABLE ... AS SELECT
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: result only: the trace is that of the last SELECT from the new table, which has no join; the case checks
-- the rows CREATE TABLE ... AS SELECT wrote
evaluate 'TC-3-02-09: CREATE TABLE ... AS SELECT';
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
drop table if exists te;
create table te as select /*+ recompile use_hash */ a.cb * 2 c1, d.cb c2 from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select c1, c2 from te;
drop table if exists ta, tb, tc, td, te;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-10: hash join in a correlated EXISTS subquery
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the hash join in the correlated EXISTS subquery passes through to the node of the subquery
evaluate 'TC-3-02-10: hash join in a correlated EXISTS subquery';
drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
insert into ta values (1, 7), (5, 50);
insert into tb values (1, 11), (1, 11), (2, 20);
insert into tc values (1, 101), (1, 101), (3, 30);
update statistics on ta, tb, tc with fullscan;
select /*+ recompile */ a.cb from ta a where exists (select /*+ use_hash */ b.cb * 2 from tb b, tc c where b.ca = c.ca and c.ca = a.ca);
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb, tc;


set trace off;

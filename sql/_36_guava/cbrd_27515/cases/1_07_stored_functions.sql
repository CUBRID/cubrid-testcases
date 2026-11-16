/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-1.5 to AC-1.7: outer, SEMI and ANTI joins, and stored functions.
 *  TC-1-07: a serial hash join evaluates a stored function.
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
 *    TC-1-07-01   1 / 1          function without PARALLEL_ENABLE
 *    TC-1-07-02   2 / 2          function without PARALLEL_ENABLE in the parent join key
 *    TC-1-07-03   1 / 1          PARALLEL_ENABLE function
 *    TC-1-07-04   2 / 2          PARALLEL_ENABLE function in the parent join key
 *    TC-1-07-05   1 / 1          empty build input
 *    TC-1-07-06   1 / 1          LEFT OUTER, function without PARALLEL_ENABLE
 *    TC-1-07-07   1 / 1          LEFT OUTER, PARALLEL_ENABLE function
 *    TC-1-07-08   1 / 1          SEMI, function without PARALLEL_ENABLE
 *    TC-1-07-09   1 / 1          ANTI, function without PARALLEL_ENABLE
 */

-- f_plus: an SP a parallel worker may not run; f_plus_px: the same body, declared PARALLEL_ENABLE.
CREATE OR REPLACE FUNCTION f_plus (x INT) RETURN INT AS BEGIN RETURN x + 1000; END;
CREATE OR REPLACE FUNCTION f_plus_px (x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x + 1000; END;
set trace on;


-- =====================================================================================================================
-- TC-1-07: a serial hash join evaluates a stored function
-- =====================================================================================================================

-- the tables of TC-1-07-01 to TC-1-07-04
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
-- TC-1-07-01: function without PARALLEL_ENABLE
--
-- expected: temp_scans 1, pass_through 1
--   These small inputs run serially, so the hash join evaluates an SP without PARALLEL_ENABLE.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-01: function without PARALLEL_ENABLE';
select /*+ recompile use_hash */ f_plus (a.cb), b.cb from ta a, tb b where a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-02: function without PARALLEL_ENABLE in the parent join key
--
-- expected: temp_scans 2, pass_through 2
--   The child hash join evaluates an SP without PARALLEL_ENABLE in the parent join key.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-02: function without PARALLEL_ENABLE in the parent join key';
select /*+ recompile use_hash ordered */ a.cb, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and f_plus (a.ca) = c.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-03: PARALLEL_ENABLE function
--
-- expected: temp_scans 1, pass_through 1
--   The hash join evaluates a PARALLEL_ENABLE SP.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-03: PARALLEL_ENABLE function';
select /*+ recompile use_hash */ f_plus_px (a.cb), b.cb from ta a, tb b where a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-04: PARALLEL_ENABLE function in the parent join key
--
-- expected: temp_scans 2, pass_through 2
--   The child hash join evaluates a PARALLEL_ENABLE SP in the parent join key.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-04: PARALLEL_ENABLE function in the parent join key';
select /*+ recompile use_hash ordered */ a.cb, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and f_plus_px (a.ca) = c.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-05: empty build input
--
-- expected: temp_scans 1, pass_through 1
--   The counts are the same on develop. The build input is empty, so the join writes no row and the scan above reads 0
--   rows with or without pass through.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-05: empty build input';

-- the tables of TC-1-07-05
-- tb is empty: a join that starts from it produces no rows, and an outer join above it must still fill NULLs.
drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, 11), (1, 11), (2, 20);
update statistics on ta, tb with fullscan;

select /*+ recompile use_hash */ f_plus (a.cb), b.cb from ta a, tb b where a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb;

-- the tables of TC-1-07-06 to TC-1-07-09
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
-- TC-1-07-06: LEFT OUTER, function without PARALLEL_ENABLE
--
-- expected: temp_scans 1, pass_through 1
--   The outer join evaluates an SP without PARALLEL_ENABLE on the rows it fills with NULL.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-06: LEFT OUTER, function without PARALLEL_ENABLE';
select /*+ recompile use_hash */ f_plus (nvl (b.cb, 0)), a.cb from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-07: LEFT OUTER, PARALLEL_ENABLE function
--
-- expected: temp_scans 1, pass_through 1
--   The outer join evaluates a PARALLEL_ENABLE SP on the rows it fills with NULL.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-07: LEFT OUTER, PARALLEL_ENABLE function';
select /*+ recompile use_hash */ f_plus_px (nvl (b.cb, 0)), a.cb from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-08: SEMI, function without PARALLEL_ENABLE
--
-- expected: temp_scans 1, pass_through 1
--   The SEMI join evaluates an SP without PARALLEL_ENABLE.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-08: SEMI, function without PARALLEL_ENABLE';
select /*+ recompile use_hash */ f_plus (ta.cb) from ta semi join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-09: ANTI, function without PARALLEL_ENABLE
--
-- expected: temp_scans 1, pass_through 1
--   The ANTI join evaluates an SP without PARALLEL_ENABLE.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-09: ANTI, function without PARALLEL_ENABLE';
select /*+ recompile use_hash */ f_plus (ta.cb) from ta anti join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;


set trace off;
drop function f_plus;
drop function f_plus_px;

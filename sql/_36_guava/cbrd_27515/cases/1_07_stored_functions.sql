/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-1.5 to AC-1.7: outer, SEMI and ANTI joins, and stored functions.
 *  TC-1-07: a serial hash join evaluates a stored function.
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
 *    TC-1-07-01   result, pass through           function without PARALLEL_ENABLE
 *    TC-1-07-02   result, pass through           function without PARALLEL_ENABLE in the parent join key
 *    TC-1-07-03   result, pass through           PARALLEL_ENABLE function
 *    TC-1-07-04   result, pass through           PARALLEL_ENABLE function in the parent join key
 *    TC-1-07-05   result only                    empty build input
 *    TC-1-07-06   result, pass through           LEFT OUTER, function without PARALLEL_ENABLE
 *    TC-1-07-07   result, pass through           LEFT OUTER, PARALLEL_ENABLE function
 *    TC-1-07-08   result, pass through           SEMI, function without PARALLEL_ENABLE
 *    TC-1-07-09   result, pass through           ANTI, function without PARALLEL_ENABLE
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
-- expected: pass through: these small inputs run serially, so the hash join evaluates an SP without PARALLEL_ENABLE
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-01: function without PARALLEL_ENABLE';
select /*+ recompile use_hash */ f_plus (a.cb), b.cb from ta a, tb b where a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-02: function without PARALLEL_ENABLE in the parent join key
-- expected: pass through: the child hash join evaluates an SP without PARALLEL_ENABLE in the parent join key
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-02: function without PARALLEL_ENABLE in the parent join key';
select /*+ recompile use_hash ordered */ a.cb, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and f_plus (a.ca) = c.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-03: PARALLEL_ENABLE function
-- expected: pass through: the hash join evaluates a PARALLEL_ENABLE SP
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-03: PARALLEL_ENABLE function';
select /*+ recompile use_hash */ f_plus_px (a.cb), b.cb from ta a, tb b where a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-04: PARALLEL_ENABLE function in the parent join key
-- expected: pass through: the child hash join evaluates a PARALLEL_ENABLE SP in the parent join key
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-04: PARALLEL_ENABLE function in the parent join key';
select /*+ recompile use_hash ordered */ a.cb, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and f_plus_px (a.ca) = c.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-05: empty build input
-- expected: result only: the build input is empty, so the join writes no row and the scan above reads 0 rows with or
-- without pass through
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
-- expected: pass through: the outer join evaluates an SP without PARALLEL_ENABLE on the rows it fills with NULL
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-06: LEFT OUTER, function without PARALLEL_ENABLE';
select /*+ recompile use_hash */ f_plus (nvl (b.cb, 0)), a.cb from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-07: LEFT OUTER, PARALLEL_ENABLE function
-- expected: pass through: the outer join evaluates a PARALLEL_ENABLE SP on the rows it fills with NULL
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-07: LEFT OUTER, PARALLEL_ENABLE function';
select /*+ recompile use_hash */ f_plus_px (nvl (b.cb, 0)), a.cb from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-08: SEMI, function without PARALLEL_ENABLE
-- expected: pass through: the SEMI join evaluates an SP without PARALLEL_ENABLE
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-08: SEMI, function without PARALLEL_ENABLE';
select /*+ recompile use_hash */ f_plus (ta.cb) from ta semi join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-09: ANTI, function without PARALLEL_ENABLE
-- expected: pass through: the ANTI join evaluates an SP without PARALLEL_ENABLE
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-09: ANTI, function without PARALLEL_ENABLE';
select /*+ recompile use_hash */ f_plus (ta.cb) from ta anti join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;


set trace off;
drop function f_plus;
drop function f_plus_px;

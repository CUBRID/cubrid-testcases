/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-1.5 to AC-1.7: outer, SEMI and ANTI joins, and stored functions.
 *  TC-1-05: outer, SEMI and ANTI hash joins evaluate the select list expressions.
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
 *    TC-1-05-01   result, pass through           LEFT OUTER, matched and unmatched rows
 *    TC-1-05-02   result, pass through           LEFT OUTER, NVL on the NULL-filled side
 *    TC-1-05-03   result, pass through           RIGHT OUTER, NVL on the NULL-filled side
 *    TC-1-05-04   result, pass through           LEFT OUTER, no matching row
 *    TC-1-05-05   result, pass through           LEFT OUTER, empty build input
 *    TC-1-05-06   result, pass through           LEFT OUTER, a row with a NULL join key
 *    TC-1-05-07   result, pass through           LEFT OUTER, a non-equi ON term drops every row
 *    TC-1-05-08   result, pass through           SEMI, column
 *    TC-1-05-09   result, pass through           ANTI, column
 *    TC-1-05-10   result, pass through           SEMI, expression on the join key column
 *    TC-1-05-11   result, pass through           ANTI, empty build input
 *    TC-1-05-12   result, pass through           ANTI, expression on the join key column
 *    TC-1-05-13   result, pass through           SEMI, expression
 *    TC-1-05-14   result, pass through           ANTI, expression
 *    TC-1-05-15   result, pass through           IS NULL term after an outer join
 *    TC-1-05-16   result, pass through           expression term after an outer join
 *    TC-1-05-17   result, pass through           EXISTS turned into a SEMI join
 *    TC-1-05-18   result, pass through           NOT EXISTS turned into an ANTI join
 */

set trace on;


-- =====================================================================================================================
-- TC-1-05: outer, SEMI and ANTI hash joins evaluate the select list expressions
-- =====================================================================================================================

-- the tables of TC-1-05-01 to TC-1-05-03
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
-- TC-1-05-01: LEFT OUTER, matched and unmatched rows
--
--   expected: pass through: the outer join writes the rows without a match itself and evaluates the expressions on them
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-01: LEFT OUTER, matched and unmatched rows';
select /*+ recompile use_hash */ a.cb * 2, b.cb + 1 from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-02: LEFT OUTER, NVL on the NULL-filled side
--
--   expected: pass through: the outer join evaluates NVL on the rows it fills with NULL
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-02: LEFT OUTER, NVL on the NULL-filled side';
select /*+ recompile use_hash */ a.cb, nvl (b.cb, -1) from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-03: RIGHT OUTER, NVL on the NULL-filled side
--
--   expected: pass through: the RIGHT OUTER join evaluates NVL on the rows it fills with NULL
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-03: RIGHT OUTER, NVL on the NULL-filled side';
select /*+ recompile use_hash */ nvl (a.cb, -1), b.cb * 2 from ta a right outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-04: LEFT OUTER, no matching row
--
--   expected: pass through: the outer join fills every row with NULL and evaluates the expression
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-04: LEFT OUTER, no matching row';

-- the tables of TC-1-05-04
-- ta.ca = 9 matches nothing in tb: a left outer join fills the whole row with NULL.
drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (9, 99), (9, 99);
insert into tb values (1, 101), (1, 101), (3, 30);
update statistics on ta, tb with fullscan;

select /*+ recompile use_hash */ a.cb * 2, b.cb from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-05: LEFT OUTER, empty build input
--
--   expected: pass through: the build input is empty: the outer join writes every row with NULL without probing
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-05: LEFT OUTER, empty build input';

-- the tables of TC-1-05-05
-- ta.ca = 9 matches nothing, and tb is empty: the join writes every ta row null-padded without probing.
drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (9, 99), (9, 99);
update statistics on ta, tb with fullscan;

select /*+ recompile use_hash */ a.cb + 1, nvl (b.cb, -1) from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-06: LEFT OUTER, a row with a NULL join key
--
--   expected: pass through: the outer join writes the row with a NULL key with NULL without probing
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-06: LEFT OUTER, a row with a NULL join key';

-- the tables of TC-1-05-06
-- ta has a NULL key: an outer join writes that row null-padded without probing.
drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (NULL, 5), (1, 6);
insert into tb values (1, 101), (1, 101), (3, 30);
update statistics on ta, tb with fullscan;

select /*+ recompile use_hash */ a.cb + 1, nvl (b.cb, -1) from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb;

-- the tables of TC-1-05-07 to TC-1-05-10
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
-- TC-1-05-07: LEFT OUTER, a non-equi ON term drops every row
--
--   expected: pass through: the ON term drops every match, and the outer join writes every row with NULL
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-07: LEFT OUTER, a non-equi ON term drops every row';
select /*+ recompile use_hash */ a.cb + 1, nvl (b.cb, -1) from ta a left outer join tb b on a.ca = b.ca and b.cb > a.cb * 100;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-08: SEMI, column
--
--   expected: pass through: the SEMI join writes the column of its outer input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-08: SEMI, column';
select /*+ recompile use_hash */ ta.ca from ta semi join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-09: ANTI, column
--
--   expected: pass through: the ANTI join writes the column of its outer input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-09: ANTI, column';
select /*+ recompile use_hash */ ta.ca from ta anti join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-10: SEMI, expression on the join key column
--
--   expected: pass through: the SEMI join evaluates the expression over the join key column
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-10: SEMI, expression on the join key column';
select /*+ recompile use_hash */ ta.ca + 1 from ta semi join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-11: ANTI, empty build input
--
--   expected: pass through: the build input is empty: the ANTI join writes every row without probing
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-11: ANTI, empty build input';

-- the tables of TC-1-05-11
-- ta.ca = 9 matches nothing, and tb is empty: the join writes every ta row null-padded without probing.
drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (9, 99), (9, 99);
update statistics on ta, tb with fullscan;

select /*+ recompile use_hash */ a.cb * 2 from ta a anti join tb b on b.ca = a.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb;

-- the tables of TC-1-05-12 to TC-1-05-18
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
-- TC-1-05-12: ANTI, expression on the join key column
--
--   expected: pass through: the ANTI join evaluates the expression over the join key column
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-12: ANTI, expression on the join key column';
select /*+ recompile use_hash */ ta.ca + 1 from ta anti join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-13: SEMI, expression
--
--   expected: pass through: the SEMI join evaluates the expression
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-13: SEMI, expression';
select /*+ recompile use_hash */ ta.cb * 2 from ta semi join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-14: ANTI, expression
--
--   expected: pass through: the ANTI join evaluates the expression
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-14: ANTI, expression';
select /*+ recompile use_hash */ ta.cb * 2 from ta anti join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-15: IS NULL term after an outer join
--
--   expected: pass through: the hash join evaluates the IS NULL term after the outer join, so the node above has no
--   work
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-15: IS NULL term after an outer join';
select /*+ recompile use_hash */ a.cb + 1, nvl (b.cb, -1) from ta a left outer join tb b on a.ca = b.ca where b.cb is null;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-16: expression term after an outer join
--
--   expected: pass through: the hash join evaluates the expression term after the outer join
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-16: expression term after an outer join';
select /*+ recompile use_hash */ a.cb + 1, nvl (b.cb, -1) from ta a left outer join tb b on a.ca = b.ca where nvl (b.cb, 0) + a.cb > 100;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-17: EXISTS turned into a SEMI join
--
--   expected: pass through: EXISTS becomes a SEMI join, which passes through like TC-1-05-13
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-17: EXISTS turned into a SEMI join';
select /*+ recompile use_hash */ d.cb * 2 from td d where exists (select 1 from ta a where a.ca = d.ca);
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-18: NOT EXISTS turned into an ANTI join
--
--   expected: pass through: NOT EXISTS becomes an ANTI join, which passes through like TC-1-05-14
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-18: NOT EXISTS turned into an ANTI join';
select /*+ recompile use_hash */ d.cb * 2 from td d where not exists (select 1 from ta a where a.ca = d.ca);
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;


set trace off;

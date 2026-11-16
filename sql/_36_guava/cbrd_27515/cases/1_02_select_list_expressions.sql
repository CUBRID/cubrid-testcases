/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-1.1 to AC-1.5: the hash join writes the columns and expressions of the node above it.
 *  TC-1-02: the hash join evaluates the select list expressions for each result row.
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
 *    TC-1-02-01   3 / 3          arithmetic on a column of one input
 *    TC-1-02-02   3 / 3          arithmetic on columns of both inputs
 *    TC-1-02-03   3 / 3          type conversion
 *    TC-1-02-04   3 / 3          string function
 *    TC-1-02-05   3 / 3          CASE expression
 *    TC-1-02-06   3 / 3          arithmetic on a join key column
 *    TC-1-02-07   3 / 3          columns and expressions mixed
 *    TC-1-02-08   3 / 3          regular expression function
 *    TC-1-02-09   1 / 1          the join term is an expression
 *    TC-1-02-10   3 / 3          host variable
 *    TC-1-02-11   3 / 3          constant not at the front
 *    TC-1-02-12   3 / 3          constant at the front
 */

set trace on;


-- =====================================================================================================================
-- TC-1-02: the hash join evaluates the select list expressions for each result row
-- =====================================================================================================================

-- the tables of TC-1-02-01 to TC-1-02-12
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
-- TC-1-02-01: arithmetic on a column of one input
--
-- expected: temp_scans 3, pass_through 3
--   The hash join evaluates the select list expressions for each result row.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-01: arithmetic on a column of one input';
select /*+ recompile use_hash */ a.cb * 2, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-02: arithmetic on columns of both inputs
--
-- expected: temp_scans 3, pass_through 3
--   The hash join evaluates an expression over the columns of both inputs.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-02: arithmetic on columns of both inputs';
select /*+ recompile use_hash */ a.cb + b.cb, c.cb - b.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-03: type conversion
--
-- expected: temp_scans 3, pass_through 3
--   The hash join evaluates a CAST.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-03: type conversion';
select /*+ recompile use_hash */ cast(a.cb as bigint), d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-04: string function
--
-- expected: temp_scans 3, pass_through 3
--   The hash join evaluates a string function.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-04: string function';
select /*+ recompile use_hash */ lpad(cast(a.cb as varchar), 8, '0'), d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-05: CASE expression
--
-- expected: temp_scans 3, pass_through 3
--   The hash join evaluates a CASE expression.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-05: CASE expression';
select /*+ recompile use_hash */ case when a.cb > 10 then 1 else 0 end, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-06: arithmetic on a join key column
--
-- expected: temp_scans 3, pass_through 3
--   The hash join evaluates an expression over a join key column.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-06: arithmetic on a join key column';
select /*+ recompile use_hash */ a.ca * 2, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-07: columns and expressions mixed
--
-- expected: temp_scans 3, pass_through 3
--   The hash join copies the columns and evaluates the expressions.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-07: columns and expressions mixed';
select /*+ recompile use_hash */ a.cb, b.cb + c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-08: regular expression function
--
-- expected: temp_scans 3, pass_through 3
--   The hash join evaluates a regular expression function.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-08: regular expression function';
select /*+ recompile use_hash */ regexp_replace(cast(a.cb as varchar), '1', 'x'), d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-09: the join term is an expression
--
-- expected: temp_scans 1, pass_through 1
--   The join term is an expression, and the hash join evaluates the select list.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-09: the join term is an expression';
select /*+ recompile use_hash */ a.ca * 2, b.cb from ta a, tb b where a.ca * 2 = b.ca * 2;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-10: host variable
--
-- expected: temp_scans 3, pass_through 3
--   The hash join reads the host variable like a constant.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-10: host variable';
prepare s72 from 'select /*+ recompile use_hash */ a.cb + ?, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca';
execute s72 using 5;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-11: constant not at the front
--
-- expected: temp_scans 3, pass_through 3
--   The hash join writes a constant like an expression.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-11: constant not at the front';
select /*+ recompile use_hash */ a.cb, 77, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-12: constant at the front
--
-- expected: temp_scans 3, pass_through 3
--   The hash join writes a constant that is the first column.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-12: constant at the front';
select /*+ recompile use_hash */ 77, a.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;


set trace off;

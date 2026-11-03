/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node takes over the hash join's list file instead of reading it again.
 *  AC-1.1 to AC-1.5: the hash join writes the columns and expressions of the node above it.
 *
 *  Every sub-case checks its rows. A sub-case marked "taken over" or "not taken over" is followed by a
 *  query that counts, in the trace of the sub-case, the SCAN (temp ...) lines and those with readrows: 0.
 *  A taken-over result reads no row, so the two counts are equal; without the change every count of
 *  taken_over is 0. CTP masks the digits of a trace, so the counts are read as a result row.
 *  A sub-case marked "trace" also shows its trace: the node tree is the same as without the change.
 *
 *  Sub-cases:
 *    Sub-case     Check                      Case
 *    TC-1-01-01   taken over, trace          select list in the column order of the join
 *    TC-1-01-02   taken over                 select list in the reverse column order
 *    TC-1-01-03   taken over                 the same column twice
 *    TC-1-01-04   taken over                 columns of one table only
 *    TC-1-01-05   taken over                 join key columns
 *    TC-1-01-06   taken over                 rows an outer join fills with NULL
 *    TC-1-02-01   taken over                 arithmetic on a column of one input
 *    TC-1-02-02   taken over                 arithmetic on columns of both inputs
 *    TC-1-02-03   taken over                 type conversion
 *    TC-1-02-04   taken over                 string function
 *    TC-1-02-05   taken over                 CASE expression
 *    TC-1-02-06   taken over                 arithmetic on a join key column
 *    TC-1-02-07   taken over                 columns and expressions mixed
 *    TC-1-02-08   taken over                 regular expression function
 *    TC-1-02-09   taken over                 the join term is an expression
 *    TC-1-02-10   taken over                 host variable
 *    TC-1-02-11   taken over                 constant not at the front
 *    TC-1-02-12   taken over                 constant at the front
 *    TC-1-03-01   taken over                 division by zero only in the dropped rows
 *    TC-1-04-01   taken over                 the parent join key is an expression
 *    TC-1-04-02   taken over                 the parent join key and the select list are expressions
 */

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
CREATE OR REPLACE FUNCTION f_plus (x INT) RETURN INT AS BEGIN RETURN x + 1000; END;
CREATE OR REPLACE FUNCTION f_plus_px (x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x + 1000; END;

set trace on;


-- =====================================================================================================================
-- TC-1-01: the hash join copies the columns from the input tuples
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-01: select list in the column order of the join
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-01: select list in the column order of the join';
select /*+ recompile use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;
select /*+ recompile use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
show trace;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-02: select list in the reverse column order
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-02: select list in the reverse column order';
select /*+ recompile use_hash */ d.cb, c.cb, b.cb, a.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-03: the same column twice
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-03: the same column twice';
select /*+ recompile use_hash */ a.cb, d.cb, a.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-04: columns of one table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-04: columns of one table only';
select /*+ recompile use_hash */ c.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-05: join key columns
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-05: join key columns';
select /*+ recompile use_hash */ a.ca, a.cb, d.ca, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-06: rows an outer join fills with NULL
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-06: rows an outer join fills with NULL';
drop table if exists te;
create table te (ca int, cb int);
insert into te values (9, 99), (9, 99);
update statistics on te with fullscan;
select /*+ recompile use_hash */ e.cb, b.cb from te e left outer join tb b on e.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;
drop table if exists te;

-- =====================================================================================================================
-- TC-1-02: the hash join evaluates the select list expressions for each result row
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-01: arithmetic on a column of one input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-01: arithmetic on a column of one input';
select /*+ recompile use_hash */ a.cb * 2, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-02: arithmetic on columns of both inputs
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-02: arithmetic on columns of both inputs';
select /*+ recompile use_hash */ a.cb + b.cb, c.cb - b.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-03: type conversion
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-03: type conversion';
select /*+ recompile use_hash */ cast(a.cb as bigint), d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-04: string function
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-04: string function';
select /*+ recompile use_hash */ lpad(cast(a.cb as varchar), 8, '0'), d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-05: CASE expression
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-05: CASE expression';
select /*+ recompile use_hash */ case when a.cb > 10 then 1 else 0 end, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-06: arithmetic on a join key column
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-06: arithmetic on a join key column';
select /*+ recompile use_hash */ a.ca * 2, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-07: columns and expressions mixed
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-07: columns and expressions mixed';
select /*+ recompile use_hash */ a.cb, b.cb + c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-08: regular expression function
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-08: regular expression function';
select /*+ recompile use_hash */ regexp_replace(cast(a.cb as varchar), '1', 'x'), d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-09: the join term is an expression
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-09: the join term is an expression';
select /*+ recompile use_hash */ a.ca * 2, b.cb from ta a, tb b where a.ca * 2 = b.ca * 2;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-10: host variable
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-10: host variable';
prepare s72 from 'select /*+ recompile use_hash */ a.cb + ?, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca';
execute s72 using 5;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-11: constant not at the front
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-11: constant not at the front';
select /*+ recompile use_hash */ a.cb, 77, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-12: constant at the front
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-12: constant at the front';
select /*+ recompile use_hash */ 77, a.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- =====================================================================================================================
-- TC-1-03: the expressions of rows the join drops are not evaluated
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-03-01: division by zero only in the dropped rows
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-03-01: division by zero only in the dropped rows';
drop table if exists te;
create table te (ca int, cb int, cc int);
insert into te values (1, 10, 2), (2, 10, 0);
update statistics on te with fullscan;
select /*+ recompile use_hash */ e.cb / e.cc from te e, tb b where e.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;
drop table if exists te;

-- =====================================================================================================================
-- TC-1-04: the child hash join evaluates the key expression of the parent hash join
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-04-01: the parent join key is an expression
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-04-01: the parent join key is an expression';
select /*+ recompile use_hash ordered */ a.cb, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and a.ca + 1000 = c.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-04-02: the parent join key and the select list are expressions
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-04-02: the parent join key and the select list are expressions';
select /*+ recompile use_hash ordered */ a.cb * 2, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and a.ca + 1000 = c.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;


set trace off;
drop table if exists ta, tb, tc, td, t73, t74;
drop function f_plus;
drop function f_plus_px;

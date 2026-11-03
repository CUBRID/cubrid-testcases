/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-1.1 to AC-1.5: the hash join writes the columns and expressions of the node above it.
 *  TC-1-04: the child hash join evaluates the key expression of the parent hash join.
 *
 *  Every sub-case compares its result rows with the answer. Consecutive sub-cases that read ta, tb, tc and
 *  td unchanged share one copy of them. A sub-case that needs other tables or other rows makes its own,
 *  named from ta, and drops them afterwards.
 *
 *  A sub-case marked "pass through" or "no pass through" is followed by a query that counts, in the trace
 *  of the sub-case, the SCAN (temp ...) lines and those with readrows: 0. A passed-through result reads no
 *  rows, so the two counts are equal. Without the change every count of pass_through is 0. CTP masks the
 *  digits of a trace, so the counts are read as a result row.
 *
 *  A sub-case marked "trace" also shows its trace: the node tree is the same as without the change.
 *
 *  Sub-cases:
 *    Sub-case     Check                          Case
 *    TC-1-04-01   result, pass through           the parent join key is an expression
 *    TC-1-04-02   result, pass through           the parent join key and the select list are expressions
 */

set trace on;


-- =====================================================================================================================
-- TC-1-04: the child hash join evaluates the key expression of the parent hash join
-- =====================================================================================================================

-- the tables of TC-1-04-01 to TC-1-04-02
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
-- TC-1-04-01: the parent join key is an expression
--   expected: pass through: the child hash join evaluates the key expression of the parent hash join, so both pass
--   through
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-04-01: the parent join key is an expression';
select /*+ recompile use_hash ordered */ a.cb, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and a.ca + 1000 = c.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-04-02: the parent join key and the select list are expressions
--   expected: pass through: the child hash join evaluates the parent key expression and the select list expression
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-04-02: the parent join key and the select list are expressions';
select /*+ recompile use_hash ordered */ a.cb * 2, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and a.ca + 1000 = c.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;


set trace off;

/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-1.1 to AC-1.5: the hash join writes the columns and expressions of the node above it.
 *  TC-1-03: the expressions of rows the join drops are not evaluated.
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
 *    TC-1-03-01   result, pass through           division by zero only in the dropped rows
 */

set trace on;


-- =====================================================================================================================
-- TC-1-03: the expressions of rows the join drops are not evaluated
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-03-01: division by zero only in the dropped rows
-- expected: pass through: the hash join evaluates cb / cc on joined rows only; the row with cc = 0 joins nothing, so
-- the statement does not divide by zero
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-03-01: division by zero only in the dropped rows';

-- the tables of TC-1-03-01
-- ta (2, 10, 0) matches nothing in tb: the join must never evaluate cb / cc on it.
drop table if exists ta, tb;
create table ta (ca int, cb int, cc int);
create table tb (ca int, cb int);
insert into ta values (1, 10, 2), (2, 10, 0);
insert into tb values (1, 101), (1, 101), (3, 30);
update statistics on ta, tb with fullscan;

select /*+ recompile use_hash */ a.cb / a.cc from ta a, tb b where a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb;


set trace off;

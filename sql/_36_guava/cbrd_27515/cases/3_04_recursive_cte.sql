/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-3.2 to AC-3.4 and AC-4: statements around a hash join result, and the trace.
 *  TC-3-04: the recursive part of a recursive CTE uses a hash join.
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
 *    TC-3-04-01   3 / 1          hash join in the recursive part
 */

set trace on;


-- =====================================================================================================================
-- TC-3-04: the recursive part of a recursive CTE uses a hash join
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-04-01: hash join in the recursive part
--
-- expected: temp_scans 3, pass_through 1
--   The hash join in the recursive part passes through, while the other two scans read the result of the CTE itself.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-04-01: hash join in the recursive part';

-- the tables of TC-3-04-01
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

with recursive r (n) as (select 1 from db_root union all select /*+ recompile use_hash parallel(4) */ r.n + 1 from r, ta a where r.n < 3 and a.ca = r.n) select n from r;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;


set trace off;

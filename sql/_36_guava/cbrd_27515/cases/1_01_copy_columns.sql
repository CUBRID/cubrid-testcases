/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-1.1 to AC-1.5: the hash join writes the columns and expressions of the node above it.
 *  TC-1-01: the hash join copies the columns from the input tuples.
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
 *    TC-1-01-01   3 / 3, trace   select list in the column order of the join
 *    TC-1-01-02   3 / 3          select list in the reverse column order
 *    TC-1-01-03   3 / 3          the same column twice
 *    TC-1-01-04   3 / 3          columns of one table only
 *    TC-1-01-05   3 / 3          join key columns
 *    TC-1-01-06   1 / 1          rows an outer join fills with NULL
 */

set trace on;


-- =====================================================================================================================
-- TC-1-01: the hash join copies the columns from the input tuples
-- =====================================================================================================================

-- the tables of TC-1-01-01 to TC-1-01-05
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
-- TC-1-01-01: select list in the column order of the join
--
-- expected: temp_scans 3, pass_through 3
--   The select list is columns of the join inputs, which the hash join copies.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-01: select list in the column order of the join';
select /*+ recompile use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
select /*+ recompile use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
show trace;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-02: select list in the reverse column order
--
-- expected: temp_scans 3, pass_through 3
--   The select list is columns of the join inputs, in another order.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-02: select list in the reverse column order';
select /*+ recompile use_hash */ d.cb, c.cb, b.cb, a.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-03: the same column twice
--
-- expected: temp_scans 3, pass_through 3
--   The select list names the same column twice.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-03: the same column twice';
select /*+ recompile use_hash */ a.cb, d.cb, a.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-04: columns of one table only
--
-- expected: temp_scans 3, pass_through 3
--   The select list is columns of one input.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-04: columns of one table only';
select /*+ recompile use_hash */ c.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-05: join key columns
--
-- expected: temp_scans 3, pass_through 3
--   The select list is the join key columns.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-05: join key columns';
select /*+ recompile use_hash */ a.ca, a.cb, d.ca, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-06: rows an outer join fills with NULL
--
-- expected: temp_scans 1, pass_through 1
--   The outer join writes the rows without a match itself, with the columns of tb NULL.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-06: rows an outer join fills with NULL';

-- the tables of TC-1-01-06
-- ta.ca = 9 matches nothing in tb: a left outer join fills the whole row with NULL.
drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (9, 99), (9, 99);
insert into tb values (1, 101), (1, 101), (3, 30);
update statistics on ta, tb with fullscan;

select /*+ recompile use_hash */ a.cb, b.cb from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;

drop table if exists ta, tb;


set trace off;

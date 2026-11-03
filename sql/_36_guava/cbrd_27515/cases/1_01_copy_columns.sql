/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node passes the hash join's list file through instead of reading it again.
 *  AC-1.1 to AC-1.5: the hash join writes the columns and expressions of the node above it.
 *  TC-1-01: the hash join copies the columns from the input tuples.
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
 *    TC-1-01-01   result, pass through, trace    select list in the column order of the join
 *    TC-1-01-02   result, pass through           select list in the reverse column order
 *    TC-1-01-03   result, pass through           the same column twice
 *    TC-1-01-04   result, pass through           columns of one table only
 *    TC-1-01-05   result, pass through           join key columns
 *    TC-1-01-06   result, pass through           rows an outer join fills with NULL
 */

set trace on;


-- =====================================================================================================================
-- TC-1-01: the hash join copies the columns from the input tuples
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-01: select list in the column order of the join
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the select list is columns of the join inputs, which the hash join copies
evaluate 'TC-1-01-01: select list in the column order of the join';
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
select /*+ recompile use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
select /*+ recompile use_hash */ a.cb, b.cb, c.cb, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
show trace;
drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-02: select list in the reverse column order
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the select list is columns of the join inputs, in another order
evaluate 'TC-1-01-02: select list in the reverse column order';
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
select /*+ recompile use_hash */ d.cb, c.cb, b.cb, a.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-03: the same column twice
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the select list names the same column twice
evaluate 'TC-1-01-03: the same column twice';
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
select /*+ recompile use_hash */ a.cb, d.cb, a.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-04: columns of one table only
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the select list is columns of one input
evaluate 'TC-1-01-04: columns of one table only';
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
select /*+ recompile use_hash */ c.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-05: join key columns
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the select list is the join key columns
evaluate 'TC-1-01-05: join key columns';
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
select /*+ recompile use_hash */ a.ca, a.cb, d.ca, d.cb from ta a, tb b, tc c, td d where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as pass_through from db_root;
drop table if exists ta, tb, tc, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-06: rows an outer join fills with NULL
-- ---------------------------------------------------------------------------------------------------------------------
-- expected: pass through: the outer join writes the rows without a match itself, with the columns of tb NULL
evaluate 'TC-1-01-06: rows an outer join fills with NULL';
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

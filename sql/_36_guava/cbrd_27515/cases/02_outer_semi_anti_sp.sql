/**
 *  This test case verifies CBRD-27515: a hash join writes the columns and expressions of the node above it,
 *  and that node takes over the hash join's list file instead of reading it again.
 *  AC-1.5 to AC-1.7: outer, SEMI and ANTI joins, and stored functions.
 *
 *  Every sub-case checks its rows. A sub-case marked "taken over" or "not taken over" is followed by a
 *  query that counts, in the trace of the sub-case, the SCAN (temp ...) lines and those with readrows: 0.
 *  A taken-over result reads no row, so the two counts are equal; without the change every count of
 *  taken_over is 0. CTP masks the digits of a trace, so the counts are read as a result row.
 *  A sub-case marked "trace" also shows its trace: the node tree is the same as without the change.
 *
 *  Sub-cases:
 *    Sub-case     Check                      Case
 *    TC-1-05-01   taken over                 LEFT OUTER, matched and unmatched rows
 *    TC-1-05-02   taken over                 LEFT OUTER, NVL on the NULL-filled side
 *    TC-1-05-03   taken over                 RIGHT OUTER, NVL on the NULL-filled side
 *    TC-1-05-04   taken over                 LEFT OUTER, no matching row
 *    TC-1-05-05   taken over                 LEFT OUTER, empty build input
 *    TC-1-05-06   taken over                 LEFT OUTER, a row with a NULL join key
 *    TC-1-05-07   taken over                 LEFT OUTER, a non-equi ON term drops every row
 *    TC-1-05-08   rows                       SEMI, column
 *    TC-1-05-09   rows                       ANTI, column
 *    TC-1-05-10   rows                       SEMI, expression on the join key column
 *    TC-1-05-11   taken over                 ANTI, empty build input
 *    TC-1-05-12   rows                       ANTI, expression on the join key column
 *    TC-1-05-13   taken over                 SEMI, expression
 *    TC-1-05-14   taken over                 ANTI, expression
 *    TC-1-05-15   rows                       IS NULL term after an outer join
 *    TC-1-05-16   rows                       expression term after an outer join
 *    TC-1-05-17   rows                       EXISTS turned into a SEMI join
 *    TC-1-05-18   rows                       NOT EXISTS turned into an ANTI join
 *    TC-1-07-01   taken over                 function without PARALLEL_ENABLE
 *    TC-1-07-02   taken over                 function without PARALLEL_ENABLE in the parent join key
 *    TC-1-07-03   taken over                 PARALLEL_ENABLE function
 *    TC-1-07-04   taken over                 PARALLEL_ENABLE function in the parent join key
 *    TC-1-07-05   rows                       empty build input
 *    TC-1-07-06   taken over                 LEFT OUTER, function without PARALLEL_ENABLE
 *    TC-1-07-07   taken over                 LEFT OUTER, PARALLEL_ENABLE function
 *    TC-1-07-08   taken over                 SEMI, function without PARALLEL_ENABLE
 *    TC-1-07-09   taken over                 ANTI, function without PARALLEL_ENABLE
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
-- TC-1-05: outer, SEMI and ANTI hash joins evaluate the select list expressions
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-01: LEFT OUTER, matched and unmatched rows
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-01: LEFT OUTER, matched and unmatched rows';
select /*+ recompile use_hash */ a.cb * 2, b.cb + 1 from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-02: LEFT OUTER, NVL on the NULL-filled side
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-02: LEFT OUTER, NVL on the NULL-filled side';
select /*+ recompile use_hash */ a.cb, nvl (b.cb, -1) from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-03: RIGHT OUTER, NVL on the NULL-filled side
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-03: RIGHT OUTER, NVL on the NULL-filled side';
select /*+ recompile use_hash */ nvl (a.cb, -1), b.cb * 2 from ta a right outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-04: LEFT OUTER, no matching row
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-04: LEFT OUTER, no matching row';
drop table if exists te;
create table te (ca int, cb int);
insert into te values (9, 99), (9, 99);
update statistics on te with fullscan;
select /*+ recompile use_hash */ e.cb * 2, b.cb from te e left outer join tb b on e.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;
drop table if exists te;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-05: LEFT OUTER, empty build input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-05: LEFT OUTER, empty build input';
drop table if exists te, tf;
create table te (ca int, cb int);
create table tf (ca int, cb int);
insert into te values (9, 99), (9, 99);
update statistics on te, tf with fullscan;
select /*+ recompile use_hash */ e.cb + 1, nvl (f.cb, -1) from te e left outer join tf f on e.ca = f.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;
drop table if exists te, tf;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-06: LEFT OUTER, a row with a NULL join key
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-06: LEFT OUTER, a row with a NULL join key';
drop table if exists te;
create table te (ca int, cb int);
insert into te values (NULL, 5), (1, 6);
update statistics on te with fullscan;
select /*+ recompile use_hash */ e.cb + 1, nvl (b.cb, -1) from te e left outer join tb b on e.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;
drop table if exists te;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-07: LEFT OUTER, a non-equi ON term drops every row
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-07: LEFT OUTER, a non-equi ON term drops every row';
select /*+ recompile use_hash */ a.cb + 1, nvl (b.cb, -1) from ta a left outer join tb b on a.ca = b.ca and b.cb > a.cb * 100;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-08: SEMI, column
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-08: SEMI, column';
select /*+ recompile use_hash */ ta.ca from ta semi join tb on tb.ca = ta.ca;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-09: ANTI, column
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-09: ANTI, column';
select /*+ recompile use_hash */ ta.ca from ta anti join tb on tb.ca = ta.ca;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-10: SEMI, expression on the join key column
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-10: SEMI, expression on the join key column';
select /*+ recompile use_hash */ ta.ca + 1 from ta semi join tb on tb.ca = ta.ca;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-11: ANTI, empty build input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-11: ANTI, empty build input';
drop table if exists te, tf;
create table te (ca int, cb int);
create table tf (ca int, cb int);
insert into te values (9, 99), (9, 99);
update statistics on te, tf with fullscan;
select /*+ recompile use_hash */ e.cb * 2 from te e anti join tf f on f.ca = e.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;
drop table if exists te, tf;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-12: ANTI, expression on the join key column
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-12: ANTI, expression on the join key column';
select /*+ recompile use_hash */ ta.ca + 1 from ta anti join tb on tb.ca = ta.ca;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-13: SEMI, expression
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-13: SEMI, expression';
select /*+ recompile use_hash */ ta.cb * 2 from ta semi join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-14: ANTI, expression
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-14: ANTI, expression';
select /*+ recompile use_hash */ ta.cb * 2 from ta anti join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-15: IS NULL term after an outer join
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-15: IS NULL term after an outer join';
select /*+ recompile use_hash */ a.cb + 1, nvl (b.cb, -1) from ta a left outer join tb b on a.ca = b.ca where b.cb is null;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-16: expression term after an outer join
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-16: expression term after an outer join';
select /*+ recompile use_hash */ a.cb + 1, nvl (b.cb, -1) from ta a left outer join tb b on a.ca = b.ca where nvl (b.cb, 0) + a.cb > 100;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-17: EXISTS turned into a SEMI join
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-17: EXISTS turned into a SEMI join';
select /*+ recompile use_hash */ d.cb * 2 from td d where exists (select 1 from ta a where a.ca = d.ca);

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-18: NOT EXISTS turned into an ANTI join
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-18: NOT EXISTS turned into an ANTI join';
select /*+ recompile use_hash */ d.cb * 2 from td d where not exists (select 1 from ta a where a.ca = d.ca);

-- =====================================================================================================================
-- TC-1-07: a serial hash join evaluates a stored function
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-01: function without PARALLEL_ENABLE
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-01: function without PARALLEL_ENABLE';
select /*+ recompile use_hash */ f_plus (a.cb), b.cb from ta a, tb b where a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-02: function without PARALLEL_ENABLE in the parent join key
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-02: function without PARALLEL_ENABLE in the parent join key';
select /*+ recompile use_hash ordered */ a.cb, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and f_plus (a.ca) = c.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-03: PARALLEL_ENABLE function
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-03: PARALLEL_ENABLE function';
select /*+ recompile use_hash */ f_plus_px (a.cb), b.cb from ta a, tb b where a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-04: PARALLEL_ENABLE function in the parent join key
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-04: PARALLEL_ENABLE function in the parent join key';
select /*+ recompile use_hash ordered */ a.cb, b.cb, c.cb from ta a, tb b, tc c where a.ca = b.ca and f_plus_px (a.ca) = c.cb;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-05: empty build input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-05: empty build input';
drop table if exists te;
create table te (ca int, cb int);
update statistics on te with fullscan;
select /*+ recompile use_hash */ f_plus (a.cb), e.cb from ta a, te e where a.ca = e.ca;
drop table if exists te;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-06: LEFT OUTER, function without PARALLEL_ENABLE
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-06: LEFT OUTER, function without PARALLEL_ENABLE';
select /*+ recompile use_hash */ f_plus (nvl (b.cb, 0)), a.cb from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-07: LEFT OUTER, PARALLEL_ENABLE function
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-07: LEFT OUTER, PARALLEL_ENABLE function';
select /*+ recompile use_hash */ f_plus_px (nvl (b.cb, 0)), a.cb from ta a left outer join tb b on a.ca = b.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-08: SEMI, function without PARALLEL_ENABLE
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-08: SEMI, function without PARALLEL_ENABLE';
select /*+ recompile use_hash */ f_plus (ta.cb) from ta semi join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-09: ANTI, function without PARALLEL_ENABLE
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-09: ANTI, function without PARALLEL_ENABLE';
select /*+ recompile use_hash */ f_plus (ta.cb) from ta anti join tb on tb.ca = ta.ca;
select regexp_count (trace_stats (), 'SCAN \(temp') as temp_scans, regexp_count (trace_stats (), 'SCAN \(temp[^)]*readrows: 0,') as taken_over from db_root;


set trace off;
drop table if exists ta, tb, tc, td, t73, t74;
drop function f_plus;
drop function f_plus_px;

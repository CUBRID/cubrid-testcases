/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A hash join hashes a NUMERIC key by its value. The change makes NUMERIC values of different declared scales that
 *  compare equal, such as 1.5 in NUMERIC(38,1) and in NUMERIC(38,20), get one hash. Each hash join is followed by its
 *  nested loop join twin, and the two results must match row by row. SHOW TRACE shows HASHJOIN. Cases 1 to 55 join each
 *  pair of the tn_<n> tables in the order of tn_zero, tn_one, tn_two, tn_three, tn_nine, tn_ten, tn_eighteen,
 *  tn_nineteen, tn_twenty, tn_thirtyseven, tn_thirtyeight: Case 1 joins tn_zero and tn_one, Case 55 tn_thirtyseven and
 *  tn_thirtyeight.
 *
 *  Coverage:
 *    Case 1 to 55:  NUMERIC - hash join of each pair of the tn_<n> tables returns the pairs of the nested loop join
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- tn_<n> holds NUMERIC(38,<n>) values. The names are in letters because CTP masks digits in a trace
-- ca stands for one value in every tn_<n> table, and each table holds the values that fit its scale
-- ca | cb
-- ---+-----------------------------------------
--  1 | 0
--  2 | 1
--  3 | 100
--  4 | 0.5
--  5 | 0.25
--  6 | 0.1
--  7 | 0.01
--  8 | 0.001
--  9 | 0.000001
-- 10 | 1.5
-- 11 | 12.34
-- 12 | 9.9
-- 13 | -0.5
-- 14 | 0.1234567890123456789
-- 15 | 0.00000000000000000001
-- 16 | 0.12345678901234567890123456789012345678
-- 17 | -1.0
-- 18 | -12.3
-- 19 | -123456789.0
DROP TABLE IF EXISTS tn_zero;
CREATE TABLE tn_zero (ca INT, cb NUMERIC(38,0));
INSERT INTO tn_zero VALUES (1, 0), (2, 1), (3, 100), (17, -1.0), (19, -123456789.0);

DROP TABLE IF EXISTS tn_one;
CREATE TABLE tn_one (ca INT, cb NUMERIC(38,1));
INSERT INTO tn_one VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (6, 0.1),
  (10, 1.5),
  (12, 9.9),
  (13, -0.5),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS tn_two;
CREATE TABLE tn_two (ca INT, cb NUMERIC(38,2));
INSERT INTO tn_two VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS tn_three;
CREATE TABLE tn_three (ca INT, cb NUMERIC(38,3));
INSERT INTO tn_three VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS tn_nine;
CREATE TABLE tn_nine (ca INT, cb NUMERIC(38,9));
INSERT INTO tn_nine VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS tn_ten;
CREATE TABLE tn_ten (ca INT, cb NUMERIC(38,10));
INSERT INTO tn_ten VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS tn_eighteen;
CREATE TABLE tn_eighteen (ca INT, cb NUMERIC(38,18));
INSERT INTO tn_eighteen VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS tn_nineteen;
CREATE TABLE tn_nineteen (ca INT, cb NUMERIC(38,19));
INSERT INTO tn_nineteen VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (14, 0.1234567890123456789),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS tn_twenty;
CREATE TABLE tn_twenty (ca INT, cb NUMERIC(38,20));
INSERT INTO tn_twenty VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (14, 0.1234567890123456789),
  (15, 0.00000000000000000001),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS tn_thirtyseven;
CREATE TABLE tn_thirtyseven (ca INT, cb NUMERIC(38,37));
INSERT INTO tn_thirtyseven VALUES
  (1, 0),
  (2, 1),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (10, 1.5),
  (12, 9.9),
  (13, -0.5),
  (14, 0.1234567890123456789),
  (15, 0.00000000000000000001),
  (17, -1.0);

DROP TABLE IF EXISTS tn_thirtyeight;
CREATE TABLE tn_thirtyeight (ca INT, cb NUMERIC(38,38));
INSERT INTO tn_thirtyeight VALUES
  (1, 0),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (13, -0.5),
  (14, 0.1234567890123456789),
  (15, 0.00000000000000000001),
  (16, 0.12345678901234567890123456789012345678);

UPDATE STATISTICS ON tn_zero, tn_one, tn_two, tn_three, tn_nine, tn_ten, tn_eighteen, tn_nineteen, tn_twenty, tn_thirtyseven, tn_thirtyeight WITH FULLSCAN;

evaluate 'Case 1: NUMERIC - hash join of tn_zero and tn_one returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_zero x, tn_one y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_zero x, tn_one y where x.cb = y.cb order by 1, 2;

evaluate 'Case 2: NUMERIC - hash join of tn_zero and tn_two returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_zero x, tn_two y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_zero x, tn_two y where x.cb = y.cb order by 1, 2;

evaluate 'Case 3: NUMERIC - hash join of tn_zero and tn_three returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_zero x, tn_three y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_zero x, tn_three y where x.cb = y.cb order by 1, 2;

evaluate 'Case 4: NUMERIC - hash join of tn_zero and tn_nine returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_zero x, tn_nine y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_zero x, tn_nine y where x.cb = y.cb order by 1, 2;

evaluate 'Case 5: NUMERIC - hash join of tn_zero and tn_ten returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_zero x, tn_ten y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_zero x, tn_ten y where x.cb = y.cb order by 1, 2;

evaluate 'Case 6: NUMERIC - hash join of tn_zero and tn_eighteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_zero x, tn_eighteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_zero x, tn_eighteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 7: NUMERIC - hash join of tn_zero and tn_nineteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_zero x, tn_nineteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_zero x, tn_nineteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 8: NUMERIC - hash join of tn_zero and tn_twenty returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_zero x, tn_twenty y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_zero x, tn_twenty y where x.cb = y.cb order by 1, 2;

evaluate 'Case 9: NUMERIC - hash join of tn_zero and tn_thirtyseven returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_zero x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_zero x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;

evaluate 'Case 10: NUMERIC - hash join of tn_zero and tn_thirtyeight returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_zero x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_zero x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;

evaluate 'Case 11: NUMERIC - hash join of tn_one and tn_two returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_one x, tn_two y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_one x, tn_two y where x.cb = y.cb order by 1, 2;

evaluate 'Case 12: NUMERIC - hash join of tn_one and tn_three returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_one x, tn_three y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_one x, tn_three y where x.cb = y.cb order by 1, 2;

evaluate 'Case 13: NUMERIC - hash join of tn_one and tn_nine returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_one x, tn_nine y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_one x, tn_nine y where x.cb = y.cb order by 1, 2;

evaluate 'Case 14: NUMERIC - hash join of tn_one and tn_ten returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_one x, tn_ten y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_one x, tn_ten y where x.cb = y.cb order by 1, 2;

evaluate 'Case 15: NUMERIC - hash join of tn_one and tn_eighteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_one x, tn_eighteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_one x, tn_eighteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 16: NUMERIC - hash join of tn_one and tn_nineteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_one x, tn_nineteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_one x, tn_nineteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 17: NUMERIC - hash join of tn_one and tn_twenty returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_one x, tn_twenty y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_one x, tn_twenty y where x.cb = y.cb order by 1, 2;

evaluate 'Case 18: NUMERIC - hash join of tn_one and tn_thirtyseven returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_one x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_one x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;

evaluate 'Case 19: NUMERIC - hash join of tn_one and tn_thirtyeight returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_one x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_one x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;

evaluate 'Case 20: NUMERIC - hash join of tn_two and tn_three returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_two x, tn_three y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_two x, tn_three y where x.cb = y.cb order by 1, 2;

evaluate 'Case 21: NUMERIC - hash join of tn_two and tn_nine returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_two x, tn_nine y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_two x, tn_nine y where x.cb = y.cb order by 1, 2;

evaluate 'Case 22: NUMERIC - hash join of tn_two and tn_ten returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_two x, tn_ten y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_two x, tn_ten y where x.cb = y.cb order by 1, 2;

evaluate 'Case 23: NUMERIC - hash join of tn_two and tn_eighteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_two x, tn_eighteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_two x, tn_eighteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 24: NUMERIC - hash join of tn_two and tn_nineteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_two x, tn_nineteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_two x, tn_nineteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 25: NUMERIC - hash join of tn_two and tn_twenty returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_two x, tn_twenty y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_two x, tn_twenty y where x.cb = y.cb order by 1, 2;

evaluate 'Case 26: NUMERIC - hash join of tn_two and tn_thirtyseven returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_two x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_two x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;

evaluate 'Case 27: NUMERIC - hash join of tn_two and tn_thirtyeight returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_two x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_two x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;

evaluate 'Case 28: NUMERIC - hash join of tn_three and tn_nine returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_three x, tn_nine y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_three x, tn_nine y where x.cb = y.cb order by 1, 2;

evaluate 'Case 29: NUMERIC - hash join of tn_three and tn_ten returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_three x, tn_ten y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_three x, tn_ten y where x.cb = y.cb order by 1, 2;

evaluate 'Case 30: NUMERIC - hash join of tn_three and tn_eighteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_three x, tn_eighteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_three x, tn_eighteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 31: NUMERIC - hash join of tn_three and tn_nineteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_three x, tn_nineteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_three x, tn_nineteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 32: NUMERIC - hash join of tn_three and tn_twenty returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_three x, tn_twenty y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_three x, tn_twenty y where x.cb = y.cb order by 1, 2;

evaluate 'Case 33: NUMERIC - hash join of tn_three and tn_thirtyseven returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_three x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_three x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;

evaluate 'Case 34: NUMERIC - hash join of tn_three and tn_thirtyeight returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_three x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_three x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;

evaluate 'Case 35: NUMERIC - hash join of tn_nine and tn_ten returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_nine x, tn_ten y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_nine x, tn_ten y where x.cb = y.cb order by 1, 2;

evaluate 'Case 36: NUMERIC - hash join of tn_nine and tn_eighteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_nine x, tn_eighteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_nine x, tn_eighteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 37: NUMERIC - hash join of tn_nine and tn_nineteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_nine x, tn_nineteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_nine x, tn_nineteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 38: NUMERIC - hash join of tn_nine and tn_twenty returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_nine x, tn_twenty y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_nine x, tn_twenty y where x.cb = y.cb order by 1, 2;

evaluate 'Case 39: NUMERIC - hash join of tn_nine and tn_thirtyseven returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_nine x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_nine x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;

evaluate 'Case 40: NUMERIC - hash join of tn_nine and tn_thirtyeight returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_nine x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_nine x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;

evaluate 'Case 41: NUMERIC - hash join of tn_ten and tn_eighteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_ten x, tn_eighteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_ten x, tn_eighteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 42: NUMERIC - hash join of tn_ten and tn_nineteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_ten x, tn_nineteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_ten x, tn_nineteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 43: NUMERIC - hash join of tn_ten and tn_twenty returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_ten x, tn_twenty y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_ten x, tn_twenty y where x.cb = y.cb order by 1, 2;

evaluate 'Case 44: NUMERIC - hash join of tn_ten and tn_thirtyseven returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_ten x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_ten x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;

evaluate 'Case 45: NUMERIC - hash join of tn_ten and tn_thirtyeight returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_ten x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_ten x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;

evaluate 'Case 46: NUMERIC - hash join of tn_eighteen and tn_nineteen returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_eighteen x, tn_nineteen y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_eighteen x, tn_nineteen y where x.cb = y.cb order by 1, 2;

evaluate 'Case 47: NUMERIC - hash join of tn_eighteen and tn_twenty returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_eighteen x, tn_twenty y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_eighteen x, tn_twenty y where x.cb = y.cb order by 1, 2;

evaluate 'Case 48: NUMERIC - hash join of tn_eighteen and tn_thirtyseven returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_eighteen x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_eighteen x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;

evaluate 'Case 49: NUMERIC - hash join of tn_eighteen and tn_thirtyeight returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_eighteen x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_eighteen x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;

evaluate 'Case 50: NUMERIC - hash join of tn_nineteen and tn_twenty returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_nineteen x, tn_twenty y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_nineteen x, tn_twenty y where x.cb = y.cb order by 1, 2;

evaluate 'Case 51: NUMERIC - hash join of tn_nineteen and tn_thirtyseven returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_nineteen x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_nineteen x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;

evaluate 'Case 52: NUMERIC - hash join of tn_nineteen and tn_thirtyeight returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_nineteen x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_nineteen x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;

evaluate 'Case 53: NUMERIC - hash join of tn_twenty and tn_thirtyseven returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_twenty x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_twenty x, tn_thirtyseven y where x.cb = y.cb order by 1, 2;

evaluate 'Case 54: NUMERIC - hash join of tn_twenty and tn_thirtyeight returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_twenty x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_twenty x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;

evaluate 'Case 55: NUMERIC - hash join of tn_thirtyseven and tn_thirtyeight returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tn_thirtyseven x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tn_thirtyseven x, tn_thirtyeight y where x.cb = y.cb order by 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS tn_zero, tn_one, tn_two, tn_three, tn_nine, tn_ten, tn_eighteen, tn_nineteen, tn_twenty, tn_thirtyseven, tn_thirtyeight;

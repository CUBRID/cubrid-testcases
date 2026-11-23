/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A JSON value compares as the SQL value it converts to: 1 equals 1.0, true equals "true", "0x10" equals 16, and an
 *  object compares by its body text. The change hashes a JSON key as it compares, and the hash join compares the key
 *  with coercion as the join term does. Before the change, the hash join missed pairs of equal JSON keys, so each hash
 *  join must return the pairs of its nested loop join twin, and the hash GROUP BY the groups of the sort GROUP BY. SHOW
 *  TRACE shows HASHJOIN.
 *
 *  Coverage:
 *    Case 1:  JSON - hash join returns the pairs of the nested loop join
 *    Case 2:  JSON - hash join with the other build side returns the pairs of the nested loop join
 *    Case 3:  JSON - hash GROUP BY returns the groups of the sort GROUP BY
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- JSON values of ta; tb holds values that compare equal to some of them, and others
-- ca | cb
-- ---+-------------------
--  1 | 1
--  2 | -0.0
--  3 | true
--  4 | "a"
--  5 | [1, 2]
--  6 | {"a": 1}
--  7 | 1.5
--  8 | 9007199254740993   (2^53 + 1)
--  9 | 16
-- 10 | 0
-- 11 | null
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb JSON);
INSERT INTO ta VALUES
  (1, '1'),
  (2, '-0.0'),
  (3, 'true'),
  (4, '"a"'),
  (5, '[1, 2]'),
  (6, '{"a": 1}'),
  (7, '1.5'),
  (8, '9007199254740993'),
  (9, '16'),
  (10, '0'),
  (11, 'null');

-- ca | cb
-- ---+---------------------
-- 11 | 1.0
-- 12 | 0.0
-- 13 | "true"
-- 14 | "a"
-- 15 | [1,2]
-- 16 | {"a":1}
-- 17 | 1
-- 18 | "1.5"
-- 19 | "  1  "               (1 with spaces around it)
-- 20 | 9007199254740992.0   (2^53)
-- 21 | "0x10"               (16 in hexadecimal)
-- 22 | ""                   (the empty string)
-- 23 | "abc"
-- 24 | "A"
-- 25 | null
-- 26 | "[1,2]"              (a string, not an array)
CREATE TABLE tb (ca INT, cb JSON);
INSERT INTO tb VALUES
  (11, '1.0'),
  (12, '0.0'),
  (13, '"true"'),
  (14, '"a"'),
  (15, '[1,2]'),
  (16, '{"a":1}'),
  (17, '1'),
  (18, '"1.5"'),
  (19, '"  1  "'),
  (20, '9007199254740992.0'),
  (21, '"0x10"'),
  (22, '""'),
  (23, '"abc"'),
  (24, '"A"'),
  (25, 'null'),
  (26, '"[1,2]"');

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 1: JSON - hash join returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;

evaluate 'Case 2: JSON - hash join with the other build side returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM tb, ta WHERE ta.cb = tb.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM tb, ta WHERE ta.cb = tb.cb ORDER BY 1, 2;

evaluate 'Case 3: JSON - hash GROUP BY returns the groups of the sort GROUP BY';
-- true and "true" (ta.ca 3, tb.ca 13) are left out: the sort GROUP BY tells them apart, the hash GROUP BY does not,
-- before the change as after it
DROP TABLE IF EXISTS tc;
CREATE TABLE tc AS SELECT * FROM ta WHERE ca <> 3 UNION ALL SELECT * FROM tb WHERE ca <> 13;
set trace on;
SELECT /*+ PARALLEL(0) */ MIN (ca), COUNT (*) FROM tc GROUP BY cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_HASH_AGGREGATE */ MIN (ca), COUNT (*) FROM tc GROUP BY cb ORDER BY 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb, tc;

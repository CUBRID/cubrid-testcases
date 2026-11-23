/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A collection element compares with coercion. BIGINT and NUMERIC(24,4) elements of one value hash alike, so their
 *  hash join returns the pairs of its nested loop join twin. BIGINT or NUMERIC elements against DOUBLE elements compare
 *  through DOUBLE, which can hash apart from the exact value, so the planner joins them by nested loop under a hash
 *  join hint. SHOW TRACE shows which join runs.
 *
 *  Coverage:
 *    Case 1:  MULTISET - hash join of BIGINT and NUMERIC(24,4) elements returns the pairs of the nested loop join
 *    Case 2:  MULTISET - BIGINT and DOUBLE elements join by nested loop, with its pairs
 *    Case 3:  MULTISET - NUMERIC(24,4) and DOUBLE elements join by nested loop, with its pairs
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- one value in three element types; 495038888524330534 has 18 digits, 9007199254740993 is 2^53 + 1
DROP TABLE IF EXISTS tc, tb, ta;

-- ta: BIGINT elements
-- ca | cb
-- ---+----------------------
-- 31 | {1}
-- 32 | {495038888524330534}
-- 33 | {9007199254740993}
CREATE TABLE ta (ca INT, cb MULTISET (BIGINT));
INSERT INTO ta VALUES
  (31, {1}),
  (32, {495038888524330534}),
  (33, {9007199254740993});

-- tb: NUMERIC(24,4) elements of the same values
-- ca | cb
-- ---+---------------------------
-- 41 | {1.0000}
-- 42 | {495038888524330534.0000}
-- 43 | {9007199254740993.0000}
CREATE TABLE tb (ca INT, cb MULTISET (NUMERIC (24, 4)));
INSERT INTO tb VALUES
  (41, {1.0000}),
  (42, {495038888524330534.0000}),
  (43, {9007199254740993.0000});

-- tc: DOUBLE elements; tc.ca 53 holds 2^53, the DOUBLE nearest to 2^53 + 1
-- ca | cb
-- ---+-------------------------
-- 51 | {1.0}
-- 52 | {495038888524330534.0}
-- 53 | {9007199254740992.0}
CREATE TABLE tc (ca INT, cb MULTISET (DOUBLE));
INSERT INTO tc VALUES
  (51, {1.0}),
  (52, {495038888524330534.0}),
  (53, {9007199254740992.0});

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

evaluate 'Case 1: MULTISET - hash join of BIGINT and NUMERIC(24,4) elements returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;

evaluate 'Case 2: MULTISET - BIGINT and DOUBLE elements join by nested loop, with its pairs';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tc.ca FROM ta, tc WHERE ta.cb = tc.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tc.ca FROM ta, tc WHERE ta.cb = tc.cb ORDER BY 1, 2;

evaluate 'Case 3: MULTISET - NUMERIC(24,4) and DOUBLE elements join by nested loop, with its pairs';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tb.ca, tc.ca FROM tb, tc WHERE tb.cb = tc.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tb.ca, tc.ca FROM tb, tc WHERE tb.cb = tc.cb ORDER BY 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb, tc;

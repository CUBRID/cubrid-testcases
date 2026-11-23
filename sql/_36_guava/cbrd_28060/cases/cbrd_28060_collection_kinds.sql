/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  SET, MULTISET and SEQUENCE keys compare across kinds: a SET keeps its elements sorted and once, a MULTISET compares
 *  sorted, a SEQUENCE in its order. A key of two collection kinds hashes in the domain of one, the other converted into
 *  it with its elements, and each hash join must return the pairs of its nested loop join twin.
 *
 *  Coverage:
 *    Case 1:  SET, MULTISET and SEQUENCE across kinds - hash join returns the pairs of the nested loop join
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- a key of two collection kinds hashes in the domain of one, the other converted into it with its elements, and its
-- pairs compare with coercion; a SET keeps its elements sorted and once ({2, 1} and {1, 2, 2} hold {1, 2}), a MULTISET
-- compares sorted, a SEQUENCE in its order
DROP TABLE IF EXISTS ta, tb, tc, td;

-- ta: SET (INT)
-- ca | cb
-- ---+----------
--  1 | {1, 2}
--  2 | {2, 1}
--  3 | {3}
--  4 | {1, 2, 2}
--  5 | {}
CREATE TABLE ta (ca INT, cb SET (INT));
INSERT INTO ta VALUES (1, {1, 2}), (2, {2, 1}), (3, {3}), (4, {1, 2, 2}), (5, {});

-- tb: SEQUENCE (INT)
-- ca | cb
-- ---+----------
-- 11 | {1, 2}
-- 12 | {2, 1}
-- 13 | {3}
-- 14 | {1, 2, 2}
-- 15 | {}
-- 16 | {1, 1, 2}
CREATE TABLE tb (ca INT, cb SEQUENCE (INT));
INSERT INTO tb VALUES (11, {1, 2}), (12, {2, 1}), (13, {3}), (14, {1, 2, 2}), (15, {}), (16, {1, 1, 2});

-- tc: SEQUENCE (NUMERIC (10, 2))
-- ca | cb
-- ---+-------------
-- 21 | {1.00, 2.00}
-- 22 | {2.00, 1.00}
-- 23 | {3.00}
-- 24 | {1.50}
CREATE TABLE tc (ca INT, cb SEQUENCE (NUMERIC (10, 2)));
INSERT INTO tc VALUES (21, {1.00, 2.00}), (22, {2.00, 1.00}), (23, {3.00}), (24, {1.50});

-- td: MULTISET (INT)
-- ca | cb
-- ---+----------
-- 31 | {1, 2}
-- 32 | {2, 1}
-- 33 | {1, 2, 2}
-- 34 | {1, 1, 2}
CREATE TABLE td (ca INT, cb MULTISET (INT));
INSERT INTO td VALUES (31, {1, 2}), (32, {2, 1}), (33, {1, 2, 2}), (34, {1, 1, 2});

UPDATE STATISTICS ON ta, tb, tc, td WITH FULLSCAN;

evaluate 'Case 1: SET, MULTISET and SEQUENCE across kinds - hash join returns the pairs of the nested loop join';
-- SET = SEQUENCE
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;
-- SET = SEQUENCE (NUMERIC): the elements of two types as well
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tc.ca FROM ta, tc WHERE ta.cb = tc.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tc.ca FROM ta, tc WHERE ta.cb = tc.cb ORDER BY 1, 2;
-- MULTISET = SEQUENCE
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ td.ca, tb.ca FROM td, tb WHERE td.cb = tb.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ td.ca, tb.ca FROM td, tb WHERE td.cb = tb.cb ORDER BY 1, 2;
-- SET = MULTISET
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, td.ca FROM ta, td WHERE ta.cb = td.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, td.ca FROM ta, td WHERE ta.cb = td.cb ORDER BY 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb, tc, td;

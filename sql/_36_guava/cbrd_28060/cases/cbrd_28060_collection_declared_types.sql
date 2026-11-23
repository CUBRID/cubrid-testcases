/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A collection declared with several element types hashes when all of them share one element hash type (exact numbers,
 *  DOUBLE and MONETARY, or strings of one collation), and its hash join returns the pairs of its nested loop join twin.
 *  One that mixes two hash types (INT and VARCHAR, INT and FLOAT) is joined by the nested loop under a hash join hint.
 *  SHOW TRACE shows which join runs.
 *
 *  Coverage:
 *    Case 1:  SET of several element types of one hash type - hash join returns the pairs of the nested loop join
 *    Case 2:  SET of element types of two hash types - joins by nested loop, with its pairs
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

DROP TABLE IF EXISTS ta, tb, tc, td, te, tf;

-- ta and tb: INT, BIGINT and NUMERIC(10,2) elements, which hash as the DOUBLE they equal
-- ta.ca | ta.cb                    | tb.ca | tb.cb
-- ------+--------------------------+-------+---------------------------------
--  101  | {1, 2}                   |  111  | {CAST (1 AS BIGINT), 2.00}
--  102  | {3}                      |  112  | {3.00}
--  103  | {CAST (5 AS BIGINT)}     |  113  | {5}
--       |                          |  114  | {4}
CREATE TABLE ta (ca INT, cb SET (INT, BIGINT, NUMERIC (10, 2)));
INSERT INTO ta VALUES
  (101, {1, 2}),
  (102, {3}),
  (103, {CAST (5 AS BIGINT)});
CREATE TABLE tb (ca INT, cb SET (INT, BIGINT, NUMERIC (10, 2)));
INSERT INTO tb VALUES
  (111, {CAST (1 AS BIGINT), 2.00}),
  (112, {3.00}),
  (113, {5}),
  (114, {4});

-- tc and td: VARCHAR and CHAR elements of one collation, which hash without the trailing pad
-- tc.ca | tc.cb      | td.ca | td.cb
-- ------+------------+-------+-------------------------------
--  121  | {'a'}      |  131  | {CAST ('a' AS CHAR (5))}
--  122  | {'b', 'c'} |  132  | {'c', CAST ('b' AS CHAR (5))}
--       |            |  133  | {'d'}
CREATE TABLE tc (ca INT, cb SET (VARCHAR (10), CHAR (5)));
INSERT INTO tc VALUES
  (121, {'a'}),
  (122, {'b', 'c'});
CREATE TABLE td (ca INT, cb SET (VARCHAR (10), CHAR (5)));
INSERT INTO td VALUES
  (131, {CAST ('a' AS CHAR (5))}),
  (132, {'c', CAST ('b' AS CHAR (5))}),
  (133, {'d'});

-- te and tf: INT and DOUBLE elements, which hash as the DOUBLE they equal
-- te.ca | te.cb       | tf.ca | tf.cb
-- ------+-------------+-------+-------------------------------
--  181  | {1, 2.5e0}  |  191  | {CAST (1 AS DOUBLE), 2.5e0}
--  182  | {3}         |  192  | {CAST (3 AS DOUBLE)}
--       |             |  193  | {4}
CREATE TABLE te (ca INT, cb SET (INT, DOUBLE));
INSERT INTO te VALUES
  (181, {1, 2.5e0}),
  (182, {3});
CREATE TABLE tf (ca INT, cb SET (INT, DOUBLE));
INSERT INTO tf VALUES
  (191, {CAST (1 AS DOUBLE), 2.5e0}),
  (192, {CAST (3 AS DOUBLE)}),
  (193, {4});

UPDATE STATISTICS ON ta, tb, tc, td, te, tf WITH FULLSCAN;

evaluate 'Case 1: SET of several element types of one hash type - hash join returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;
show trace;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tc.ca, td.ca FROM tc, td WHERE tc.cb = td.cb ORDER BY 1, 2;
show trace;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ te.ca, tf.ca FROM te, tf WHERE te.cb = tf.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;
SELECT /*+ NO_USE_HASH USE_NL */ tc.ca, td.ca FROM tc, td WHERE tc.cb = td.cb ORDER BY 1, 2;
SELECT /*+ NO_USE_HASH USE_NL */ te.ca, tf.ca FROM te, tf WHERE te.cb = tf.cb ORDER BY 1, 2;

-- {1} = {'1'} in tg and th, and INT 16777217 = FLOAT 16777216 in ti and tj: the comparison coerces the elements,
-- the element hash tells them apart
DROP TABLE IF EXISTS tg, th, ti, tj;

-- tg and th: INT and VARCHAR elements
-- tg.ca | tg.cb | th.ca | th.cb
-- ------+-------+-------+-------
--  141  | {1}   |  151  | {'1'}
--  142  | {'x'} |  152  | {1}
--       |       |  153  | {'x'}
CREATE TABLE tg (ca INT, cb SET (INT, VARCHAR (10)));
INSERT INTO tg VALUES
  (141, {1}),
  (142, {'x'});
CREATE TABLE th (ca INT, cb SET (INT, VARCHAR (10)));
INSERT INTO th VALUES
  (151, {'1'}),
  (152, {1}),
  (153, {'x'});

-- ti and tj: INT and FLOAT elements; 16777217 is 2^24 + 1, which FLOAT rounds to 2^24
-- ti.ca | ti.cb      | tj.ca | tj.cb
-- ------+------------+-------+------------------------------
--  161  | {16777217} |  171  | {CAST (16777216 AS FLOAT)}
--       |            |  172  | {16777217}
CREATE TABLE ti (ca INT, cb SET (INT, FLOAT));
INSERT INTO ti VALUES
  (161, {16777217});
CREATE TABLE tj (ca INT, cb SET (INT, FLOAT));
INSERT INTO tj VALUES
  (171, {CAST (16777216 AS FLOAT)}),
  (172, {16777217});

UPDATE STATISTICS ON tg, th, ti, tj WITH FULLSCAN;

evaluate 'Case 2: SET of element types of two hash types - joins by nested loop, with its pairs';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tg.ca, th.ca FROM tg, th WHERE tg.cb = th.cb ORDER BY 1, 2;
show trace;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ti.ca, tj.ca FROM ti, tj WHERE ti.cb = tj.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tg.ca, th.ca FROM tg, th WHERE tg.cb = th.cb ORDER BY 1, 2;
SELECT /*+ NO_USE_HASH USE_NL */ ti.ca, tj.ca FROM ti, tj WHERE ti.cb = tj.cb ORDER BY 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb, tc, td, te, tf, tg, th, ti, tj;

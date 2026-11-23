/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A NUMERIC element of no precision keeps the scale of its value. Elements of one value and other scales ({1.5} and
 *  {1.50}) compare equal and must hash alike, so the hash join returns the pairs of its nested loop join twin.
 *
 *  Coverage:
 *    Case 1:  SET OF NUMERIC - hash join of elements of their own scale (1.5 and 1.50) returns the pairs of the nested
 *             loop join
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- a NUMERIC element of no precision keeps the scale of its value: {1.5} = {1.50} and {2} = {2.000}
DROP TABLE IF EXISTS tb, ta;

-- ta.ca | ta.cb | tb.ca | tb.cb
-- -------+--------+--------+--------
--  1     | {1.5}  |  11    | {1.50}
--  2     | {2}    |  12    | {2.000}
CREATE TABLE ta (ca INT, cb SET (NUMERIC));
INSERT INTO ta VALUES (1, {1.5}), (2, {2});
CREATE TABLE tb (ca INT, cb SET (NUMERIC));
INSERT INTO tb VALUES (11, {1.50}), (12, {2.000});

evaluate 'Case 1: SET OF NUMERIC - hash join of elements of their own scale (1.5 and 1.50) returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb;

/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A SET OF a class holds OIDs, which the change hashes as it compares them. The hash join of SET OF a class keys must
 *  return the pairs of its nested loop join twin.
 *
 *  Coverage:
 *    Case 1:  SET OF a class - hash join returns the pairs of the nested loop join
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

evaluate 'Case 1: SET OF a class - hash join returns the pairs of the nested loop join';
-- tb and tc hold a set of one ta object each: tb.ca 1 and tc.ca 11 the object of ca 1, 2 and 12 of ca 2
DROP TABLE IF EXISTS tb, tc, ta;
CREATE TABLE ta (ca INT) DONT_REUSE_OID;
INSERT INTO ta VALUES (1), (2);
CREATE TABLE tb (ca INT, cb SET OF ta);
CREATE TABLE tc (ca INT, cb SET OF ta);
INSERT INTO tb SELECT x.ca, {x} FROM ta x;
INSERT INTO tc SELECT x.ca + 10, {x} FROM ta x;
UPDATE STATISTICS ON tb, tc WITH FULLSCAN;
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tb.ca, tc.ca FROM tb, tc WHERE tb.cb = tc.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tb.ca, tc.ca FROM tb, tc WHERE tb.cb = tc.cb ORDER BY 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb, tc;

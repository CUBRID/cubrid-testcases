/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A MULTISET compares sorted, whatever the order of its elements. The change hashes a multiset as it compares. Before
 *  the change, the hash join missed pairs of equal multisets whose elements are stored in another order, so the hash
 *  join must return the pairs of its nested loop join twin. SHOW TRACE shows HASHJOIN.
 *
 *  Coverage:
 *    Case 1:  MULTISET - hash join of unsorted multisets returns the pairs of the nested loop join
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- ta.ca 1 holds 200 elements inserted out of order, which leaves the multiset unsorted;
-- ta.ca 2 and 3 hold one element twice; tb holds the same multisets and others of the same elements
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb MULTISET (INT));
INSERT INTO ta VALUES (1, {200,199,198,197,196,195,194,193,192,191,190,189,188,187,186,185,184,183,182,181,180,179,178,177,176,175,174,173,172,171,170,169,168,167,166,165,164,163,162,161,160,159,158,157,156,155,154,153,152,151,150,149,148,147,146,145,144,143,142,141,140,139,138,137,136,135,134,133,132,131,130,129,128,127,126,125,124,123,122,121,120,119,118,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,102,101,100,99,98,97,96,95,94,93,92,91,90,89,88,87,86,85,84,83,82,81,80,79,78,77,76,75,74,73,72,71,70,69,68,67,66,65,64,63,62,61,60,59,58,57,56,55,54,53,52,51,50,49,48,47,46,45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1});

-- ca | cb
-- ---+----------
--  2 | {1, 1, 2}
--  3 | {1, 2, 2}
INSERT INTO ta VALUES (2, {1, 1, 2}), (3, {1, 2, 2});

CREATE TABLE tb (ca INT, cb MULTISET (INT));
INSERT INTO tb SELECT ca + 10, cb FROM ta;

-- the multisets of ta.ca 2 and 3 in another order, and one of the same elements of another count
-- ca | cb
-- ---+----------
-- 14 | {2, 1, 1}
-- 15 | {2, 2, 1}
-- 16 | {1, 2}
INSERT INTO tb VALUES (14, {2, 1, 1}), (15, {2, 2, 1}), (16, {1, 2});

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 1: MULTISET - hash join of unsorted multisets returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb;

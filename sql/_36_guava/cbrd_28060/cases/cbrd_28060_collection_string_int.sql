/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  Collection elements that compare equal only with coercion, a VARCHAR element 1 and an INT element 1, hash apart, so
 *  the planner leaves the join of a VARCHAR and an INT multiset to the nested loop under a hash join hint, and the join
 *  returns the pairs of its nested loop join twin. SHOW TRACE shows which join runs.
 *
 *  Coverage:
 *    Case 1:  MULTISET - VARCHAR and INT elements join by nested loop, with its pairs
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- {'1'} = {1}: the comparison coerces the elements, the element hash tells them apart.
DROP TABLE IF EXISTS ta, tb;

-- ta: VARCHAR elements
-- ca | cb
-- ---+-----------
-- 61 | {'1'}
-- 62 | {'2'}
-- 63 | {'1', '2'}
CREATE TABLE ta (ca INT, cb MULTISET (VARCHAR (10)));
INSERT INTO ta VALUES
  (61, {'1'}),
  (62, {'2'}),
  (63, {'1', '2'});

-- tb: INT elements
-- ca | cb
-- ---+-------
-- 71 | {1}
-- 72 | {3}
-- 73 | {2, 1}
CREATE TABLE tb (ca INT, cb MULTISET (INT));
INSERT INTO tb VALUES
  (71, {1}),
  (72, {3}),
  (73, {2, 1});

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 1: MULTISET - VARCHAR and INT elements join by nested loop, with its pairs';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb;

/**
 *  This test case verifies CBRD-28029 #14: a merge join (USE_MERGE) whose keys are expressions on both sides and whose two tables have no
 *  column used above it must stay in the plan: it must neither vanish (leaving the outer rows only) nor fail.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t14x, t14o, t14i;
CREATE TABLE t14x (c INT);
CREATE TABLE t14o (c INT);
CREATE TABLE t14i (c INT);
INSERT INTO t14x VALUES (1), (2);
INSERT INTO t14o VALUES (1), (1), (3);
INSERT INTO t14i VALUES (1), (2);
-- o.c = 1 (2 rows) matches i.c = 1 (1 row): 2 pairs, times the 2 rows of x
-- expected: rows: 4
evaluate 'Case 14-1';
SELECT /*+ USE_MERGE RECOMPILE */ COUNT(*) AS cnt FROM t14x x, t14o o, t14i i WHERE o.c + 0 = i.c + 0;
-- expected: rows: 0
evaluate 'Case 14-2';
SELECT /*+ USE_MERGE RECOMPILE */ COUNT(*) AS cnt FROM t14x x, t14o o, t14i i WHERE o.c + 0 = i.c + 10;
-- expected: rows: 0
evaluate 'Case 14-3';
SELECT /*+ USE_MERGE RECOMPILE */ COUNT(*) AS cnt FROM t14x x, t14o o LEFT OUTER JOIN t14i i ON o.c + 0 = i.c + 10 WHERE i.c IS NOT NULL;
-- expected: rows: 3
evaluate 'Case 14-4';
SELECT /*+ USE_MERGE RECOMPILE */ COUNT(*) AS cnt FROM t14o o LEFT OUTER JOIN t14i i ON o.c + 0 = i.c + 0;
-- expected: rows: 4
evaluate 'Case 14-c1';
SELECT /*+ USE_MERGE RECOMPILE */ COUNT(o.c) AS cnt FROM t14x x, t14o o, t14i i WHERE o.c + 0 = i.c + 0;
-- expected: rows: 1 / 1 / 2 / 2
evaluate 'Case 14-5';
SELECT /*+ USE_MERGE RECOMPILE */ x.c FROM t14x x, t14o o, t14i i WHERE o.c + 0 = i.c + 0 ORDER BY 1;
-- expected: rows: 4
evaluate 'Case 14-6';
SELECT /*+ USE_MERGE RECOMPILE */ COUNT(*) AS cnt FROM t14x x, t14o o, t14i i WHERE CAST(o.c AS VARCHAR) = CAST(i.c AS VARCHAR);
-- expected: rows: 'r' / 'r' / 'r'
evaluate 'Case 14-7';
SELECT /*+ USE_MERGE RECOMPILE */ 'r' AS r FROM t14o o LEFT OUTER JOIN t14i i ON o.c + 0 = i.c + 0;
-- expected: rows: 3
evaluate 'Case 14-8';
SELECT /*+ USE_MERGE RECOMPILE */ COUNT(*) AS cnt FROM t14i i RIGHT OUTER JOIN t14o o ON o.c + 0 = i.c + 0;
-- expected: rows: 4
evaluate 'Case 14-9';
SELECT /*+ USE_MERGE RECOMPILE */ COUNT(*) AS cnt FROM t14x x, t14o o, t14i i WHERE o.c + 0 = i.c + 0 AND o.c * 1 = i.c * 1;
-- expected: rows: 2
evaluate 'Case 14-10';
SELECT /*+ USE_MERGE RECOMPILE */ COUNT(*) AS cnt FROM t14o o, t14i i WHERE o.c + 0 = i.c + 0;
-- expected: rows: 4
evaluate 'Case 14-11';
SELECT /*+ USE_MERGE RECOMPILE */ COUNT(*) AS cnt FROM t14x x INNER JOIN t14o o ON 1 = 1 INNER JOIN t14i i ON o.c + 0 = i.c + 0;
-- expected: rows: 1 | 2 / 2 | 2
evaluate 'Case 14-12';
SELECT /*+ USE_MERGE RECOMPILE */ x.c, COUNT(*) AS cnt FROM t14x x, t14o o, t14i i WHERE o.c + 0 = i.c + 0 GROUP BY x.c ORDER BY 1;
-- expected: rows: 6
evaluate 'Case 14-13';
SELECT /*+ USE_MERGE RECOMPILE */ COUNT(*) AS cnt FROM t14x x, t14o o LEFT OUTER JOIN t14i i ON o.c + 0 = i.c + 0;
-- twins with the other join methods
-- expected: rows: 4
evaluate 'Case 14-t1';
SELECT /*+ USE_HASH RECOMPILE */ COUNT(*) AS cnt FROM t14x x, t14o o, t14i i WHERE o.c + 0 = i.c + 0;
-- expected: rows: 4
evaluate 'Case 14-t2';
SELECT /*+ USE_NL RECOMPILE */ COUNT(*) AS cnt FROM t14x x, t14o o, t14i i WHERE o.c + 0 = i.c + 0;
-- expected: rows: 3
evaluate 'Case 14-t3';
SELECT /*+ USE_NL RECOMPILE */ COUNT(*) AS cnt FROM t14o o LEFT OUTER JOIN t14i i ON o.c + 0 = i.c + 0;
-- the merge join is in the plan
-- expected: rows: 4
evaluate 'Case 14-p1';
--@queryplan
SELECT /*+ USE_MERGE RECOMPILE */ COUNT(*) AS cnt FROM t14x x, t14o o, t14i i WHERE o.c + 0 = i.c + 0;
DROP TABLE t14x, t14o, t14i;

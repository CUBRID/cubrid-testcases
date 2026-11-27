/**
 *  This test case verifies CBRD-28029 (review of PR #8609, 11-19): #27 a NULL disjunct of a WHERE or ON term rejects the row as FALSE does and
 *  does not make the whole term false, so x = NULL OR y returns the rows of y, #28 an outer join is reduced by a
 *  comparison of a row value of inner columns (IN list, NOT IN, <>, <), since the row the outer join fills with
 *  NULL compares UNKNOWN, and a row with a NULL element is equal to no row.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t27, t28o, t28i;
CREATE TABLE t27 (a INT, b CHAR(10));
INSERT INTO t27 VALUES (1, '1'), (NULL, '3'), (3, NULL);
-- expected: rows: 1
evaluate 'Case 27-1';
SELECT a FROM t27 WHERE (a = NULL OR a = 1) ORDER BY 1;
-- expected: same: 27-1
evaluate 'Case 27-2';
SELECT a FROM t27 WHERE (a = 1 OR a = NULL) ORDER BY 1;
-- expected: rows: 1
evaluate 'Case 27-3';
SELECT a FROM t27 WHERE b IS NOT NULL AND (a = NULL OR a = 1 OR a = 3) ORDER BY 1;
-- expected: empty
evaluate 'Case 27-4';
SELECT a FROM t27 WHERE (a = NULL OR a = NULL);
-- expected: empty
evaluate 'Case 27-5';
SELECT a FROM t27 WHERE NOT (a = NULL OR a = 1);
-- expected: rows: NULL | NULL / 1 | 1 / 3 | NULL
evaluate 'Case 27-6';
SELECT x.a, y.a FROM t27 x LEFT JOIN t27 y ON x.a = y.a AND (y.a = NULL OR y.b = '1') ORDER BY 1;
-- expected: rows: 1 | 1
evaluate 'Case 27-7';
SELECT a, COUNT(*) FROM t27 GROUP BY a HAVING (a = NULL OR a = 1) ORDER BY 1;
CREATE TABLE t28o (id INT PRIMARY KEY);
CREATE TABLE t28i (id INT, a INT, b INT);
INSERT INTO t28o VALUES (1), (2), (3), (4), (5), (6);
INSERT INTO t28i VALUES (1, 1, 2), (2, 3, 4), (3, 1, 3), (4, NULL, 2), (5, NULL, NULL);
CREATE INDEX i28_ab ON t28i (a, b);
CREATE INDEX i28_id ON t28i (id);
UPDATE STATISTICS ON t28o, t28i WITH FULLSCAN;
-- expected: rows: 1 / 2
evaluate 'Case 28-1';
--@queryplan
SELECT o.id FROM t28o o LEFT JOIN t28i i ON o.id = i.id WHERE (i.a, i.b) IN ((1, 2), (3, 4)) ORDER BY 1;
-- expected: rows: 1
evaluate 'Case 28-2';
--@queryplan
SELECT o.id FROM t28o o LEFT JOIN t28i i ON o.id = i.id WHERE (i.a, i.b) IN ((1, 2), (NULL, 2)) ORDER BY 1;
-- expected: rows: 1 / 2
evaluate 'Case 28-3';
--@queryplan
SELECT o.id FROM t28o o LEFT JOIN t28i i ON o.id = i.id WHERE (o.id, i.a) IN ((1, 1), (2, 3), (6, 1)) ORDER BY 1;
-- expected: rows: 2 / 3
evaluate 'Case 28-4';
--@queryplan
SELECT o.id FROM t28o o LEFT JOIN t28i i ON o.id = i.id WHERE (i.a, i.b) NOT IN ((1, 2), (5, 5)) ORDER BY 1;
-- expected: rows: 2 / 3
evaluate 'Case 28-5';
--@queryplan
SELECT o.id FROM t28o o LEFT JOIN t28i i ON o.id = i.id WHERE (i.a, i.b) <> (1, 2) ORDER BY 1;
-- expected: rows: 1 / 3
evaluate 'Case 28-6';
--@queryplan
SELECT o.id FROM t28o o LEFT JOIN t28i i ON o.id = i.id WHERE (i.a, i.b) < (2, 0) ORDER BY 1;
-- expected: rows: 3 / 4 / 5 / 6
evaluate 'Case 28-7';
--@queryplan
SELECT o.id FROM t28o o LEFT JOIN t28i i ON o.id = i.id WHERE ((i.a, i.b) IN ((1, 2), (3, 4))) IS NULL OR i.b = 3 ORDER BY 1;
-- expected: rows: 1 / 2 / 6
evaluate 'Case 28-8';
--@queryplan
SELECT o.id FROM t28o o LEFT JOIN t28i i ON o.id = i.id WHERE (i.a, i.b) IN ((1, 2), (3, 4)) OR o.id = 6 ORDER BY 1;
DROP TABLE t27, t28o, t28i;

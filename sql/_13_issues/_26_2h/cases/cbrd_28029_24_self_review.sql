/**
 *  This test case verifies CBRD-28029 (found by the self review of PR #8609, 11-18): #24 an aggregate with no GROUP BY over a constant false
 *  START WITH or hierarchical WHERE still returns its one row, and ALL / IN over it compare with that row, #25 a LIKE
 *  pattern with no wildcard on a binary CHAR column is not rewritten to = (the column is padded with zero bytes, and
 *  LIKE skips only trailing spaces), so a literal pattern gives the answer of a bound or cast pattern, R3-01 an outer
 *  join is reduced and an ORDER BY is skipped over DATEDIFF / LOCATE of the inner column as before.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t24, t25, t25o, t25i;
CREATE TABLE t24 (id INT, p INT);
INSERT INTO t24 VALUES (1, NULL), (2, 1);
-- expected: rows: 0
evaluate 'Case 24-1';
SELECT COUNT(*) AS cnt FROM t24 START WITH 1 = 0 CONNECT BY PRIOR id = p;
-- expected: rows: 0
evaluate 'Case 24-2';
SELECT COUNT(*) AS cnt FROM t24 WHERE 1 = 0 START WITH id = 1 CONNECT BY PRIOR id = p;
-- expected: rows: 0
evaluate 'Case 24-c1';
SELECT COUNT(*) AS cnt FROM t24 START WITH id = 0 CONNECT BY PRIOR id = p;
-- expected: empty
evaluate 'Case 24-3';
SELECT 'r' AS r FROM db_root WHERE 1 = ALL (SELECT COUNT(*) FROM t24 START WITH 1 = 0 CONNECT BY PRIOR id = p);
-- expected: rows: 'r'
evaluate 'Case 24-4';
SELECT 'r' AS r FROM db_root WHERE 0 = ALL (SELECT COUNT(*) FROM t24 START WITH 1 = 0 CONNECT BY PRIOR id = p);
-- expected: rows: 'r'
evaluate 'Case 24-5';
SELECT 'r' AS r FROM db_root WHERE 0 IN (SELECT COUNT(*) FROM t24 START WITH 1 = 0 CONNECT BY PRIOR id = p);
-- expected: empty
evaluate 'Case 24-6';
SELECT 'r' AS r FROM db_root WHERE 5 > ALL (SELECT MAX(id) FROM t24 START WITH 1 = 0 CONNECT BY PRIOR id = p);
-- expected: same: 24-3
evaluate 'Case 24-c2';
SELECT 'r' AS r FROM db_root WHERE 1 = ALL (SELECT COUNT(*) FROM t24 START WITH id = 0 CONNECT BY PRIOR id = p);
-- expected: same: 24-6
evaluate 'Case 24-c3';
SELECT 'r' AS r FROM db_root WHERE 5 > ALL (SELECT MAX(id) FROM t24 START WITH id = 0 CONNECT BY PRIOR id = p);
-- expected: empty
evaluate 'Case 24-7';
SELECT 'r' AS r FROM db_root WHERE 1 = ALL (SELECT COUNT(*) FROM t24 WHERE 1 = 0 START WITH id = 1 CONNECT BY PRIOR id = p);
-- expected: rows: 2
evaluate 'Case 24-8';
SELECT COUNT(*) AS cnt FROM t24 START WITH id = 1 CONNECT BY PRIOR id = p;
CREATE TABLE t25 (c CHAR(5) CHARSET binary);
INSERT INTO t25 VALUES ('ab');
-- expected: rows: 0
evaluate 'Case 25-1';
SELECT COUNT(*) AS cnt FROM t25 WHERE c LIKE 'ab';
-- expected: same: 25-1
evaluate 'Case 25-2';
SELECT COUNT(*) AS cnt FROM t25 WHERE c LIKE 'a' || 'b';
-- expected: same: 25-1
evaluate 'Case 25-3';
SELECT COUNT(*) AS cnt FROM t25 WHERE c LIKE CAST('ab' AS VARCHAR(5));
PREPARE p25 FROM 'SELECT COUNT(*) AS cnt FROM t25 WHERE c LIKE ?';
-- expected: same: 25-1
evaluate 'Case 25-4';
EXECUTE p25 USING 'ab';
DEALLOCATE PREPARE p25;
-- expected: rows: 1
evaluate 'Case 25-5';
SELECT COUNT(*) AS cnt FROM t25 WHERE c LIKE 'ab%';
-- expected: rows: 1
evaluate 'Case 25-6';
SELECT COUNT(*) AS cnt FROM t25 WHERE c = 'ab';
CREATE TABLE t25o (id INT PRIMARY KEY);
CREATE TABLE t25i (id INT, d DATE, s VARCHAR(10));
CREATE INDEX t25i_d ON t25i (d);
INSERT INTO t25o VALUES (1), (2);
INSERT INTO t25i VALUES (1, SYSDATE, 'abc');
UPDATE STATISTICS ON t25o, t25i WITH FULLSCAN;
-- expected: rows: 1
evaluate 'Case 26-1';
--@queryplan
SELECT o.id FROM t25o o LEFT JOIN t25i i ON o.id = i.id WHERE DATEDIFF (SYSDATE, i.d) < 30;
-- expected: rows: 1
evaluate 'Case 26-2';
--@queryplan
SELECT o.id FROM t25o o LEFT JOIN t25i i ON o.id = i.id WHERE LOCATE ('b', i.s) > 0;
-- expected: rows: 1
evaluate 'Case 26-3';
--@queryplan
SELECT o.id FROM t25o o LEFT JOIN t25i i ON o.id = i.id WHERE COALESCE (i.d, SYSDATE) IS NOT NULL ORDER BY 1 LIMIT 1;
DROP TABLE t24, t25, t25o, t25i;

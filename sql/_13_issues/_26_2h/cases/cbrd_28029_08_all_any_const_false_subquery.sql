/**
 *  This test case verifies CBRD-28029 #8: a quantified comparison (ALL / ANY / SOME) and IN over a subquery that is constant false must work as
 *  over an empty set: x op ALL (empty) is true, x op ANY (empty) and x IN (empty) are false (also for a NULL x).
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t08;
CREATE TABLE t08 (a INT, s VARCHAR(10));
INSERT INTO t08 VALUES (1, 'p'), (2, 'q');
-- expected: rows: 'r'
evaluate 'Case 8-1';
SELECT 'r' AS r FROM db_root WHERE 1 > ALL (SELECT a FROM t08 WHERE 1 = 2);
-- expected: empty
evaluate 'Case 8-2';
SELECT 'r' AS r FROM db_root WHERE 1 = ANY (SELECT a FROM t08 WHERE 1 = 2);
-- expected: empty
evaluate 'Case 8-3';
SELECT 'r' AS r FROM db_root WHERE 1 = SOME (SELECT a FROM t08 WHERE 1 = 2);
-- expected: rows: 0
evaluate 'Case 8-4';
SELECT (1 IN (SELECT a FROM t08 WHERE 1 = 2)) AS r FROM db_root;
-- expected: rows: 'r'
evaluate 'Case 8-5';
SELECT 'r' AS r FROM db_root WHERE NOT (1 IN (SELECT a FROM t08 WHERE 1 = 2));
-- expected: rows: 'r'
evaluate 'Case 8-6';
SELECT 'r' AS r FROM db_root WHERE (1 IN (SELECT a FROM t08 WHERE 1 = 2)) IS FALSE;
-- expected: rows: 'r'
evaluate 'Case 8-7';
SELECT 'r' AS r FROM db_root WHERE 1 <> ALL (SELECT a FROM t08 WHERE 1 = 2);
-- expected: rows: 'r'
evaluate 'Case 8-8';
SELECT 'r' AS r FROM db_root WHERE 1 = ALL (SELECT a FROM t08 WHERE 1 = 2);
-- expected: empty
evaluate 'Case 8-9';
SELECT 'r' AS r FROM db_root WHERE 1 < ANY (SELECT a FROM t08 WHERE 1 = 2);
-- expected: empty
evaluate 'Case 8-10';
SELECT 'r' AS r FROM db_root WHERE NOT (1 > ALL (SELECT a FROM t08 WHERE 1 = 2));
-- expected: rows: 'r'
evaluate 'Case 8-11';
SELECT 'r' AS r FROM db_root WHERE NOT (1 = ANY (SELECT a FROM t08 WHERE 1 = 2));
-- expected: rows: 1 | 0 | 0 | 1
evaluate 'Case 8-12';
SELECT (1 > ALL (SELECT a FROM t08 WHERE 1 = 2)) AS gt_all, (1 = ANY (SELECT a FROM t08 WHERE 1 = 2)) AS eq_any, (1 = SOME (SELECT a FROM t08 WHERE 1 = 2)) AS eq_some, (1 <> ALL (SELECT a FROM t08 WHERE 1 = 2)) AS ne_all FROM db_root;
-- a NULL on the left
-- expected: rows: 1 | 0 | 0
evaluate 'Case 8-13';
SELECT (NULL > ALL (SELECT a FROM t08 WHERE 1 = 2)) AS gt_all, (NULL = ANY (SELECT a FROM t08 WHERE 1 = 2)) AS eq_any, (NULL IN (SELECT a FROM t08 WHERE 1 = 2)) AS in_r FROM db_root;
-- a column on the left
-- expected: rows: 1 / 2
evaluate 'Case 8-14';
SELECT a FROM t08 WHERE a > ALL (SELECT a FROM t08 WHERE 1 = 2) ORDER BY a;
-- expected: empty
evaluate 'Case 8-15';
SELECT a FROM t08 WHERE a = ANY (SELECT a FROM t08 WHERE 1 = 2) ORDER BY a;
-- expected: rows: 1 | 0 / 2 | 0
evaluate 'Case 8-16';
SELECT a, (a IN (SELECT a FROM t08 WHERE 1 = 2)) AS r FROM t08 ORDER BY a;
-- other column types
-- expected: rows: 'r'
evaluate 'Case 8-17';
SELECT 'r' AS r FROM db_root WHERE 'x' > ALL (SELECT s FROM t08 WHERE 1 = 2);
-- expected: empty
evaluate 'Case 8-18';
SELECT 'r' AS r FROM db_root WHERE 'x' = ANY (SELECT s FROM t08 WHERE 1 = 2);
-- expected: rows: 'r'
evaluate 'Case 8-19';
SELECT 'r' AS r FROM db_root WHERE 1.5 >= ALL (SELECT a FROM t08 WHERE 1 = 2);
-- other constant-false forms
-- expected: rows: 'r'
evaluate 'Case 8-20';
SELECT 'r' AS r FROM db_root WHERE 1 > ALL (SELECT a FROM t08 WHERE 0 <> 0);
-- expected: rows: 'r'
evaluate 'Case 8-21';
SELECT 'r' AS r FROM db_root WHERE 1 > ALL (SELECT a FROM t08 WHERE 1 = 2 AND a > 0);
-- an aggregate over the false WHERE still returns one row: MAX is NULL, COUNT is 0
-- expected: rows: NULL | NULL | 0 | 1
evaluate 'Case 8-22';
SELECT (1 > ALL (SELECT MAX(a) FROM t08 WHERE 1 = 2)) AS gt_all, (1 IN (SELECT MAX(a) FROM t08 WHERE 1 = 2)) AS in_max, (1 IN (SELECT COUNT(*) FROM t08 WHERE 1 = 2)) AS in_cnt1, (0 IN (SELECT COUNT(*) FROM t08 WHERE 1 = 2)) AS in_cnt0 FROM db_root;
-- false at other times (rule #110): a literal FALSE, a set operation of false branches, a derived table, a CTE
-- expected: rows: 'r'
evaluate 'Case 8-30';
SELECT 'r' AS r FROM db_root WHERE 1 > ALL (SELECT a FROM t08 WHERE FALSE);
-- expected: rows: 'r'
evaluate 'Case 8-31';
SELECT 'r' AS r FROM db_root WHERE 1 > ALL (SELECT a FROM t08 WHERE 1 = 2 UNION ALL SELECT a FROM t08 WHERE 1 = 2);
-- expected: rows: 'r'
evaluate 'Case 8-32';
SELECT 'r' AS r FROM db_root WHERE 1 > ALL (SELECT x.a FROM (SELECT a FROM t08 WHERE 1 = 2) x);
-- expected: empty
evaluate 'Case 8-33';
SELECT 'r' AS r FROM db_root WHERE 1 = ANY (WITH c AS (SELECT a FROM t08 WHERE 1 = 2) SELECT a FROM c);
-- expected: rows: 0 | 1
evaluate 'Case 8-34';
SELECT (1 IN (SELECT a FROM t08 WHERE 1 = 2 UNION ALL SELECT a FROM t08 WHERE 1 = 2)) AS in_r, (1 NOT IN (SELECT a FROM t08 WHERE 1 = 2 UNION ALL SELECT a FROM t08 WHERE 1 = 2)) AS nin_r FROM db_root;
-- the empty set known only at run time (bound value): the same answers
-- expected: exec
evaluate 'Case 8-35p';
PREPARE p08b FROM 'SELECT (? > ALL (SELECT a FROM t08 WHERE a = ?)) AS gt_all, (? = ANY (SELECT a FROM t08 WHERE a = ?)) AS eq_any, (? IN (SELECT a FROM t08 WHERE a = ?)) AS in_r FROM db_root';
-- expected: rows: 1 | 0 | 0
evaluate 'Case 8-35';
EXECUTE p08b USING 1, 99, 1, 99, 1, 99;
DEALLOCATE PREPARE p08b;
-- controls
-- expected: rows: 'r'
evaluate 'Case 8-c1';
SELECT 'r' AS r FROM db_root WHERE 1 > ALL (SELECT a FROM t08 WHERE a > 5);
-- expected: rows: 'r'
evaluate 'Case 8-c2';
SELECT 'r' AS r FROM db_root WHERE 1 NOT IN (SELECT a FROM t08 WHERE 1 = 2);
-- expected: rows: 0 | 1
evaluate 'Case 8-c3';
SELECT (EXISTS (SELECT a FROM t08 WHERE 1 = 2)) AS ex, (NOT EXISTS (SELECT a FROM t08 WHERE 1 = 2)) AS nex FROM db_root;
-- expected: empty
evaluate 'Case 8-c4';
SELECT 'r' AS r FROM db_root WHERE 1 > ALL (SELECT a FROM t08);
-- expected: rows: 'r'
evaluate 'Case 8-c5';
SELECT 'r' AS r FROM db_root WHERE 3 > ALL (SELECT a FROM t08);
-- expected: rows: 1 | 0
evaluate 'Case 8-c6';
SELECT (1 > ALL (SELECT a FROM t08 WHERE a > 5)) AS gt_all, (1 IN (SELECT a FROM t08 WHERE a > 5)) AS in_r FROM db_root;
-- host variable on the left
-- expected: exec
evaluate 'Case 8-23p';
PREPARE p08 FROM 'SELECT ''r'' AS r FROM db_root WHERE ? > ALL (SELECT a FROM t08 WHERE 1 = 2)';
-- expected: rows: 'r'
evaluate 'Case 8-23';
EXECUTE p08 USING 1;
DEALLOCATE PREPARE p08;
DROP TABLE t08;

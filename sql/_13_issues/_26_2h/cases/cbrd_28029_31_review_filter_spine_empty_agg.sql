/**
 *  This test case verifies CBRD-28029 (second review of PR #8609): #31
 *  31-1..31-13: a NULL operand of AND or OR. On the AND/OR spine of a search condition it folds as before CNF
 *  (WHERE k = NULL OR k = 6 is k = 6), elsewhere (under NOT, IS, a select item, a trigger condition) it stays UNKNOWN,
 *  and a stored definition that prints it reads back (the grammar takes NULL as an operand of a logical operator).
 *  31-20..31-23: an AND under an OR in the WHERE of an explicit INNER JOIN folds its NULL operand, so the plan is
 *  generated and the ON condition applies, under NOT and IS the AND stays UNKNOWN.
 *  31-30: LIKE with a constant prefix on a numeric column becomes a BETWEEN GE_LT range, which rejects the NULL-padded row.
 *  31-40..31-44: a correlated aggregate subquery whose WHERE rejects every row while the padded column is NULL takes
 *  the value of no input row (COUNT 0, MAX NULL): COUNT > 0 and MAX + 0 > 0 reduce the outer join, COUNT = 0 and
 *  NVL (MAX + 0, 5) = 5 keep it, a subquery with GROUP BY returns no row then (NULL), as before.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP VIEW IF EXISTS v31a;
DROP VIEW IF EXISTS v31b;
DROP VIEW IF EXISTS v31c;
DROP VIEW IF EXISTS v31d;
DROP TABLE IF EXISTS t31, ts31, tlog31, tf31, t31b, o31, i31, wa31, wb31, tt31;
CREATE TABLE t31 (id INT PRIMARY KEY, k INT);
INSERT INTO t31 SELECT ROWNUM, MOD (ROWNUM, 5) + 3 FROM db_class a, db_class b LIMIT 100;
CREATE INDEX i31_k ON t31 (k);
-- expected: exec
evaluate 'Case 31-1';
CREATE VIEW v31a AS SELECT id FROM t31 WHERE k = NULL OR k = 6;
-- expected: rows: 20
evaluate 'Case 31-2';
SELECT COUNT(*) FROM v31a;
-- expected: exec
evaluate 'Case 31-3';
CREATE VIEW v31b AS SELECT id FROM t31 WHERE k = 6 AND (k = NULL OR id > 0);
-- expected: rows: 20
evaluate 'Case 31-4';
SELECT COUNT(*) FROM v31b;
-- expected: exec
evaluate 'Case 31-5';
CREATE VIEW v31c AS SELECT id FROM t31 WHERE k = NULL;
-- expected: rows: 0
evaluate 'Case 31-6';
SELECT COUNT(*) FROM v31c;
-- expected: exec
evaluate 'Case 31-7';
CREATE VIEW v31d AS SELECT id, (k = NULL OR k = 6) IS NULL AS u FROM t31;
-- expected: rows: 80
evaluate 'Case 31-8';
SELECT COUNT(*) FROM v31d WHERE u = 1;
CREATE TABLE ts31 (k INT);
CREATE TABLE tlog31 (tag VARCHAR(10), k INT);
-- expected: exec
evaluate 'Case 31-9';
CREATE TRIGGER tr31 AFTER INSERT ON ts31 IF NOT (obj.k = NULL OR obj.k = 6) EXECUTE INSERT INTO tlog31 VALUES ('tr31', obj.k);
-- expected: affected: 1
evaluate 'Case 31-10';
INSERT INTO ts31 VALUES (5);
-- expected: rows: 0
evaluate 'Case 31-11';
SELECT COUNT(*) FROM tlog31;
CREATE TABLE tf31 (id INT, k INT);
INSERT INTO tf31 SELECT id, k FROM t31;
-- expected: error: Invalid filter expression
evaluate 'Case 31-12';
CREATE INDEX fi31 ON tf31 (k) WHERE k > 3 AND NULL = k;
-- expected: rows: 20
evaluate 'Case 31-13';
SELECT COUNT(*) FROM t31 WHERE NULL OR k = 6;
-- expected: rows: 0
evaluate 'Case 31-14';
SELECT COUNT(*) FROM t31 WHERE NULL;
-- expected: rows: 0
evaluate 'Case 31-15';
SELECT COUNT(*) FROM t31 WHERE NOT NULL;
-- expected: rows: 80
evaluate 'Case 31-16';
SELECT COUNT(*) FROM t31 WHERE (NULL OR k = 6) IS NULL;
CREATE TABLE t31b (id INT PRIMARY KEY, w INT);
INSERT INTO t31b SELECT id, id FROM t31;
-- expected: rows: 20
evaluate 'Case 31-20';
--@queryplan
SELECT COUNT(*) FROM t31 a INNER JOIN t31b b ON a.id = b.id WHERE a.k = 5 OR (a.k = NULL AND a.id > 3);
-- expected: rows: 20
evaluate 'Case 31-21';
--@queryplan
SELECT COUNT(*) FROM t31 a INNER JOIN t31b b ON a.id = b.id WHERE a.k = 5 OR (a.k = NULL AND b.w > 3);
-- expected: rows: 22
evaluate 'Case 31-22';
SELECT COUNT(*) FROM t31 a INNER JOIN t31b b ON a.id = b.id WHERE a.k = 5 OR NOT (a.k = NULL AND a.id > 3);
-- expected: rows: 97
evaluate 'Case 31-23';
SELECT COUNT(*) FROM t31 a INNER JOIN t31b b ON a.id = b.id WHERE (a.k = NULL AND a.id > 3) IS NULL;
CREATE TABLE o31 (id INT);
CREATE TABLE i31 (id INT, num INT);
INSERT INTO o31 VALUES (1), (2);
INSERT INTO i31 VALUES (1, 123), (2, 456);
-- expected: rows: 1 | 123
evaluate 'Case 31-30';
--@queryplan
SELECT o31.id, i31.num FROM o31 LEFT OUTER JOIN i31 ON o31.id = i31.id WHERE i31.num LIKE '1%';
CREATE TABLE wa31 (a INT PRIMARY KEY);
CREATE TABLE wb31 (a INT, b INT);
CREATE TABLE tt31 (x INT, y INT);
INSERT INTO wa31 SELECT ROWNUM FROM db_class LIMIT 10;
INSERT INTO wb31 SELECT a, a FROM wa31 WHERE a <= 8;
INSERT INTO tt31 SELECT a, a FROM wa31 WHERE a <= 5;
CREATE INDEX i31_wb ON wb31 (a);
CREATE INDEX i31_tt ON tt31 (y);
-- expected: rows: 5
evaluate 'Case 31-40';
--@queryplan
SELECT COUNT(*) FROM wa31 LEFT OUTER JOIN wb31 ON wb31.a = wa31.a WHERE (SELECT COUNT (*) FROM tt31 WHERE tt31.y = wb31.b) > 0;
-- expected: rows: 5
evaluate 'Case 31-41';
--@queryplan
SELECT COUNT(*) FROM wa31 LEFT OUTER JOIN wb31 ON wb31.a = wa31.a WHERE (SELECT MAX (tt31.x) + 0 FROM tt31 WHERE tt31.y = wb31.b) > 0;
-- expected: rows: 5
evaluate 'Case 31-42';
--@queryplan
SELECT COUNT(*) FROM wa31 LEFT OUTER JOIN wb31 ON wb31.a = wa31.a WHERE (SELECT COUNT (*) FROM tt31 WHERE tt31.y = wb31.b) = 0;
-- expected: rows: 6
evaluate 'Case 31-43';
--@queryplan
SELECT COUNT(*) FROM wa31 LEFT OUTER JOIN wb31 ON wb31.a = wa31.a WHERE NVL ((SELECT MAX (tt31.x) + 0 FROM tt31 WHERE tt31.y = wb31.b), 5) = 5;
-- expected: rows: 5
evaluate 'Case 31-44';
--@queryplan
SELECT COUNT(*) FROM wa31 LEFT OUTER JOIN wb31 ON wb31.a = wa31.a WHERE (SELECT COUNT (*) FROM tt31 WHERE tt31.y = wb31.b GROUP BY tt31.y) > 0;
DROP TRIGGER tr31;
DROP VIEW v31a;
DROP VIEW v31b;
DROP VIEW v31c;
DROP VIEW v31d;
DROP TABLE t31, ts31, tlog31, tf31, t31b, o31, i31, wa31, wb31, tt31;

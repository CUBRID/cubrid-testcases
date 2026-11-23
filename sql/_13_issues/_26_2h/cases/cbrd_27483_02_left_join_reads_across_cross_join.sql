/**
 *  This test case verifies CBRD-27483: a LEFT, INNER or RIGHT JOIN after a CROSS JOIN whose ON reads a table on the
 *  other side of the CROSS JOIN must return the right rows and not fail with "Outer join query optimization failed."
 *  The cases come from the SQLancer defect #17 of CBRD-28029.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS ta, tb, tc, td;
CREATE TABLE ta (ca BIGINT, cb SMALLINT);
CREATE TABLE tb (ca VARCHAR(87));
CREATE TABLE tc (ca VARCHAR(10));
INSERT INTO ta VALUES (1, 1), (2, NULL);
INSERT INTO tb VALUES ('1'), ('a');
INSERT INTO tc VALUES ('1'), ('zz');
-- the ON reads the table before the CROSS JOIN and the inner table, no join term (the JIRA shape)
-- expected: rows: 1 | '1' | '1' / 1 | 'a' | '1' / 2 | '1' | NULL / 2 | 'a' | NULL
evaluate 'Case 17-1';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;
-- the ON reads only the table before the CROSS JOIN
-- expected: rows: 1 | '1' | '1' / 1 | '1' | 'a' / 1 | 'a' | '1' / 1 | 'a' | 'a' / 2 | '1' | NULL / 2 | 'a' | NULL
evaluate 'Case 17-2';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 ORDER BY 1, 2, 3;
-- two CROSS JOINs in between
-- expected: rows: 1 | '1' | '1' | '1' / 1 | '1' | 'a' | '1' / 1 | 'a' | '1' | '1' / 1 | 'a' | 'a' | '1' / 2 | '1' | '1' | NULL / 2 | '1' | 'a' | NULL / 2 | 'a' | '1' | NULL / 2 | 'a' | 'a' | NULL
evaluate 'Case 17-3';
SELECT a.ca, b.ca, d.ca, c.ca FROM ta a CROSS JOIN tb b CROSS JOIN tb d LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3, 4;
-- a comma before: the ON reads the table right after the comma, a CROSS JOIN in between
-- expected: rows: 1 | '1' | 'a' / 1 | '1' | 'a' / 1 | 'a' | NULL / 1 | 'a' | NULL / 2 | '1' | 'a' / 2 | '1' | 'a' / 2 | 'a' | NULL / 2 | 'a' | NULL
evaluate 'Case 17-4';
SELECT a.ca, b.ca, c.ca FROM ta a, tb b CROSS JOIN tb d LEFT JOIN tb c ON b.ca = '1' AND c.ca = 'a' ORDER BY 1, 2, 3;
-- the ON reads tables on both sides of the CROSS JOIN: no join term, two join terms, one join term and a filter
-- expected: rows: 1 | '1' | '1' / 1 | 'a' | NULL / 2 | '1' | NULL / 2 | 'a' | NULL
evaluate 'Case 17-5';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.ca = 1 AND b.ca = '1' AND c.ca = '1' ORDER BY 1, 2, 3;
-- expected: rows: 1 | '1' | '1' / 1 | 'a' | NULL / 2 | '1' | NULL / 2 | 'a' | NULL
evaluate 'Case 17-6';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON CAST(a.ca AS VARCHAR) = c.ca AND b.ca = c.ca ORDER BY 1, 2, 3;
-- expected: rows: 1 | '1' | '1' / 1 | 'a' | NULL / 2 | '1' | NULL / 2 | 'a' | NULL
evaluate 'Case 17-7';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON CAST(a.ca AS VARCHAR) = c.ca AND b.ca = '1' ORDER BY 1, 2, 3;
-- WHERE on either side
-- expected: rows: 1 | 'a' | '1' / 2 | 'a' | NULL
evaluate 'Case 17-8';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' WHERE b.ca = 'a' ORDER BY 1, 2, 3;
-- expected: rows: 2 | '1' | NULL / 2 | 'a' | NULL
evaluate 'Case 17-9';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' WHERE c.ca IS NULL ORDER BY 1, 2, 3;
-- a second LEFT JOIN reads the table before the CROSS JOIN
-- expected: rows: 1 | '1' | '1' | 'a' / 1 | 'a' | 'a' | 'a' / 2 | '1' | '1' | NULL / 2 | 'a' | 'a' | NULL
evaluate 'Case 17-10';
SELECT a.ca, b.ca, c.ca, d.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON b.ca = c.ca LEFT JOIN tb d ON a.cb = 1 AND d.ca = 'a' ORDER BY 1, 2, 3, 4;
-- derived tables and hints
-- expected: the rows of Case 17-1
evaluate 'Case 17-11';
SELECT a.ca, b.ca, c.ca FROM (SELECT ca, cb FROM ta) a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;
-- expected: the rows of Case 17-1
evaluate 'Case 17-12';
SELECT a.ca, b.ca, c.ca FROM (SELECT ca, cb FROM ta WHERE ca > 0) a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;
-- expected: the rows of Case 17-1
evaluate 'Case 17-13';
SELECT /*+ ORDERED */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;
-- expected: the rows of Case 17-1
evaluate 'Case 17-14';
SELECT /*+ LEADING(b) */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;
-- results that the fix does not change: INNER JOIN, the ON reads the table right before, INNER JOIN ON TRUE in place of the CROSS JOIN
-- expected: rows: 1 | '1' | '1' / 1 | 'a' | '1'
evaluate 'Case 17-15';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b INNER JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;
-- expected: rows: 1 | '1' | '1' / 1 | 'a' | '1'
evaluate 'Case 17-16';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b INNER JOIN tb c ON CAST(a.ca AS VARCHAR) = c.ca ORDER BY 1, 2, 3;
-- expected: rows: 1 | '1' | '1' / 1 | 'a' | NULL / 2 | '1' | '1' / 2 | 'a' | NULL
evaluate 'Case 17-17';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON b.ca = '1' AND c.ca = '1' ORDER BY 1, 2, 3;
-- expected: the rows of Case 17-1
evaluate 'Case 17-18';
SELECT a.ca, b.ca, c.ca FROM ta a INNER JOIN tb b ON 1 = 1 LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;
-- the comma form cannot read the table before the comma
-- expected: error: ... in join condition is not defined
evaluate 'Case 17-19';
SELECT a.ca, b.ca, c.ca FROM ta a, tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;
-- a RIGHT OUTER JOIN after a CROSS JOIN gives the same rows with and without join order hints (whatever the association)
-- expected: any association, and the cases with join order hints below return the same rows
evaluate 'Case 17-20';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b RIGHT JOIN tc c ON b.ca = c.ca ORDER BY 1, 2, 3;
-- expected: the rows of Case 17-20
evaluate 'Case 17-21';
SELECT /*+ ORDERED */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b RIGHT JOIN tc c ON b.ca = c.ca ORDER BY 1, 2, 3;
-- expected: the rows of Case 17-20
evaluate 'Case 17-22';
SELECT /*+ LEADING(a) */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b RIGHT JOIN tc c ON b.ca = c.ca ORDER BY 1, 2, 3;
-- DML
CREATE TABLE td AS SELECT * FROM ta;
-- expected: 1 row affected
evaluate 'Case 17-30';
UPDATE td a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' SET a.ca = a.ca + 10 WHERE c.ca IS NULL;
-- expected: rows: 1 / 12
evaluate 'Case 17-31';
SELECT ca FROM td ORDER BY 1;
-- expected: 1 row affected
evaluate 'Case 17-32';
DELETE a FROM td a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' WHERE c.ca IS NULL;
-- expected: rows: 1
evaluate 'Case 17-33';
SELECT ca FROM td ORDER BY 1;
DROP TABLE ta, tb, tc, td;

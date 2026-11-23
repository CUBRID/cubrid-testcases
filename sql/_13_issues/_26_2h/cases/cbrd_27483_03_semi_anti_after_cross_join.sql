/**
 *  This test case verifies CBRD-27483 for SEMI and ANTI JOIN: an IN or EXISTS subquery after a CROSS JOIN turns into a
 *  SEMI JOIN whose ON may read the tables on both sides of the CROSS JOIN, and so may an explicit SEMI or ANTI JOIN.
 *  The query must return the right rows and not fail with "Outer join query optimization failed."
 *  Cases 3-1 to 3-30 come from the SQLancer defect #3 of CBRD-28029.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS ta, tb;
CREATE TABLE ta (ca BIGINT, cb SMALLINT);
CREATE TABLE tb (ca VARCHAR(87));
INSERT INTO ta VALUES (1, 1), (2, NULL);
INSERT INTO tb VALUES ('1'), ('a');
-- (i.ca = i.ca) is true for both rows of tb, so the subquery returns '1' and 'a' for every outer row
-- expected: rows: '1' / '1' / 'a' / 'a'
evaluate 'Case 3-1';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;
-- expected: rows: '1' / '1' / 'a' / 'a'
evaluate 'Case 3-cb';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE '1' IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;
-- expected: rows: 1 / 2
evaluate 'Case 3-c2';
SELECT a.ca FROM ta a WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;
-- comma join
-- expected: rows: 1 | '1' / 1 | 'a' / 2 | '1' / 2 | 'a'
evaluate 'Case 3-2';
SELECT a.ca, b.ca FROM ta a, tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1, 2;
-- the subquery result depends on the outer row: a.cb = 1 only for a.ca = 1
-- expected: rows: 1 | '1' / 1 | 'a'
evaluate 'Case 3-3';
SELECT a.ca, b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = 'zz') OR (a.cb = 1)) ORDER BY 1, 2;
-- the correlated table is the other side of the CROSS JOIN
-- expected: rows: 1 | '1' / 2 | '1'
evaluate 'Case 3-4';
SELECT a.ca, b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = 'zz') OR (b.ca = '1')) ORDER BY 1, 2;
-- one term that reads the subquery table and the outer table together (no OR)
-- expected: rows: '1' / '1'
evaluate 'Case 3-5';
SELECT b.ca FROM tb b CROSS JOIN ta a WHERE CAST(1 AS BIGINT) IN (SELECT x.ca FROM ta x WHERE (CASE WHEN x.ca > 0 THEN b.ca ELSE '?' END) = '1') ORDER BY 1;
-- the constant is not in the subquery result
-- expected: no rows
evaluate 'Case 3-6';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE CAST(2 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;
-- expected: no rows
evaluate 'Case 3-7';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) NOT IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;
-- expected: rows: '1' / '1' / 'a' / 'a'
evaluate 'Case 3-8';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE EXISTS (SELECT 1 FROM tb i WHERE i.ca = CAST(1 AS VARCHAR) AND ((i.ca = i.ca) OR (a.cb = a.cb))) ORDER BY 1;
-- expected: rows: 8
evaluate 'Case 3-9';
SELECT COUNT(*) AS cnt FROM ta a CROSS JOIN tb b CROSS JOIN ta a2 WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb));
-- other constant expressions on the left
-- expected: rows: '1' / '1' / 'a' / 'a'
evaluate 'Case 3-10';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE TO_CHAR(1) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;
-- expected: rows: 1 / 1 / 2 / 2
evaluate 'Case 3-11';
SELECT a.ca FROM ta a CROSS JOIN tb b WHERE CAST('1' AS BIGINT) IN (SELECT x.ca FROM ta x WHERE (x.ca = x.ca) OR (b.ca = b.ca)) ORDER BY 1;
-- a host variable on the left
evaluate 'Case 3-12p';
PREPARE p03 FROM 'SELECT b.ca FROM ta a CROSS JOIN tb b WHERE ? IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1';
-- expected: rows: '1' / '1' / 'a' / 'a'
evaluate 'Case 3-12';
EXECUTE p03 USING '1';
-- expected: no rows
evaluate 'Case 3-13';
EXECUTE p03 USING '2';
DEALLOCATE PREPARE p03;
-- an explicit INNER JOIN with an ON that reads both tables
-- expected: rows: '1' / '1' / 'a' / 'a'
evaluate 'Case 3-14';
SELECT b.ca FROM ta a INNER JOIN tb b ON 1 = 1 WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;
-- a LEFT OUTER JOIN outside
-- expected: rows: 1 | '1' / 1 | 'a' / 2 | '1' / 2 | 'a'
evaluate 'Case 3-15';
SELECT a.ca, b.ca FROM ta a LEFT OUTER JOIN tb b ON b.ca IS NOT NULL WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1, 2;
-- more forms (found while analysing): the explicit SEMI / ANTI JOIN syntax after a CROSS JOIN, the outer spec behind
-- the CROSS JOIN with a later INNER JOIN, plan hints, NOT EXISTS, a multi-table subquery, DML
-- expected: rows: '1' / '1' / 'a' / 'a'
evaluate 'Case 3-20';
SELECT b.ca FROM ta a CROSS JOIN tb b SEMI JOIN tb i ON i.ca = CAST(1 AS VARCHAR) AND ((i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;
-- expected: no rows
evaluate 'Case 3-21';
SELECT b.ca FROM ta a CROSS JOIN tb b ANTI JOIN tb i ON i.ca = CAST(1 AS VARCHAR) AND ((i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;
-- expected: rows: 1 | '1' | '1' / 1 | 'a' | '1'
evaluate 'Case 3-22';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b INNER JOIN tb c ON CAST(a.ca AS VARCHAR) = c.ca WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (b.ca = '1')) ORDER BY 1, 2, 3;
-- expected: rows: '1' / '1' / 'a' / 'a'
evaluate 'Case 3-23';
SELECT /*+ ORDERED */ b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;
-- expected: rows: '1' / '1' / 'a' / 'a'
evaluate 'Case 3-24';
SELECT /*+ LEADING(b) */ b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;
-- expected: no rows
evaluate 'Case 3-25';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE NOT EXISTS (SELECT 1 FROM tb i WHERE i.ca = CAST(1 AS VARCHAR) AND ((i.ca = i.ca) OR (a.cb = a.cb))) ORDER BY 1;
-- expected: rows: 1 | '1' / 1 | 'a'
evaluate 'Case 3-26';
SELECT a.ca, b.ca FROM ta a CROSS JOIN tb b WHERE CAST(a.ca AS VARCHAR) IN (SELECT i.ca FROM tb i) ORDER BY 1, 2;
-- expected: rows: '1' / '1' / 'a' / 'a'
evaluate 'Case 3-27';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i, ta j WHERE ((i.ca = i.ca) OR (a.cb = a.cb)) AND j.ca = 1) ORDER BY 1;
-- expected: 2 rows affected
evaluate 'Case 3-28';
UPDATE ta a CROSS JOIN tb b SET a.ca = a.ca WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb));
-- expected: 0 rows affected
evaluate 'Case 3-29';
DELETE a FROM ta a CROSS JOIN tb b WHERE CAST(2 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb));
-- expected: rows: 2
evaluate 'Case 3-30';
SELECT COUNT(*) AS cnt FROM ta;
DROP TABLE ta, tb;
DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3), (4, NULL);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb VALUES (1, 1), (2, 2), (3, NULL);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO tc VALUES (1, 1), (1, 2), (2, 3), (5, 1);
UPDATE STATISTICS ON ta, tb, tc;
-- an explicit SEMI / ANTI JOIN whose ON joins both tables of the CROSS JOIN, with and without a WHERE
-- expected: rows: 1 | 1 | 1 | 1 / 1 | 1 | 2 | 2 / 1 | 1 | 3 | NULL / 2 | 2 | 1 | 1 / 2 | 2 | 2 | 2 / 2 | 2 | 3 | NULL
evaluate 'Case 3-50';
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb SEMI JOIN tc ON tc.ca = ta.ca ORDER BY 1, 2, 3, 4;
-- expected: rows: 1 | 1 | 1 | 1 / 1 | 1 | 2 | 2
evaluate 'Case 3-51';
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb SEMI JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb ORDER BY 1, 2, 3, 4;
-- expected: rows: 1 | 1 | 1 | 1
evaluate 'Case 3-52';
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb SEMI JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE tb.cb = 1 ORDER BY 1, 2, 3, 4;
-- expected: rows: 3 | 3 | 1 | 1 / 3 | 3 | 2 | 2 / 3 | 3 | 3 | NULL / 4 | NULL | 1 | 1 / 4 | NULL | 2 | 2 / 4 | NULL | 3 | NULL
evaluate 'Case 3-53';
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb ANTI JOIN tc ON tc.ca = ta.ca ORDER BY 1, 2, 3, 4;
-- expected: rows: 1 | 1 | 3 | NULL / 2 | 2 | 1 | 1 / 2 | 2 | 2 | 2 / 2 | 2 | 3 | NULL / 3 | 3 | 1 | 1 / 3 | 3 | 2 | 2 / 3 | 3 | 3 | NULL / 4 | NULL | 1 | 1 / 4 | NULL | 2 | 2 / 4 | NULL | 3 | NULL
evaluate 'Case 3-54';
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb ANTI JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb ORDER BY 1, 2, 3, 4;
-- expected: rows: 2 | 2 | 1 | 1 / 3 | 3 | 1 | 1 / 4 | NULL | 1 | 1
evaluate 'Case 3-55';
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb ANTI JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE tb.cb = 1 ORDER BY 1, 2, 3, 4;
DROP TABLE ta, tb, tc;

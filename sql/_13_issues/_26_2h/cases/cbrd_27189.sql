/**
 * This test case verifies CBRD-27189: a numbering column (ROWNUM/ORDERBY_NUM())
 * of a subquery(view) must not be exposed to an expression of the main query
 * when the subquery is merged into it. Such a value is only settled after the
 * sort of the subquery is done, so an expression reading it produced a wrong
 * result.
 *
 * Coverage:
 * 1. Main repro - DECODE () on the numbering column of an inline view.
 * 2. Same shape through a CTE.
 * 3. Same shape through a view.
 * 4. CASE/arithmetic/NVL/concatenation on the numbering column.
 * 5. Bare reference of the numbering column keeps working (still merged).
 * 6. Numbering not exposed as a column keeps being merged.
 * 7. Sort resolved by an index (no real sort).
 * 8. ROWNUM of a subquery without ORDER BY.
 * 9. CAST () on the numbering column.
 * 10. A subquery of the select list reads the numbering column.
 */

--+ server-message on

DROP TABLE IF EXISTS t1;

CREATE TABLE t1 (name VARCHAR(20), code INT PRIMARY KEY);
INSERT INTO t1 VALUES ('e', 1), ('d', 2), ('c', 3), ('b', 4), ('a', 5);

-- 1. main repro: DECODE () reads the numbering column of an inline view
SELECT DECODE(rn, 1, name, 'WRONG') AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM t1 ORDER BY name) WHERE ROWNUM <= 1);

-- 2. the same shape written with a CTE
WITH src AS (
    SELECT name, ROWNUM AS rn FROM (SELECT name FROM t1 ORDER BY name) WHERE ROWNUM <= 1
)
SELECT DECODE(rn, 1, name, 'WRONG') AS result FROM src;

-- 3. the same shape through a view
CREATE OR REPLACE VIEW v1 AS
    SELECT name, ROWNUM AS rn FROM (SELECT name FROM t1 ORDER BY name) WHERE ROWNUM <= 1;
SELECT DECODE(rn, 1, name, 'WRONG') AS result FROM v1;
SELECT rn AS result FROM v1;
DROP VIEW v1;

-- 4. other expressions reading the numbering column
SELECT CASE WHEN rn = 1 THEN name ELSE 'WRONG' END AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM t1 ORDER BY name) WHERE ROWNUM <= 1);

SELECT rn + 0 AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM t1 ORDER BY name) WHERE ROWNUM <= 1);

SELECT NVL(rn, 0) AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM t1 ORDER BY name) WHERE ROWNUM <= 1);

SELECT 'x' || rn AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM t1 ORDER BY name) WHERE ROWNUM <= 1);

-- 5. more than one row, both the bare and the embedded reference
SELECT rn, DECODE(rn, 1, 'first', 'other') AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM t1 ORDER BY name) WHERE ROWNUM <= 3) src;

-- 6. the numbering column is not exposed, so the query is still merged
SELECT UPPER(name) AS result
FROM (SELECT name FROM (SELECT name FROM t1 ORDER BY name) WHERE ROWNUM <= 3) src;

-- 7. the sort is resolved by an index
SELECT DECODE(rn, 1, name, 'WRONG') AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM t1 ORDER BY code) WHERE ROWNUM <= 1);

-- 8. ROWNUM of a subquery which has no ORDER BY
SELECT DECODE(rn, 1, 'ONE', 'OTHER') AS result
FROM (SELECT ROWNUM AS rn, name FROM t1) WHERE rn <= 3;

-- 9. CAST () reads the numbering column
SELECT CAST(rn AS VARCHAR) AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM t1 ORDER BY name) WHERE ROWNUM <= 2) src;

-- 10. a subquery of the select list reads the numbering column
SELECT (SELECT COUNT(*) FROM t1 WHERE src.rn = 1) AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM t1 ORDER BY name) WHERE ROWNUM <= 2) src;

DROP TABLE t1;

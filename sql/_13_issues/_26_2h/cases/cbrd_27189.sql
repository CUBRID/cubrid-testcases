/**
 * This test case verifies CBRD-27189: a numbering column (ROWNUM/ORDERBY_NUM()/
 * GROUPBY_NUM()) of a subquery(view) must not be exposed to an expression of the
 * main query when the subquery is merged into it. Such a value is only settled
 * after the sort (or grouping) of the subquery is done, so an expression reading
 * it produced a wrong result.
 *
 * Every case prints, via evaluate (), whether the subquery is expected to be
 * merged, and is followed by show trace. The "rewritten query:" line of the
 * trace is what actually proves it: a merged query is flat, a blocked one keeps
 * the derived table. Result values alone cannot tell the two apart, so without
 * the trace this test could not detect over-blocking -- merging that stops
 * happening where it still should.
 *
 * Table names are letter-only on purpose: digits inside the trace block are
 * masked to '?', so t1/t2 would both render as "t?" and become indistinguishable.
 *
 * Coverage
 *   NOT merged (the fix blocks it)
 *     01 DECODE () on the numbering column of an inline view -- the main repro
 *     02 the same shape through a CTE
 *     03 the same shape through a view
 *     05 CASE / arithmetic / NVL / concatenation
 *     06 more than one row, bare and embedded reference together
 *     08 sort resolved by an index (no real sort needed)
 *     09 CAST ()
 *     10 a subquery of the select list reads the numbering column
 *     11 GROUPBY_NUM () instead of ORDERBY_NUM ()
 *     12 ORDERBY_NUM () written explicitly instead of ROWNUM
 *     15 ORDER BY on the numbering column
 *     16 GROUP BY / HAVING on the numbering column
 *   still merged (the fix must NOT block it)
 *     04 bare reference of the numbering column
 *     07 the numbering column is not exposed at all
 *     13 ROWNUM of a subquery which has no ORDER BY
 *     14 INST_NUM (), evaluated during the scan, so safe inside an expression
 *     17 the numbering column is read only by WHERE -> folded into TOP-N.
 *        Deliberately excluded from the check by the fix; including it broke
 *        the pagination plans of cbrd_24258 / cbrd_26257.
 */

--+ server-message on

DROP TABLE IF EXISTS tsort;
DROP TABLE IF EXISTS tpage;

CREATE TABLE tsort (name VARCHAR(20), code INT PRIMARY KEY);
INSERT INTO tsort VALUES ('e', 1), ('d', 2), ('c', 3), ('b', 4), ('a', 5);

-- tpage carries enough rows for the pagination and grouping cases below
CREATE TABLE tpage (name VARCHAR(20), code INT PRIMARY KEY, grp INT);
INSERT INTO tpage
SELECT 'n' || LPAD(CAST(ROWNUM AS VARCHAR), 3, '0'), ROWNUM, MOD(ROWNUM, 5)
  FROM db_class a, db_class b LIMIT 40;

set trace on;

evaluate 'case 01 : DECODE () on the numbering column of an inline view -- NOT merged';
SELECT DECODE(rn, 1, name, 'WRONG') AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 1);
show trace;

evaluate 'case 02 : the same shape written with a CTE -- NOT merged';
WITH src AS (
    SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 1
)
SELECT DECODE(rn, 1, name, 'WRONG') AS result FROM src;
show trace;

evaluate 'case 03 : the same shape through a view -- NOT merged';
CREATE OR REPLACE VIEW vsort AS
    SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 1;
SELECT DECODE(rn, 1, name, 'WRONG') AS result FROM vsort;
show trace;

evaluate 'case 04 : bare reference of the numbering column -- still merged';
SELECT rn AS result FROM vsort;
show trace;
DROP VIEW vsort;

evaluate 'case 05a : CASE reads the numbering column -- NOT merged';
SELECT CASE WHEN rn = 1 THEN name ELSE 'WRONG' END AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 1);
show trace;

evaluate 'case 05b : arithmetic reads the numbering column -- NOT merged';
SELECT rn + 0 AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 1);
show trace;

evaluate 'case 05c : NVL reads the numbering column -- NOT merged';
SELECT NVL(rn, 0) AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 1);
show trace;

evaluate 'case 05d : concatenation reads the numbering column -- NOT merged';
SELECT 'x' || rn AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 1);
show trace;

evaluate 'case 06 : more than one row, bare and embedded reference together -- NOT merged';
SELECT rn, DECODE(rn, 1, 'first', 'other') AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 3) src;
show trace;

evaluate 'case 07 : the numbering column is not exposed -- still merged';
SELECT UPPER(name) AS result
FROM (SELECT name FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 3) src;
show trace;

evaluate 'case 08 : the sort is resolved by an index -- NOT merged';
SELECT DECODE(rn, 1, name, 'WRONG') AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY code) WHERE ROWNUM <= 1);
show trace;

evaluate 'case 09 : CAST () reads the numbering column -- NOT merged';
SELECT CAST(rn AS VARCHAR) AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 2) src;
show trace;

evaluate 'case 10 : a subquery of the select list reads the numbering column -- NOT merged';
SELECT (SELECT COUNT(*) FROM tsort WHERE src.rn = 1) AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 2) src;
show trace;

evaluate 'case 11 : GROUPBY_NUM () read by an expression -- NOT merged';
SELECT DECODE(gn, 1, 'FIRST', 'OTHER') AS result
FROM (SELECT grp, GROUPBY_NUM() AS gn FROM tpage GROUP BY grp ORDER BY grp) WHERE gn <= 2;
show trace;

evaluate 'case 12 : ORDERBY_NUM () written explicitly -- NOT merged';
SELECT DECODE(rn, 1, name, 'WRONG') AS result
FROM (SELECT name, ORDERBY_NUM() AS rn FROM tsort ORDER BY name FOR ORDERBY_NUM() <= 1);
show trace;

evaluate 'case 13 : ROWNUM of a subquery which has no ORDER BY -- still merged';
SELECT DECODE(rn, 1, 'ONE', 'OTHER') AS result
FROM (SELECT ROWNUM AS rn, name FROM tsort) WHERE rn <= 3;
show trace;

evaluate 'case 14 : INST_NUM () inside an expression -- still merged';
SELECT DECODE(rn, 1, name, 'WRONG') AS result
FROM (SELECT name, INST_NUM() AS rn FROM tpage WHERE INST_NUM() <= 1);
show trace;

evaluate 'case 15 : ORDER BY on the numbering column -- NOT merged';
SELECT name AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 3)
ORDER BY rn DESC;
show trace;

evaluate 'case 16 : GROUP BY / HAVING on the numbering column -- NOT merged';
SELECT MAX(name) AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM tsort ORDER BY name) WHERE ROWNUM <= 3)
GROUP BY rn HAVING rn > 1;
show trace;

evaluate 'case 17 : the numbering column is read only by WHERE -- still merged, folded into TOP-N';
SELECT name AS result
FROM (SELECT name, ROWNUM AS rn FROM (SELECT name FROM tpage ORDER BY name))
WHERE rn >= 7 AND rn < 10;
show trace;

set trace off;

DROP TABLE tsort;
DROP TABLE tpage;

--+ server-message off

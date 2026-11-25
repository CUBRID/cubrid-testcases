/**
 *  This test case verifies CBRD-28029 #1: a column fixed by an equality (c = const) is substituted into another term, the substituted
 *  comparison folds to a constant (NULL or TRUE), and an IS [NOT] NULL / IS [NOT] TRUE / ... over the AND/OR that
 *  holds it must still follow three-valued logic.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t01, t01b;
CREATE TABLE t01 (c VARCHAR, n INT);
INSERT INTO t01 VALUES ('', 1), ('', 2), ('z', 3);
-- for c = '' : NULLIF(c, '') is NULL, so (n > 0 AND NULL) is NULL and (n < 0 OR NULL) is NULL
-- expected: rows: 2
evaluate 'Case 1-1';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND (n > 0 AND NULLIF(c, '') = 'x') IS NULL;
-- expected: rows: 0
evaluate 'Case 1-2';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND (n > 0 AND NULLIF(c, '') = 'x') IS NOT NULL;
-- expected: rows: 2
evaluate 'Case 1-3';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND ((n > 0 AND NULLIF(c, '') = 'x') IS UNKNOWN);
-- expected: rows: 2
evaluate 'Case 1-4';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND (n < 0 OR NULLIF(c, '') = 'x') IS NULL;
-- expected: rows: 2
evaluate 'Case 1-c1';
SELECT COUNT(*) AS cnt FROM t01 WHERE c IN ('', 'q') AND (n > 0 AND NULLIF(c, '') = 'x') IS NULL;
-- expected: rows: 2
evaluate 'Case 1-c2';
SELECT SUM(CASE WHEN (n > 0 AND NULLIF(c, '') = 'x') IS NULL THEN 1 ELSE 0 END) AS s FROM t01 WHERE c = '';
-- the rows themselves, not only the count
-- expected: rows: 1 / 2
evaluate 'Case 1-5';
SELECT n FROM t01 WHERE c = '' AND (n > 0 AND NULLIF(c, '') = 'x') IS NULL ORDER BY n;
-- expected: rows: 0
evaluate 'Case 1-6';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND ((n > 0 AND NULLIF(c, '') = 'x') IS NOT UNKNOWN);
-- expected: rows: 0
evaluate 'Case 1-7';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND ((n > 0 AND NULLIF(c, '') = 'x') IS TRUE);
-- expected: rows: 0
evaluate 'Case 1-8';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND ((n > 0 AND NULLIF(c, '') = 'x') IS FALSE);
-- expected: rows: 2
evaluate 'Case 1-9';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND ((n > 0 AND NULLIF(c, '') = 'x') IS NOT TRUE);
-- expected: rows: 2
evaluate 'Case 1-10';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND ((n > 0 AND NULLIF(c, '') = 'x') IS NOT FALSE);
-- NOT (TRUE AND NULL) is NULL: no row
-- expected: rows: 0
evaluate 'Case 1-11';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND NOT (n > 0 AND NULLIF(c, '') = 'x');
-- expected: rows: 0
evaluate 'Case 1-12';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND (n < 0 OR NULLIF(c, '') = 'x') IS NOT NULL;
-- TRUE OR NULL is TRUE, FALSE AND NULL is FALSE: IS NULL is false in both
-- expected: rows: 0
evaluate 'Case 1-13';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND (n > 0 OR NULLIF(c, '') = 'x') IS NULL;
-- expected: rows: 0
evaluate 'Case 1-14';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND (n < 0 AND NULLIF(c, '') = 'x') IS NULL;
-- expected: rows: 2
evaluate 'Case 1-15';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND (n < 0 AND NULLIF(c, '') = 'x') IS NOT NULL;
-- select list over the same filtered rows
-- expected: rows: 1 | 1 | 0 / 2 | 1 | 0
evaluate 'Case 1-16';
SELECT n, (n > 0 AND NULLIF(c, '') = 'x') IS NULL AS isn, (n > 0 AND NULLIF(c, '') = 'x') IS NOT NULL AS isnn FROM t01 WHERE c = '' ORDER BY n;
-- the equality in the ON clause of a join (the original SQLancer report)
-- expected: rows: 6
evaluate 'Case 1-17';
SELECT COUNT(*) AS cnt FROM t01 a INNER JOIN t01 b ON b.c = '' WHERE (b.n > 0 AND NULLIF(b.c, '') = 'x') IS NULL;
-- expected: rows: 0
evaluate 'Case 1-18';
SELECT COUNT(*) AS cnt FROM t01 a INNER JOIN t01 b ON b.c = '' WHERE (b.n > 0 AND NULLIF(b.c, '') = 'x') IS NOT NULL;
-- host variables in place of the literals
PREPARE p01 FROM 'SELECT COUNT(*) AS cnt FROM t01 WHERE c = ? AND (n > 0 AND NULLIF(c, ?) = ''x'') IS NULL';
-- expected: rows: 2
evaluate 'Case 1-19';
EXECUTE p01 USING '', '';
DEALLOCATE PREPARE p01;
-- TLP over p = (n > 0 AND NULLIF(c, '') = 'x') for the rows of c = '': p, NOT p, p IS NULL must add up to 2
-- expected: rows: 0 | 0 | 2
evaluate 'Case 1-20';
SELECT (SELECT COUNT(*) FROM t01 WHERE c = '' AND (n > 0 AND NULLIF(c, '') = 'x')) AS p, (SELECT COUNT(*) FROM t01 WHERE c = '' AND NOT (n > 0 AND NULLIF(c, '') = 'x')) AS np, (SELECT COUNT(*) FROM t01 WHERE c = '' AND (n > 0 AND NULLIF(c, '') = 'x') IS NULL) AS pn FROM db_root;
-- HAVING: the equality comes from WHERE, IS NULL is in HAVING
-- expected: rows: '' | 2
evaluate 'Case 1-21';
SELECT c, COUNT(*) AS cnt FROM t01 WHERE c = '' GROUP BY c HAVING (MAX(n) > 0 AND NULLIF(c, '') = 'x') IS NULL;

-- the comparison folds to TRUE instead of NULL (2026-11-16 variant): q is NULL, so (TRUE AND q) IS NULL is true
CREATE TABLE t01b (c0 DOUBLE, c1 VARCHAR);
INSERT INTO t01b VALUES (5, NULL);
-- expected: rows: 5.000000000000000e+00 | NULL
evaluate 'Case 1-34';
SELECT c0, c1 FROM t01b WHERE c0 > 4 AND ((c0 < 9) AND (c1 = 'x')) IS NULL;
-- expected: rows: 5.000000000000000e+00 | NULL
evaluate 'Case 1-36';
SELECT c0, c1 FROM t01b WHERE c0 = 5 AND ((c0 > 9) OR (c1 = 'x')) IS NULL;
-- expected: rows: 5.000000000000000e+00 | NULL
evaluate 'Case 1-37';
SELECT c0, c1 FROM t01b WHERE ((5 < 9) AND (c1 = 'x')) IS NULL;
-- expected: rows: 5.000000000000000e+00 | NULL
evaluate 'Case 1-40';
SELECT c0, c1 FROM t01b WHERE c0 = 5 AND (((c0 < 9) AND (c1 = 'x')) IS NOT FALSE);
-- the TRUE term second in the AND
-- expected: rows: 5.000000000000000e+00 | NULL
evaluate 'Case 1-41';
SELECT c0, c1 FROM t01b WHERE c0 = 5 AND ((c1 = 'x') AND (c0 < 9)) IS NULL;
-- a FALSE fold: FALSE AND NULL is FALSE
-- expected: empty
evaluate 'Case 1-42';
SELECT c0, c1 FROM t01b WHERE c0 = 5 AND ((c0 > 9) AND (c1 = 'x')) IS NULL;
-- expected: rows: 5.000000000000000e+00 | NULL
evaluate 'Case 1-43';
SELECT c0, c1 FROM t01b WHERE c0 = 5 AND ((c0 > 9) AND (c1 = 'x')) IS NOT NULL;
-- TRUE OR NULL is TRUE
-- expected: empty
evaluate 'Case 1-44';
SELECT c0, c1 FROM t01b WHERE c0 = 5 AND ((c0 < 9) OR (c1 = 'x')) IS NULL;
-- select list
-- expected: rows: 1 | 0
evaluate 'Case 1-45';
SELECT ((c0 < 9) AND (c1 = 'x')) IS NULL AS isn, ((c0 < 9) AND (c1 = 'x')) IS NOT NULL AS isnn FROM t01b WHERE c0 = 5;

-- CUBRID binds IS [NOT] TRUE/FALSE/UNKNOWN looser than AND (csql_grammar.y boolean_term_is): without the parentheses the
-- IS covers the whole AND and c = '' is not substituted -- pinned here
-- expected: rows: 3
evaluate 'Case 1-50';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND (n > 0 AND NULLIF(c, '') = 'x') IS NOT TRUE;
-- expected: rows: 1
evaluate 'Case 1-51';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND (n > 0 AND NULLIF(c, '') = 'x') IS FALSE;
-- expected: rows: 1
evaluate 'Case 1-52';
SELECT COUNT(*) AS cnt FROM t01 WHERE c = '' AND (n > 0 AND NULLIF(c, '') = 'x') IS NOT UNKNOWN;
-- XASL cache key: the second statement must not reuse the plan of the first (the folded head of the nested list was
-- the only part of it in the rewritten statement)
-- expected: rows: 1
evaluate 'Case 1-53';
SELECT COUNT(*) FROM t01b WHERE c0 = 5 AND ((((c0 < 9) AND (c1 = 'x')) XOR (c1 IS NULL)) IS NULL);

DROP TABLE IF EXISTS t27, j1;
CREATE TABLE t27 (a INT);
INSERT INTO t27 VALUES (1), (2);
CREATE TABLE j1 (a INT, b INT);
INSERT INTO j1 VALUES (5, 9), (6, 9), (7, 9), (5, 8);
-- agent-d extended shapes for CBRD-28029 #1 (answers by 3VL, CUBRID grammar: IS [NOT] TRUE/FALSE/UNKNOWN binds looser than AND)
-- P: the IS operand in parentheses, so c = '' stays a WHERE conjunct and is substituted
-- expected: rows: 0
evaluate 'Case P-1';
SELECT COUNT(*) FROM t01 WHERE c = '' AND ((n > 0 AND NULLIF(c, '') = 'x') IS TRUE);
-- expected: rows: 2
evaluate 'Case P-2';
SELECT COUNT(*) FROM t01 WHERE c = '' AND ((n > 0 AND NULLIF(c, '') = 'x') IS NOT TRUE);
-- expected: rows: 0
evaluate 'Case P-3';
SELECT COUNT(*) FROM t01 WHERE c = '' AND ((n > 0 AND NULLIF(c, '') = 'x') IS FALSE);
-- expected: rows: 2
evaluate 'Case P-4';
SELECT COUNT(*) FROM t01 WHERE c = '' AND ((n > 0 AND NULLIF(c, '') = 'x') IS NOT FALSE);
-- expected: rows: 2
evaluate 'Case P-5';
SELECT COUNT(*) FROM t01 WHERE c = '' AND ((n > 0 AND NULLIF(c, '') = 'x') IS UNKNOWN);
-- expected: rows: 0
evaluate 'Case P-6';
SELECT COUNT(*) FROM t01 WHERE c = '' AND ((n > 0 AND NULLIF(c, '') = 'x') IS NOT UNKNOWN);
-- the parse of the unparenthesized TC forms 1-9, 1-8, 1-6, written out
-- expected: rows: 3
evaluate 'Case P-7';
SELECT COUNT(*) FROM t01 WHERE (c = '' AND (n > 0 AND NULLIF(c, '') = 'x')) IS NOT TRUE;
-- expected: rows: 1
evaluate 'Case P-8';
SELECT COUNT(*) FROM t01 WHERE (c = '' AND (n > 0 AND NULLIF(c, '') = 'x')) IS FALSE;
-- expected: rows: 1
evaluate 'Case P-9';
SELECT COUNT(*) FROM t01 WHERE (c = '' AND (n > 0 AND NULLIF(c, '') = 'x')) IS NOT UNKNOWN;
-- Q: the TRUE fold under IS / NOT / XOR / CASE / IF
-- expected: rows: 0
evaluate 'Case Q-3';
SELECT COUNT(*) FROM t01b WHERE c0 = 5 AND (((c0 < 9) AND (c1 = 'x')) IS FALSE);
-- expected: rows: 1
evaluate 'Case Q-4';
SELECT COUNT(*) FROM t01b WHERE c0 = 5 AND (((c0 < 9) AND (c1 = 'x')) IS NOT FALSE);
-- N: the NULL fold first / second, AND / OR (t01, c = '' gives NULLIF(c, '') NULL)
-- expected: rows: 1
evaluate 'Case N-5';
SELECT COUNT(*) FROM t01 WHERE c = '' AND (n > 1 AND NULLIF(c, '') = 'x') IS NULL;
-- expected: rows: 1
evaluate 'Case N-6';
SELECT COUNT(*) FROM t01 WHERE c = '' AND (n > 1 OR NULLIF(c, '') = 'x') IS NULL;
-- expected: rows: 2
evaluate 'Case N-7';
SELECT COUNT(*) FROM t01 WHERE c = '' AND COALESCE((n > 0 AND NULLIF(c, '') = 'x'), 7) = 7;
-- expected: rows: 2
evaluate 'Case N-8';
SELECT COUNT(*) FROM t01 WHERE c = '' AND (CASE WHEN n > 0 AND NULLIF(c, '') = 'x' THEN 1 ELSE 0 END) = 0;
-- expected: rows: 2
evaluate 'Case N-9';
SELECT COUNT(*) FROM t01 WHERE c = '' AND ((NOT (n > 0 AND NULLIF(c, '') = 'x')) IS NULL);
-- expected: rows: 1
evaluate 'Case N-10';
SELECT COUNT(*) FROM t01 WHERE c = '' AND ((NOT (n > 1 AND NULLIF(c, '') = 'x')) IS NULL);
-- expected: rows: 1 | 0 / 2 | 1
evaluate 'Case N-11';
SELECT n, ((n > 1 AND NULLIF(c, '') = 'x') IS NULL) AS v FROM t01 WHERE c = '' ORDER BY n;
-- CBRD-28027
-- CBRD-28156
-- expected: rows: 2
evaluate 'Case C-2';
SELECT COUNT(*) FROM j1 x WHERE x.b = 9 AND NOT (x.b = 9 AND x.a = 5);
-- M: CBRD-27904 family (no substitution, AND/OR folding with a NULL constant). With the CNF walk kept to AND and OR
-- (#8590), an AND or OR under IS stays a tree and takes this folding too, it folds NULL only for a filter term now.
-- n is 1, 2, 3: (FALSE AND NULL) is FALSE, (FALSE OR NULL) is UNKNOWN
-- expected: rows: 0
evaluate 'Case M-1';
SELECT COUNT(*) FROM t01 WHERE ((n < 0) AND (1 = NULL)) IS NULL;
-- expected: rows: 3
evaluate 'Case M-2';
SELECT COUNT(*) FROM t01 WHERE ((n < 0) OR (1 = NULL)) IS NULL;
-- expected: rows: 0 / 0 / 0
evaluate 'Case M-3';
SELECT ((n < 0) AND (1 = NULL)) IS NULL AS m FROM t01 ORDER BY n;
-- expected: rows: 1 / 1 / 1
evaluate 'Case M-4';
SELECT ((n < 0) OR (1 = NULL)) IS NULL AS m FROM t01 ORDER BY n;

-- agent-d edge shapes: several folded disjuncts in one or_next chain, nested
-- (NULL OR NULL) AND n > 1: n=1 FALSE, n=2 NULL
-- NULL OR NULL OR n > 1: n=1 NULL, n=2 TRUE
-- (NULL OR TRUE) AND n > 1 IS FALSE: n=1 FALSE -> 1 row
-- (NULL OR FALSE) AND n > 0 IS UNKNOWN: NULL -> 2 rows
-- (NULL OR n > 1) AND (NULL OR n < 2) IS NULL: n=1 (NULL)AND(TRUE)=NULL yes, n=2 TRUE AND NULL = NULL yes -> 2
-- a filter (top level) OR with a substituted NULL disjunct: NULL acts as FALSE, plan should be the same as develop
-- expected: rows: 1
evaluate 'Case E-6';
SELECT COUNT(*) FROM t01 WHERE c = '' AND (NULLIF(c, '') = 'x' OR n = 2);
-- expected: rows: 0
evaluate 'Case E-7';
SELECT COUNT(*) FROM t01 WHERE c = '' AND (NULLIF(c, '') = 'x' OR NULLIF(c, '') = 'y');
-- NOT over the substituted AND (top level, NOT pushed): NOT (n > 0 AND NULL) = (n <= 0 OR NULL) -> no row
-- expected: rows: 0
evaluate 'Case E-8';
SELECT COUNT(*) FROM t01 WHERE c = '' AND NOT (NULLIF(c, '') = 'x' AND n > 0);
-- the select list keeps 3VL (no substitution there)
-- expected: rows: 1 | 1 / 2 | 0
evaluate 'Case E-9';
SELECT n, ((NULLIF(c, '') = 'x' OR n > 1) IS NULL) AS v FROM t01 WHERE c = '' ORDER BY n;

DROP TABLE t01, t01b, t27, j1;

-- agent-d: the same shapes through other paths (subquery, view, derived table, DELETE/UPDATE)
DROP VIEW IF EXISTS v01;
DROP TABLE IF EXISTS t01, t01b, t01d;
CREATE TABLE t01 (c VARCHAR, n INT);
INSERT INTO t01 VALUES ('', 1), ('', 2), ('z', 3);
CREATE TABLE t01b (c0 DOUBLE, c1 VARCHAR);
INSERT INTO t01b VALUES (5, NULL);
CREATE VIEW v01 AS SELECT c, n FROM t01 WHERE c = '';
-- expected: rows: 2
evaluate 'Case V-1';
SELECT COUNT(*) FROM v01 WHERE (n > 0 AND NULLIF(c, '') = 'x') IS NULL;
-- expected: rows: 2
evaluate 'Case V-3';
SELECT COUNT(*) FROM t01 o WHERE EXISTS (SELECT 1 FROM t01 i WHERE i.c = '' AND i.n = o.n AND (i.n > 0 AND NULLIF(i.c, '') = 'x') IS NULL);
-- expected: rows: 2
evaluate 'Case V-4';
SELECT COUNT(*) FROM (SELECT c, n FROM t01 WHERE c = '' AND (n > 0 AND NULLIF(c, '') = 'x') IS NULL) d;
-- DML: the WHERE of DELETE/UPDATE goes through the same reduction
CREATE TABLE t01d (c VARCHAR, n INT);
INSERT INTO t01d SELECT c, n FROM t01;
-- expected: affected: 2
evaluate 'Case V-6';
DELETE FROM t01d WHERE c = '' AND (n > 0 AND NULLIF(c, '') = 'x') IS NULL;
-- expected: rows: 'z' | 3
evaluate 'Case V-7';
SELECT c, n FROM t01d ORDER BY n;
INSERT INTO t01d SELECT c, n FROM t01 WHERE c = '';
-- the same statement twice (the second run takes the cached plan)
-- expected: rows: 2
evaluate 'Case V-10';
SELECT COUNT(*) FROM t01 WHERE c = '' AND (n > 0 AND NULLIF(c, '') = 'x') IS NULL;
-- expected: rows: 2
evaluate 'Case V-11';
SELECT COUNT(*) FROM t01 WHERE c = '' AND (n > 0 AND NULLIF(c, '') = 'x') IS NULL;
DROP VIEW v01;
DROP TABLE t01, t01b, t01d;

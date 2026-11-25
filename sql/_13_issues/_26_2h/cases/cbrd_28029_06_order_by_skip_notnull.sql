/**
 *  This test case verifies CBRD-28029 #6: an index scan skips ORDER BY (or GROUP BY) only when the WHERE proves the key columns NOT NULL,
 *  a predicate that can be true on a NULL key (IS FALSE over a predicate, one branch of an OR, a term inside a
 *  subquery, NULLIF(1, f(key))) is no such proof. Rows whose keys are all NULL are not in the index.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t06, t06w, t06xo, t06xi, t06u, t06v;
CREATE TABLE t06 (a FLOAT, b VARCHAR(10));
CREATE INDEX t06_ba ON t06 (b, a DESC);
INSERT INTO t06 VALUES (NULL, NULL), (1, 'x'), (NULL, 'y');
-- expected: rows: NULL / 'y'
evaluate 'Case 6-1';
SELECT b FROM t06 WHERE (a IS NOT NULL) IS FALSE ORDER BY b, a DESC;
-- expected: rows: NULL
evaluate 'Case 6-2';
SELECT b FROM t06 WHERE (b IS NOT NULL) IS FALSE ORDER BY b, a DESC;
-- expected: rows: 2
evaluate 'Case 6-c1';
SELECT COUNT(*) AS cnt FROM t06 WHERE (a IS NOT NULL) IS FALSE;
-- expected: rows: NULL / 'y'
evaluate 'Case 6-c2';
SELECT b FROM t06 WHERE (a IS NOT NULL) IS FALSE USING INDEX NONE ORDER BY b, a DESC;
-- expected: rows: NULL | 1
evaluate 'Case 6-3';
SELECT b, COUNT(*) AS cnt FROM t06 WHERE (b IS NOT NULL) IS FALSE GROUP BY b ORDER BY b;
-- expected: rows: NULL / 'y'
evaluate 'Case 6-4';
SELECT b FROM t06 WHERE (a IS NULL) IS TRUE ORDER BY b, a DESC;
-- expected: rows: NULL / 'y'
evaluate 'Case 6-5';
SELECT b FROM t06 WHERE NOT (a IS NOT NULL) ORDER BY b, a DESC;
-- expected: rows: NULL / 'y'
evaluate 'Case 6-6';
SELECT b FROM t06 WHERE (a IS NOT NULL) IS NOT TRUE ORDER BY b, a DESC;
-- expected: rows: NULL / 'y'
evaluate 'Case 6-7';
SELECT b FROM t06 WHERE (a > 0) IS NOT TRUE ORDER BY b, a DESC;
-- no row: (NULL, NULL) gives F OR UNKNOWN, which IS FALSE is not (expectation corrected 11-17: NULL > 5 is UNKNOWN)
-- expected: empty
evaluate 'Case 6-8';
SELECT b FROM t06 WHERE (b IS NOT NULL OR a > 5) IS FALSE ORDER BY b, a DESC;
-- (NULL, NULL) gives F OR F
-- expected: rows: NULL
evaluate 'Case 6-8b';
SELECT b FROM t06 WHERE (b IS NOT NULL OR NVL(a, 0) > 5) IS FALSE ORDER BY b, a DESC;
-- expected: rows: NULL / 'y'
evaluate 'Case 6-9';
SELECT b FROM t06 WHERE (NOT (a > 0)) IS NULL ORDER BY b, a DESC;
-- expected: rows: NULL / 'y'
evaluate 'Case 6-10';
SELECT b FROM t06 WHERE (CASE WHEN a IS NULL THEN 1 END) = 1 ORDER BY b, a DESC;
-- expected: rows: NULL / 'x' / 'y'
evaluate 'Case 6-11';
SELECT b FROM t06 WHERE (a IS NOT NULL) IS NOT NULL ORDER BY b, a DESC;
-- keys that are proved NOT NULL: the skip stays and the rows are right
-- expected: rows: 'x'
evaluate 'Case 6-n1';
--@queryplan
SELECT b FROM t06 WHERE a > 0 ORDER BY b, a DESC;
-- expected: rows: 'x' / 'y'
evaluate 'Case 6-n2';
--@queryplan
SELECT b FROM t06 WHERE b IS NOT NULL ORDER BY b, a DESC;
-- expected: empty
evaluate 'Case 6-n3';
SELECT b FROM t06 WHERE (a > 0) IS FALSE ORDER BY b, a DESC;
-- expected: rows: 'x'
evaluate 'Case 6-n4';
--@queryplan
SELECT b FROM t06 WHERE (a > 0) IS TRUE ORDER BY b, a DESC;
-- expected: rows: 'x' / 'y'
evaluate 'Case 6-n5';
--@queryplan
SELECT b FROM t06 WHERE b > 'a' ORDER BY b, a DESC;

-- one branch of an OR compares the key column with another column
CREATE TABLE t06w (a DOUBLE, b DOUBLE UNIQUE);
INSERT INTO t06w VALUES (1, NULL), (2, NULL), (3, 5), (NULL, 6);
-- ORDER BY b alone (as reported): the two NULL keys tie, so the rows are compared as a set
-- expected: set: 1.000000000000000e+00 | NULL / 2.000000000000000e+00 | NULL / 3.000000000000000e+00 | 5.000000000000000e+00
evaluate 'Case 6-20';
SELECT a, b FROM t06w WHERE (a > 0) OR (b < a) ORDER BY b;
-- expected: rows: 1.000000000000000e+00 | NULL / 2.000000000000000e+00 | NULL / 3.000000000000000e+00 | 5.000000000000000e+00
evaluate 'Case 6-20b';
SELECT a, b FROM t06w WHERE (a > 0) OR (b < a) ORDER BY b, a;
-- expected: set: 1.000000000000000e+00 | NULL / 2.000000000000000e+00 | NULL / 3.000000000000000e+00 | 5.000000000000000e+00
evaluate 'Case 6-21';
SELECT a, b FROM t06w WHERE (a = a) OR (b < a) ORDER BY b;
-- expected: set: 1.000000000000000e+00 | NULL / 2.000000000000000e+00 | NULL / 3.000000000000000e+00 | 5.000000000000000e+00
evaluate 'Case 6-c20';
SELECT a, b FROM t06w WHERE (a > 0) OR (b < 0) ORDER BY b;
-- the key column compared with another column in both branches
-- expected: rows: 3.000000000000000e+00 | 5.000000000000000e+00
evaluate 'Case 6-22';
SELECT a, b FROM t06w WHERE (b > a) OR (b < a) ORDER BY b;
-- expected: rows: NULL | 6.000000000000000e+00
evaluate 'Case 6-23';
SELECT a, b FROM t06w WHERE b > 5 OR b = a ORDER BY b;
-- expected: set: 1.000000000000000e+00 | NULL / 2.000000000000000e+00 | NULL / 3.000000000000000e+00 | 5.000000000000000e+00
evaluate 'Case 6-24';
SELECT a, b FROM t06w WHERE (a > 0) OR (b < a) GROUP BY b, a ORDER BY b;

-- a key column of the outer table compared inside a correlated subquery
CREATE TABLE t06xo (a INT UNIQUE, b VARCHAR);
CREATE TABLE t06xi (v DOUBLE);
INSERT INTO t06xo VALUES (NULL, 'x'), (1, 'y');
INSERT INTO t06xi VALUES (0.5E0), (5.0E0);
-- expected: rows: NULL | 'x' / 1 | 'y'
evaluate 'Case 6-30';
SELECT a, b FROM t06xo o WHERE 1 <> ANY (SELECT i.v FROM t06xi i WHERE o.b = o.b OR o.a > i.v) ORDER BY a;
-- expected: rows: NULL | 'x' / 1 | 'y'
evaluate 'Case 6-31';
SELECT a, b FROM t06xo o WHERE NOT (1 = ALL (SELECT i.v FROM t06xi i WHERE o.b = o.b OR o.a > i.v)) ORDER BY a;
-- expected: rows: NULL | 'x' / 1 | 'y'
evaluate 'Case 6-32';
SELECT a, b FROM t06xo o WHERE 1 < ANY (SELECT i.v FROM t06xi i WHERE o.b = o.b OR o.a > i.v) ORDER BY a;
-- expected: rows: NULL | 'x' / 1 | 'y'
evaluate 'Case 6-33';
SELECT a, b FROM t06xo o WHERE 1 <> ANY (SELECT i.v FROM t06xi i WHERE o.a > i.v OR i.v > 0) ORDER BY a;
-- expected: rows: 1 | 'y'
evaluate 'Case 6-34';
SELECT a, b FROM t06xo o WHERE 1 <> ANY (SELECT i.v FROM t06xi i WHERE o.a > i.v) ORDER BY a;
-- expected: rows: NULL | 'x' / 1 | 'y'
evaluate 'Case 6-c30';
SELECT a, b FROM t06xo o WHERE 1 <> ANY (SELECT i.v FROM t06xi i WHERE o.b = o.b) ORDER BY a;
-- expected: rows: NULL | 1 / 1 | 1
evaluate 'Case 6-35';
SELECT a, COUNT(*) AS cnt FROM t06xo o WHERE 1 <> ANY (SELECT i.v FROM t06xi i WHERE o.b = o.b OR o.a > i.v) GROUP BY a ORDER BY a;

-- NULLIF(1, CHAR_LENGTH(c0)) is 1 for a NULL c0
CREATE TABLE t06u (c0 VARCHAR(41) UNIQUE);
CREATE TABLE t06v (c1 DOUBLE);
INSERT INTO t06u VALUES (NULL), (NULL), ('ab');
INSERT INTO t06v VALUES (1), (2);
-- expected: rows: NULL | 1.000000000000000e+00 / NULL | 1.000000000000000e+00 / NULL | 2.000000000000000e+00 / NULL | 2.000000000000000e+00 / 'ab' | 1.000000000000000e+00 / 'ab' | 2.000000000000000e+00
evaluate 'Case 6-40';
SELECT u.c0, v.c1 FROM t06u u INNER JOIN t06v v ON (-5 < NULLIF(1, CHAR_LENGTH(u.c0))) ORDER BY u.c0, v.c1;
-- expected: rows: NULL / NULL / 'ab'
evaluate 'Case 6-41';
SELECT u.c0 FROM t06u u WHERE (-5 < NULLIF(1, CHAR_LENGTH(u.c0))) ORDER BY u.c0;
-- expected: rows: NULL / NULL / 'ab'
evaluate 'Case 6-42';
SELECT u.c0 FROM t06u u WHERE NULLIF(1, CHAR_LENGTH(u.c0)) = 1 ORDER BY u.c0;
-- expected: rows: NULL / NULL / 'ab'
evaluate 'Case 6-43';
SELECT u.c0 FROM t06u u WHERE NVL(CHAR_LENGTH(u.c0), 0) >= 0 ORDER BY u.c0;
-- expected: rows: NULL / NULL / 'ab'
evaluate 'Case 6-44';
SELECT u.c0 FROM t06u u WHERE COALESCE(u.c0, 'z') > 'a' ORDER BY u.c0;
-- expected: rows: NULL | 2 / 'ab' | 1
evaluate 'Case 6-45';
SELECT u.c0, COUNT(*) AS cnt FROM t06u u WHERE (-5 < NULLIF(1, CHAR_LENGTH(u.c0))) GROUP BY u.c0 ORDER BY u.c0;
-- expected: rows: NULL / NULL / 'ab'
evaluate 'Case 6-c40';
SELECT u.c0 FROM t06u u WHERE (-5 < NULLIF(1, CHAR_LENGTH(u.c0))) USING INDEX NONE ORDER BY u.c0;
-- the key is proved NOT NULL: CHAR_LENGTH(c0) > 0 is null-rejecting
-- expected: rows: 'ab'
evaluate 'Case 6-n40';
--@queryplan
SELECT u.c0 FROM t06u u WHERE CHAR_LENGTH(u.c0) > 0 ORDER BY u.c0;
-- functions that are not NULL on a NULL argument, and aggregate subqueries (found while implementing)
-- expected: rows: NULL / NULL / 'ab'
evaluate 'Case 6-60';
SELECT u.c0 FROM t06u u WHERE JSON_ARRAY(u.c0) IS NOT NULL ORDER BY u.c0;
-- expected: rows: NULL / NULL
evaluate 'Case 6-61';
SELECT u.c0 FROM t06u u WHERE (SELECT COUNT(*) FROM t06v v WHERE v.c1 = CHAR_LENGTH(u.c0)) = 0 ORDER BY u.c0;
-- expected: rows: NULL / NULL / 'ab'
evaluate 'Case 6-62';
SELECT u.c0 FROM t06u u WHERE EXISTS (SELECT COUNT(*) FROM t06v v WHERE v.c1 = CHAR_LENGTH(u.c0)) ORDER BY u.c0;
-- expected: rows: NULL / NULL / 'ab'
evaluate 'Case 6-63';
SELECT u.c0 FROM t06u u WHERE TYPEOF(u.c0) IS NOT NULL ORDER BY u.c0;
-- a NULL key IN a subquery, or compared with MAX of no row, is no row: the skip stays
-- expected: rows: 'ab'
evaluate 'Case 6-n60';
--@queryplan
SELECT u.c0 FROM t06u u WHERE u.c0 IN (SELECT 'ab' FROM t06v v) ORDER BY u.c0;
-- expected: rows: 'ab'
evaluate 'Case 6-n61';
--@queryplan
SELECT u.c0 FROM t06u u WHERE (SELECT MAX(v.c1) FROM t06v v WHERE v.c1 = CHAR_LENGTH(u.c0)) = 2 ORDER BY u.c0;
-- an ON term of a LEFT OUTER JOIN does not filter the preserved table: o.k > 0 is no proof that o.k is NOT NULL
CREATE TABLE t06lo (k INT UNIQUE, v VARCHAR);
CREATE TABLE t06li (k INT);
INSERT INTO t06lo VALUES (NULL, 'n1'), (NULL, 'n2'), (1, 'a'), (2, 'b');
INSERT INTO t06li VALUES (1), (2);
-- expected: set: NULL | 'n1' / NULL | 'n2' / 1 | 'a' / 2 | 'b'
evaluate 'Case 6-50';
SELECT o.k, o.v FROM t06lo o LEFT OUTER JOIN t06li i ON o.k > 0 AND i.k = o.k ORDER BY o.k;
-- expected: rows: NULL | 'n1' / NULL | 'n2' / 1 | 'a' / 2 | 'b'
evaluate 'Case 6-51';
SELECT o.k, o.v FROM t06lo o LEFT OUTER JOIN t06li i ON o.k > 0 AND i.k = o.k ORDER BY o.k, o.v;
-- FIELD(NULL, ...) is 0 and an AND under IS FALSE can be true on a NULL key
-- expected: rows: NULL / NULL / 'ab'
evaluate 'Case 6-52';
SELECT u.c0 FROM t06u u WHERE FIELD(u.c0, 'q') = 0 ORDER BY u.c0;
-- expected: rows: NULL / NULL
evaluate 'Case 6-53';
SELECT u.c0 FROM t06u u WHERE (u.c0 > 'a' AND u.c0 < 'b') IS NOT TRUE ORDER BY u.c0;
DROP TABLE t06lo, t06li;
DROP TABLE t06, t06w, t06xo, t06xi, t06u, t06v;

/**
 *  This test case verifies CBRD-28029 #11 and #12: BETWEEN and its negation must compare with the same types, so that a row is in exactly
 *  one of p, NOT p and p IS NULL. #11: FLOAT x against an INT and a DOUBLE bound, #12: BIGINT beyond 2^53 against a
 *  DOUBLE bound (DOUBLE cannot tell -9223372036854775808 from -9223372036854775806).
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t11f, t11g, t12, t12b;
CREATE TABLE t11f (x FLOAT);
CREATE TABLE t11g (y INT);
INSERT INTO t11f VALUES (-1923119233);
INSERT INTO t11g VALUES (-1923119233);
-- FLOAT x is -1923119232 (24-bit mantissa), x <= y compares as FLOAT (true), x >= CAST(y AS DOUBLE) as DOUBLE (true)
-- expected: rows: 1
evaluate 'Case 11-1';
SELECT COUNT(*) AS cnt FROM t11f, t11g WHERE x BETWEEN CAST(y AS DOUBLE) AND y;
-- expected: rows: 0
evaluate 'Case 11-2';
SELECT COUNT(*) AS cnt FROM t11f, t11g WHERE NOT (x BETWEEN CAST(y AS DOUBLE) AND y);
-- expected: rows: 0
evaluate 'Case 11-3';
SELECT COUNT(*) AS cnt FROM t11f, t11g WHERE x NOT BETWEEN CAST(y AS DOUBLE) AND y;
-- expected: rows: 0
evaluate 'Case 11-4';
SELECT COUNT(*) AS cnt FROM t11f, t11g WHERE (x BETWEEN CAST(y AS DOUBLE) AND y) IS NULL;
-- expected: rows: 1 | 0 | 0
evaluate 'Case 11-5';
SELECT (x BETWEEN CAST(y AS DOUBLE) AND y) AS p, (NOT (x BETWEEN CAST(y AS DOUBLE) AND y)) AS np, (x NOT BETWEEN CAST(y AS DOUBLE) AND y) AS nb FROM t11f, t11g;
-- expected: rows: 1
evaluate 'Case 11-c1';
SELECT COUNT(*) AS cnt FROM t11f, t11g WHERE x BETWEEN y AND y;
-- expected: rows: 0
evaluate 'Case 11-c2';
SELECT COUNT(*) AS cnt FROM t11f, t11g WHERE NOT (x BETWEEN y AND y);
-- the bounds the other way round: x <= CAST(y AS DOUBLE) is false, so p is false and NOT p true
-- expected: rows: 0
evaluate 'Case 11-6';
SELECT COUNT(*) AS cnt FROM t11f, t11g WHERE x BETWEEN y AND CAST(y AS DOUBLE);
-- expected: rows: 1
evaluate 'Case 11-7';
SELECT COUNT(*) AS cnt FROM t11f, t11g WHERE NOT (x BETWEEN y AND CAST(y AS DOUBLE));
-- expected: rows: 1
evaluate 'Case 11-8';
SELECT COUNT(*) AS cnt FROM t11f, t11g WHERE x NOT BETWEEN y AND CAST(y AS DOUBLE);
-- expected: rows: 0 | 1 | 1
evaluate 'Case 11-9';
SELECT (x BETWEEN y AND CAST(y AS DOUBLE)) AS p, (NOT (x BETWEEN y AND CAST(y AS DOUBLE))) AS np, (x NOT BETWEEN y AND CAST(y AS DOUBLE)) AS nb FROM t11f, t11g;
-- a host variable bound
-- expected: exec
evaluate 'Case 11-10p';
PREPARE p11 FROM 'SELECT COUNT(*) AS cnt FROM t11f, t11g WHERE NOT (x BETWEEN CAST(y AS DOUBLE) AND ?)';
-- expected: rows: 0
evaluate 'Case 11-10';
EXECUTE p11 USING -1923119233;
DEALLOCATE PREPARE p11;

CREATE TABLE t12 (c0 BIGINT);
INSERT INTO t12 VALUES (-9223372036854775808), (1);
-- expected: rows: 2
evaluate 'Case 12-1';
SELECT COUNT(*) AS cnt FROM t12 WHERE NOT (c0 BETWEEN c0 + 2 AND 0.5E0);
-- expected: rows: 0
evaluate 'Case 12-2';
SELECT COUNT(*) AS cnt FROM t12 WHERE c0 BETWEEN c0 + 2 AND 0.5E0;
-- expected: rows: 2
evaluate 'Case 12-3';
SELECT COUNT(*) AS cnt FROM t12 WHERE c0 NOT BETWEEN c0 + 2 AND 0.5E0;
-- expected: rows: 0
evaluate 'Case 12-4';
SELECT COUNT(*) AS cnt FROM t12 WHERE (c0 BETWEEN c0 + 2 AND 0.5E0) IS NULL;
-- expected: rows: -9223372036854775808 | 0 | 1 | 1 / 1 | 0 | 1 | 1
evaluate 'Case 12-5';
SELECT c0, (c0 BETWEEN c0 + 2 AND 0.5E0) AS p, (NOT (c0 BETWEEN c0 + 2 AND 0.5E0)) AS np, (c0 NOT BETWEEN c0 + 2 AND 0.5E0) AS nb FROM t12 ORDER BY c0;
-- expected: rows: -9223372036854775808 / 1
evaluate 'Case 12-6';
SELECT c0 FROM t12 WHERE NOT (c0 BETWEEN c0 + 2 AND 0.5E0) ORDER BY c0;
-- expected: rows: 2
evaluate 'Case 12-c1';
SELECT COUNT(*) AS cnt FROM t12 WHERE NOT (c0 BETWEEN c0 + 2 AND 0.5);
-- the upper end of BIGINT
CREATE TABLE t12b (c0 BIGINT);
INSERT INTO t12b VALUES (9223372036854775807), (1);
-- expected: rows: 0
evaluate 'Case 12-7';
SELECT COUNT(*) AS cnt FROM t12b WHERE c0 BETWEEN -0.5E0 AND c0 - 2;
-- expected: rows: 2
evaluate 'Case 12-8';
SELECT COUNT(*) AS cnt FROM t12b WHERE NOT (c0 BETWEEN -0.5E0 AND c0 - 2);
-- expected: rows: 2
evaluate 'Case 12-9';
SELECT COUNT(*) AS cnt FROM t12b WHERE c0 NOT BETWEEN -0.5E0 AND c0 - 2;
-- constant BIGINT operands that DOUBLE cannot hold apart, with a DOUBLE bound (folded at compile time)
-- expected: rows: 0 | 1 | 1
evaluate 'Case 12-10';
SELECT (CAST(-9223372036854775808 AS BIGINT) BETWEEN CAST(-9223372036854775806 AS BIGINT) AND 1.0E0) AS p, (NOT (CAST(-9223372036854775808 AS BIGINT) BETWEEN CAST(-9223372036854775806 AS BIGINT) AND 1.0E0)) AS np, (CAST(-9223372036854775808 AS BIGINT) NOT BETWEEN CAST(-9223372036854775806 AS BIGINT) AND 1.0E0) AS nb FROM db_root;
-- the negation in other clauses: ON, HAVING, double negation, DML
-- expected: rows: 1
evaluate 'Case 12-11';
SELECT COUNT(*) AS cnt FROM t11f INNER JOIN t11g ON x BETWEEN CAST(y AS DOUBLE) AND y;
-- expected: rows: 0
evaluate 'Case 12-12';
SELECT COUNT(*) AS cnt FROM t11f INNER JOIN t11g ON NOT (x BETWEEN CAST(y AS DOUBLE) AND y);
-- expected: rows: 1
evaluate 'Case 12-13';
SELECT COUNT(*) AS cnt FROM t11f, t11g WHERE NOT (x NOT BETWEEN CAST(y AS DOUBLE) AND y);
-- expected: rows: -9223372036854775808 / 1
evaluate 'Case 12-14';
SELECT c0 FROM t12 GROUP BY c0 HAVING NOT (c0 BETWEEN c0 + 2 AND 0.5E0) ORDER BY c0;
-- expected: affected: 2
evaluate 'Case 12-15';
UPDATE t12 SET c0 = c0 WHERE NOT (c0 BETWEEN c0 + 2 AND 0.5E0);
-- expected: affected: 2
evaluate 'Case 12-16';
DELETE FROM t12b WHERE NOT (c0 BETWEEN -0.5E0 AND c0 - 2);
-- CHAR literals padded against a VARCHAR bound: '' = ' ' as CHAR
DROP TABLE IF EXISTS t12s;
CREATE TABLE t12s (id INT, v VARCHAR(10));
INSERT INTO t12s VALUES (1, 'xy'), (2, NULL);
-- expected: rows: 1 | 1 | 0 / 2 | NULL | NULL
evaluate 'Case 12-17';
SELECT id, ('' BETWEEN ' ' AND v) AS p, ('' NOT BETWEEN ' ' AND v) AS nb FROM t12s ORDER BY id;
-- expected: rows: 1 | 0
evaluate 'Case 12-18';
SELECT ('' BETWEEN ' ' AND CAST('xy' AS VARCHAR)) AS p, ('' NOT BETWEEN ' ' AND CAST('xy' AS VARCHAR)) AS nb FROM db_root;
-- expected: rows: 0
evaluate 'Case 12-19';
SELECT COUNT(*) AS cnt FROM t12s WHERE '' NOT BETWEEN ' ' AND CAST('xy' AS VARCHAR);
DROP TABLE t12s;
DROP TABLE t11f, t11g, t12, t12b;

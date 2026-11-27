/**
 *  This test case verifies CBRD-28029 #4: a LEFT OUTER JOIN ON that ANDs a key condition of the inner table with a term that reads only the
 *  outer (preserved) table, when the inner table is read through a covering index, that outer term must still filter.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t04o, t04i, t04j;
CREATE TABLE t04o (c VARCHAR PRIMARY KEY);
CREATE TABLE t04i (c BIGINT PRIMARY KEY, d INT);
CREATE TABLE t04j (k INT, v INT);
CREATE INDEX t04j_k ON t04j (k);
CREATE INDEX t04j_vk ON t04j (v DESC, k);
INSERT INTO t04o VALUES ('a'), ('b');
INSERT INTO t04i VALUES (1, 10), (2, 20), (3, 30);
INSERT INTO t04j VALUES (1, 1), (2, 2), (3, 3);
-- o.c is never 'zz': the ON is false for every pair and every outer row is padded with NULL
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-1';
SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c >= 2) AND (o.c = 'zz') ORDER BY 1, 2;
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-2';
SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c = 2) AND (o.c = 'zz') ORDER BY 1, 2;
-- o.c > 'a' is true only for 'b'
-- expected: rows: 'a' | NULL / 'b' | 2 / 'b' | 3
evaluate 'Case 4-3';
SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c >= 2) AND (o.c > 'a') ORDER BY 1, 2;
-- controls: not covering (i.d is outside the index), no index
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-c1';
SELECT o.c, i.d FROM t04o o LEFT OUTER JOIN t04i i ON (i.c >= 2) AND (o.c = 'zz') ORDER BY 1, 2;
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-c2';
SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c >= 2) AND (o.c = 'zz') USING INDEX NONE ORDER BY 1, 2;
-- expected: rows: 'a' | NULL / 'b' | 2 / 'b' | 3
evaluate 'Case 4-c3';
SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c >= 2) AND (o.c > 'a') USING INDEX NONE ORDER BY 1, 2;
-- other key conditions
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-4';
SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c BETWEEN 2 AND 3) AND (o.c = 'zz') ORDER BY 1, 2;
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-5';
SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c IN (1, 3)) AND (o.c = 'zz') ORDER BY 1, 2;
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-6';
SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c > 1) AND (o.c IS NULL) ORDER BY 1, 2;
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-7';
SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c >= 2) AND (CHAR_LENGTH(o.c) = 5) ORDER BY 1, 2;
-- the outer term is true for every outer row
-- expected: rows: 'a' | 2 / 'a' | 3 / 'b' | 2 / 'b' | 3
evaluate 'Case 4-8';
SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c >= 2) AND (o.c IN ('a', 'b')) ORDER BY 1, 2;
-- an inner-only term next to the key condition and the outer term
-- expected: rows: 'a' | NULL / 'b' | 2
evaluate 'Case 4-9';
SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c >= 2) AND (i.c <> 3) AND (o.c > 'a') ORDER BY 1, 2;
-- counts and groups
-- expected: rows: 2
evaluate 'Case 4-10';
SELECT COUNT(*) AS cnt FROM t04o o LEFT OUTER JOIN t04i i ON (i.c >= 2) AND (o.c = 'zz');
-- expected: rows: 'a' | 0 / 'b' | 2
evaluate 'Case 4-11';
SELECT o.c, COUNT(i.c) AS cnt FROM t04o o LEFT OUTER JOIN t04i i ON (i.c >= 2) AND (o.c > 'a') GROUP BY o.c ORDER BY 1;
-- RIGHT OUTER JOIN with the sides swapped
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-12';
SELECT o.c, i.c FROM t04i i RIGHT OUTER JOIN t04o o ON (i.c >= 2) AND (o.c = 'zz') ORDER BY 1, 2;
-- expected: rows: 'a' | NULL / 'b' | 2 / 'b' | 3
evaluate 'Case 4-13';
SELECT o.c, i.c FROM t04i i RIGHT OUTER JOIN t04o o ON (i.c >= 2) AND (o.c > 'a') ORDER BY 1, 2;
-- a secondary index, ascending and descending
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-14';
SELECT o.c, j.k FROM t04o o LEFT OUTER JOIN t04j j ON (j.k >= 2) AND (o.c = 'zz') ORDER BY 1, 2;
-- expected: rows: 'a' | NULL / 'b' | 2 / 'b' | 3
evaluate 'Case 4-15';
SELECT o.c, j.k FROM t04o o LEFT OUTER JOIN t04j j ON (j.k >= 2) AND (o.c > 'a') ORDER BY 1, 2;
-- expected: rows: 'a' | NULL | NULL / 'b' | 2 | 2 / 'b' | 3 | 3
evaluate 'Case 4-16';
SELECT o.c, j.v, j.k FROM t04o o LEFT OUTER JOIN t04j j ON (j.v >= 2) AND (o.c > 'a') ORDER BY 1, 2;
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-17';
SELECT o.c, j.k FROM t04o o LEFT OUTER JOIN t04j j ON (j.k >= 2) AND (o.c = 'zz') USING INDEX NONE ORDER BY 1, 2;
-- INNER JOIN: the outer term filters the outer side
-- expected: empty
evaluate 'Case 4-18';
SELECT o.c, i.c FROM t04o o INNER JOIN t04i i ON (i.c >= 2) AND (o.c = 'zz') ORDER BY 1, 2;
-- host variables
PREPARE p04 FROM 'SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c >= ?) AND (o.c = ?) ORDER BY 1, 2';
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-19';
EXECUTE p04 USING 2, 'zz';
-- expected: rows: 'a' | NULL / 'b' | 2 / 'b' | 3
evaluate 'Case 4-20';
EXECUTE p04 USING 2, 'b';
DEALLOCATE PREPARE p04;
-- the outer term compares the outer column with the inner key (a real join term) next to an outer-only term
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-21';
SELECT o.c, i.c FROM t04o o LEFT OUTER JOIN t04i i ON (i.c >= 2) AND (o.c = 'zz') AND (CAST(i.c AS VARCHAR) <> o.c) ORDER BY 1, 2;
-- more forms (found while analysing): ON terms that read no table, a key list on a two-column covering index,
-- a partitioned inner table, an aggregate over the padded rows, and DML through the same join
DROP TABLE IF EXISTS t04p, t04q, t04r, t04s, t04hp;
CREATE TABLE t04p (c VARCHAR PRIMARY KEY);
CREATE TABLE t04q (c BIGINT PRIMARY KEY, d INT);
CREATE TABLE t04r (k INT, c VARCHAR);
CREATE TABLE t04s (a INT, b INT, d INT);
CREATE INDEX t04s_ab ON t04s (a, b);
CREATE TABLE t04hp (c INT PRIMARY KEY) PARTITION BY HASH (c) PARTITIONS 2;
INSERT INTO t04p VALUES ('a'), ('b');
INSERT INTO t04q VALUES (1, 10), (2, 20), (3, 30);
INSERT INTO t04r VALUES (1, 'a'), (2, 'b');
INSERT INTO t04s VALUES (1, 10, 100), (1, 11, 101), (2, 20, 200);
INSERT INTO t04hp VALUES (1), (2), (3);
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-30';
SELECT o.c, i.c FROM t04p o LEFT OUTER JOIN t04q i ON (i.c >= 2) AND (SYS_DATE IS NULL) ORDER BY 1, 2;
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-31';
SELECT o.c, i.c FROM t04p o LEFT OUTER JOIN t04q i ON (i.c >= 2) AND (DRAND() < 0) ORDER BY 1, 2;
-- expected: exec
evaluate 'Case 4-32p';
PREPARE p04b FROM 'SELECT o.c, i.c FROM t04p o LEFT OUTER JOIN t04q i ON (i.c >= 2) AND (? = ''x'') ORDER BY 1, 2';
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-32';
EXECUTE p04b USING 'y';
-- expected: rows: 'a' | 2 / 'a' | 3 / 'b' | 2 / 'b' | 3
evaluate 'Case 4-33';
EXECUTE p04b USING 'x';
DEALLOCATE PREPARE p04b;
-- expected: rows: 1 | NULL | NULL / 2 | NULL | NULL
evaluate 'Case 4-34';
SELECT o.k, i.a, i.b FROM t04r o LEFT OUTER JOIN t04s i ON i.a IN (1, 2) AND o.c = 'zz' ORDER BY 1, 2, 3;
-- expected: rows: 1 | NULL | NULL / 2 | 1 | 10 / 2 | 1 | 11 / 2 | 2 | 20
evaluate 'Case 4-35';
SELECT o.k, i.a, i.b FROM t04r o LEFT OUTER JOIN t04s i ON i.a IN (1, 2) AND o.c > 'a' ORDER BY 1, 2, 3;
-- expected: rows: 'a' | NULL / 'b' | NULL
evaluate 'Case 4-36';
SELECT o.c, p.c FROM t04p o LEFT OUTER JOIN t04hp p ON (p.c >= 2) AND (o.c = 'zz') ORDER BY 1, 2;
-- expected: rows: 2
evaluate 'Case 4-37';
SELECT COUNT(*) AS cnt FROM t04p o LEFT OUTER JOIN t04q i ON (i.c >= 2) AND (o.c = 'zz') WHERE i.c IS NULL;
-- expected: affected: 2
evaluate 'Case 4-38';
UPDATE t04p o LEFT OUTER JOIN t04q i ON (i.c >= 2) AND (o.c = 'zz') SET o.c = o.c || 'x' WHERE i.c IS NULL;
-- expected: rows: 'ax' / 'bx'
evaluate 'Case 4-39';
SELECT c FROM t04p ORDER BY 1;
-- expected: affected: 2
evaluate 'Case 4-40';
DELETE o FROM t04p o LEFT OUTER JOIN t04q i ON (i.c >= 2) AND (o.c = 'zzx') WHERE i.c IS NULL;
-- expected: empty
evaluate 'Case 4-41';
SELECT c FROM t04p ORDER BY 1;
DROP TABLE t04p, t04q, t04r, t04s, t04hp;
DROP TABLE t04o, t04i, t04j;

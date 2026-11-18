/**
 *  This test case verifies CBRD-28029 #15: an empty string read from a multi-column index key and converted to a number must be 0 (as from the
 *  heap), not the number in the next key column.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t15, t15b, t15c;
CREATE TABLE t15 (c0 VARCHAR(42), c1 VARCHAR);
INSERT INTO t15 VALUES ('-1455239093', '');
CREATE INDEX t15_i ON t15 (c1, c0);
-- expected: rows: 1.000000000000000e+00 | 0.000000000000000e+00
evaluate 'Case 15-c1';
SELECT c1 + 1 AS p, CAST(c1 AS DOUBLE) AS d FROM t15 WHERE c1 = '' USING INDEX NONE;
-- expected: same: 15-c1
evaluate 'Case 15-1';
SELECT c1 + 1 AS p, CAST(c1 AS DOUBLE) AS d FROM t15 WHERE c1 = '';
-- expected: any
evaluate 'Case 15-c2';
SELECT CAST(c1 AS INT) AS i, CAST(c1 AS BIGINT) AS b, CAST(c1 AS SMALLINT) AS s, CAST(c1 AS FLOAT) AS f, CAST(c1 AS NUMERIC(10,2)) AS n FROM t15 WHERE c1 = '' USING INDEX NONE;
-- expected: same: 15-c2
evaluate 'Case 15-2';
SELECT CAST(c1 AS INT) AS i, CAST(c1 AS BIGINT) AS b, CAST(c1 AS SMALLINT) AS s, CAST(c1 AS FLOAT) AS f, CAST(c1 AS NUMERIC(10,2)) AS n FROM t15 WHERE c1 = '';
-- expected: any
evaluate 'Case 15-c3';
SELECT c1 * 2 AS m, ABS(c1) AS a, c1 - 1 AS s, c1 / 2 AS d FROM t15 WHERE c1 = '' USING INDEX NONE;
-- expected: same: 15-c3
evaluate 'Case 15-3';
SELECT c1 * 2 AS m, ABS(c1) AS a, c1 - 1 AS s, c1 / 2 AS d FROM t15 WHERE c1 = '';
-- expected: rows: 1
evaluate 'Case 15-c4';
SELECT COUNT(*) AS cnt FROM t15 WHERE c1 = '' AND c1 + 0 = 0 USING INDEX NONE;
-- expected: rows: 1
evaluate 'Case 15-4';
SELECT COUNT(*) AS cnt FROM t15 WHERE c1 = '' AND c1 + 0 = 0;
-- expected: rows: 1
evaluate 'Case 15-5';
SELECT COUNT(*) AS cnt FROM t15 WHERE c1 = '' AND CAST(c1 AS DOUBLE) = 0;
-- expected: rows: 0.000000000000000e+00
evaluate 'Case 15-6';
SELECT CAST(c1 AS DOUBLE) AS d FROM t15 WHERE c1 >= '' ORDER BY c1;
-- semi join / EXISTS: an outer key '' must not meet the inner row of another key
CREATE TABLE t15b (c0 VARCHAR(42), c1 VARCHAR);
INSERT INTO t15b VALUES ('', '-1639199055'), ('-1455239093', '');
CREATE INDEX t15b_a ON t15b (c1 ASC, c0 ASC);
CREATE INDEX t15b_d ON t15b (c1 DESC, c0);
-- expected: rows: 0
evaluate 'Case 15-10';
SELECT COUNT(*) AS cnt FROM t15b o WHERE o.c0 = SOME (SELECT i.c1 FROM t15b i WHERE CAST(i.c1 AS DOUBLE) < 0);
-- expected: rows: 0
evaluate 'Case 15-11';
SELECT COUNT(*) AS cnt FROM t15b o WHERE EXISTS (SELECT 1 FROM t15b i WHERE i.c1 = o.c0 AND CAST(i.c1 AS DOUBLE) < 0);
-- expected: rows: 0
evaluate 'Case 15-c10';
SELECT COUNT(*) AS cnt FROM t15b o WHERE o.c0 = SOME (SELECT i.c1 FROM t15b i WHERE CAST(i.c1 AS DOUBLE) < 0) USING INDEX NONE;
-- expected: rows: '' | 0.000000000000000e+00 / '-1639199055' | -1.639199055000000e+09
evaluate 'Case 15-12';
SELECT c1, CAST(c1 AS DOUBLE) AS d FROM t15b WHERE c1 IS NOT NULL ORDER BY c1;
-- the empty string is the last key column
CREATE TABLE t15c (k VARCHAR(10), c1 VARCHAR);
CREATE INDEX t15c_kc ON t15c (k, c1);
INSERT INTO t15c VALUES ('k', ''), ('l', '7');
-- expected: rows: 'k' | 0.000000000000000e+00 | 1.000000000000000e+00 / 'l' | 7.000000000000000e+00 | 8.000000000000000e+00
evaluate 'Case 15-13';
SELECT k, CAST(c1 AS DOUBLE) AS d, c1 + 1 AS p FROM t15c WHERE k >= 'k' ORDER BY k;
DROP TABLE t15, t15b, t15c;

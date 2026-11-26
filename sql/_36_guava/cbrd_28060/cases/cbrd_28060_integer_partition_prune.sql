/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A hash partition prune converts a constant into the type of the key and hashes it, while the comparison of a key and
 *  a constant of two types converts the key. The two agree only when the conversion of the key keeps every key apart,
 *  so the scan reads one partition for a SMALLINT key compared as an INT or a BIGINT, and every partition for an INT
 *  key compared as a FLOAT or a BIGINT key compared as a DOUBLE. Before the change, 33554432 as a FLOAT, which equals
 *  the INT keys 33554432 and 33554433, read the partition of 33554432 only. A constant that the type of the key does
 *  not hold has no partition of an expression on the key, so the scan reads every partition. Before the change, it
 *  failed with a data overflow error. A constant that the type holds reads the partition of the expression's value.
 *
 *  A prune case counts the rows of each constant or bound value in the partitioned table and in its twin without
 *  partitions, and the two counts must match. SHOW TRACE shows one PARTITION line for each partition that the scan of
 *  one value, traced after the counts, reads.
 *
 *  Coverage:
 *    Case 1:  SMALLINT - t_smallint_part prune per INT constant reads one partition and matches t_smallint
 *    Case 2:  SMALLINT - t_smallint_part prune per IN list of INT constants reads two partitions and matches t_smallint
 *    Case 3:  SMALLINT - t_smallint_part prune per BIGINT constant reads one partition and matches t_smallint
 *    Case 4:  SMALLINT - t_smallint_hash_expression prune per INT constant past the SMALLINT range reads every
 *             partition and matches t_smallint
 *    Case 5:  SMALLINT - t_smallint_range_expression prune per INT constant past the SMALLINT range reads every
 *             partition and matches t_smallint
 *    Case 6:  INT - t_int_part prune per BIGINT constant reads one partition and matches t_int
 *    Case 7:  INT - t_int_part prune per FLOAT constant reads every partition and matches t_int
 *    Case 8:  BIGINT - t_bigint_part prune per DOUBLE constant reads every partition and matches t_bigint
 *    Case 9:  SMALLINT - t_smallint_part prune per INT host variable reads one partition and matches t_smallint
 *    Case 10: SMALLINT - t_smallint_range_expression prune per INT constant reads one partition and matches
 *             t_smallint
 */

set trace on;

DROP TABLE IF EXISTS t_smallint, t_smallint_part, t_smallint_hash_expression, t_smallint_range_expression, t_int,
  t_int_part, t_bigint, t_bigint_part;

-- t_smallint, t_smallint_part, t_smallint_hash_expression and t_smallint_range_expression hold the same rows
-- ca | cb
-- ---+-------
--  1 | 1
--  2 | 2
--  3 | 3
--  4 | 32767
CREATE TABLE t_smallint (ca INT, cb SMALLINT);
INSERT INTO t_smallint VALUES (1, 1), (2, 2), (3, 3), (4, 32767);

CREATE TABLE t_smallint_part (ca INT, cb SMALLINT) PARTITION BY HASH (cb) PARTITIONS 7;
INSERT INTO t_smallint_part SELECT ca, cb FROM t_smallint;

CREATE TABLE t_smallint_hash_expression (ca INT, cb SMALLINT) PARTITION BY HASH (cb + 0) PARTITIONS 7;
INSERT INTO t_smallint_hash_expression SELECT ca, cb FROM t_smallint;

CREATE TABLE t_smallint_range_expression (ca INT, cb SMALLINT) PARTITION BY RANGE (cb + 0)
  (PARTITION p0 VALUES LESS THAN (2), PARTITION p1 VALUES LESS THAN MAXVALUE);
INSERT INTO t_smallint_range_expression SELECT ca, cb FROM t_smallint;

-- t_int and t_int_part hold the same rows: 33554432 = 2^25, and a FLOAT does not hold 33554433
-- ca | cb
-- ---+----------
--  1 | 1
--  2 | 33554432
--  3 | 33554433
CREATE TABLE t_int (ca INT, cb INT);
INSERT INTO t_int VALUES (1, 1), (2, 33554432), (3, 33554433);

CREATE TABLE t_int_part (ca INT, cb INT) PARTITION BY HASH (cb) PARTITIONS 7;
INSERT INTO t_int_part SELECT ca, cb FROM t_int;

-- t_bigint and t_bigint_part hold the same rows: 9007199254740992 = 2^53, and a DOUBLE does not hold
-- 9007199254740993
-- ca | cb
-- ---+-----------------
--  1 | 1
--  2 | 9007199254740992
--  3 | 9007199254740993
CREATE TABLE t_bigint (ca INT, cb BIGINT);
INSERT INTO t_bigint VALUES (1, 1), (2, 9007199254740992), (3, 9007199254740993);

CREATE TABLE t_bigint_part (ca INT, cb BIGINT) PARTITION BY HASH (cb) PARTITIONS 7;
INSERT INTO t_bigint_part SELECT ca, cb FROM t_bigint;

UPDATE STATISTICS ON t_smallint, t_smallint_part, t_smallint_hash_expression, t_smallint_range_expression, t_int,
  t_int_part, t_bigint, t_bigint_part WITH FULLSCAN;

evaluate 'Case 1: SMALLINT - t_smallint_part prune per INT constant reads one partition and matches t_smallint';
SELECT 1 AS ca, '[1]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb = 1) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_part WHERE cb = 1) AS cnt_part;

SELECT 2 AS ca, '[32767]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb = 32767) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_part WHERE cb = 32767) AS cnt_part;

SELECT 3 AS ca, '[4]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb = 4) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_part WHERE cb = 4) AS cnt_part;

SELECT 4 AS ca, '[70000]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb = 70000) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_part WHERE cb = 70000) AS cnt_part;

SELECT COUNT (*) FROM t_smallint_part WHERE cb = 1;
show trace;

evaluate 'Case 2: SMALLINT - t_smallint_part prune per IN list of INT constants reads two partitions and matches t_smallint';
SELECT 1 AS ca, '[1, 3]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb IN (1, 3)) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_part WHERE cb IN (1, 3)) AS cnt_part;

SELECT 2 AS ca, '[1, 70000]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb IN (1, 70000)) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_part WHERE cb IN (1, 70000)) AS cnt_part;

SELECT COUNT (*) FROM t_smallint_part WHERE cb IN (1, 3);
show trace;

evaluate 'Case 3: SMALLINT - t_smallint_part prune per BIGINT constant reads one partition and matches t_smallint';
SELECT 1 AS ca, '[1]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb = CAST (1 AS BIGINT)) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_part WHERE cb = CAST (1 AS BIGINT)) AS cnt_part;

SELECT 2 AS ca, '[70000]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb = CAST (70000 AS BIGINT)) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_part WHERE cb = CAST (70000 AS BIGINT)) AS cnt_part;

SELECT COUNT (*) FROM t_smallint_part WHERE cb = CAST (1 AS BIGINT);
show trace;

evaluate 'Case 4: SMALLINT - t_smallint_hash_expression prune per INT constant past the SMALLINT range reads every partition and matches t_smallint';
SELECT 1 AS ca, '[70000]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb = 70000) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_hash_expression WHERE cb = 70000) AS cnt_part;

SELECT 2 AS ca, '[1, 70000]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb IN (1, 70000)) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_hash_expression WHERE cb IN (1, 70000)) AS cnt_part;

SELECT 3 AS ca, '[ANY 1, 70000]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb = ANY {1, 70000}) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_hash_expression WHERE cb = ANY {1, 70000}) AS cnt_part;

SELECT COUNT (*) FROM t_smallint_hash_expression WHERE cb = 70000;
show trace;

evaluate 'Case 5: SMALLINT - t_smallint_range_expression prune per INT constant past the SMALLINT range reads every partition and matches t_smallint';
SELECT 1 AS ca, '[70000]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb = 70000) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_range_expression WHERE cb = 70000) AS cnt_part;

SELECT 2 AS ca, '[1, 70000]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb IN (1, 70000)) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_range_expression WHERE cb IN (1, 70000)) AS cnt_part;

SELECT 3 AS ca, '[ANY 1, 70000]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb = ANY {1, 70000}) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_range_expression WHERE cb = ANY {1, 70000}) AS cnt_part;

SELECT COUNT (*) FROM t_smallint_range_expression WHERE cb = 70000;
show trace;

evaluate 'Case 6: INT - t_int_part prune per BIGINT constant reads one partition and matches t_int';
SELECT 1 AS ca, '[1]' AS cb,
  (SELECT COUNT (*) FROM t_int WHERE cb = CAST (1 AS BIGINT)) AS cnt_base,
  (SELECT COUNT (*) FROM t_int_part WHERE cb = CAST (1 AS BIGINT)) AS cnt_part;

SELECT 2 AS ca, '[33554433]' AS cb,
  (SELECT COUNT (*) FROM t_int WHERE cb = CAST (33554433 AS BIGINT)) AS cnt_base,
  (SELECT COUNT (*) FROM t_int_part WHERE cb = CAST (33554433 AS BIGINT)) AS cnt_part;

SELECT COUNT (*) FROM t_int_part WHERE cb = CAST (1 AS BIGINT);
show trace;

evaluate 'Case 7: INT - t_int_part prune per FLOAT constant reads every partition and matches t_int';
SELECT 1 AS ca, '[1]' AS cb,
  (SELECT COUNT (*) FROM t_int WHERE cb = CAST (1 AS FLOAT)) AS cnt_base,
  (SELECT COUNT (*) FROM t_int_part WHERE cb = CAST (1 AS FLOAT)) AS cnt_part;

SELECT 2 AS ca, '[33554432]' AS cb,
  (SELECT COUNT (*) FROM t_int WHERE cb = CAST (33554432 AS FLOAT)) AS cnt_base,
  (SELECT COUNT (*) FROM t_int_part WHERE cb = CAST (33554432 AS FLOAT)) AS cnt_part;

SELECT COUNT (*) FROM t_int_part WHERE cb = CAST (33554432 AS FLOAT);
show trace;

evaluate 'Case 8: BIGINT - t_bigint_part prune per DOUBLE constant reads every partition and matches t_bigint';
SELECT 1 AS ca, '[1]' AS cb,
  (SELECT COUNT (*) FROM t_bigint WHERE cb = CAST (1 AS DOUBLE)) AS cnt_base,
  (SELECT COUNT (*) FROM t_bigint_part WHERE cb = CAST (1 AS DOUBLE)) AS cnt_part;

SELECT 2 AS ca, '[9007199254740992]' AS cb,
  (SELECT COUNT (*) FROM t_bigint WHERE cb = CAST (9007199254740992 AS DOUBLE)) AS cnt_base,
  (SELECT COUNT (*) FROM t_bigint_part WHERE cb = CAST (9007199254740992 AS DOUBLE)) AS cnt_part;

SELECT COUNT (*) FROM t_bigint_part WHERE cb = CAST (9007199254740992 AS DOUBLE);
show trace;

evaluate 'Case 9: SMALLINT - t_smallint_part prune per INT host variable reads one partition and matches t_smallint';
prepare st_count from 'SELECT (SELECT COUNT (*) FROM t_smallint WHERE ? = cb) AS cnt_base, (SELECT COUNT (*) FROM t_smallint_part WHERE ? = cb) AS cnt_part';
execute st_count using 1, 1;
execute st_count using 32767, 32767;
deallocate prepare st_count;

prepare st_prune from 'SELECT COUNT (*) FROM t_smallint_part WHERE ? = cb';
execute st_prune using 1;
show trace;
deallocate prepare st_prune;

evaluate 'Case 10: SMALLINT - t_smallint_range_expression prune per INT constant reads one partition and matches t_smallint';
SELECT 1 AS ca, '[1]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb = 1) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_range_expression WHERE cb = 1) AS cnt_part;

SELECT 2 AS ca, '[3]' AS cb,
  (SELECT COUNT (*) FROM t_smallint WHERE cb = 3) AS cnt_base,
  (SELECT COUNT (*) FROM t_smallint_range_expression WHERE cb = 3) AS cnt_part;

SELECT COUNT (*) FROM t_smallint_range_expression WHERE cb = 3;
show trace;

-- cleanup
DROP TABLE IF EXISTS t_smallint, t_smallint_part, t_smallint_hash_expression, t_smallint_range_expression, t_int,
  t_int_part, t_bigint, t_bigint_part;

set trace off;

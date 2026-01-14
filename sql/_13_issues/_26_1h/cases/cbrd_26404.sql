/**
 * This test case verifies CBRD-26404: 
 * IS NOT NULL incorrectly removed in OUTER JOINs for NOT NULL columns from the inner table.
 */

-- Test Setup
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;

CREATE TABLE t1(c1 INT, c2 INT NOT NULL);
INSERT INTO t1 VALUES(1, 1), (2, 2), (3, 3);

CREATE TABLE t2(c1 INT, c2 INT NOT NULL);
INSERT INTO t2 VALUES(2, 2), (4, 4);

evaluate 'Case 1: LEFT OUTER JOIN - IS NOT NULL on inner table (t2.c2)';
SELECT /*+ recompile */ a.*, b.*
FROM t1 a
LEFT OUTER JOIN t2 b ON a.c1 = b.c1
WHERE b.c2 IS NOT NULL;

evaluate 'Case 2: RIGHT OUTER JOIN - IS NOT NULL on inner table (t1.c2)';
SELECT /*+ recompile */ a.*, b.*
FROM t1 a
RIGHT OUTER JOIN t2 b ON a.c1 = b.c1
WHERE a.c2 IS NOT NULL;

evaluate 'Case 3: Multiple IS NOT NULL';
SELECT /*+ recompile */ a.*, b.*
FROM t1 a
LEFT OUTER JOIN t2 b ON a.c1 = b.c1
WHERE a.c2 IS NOT NULL
  AND b.c2 IS NOT NULL;

evaluate 'Case 4: IS NOT NULL with additional condition';
SELECT /*+ recompile */ a.*, b.*
FROM t1 a
LEFT OUTER JOIN t2 b ON a.c1 = b.c1
WHERE b.c2 IS NOT NULL
  AND b.c1 > 1
ORDER BY a.c1;

DROP TABLE IF EXISTS t3;
CREATE TABLE t3 (c1 INT, c2 INT NOT NULL);
INSERT INTO t3 VALUES (1,1), (2,2), (5,5);

evaluate 'Case 5: Multiple OUTER JOINs - IS NOT NULL on inner tables';
SELECT /*+ recompile */ a.*, b.*, c.*
FROM t1 a
LEFT OUTER JOIN t2 b ON a.c1 = b.c1
LEFT OUTER JOIN t3 c ON a.c1 = c.c1
WHERE b.c2 IS NOT NULL
  AND c.c2 IS NOT NULL;

-- Test Cleanup
DROP TABLE t1;
DROP TABLE t2;
DROP TABLE t3;
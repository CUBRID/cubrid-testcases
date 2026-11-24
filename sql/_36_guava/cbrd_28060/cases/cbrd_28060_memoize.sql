/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A nested loop join memoizes its inner scan by the key of the outer row. A memoized result keyed by one value must
 *  not answer for another value that compares equal and hashes alike but converts to another string: the DOUBLE -0
 *  and 0, the NUMERIC 1.0 and 1.00, and the utf8_en_ci strings a and A. Each join runs with memoize_memory_limit=64M
 *  and then with 0, which turns memoize off, and both must return the same sums.
 *
 *  Coverage:
 *    Case 1:  DOUBLE - a nested loop join memoized by -0 and 0 returns the rows of the join without memoize; result =
 *             50 100 100
 *    Case 2:  NUMERIC - a nested loop join memoized by 1.0 and 1.00 returns the rows of the join without
 *             memoize; result = 50 100 100
 *    Case 3:  VARCHAR utf8_en_ci - a nested loop join memoized by a and A returns the rows of the join without
 *             memoize; result = 50 100 100
 */

DROP TABLE IF EXISTS t_double, t_varchar;
CREATE TABLE t_double (ca INT, cb DOUBLE);
CREATE TABLE t_varchar (ca VARCHAR (10), cb INT);

-- t_double: ca 1 to 50 hold 0 and ca 51 to 100 hold -0 as DOUBLE
-- ca  | cb
-- ----+----
-- 1   | 0
-- 50  | 0
-- 51  | -0
-- 100 | -0
INSERT INTO t_double
SELECT ROWNUM, CASE WHEN ROWNUM <= 50 THEN CAST (0 AS DOUBLE) ELSE -CAST (0 AS DOUBLE) END
FROM db_class a, db_class b
LIMIT 100;

-- t_varchar
-- ca   | cb
-- -----+----
-- '0'  | 1
-- '-0' | 2
INSERT INTO t_varchar VALUES ('0', 1), ('-0', 2);

UPDATE STATISTICS ON t_double, t_varchar WITH FULLSCAN;

evaluate 'Case 1: DOUBLE - a nested loop join memoized by -0 and 0 returns the rows of the join without memoize; result = 50 100 100';
-- t_double.cb || '' is the string 0 or -0, which joins t_varchar.ca
-- the first query memoizes the inner scan of t_varchar, the second runs with memoize turned off
set system parameters 'memoize_memory_limit=64M';

SELECT /*+ RECOMPILE PARALLEL(0) ORDERED USE_NL(t_varchar) */
  SUM (CASE WHEN t_double.ca <= 50 THEN t_varchar.cb ELSE 0 END),
  SUM (CASE WHEN t_double.ca > 50 THEN t_varchar.cb ELSE 0 END),
  COUNT (*)
FROM t_double INNER JOIN t_varchar ON t_varchar.ca = t_double.cb || '';
set system parameters 'memoize_memory_limit=0';

SELECT /*+ RECOMPILE PARALLEL(0) ORDERED USE_NL(t_varchar) */
  SUM (CASE WHEN t_double.ca <= 50 THEN t_varchar.cb ELSE 0 END),
  SUM (CASE WHEN t_double.ca > 50 THEN t_varchar.cb ELSE 0 END),
  COUNT (*)
FROM t_double INNER JOIN t_varchar ON t_varchar.ca = t_double.cb || '';
set system parameters 'memoize_memory_limit=default';

DROP TABLE IF EXISTS t_int, t_varchar;
CREATE TABLE t_int (ca INT);
CREATE TABLE t_varchar (ca VARCHAR (10), cb INT);

-- t_int, ca = 1 to 100
INSERT INTO t_int SELECT ROWNUM FROM db_class a, db_class b LIMIT 100;

-- t_varchar
-- ca     | cb
-- -------+----
-- '1.0'  | 1
-- '1.00' | 2
INSERT INTO t_varchar VALUES ('1.0', 1), ('1.00', 2);

UPDATE STATISTICS ON t_int, t_varchar WITH FULLSCAN;

evaluate 'Case 2: NUMERIC - a nested loop join memoized by 1.0 and 1.00 returns the rows of the join without memoize; result = 50 100 100';
-- d gives ca 1 to 50 the NUMERIC(5,1) 1.0 and ca 51 to 100 the NUMERIC(5,2) 1.00, and d.cb || '' is the string 1.0 or
-- 1.00, which joins t_varchar.ca
-- the first query memoizes the inner scan of t_varchar, the second runs with memoize turned off
set system parameters 'memoize_memory_limit=64M';

SELECT /*+ RECOMPILE PARALLEL(0) ORDERED USE_NL(t_varchar) */
  SUM (CASE WHEN d.ca <= 50 THEN t_varchar.cb ELSE 0 END),
  SUM (CASE WHEN d.ca > 50 THEN t_varchar.cb ELSE 0 END),
  COUNT (*)
FROM
  (SELECT ca, CAST (1 AS NUMERIC (5, 1)) cb FROM t_int WHERE ca <= 50
   UNION ALL
   SELECT ca, CAST (1 AS NUMERIC (5, 2)) FROM t_int WHERE ca > 50) d
  INNER JOIN t_varchar ON t_varchar.ca = d.cb || '';
set system parameters 'memoize_memory_limit=0';

SELECT /*+ RECOMPILE PARALLEL(0) ORDERED USE_NL(t_varchar) */
  SUM (CASE WHEN d.ca <= 50 THEN t_varchar.cb ELSE 0 END),
  SUM (CASE WHEN d.ca > 50 THEN t_varchar.cb ELSE 0 END),
  COUNT (*)
FROM
  (SELECT ca, CAST (1 AS NUMERIC (5, 1)) cb FROM t_int WHERE ca <= 50
   UNION ALL
   SELECT ca, CAST (1 AS NUMERIC (5, 2)) FROM t_int WHERE ca > 50) d
  INNER JOIN t_varchar ON t_varchar.ca = d.cb || '';
set system parameters 'memoize_memory_limit=default';

DROP TABLE IF EXISTS t_varchar_en_ci, t_varchar;
CREATE TABLE t_varchar_en_ci (ca INT, cb VARCHAR (10) COLLATE utf8_en_ci);
CREATE TABLE t_varchar (ca VARCHAR (10), cb INT);

-- t_varchar_en_ci: ca 1 to 50 hold a and ca 51 to 100 hold A
-- ca  | cb
-- ----+-----
-- 1   | 'a'
-- 50  | 'a'
-- 51  | 'A'
-- 100 | 'A'
INSERT INTO t_varchar_en_ci
SELECT ROWNUM, CASE WHEN ROWNUM <= 50 THEN 'a' ELSE 'A' END
FROM db_class a, db_class b
LIMIT 100;

-- t_varchar
-- ca   | cb
-- -----+----
-- '61' | 1
-- '41' | 2
INSERT INTO t_varchar VALUES ('61', 1), ('41', 2);

UPDATE STATISTICS ON t_varchar_en_ci, t_varchar WITH FULLSCAN;

evaluate 'Case 3: VARCHAR utf8_en_ci - a nested loop join memoized by a and A returns the rows of the join without memoize; result = 50 100 100';
-- HEX (t_varchar_en_ci.cb) is the string 61 or 41, which joins t_varchar.ca
-- the first query memoizes the inner scan of t_varchar, the second runs with memoize turned off
set system parameters 'memoize_memory_limit=64M';

SELECT /*+ RECOMPILE PARALLEL(0) ORDERED USE_NL(t_varchar) */
  SUM (CASE WHEN t_varchar_en_ci.ca <= 50 THEN t_varchar.cb ELSE 0 END),
  SUM (CASE WHEN t_varchar_en_ci.ca > 50 THEN t_varchar.cb ELSE 0 END),
  COUNT (*)
FROM t_varchar_en_ci INNER JOIN t_varchar ON t_varchar.ca = HEX (t_varchar_en_ci.cb);
set system parameters 'memoize_memory_limit=0';

SELECT /*+ RECOMPILE PARALLEL(0) ORDERED USE_NL(t_varchar) */
  SUM (CASE WHEN t_varchar_en_ci.ca <= 50 THEN t_varchar.cb ELSE 0 END),
  SUM (CASE WHEN t_varchar_en_ci.ca > 50 THEN t_varchar.cb ELSE 0 END),
  COUNT (*)
FROM t_varchar_en_ci INNER JOIN t_varchar ON t_varchar.ca = HEX (t_varchar_en_ci.cb);
set system parameters 'memoize_memory_limit=default';

-- cleanup
DROP TABLE IF EXISTS t_double, t_varchar;
DROP TABLE IF EXISTS t_int, t_varchar_en_ci;

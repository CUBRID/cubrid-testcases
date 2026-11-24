/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A nested loop join memoizes its inner scan by the key of the outer row. A memoized result keyed by the DOUBLE -0
 *  must not answer for 0, which compares equal and hashes alike but converts to another string. The join runs with
 *  memoize_memory_limit=64M and then with 0, which turns memoize off, and both must return the same sums.
 *
 *  Coverage:
 *    Case 1:  DOUBLE - a nested loop join memoized by -0 and 0 returns the rows of the join without memoize; result =
 *             50 100 100
 */

evaluate 'Case 1: DOUBLE - a nested loop join memoized by -0 and 0 returns the rows of the join without memoize; result = 50 100 100';
-- t_double.cb || '' is the string 0 or -0, which joins t_varchar.ca
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

-- cleanup
DROP TABLE IF EXISTS t_double, t_varchar;

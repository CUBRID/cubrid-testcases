/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A nested loop join memoizes its inner scan by the key of the outer row. A memoized result keyed by the DOUBLE -0
 *  must not answer for 0, which compares equal and hashes alike but converts to another string. The join runs with
 *  memoize_memory_limit=64M and then with 0, which turns memoize off, and both must return the same sums.
 *
 *  Coverage:
 *    Case 1:  DOUBLE - a nested loop join memoized by -0 and 0 returns the rows of the join without memoize; result =
 *             50 100 100
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

evaluate 'Case 1: DOUBLE - a nested loop join memoized by -0 and 0 returns the rows of the join without memoize; result = 50 100 100';
-- ta.ca 1 to 50 hold 0 and 51 to 100 hold -0 as DOUBLE; ta.cb || '' is the string 0 or -0, which joins tb.ca
-- ca | cb
-- ---+----
-- 0  | 1
-- -0 | 2
DROP TABLE IF EXISTS ta, tb;
CREATE TABLE ta (ca INT, cb DOUBLE);
CREATE TABLE tb (ca VARCHAR (10), cb INT);
INSERT INTO ta SELECT ROWNUM, CASE WHEN ROWNUM <= 50 THEN CAST (0 AS DOUBLE) ELSE -CAST (0 AS DOUBLE) END FROM db_class a, db_class b LIMIT 100;
INSERT INTO tb VALUES
  ('0', 1),
  ('-0', 2);
UPDATE STATISTICS ON ta, tb WITH FULLSCAN;
-- the first query memoizes the inner scan of tb, the second runs with memoize turned off
set system parameters 'memoize_memory_limit=64M';
SELECT /*+ RECOMPILE PARALLEL(0) ORDERED USE_NL(tb) */
  SUM (CASE WHEN ta.ca <= 50 THEN tb.cb ELSE 0 END),
  SUM (CASE WHEN ta.ca > 50 THEN tb.cb ELSE 0 END),
  COUNT (*)
FROM ta INNER JOIN tb ON tb.ca = ta.cb || '';
set system parameters 'memoize_memory_limit=0';
SELECT /*+ RECOMPILE PARALLEL(0) ORDERED USE_NL(tb) */
  SUM (CASE WHEN ta.ca <= 50 THEN tb.cb ELSE 0 END),
  SUM (CASE WHEN ta.ca > 50 THEN tb.cb ELSE 0 END),
  COUNT (*)
FROM ta INNER JOIN tb ON tb.ca = ta.cb || '';
set system parameters 'memoize_memory_limit=default';

-- cleanup

DROP TABLE IF EXISTS ta, tb;

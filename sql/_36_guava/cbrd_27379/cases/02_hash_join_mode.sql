/**
 *  This test case verifies CBRD-27379: SEMI JOIN and ANTI JOIN run as a hash join.
 *  AC-1: hash join execution modes, outer joins, empty partitions (TC 1 to TC 3).
 *
 *  The hash join runs in one of four modes:
 *    SINGLE          ta, tb with NO_PARALLEL_HASH_JOIN: no SPLIT line, no parallel workers on HASHJOIN or PROBE
 *    PARTITION       tc, td with NO_PARALLEL_HASH_JOIN: SPLIT line, no parallel workers on HASHJOIN or PROBE
 *    PARALLEL_PROBE  ta, tb with PARALLEL(4): no SPLIT line, parallel workers under PROBE
 *    PARALLEL        tc, td with PARALLEL(4): SPLIT line, parallel workers on HASHJOIN
 *  The file lowers max_hash_list_scan_size to 2M for TC 1 to TC 3-2 to keep the tables small. ta, tb (30001
 *  rows each) stay below its split threshold even as the build input, and tc, td (80001 rows each) exceed it.
 *  The join key is CHAR(200) so that the input lists of ta, tb fill more than 4 sectors of 64 pages with few rows, and
 *  each of the 4 workers of PARALLEL(4) gets a sector to scan.
 *  Run this file with test_mode=yes, as CTP does, for the parallel modes:
 *  test_mode lowers parallel_scan_page_threshold to 32, and parallel_hash_join_page_threshold
 *  and parallel_sort_page_threshold to 0, when they keep their default values.
 *
 *  Coverage:
 *    TC 1: SEMI JOIN / ANTI JOIN in the four modes, also with an ON clause term on the outer table or on both tables,
 *          and with an ON clause term that only a middle one of the inner rows with the same key meets
 *    TC 2: LEFT / RIGHT OUTER JOIN in the four modes
 *    TC 3: partitions without inner rows, and an outer input larger or smaller than the inner
 *          (SEMI JOIN / ANTI JOIN build the inner input even when the outer is smaller, an INNER JOIN builds the outer)
 *
 *  Sub-cases:
 *    Sub-case  Query                   Case
 *    TC 1-1    ta SEMI JOIN tb         SINGLE, PARALLEL_PROBE
 *    TC 1-2    ta ANTI JOIN tb         SINGLE, PARALLEL_PROBE
 *    TC 1-3    tc SEMI JOIN td         PARTITION, PARALLEL
 *    TC 1-4    tc ANTI JOIN td         PARTITION, PARALLEL
 *    TC 1-5    ta SEMI JOIN tb         SINGLE, PARALLEL_PROBE, ON term on the outer table
 *    TC 1-6    ta ANTI JOIN tb         SINGLE, PARALLEL_PROBE, ON term on the outer table
 *    TC 1-7    tc SEMI JOIN td         PARTITION, PARALLEL, ON term on the outer table
 *    TC 1-8    tc ANTI JOIN td         PARTITION, PARALLEL, ON term on the outer table
 *    TC 1-9    ta SEMI JOIN tb         SINGLE, PARALLEL_PROBE, ON term on both tables
 *    TC 1-10   ta ANTI JOIN tb         SINGLE, PARALLEL_PROBE, ON term on both tables
 *    TC 1-11   tc SEMI JOIN td         PARTITION, PARALLEL, ON term on both tables
 *    TC 1-12   tc ANTI JOIN td         PARTITION, PARALLEL, ON term on both tables
 *    TC 1-13   ta SEMI JOIN tb         SINGLE, PARALLEL_PROBE, ON term met by a middle row of a key only
 *    TC 1-14   ta ANTI JOIN tb         SINGLE, PARALLEL_PROBE, ON term met by a middle row of a key only
 *    TC 1-15   tc SEMI JOIN td         PARTITION, PARALLEL, ON term met by a middle row of a key only
 *    TC 1-16   tc ANTI JOIN td         PARTITION, PARALLEL, ON term met by a middle row of a key only
 *    TC 2-1    ta LEFT OUTER JOIN tb   SINGLE, PARALLEL_PROBE
 *    TC 2-2    ta RIGHT OUTER JOIN tb  SINGLE, PARALLEL_PROBE
 *    TC 2-3    tc LEFT OUTER JOIN td   PARTITION, PARALLEL
 *    TC 2-4    tc RIGHT OUTER JOIN td  PARTITION, PARALLEL
 *    TC 3-1    tc SEMI JOIN te         PARTITION, PARALLEL, partitions without inner rows
 *    TC 3-2    tc ANTI JOIN te         PARTITION, PARALLEL, partitions without inner rows
 *    TC 3-3    ta SEMI JOIN tb         outer input larger than the inner
 *    TC 3-4    ta ANTI JOIN tb         outer input larger than the inner
 *    TC 3-5    ta SEMI JOIN tb         outer input smaller than the inner, INNER JOIN of the same tables first
 *    TC 3-6    ta ANTI JOIN tb         outer input smaller than the inner
 *
 *  TC 1-1 to TC 1-12 compare the two modes on the same tables by EXCEPT ALL in both directions. Both counts
 *  must be 0. TC 1-13 to TC 1-16 check the counts, which a probe that stops at the first row of a key changes.
 *  CTP masks the numbers in a SHOW TRACE output, so time, fetch and row values are not compared.
 *  The trace asserts the presence of the SPLIT line, and of the parallel workers line on HASHJOIN or under PROBE.
 *  The traced queries add NO_PARALLEL_SUBQUERY and NO_PARALLEL_SCAN: whether a subquery or a scan gets parallel
 *  workers can differ from run to run, and the trace would show it in lines this file does not assert.
 */

-- =====================================================================================================================
-- Setup for TC 1 to TC 3-2 (hash join modes, outer joins, empty partitions)
-- =====================================================================================================================
DROP TABLE IF EXISTS ta, tb, tc, td, te;

-- With max_hash_list_scan_size=2M, a build input of more than 32263 rows (2 MB x 0.8 / 52 bytes per entry) splits:
-- ta, tb (30001 rows each) stay in one context, and tc, td, te (80001 rows each) split into 3 partitions.
-- ta, tb hold 30001 rows of 215 bytes or more (tb also has cb) in 457 heap pages or more, 7 sectors of 64 pages:
-- the 4 workers of PARALLEL(4) need 4.
SET SYSTEM PARAMETERS 'max_hash_list_scan_size=2M';

-- ta: 30000 rows of LPAD (ROWNUM, 200, '0'), and one NULL row
--   ROWNUM 1       -> '0000...0001'    199 '0' + '1'
--   ROWNUM 2       -> '0000...0002'    199 '0' + '2'
--   ...
--   ROWNUM 30000   -> '0000...30000'   195 '0' + '30000'
--   NULL
--   Stored: 30001 rows, keys 1 .. 30000 with 1 row per key, and 1 NULL
CREATE TABLE ta (ca CHAR(200));
INSERT INTO ta
  WITH RECURSIVE cte (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 400
  )
  SELECT LPAD (ROWNUM, 200, '0')
  FROM cte x, cte y
  WHERE ROWNUM <= 30000;
INSERT INTO ta VALUES (NULL);

-- tb: 30000 rows of LPAD (MOD (ROWNUM - 1, 6000) * 4 + 4, 200, '0'), and one NULL row
--   ROWNUM 1       -> '0000...0004'    199 '0' + '4'
--   ROWNUM 2       -> '0000...0008'    199 '0' + '8'
--   ...
--   ROWNUM 6000    -> '0000...24000'   195 '0' + '24000'
--   ROWNUM 6001    -> '0000...0004'    199 '0' + '4'       the same keys repeat, 5 rows per key
--   ...
--   ROWNUM 30000   -> '0000...24000'   195 '0' + '24000'
--   NULL
--   Stored: 30001 rows, 6000 keys 4 .. 24000 (multiples of 4) with 5 rows per key, and 1 NULL
--   cb is ROWNUM: the 5 rows of key 4 * k have cb k, k + 6000, ..., k + 24000,
--   and only the 3rd, k + 12000, lies between k + 6000 and k + 18000
CREATE TABLE tb (ca CHAR(200), cb INT);
INSERT INTO tb
  WITH RECURSIVE cte (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 400
  )
  SELECT LPAD (MOD (ROWNUM - 1, 6000) * 4 + 4, 200, '0'), ROWNUM
  FROM cte x, cte y
  WHERE ROWNUM <= 30000;
INSERT INTO tb VALUES (NULL, NULL);

-- tc: 80000 rows of LPAD (ROWNUM, 200, '0'), and one NULL row
--   ROWNUM 1       -> '0000...0001'    199 '0' + '1'
--   ROWNUM 2       -> '0000...0002'    199 '0' + '2'
--   ...
--   ROWNUM 80000   -> '0000...80000'   195 '0' + '80000'
--   NULL
--   Stored: 80001 rows, keys 1 .. 80000 with 1 row per key, and 1 NULL
CREATE TABLE tc (ca CHAR(200));
INSERT INTO tc
  WITH RECURSIVE cte (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 600
  )
  SELECT LPAD (ROWNUM, 200, '0')
  FROM cte x, cte y
  WHERE ROWNUM <= 80000;
INSERT INTO tc VALUES (NULL);

-- td: 80000 rows of LPAD (MOD (ROWNUM - 1, 20000) * 4 + 4, 200, '0'), and one NULL row
--   ROWNUM 1       -> '0000...0004'    199 '0' + '4'
--   ROWNUM 2       -> '0000...0008'    199 '0' + '8'
--   ...
--   ROWNUM 20000   -> '0000...80000'   195 '0' + '80000'
--   ROWNUM 20001   -> '0000...0004'    199 '0' + '4'       the same keys repeat, 4 rows per key
--   ...
--   ROWNUM 80000   -> '0000...80000'   195 '0' + '80000'
--   NULL
--   Stored: 80001 rows, 20000 keys 4 .. 80000 (multiples of 4) with 4 rows per key, and 1 NULL
--   cb is ROWNUM: the 4 rows of key 4 * k have cb k, k + 20000, k + 40000, k + 60000,
--   and only the 2nd, k + 20000, lies between k and k + 40000
CREATE TABLE td (ca CHAR(200), cb INT);
INSERT INTO td
  WITH RECURSIVE cte (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 600
  )
  SELECT LPAD (MOD (ROWNUM - 1, 20000) * 4 + 4, 200, '0'), ROWNUM
  FROM cte x, cte y
  WHERE ROWNUM <= 80000;
INSERT INTO td VALUES (NULL, NULL);

-- te: 80000 rows of LPAD (2, 200, '0'), and one NULL row
--   ROWNUM 1       -> '0000...0002'    199 '0' + '2'
--   ...
--   ROWNUM 80000   -> '0000...0002'    199 '0' + '2'
--   NULL
--   Stored: 80001 rows, key 2 in 80000 rows, and 1 NULL
CREATE TABLE te (ca CHAR(200));
INSERT INTO te
  WITH RECURSIVE cte (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 600
  )
  SELECT LPAD (2, 200, '0')
  FROM cte x, cte y
  WHERE ROWNUM <= 80000;
INSERT INTO te VALUES (NULL);

UPDATE STATISTICS ON ta, tb, tc, td, te WITH FULLSCAN;

-- Trace stays on until the end of this file. Each SHOW TRACE prints the trace of the query right before it.
SET TRACE ON;

-- =====================================================================================================================
-- TC 1: SEMI JOIN / ANTI JOIN in four hash join modes
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-1: ta SEMI JOIN tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-1: ta SEMI JOIN tb';

-- TC 1-1-1: SINGLE mode, result and trace
evaluate 'TC 1-1-1: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC 1-1-2: PARALLEL_PROBE mode, result and trace
evaluate 'TC 1-1-2: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC 1-1-3: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'TC 1-1-3: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS single_minus_parallel_probe
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca
) r;

-- TC 1-1-4: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'TC 1-1-4: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_probe_minus_single
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca
) r;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-2: ta ANTI JOIN tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-2: ta ANTI JOIN tb';

-- TC 1-2-1: SINGLE mode, result and trace
evaluate 'TC 1-2-1: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC 1-2-2: PARALLEL_PROBE mode, result and trace
evaluate 'TC 1-2-2: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC 1-2-3: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'TC 1-2-3: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS single_minus_parallel_probe
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca
) r;

-- TC 1-2-4: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'TC 1-2-4: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_probe_minus_single
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca
) r;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-3: tc SEMI JOIN td
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-3: tc SEMI JOIN td';

-- TC 1-3-1: PARTITION mode, result and trace
evaluate 'TC 1-3-1: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- TC 1-3-2: PARALLEL mode, result and trace
evaluate 'TC 1-3-2: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- TC 1-3-3: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'TC 1-3-3: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS partition_minus_parallel
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca
) r;

-- TC 1-3-4: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'TC 1-3-4: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_minus_partition
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca
) r;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-4: tc ANTI JOIN td
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-4: tc ANTI JOIN td';

-- TC 1-4-1: PARTITION mode, result and trace
evaluate 'TC 1-4-1: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- TC 1-4-2: PARALLEL mode, result and trace
evaluate 'TC 1-4-2: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- TC 1-4-3: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'TC 1-4-3: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS partition_minus_parallel
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca
) r;

-- TC 1-4-4: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'TC 1-4-4: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_minus_partition
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca
) r;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-5: ta SEMI JOIN tb, ON clause term on the outer table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-5: ta SEMI JOIN tb, ON clause term on the outer table only';

-- TC 1-5-1: SINGLE mode, result and trace
evaluate 'TC 1-5-1: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0');
SHOW TRACE;

-- TC 1-5-2: PARALLEL_PROBE mode, result and trace
evaluate 'TC 1-5-2: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0');
SHOW TRACE;

-- TC 1-5-3: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'TC 1-5-3: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS single_minus_parallel_probe
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0')
) r;

-- TC 1-5-4: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'TC 1-5-4: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_probe_minus_single
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0')
) r;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-6: ta ANTI JOIN tb, ON clause term on the outer table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-6: ta ANTI JOIN tb, ON clause term on the outer table only';

-- TC 1-6-1: SINGLE mode, result and trace
evaluate 'TC 1-6-1: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0');
SHOW TRACE;

-- TC 1-6-2: PARALLEL_PROBE mode, result and trace
evaluate 'TC 1-6-2: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0');
SHOW TRACE;

-- TC 1-6-3: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'TC 1-6-3: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS single_minus_parallel_probe
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0')
) r;

-- TC 1-6-4: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'TC 1-6-4: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_probe_minus_single
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0')
) r;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-7: tc SEMI JOIN td, ON clause term on the outer table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-7: tc SEMI JOIN td, ON clause term on the outer table only';

-- TC 1-7-1: PARTITION mode, result and trace
evaluate 'TC 1-7-1: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0');
SHOW TRACE;

-- TC 1-7-2: PARALLEL mode, result and trace
evaluate 'TC 1-7-2: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0');
SHOW TRACE;

-- TC 1-7-3: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'TC 1-7-3: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS partition_minus_parallel
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0')
) r;

-- TC 1-7-4: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'TC 1-7-4: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_minus_partition
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0')
) r;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-8: tc ANTI JOIN td, ON clause term on the outer table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-8: tc ANTI JOIN td, ON clause term on the outer table only';

-- TC 1-8-1: PARTITION mode, result and trace
evaluate 'TC 1-8-1: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0');
SHOW TRACE;

-- TC 1-8-2: PARALLEL mode, result and trace
evaluate 'TC 1-8-2: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0');
SHOW TRACE;

-- TC 1-8-3: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'TC 1-8-3: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS partition_minus_parallel
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0')
) r;

-- TC 1-8-4: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'TC 1-8-4: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_minus_partition
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0')
) r;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-9: ta SEMI JOIN tb, ON clause term on both tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-9: ta SEMI JOIN tb, ON clause term on both tables';

-- TC 1-9-1: SINGLE mode, result and trace
evaluate 'TC 1-9-1: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC 1-9-2: PARALLEL_PROBE mode, result and trace
evaluate 'TC 1-9-2: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC 1-9-3: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'TC 1-9-3: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS single_minus_parallel_probe
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
) r;

-- TC 1-9-4: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'TC 1-9-4: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_probe_minus_single
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
) r;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-10: ta ANTI JOIN tb, ON clause term on both tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-10: ta ANTI JOIN tb, ON clause term on both tables';

-- TC 1-10-1: SINGLE mode, result and trace
evaluate 'TC 1-10-1: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC 1-10-2: PARALLEL_PROBE mode, result and trace
evaluate 'TC 1-10-2: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC 1-10-3: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'TC 1-10-3: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS single_minus_parallel_probe
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
) r;

-- TC 1-10-4: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'TC 1-10-4: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_probe_minus_single
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
) r;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-11: tc SEMI JOIN td, ON clause term on both tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-11: tc SEMI JOIN td, ON clause term on both tables';

-- TC 1-11-1: PARTITION mode, result and trace
evaluate 'TC 1-11-1: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC 1-11-2: PARALLEL mode, result and trace
evaluate 'TC 1-11-2: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC 1-11-3: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'TC 1-11-3: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS partition_minus_parallel
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
) r;

-- TC 1-11-4: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'TC 1-11-4: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_minus_partition
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
) r;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-12: tc ANTI JOIN td, ON clause term on both tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-12: tc ANTI JOIN td, ON clause term on both tables';

-- TC 1-12-1: PARTITION mode, result and trace
evaluate 'TC 1-12-1: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC 1-12-2: PARALLEL mode, result and trace
evaluate 'TC 1-12-2: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC 1-12-3: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'TC 1-12-3: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS partition_minus_parallel
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
) r;

-- TC 1-12-4: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'TC 1-12-4: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_minus_partition
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
) r;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-13: ta SEMI JOIN tb, ON clause term that only a middle row of each key meets
--   Of the 5 rows of a key, only the 3rd meets the term, so the probe passes 2 rows that fail it in insert order
--   or in reverse.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-13: ta SEMI JOIN tb, ON clause term met by a middle row of each key only';

-- TC 1-13-1: SINGLE mode, result and trace
evaluate 'TC 1-13-1: SINGLE mode, result and trace, result = 6000';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > CAST (ta.ca AS INT) / 4 + 6000 AND tb.cb < CAST (ta.ca AS INT) / 4 + 18000;
SHOW TRACE;

-- TC 1-13-2: PARALLEL_PROBE mode, result and trace
evaluate 'TC 1-13-2: PARALLEL_PROBE mode, result and trace, result = 6000';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > CAST (ta.ca AS INT) / 4 + 6000 AND tb.cb < CAST (ta.ca AS INT) / 4 + 18000;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-14: ta ANTI JOIN tb, ON clause term that only a middle row of each key meets
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-14: ta ANTI JOIN tb, ON clause term met by a middle row of each key only';

-- TC 1-14-1: SINGLE mode, result and trace
evaluate 'TC 1-14-1: SINGLE mode, result and trace, result = 24001';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > CAST (ta.ca AS INT) / 4 + 6000 AND tb.cb < CAST (ta.ca AS INT) / 4 + 18000;
SHOW TRACE;

-- TC 1-14-2: PARALLEL_PROBE mode, result and trace
evaluate 'TC 1-14-2: PARALLEL_PROBE mode, result and trace, result = 24001';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > CAST (ta.ca AS INT) / 4 + 6000 AND tb.cb < CAST (ta.ca AS INT) / 4 + 18000;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-15: tc SEMI JOIN td, ON clause term that only a middle row of each key meets
--   Of the 4 rows of a key, only the 2nd meets the term, so the probe passes 1 row that fails it in insert order,
--   2 in reverse.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-15: tc SEMI JOIN td, ON clause term met by a middle row of each key only';

-- TC 1-15-1: PARTITION mode, result and trace
evaluate 'TC 1-15-1: PARTITION mode, result and trace, result = 20000';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND td.cb > CAST (tc.ca AS INT) / 4 AND td.cb < CAST (tc.ca AS INT) / 4 + 40000;
SHOW TRACE;

-- TC 1-15-2: PARALLEL mode, result and trace
evaluate 'TC 1-15-2: PARALLEL mode, result and trace, result = 20000';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND td.cb > CAST (tc.ca AS INT) / 4 AND td.cb < CAST (tc.ca AS INT) / 4 + 40000;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-16: tc ANTI JOIN td, ON clause term that only a middle row of each key meets
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-16: tc ANTI JOIN td, ON clause term met by a middle row of each key only';

-- TC 1-16-1: PARTITION mode, result and trace
evaluate 'TC 1-16-1: PARTITION mode, result and trace, result = 60001';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND td.cb > CAST (tc.ca AS INT) / 4 AND td.cb < CAST (tc.ca AS INT) / 4 + 40000;
SHOW TRACE;

-- TC 1-16-2: PARALLEL mode, result and trace
evaluate 'TC 1-16-2: PARALLEL mode, result and trace, result = 60001';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND td.cb > CAST (tc.ca AS INT) / 4 AND td.cb < CAST (tc.ca AS INT) / 4 + 40000;
SHOW TRACE;

-- =====================================================================================================================
-- TC 2: LEFT/RIGHT OUTER JOIN in four hash join modes
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-1: ta LEFT OUTER JOIN tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-1: ta LEFT OUTER JOIN tb';

-- TC 2-1-1: SINGLE mode, result and trace
evaluate 'TC 2-1-1: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (tb.ca)
FROM ta
  LEFT JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC 2-1-2: PARALLEL_PROBE mode, result and trace
evaluate 'TC 2-1-2: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (tb.ca)
FROM ta
  LEFT JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-2: ta RIGHT OUTER JOIN tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-2: ta RIGHT OUTER JOIN tb';

-- TC 2-2-1: SINGLE mode, result and trace
evaluate 'TC 2-2-1: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (ta.ca)
FROM ta
  RIGHT JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC 2-2-2: PARALLEL_PROBE mode, result and trace
evaluate 'TC 2-2-2: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (ta.ca)
FROM ta
  RIGHT JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-3: tc LEFT OUTER JOIN td
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-3: tc LEFT OUTER JOIN td';

-- TC 2-3-1: PARTITION mode, result and trace
evaluate 'TC 2-3-1: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (td.ca)
FROM tc
  LEFT JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- TC 2-3-2: PARALLEL mode, result and trace
evaluate 'TC 2-3-2: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (td.ca)
FROM tc
  LEFT JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-4: tc RIGHT OUTER JOIN td
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-4: tc RIGHT OUTER JOIN td';

-- TC 2-4-1: PARTITION mode, result and trace
evaluate 'TC 2-4-1: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (tc.ca)
FROM tc
  RIGHT JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- TC 2-4-2: PARALLEL mode, result and trace
evaluate 'TC 2-4-2: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (tc.ca)
FROM tc
  RIGHT JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- =====================================================================================================================
-- TC 3: partitions without inner rows; outer input larger than inner input
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-1: SEMI JOIN, partitions without inner rows
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-1: SEMI JOIN, partitions without inner rows';

-- TC 3-1-1: PARTITION mode, result and trace
evaluate 'TC 3-1-1: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN te ON te.ca = tc.ca;
SHOW TRACE;

-- TC 3-1-2: PARALLEL mode, result and trace
evaluate 'TC 3-1-2: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN te ON te.ca = tc.ca;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-2: ANTI JOIN, partitions without inner rows
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-2: ANTI JOIN, partitions without inner rows';

-- TC 3-2-1: PARTITION mode, result and trace
evaluate 'TC 3-2-1: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN te ON te.ca = tc.ca;
SHOW TRACE;

-- TC 3-2-2: PARALLEL mode, result and trace
evaluate 'TC 3-2-2: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN te ON te.ca = tc.ca;
SHOW TRACE;

-- cleanup
DROP TABLE IF EXISTS te, td, tc, tb, ta;
SET SYSTEM PARAMETERS 'max_hash_list_scan_size=default';

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-3: SEMI JOIN, larger outer input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-3: SEMI JOIN, larger outer input';

DROP TABLE IF EXISTS tb, ta;
-- ta: 50 rows, keys 1 to 50 once each
--   1, 2, 3, ..., 50
CREATE TABLE ta (ca INT);
INSERT INTO ta SELECT LEVEL FROM db_root CONNECT BY LEVEL <= 50;

-- tb: 5 rows, keys 1 and 2 twice each, and key 3 once
--   1, 1, 2, 2, 3
CREATE TABLE tb (ca INT);
INSERT INTO tb VALUES (1), (1), (2), (2), (3);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 3-3-1: hash join, result and trace
evaluate 'TC 3-3-1: hash join, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-4: ANTI JOIN, larger outer input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-4: ANTI JOIN, larger outer input';

DROP TABLE IF EXISTS tb, ta;
-- ta: 50 rows, keys 1 to 50 once each
--   1, 2, 3, ..., 50
CREATE TABLE ta (ca INT);
INSERT INTO ta SELECT LEVEL FROM db_root CONNECT BY LEVEL <= 50;

-- tb: 5 rows, keys 1 and 2 twice each, and key 3 once
--   1, 1, 2, 2, 3
CREATE TABLE tb (ca INT);
INSERT INTO tb VALUES (1), (1), (2), (2), (3);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 3-4-1: hash join, result and trace
evaluate 'TC 3-4-1: hash join, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-5: SEMI JOIN, smaller outer input
--   An INNER JOIN of these tables builds the smaller input ta. A SEMI JOIN and an ANTI JOIN must build the inner tb.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-5: SEMI JOIN, smaller outer input';

DROP TABLE IF EXISTS tb, ta;
-- ta: 5 rows, keys 1 to 5 once each
--   1, 2, 3, 4, 5
CREATE TABLE ta (ca INT);
INSERT INTO ta SELECT LEVEL FROM db_root CONNECT BY LEVEL <= 5;

-- tb: 60 rows, keys 1, 2 and 3 with 20 rows each
--   2, 3, 1, 2, 3, 1, ...
CREATE TABLE tb (ca INT);
INSERT INTO tb SELECT MOD (LEVEL, 3) + 1 FROM db_root CONNECT BY LEVEL <= 60;

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 3-5-1: INNER JOIN of the same tables, which builds ta
evaluate 'TC 3-5-1: INNER JOIN of the same tables builds ta, result = 60';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC 3-5-2: SEMI JOIN, which builds tb
evaluate 'TC 3-5-2: SEMI JOIN builds tb, result = 3';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-6: ANTI JOIN, smaller outer input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-6: ANTI JOIN, smaller outer input';

DROP TABLE IF EXISTS tb, ta;
-- ta: 5 rows, keys 1 to 5 once each
--   1, 2, 3, 4, 5
CREATE TABLE ta (ca INT);
INSERT INTO ta SELECT LEVEL FROM db_root CONNECT BY LEVEL <= 5;

-- tb: 60 rows, keys 1, 2 and 3 with 20 rows each
--   2, 3, 1, 2, 3, 1, ...
CREATE TABLE tb (ca INT);
INSERT INTO tb SELECT MOD (LEVEL, 3) + 1 FROM db_root CONNECT BY LEVEL <= 60;

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 3-6-1: ANTI JOIN, which builds tb
evaluate 'TC 3-6-1: ANTI JOIN builds tb, result = 2';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- cleanup
SET TRACE OFF;
DROP TABLE IF EXISTS tb, ta;

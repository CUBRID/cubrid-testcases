/**
 *  This test case verifies CBRD-27379: SEMI JOIN and ANTI JOIN run as a hash join.
 *  AC-1: hash join execution modes, outer joins, empty partitions (TC-1-05 to TC-1-07).
 *
 *  The hash join runs in one of four modes:
 *    SINGLE          ta, tb with NO_PARALLEL_HASH_JOIN: no SPLIT line, no parallel workers on HASHJOIN or PROBE
 *    PARTITION       tc, td with NO_PARALLEL_HASH_JOIN: SPLIT line, no parallel workers on HASHJOIN or PROBE
 *    PARALLEL_PROBE  ta, tb with PARALLEL(4): no SPLIT line, parallel workers under PROBE
 *    PARALLEL        tc, td with PARALLEL(4): SPLIT line, parallel workers on HASHJOIN
 *  The file lowers max_hash_list_scan_size to 2M for TC-1-05 to TC-1-07-02 to keep the tables small. ta, tb (30001
 *  rows each) stay below its split threshold even as the build input, and tc, td (80001 rows each) exceed it.
 *  The join key is CHAR(200) so that the input lists of ta, tb fill more than 4 sectors of 64 pages with few rows, and
 *  each of the 4 workers of PARALLEL(4) gets a sector to scan.
 *  Run this file with test_mode=yes, as CTP does, for the parallel modes:
 *  test_mode lowers parallel_scan_page_threshold to 32, and parallel_hash_join_page_threshold
 *  and parallel_sort_page_threshold to 0, when they keep their default values.
 *
 *  Coverage:
 *    TC-1-05: SEMI JOIN / ANTI JOIN in the four modes, also with an ON clause term on the outer table or on both tables,
 *             and with an ON clause term that only the last of the inner rows with the same key meets
 *    TC-1-06: LEFT / RIGHT OUTER JOIN in the four modes
 *    TC-1-07: partitions without inner rows, and an outer input larger or smaller than the inner
 *             (SEMI JOIN / ANTI JOIN build the inner input even when the outer is smaller, an INNER JOIN builds the outer)
 *
 *  Sub-cases:
 *    No  Sub-case    Query                   Case
 *    1   TC-1-05-01  ta SEMI JOIN tb         SINGLE, PARALLEL_PROBE
 *    2   TC-1-05-02  ta ANTI JOIN tb         SINGLE, PARALLEL_PROBE
 *    3   TC-1-05-03  tc SEMI JOIN td         PARTITION, PARALLEL
 *    4   TC-1-05-04  tc ANTI JOIN td         PARTITION, PARALLEL
 *    5   TC-1-05-05  ta SEMI JOIN tb         SINGLE, PARALLEL_PROBE, ON term on the outer table
 *    6   TC-1-05-06  ta ANTI JOIN tb         SINGLE, PARALLEL_PROBE, ON term on the outer table
 *    7   TC-1-05-07  tc SEMI JOIN td         PARTITION, PARALLEL, ON term on the outer table
 *    8   TC-1-05-08  tc ANTI JOIN td         PARTITION, PARALLEL, ON term on the outer table
 *    9   TC-1-05-09  ta SEMI JOIN tb         SINGLE, PARALLEL_PROBE, ON term on both tables
 *    10  TC-1-05-10  ta ANTI JOIN tb         SINGLE, PARALLEL_PROBE, ON term on both tables
 *    11  TC-1-05-11  tc SEMI JOIN td         PARTITION, PARALLEL, ON term on both tables
 *    12  TC-1-05-12  tc ANTI JOIN td         PARTITION, PARALLEL, ON term on both tables
 *    13  TC-1-05-13  ta SEMI JOIN tb         SINGLE, PARALLEL_PROBE, ON term met by the last row of a key only
 *    14  TC-1-05-14  ta ANTI JOIN tb         SINGLE, PARALLEL_PROBE, ON term met by the last row of a key only
 *    15  TC-1-05-15  tc SEMI JOIN td         PARTITION, PARALLEL, ON term met by the last row of a key only
 *    16  TC-1-05-16  tc ANTI JOIN td         PARTITION, PARALLEL, ON term met by the last row of a key only
 *    17  TC-1-06-01  ta LEFT OUTER JOIN tb   SINGLE, PARALLEL_PROBE
 *    18  TC-1-06-02  ta RIGHT OUTER JOIN tb  SINGLE, PARALLEL_PROBE
 *    19  TC-1-06-03  tc LEFT OUTER JOIN td   PARTITION, PARALLEL
 *    20  TC-1-06-04  tc RIGHT OUTER JOIN td  PARTITION, PARALLEL
 *    21  TC-1-07-01  tc SEMI JOIN te         PARTITION, PARALLEL, partitions without inner rows
 *    22  TC-1-07-02  tc ANTI JOIN te         PARTITION, PARALLEL, partitions without inner rows
 *    23  TC-1-07-03  ta SEMI JOIN tb         outer input larger than the inner
 *    24  TC-1-07-04  ta ANTI JOIN tb         outer input larger than the inner
 *    25  TC-1-07-05  ta SEMI JOIN tb         outer input smaller than the inner, INNER JOIN of the same tables first
 *    26  TC-1-07-06  ta ANTI JOIN tb         outer input smaller than the inner
 *
 *  TC-1-05-01 to TC-1-05-12 compare the two modes on the same tables by EXCEPT ALL in both directions. Both counts
 *  must be 0. TC-1-05-13 to TC-1-05-16 check the counts, which a probe that stops at the first row of a key changes.
 *  CTP masks the numbers in a SHOW TRACE output, so time, fetch and row values are not compared.
 *  The trace asserts the presence of the SPLIT line, and of the parallel workers line on HASHJOIN or under PROBE.
 *  The traced queries add NO_PARALLEL_SUBQUERY and NO_PARALLEL_SCAN: whether a subquery or a scan gets parallel
 *  workers can differ from run to run, and the trace would show it in lines this file does not assert.
 */

-- =====================================================================================================================
-- Setup for TC-1-05 to TC-1-07-02 (hash join modes, outer joins, empty partitions)
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
--   cb is ROWNUM: the 5 rows of key 4 * k have cb k, k + 6000, ..., k + 24000, and only the last has cb >= k + 24000
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
--   cb is ROWNUM: the 4 rows of key 4 * k have cb k, k + 20000, k + 40000, k + 60000, and only the last has cb >= k + 60000
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
-- TC-1-05: SEMI JOIN / ANTI JOIN in four hash join modes
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-01: ta SEMI JOIN tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-01: ta SEMI JOIN tb';

-- TC-1-05-01-01: SINGLE mode, result and trace
evaluate 'TC-1-05-01-01: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC-1-05-01-02: PARALLEL_PROBE mode, result and trace
evaluate 'TC-1-05-01-02: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC-1-05-01-03: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'TC-1-05-01-03: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
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

-- TC-1-05-01-04: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'TC-1-05-01-04: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
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
-- TC-1-05-02: ta ANTI JOIN tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-02: ta ANTI JOIN tb';

-- TC-1-05-02-01: SINGLE mode, result and trace
evaluate 'TC-1-05-02-01: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC-1-05-02-02: PARALLEL_PROBE mode, result and trace
evaluate 'TC-1-05-02-02: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC-1-05-02-03: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'TC-1-05-02-03: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
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

-- TC-1-05-02-04: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'TC-1-05-02-04: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
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
-- TC-1-05-03: tc SEMI JOIN td
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-03: tc SEMI JOIN td';

-- TC-1-05-03-01: PARTITION mode, result and trace
evaluate 'TC-1-05-03-01: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- TC-1-05-03-02: PARALLEL mode, result and trace
evaluate 'TC-1-05-03-02: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- TC-1-05-03-03: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'TC-1-05-03-03: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
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

-- TC-1-05-03-04: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'TC-1-05-03-04: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
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
-- TC-1-05-04: tc ANTI JOIN td
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-04: tc ANTI JOIN td';

-- TC-1-05-04-01: PARTITION mode, result and trace
evaluate 'TC-1-05-04-01: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- TC-1-05-04-02: PARALLEL mode, result and trace
evaluate 'TC-1-05-04-02: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- TC-1-05-04-03: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'TC-1-05-04-03: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
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

-- TC-1-05-04-04: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'TC-1-05-04-04: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
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
-- TC-1-05-05: ta SEMI JOIN tb, ON clause term on the outer table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-05: ta SEMI JOIN tb, ON clause term on the outer table only';

-- TC-1-05-05-01: SINGLE mode, result and trace
evaluate 'TC-1-05-05-01: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0');
SHOW TRACE;

-- TC-1-05-05-02: PARALLEL_PROBE mode, result and trace
evaluate 'TC-1-05-05-02: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0');
SHOW TRACE;

-- TC-1-05-05-03: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'TC-1-05-05-03: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
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

-- TC-1-05-05-04: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'TC-1-05-05-04: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
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
-- TC-1-05-06: ta ANTI JOIN tb, ON clause term on the outer table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-06: ta ANTI JOIN tb, ON clause term on the outer table only';

-- TC-1-05-06-01: SINGLE mode, result and trace
evaluate 'TC-1-05-06-01: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0');
SHOW TRACE;

-- TC-1-05-06-02: PARALLEL_PROBE mode, result and trace
evaluate 'TC-1-05-06-02: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (15000, 200, '0');
SHOW TRACE;

-- TC-1-05-06-03: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'TC-1-05-06-03: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
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

-- TC-1-05-06-04: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'TC-1-05-06-04: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
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
-- TC-1-05-07: tc SEMI JOIN td, ON clause term on the outer table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-07: tc SEMI JOIN td, ON clause term on the outer table only';

-- TC-1-05-07-01: PARTITION mode, result and trace
evaluate 'TC-1-05-07-01: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0');
SHOW TRACE;

-- TC-1-05-07-02: PARALLEL mode, result and trace
evaluate 'TC-1-05-07-02: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0');
SHOW TRACE;

-- TC-1-05-07-03: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'TC-1-05-07-03: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
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

-- TC-1-05-07-04: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'TC-1-05-07-04: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
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
-- TC-1-05-08: tc ANTI JOIN td, ON clause term on the outer table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-08: tc ANTI JOIN td, ON clause term on the outer table only';

-- TC-1-05-08-01: PARTITION mode, result and trace
evaluate 'TC-1-05-08-01: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0');
SHOW TRACE;

-- TC-1-05-08-02: PARALLEL mode, result and trace
evaluate 'TC-1-05-08-02: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (40000, 200, '0');
SHOW TRACE;

-- TC-1-05-08-03: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'TC-1-05-08-03: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
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

-- TC-1-05-08-04: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'TC-1-05-08-04: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
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
-- TC-1-05-09: ta SEMI JOIN tb, ON clause term on both tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-09: ta SEMI JOIN tb, ON clause term on both tables';

-- TC-1-05-09-01: SINGLE mode, result and trace
evaluate 'TC-1-05-09-01: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC-1-05-09-02: PARALLEL_PROBE mode, result and trace
evaluate 'TC-1-05-09-02: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC-1-05-09-03: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'TC-1-05-09-03: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
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

-- TC-1-05-09-04: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'TC-1-05-09-04: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
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
-- TC-1-05-10: ta ANTI JOIN tb, ON clause term on both tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-10: ta ANTI JOIN tb, ON clause term on both tables';

-- TC-1-05-10-01: SINGLE mode, result and trace
evaluate 'TC-1-05-10-01: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC-1-05-10-02: PARALLEL_PROBE mode, result and trace
evaluate 'TC-1-05-10-02: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC-1-05-10-03: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'TC-1-05-10-03: rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
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

-- TC-1-05-10-04: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'TC-1-05-10-04: rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
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
-- TC-1-05-11: tc SEMI JOIN td, ON clause term on both tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-11: tc SEMI JOIN td, ON clause term on both tables';

-- TC-1-05-11-01: PARTITION mode, result and trace
evaluate 'TC-1-05-11-01: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC-1-05-11-02: PARALLEL mode, result and trace
evaluate 'TC-1-05-11-02: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC-1-05-11-03: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'TC-1-05-11-03: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
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

-- TC-1-05-11-04: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'TC-1-05-11-04: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
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
-- TC-1-05-12: tc ANTI JOIN td, ON clause term on both tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-12: tc ANTI JOIN td, ON clause term on both tables';

-- TC-1-05-12-01: PARTITION mode, result and trace
evaluate 'TC-1-05-12-01: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC-1-05-12-02: PARALLEL mode, result and trace
evaluate 'TC-1-05-12-02: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;
SHOW TRACE;

-- TC-1-05-12-03: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'TC-1-05-12-03: rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
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

-- TC-1-05-12-04: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'TC-1-05-12-04: rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
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
-- TC-1-05-13: ta SEMI JOIN tb, ON clause term that only the last row of each key meets
--   Of the 5 rows of a key, the probe must pass the 4 that fail the term and find the last one.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-13: ta SEMI JOIN tb, ON clause term met by the last row of each key only';

-- TC-1-05-13-01: SINGLE mode, result and trace
evaluate 'TC-1-05-13-01: SINGLE mode, result and trace, result = 6000';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb >= CAST (ta.ca AS INT) / 4 + 24000;
SHOW TRACE;

-- TC-1-05-13-02: PARALLEL_PROBE mode, result and trace
evaluate 'TC-1-05-13-02: PARALLEL_PROBE mode, result and trace, result = 6000';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb >= CAST (ta.ca AS INT) / 4 + 24000;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-14: ta ANTI JOIN tb, ON clause term that only the last row of each key meets
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-14: ta ANTI JOIN tb, ON clause term met by the last row of each key only';

-- TC-1-05-14-01: SINGLE mode, result and trace
evaluate 'TC-1-05-14-01: SINGLE mode, result and trace, result = 24001';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb >= CAST (ta.ca AS INT) / 4 + 24000;
SHOW TRACE;

-- TC-1-05-14-02: PARALLEL_PROBE mode, result and trace
evaluate 'TC-1-05-14-02: PARALLEL_PROBE mode, result and trace, result = 24001';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb >= CAST (ta.ca AS INT) / 4 + 24000;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-15: tc SEMI JOIN td, ON clause term that only the last row of each key meets
--   Of the 4 rows of a key, the probe must pass the 3 that fail the term and find the last one.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-15: tc SEMI JOIN td, ON clause term met by the last row of each key only';

-- TC-1-05-15-01: PARTITION mode, result and trace
evaluate 'TC-1-05-15-01: PARTITION mode, result and trace, result = 20000';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND td.cb >= CAST (tc.ca AS INT) / 4 + 60000;
SHOW TRACE;

-- TC-1-05-15-02: PARALLEL mode, result and trace
evaluate 'TC-1-05-15-02: PARALLEL mode, result and trace, result = 20000';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND td.cb >= CAST (tc.ca AS INT) / 4 + 60000;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-16: tc ANTI JOIN td, ON clause term that only the last row of each key meets
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-16: tc ANTI JOIN td, ON clause term met by the last row of each key only';

-- TC-1-05-16-01: PARTITION mode, result and trace
evaluate 'TC-1-05-16-01: PARTITION mode, result and trace, result = 60001';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND td.cb >= CAST (tc.ca AS INT) / 4 + 60000;
SHOW TRACE;

-- TC-1-05-16-02: PARALLEL mode, result and trace
evaluate 'TC-1-05-16-02: PARALLEL mode, result and trace, result = 60001';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND td.cb >= CAST (tc.ca AS INT) / 4 + 60000;
SHOW TRACE;

-- =====================================================================================================================
-- TC-1-06: LEFT/RIGHT OUTER JOIN in four hash join modes
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-06-01: ta LEFT OUTER JOIN tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-06-01: ta LEFT OUTER JOIN tb';

-- TC-1-06-01-01: SINGLE mode, result and trace
evaluate 'TC-1-06-01-01: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (tb.ca)
FROM ta
  LEFT JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC-1-06-01-02: PARALLEL_PROBE mode, result and trace
evaluate 'TC-1-06-01-02: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (tb.ca)
FROM ta
  LEFT JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-06-02: ta RIGHT OUTER JOIN tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-06-02: ta RIGHT OUTER JOIN tb';

-- TC-1-06-02-01: SINGLE mode, result and trace
evaluate 'TC-1-06-02-01: SINGLE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (ta.ca)
FROM ta
  RIGHT JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC-1-06-02-02: PARALLEL_PROBE mode, result and trace
evaluate 'TC-1-06-02-02: PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (ta.ca)
FROM ta
  RIGHT JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-06-03: tc LEFT OUTER JOIN td
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-06-03: tc LEFT OUTER JOIN td';

-- TC-1-06-03-01: PARTITION mode, result and trace
evaluate 'TC-1-06-03-01: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (td.ca)
FROM tc
  LEFT JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- TC-1-06-03-02: PARALLEL mode, result and trace
evaluate 'TC-1-06-03-02: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (td.ca)
FROM tc
  LEFT JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-06-04: tc RIGHT OUTER JOIN td
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-06-04: tc RIGHT OUTER JOIN td';

-- TC-1-06-04-01: PARTITION mode, result and trace
evaluate 'TC-1-06-04-01: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (tc.ca)
FROM tc
  RIGHT JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- TC-1-06-04-02: PARALLEL mode, result and trace
evaluate 'TC-1-06-04-02: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*), COUNT (tc.ca)
FROM tc
  RIGHT JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- =====================================================================================================================
-- TC-1-07: partitions without inner rows; outer input larger than inner input
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-01: SEMI JOIN, partitions without inner rows
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-01: SEMI JOIN, partitions without inner rows';

-- TC-1-07-01-01: PARTITION mode, result and trace
evaluate 'TC-1-07-01-01: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN te ON te.ca = tc.ca;
SHOW TRACE;

-- TC-1-07-01-02: PARALLEL mode, result and trace
evaluate 'TC-1-07-01-02: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  SEMI JOIN te ON te.ca = tc.ca;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-02: ANTI JOIN, partitions without inner rows
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-02: ANTI JOIN, partitions without inner rows';

-- TC-1-07-02-01: PARTITION mode, result and trace
evaluate 'TC-1-07-02-01: PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN te ON te.ca = tc.ca;
SHOW TRACE;

-- TC-1-07-02-02: PARALLEL mode, result and trace
evaluate 'TC-1-07-02-02: PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM tc
  ANTI JOIN te ON te.ca = tc.ca;
SHOW TRACE;

-- cleanup
DROP TABLE IF EXISTS te, td, tc, tb, ta;
SET SYSTEM PARAMETERS 'max_hash_list_scan_size=default';

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-03: SEMI JOIN, larger outer input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-03: SEMI JOIN, larger outer input';

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

-- TC-1-07-03-01: hash join, result and trace
evaluate 'TC-1-07-03-01: hash join, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-04: ANTI JOIN, larger outer input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-04: ANTI JOIN, larger outer input';

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

-- TC-1-07-04-01: hash join, result and trace
evaluate 'TC-1-07-04-01: hash join, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-05: SEMI JOIN, smaller outer input
--   An INNER JOIN of these tables builds the smaller input ta. A SEMI JOIN and an ANTI JOIN must build the inner tb.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-05: SEMI JOIN, smaller outer input';

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

-- TC-1-07-05-01: INNER JOIN of the same tables, which builds ta
evaluate 'TC-1-07-05-01: INNER JOIN of the same tables builds ta, result = 60';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- TC-1-07-05-02: SEMI JOIN, which builds tb
evaluate 'TC-1-07-05-02: SEMI JOIN builds tb, result = 3';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-06: ANTI JOIN, smaller outer input
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-06: ANTI JOIN, smaller outer input';

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

-- TC-1-07-06-01: ANTI JOIN, which builds tb
evaluate 'TC-1-07-06-01: ANTI JOIN builds tb, result = 2';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- cleanup
SET TRACE OFF;
DROP TABLE IF EXISTS tb, ta;

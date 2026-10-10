/**
 *  This test case verifies CBRD-27379: SEMI JOIN and ANTI JOIN run as a hash join.
 *  Part 2 of 5 -- hash join execution modes, outer joins, empty partitions (TC-1-05 to TC-1-07).
 *
 *  The hash join runs in one of four modes:
 *    SINGLE          ta, tb with NO_PARALLEL_HASH_JOIN: no SPLIT line, no parallel workers
 *    PARTITION       tc, td with NO_PARALLEL_HASH_JOIN: SPLIT line, no parallel workers
 *    PARALLEL_PROBE  ta, tb with PARALLEL(4): no SPLIT line, parallel workers under PROBE
 *    PARALLEL        tc, td with PARALLEL(4): SPLIT line, parallel workers on HASHJOIN
 *  ta, tb (100001 rows on the smaller side) stay below the split threshold of the default max_hash_list_scan_size,
 *  and tc, td (300001 rows each) exceed it.
 *  The join key is CHAR(200) so that the input lists reach parallel_hash_join_page_threshold.
 *
 *  Coverage:
 *    TC-1-05: SEMI JOIN / ANTI JOIN in the four modes, also with an ON clause term on the outer table or on both tables
 *    TC-1-06: LEFT / RIGHT OUTER JOIN in the four modes
 *    TC-1-07: partitions without inner rows, and an outer input larger than the inner
 *
 *  TC-1-05 compares the two modes on the same tables by EXCEPT ALL in both directions. Both counts must be 0.
 *  CTP runs with test_mode=yes, so time, fetch and row values in "show trace" are masked.
 *  The trace asserts the presence of the SPLIT and parallel workers lines.
 */

-- =====================================================================================================================
-- Setup for TC-1-05 to TC-1-07-02 (hash join modes, outer joins, empty partitions)
-- =====================================================================================================================
DROP TABLE IF EXISTS ta, tb, tc, td, te;

-- ta: 100000 rows of LPAD (ROWNUM, 200, '0'), and one NULL row
--   ROWNUM 1       -> '0000...0001'    199 '0' + '1'
--   ROWNUM 2       -> '0000...0002'    199 '0' + '2'
--   ...
--   ROWNUM 100000  -> '0000...100000'  194 '0' + '100000'
--   NULL
--   Stored: 100001 rows, keys 1 .. 100000 with 1 row per key, and 1 NULL
CREATE TABLE ta (ca CHAR(200));
INSERT INTO ta
WITH RECURSIVE cte (n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 400
)
SELECT LPAD (ROWNUM, 200, '0')
FROM cte x, cte y
WHERE ROWNUM <= 100000;
INSERT INTO ta VALUES (NULL);

-- tb: 150000 rows of LPAD (MOD (ROWNUM - 1, 25000) * 4 + 4, 200, '0'), and one NULL row
--   ROWNUM 1       -> '0000...0004'    199 '0' + '4'
--   ROWNUM 2       -> '0000...0008'    199 '0' + '8'
--   ...
--   ROWNUM 25000   -> '0000...100000'  194 '0' + '100000'
--   ROWNUM 25001   -> '0000...0004'    199 '0' + '4'       the same keys repeat, 6 rows per key
--   ...
--   ROWNUM 150000  -> '0000...100000'  194 '0' + '100000'
--   NULL
--   Stored: 150001 rows, 25000 keys 4 .. 100000 (multiples of 4) with 6 rows per key, and 1 NULL
CREATE TABLE tb (ca CHAR(200));
INSERT INTO tb
WITH RECURSIVE cte (n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 400
)
SELECT LPAD (MOD (ROWNUM - 1, 25000) * 4 + 4, 200, '0')
FROM cte x, cte y
WHERE ROWNUM <= 150000;
INSERT INTO tb VALUES (NULL);

-- tc: 300000 rows of LPAD (ROWNUM, 200, '0'), and one NULL row
--   ROWNUM 1       -> '0000...0001'    199 '0' + '1'
--   ROWNUM 2       -> '0000...0002'    199 '0' + '2'
--   ...
--   ROWNUM 300000  -> '0000...300000'  194 '0' + '300000'
--   NULL
--   Stored: 300001 rows, keys 1 .. 300000 with 1 row per key, and 1 NULL
CREATE TABLE tc (ca CHAR(200));
INSERT INTO tc
WITH RECURSIVE cte (n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 600
)
SELECT LPAD (ROWNUM, 200, '0')
FROM cte x, cte y
WHERE ROWNUM <= 300000;
INSERT INTO tc VALUES (NULL);

-- td: 300000 rows of LPAD (MOD (ROWNUM - 1, 75000) * 4 + 4, 200, '0'), and one NULL row
--   ROWNUM 1       -> '0000...0004'    199 '0' + '4'
--   ROWNUM 2       -> '0000...0008'    199 '0' + '8'
--   ...
--   ROWNUM 75000   -> '0000...300000'  194 '0' + '300000'
--   ROWNUM 75001   -> '0000...0004'    199 '0' + '4'       the same keys repeat, 4 rows per key
--   ...
--   ROWNUM 300000  -> '0000...300000'  194 '0' + '300000'
--   NULL
--   Stored: 300001 rows, 75000 keys 4 .. 300000 (multiples of 4) with 4 rows per key, and 1 NULL
CREATE TABLE td (ca CHAR(200));
INSERT INTO td
WITH RECURSIVE cte (n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 600
)
SELECT LPAD (MOD (ROWNUM - 1, 75000) * 4 + 4, 200, '0')
FROM cte x, cte y
WHERE ROWNUM <= 300000;
INSERT INTO td VALUES (NULL);

UPDATE STATISTICS ON ta, tb, tc, td;

-- Trace stays on until the end of this file. Each SHOW TRACE prints the trace of the query right before it.
SET TRACE ON;

-- =====================================================================================================================
-- TC-1-05: SEMI JOIN / ANTI JOIN in four hash join modes
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-01: ta SEMI JOIN tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-01: ta SEMI JOIN tb';

-- SINGLE mode, result
evaluate 'SINGLE mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;

-- SINGLE mode, trace
evaluate 'SINGLE mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- PARALLEL_PROBE mode, result and trace
evaluate 'PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS single_minus_parallel_probe
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca
) x;

-- rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_probe_minus_single
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca
) x;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-02: ta ANTI JOIN tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-02: ta ANTI JOIN tb';

-- SINGLE mode, result
evaluate 'SINGLE mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;

-- SINGLE mode, trace
evaluate 'SINGLE mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- PARALLEL_PROBE mode, result and trace
evaluate 'PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS single_minus_parallel_probe
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca
) x;

-- rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_probe_minus_single
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca
) x;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-03: tc SEMI JOIN td
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-03: tc SEMI JOIN td';

-- PARTITION mode, result
evaluate 'PARTITION mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca;

-- PARTITION mode, trace
evaluate 'PARTITION mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- PARALLEL mode, result and trace
evaluate 'PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS partition_minus_parallel
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca
) x;

-- rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_minus_partition
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca
) x;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-04: tc ANTI JOIN td
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-04: tc ANTI JOIN td';

-- PARTITION mode, result
evaluate 'PARTITION mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca;

-- PARTITION mode, trace
evaluate 'PARTITION mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- PARALLEL mode, result and trace
evaluate 'PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS partition_minus_parallel
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca
) x;

-- rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_minus_partition
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca
) x;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-05: ta SEMI JOIN tb, ON clause term on the outer table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-05: ta SEMI JOIN tb, ON clause term on the outer table only';

-- SINGLE mode, result
evaluate 'SINGLE mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0');

-- SINGLE mode, trace
evaluate 'SINGLE mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0');
SHOW TRACE;

-- PARALLEL_PROBE mode, result and trace
evaluate 'PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0');
SHOW TRACE;

-- rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS single_minus_parallel_probe
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0')
) x;

-- rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_probe_minus_single
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0')
) x;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-06: ta ANTI JOIN tb, ON clause term on the outer table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-06: ta ANTI JOIN tb, ON clause term on the outer table only';

-- SINGLE mode, result
evaluate 'SINGLE mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0');

-- SINGLE mode, trace
evaluate 'SINGLE mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0');
SHOW TRACE;

-- PARALLEL_PROBE mode, result and trace
evaluate 'PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0');
SHOW TRACE;

-- rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS single_minus_parallel_probe
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0')
) x;

-- rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_probe_minus_single
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.ca <= LPAD (50000, 200, '0')
) x;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-07: tc SEMI JOIN td, ON clause term on the outer table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-07: tc SEMI JOIN td, ON clause term on the outer table only';

-- PARTITION mode, result
evaluate 'PARTITION mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0');

-- PARTITION mode, trace
evaluate 'PARTITION mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0');
SHOW TRACE;

-- PARALLEL mode, result and trace
evaluate 'PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0');
SHOW TRACE;

-- rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS partition_minus_parallel
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0')
) x;

-- rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_minus_partition
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0')
) x;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-08: tc ANTI JOIN td, ON clause term on the outer table only
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-08: tc ANTI JOIN td, ON clause term on the outer table only';

-- PARTITION mode, result
evaluate 'PARTITION mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0');

-- PARTITION mode, trace
evaluate 'PARTITION mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0');
SHOW TRACE;

-- PARALLEL mode, result and trace
evaluate 'PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0');
SHOW TRACE;

-- rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS partition_minus_parallel
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0')
) x;

-- rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_minus_partition
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0')
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND tc.ca <= LPAD (150000, 200, '0')
) x;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-09: ta SEMI JOIN tb, ON clause term on both tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-09: ta SEMI JOIN tb, ON clause term on both tables';

-- SINGLE mode, result
evaluate 'SINGLE mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;

-- SINGLE mode, trace
evaluate 'SINGLE mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;
SHOW TRACE;

-- PARALLEL_PROBE mode, result and trace
evaluate 'PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;
SHOW TRACE;

-- rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS single_minus_parallel_probe
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
) x;

-- rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_probe_minus_single
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
) x;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-10: ta ANTI JOIN tb, ON clause term on both tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-10: ta ANTI JOIN tb, ON clause term on both tables';

-- SINGLE mode, result
evaluate 'SINGLE mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;

-- SINGLE mode, trace
evaluate 'SINGLE mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;
SHOW TRACE;

-- PARALLEL_PROBE mode, result and trace
evaluate 'PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0;
SHOW TRACE;

-- rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result
evaluate 'rows in the SINGLE mode result EXCEPT ALL the PARALLEL_PROBE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS single_minus_parallel_probe
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
) x;

-- rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result
evaluate 'rows in the PARALLEL_PROBE mode result EXCEPT ALL the SINGLE mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_probe_minus_single
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND MOD (CAST (ta.ca AS INT) + CAST (tb.ca AS INT), 16) = 0
) x;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-11: tc SEMI JOIN td, ON clause term on both tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-11: tc SEMI JOIN td, ON clause term on both tables';

-- PARTITION mode, result
evaluate 'PARTITION mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;

-- PARTITION mode, trace
evaluate 'PARTITION mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;
SHOW TRACE;

-- PARALLEL mode, result and trace
evaluate 'PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM tc
  SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;
SHOW TRACE;

-- rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS partition_minus_parallel
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
) x;

-- rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_minus_partition
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    SEMI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
) x;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-05-12: tc ANTI JOIN td, ON clause term on both tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-05-12: tc ANTI JOIN td, ON clause term on both tables';

-- PARTITION mode, result
evaluate 'PARTITION mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;

-- PARTITION mode, trace
evaluate 'PARTITION mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;
SHOW TRACE;

-- PARALLEL mode, result and trace
evaluate 'PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM tc
  ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0;
SHOW TRACE;

-- rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result
evaluate 'rows in the PARTITION mode result EXCEPT ALL the PARALLEL mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS partition_minus_parallel
FROM (
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
) x;

-- rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result
evaluate 'rows in the PARALLEL mode result EXCEPT ALL the PARTITION mode result';
SELECT /*+ RECOMPILE */ COUNT (*) AS parallel_minus_partition
FROM (
  SELECT /*+ USE_HASH PARALLEL(4) */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
  EXCEPT ALL
  SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN */ tc.ca
  FROM tc
    ANTI JOIN td ON td.ca = tc.ca AND MOD (CAST (tc.ca AS INT) + CAST (td.ca AS INT), 16) = 0
) x;

-- =====================================================================================================================
-- TC-1-06: LEFT/RIGHT OUTER JOIN in four hash join modes
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-06-01: ta LEFT OUTER JOIN tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-06-01: ta LEFT OUTER JOIN tb';

-- SINGLE mode, result
evaluate 'SINGLE mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*), COUNT (tb.ca)
FROM ta
  LEFT JOIN tb ON tb.ca = ta.ca;

-- SINGLE mode, trace
evaluate 'SINGLE mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*), COUNT (tb.ca)
FROM ta
  LEFT JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- PARALLEL_PROBE mode, result and trace
evaluate 'PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*), COUNT (tb.ca)
FROM ta
  LEFT JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-06-02: ta RIGHT OUTER JOIN tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-06-02: ta RIGHT OUTER JOIN tb';

-- SINGLE mode, result
evaluate 'SINGLE mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*), COUNT (ta.ca)
FROM ta
  RIGHT JOIN tb ON tb.ca = ta.ca;

-- SINGLE mode, trace
evaluate 'SINGLE mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*), COUNT (ta.ca)
FROM ta
  RIGHT JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- PARALLEL_PROBE mode, result and trace
evaluate 'PARALLEL_PROBE mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*), COUNT (ta.ca)
FROM ta
  RIGHT JOIN tb ON tb.ca = ta.ca;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-06-03: tc LEFT OUTER JOIN td
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-06-03: tc LEFT OUTER JOIN td';

-- PARTITION mode, result
evaluate 'PARTITION mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*), COUNT (td.ca)
FROM tc
  LEFT JOIN td ON td.ca = tc.ca;

-- PARTITION mode, trace
evaluate 'PARTITION mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*), COUNT (td.ca)
FROM tc
  LEFT JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- PARALLEL mode, result and trace
evaluate 'PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*), COUNT (td.ca)
FROM tc
  LEFT JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-06-04: tc RIGHT OUTER JOIN td
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-06-04: tc RIGHT OUTER JOIN td';

-- PARTITION mode, result
evaluate 'PARTITION mode, result';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*), COUNT (tc.ca)
FROM tc
  RIGHT JOIN td ON td.ca = tc.ca;

-- PARTITION mode, trace
evaluate 'PARTITION mode, trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*), COUNT (tc.ca)
FROM tc
  RIGHT JOIN td ON td.ca = tc.ca;
SHOW TRACE;

-- PARALLEL mode, result and trace
evaluate 'PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*), COUNT (tc.ca)
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

-- te: 300000 rows of LPAD (2, 200, '0'), and one NULL row
--   ROWNUM 1       -> '0000...0002'    199 '0' + '2'
--   ...
--   ROWNUM 300000  -> '0000...0002'    199 '0' + '2'
--   NULL
--   Stored: 300001 rows, key 2 in 300000 rows, and 1 NULL
DROP TABLE IF EXISTS te;
CREATE TABLE te (ca CHAR(200));
INSERT INTO te
WITH RECURSIVE cte (n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 600
)
SELECT LPAD (2, 200, '0')
FROM cte x, cte y
WHERE ROWNUM <= 300000;
INSERT INTO te VALUES (NULL);
UPDATE STATISTICS ON te;

-- PARTITION mode, result and trace
evaluate 'PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  SEMI JOIN te ON te.ca = tc.ca;
SHOW TRACE;

-- PARALLEL mode, result and trace
evaluate 'PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM tc
  SEMI JOIN te ON te.ca = tc.ca;
SHOW TRACE;

-- cleanup
DROP TABLE IF EXISTS te;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-07-02: ANTI JOIN, partitions without inner rows
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-07-02: ANTI JOIN, partitions without inner rows';

-- te: 300000 rows of LPAD (2, 200, '0'), and one NULL row
--   ROWNUM 1       -> '0000...0002'    199 '0' + '2'
--   ...
--   ROWNUM 300000  -> '0000...0002'    199 '0' + '2'
--   NULL
--   Stored: 300001 rows, key 2 in 300000 rows, and 1 NULL
DROP TABLE IF EXISTS te;
CREATE TABLE te (ca CHAR(200));
INSERT INTO te
WITH RECURSIVE cte (n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 600
)
SELECT LPAD (2, 200, '0')
FROM cte x, cte y
WHERE ROWNUM <= 300000;
INSERT INTO te VALUES (NULL);
UPDATE STATISTICS ON te;

-- PARTITION mode, result and trace
evaluate 'PARTITION mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_HASH_JOIN */ COUNT (*)
FROM tc
  ANTI JOIN te ON te.ca = tc.ca;
SHOW TRACE;

-- PARALLEL mode, result and trace
evaluate 'PARALLEL mode, result and trace';
SELECT /*+ RECOMPILE USE_HASH PARALLEL(4) */ COUNT (*)
FROM tc
  ANTI JOIN te ON te.ca = tc.ca;
SHOW TRACE;

-- cleanup
DROP TABLE IF EXISTS te, td, tc, tb, ta;

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
UPDATE STATISTICS ON ta, tb;

-- hash join, result and trace
evaluate 'hash join, result and trace';
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
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
UPDATE STATISTICS ON ta, tb;

-- hash join
evaluate 'hash join';
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;

-- cleanup
SET TRACE OFF;
DROP TABLE IF EXISTS tb, ta;

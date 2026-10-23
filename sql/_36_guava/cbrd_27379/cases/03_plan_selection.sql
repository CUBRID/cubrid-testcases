/**
 *  This test case verifies CBRD-27379: SEMI JOIN and ANTI JOIN run as a hash join.
 *  AC-2: plan selection (TC-2-01).
 *
 *  Before the fix, the planner skipped hash join costing for SEMI / ANTI JOIN. Now a hash join is a candidate for them,
 *  and USE_HASH / NO_USE_HASH decide the join method whether the hint is written in the outer query
 *  or in the subquery that is unnested into the SEMI / ANTI JOIN.
 *
 *  Coverage:
 *    TC-2-01-01, 02:   SEMI JOIN and ANTI JOIN with USE_HASH and with NO_USE_HASH
 *    TC-2-01-03:       unnested NOT IN with USE_HASH
 *    TC-2-01-04:       EXISTS / NOT EXISTS with an index on tb.ca, without a hint and with USE_HASH
 *                      in the outer query, USE_HASH or USE_HASH(tb) in the subquery
 *    TC-2-01-05:       EXISTS / NOT EXISTS without an index on tb.ca, without a hint and with NO_USE_HASH
 *                      in the outer query, NO_USE_HASH or NO_USE_HASH(tb) in the subquery
 *
 *  Sub-cases:
 *    No  Sub-case    Query                         Case
 *    1   TC-2-01-01  ta SEMI JOIN tb               USE_HASH, NO_USE_HASH
 *    2   TC-2-01-02  ta ANTI JOIN tb               USE_HASH, NO_USE_HASH
 *    3   TC-2-01-03  NOT IN subquery               USE_HASH
 *    4   TC-2-01-04  EXISTS / NOT EXISTS subquery  index on tb.ca: no hint, USE_HASH, USE_HASH(tb)
 *    5   TC-2-01-05  EXISTS / NOT EXISTS subquery  no index on tb.ca: no hint, NO_USE_HASH, NO_USE_HASH(tb)
 *
 *  CTP masks the numbers in a --@queryplan output, so cost and cardinality are not compared.
 *  Each step asserts the result rows and the plan: the join method, the join type and the scans.
 */

-- =====================================================================================================================
-- TC-2-01: USE_HASH / NO_USE_HASH hints and where they are written
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-01: SEMI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-01: SEMI JOIN';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3);
INSERT INTO tb VALUES (1), (1), (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-2-01-01-01: USE_HASH, result and plan
evaluate 'TC-2-01-01-01: USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;

-- TC-2-01-01-02: NO_USE_HASH, result and plan
evaluate 'TC-2-01-01-02: NO_USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-02: ANTI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-02: ANTI JOIN';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3);
INSERT INTO tb VALUES (1), (1), (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-2-01-02-01: USE_HASH, result and plan
evaluate 'TC-2-01-02-01: USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;

-- TC-2-01-02-02: NO_USE_HASH, result and plan
evaluate 'TC-2-01-02-02: NO_USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-03: NOT IN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-03: NOT IN';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT NOT NULL);
CREATE TABLE tb (ca INT PRIMARY KEY);
INSERT INTO ta VALUES (1, 1000), (2, 2000), (3, 1000), (4, 9999), (5, 1000);
INSERT INTO tb VALUES (1000), (2000);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-2-01-03-01: USE_HASH, result and plan
evaluate 'TC-2-01-03-01: USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
WHERE ta.cb NOT IN (SELECT ca FROM tb);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-04: index on tb.ca, USE_HASH
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-04: index on tb.ca, USE_HASH';

DROP TABLE IF EXISTS tb, ta;
-- ta: 2000 rows of ROWNUM
--   Stored: 2000 rows, keys 1 .. 2000 with 1 row per key
CREATE TABLE ta (ca INT);
INSERT INTO ta
  WITH RECURSIVE cte (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 50
  )
  SELECT ROWNUM
  FROM cte x, cte y
  WHERE ROWNUM <= 2000;

-- tb: 2000 rows of MOD (ROWNUM, 500)
--   Stored: 2000 rows, keys 0 .. 499 with 4 rows per key
CREATE TABLE tb (ca INT);
INSERT INTO tb
  WITH RECURSIVE cte (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 50
  )
  SELECT MOD (ROWNUM, 500)
  FROM cte x, cte y
  WHERE ROWNUM <= 2000;
CREATE INDEX i_tb_ca ON tb (ca);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-2-01-04-01: EXISTS, no hint, result and plan
evaluate 'TC-2-01-04-01: EXISTS, no hint, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-04-02: EXISTS, outer query USE_HASH, result and plan
evaluate 'TC-2-01-04-02: EXISTS, outer query USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-04-03: EXISTS, subquery USE_HASH, result and plan
evaluate 'TC-2-01-04-03: EXISTS, subquery USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT /*+ USE_HASH */ 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-04-04: EXISTS, subquery USE_HASH(tb), result and plan
evaluate 'TC-2-01-04-04: EXISTS, subquery USE_HASH(tb), result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT /*+ USE_HASH(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-04-05: NOT EXISTS, no hint, result and plan
evaluate 'TC-2-01-04-05: NOT EXISTS, no hint, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-04-06: NOT EXISTS, outer query USE_HASH, result and plan
evaluate 'TC-2-01-04-06: NOT EXISTS, outer query USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-04-07: NOT EXISTS, subquery USE_HASH, result and plan
evaluate 'TC-2-01-04-07: NOT EXISTS, subquery USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ USE_HASH */ 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-04-08: NOT EXISTS, subquery USE_HASH(tb), result and plan
evaluate 'TC-2-01-04-08: NOT EXISTS, subquery USE_HASH(tb), result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ USE_HASH(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-05: no index on tb.ca, NO_USE_HASH
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-05: no index on tb.ca, NO_USE_HASH';

DROP TABLE IF EXISTS tb, ta;
-- ta: 2000 rows of ROWNUM
--   Stored: 2000 rows, keys 1 .. 2000 with 1 row per key
CREATE TABLE ta (ca INT);
INSERT INTO ta
  WITH RECURSIVE cte (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 50
  )
  SELECT ROWNUM
  FROM cte x, cte y
  WHERE ROWNUM <= 2000;

-- tb: 2000 rows of MOD (ROWNUM, 500)
--   Stored: 2000 rows, keys 0 .. 499 with 4 rows per key
CREATE TABLE tb (ca INT);
INSERT INTO tb
  WITH RECURSIVE cte (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 50
  )
  SELECT MOD (ROWNUM, 500)
  FROM cte x, cte y
  WHERE ROWNUM <= 2000;

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-2-01-05-01: EXISTS, no join method hint (ORDERED keeps the DISTINCT form of tb out), result and plan
evaluate 'TC-2-01-05-01: EXISTS, no join method hint, result and plan';
--@queryplan
SELECT /*+ RECOMPILE ORDERED */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-05-02: EXISTS, outer query NO_USE_HASH, result and plan
evaluate 'TC-2-01-05-02: EXISTS, outer query NO_USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-05-03: EXISTS, subquery NO_USE_HASH, result and plan
evaluate 'TC-2-01-05-03: EXISTS, subquery NO_USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT /*+ NO_USE_HASH */ 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-05-04: EXISTS, subquery NO_USE_HASH(tb), result and plan
evaluate 'TC-2-01-05-04: EXISTS, subquery NO_USE_HASH(tb), result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT /*+ NO_USE_HASH(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-05-05: NOT EXISTS, no hint, result and plan
evaluate 'TC-2-01-05-05: NOT EXISTS, no hint, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-05-06: NOT EXISTS, outer query NO_USE_HASH, result and plan
evaluate 'TC-2-01-05-06: NOT EXISTS, outer query NO_USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-05-07: NOT EXISTS, subquery NO_USE_HASH, result and plan
evaluate 'TC-2-01-05-07: NOT EXISTS, subquery NO_USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ NO_USE_HASH */ 1 FROM tb WHERE tb.ca = ta.ca);

-- TC-2-01-05-08: NOT EXISTS, subquery NO_USE_HASH(tb), result and plan
evaluate 'TC-2-01-05-08: NOT EXISTS, subquery NO_USE_HASH(tb), result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ NO_USE_HASH(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

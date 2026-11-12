/**
 *  This test case verifies CBRD-27379: SEMI JOIN and ANTI JOIN run as a hash join.
 *  AC-2: plan selection (TC 1 to TC 6).
 *
 *  Before the fix, the planner skipped hash join costing for SEMI / ANTI JOIN. Now a hash join is a candidate for them,
 *  and USE_HASH / NO_USE_HASH decide the join method whether the hint is written in the outer query
 *  or in the subquery that is unnested into the SEMI / ANTI JOIN.
 *
 *  Coverage:
 *    TC 1, 2: SEMI JOIN and ANTI JOIN with USE_HASH and with NO_USE_HASH
 *    TC 3:    unnested NOT IN with USE_HASH
 *    TC 4:    EXISTS / NOT EXISTS with an index on tb.ca, without a hint and with USE_HASH
 *             in the outer query, USE_HASH or USE_HASH(tb) in the subquery
 *    TC 5:    EXISTS / NOT EXISTS without an index on tb.ca, without a hint and with NO_USE_HASH
 *             in the outer query, NO_USE_HASH or NO_USE_HASH(tb) in the subquery
 *    TC 6:    USE_MERGE does not apply to an ANTI JOIN, which has no merge join: it stays a hash join,
 *             while an INNER JOIN of the same tables becomes a merge join
 *
 *  Sub-cases:
 *    Sub-case  Query                         Case
 *    TC 1      ta SEMI JOIN tb               USE_HASH, NO_USE_HASH
 *    TC 2      ta ANTI JOIN tb               USE_HASH, NO_USE_HASH
 *    TC 3      NOT IN subquery               USE_HASH
 *    TC 4      EXISTS / NOT EXISTS subquery  index on tb.ca: no hint, USE_HASH, USE_HASH(tb)
 *    TC 5      EXISTS / NOT EXISTS subquery  no index on tb.ca: no hint, NO_USE_HASH, NO_USE_HASH(tb)
 *    TC 6      ANTI JOIN, NOT EXISTS         USE_MERGE, subquery USE_MERGE(tb), INNER JOIN with USE_MERGE
 *
 *  CTP masks the numbers in a --@queryplan output, so cost and cardinality are not compared.
 *  Each step asserts the result rows and the plan: the join method, the join type and the scans.
 */

-- =====================================================================================================================
-- TC : USE_HASH / NO_USE_HASH hints and where they are written
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1: SEMI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1: SEMI JOIN';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3);
INSERT INTO tb VALUES (1), (1), (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 1-1: USE_HASH, result and plan
evaluate 'TC 1-1: USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;

-- TC 1-2: NO_USE_HASH, result and plan
evaluate 'TC 1-2: NO_USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2: ANTI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2: ANTI JOIN';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3);
INSERT INTO tb VALUES (1), (1), (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 2-1: USE_HASH, result and plan
evaluate 'TC 2-1: USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;

-- TC 2-2: NO_USE_HASH, result and plan
evaluate 'TC 2-2: NO_USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3: NOT IN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3: NOT IN';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT NOT NULL);
CREATE TABLE tb (ca INT PRIMARY KEY);
INSERT INTO ta VALUES (1, 1000), (2, 2000), (3, 1000), (4, 9999), (5, 1000);
INSERT INTO tb VALUES (1000), (2000);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 3-1: USE_HASH, result and plan
evaluate 'TC 3-1: USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
WHERE ta.cb NOT IN (SELECT ca FROM tb);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4: index on tb.ca, USE_HASH
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4: index on tb.ca, USE_HASH';

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

-- TC 4-1: EXISTS, no hint, result and plan
evaluate 'TC 4-1: EXISTS, no hint, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 4-2: EXISTS, outer query USE_HASH, result and plan
evaluate 'TC 4-2: EXISTS, outer query USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 4-3: EXISTS, subquery USE_HASH, result and plan
evaluate 'TC 4-3: EXISTS, subquery USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT /*+ USE_HASH */ 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 4-4: EXISTS, subquery USE_HASH(tb), result and plan
evaluate 'TC 4-4: EXISTS, subquery USE_HASH(tb), result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT /*+ USE_HASH(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 4-5: NOT EXISTS, no hint, result and plan
evaluate 'TC 4-5: NOT EXISTS, no hint, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 4-6: NOT EXISTS, outer query USE_HASH, result and plan
evaluate 'TC 4-6: NOT EXISTS, outer query USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 4-7: NOT EXISTS, subquery USE_HASH, result and plan
evaluate 'TC 4-7: NOT EXISTS, subquery USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ USE_HASH */ 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 4-8: NOT EXISTS, subquery USE_HASH(tb), result and plan
evaluate 'TC 4-8: NOT EXISTS, subquery USE_HASH(tb), result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ USE_HASH(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 5: no index on tb.ca, NO_USE_HASH
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 5: no index on tb.ca, NO_USE_HASH';

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

-- TC 5-1: EXISTS, no join method hint (ORDERED keeps the DISTINCT form of tb out), result and plan
evaluate 'TC 5-1: EXISTS, no join method hint, result and plan';
--@queryplan
SELECT /*+ RECOMPILE ORDERED */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 5-2: EXISTS, outer query NO_USE_HASH, result and plan
evaluate 'TC 5-2: EXISTS, outer query NO_USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 5-3: EXISTS, subquery NO_USE_HASH, result and plan
evaluate 'TC 5-3: EXISTS, subquery NO_USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT /*+ NO_USE_HASH */ 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 5-4: EXISTS, subquery NO_USE_HASH(tb), result and plan
evaluate 'TC 5-4: EXISTS, subquery NO_USE_HASH(tb), result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT /*+ NO_USE_HASH(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 5-5: NOT EXISTS, no hint, result and plan
evaluate 'TC 5-5: NOT EXISTS, no hint, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 5-6: NOT EXISTS, outer query NO_USE_HASH, result and plan
evaluate 'TC 5-6: NOT EXISTS, outer query NO_USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 5-7: NOT EXISTS, subquery NO_USE_HASH, result and plan
evaluate 'TC 5-7: NOT EXISTS, subquery NO_USE_HASH, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ NO_USE_HASH */ 1 FROM tb WHERE tb.ca = ta.ca);

-- TC 5-8: NOT EXISTS, subquery NO_USE_HASH(tb), result and plan
evaluate 'TC 5-8: NOT EXISTS, subquery NO_USE_HASH(tb), result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ NO_USE_HASH(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 6: USE_MERGE and an ANTI JOIN, on the tables of TC 5
--   There is no merge join for a SEMI JOIN or an ANTI JOIN, so the planner does not apply USE_MERGE to their inner
--   input and keeps the hash join a candidate. The INNER JOIN shows that the same hint makes a merge join otherwise.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 6: USE_MERGE and an ANTI JOIN';

-- TC 6-1: INNER JOIN, outer query USE_MERGE, result and plan
evaluate 'TC 6-1: INNER JOIN, outer query USE_MERGE, merge join, result = 1996';
--@queryplan
SELECT /*+ RECOMPILE USE_MERGE */ COUNT (*)
FROM ta
  JOIN tb ON tb.ca = ta.ca;

-- TC 6-2: ANTI JOIN, outer query USE_MERGE, result and plan
evaluate 'TC 6-2: ANTI JOIN, outer query USE_MERGE, hash join, result = 1501';
--@queryplan
SELECT /*+ RECOMPILE USE_MERGE */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;

-- TC 6-3: NOT EXISTS, subquery USE_MERGE(tb), result and plan
evaluate 'TC 6-3: NOT EXISTS, subquery USE_MERGE(tb), hash join, result = 1501';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ USE_MERGE(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

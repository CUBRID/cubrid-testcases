/**
 *  This test case verifies CBRD-27379: SEMI JOIN and ANTI JOIN run as a hash join.
 *  AC-1: results of the hash join (TC 1 to TC 4).
 *
 *  Before the fix, SEMI JOIN and ANTI JOIN ran only as a nested loop join. The fix adds a hash join path for both:
 *  SEMI stops probing at the first match of an outer row, ANTI outputs an outer row only when no inner row matches.
 *
 *  Coverage:
 *    TC 1: duplicate inner keys and NULL keys, for explicit SEMI / ANTI JOIN
 *          and for unnested EXISTS / NOT EXISTS / IN / NOT IN subqueries.
 *          An unnested query is followed by the same query with NO_UNNEST, and the two results must match
 *    TC 2: empty inner table and empty outer table, and an empty derived table as the inner input,
 *          whose result is known before the outer runs: SEMI skips the outer scan, ANTI scans it
 *    TC 3: ON clause with terms other than the equi-join term
 *    TC 4: ROWNUM, LIMIT, several joins in one query, two-column join key
 *
 *  Sub-cases:
 *    Sub-case  Query                         Case
 *    TC 1-1    ta SEMI JOIN tb               duplicate inner keys, NULL keys
 *    TC 1-2    ta ANTI JOIN tb               duplicate inner keys, NULL keys
 *    TC 1-3    EXISTS subquery               duplicate inner keys, NULL keys
 *    TC 1-4    NOT EXISTS subquery           duplicate inner keys, NULL keys
 *    TC 1-5    IN subquery                   duplicate inner keys, NULL keys
 *    TC 1-6    NOT IN subquery               NOT NULL keys, no duplicate inner keys
 *    TC 2-1    ta SEMI JOIN tb               empty inner table
 *    TC 2-2    ta ANTI JOIN tb               empty inner table
 *    TC 2-3    ta SEMI JOIN tb               empty outer table
 *    TC 2-4    ta ANTI JOIN tb               empty outer table
 *    TC 2-5    ta SEMI JOIN derived table    empty derived table, outer scan skipped
 *    TC 2-6    ta ANTI JOIN derived table    empty derived table, outer scan kept
 *    TC 3-1    ta SEMI JOIN tb               ON terms tb.cb > ta.cb, ta.cc IS NOT NULL
 *    TC 3-2    ta ANTI JOIN tb               ON terms tb.cb > ta.cb, ta.cc IS NOT NULL
 *    TC 3-3    ta SEMI JOIN tb               ON term tb.cb > 20
 *    TC 3-4    ta ANTI JOIN tb               ON term tb.cb > 20
 *    TC 4-1    ta SEMI JOIN tb               ROWNUM
 *    TC 4-2    ta ANTI JOIN tb               LIMIT
 *    TC 4-3    ta SEMI JOIN tb ANTI JOIN tc  two joins in one query
 *    TC 4-4    ta JOIN tb SEMI JOIN tc       two joins in one query
 *    TC 4-5    ta SEMI JOIN tb               two-column join key
 *    TC 4-6    ta ANTI JOIN tb               two-column join key
 *
 *  TC 3 and the two-column key cases of TC 4 compare the hash join result with the nested loop join result
 *  by EXCEPT ALL in both directions. Both counts must be 0. Each sub-case recreates its tables.
 *  CTP masks the numbers in a --@queryplan output, so cost and cardinality are not compared.
 *  The plans of TC 1-3 to TC 1-6 assert that the unnested query runs as
 *  hash-join (semi join) / hash-join (anti join) and the NO_UNNEST query keeps its subquery.
 */

-- =====================================================================================================================
-- TC 1: duplicate inner keys and NULL keys; unnested subqueries return the same result
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-1: SEMI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-1: SEMI JOIN';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3), (NULL);
INSERT INTO tb VALUES (1), (1), (1), (2), (NULL);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 1-1-1: hash join
evaluate 'TC 1-1-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-2: ANTI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-2: ANTI JOIN';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3), (NULL);
INSERT INTO tb VALUES (1), (1), (1), (2), (NULL);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 1-2-1: hash join
evaluate 'TC 1-2-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-3: EXISTS subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-3: EXISTS subquery';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3), (NULL);
INSERT INTO tb VALUES (1), (1), (1), (2), (NULL);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 1-3-1: unnested, hash join, result and plan
evaluate 'TC 1-3-1: unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- TC 1-3-2: not unnested, result and plan
evaluate 'TC 1-3-2: not unnested, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE EXISTS (SELECT /*+ NO_UNNEST */ 1 FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-4: NOT EXISTS subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-4: NOT EXISTS subquery';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3), (NULL);
INSERT INTO tb VALUES (1), (1), (1), (2), (NULL);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 1-4-1: unnested, hash join, result and plan
evaluate 'TC 1-4-1: unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- TC 1-4-2: not unnested, result and plan
evaluate 'TC 1-4-2: not unnested, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE NOT EXISTS (SELECT /*+ NO_UNNEST */ 1 FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-5: IN subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-5: IN subquery';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3), (NULL);
INSERT INTO tb VALUES (1), (1), (1), (2), (NULL);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 1-5-1: unnested, hash join, result and plan
evaluate 'TC 1-5-1: unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
WHERE ta.ca IN (SELECT tb.ca FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- TC 1-5-2: not unnested, result and plan
evaluate 'TC 1-5-2: not unnested, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE ta.ca IN (SELECT /*+ NO_UNNEST */ tb.ca FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-6: NOT IN subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-6: NOT IN subquery';

-- NOT IN is unnested only when both join columns are NOT NULL or PRIMARY KEY,
-- so this sub-case has neither NULL keys nor duplicate inner keys
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT NOT NULL);
CREATE TABLE tb (ca INT PRIMARY KEY);
INSERT INTO ta VALUES (1, 1000), (2, 2000), (3, 1000), (4, 9999), (5, 1000);
INSERT INTO tb VALUES (1000), (2000);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 1-6-1: unnested, hash join, result and plan
evaluate 'TC 1-6-1: unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
WHERE ta.cb NOT IN (SELECT ca FROM tb)
ORDER BY 1;

-- TC 1-6-2: not unnested, result and plan
evaluate 'TC 1-6-2: not unnested, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE ta.cb NOT IN (SELECT /*+ NO_UNNEST */ ca FROM tb)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- =====================================================================================================================
-- TC 2: empty inner or outer input
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-1: SEMI JOIN, empty inner table
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-1: SEMI JOIN, empty inner table';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 2-1-1: hash join
evaluate 'TC 2-1-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-2: ANTI JOIN, empty inner table
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-2: ANTI JOIN, empty inner table';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 2-2-1: hash join
evaluate 'TC 2-2-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-3: SEMI JOIN, empty outer table
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-3: SEMI JOIN, empty outer table';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO tb VALUES (1), (1), (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 2-3-1: hash join
evaluate 'TC 2-3-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-4: ANTI JOIN, empty outer table
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-4: ANTI JOIN, empty outer table';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO tb VALUES (1), (1), (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 2-4-1: hash join
evaluate 'TC 2-4-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-5: SEMI JOIN, empty derived table as the inner input
--   The derived table runs before the hash join. Once it is empty, a SEMI JOIN has no result, so the outer scan of ta
--   is skipped and the trace shows it as noscan.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-5: SEMI JOIN, empty derived table as the inner input';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 2-5-1: hash join, result and trace
evaluate 'TC 2-5-1: hash join skips the scan of ta, result = no rows';
SET TRACE ON;
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ ta.ca
FROM ta
  SEMI JOIN (SELECT ca FROM tb WHERE ca > 0) d ON d.ca = ta.ca
ORDER BY 1;
SHOW TRACE;
SET TRACE OFF;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-6: ANTI JOIN, empty derived table as the inner input
--   Every outer row of an ANTI JOIN is unmatched when the inner input is empty, so the outer scan of ta must still run.
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-6: ANTI JOIN, empty derived table as the inner input';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 2-6-1: hash join, result and trace
evaluate 'TC 2-6-1: hash join scans ta, result = 1, 2, 3';
SET TRACE ON;
SELECT /*+ RECOMPILE USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ ta.ca
FROM ta
  ANTI JOIN (SELECT ca FROM tb WHERE ca > 0) d ON d.ca = ta.ca
ORDER BY 1;
SHOW TRACE;
SET TRACE OFF;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- =====================================================================================================================
-- TC 3: ON clause with terms other than the equi-join term
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-1: SEMI JOIN, first ON clause
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-1: SEMI JOIN, first ON clause';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL), (4, 200, 4), (5, 1, NULL);
INSERT INTO tb VALUES (1, 25), (1, 15), (1, 5), (2, 100), (4, 10), (5, 50);
CREATE INDEX i_tb_ca ON tb (ca);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 3-1-1: hash join
evaluate 'TC 3-1-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > ta.cb AND ta.cc IS NOT NULL
ORDER BY 1;

-- TC 3-1-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 3-1-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > ta.cb AND ta.cc IS NOT NULL
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > ta.cb AND ta.cc IS NOT NULL
) r;

-- TC 3-1-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 3-1-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > ta.cb AND ta.cc IS NOT NULL
  EXCEPT ALL
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > ta.cb AND ta.cc IS NOT NULL
) r;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-2: ANTI JOIN, first ON clause
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-2: ANTI JOIN, first ON clause';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL), (4, 200, 4), (5, 1, NULL);
INSERT INTO tb VALUES (1, 25), (1, 15), (1, 5), (2, 100), (4, 10), (5, 50);
CREATE INDEX i_tb_ca ON tb (ca);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 3-2-1: hash join
evaluate 'TC 3-2-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > ta.cb AND ta.cc IS NOT NULL
ORDER BY 1;

-- TC 3-2-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 3-2-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > ta.cb AND ta.cc IS NOT NULL
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > ta.cb AND ta.cc IS NOT NULL
) r;

-- TC 3-2-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 3-2-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > ta.cb AND ta.cc IS NOT NULL
  EXCEPT ALL
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > ta.cb AND ta.cc IS NOT NULL
) r;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-3: SEMI JOIN, second ON clause
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-3: SEMI JOIN, second ON clause';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1), (2), (3), (4), (5);
INSERT INTO tb VALUES (1, 25), (1, 15), (1, 5), (2, 100), (4, 10), (5, 50);
CREATE INDEX i_tb_ca ON tb (ca);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 3-3-1: hash join
evaluate 'TC 3-3-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > 20
ORDER BY 1;

-- TC 3-3-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 3-3-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > 20
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > 20
) r;

-- TC 3-3-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 3-3-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > 20
  EXCEPT ALL
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > 20
) r;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-4: ANTI JOIN, second ON clause
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-4: ANTI JOIN, second ON clause';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1), (2), (3), (4), (5);
INSERT INTO tb VALUES (1, 25), (1, 15), (1, 5), (2, 100), (4, 10), (5, 50);
CREATE INDEX i_tb_ca ON tb (ca);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 3-4-1: hash join
evaluate 'TC 3-4-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > 20
ORDER BY 1;

-- TC 3-4-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 3-4-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > 20
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > 20
) r;

-- TC 3-4-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 3-4-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > 20
  EXCEPT ALL
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > 20
) r;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- =====================================================================================================================
-- TC 4: ROWNUM and LIMIT, multiple joins, two-column join key
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-1: SEMI JOIN, ROWNUM
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-1: SEMI JOIN, ROWNUM';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (3), (4), (1), (2);
INSERT INTO tb VALUES (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 4-1-1: hash join
evaluate 'TC 4-1-1: hash join';
SELECT /*+ RECOMPILE */ COUNT (*)
FROM (
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca
  WHERE ROWNUM <= 1
) r;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-2: ANTI JOIN, LIMIT
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-2: ANTI JOIN, LIMIT';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3), (4);
INSERT INTO tb VALUES (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 4-2-1: hash join
evaluate 'TC 4-2-1: hash join';
SELECT /*+ RECOMPILE */ COUNT (*)
FROM (
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca
  LIMIT 1
) r;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-3: SEMI JOIN + ANTI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-3: SEMI JOIN + ANTI JOIN';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT);
CREATE TABLE tc (ca INT);
INSERT INTO ta VALUES (1, 10, 100), (2, 10, 200), (3, 20, 100), (4, 20, 300), (5, 20, 300);
INSERT INTO tb VALUES (10), (20);
INSERT INTO tc VALUES (300), (999);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 4-3-1: hash join
evaluate 'TC 4-3-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON ta.cb = tb.ca
  ANTI JOIN tc ON tc.ca = ta.cc
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-4: INNER JOIN + SEMI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-4: INNER JOIN + SEMI JOIN';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT);
CREATE TABLE tc (ca INT);
INSERT INTO ta VALUES (1, 10, 100), (2, 10, 200), (3, 20, 100), (4, 20, 300), (5, 20, 300);
INSERT INTO tb VALUES (10), (20);
INSERT INTO tc VALUES (300), (999);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 4-4-1: hash join
evaluate 'TC 4-4-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  JOIN tb ON ta.cb = tb.ca
  SEMI JOIN tc ON tc.ca = ta.cc
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-5: SEMI JOIN, two-column join key
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-5: SEMI JOIN, two-column join key';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (1, 2), (2, NULL), (NULL, 1), (3, 3);
INSERT INTO tb VALUES (1, 1), (1, 1), (2, 2), (NULL, 1), (3, NULL);
CREATE INDEX i_tb_ca_cb ON tb (ca, cb);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 4-5-1: hash join
evaluate 'TC 4-5-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca, ta.cb
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb = ta.cb
ORDER BY 1, 2;

-- TC 4-5-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 4-5-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ ta.ca, ta.cb
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb = ta.cb
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, ta.cb
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb = ta.cb
) r;

-- TC 4-5-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 4-5-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, ta.cb
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb = ta.cb
  EXCEPT ALL
  SELECT /*+ USE_HASH */ ta.ca, ta.cb
  FROM ta
    SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb = ta.cb
) r;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-6: ANTI JOIN, two-column join key
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-6: ANTI JOIN, two-column join key';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (1, 2), (2, NULL), (NULL, 1), (3, 3);
INSERT INTO tb VALUES (1, 1), (1, 1), (2, 2), (NULL, 1), (3, NULL);
CREATE INDEX i_tb_ca_cb ON tb (ca, cb);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 4-6-1: hash join
evaluate 'TC 4-6-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca, ta.cb
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb = ta.cb
ORDER BY 1, 2;

-- TC 4-6-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 4-6-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ ta.ca, ta.cb
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb = ta.cb
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, ta.cb
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb = ta.cb
) r;

-- TC 4-6-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 4-6-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, ta.cb
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb = ta.cb
  EXCEPT ALL
  SELECT /*+ USE_HASH */ ta.ca, ta.cb
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb = ta.cb
) r;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

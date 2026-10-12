/**
 *  This test case verifies CBRD-27379: SEMI JOIN and ANTI JOIN run as a hash join.
 *  AC-1: results of the hash join (TC-1-01 to TC-1-04).
 *
 *  Before the fix, SEMI JOIN and ANTI JOIN ran only as a nested loop join. The fix adds a hash join path for both:
 *  SEMI stops probing at the first match of an outer row, ANTI outputs an outer row only when no inner row matches.
 *
 *  Coverage:
 *    TC-1-01: duplicate inner keys and NULL keys, for explicit SEMI / ANTI JOIN
 *             and for unnested EXISTS / NOT EXISTS / IN / NOT IN subqueries.
 *             An unnested query is followed by the same query with NO_UNNEST, and the two results must match
 *    TC-1-02: empty inner table and empty outer table
 *    TC-1-03: ON clause with terms other than the equi-join term
 *    TC-1-04: ROWNUM, LIMIT, several joins in one query, two-column join key
 *
 *  Sub-cases:
 *    No  Sub-case    Query                         Case
 *    1   TC-1-01-01  ta SEMI JOIN tb               duplicate inner keys, NULL keys
 *    2   TC-1-01-02  ta ANTI JOIN tb               duplicate inner keys, NULL keys
 *    3   TC-1-01-03  EXISTS subquery               duplicate inner keys, NULL keys
 *    4   TC-1-01-04  NOT EXISTS subquery           duplicate inner keys, NULL keys
 *    5   TC-1-01-05  IN subquery                   duplicate inner keys, NULL keys
 *    6   TC-1-01-06  NOT IN subquery               NOT NULL keys, no duplicate inner keys
 *    7   TC-1-02-01  ta SEMI JOIN tb               empty inner table
 *    8   TC-1-02-02  ta ANTI JOIN tb               empty inner table
 *    9   TC-1-02-03  ta SEMI JOIN tb               empty outer table
 *    10  TC-1-02-04  ta ANTI JOIN tb               empty outer table
 *    11  TC-1-03-01  ta SEMI JOIN tb               ON terms tb.cb > ta.cb, ta.cc IS NOT NULL
 *    12  TC-1-03-02  ta ANTI JOIN tb               ON terms tb.cb > ta.cb, ta.cc IS NOT NULL
 *    13  TC-1-03-03  ta SEMI JOIN tb               ON term tb.cb > 20
 *    14  TC-1-03-04  ta ANTI JOIN tb               ON term tb.cb > 20
 *    15  TC-1-04-01  ta SEMI JOIN tb               ROWNUM
 *    16  TC-1-04-02  ta ANTI JOIN tb               LIMIT
 *    17  TC-1-04-03  ta SEMI JOIN tb ANTI JOIN tc  two joins in one query
 *    18  TC-1-04-04  ta JOIN tb SEMI JOIN tc       two joins in one query
 *    19  TC-1-04-05  ta SEMI JOIN tb               two-column join key
 *    20  TC-1-04-06  ta ANTI JOIN tb               two-column join key
 *
 *  TC-1-03 and the two-column key cases of TC-1-04 compare the hash join result with the nested loop join result
 *  by EXCEPT ALL in both directions. Both counts must be 0. Each sub-case recreates its tables.
 *  CTP runs with test_mode=yes, so cost and cardinality in a --@queryplan output are masked.
 *  The plans of TC-1-01-03 to TC-1-01-06 assert that the unnested query runs as
 *  hash-join (semi join) / hash-join (anti join) and the NO_UNNEST query keeps its subquery.
 */

-- =====================================================================================================================
-- TC-1-01: duplicate inner keys and NULL keys; unnested subqueries return the same result
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-01: SEMI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-01: SEMI JOIN';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3), (NULL);
INSERT INTO tb VALUES (1), (1), (1), (2), (NULL);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-01-01-01: hash join
evaluate 'TC-1-01-01-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-02: ANTI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-02: ANTI JOIN';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3), (NULL);
INSERT INTO tb VALUES (1), (1), (1), (2), (NULL);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-01-02-01: hash join
evaluate 'TC-1-01-02-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-03: EXISTS subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-03: EXISTS subquery';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3), (NULL);
INSERT INTO tb VALUES (1), (1), (1), (2), (NULL);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-01-03-01: unnested, hash join, result and plan
evaluate 'TC-1-01-03-01: unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- TC-1-01-03-02: not unnested, result and plan
evaluate 'TC-1-01-03-02: not unnested, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE EXISTS (SELECT /*+ NO_UNNEST */ 1 FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-04: NOT EXISTS subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-04: NOT EXISTS subquery';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3), (NULL);
INSERT INTO tb VALUES (1), (1), (1), (2), (NULL);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-01-04-01: unnested, hash join, result and plan
evaluate 'TC-1-01-04-01: unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- TC-1-01-04-02: not unnested, result and plan
evaluate 'TC-1-01-04-02: not unnested, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE NOT EXISTS (SELECT /*+ NO_UNNEST */ 1 FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-05: IN subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-05: IN subquery';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3), (NULL);
INSERT INTO tb VALUES (1), (1), (1), (2), (NULL);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-01-05-01: unnested, hash join, result and plan
evaluate 'TC-1-01-05-01: unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
WHERE ta.ca IN (SELECT tb.ca FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- TC-1-01-05-02: not unnested, result and plan
evaluate 'TC-1-01-05-02: not unnested, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE ta.ca IN (SELECT /*+ NO_UNNEST */ tb.ca FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-01-06: NOT IN subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-01-06: NOT IN subquery';

-- NOT IN is unnested only when both join columns are NOT NULL or PRIMARY KEY,
-- so this sub-case has neither NULL keys nor duplicate inner keys
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT NOT NULL);
CREATE TABLE tb (ca INT PRIMARY KEY);
INSERT INTO ta VALUES (1, 1000), (2, 2000), (3, 1000), (4, 9999), (5, 1000);
INSERT INTO tb VALUES (1000), (2000);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-01-06-01: unnested, hash join, result and plan
evaluate 'TC-1-01-06-01: unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
WHERE ta.cb NOT IN (SELECT ca FROM tb)
ORDER BY 1;

-- TC-1-01-06-02: not unnested, result and plan
evaluate 'TC-1-01-06-02: not unnested, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE ta.cb NOT IN (SELECT /*+ NO_UNNEST */ ca FROM tb)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- =====================================================================================================================
-- TC-1-02: empty inner or outer input
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-01: SEMI JOIN, empty inner table
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-01: SEMI JOIN, empty inner table';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-02-01-01: hash join
evaluate 'TC-1-02-01-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-02: ANTI JOIN, empty inner table
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-02: ANTI JOIN, empty inner table';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-02-02-01: hash join
evaluate 'TC-1-02-02-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-03: SEMI JOIN, empty outer table
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-03: SEMI JOIN, empty outer table';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO tb VALUES (1), (1), (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-02-03-01: hash join
evaluate 'TC-1-02-03-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-02-04: ANTI JOIN, empty outer table
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-02-04: ANTI JOIN, empty outer table';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO tb VALUES (1), (1), (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-02-04-01: hash join
evaluate 'TC-1-02-04-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- =====================================================================================================================
-- TC-1-03: ON clause with terms other than the equi-join term
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-03-01: SEMI JOIN, first ON clause
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-03-01: SEMI JOIN, first ON clause';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL), (4, 200, 4), (5, 1, NULL);
INSERT INTO tb VALUES (1, 25), (1, 15), (1, 5), (2, 100), (4, 10), (5, 50);
CREATE INDEX i_tb_ca ON tb (ca);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-03-01-01: hash join
evaluate 'TC-1-03-01-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > ta.cb AND ta.cc IS NOT NULL
ORDER BY 1;

-- TC-1-03-01-02: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC-1-03-01-02: rows in the hash join result EXCEPT ALL the NL join result';
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

-- TC-1-03-01-03: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC-1-03-01-03: rows in the NL join result EXCEPT ALL the hash join result';
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
-- TC-1-03-02: ANTI JOIN, first ON clause
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-03-02: ANTI JOIN, first ON clause';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL), (4, 200, 4), (5, 1, NULL);
INSERT INTO tb VALUES (1, 25), (1, 15), (1, 5), (2, 100), (4, 10), (5, 50);
CREATE INDEX i_tb_ca ON tb (ca);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-03-02-01: hash join
evaluate 'TC-1-03-02-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > ta.cb AND ta.cc IS NOT NULL
ORDER BY 1;

-- TC-1-03-02-02: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC-1-03-02-02: rows in the hash join result EXCEPT ALL the NL join result';
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

-- TC-1-03-02-03: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC-1-03-02-03: rows in the NL join result EXCEPT ALL the hash join result';
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
-- TC-1-03-03: SEMI JOIN, second ON clause
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-03-03: SEMI JOIN, second ON clause';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1), (2), (3), (4), (5);
INSERT INTO tb VALUES (1, 25), (1, 15), (1, 5), (2, 100), (4, 10), (5, 50);
CREATE INDEX i_tb_ca ON tb (ca);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-03-03-01: hash join
evaluate 'TC-1-03-03-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb > 20
ORDER BY 1;

-- TC-1-03-03-02: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC-1-03-03-02: rows in the hash join result EXCEPT ALL the NL join result';
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

-- TC-1-03-03-03: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC-1-03-03-03: rows in the NL join result EXCEPT ALL the hash join result';
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
-- TC-1-03-04: ANTI JOIN, second ON clause
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-03-04: ANTI JOIN, second ON clause';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1), (2), (3), (4), (5);
INSERT INTO tb VALUES (1, 25), (1, 15), (1, 5), (2, 100), (4, 10), (5, 50);
CREATE INDEX i_tb_ca ON tb (ca);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-03-04-01: hash join
evaluate 'TC-1-03-04-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb > 20
ORDER BY 1;

-- TC-1-03-04-02: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC-1-03-04-02: rows in the hash join result EXCEPT ALL the NL join result';
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

-- TC-1-03-04-03: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC-1-03-04-03: rows in the NL join result EXCEPT ALL the hash join result';
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
-- TC-1-04: ROWNUM and LIMIT, multiple joins, two-column join key
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-04-01: SEMI JOIN, ROWNUM
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-04-01: SEMI JOIN, ROWNUM';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (3), (4), (1), (2);
INSERT INTO tb VALUES (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-04-01-01: hash join
evaluate 'TC-1-04-01-01: hash join';
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
-- TC-1-04-02: ANTI JOIN, LIMIT
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-04-02: ANTI JOIN, LIMIT';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3), (4);
INSERT INTO tb VALUES (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-04-02-01: hash join
evaluate 'TC-1-04-02-01: hash join';
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
-- TC-1-04-03: SEMI JOIN + ANTI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-04-03: SEMI JOIN + ANTI JOIN';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT);
CREATE TABLE tc (ca INT);
INSERT INTO ta VALUES (1, 10, 100), (2, 10, 200), (3, 20, 100), (4, 20, 300), (5, 20, 300);
INSERT INTO tb VALUES (10), (20);
INSERT INTO tc VALUES (300), (999);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC-1-04-03-01: hash join
evaluate 'TC-1-04-03-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON ta.cb = tb.ca
  ANTI JOIN tc ON tc.ca = ta.cc
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-04-04: INNER JOIN + SEMI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-04-04: INNER JOIN + SEMI JOIN';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT);
CREATE TABLE tc (ca INT);
INSERT INTO ta VALUES (1, 10, 100), (2, 10, 200), (3, 20, 100), (4, 20, 300), (5, 20, 300);
INSERT INTO tb VALUES (10), (20);
INSERT INTO tc VALUES (300), (999);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC-1-04-04-01: hash join
evaluate 'TC-1-04-04-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  JOIN tb ON ta.cb = tb.ca
  SEMI JOIN tc ON tc.ca = ta.cc
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-1-04-05: SEMI JOIN, two-column join key
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-04-05: SEMI JOIN, two-column join key';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (1, 2), (2, NULL), (NULL, 1), (3, 3);
INSERT INTO tb VALUES (1, 1), (1, 1), (2, 2), (NULL, 1), (3, NULL);
CREATE INDEX i_tb_ca_cb ON tb (ca, cb);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-04-05-01: hash join
evaluate 'TC-1-04-05-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca, ta.cb
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca AND tb.cb = ta.cb
ORDER BY 1, 2;

-- TC-1-04-05-02: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC-1-04-05-02: rows in the hash join result EXCEPT ALL the NL join result';
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

-- TC-1-04-05-03: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC-1-04-05-03: rows in the NL join result EXCEPT ALL the hash join result';
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
-- TC-1-04-06: ANTI JOIN, two-column join key
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-1-04-06: ANTI JOIN, two-column join key';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (1, 2), (2, NULL), (NULL, 1), (3, 3);
INSERT INTO tb VALUES (1, 1), (1, 1), (2, 2), (NULL, 1), (3, NULL);
CREATE INDEX i_tb_ca_cb ON tb (ca, cb);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC-1-04-06-01: hash join
evaluate 'TC-1-04-06-01: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca, ta.cb
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND tb.cb = ta.cb
ORDER BY 1, 2;

-- TC-1-04-06-02: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC-1-04-06-02: rows in the hash join result EXCEPT ALL the NL join result';
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

-- TC-1-04-06-03: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC-1-04-06-03: rows in the NL join result EXCEPT ALL the hash join result';
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

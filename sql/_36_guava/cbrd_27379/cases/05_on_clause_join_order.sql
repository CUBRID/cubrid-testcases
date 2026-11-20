/**
 *  This test case verifies CBRD-27379: SEMI JOIN and ANTI JOIN run as a hash join.
 *  AC-4: classification of ON clause terms and join order (TC 1 to TC 4).
 *
 *  An ON clause term of an ANTI JOIN that reads only the outer table decides the match,
 *  so it must not become a filter of the outer scan. The fix classifies it as a during-join term.
 *  An ON clause term of a SEMI / ANTI JOIN that reads other tables must be evaluated while matching,
 *  so the fix joins the tables it reads before the SEMI / ANTI JOIN.
 *  A subquery is not unnested when the parts moved into the ON clause hold a path expression.
 *
 *  Coverage:
 *    TC 1: ANTI JOIN with an outer-only ON term, joined with other tables
 *    TC 2: WHERE terms on outer rows that an ANTI hash join outputs unmatched
 *          (LEFT OUTER JOIN column, host variable, uncorrelated subquery)
 *    TC 3: ON clause that reads three tables, so ta and tb are joined before the SEMI / ANTI JOIN with tc.
 *          tc holds two rows with the same join key, inserted in both orders,
 *          since a wrong join order loses a row only when the row checked first fails the ON clause:
 *          the NL join checks them in insertion order, the hash join checks the last inserted row first
 *    TC 4: path expression in the WHERE, the select list or the left operand of an [NOT] EXISTS / [NOT] IN subquery
 *
 *  Sub-cases:
 *    Sub-case  Query                               Case
 *    TC 1-1    ta ANTI JOIN tb ANTI JOIN tc        outer-only ON terms
 *    TC 1-2    ta LEFT OUTER JOIN tc ANTI JOIN tb  outer-only ON term
 *    TC 1-3    ta JOIN tb ANTI JOIN tc             ON term reading ta and tb
 *    TC 2-1    ta LEFT OUTER JOIN tc ANTI JOIN tb  WHERE term tc.cb IS NULL
 *    TC 2-2    ta ANTI JOIN tb                     WHERE term with a host variable, true and false
 *    TC 2-3    ta ANTI JOIN tb                     WHERE term with an uncorrelated subquery, true and false
 *    TC 3-1    ta JOIN tb SEMI JOIN tc             tc order (1, 10), (1, 20)
 *    TC 3-2    ta JOIN tb ANTI JOIN tc             tc order (1, 10), (1, 20)
 *    TC 3-3    ta JOIN tb SEMI JOIN tc             tc order (1, 20), (1, 10)
 *    TC 3-4    ta JOIN tb ANTI JOIN tc             tc order (1, 20), (1, 10)
 *    TC 4-1    EXISTS subquery                     path expression in the WHERE
 *    TC 4-2    NOT EXISTS subquery                 path expression in the WHERE
 *    TC 4-3    IN subquery                         path expression in the select list
 *    TC 4-4    IN subquery                         path expression in the left operand
 *    TC 4-5    NOT IN subquery                     path expression in the left operand
 *    TC 4-6    EXISTS subquery                     path expression in the select list
 *    TC 4-7    NOT IN subquery                     path expression in the select list
 *
 *  TC 1, TC 2-1 and TC 3 compare the hash join result with the nested loop join result
 *  by EXCEPT ALL in both directions. Both counts must be 0.
 */

-- =====================================================================================================================
-- TC 1: ANTI JOIN with an outer-only ON term, joined with other tables
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-1: two ANTI JOINs
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-1: two ANTI JOINs';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT);
CREATE TABLE tc (ca INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL), (4, 30, NULL);
INSERT INTO tb VALUES (1), (1), (1), (2), (4);
INSERT INTO tc VALUES (1), (2), (3), (4);
CREATE INDEX i_tb_ca ON tb (ca);
CREATE INDEX i_tc_ca ON tc (ca);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 1-1-1: hash join
evaluate 'TC 1-1-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND ta.cc IS NOT NULL
  ANTI JOIN tc ON tc.ca = ta.ca AND ta.cb > 35
ORDER BY 1;

-- TC 1-1-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 1-1-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.cc IS NOT NULL
    ANTI JOIN tc ON tc.ca = ta.ca AND ta.cb > 35
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.cc IS NOT NULL
    ANTI JOIN tc ON tc.ca = ta.ca AND ta.cb > 35
) r;

-- TC 1-1-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 1-1-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.cc IS NOT NULL
    ANTI JOIN tc ON tc.ca = ta.ca AND ta.cb > 35
  EXCEPT ALL
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.cc IS NOT NULL
    ANTI JOIN tc ON tc.ca = ta.ca AND ta.cb > 35
) r;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-2: LEFT OUTER JOIN + ANTI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-2: LEFT OUTER JOIN + ANTI JOIN';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cc INT);
CREATE TABLE tb (ca INT);
CREATE TABLE tc (ca INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, NULL);
INSERT INTO tb VALUES (1), (1), (1), (2);
INSERT INTO tc VALUES (1), (2), (3);
CREATE INDEX i_tb_ca ON tb (ca);
CREATE INDEX i_tc_ca ON tc (ca);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 1-2-1: hash join
evaluate 'TC 1-2-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  LEFT JOIN tc ON tc.ca = ta.ca
  ANTI JOIN tb ON tb.ca = ta.ca AND ta.cc IS NOT NULL
ORDER BY 1;

-- TC 1-2-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 1-2-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    LEFT JOIN tc ON tc.ca = ta.ca
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.cc IS NOT NULL
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    LEFT JOIN tc ON tc.ca = ta.ca
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.cc IS NOT NULL
) r;

-- TC 1-2-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 1-2-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    LEFT JOIN tc ON tc.ca = ta.ca
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.cc IS NOT NULL
  EXCEPT ALL
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    LEFT JOIN tc ON tc.ca = ta.ca
    ANTI JOIN tb ON tb.ca = ta.ca AND ta.cc IS NOT NULL
) r;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 1-3: INNER JOIN + ANTI JOIN, ON term reading two outer tables
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 1-3: INNER JOIN + ANTI JOIN, ON term reading two outer tables';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT);
INSERT INTO ta VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3), (4, NULL, 4), (5, 5, 5), (6, 6, 6), (7, 1, 7);
INSERT INTO tb VALUES (1, 1), (2, 20), (3, 3), (4, 4), (5, 50), (6, 6), (7, 70);
INSERT INTO tc VALUES (1), (1), (1), (2), (NULL), (5), (6);
CREATE INDEX i_tb_ca ON tb (ca);
CREATE INDEX i_tc_ca ON tc (ca);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 1-3-1: hash join
evaluate 'TC 1-3-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  JOIN tb ON tb.ca = ta.ca
  ANTI JOIN tc ON tc.ca = ta.cb AND ta.cc = tb.cb
ORDER BY 1;

-- TC 1-3-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 1-3-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    JOIN tb ON tb.ca = ta.ca
    ANTI JOIN tc ON tc.ca = ta.cb AND ta.cc = tb.cb
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    JOIN tb ON tb.ca = ta.ca
    ANTI JOIN tc ON tc.ca = ta.cb AND ta.cc = tb.cb
) r;

-- TC 1-3-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 1-3-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    JOIN tb ON tb.ca = ta.ca
    ANTI JOIN tc ON tc.ca = ta.cb AND ta.cc = tb.cb
  EXCEPT ALL
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    JOIN tb ON tb.ca = ta.ca
    ANTI JOIN tc ON tc.ca = ta.cb AND ta.cc = tb.cb
) r;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- =====================================================================================================================
-- TC 2: ANTI hash join evaluates WHERE terms on unmatched outer rows
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-1: LEFT OUTER JOIN + ANTI JOIN, WHERE filters the LEFT OUTER JOIN result
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-1: LEFT OUTER JOIN + ANTI JOIN, WHERE filters the LEFT OUTER JOIN result';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO ta VALUES (1), (2), (3);
INSERT INTO tb VALUES (1), (1), (1), (2);
INSERT INTO tc VALUES (1, NULL), (2, 100), (3, 100);
CREATE INDEX i_tb_ca ON tb (ca);
CREATE INDEX i_tc_ca ON tc (ca);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 2-1-1: hash join
evaluate 'TC 2-1-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  LEFT JOIN tc ON tc.ca = ta.ca
  ANTI JOIN tb ON tb.ca = ta.ca
WHERE tc.cb IS NULL
ORDER BY 1;

-- TC 2-1-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 2-1-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    LEFT JOIN tc ON tc.ca = ta.ca
    ANTI JOIN tb ON tb.ca = ta.ca
  WHERE tc.cb IS NULL
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    LEFT JOIN tc ON tc.ca = ta.ca
    ANTI JOIN tb ON tb.ca = ta.ca
  WHERE tc.cb IS NULL
) r;

-- TC 2-1-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 2-1-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ ta.ca
  FROM ta
    LEFT JOIN tc ON tc.ca = ta.ca
    ANTI JOIN tb ON tb.ca = ta.ca
  WHERE tc.cb IS NULL
  EXCEPT ALL
  SELECT /*+ USE_HASH */ ta.ca
  FROM ta
    LEFT JOIN tc ON tc.ca = ta.ca
    ANTI JOIN tb ON tb.ca = ta.ca
  WHERE tc.cb IS NULL
) r;

-- TC 2-1-4: ORDERED hash join
evaluate 'TC 2-1-4: ORDERED hash join';
SELECT /*+ RECOMPILE ORDERED USE_HASH */ ta.ca
FROM ta
  LEFT JOIN tc ON tc.ca = ta.ca
  ANTI JOIN tb ON tb.ca = ta.ca
WHERE tc.cb IS NULL
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-2: ANTI JOIN, host variable term
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-2: ANTI JOIN, host variable term';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
INSERT INTO ta VALUES (1), (2), (3);
INSERT INTO tb VALUES (1), (1), (1), (2);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 2-2-1: condition true
evaluate 'TC 2-2-1: condition true';
PREPARE st FROM 'SELECT /*+ RECOMPILE USE_HASH */ ta.ca FROM ta ANTI JOIN tb ON tb.ca = ta.ca WHERE ? = 1 ORDER BY 1';
EXECUTE st USING 1;

-- TC 2-2-2: condition false
evaluate 'TC 2-2-2: condition false';
EXECUTE st USING 2;

-- cleanup
DEALLOCATE PREPARE st;
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 2-3: ANTI JOIN, uncorrelated subquery term
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 2-3: ANTI JOIN, uncorrelated subquery term';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT);
CREATE TABLE tb (ca INT);
CREATE TABLE tc (ca INT);
INSERT INTO ta VALUES (1), (2), (3);
INSERT INTO tb VALUES (1), (1), (1), (2);
INSERT INTO tc VALUES (1), (2), (3);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 2-3-1: condition true
evaluate 'TC 2-3-1: condition true';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca
WHERE (SELECT COUNT (*) FROM tc) > 0
ORDER BY 1;

-- TC 2-3-2: condition false
evaluate 'TC 2-3-2: condition false';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca
WHERE (SELECT COUNT (*) FROM tc) > 5
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- =====================================================================================================================
-- TC 3: ON clause reading three tables: ta and tb are joined before the SEMI/ANTI JOIN
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-1: SEMI JOIN, tc order (1, 10), (1, 20)
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-1: SEMI JOIN, tc order (1, 10), (1, 20)';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (x INT, b INT);
CREATE TABLE tb (x INT, a INT, b INT);
CREATE TABLE tc (a INT, b INT);
INSERT INTO ta VALUES (0, 0), (1, 20), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0), (10, 0);
INSERT INTO tb VALUES (0, 0, 0), (1, 1, 0), (2, 2, 0), (3, 3, 0), (4, 4, 0), (5, 5, 0), (6, 6, 0), (7, 7, 0), (8, 8, 0), (9, 9, 0), (10, 1, 0);
INSERT INTO tc VALUES (1, 10);
INSERT INTO tc VALUES (1, 20);
CREATE INDEX i_tb_x ON tb (x);
CREATE INDEX i_tc_a ON tc (a);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 3-1-1: hash join
evaluate 'TC 3-1-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  JOIN tb ON tb.x = ta.x
  SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b;

-- TC 3-1-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 3-1-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) r;

-- TC 3-1-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 3-1-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) r;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-2: ANTI JOIN, tc order (1, 10), (1, 20)
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-2: ANTI JOIN, tc order (1, 10), (1, 20)';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (x INT, b INT);
CREATE TABLE tb (x INT, a INT, b INT);
CREATE TABLE tc (a INT, b INT);
INSERT INTO ta VALUES (0, 0), (1, 20), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0), (10, 0);
INSERT INTO tb VALUES (0, 0, 0), (1, 1, 0), (2, 2, 0), (3, 3, 0), (4, 4, 0), (5, 5, 0), (6, 6, 0), (7, 7, 0), (8, 8, 0), (9, 9, 0), (10, 1, 0);
INSERT INTO tc VALUES (1, 10);
INSERT INTO tc VALUES (1, 20);
CREATE INDEX i_tb_x ON tb (x);
CREATE INDEX i_tc_a ON tc (a);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 3-2-1: hash join
evaluate 'TC 3-2-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  JOIN tb ON tb.x = ta.x
  ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b;

-- TC 3-2-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 3-2-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) r;

-- TC 3-2-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 3-2-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) r;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-3: SEMI JOIN, tc order (1, 20), (1, 10)
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-3: SEMI JOIN, tc order (1, 20), (1, 10)';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (x INT, b INT);
CREATE TABLE tb (x INT, a INT, b INT);
CREATE TABLE tc (a INT, b INT);
INSERT INTO ta VALUES (0, 0), (1, 20), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0), (10, 0);
INSERT INTO tb VALUES (0, 0, 0), (1, 1, 0), (2, 2, 0), (3, 3, 0), (4, 4, 0), (5, 5, 0), (6, 6, 0), (7, 7, 0), (8, 8, 0), (9, 9, 0), (10, 1, 0);
INSERT INTO tc VALUES (1, 20);
INSERT INTO tc VALUES (1, 10);
CREATE INDEX i_tb_x ON tb (x);
CREATE INDEX i_tc_a ON tc (a);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 3-3-1: hash join
evaluate 'TC 3-3-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  JOIN tb ON tb.x = ta.x
  SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b;

-- TC 3-3-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 3-3-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) r;

-- TC 3-3-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 3-3-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) r;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 3-4: ANTI JOIN, tc order (1, 20), (1, 10)
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 3-4: ANTI JOIN, tc order (1, 20), (1, 10)';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (x INT, b INT);
CREATE TABLE tb (x INT, a INT, b INT);
CREATE TABLE tc (a INT, b INT);
INSERT INTO ta VALUES (0, 0), (1, 20), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0), (10, 0);
INSERT INTO tb VALUES (0, 0, 0), (1, 1, 0), (2, 2, 0), (3, 3, 0), (4, 4, 0), (5, 5, 0), (6, 6, 0), (7, 7, 0), (8, 8, 0), (9, 9, 0), (10, 1, 0);
INSERT INTO tc VALUES (1, 20);
INSERT INTO tc VALUES (1, 10);
CREATE INDEX i_tb_x ON tb (x);
CREATE INDEX i_tc_a ON tc (a);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 3-4-1: hash join
evaluate 'TC 3-4-1: hash join';
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  JOIN tb ON tb.x = ta.x
  ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b;

-- TC 3-4-2: rows in the hash join result EXCEPT ALL the NL join result
evaluate 'TC 3-4-2: rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ NO_USE_HASH USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) r;

-- TC 3-4-3: rows in the NL join result EXCEPT ALL the hash join result
evaluate 'TC 3-4-3: rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ NO_USE_HASH USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) r;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- =====================================================================================================================
-- TC 4: a subquery whose parts moved into the ON clause hold a path expression is not unnested
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-1: WHERE of an EXISTS subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-1: WHERE of an EXISTS subquery';

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE tc (cb INT) DONT_REUSE_OID;
CREATE TABLE tb (ca INT, cr tc) DONT_REUSE_OID;
CREATE TABLE ta (ca INT) DONT_REUSE_OID;
INSERT INTO tc VALUES (100), (200);
INSERT INTO tb (ca, cr) SELECT 1, c FROM tc c WHERE c.cb = 100;
INSERT INTO tb (ca, cr) SELECT 1, c FROM tc c WHERE c.cb = 200;
INSERT INTO tb (ca, cr) VALUES (2, NULL);
INSERT INTO tb (ca, cr) SELECT 3, c FROM tc c WHERE c.cb = 100;
INSERT INTO ta VALUES (1), (2), (3), (4);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 4-1-1: EXISTS subquery WHERE, result and plan
evaluate 'TC 4-1-1: EXISTS subquery WHERE, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca AND tb.cr.cb /* path expression */ > 150)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-2: WHERE of a NOT EXISTS subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-2: WHERE of a NOT EXISTS subquery';

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE tc (cb INT) DONT_REUSE_OID;
CREATE TABLE tb (ca INT, cr tc) DONT_REUSE_OID;
CREATE TABLE ta (ca INT) DONT_REUSE_OID;
INSERT INTO tc VALUES (100), (200);
INSERT INTO tb (ca, cr) SELECT 1, c FROM tc c WHERE c.cb = 100;
INSERT INTO tb (ca, cr) SELECT 1, c FROM tc c WHERE c.cb = 200;
INSERT INTO tb (ca, cr) VALUES (2, NULL);
INSERT INTO tb (ca, cr) SELECT 3, c FROM tc c WHERE c.cb = 100;
INSERT INTO ta VALUES (1), (2), (3), (4);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 4-2-1: NOT EXISTS subquery WHERE, result and plan
evaluate 'TC 4-2-1: NOT EXISTS subquery WHERE, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca AND tb.cr.cb /* path expression */ > 150)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-3: select list of an IN subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-3: select list of an IN subquery';

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE tc (cb INT) DONT_REUSE_OID;
CREATE TABLE tb (ca INT, cr tc) DONT_REUSE_OID;
CREATE TABLE ta (ca INT, cb INT) DONT_REUSE_OID;
INSERT INTO tc VALUES (100), (200);
INSERT INTO tb (ca, cr) SELECT 1, c FROM tc c WHERE c.cb = 100;
INSERT INTO tb (ca, cr) SELECT 1, c FROM tc c WHERE c.cb = 200;
INSERT INTO tb (ca, cr) VALUES (2, NULL);
INSERT INTO tb (ca, cr) SELECT 3, c FROM tc c WHERE c.cb = 100;
INSERT INTO ta VALUES (1, 100), (2, 200), (3, 7), (4, 0);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 4-3-1: IN subquery select list, result and plan
evaluate 'TC 4-3-1: IN subquery select list, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE ta.cb IN (SELECT tb.cr.cb /* path expression */ FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-4: left operand of IN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-4: left operand of IN';

DROP TABLE IF EXISTS ta, tb;
CREATE TABLE tb (ca INT, cb INT) DONT_REUSE_OID;
CREATE TABLE ta (ca INT, cr tb) DONT_REUSE_OID;
INSERT INTO tb VALUES (1, 5), (1, 15), (2, 100), (3, 7);
INSERT INTO ta (ca, cr) SELECT 1, b FROM tb b WHERE b.ca = 1 AND b.cb = 5;
INSERT INTO ta (ca, cr) SELECT 2, b FROM tb b WHERE b.ca = 2;
INSERT INTO ta (ca, cr) SELECT 3, b FROM tb b WHERE b.ca = 3;
INSERT INTO ta (ca, cr) VALUES (4, NULL);

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 4-4-1: IN left operand, result and plan
evaluate 'TC 4-4-1: IN left operand, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE ta.cr.cb /* path expression */ IN (SELECT tb.cb FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-5: left operand of NOT IN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-5: left operand of NOT IN';

DROP TABLE IF EXISTS ta, tb;
CREATE TABLE tb (ca INT, cb INT) DONT_REUSE_OID;
CREATE TABLE ta (ca INT, cr tb) DONT_REUSE_OID;
INSERT INTO tb VALUES (1, 5), (1, 15), (2, 100), (3, 7);
INSERT INTO ta (ca, cr) SELECT 1, b FROM tb b WHERE b.ca = 1 AND b.cb = 5;
INSERT INTO ta (ca, cr) SELECT 2, b FROM tb b WHERE b.ca = 2;
INSERT INTO ta (ca, cr) SELECT 3, b FROM tb b WHERE b.ca = 3;
-- ta 5 references tb (1, 15) instead of NULL, unlike ta 4 of TC 4-4:
-- no tb row has ca 5, so NOT IN is true and ta 5 is the row in the result
INSERT INTO ta (ca, cr) SELECT 5, b FROM tb b WHERE b.ca = 1 AND b.cb = 15;

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- TC 4-5-1: NOT IN left operand, result and plan
evaluate 'TC 4-5-1: NOT IN left operand, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE ta.cr.cb /* path expression */ NOT IN (SELECT tb.cb FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-6: select list of an EXISTS subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-6: select list of an EXISTS subquery';

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE tc (cb INT) DONT_REUSE_OID;
CREATE TABLE tb (ca INT, cr tc) DONT_REUSE_OID;
CREATE TABLE ta (ca INT) DONT_REUSE_OID;
INSERT INTO tc VALUES (100), (200);
INSERT INTO tb (ca, cr) SELECT 1, c FROM tc c WHERE c.cb = 100;
INSERT INTO tb (ca, cr) SELECT 1, c FROM tc c WHERE c.cb = 200;
INSERT INTO tb (ca, cr) VALUES (2, NULL);
INSERT INTO tb (ca, cr) SELECT 3, c FROM tc c WHERE c.cb = 100;
INSERT INTO ta VALUES (1), (2), (3), (4);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 4-6-1: EXISTS subquery select list, result and plan
evaluate 'TC 4-6-1: EXISTS subquery select list, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE EXISTS (SELECT tb.cr.cb /* path expression */ FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC 4-7: select list of a NOT IN subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC 4-7: select list of a NOT IN subquery';

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE tc (cb INT) DONT_REUSE_OID;
CREATE TABLE tb (ca INT, cr tc) DONT_REUSE_OID;
CREATE TABLE ta (ca INT, cb INT) DONT_REUSE_OID;
INSERT INTO tc VALUES (100), (200);
INSERT INTO tb (ca, cr) SELECT 1, c FROM tc c WHERE c.cb = 100;
INSERT INTO tb (ca, cr) SELECT 1, c FROM tc c WHERE c.cb = 200;
INSERT INTO tb (ca, cr) VALUES (2, NULL);
INSERT INTO tb (ca, cr) SELECT 3, c FROM tc c WHERE c.cb = 100;
INSERT INTO ta VALUES (1, 100), (2, 200), (3, 7), (4, 0);

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- TC 4-7-1: NOT IN subquery select list, result and plan
evaluate 'TC 4-7-1: NOT IN subquery select list, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE ta.cb NOT IN (SELECT tb.cr.cb /* path expression */ FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb, tc;

/**
 *  This test case verifies CBRD-27379: SEMI JOIN and ANTI JOIN run as a hash join.
 *  Part 5 of 5 -- classification of ON clause terms and join order (TC-4-01 to TC-4-04).
 *
 *  An ON clause term of an ANTI JOIN that reads only the outer table decides the match,
 *  so it must not become a filter of the outer scan. The fix classifies it as a during-join term.
 *  An ON clause term of a SEMI / ANTI JOIN that reads other tables must be evaluated while matching,
 *  so the fix joins the tables it reads before the SEMI / ANTI JOIN.
 *  A subquery is not unnested when the parts moved into the ON clause hold a path expression.
 *
 *  Coverage:
 *    TC-4-01: ANTI JOIN with an outer-only ON term, joined with other tables
 *    TC-4-02: WHERE terms on outer rows that an ANTI hash join outputs unmatched (host variable, uncorrelated subquery)
 *    TC-4-03: ON clause that reads three tables, so ta and tb are joined before the SEMI / ANTI JOIN with tc.
 *             tc holds two rows with the same join key, inserted in both orders,
 *             since a wrong join order loses a row only when the row checked first fails the ON clause:
 *             the NL join checks them in insertion order, the hash join checks the last inserted row first
 *    TC-4-04: path expression in the WHERE, the select list or the left operand of an [NOT] EXISTS / [NOT] IN subquery
 *
 *  TC-4-01, TC-4-02-01 and TC-4-03 compare the hash join result with the nested loop join result
 *  by EXCEPT ALL in both directions. Both counts must be 0.
 */

-- =====================================================================================================================
-- TC-4-01: ANTI JOIN with an outer-only ON term, joined with other tables
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-01-01: two ANTI JOINs
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-01-01: two ANTI JOINs';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL), (4, 30, NULL);
INSERT INTO tb VALUES (1, 5), (1, 15), (1, 25), (2, 100), (4, 5);
INSERT INTO tc VALUES (1, NULL), (2, 100), (3, 100), (4, 0);
UPDATE STATISTICS ON ta, tb, tc;

-- hash join
evaluate 'hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND ta.cc IS NOT NULL
  ANTI JOIN tc ON tc.ca = ta.ca AND ta.cb > 35
ORDER BY 1;

-- rows in the hash join result EXCEPT ALL the NL join result
evaluate 'rows in the hash join result EXCEPT ALL the NL join result';
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
) x;

-- rows in the NL join result EXCEPT ALL the hash join result
evaluate 'rows in the NL join result EXCEPT ALL the hash join result';
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
) x;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-01-02: LEFT OUTER JOIN + ANTI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-01-02: LEFT OUTER JOIN + ANTI JOIN';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL);
INSERT INTO tb VALUES (1, 5), (1, 15), (1, 25), (2, 100);
INSERT INTO tc VALUES (1, NULL), (2, 100), (3, 100);
UPDATE STATISTICS ON ta, tb, tc;

-- hash join
evaluate 'hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  LEFT JOIN tc ON tc.ca = ta.ca
  ANTI JOIN tb ON tb.ca = ta.ca AND ta.cc IS NOT NULL
ORDER BY 1;

-- rows in the hash join result EXCEPT ALL the NL join result
evaluate 'rows in the hash join result EXCEPT ALL the NL join result';
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
) x;

-- rows in the NL join result EXCEPT ALL the hash join result
evaluate 'rows in the NL join result EXCEPT ALL the hash join result';
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
) x;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- =====================================================================================================================
-- TC-4-02: ANTI hash join evaluates WHERE terms on unmatched outer rows
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-02-01: LEFT OUTER JOIN + ANTI JOIN, WHERE filters the LEFT OUTER JOIN result
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-02-01: LEFT OUTER JOIN + ANTI JOIN, WHERE filters the LEFT OUTER JOIN result';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL);
INSERT INTO tb VALUES (1, 5), (1, 15), (1, 25), (2, 100);
INSERT INTO tc VALUES (1, NULL), (2, 100), (3, 100);
UPDATE STATISTICS ON ta, tb, tc;

-- hash join
evaluate 'hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  LEFT JOIN tc ON tc.ca = ta.ca
  ANTI JOIN tb ON tb.ca = ta.ca
WHERE tc.cb IS NULL
ORDER BY ta.ca;

-- rows in the hash join result EXCEPT ALL the NL join result
evaluate 'rows in the hash join result EXCEPT ALL the NL join result';
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
) x;

-- rows in the NL join result EXCEPT ALL the hash join result
evaluate 'rows in the NL join result EXCEPT ALL the hash join result';
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
) x;

-- ORDERED hash join
evaluate 'ORDERED hash join';
SELECT /*+ RECOMPILE ORDERED USE_HASH */ ta.ca
FROM ta
  LEFT JOIN tc ON tc.ca = ta.ca
  ANTI JOIN tb ON tb.ca = ta.ca
WHERE tc.cb IS NULL
ORDER BY ta.ca;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-02-02: ANTI JOIN, host variable term
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-02-02: ANTI JOIN, host variable term';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL);
INSERT INTO tb VALUES (1, 5), (1, 15), (1, 25), (2, 100);
UPDATE STATISTICS ON ta, tb;

-- condition true
evaluate 'condition true';
PREPARE st FROM 'SELECT /*+ RECOMPILE USE_HASH */ ta.ca FROM ta ANTI JOIN tb ON tb.ca = ta.ca WHERE ? = 1 ORDER BY 1';
EXECUTE st USING 1;

-- condition false
evaluate 'condition false';
PREPARE st FROM 'SELECT /*+ RECOMPILE USE_HASH */ ta.ca FROM ta ANTI JOIN tb ON tb.ca = ta.ca WHERE ? = 1 ORDER BY 1';
EXECUTE st USING 2;

-- cleanup
DEALLOCATE PREPARE st;
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-02-03: ANTI JOIN, uncorrelated subquery term is true
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-02-03: ANTI JOIN, uncorrelated subquery term is true';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL);
INSERT INTO tb VALUES (1, 5), (1, 15), (1, 25), (2, 100);
INSERT INTO tc VALUES (1, NULL), (2, 100), (3, 100);
UPDATE STATISTICS ON ta, tb, tc;

-- hash join
evaluate 'hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca
WHERE (SELECT COUNT (*) FROM tc) > 0
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-02-04: ANTI JOIN, uncorrelated subquery term is false
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-02-04: ANTI JOIN, uncorrelated subquery term is false';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL);
INSERT INTO tb VALUES (1, 5), (1, 15), (1, 25), (2, 100);
INSERT INTO tc VALUES (1, NULL), (2, 100), (3, 100);
UPDATE STATISTICS ON ta, tb, tc;

-- hash join
evaluate 'hash join';
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca
WHERE (SELECT COUNT (*) FROM tc) > 5
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- =====================================================================================================================
-- TC-4-03: ON clause reading three tables: ta and tb are joined before the SEMI/ANTI JOIN
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-03-01: SEMI JOIN, tc order (1, 10), (1, 20)
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-03-01: SEMI JOIN, tc order (1, 10), (1, 20)';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (x INT, b INT);
CREATE TABLE tb (x INT, a INT, b INT);
CREATE TABLE tc (a INT, b INT);
INSERT INTO ta VALUES (0, 0), (1, 20), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0), (10, 0);
INSERT INTO tb VALUES (0, 0, 0), (1, 1, 0), (2, 2, 0), (3, 3, 0), (4, 4, 0), (5, 5, 0), (6, 6, 0), (7, 7, 0), (8, 8, 0), (9, 9, 0), (10, 1, 0);
INSERT INTO tc VALUES (1, 10);
INSERT INTO tc VALUES (1, 20);
CREATE INDEX i_ta_x ON ta (x);
CREATE INDEX i_tb_x ON tb (x);
CREATE INDEX i_tc_a ON tc (a);
UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- hash join
evaluate 'hash join';
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  JOIN tb ON tb.x = ta.x
  SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b;

-- rows in the hash join result EXCEPT ALL the NL join result
evaluate 'rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) x;

-- rows in the NL join result EXCEPT ALL the hash join result
evaluate 'rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) x;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-03-02: ANTI JOIN, tc order (1, 10), (1, 20)
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-03-02: ANTI JOIN, tc order (1, 10), (1, 20)';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (x INT, b INT);
CREATE TABLE tb (x INT, a INT, b INT);
CREATE TABLE tc (a INT, b INT);
INSERT INTO ta VALUES (0, 0), (1, 20), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0), (10, 0);
INSERT INTO tb VALUES (0, 0, 0), (1, 1, 0), (2, 2, 0), (3, 3, 0), (4, 4, 0), (5, 5, 0), (6, 6, 0), (7, 7, 0), (8, 8, 0), (9, 9, 0), (10, 1, 0);
INSERT INTO tc VALUES (1, 10);
INSERT INTO tc VALUES (1, 20);
CREATE INDEX i_ta_x ON ta (x);
CREATE INDEX i_tb_x ON tb (x);
CREATE INDEX i_tc_a ON tc (a);
UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- hash join
evaluate 'hash join';
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  JOIN tb ON tb.x = ta.x
  ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b;

-- rows in the hash join result EXCEPT ALL the NL join result
evaluate 'rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) x;

-- rows in the NL join result EXCEPT ALL the hash join result
evaluate 'rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) x;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-03-03: SEMI JOIN, tc order (1, 20), (1, 10)
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-03-03: SEMI JOIN, tc order (1, 20), (1, 10)';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (x INT, b INT);
CREATE TABLE tb (x INT, a INT, b INT);
CREATE TABLE tc (a INT, b INT);
INSERT INTO ta VALUES (0, 0), (1, 20), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0), (10, 0);
INSERT INTO tb VALUES (0, 0, 0), (1, 1, 0), (2, 2, 0), (3, 3, 0), (4, 4, 0), (5, 5, 0), (6, 6, 0), (7, 7, 0), (8, 8, 0), (9, 9, 0), (10, 1, 0);
INSERT INTO tc VALUES (1, 20);
INSERT INTO tc VALUES (1, 10);
CREATE INDEX i_ta_x ON ta (x);
CREATE INDEX i_tb_x ON tb (x);
CREATE INDEX i_tc_a ON tc (a);
UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- hash join
evaluate 'hash join';
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  JOIN tb ON tb.x = ta.x
  SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b;

-- rows in the hash join result EXCEPT ALL the NL join result
evaluate 'rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) x;

-- rows in the NL join result EXCEPT ALL the hash join result
evaluate 'rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    SEMI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) x;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-03-04: ANTI JOIN, tc order (1, 20), (1, 10)
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-03-04: ANTI JOIN, tc order (1, 20), (1, 10)';

DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (x INT, b INT);
CREATE TABLE tb (x INT, a INT, b INT);
CREATE TABLE tc (a INT, b INT);
INSERT INTO ta VALUES (0, 0), (1, 20), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0), (10, 0);
INSERT INTO tb VALUES (0, 0, 0), (1, 1, 0), (2, 2, 0), (3, 3, 0), (4, 4, 0), (5, 5, 0), (6, 6, 0), (7, 7, 0), (8, 8, 0), (9, 9, 0), (10, 1, 0);
INSERT INTO tc VALUES (1, 20);
INSERT INTO tc VALUES (1, 10);
CREATE INDEX i_ta_x ON ta (x);
CREATE INDEX i_tb_x ON tb (x);
CREATE INDEX i_tc_a ON tc (a);
UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- hash join
evaluate 'hash join';
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  JOIN tb ON tb.x = ta.x
  ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b;

-- rows in the hash join result EXCEPT ALL the NL join result
evaluate 'rows in the hash join result EXCEPT ALL the NL join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS hash_minus_nl
FROM (
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) x;

-- rows in the NL join result EXCEPT ALL the hash join result
evaluate 'rows in the NL join result EXCEPT ALL the hash join result';
SELECT /*+ RECOMPILE */ COUNT (*) AS nl_minus_hash
FROM (
  SELECT /*+ USE_NL */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
  EXCEPT ALL
  SELECT /*+ USE_HASH */ tb.x
  FROM ta
    JOIN tb ON tb.x = ta.x
    ANTI JOIN tc ON tc.a = tb.a AND tc.b = ta.b + tb.b
) x;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- =====================================================================================================================
-- TC-4-04: a subquery whose parts moved into the ON clause hold a path expression is not unnested
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-04-01: WHERE of an EXISTS subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-04-01: WHERE of an EXISTS subquery';

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE tc (ca INT, cb INT) DONT_REUSE_OID;
CREATE TABLE tb (ca INT, cb INT, cr tc) DONT_REUSE_OID;
CREATE TABLE ta (ca INT, cb INT, cr tb) DONT_REUSE_OID;
INSERT INTO tc VALUES (1, 100), (2, 200);
INSERT INTO tb (ca, cb, cr) SELECT 1, 5, c FROM tc c WHERE c.ca = 1;
INSERT INTO tb (ca, cb, cr) SELECT 1, 15, c FROM tc c WHERE c.ca = 2;
INSERT INTO tb (ca, cb, cr) VALUES (2, 100, NULL);
INSERT INTO tb (ca, cb, cr) SELECT 3, 7, c FROM tc c WHERE c.ca = 1;
INSERT INTO ta (ca, cb, cr) SELECT 1, 100, b FROM tb b WHERE b.ca = 1 AND b.cb = 5;
INSERT INTO ta (ca, cb, cr) SELECT 2, 200, b FROM tb b WHERE b.ca = 2;
INSERT INTO ta (ca, cb, cr) SELECT 3, 7, b FROM tb b WHERE b.ca = 3;
INSERT INTO ta (ca, cb, cr) VALUES (4, 0, NULL);
UPDATE STATISTICS ON ta, tb, tc;

-- EXISTS subquery WHERE, result and plan
evaluate 'EXISTS subquery WHERE, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca AND tb.cr.cb /* path expression */ > 150)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-04-02: WHERE of a NOT EXISTS subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-04-02: WHERE of a NOT EXISTS subquery';

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE tc (ca INT, cb INT) DONT_REUSE_OID;
CREATE TABLE tb (ca INT, cb INT, cr tc) DONT_REUSE_OID;
CREATE TABLE ta (ca INT, cb INT, cr tb) DONT_REUSE_OID;
INSERT INTO tc VALUES (1, 100), (2, 200);
INSERT INTO tb (ca, cb, cr) SELECT 1, 5, c FROM tc c WHERE c.ca = 1;
INSERT INTO tb (ca, cb, cr) SELECT 1, 15, c FROM tc c WHERE c.ca = 2;
INSERT INTO tb (ca, cb, cr) VALUES (2, 100, NULL);
INSERT INTO tb (ca, cb, cr) SELECT 3, 7, c FROM tc c WHERE c.ca = 1;
INSERT INTO ta (ca, cb, cr) SELECT 1, 100, b FROM tb b WHERE b.ca = 1 AND b.cb = 5;
INSERT INTO ta (ca, cb, cr) SELECT 2, 200, b FROM tb b WHERE b.ca = 2;
INSERT INTO ta (ca, cb, cr) SELECT 3, 7, b FROM tb b WHERE b.ca = 3;
INSERT INTO ta (ca, cb, cr) VALUES (4, 0, NULL);
UPDATE STATISTICS ON ta, tb, tc;

-- NOT EXISTS subquery WHERE, result and plan
evaluate 'NOT EXISTS subquery WHERE, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca AND tb.cr.cb /* path expression */ > 150)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-04-03: select list of an IN subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-04-03: select list of an IN subquery';

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE tc (ca INT, cb INT) DONT_REUSE_OID;
CREATE TABLE tb (ca INT, cb INT, cr tc) DONT_REUSE_OID;
CREATE TABLE ta (ca INT, cb INT, cr tb) DONT_REUSE_OID;
INSERT INTO tc VALUES (1, 100), (2, 200);
INSERT INTO tb (ca, cb, cr) SELECT 1, 5, c FROM tc c WHERE c.ca = 1;
INSERT INTO tb (ca, cb, cr) SELECT 1, 15, c FROM tc c WHERE c.ca = 2;
INSERT INTO tb (ca, cb, cr) VALUES (2, 100, NULL);
INSERT INTO tb (ca, cb, cr) SELECT 3, 7, c FROM tc c WHERE c.ca = 1;
INSERT INTO ta (ca, cb, cr) SELECT 1, 100, b FROM tb b WHERE b.ca = 1 AND b.cb = 5;
INSERT INTO ta (ca, cb, cr) SELECT 2, 200, b FROM tb b WHERE b.ca = 2;
INSERT INTO ta (ca, cb, cr) SELECT 3, 7, b FROM tb b WHERE b.ca = 3;
INSERT INTO ta (ca, cb, cr) VALUES (4, 0, NULL);
UPDATE STATISTICS ON ta, tb, tc;

-- IN subquery select list, result and plan
evaluate 'IN subquery select list, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE ta.cb IN (SELECT tb.cr.cb /* path expression */ FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-04-04: left operand of IN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-04-04: left operand of IN';

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE tc (ca INT, cb INT) DONT_REUSE_OID;
CREATE TABLE tb (ca INT, cb INT, cr tc) DONT_REUSE_OID;
CREATE TABLE ta (ca INT, cb INT, cr tb) DONT_REUSE_OID;
INSERT INTO tc VALUES (1, 100), (2, 200);
INSERT INTO tb (ca, cb, cr) SELECT 1, 5, c FROM tc c WHERE c.ca = 1;
INSERT INTO tb (ca, cb, cr) SELECT 1, 15, c FROM tc c WHERE c.ca = 2;
INSERT INTO tb (ca, cb, cr) VALUES (2, 100, NULL);
INSERT INTO tb (ca, cb, cr) SELECT 3, 7, c FROM tc c WHERE c.ca = 1;
INSERT INTO ta (ca, cb, cr) SELECT 1, 100, b FROM tb b WHERE b.ca = 1 AND b.cb = 5;
INSERT INTO ta (ca, cb, cr) SELECT 2, 200, b FROM tb b WHERE b.ca = 2;
INSERT INTO ta (ca, cb, cr) SELECT 3, 7, b FROM tb b WHERE b.ca = 3;
INSERT INTO ta (ca, cb, cr) VALUES (4, 0, NULL);
UPDATE STATISTICS ON ta, tb, tc;

-- IN left operand, result and plan
evaluate 'IN left operand, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE ta.cr.cb /* path expression */ IN (SELECT tb.cb FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-04-05: left operand of NOT IN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-04-05: left operand of NOT IN';

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE tc (ca INT, cb INT) DONT_REUSE_OID;
CREATE TABLE tb (ca INT, cb INT, cr tc) DONT_REUSE_OID;
CREATE TABLE ta (ca INT, cb INT, cr tb) DONT_REUSE_OID;
INSERT INTO tc VALUES (1, 100), (2, 200);
INSERT INTO tb (ca, cb, cr) SELECT 1, 5, c FROM tc c WHERE c.ca = 1;
INSERT INTO tb (ca, cb, cr) SELECT 1, 15, c FROM tc c WHERE c.ca = 2;
INSERT INTO tb (ca, cb, cr) VALUES (2, 100, NULL);
INSERT INTO tb (ca, cb, cr) SELECT 3, 7, c FROM tc c WHERE c.ca = 1;
INSERT INTO ta (ca, cb, cr) SELECT 1, 100, b FROM tb b WHERE b.ca = 1 AND b.cb = 5;
INSERT INTO ta (ca, cb, cr) SELECT 2, 200, b FROM tb b WHERE b.ca = 2;
INSERT INTO ta (ca, cb, cr) SELECT 3, 7, b FROM tb b WHERE b.ca = 3;
INSERT INTO ta (ca, cb, cr) SELECT 5, 0, b FROM tb b WHERE b.ca = 1 AND b.cb = 15;
UPDATE STATISTICS ON ta, tb, tc;

-- NOT IN left operand, result and plan
evaluate 'NOT IN left operand, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE ta.cr.cb /* path expression */ NOT IN (SELECT tb.cb FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-04-06: select list of an EXISTS subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-04-06: select list of an EXISTS subquery';

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE tc (ca INT, cb INT) DONT_REUSE_OID;
CREATE TABLE tb (ca INT, cb INT, cr tc) DONT_REUSE_OID;
CREATE TABLE ta (ca INT, cb INT, cr tb) DONT_REUSE_OID;
INSERT INTO tc VALUES (1, 100), (2, 200);
INSERT INTO tb (ca, cb, cr) SELECT 1, 5, c FROM tc c WHERE c.ca = 1;
INSERT INTO tb (ca, cb, cr) SELECT 1, 15, c FROM tc c WHERE c.ca = 2;
INSERT INTO tb (ca, cb, cr) VALUES (2, 100, NULL);
INSERT INTO tb (ca, cb, cr) SELECT 3, 7, c FROM tc c WHERE c.ca = 1;
INSERT INTO ta (ca, cb, cr) SELECT 1, 100, b FROM tb b WHERE b.ca = 1 AND b.cb = 5;
INSERT INTO ta (ca, cb, cr) SELECT 2, 200, b FROM tb b WHERE b.ca = 2;
INSERT INTO ta (ca, cb, cr) SELECT 3, 7, b FROM tb b WHERE b.ca = 3;
INSERT INTO ta (ca, cb, cr) VALUES (4, 0, NULL);
UPDATE STATISTICS ON ta, tb, tc;

-- EXISTS subquery select list, result and plan
evaluate 'EXISTS subquery select list, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE EXISTS (SELECT tb.cr.cb /* path expression */ FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb, tc;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-4-04-07: select list of a NOT IN subquery
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-4-04-07: select list of a NOT IN subquery';

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE tc (ca INT, cb INT) DONT_REUSE_OID;
CREATE TABLE tb (ca INT, cb INT, cr tc) DONT_REUSE_OID;
CREATE TABLE ta (ca INT, cb INT, cr tb) DONT_REUSE_OID;
INSERT INTO tc VALUES (1, 100), (2, 200);
INSERT INTO tb (ca, cb, cr) SELECT 1, 5, c FROM tc c WHERE c.ca = 1;
INSERT INTO tb (ca, cb, cr) SELECT 1, 15, c FROM tc c WHERE c.ca = 2;
INSERT INTO tb (ca, cb, cr) VALUES (2, 100, NULL);
INSERT INTO tb (ca, cb, cr) SELECT 3, 7, c FROM tc c WHERE c.ca = 1;
INSERT INTO ta (ca, cb, cr) SELECT 1, 100, b FROM tb b WHERE b.ca = 1 AND b.cb = 5;
INSERT INTO ta (ca, cb, cr) SELECT 2, 200, b FROM tb b WHERE b.ca = 2;
INSERT INTO ta (ca, cb, cr) SELECT 3, 7, b FROM tb b WHERE b.ca = 3;
INSERT INTO ta (ca, cb, cr) VALUES (4, 0, NULL);
UPDATE STATISTICS ON ta, tb, tc;

-- NOT IN subquery select list, result and plan
evaluate 'NOT IN subquery select list, result and plan';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca
FROM ta
WHERE ta.cb NOT IN (SELECT tb.cr.cb /* path expression */ FROM tb WHERE tb.ca = ta.ca)
ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta, tb, tc;

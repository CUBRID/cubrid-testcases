/**
 *  This test case verifies CBRD-27379: SEMI JOIN and ANTI JOIN run as a hash join.
 *  Part 3 of 5 -- plan selection (TC-2-01).
 *
 *  Before the fix, the planner skipped hash join costing for SEMI / ANTI JOIN. Now a hash join is a candidate for them,
 *  and USE_HASH / NO_USE_HASH decide the join method whether the hint is written in the outer query
 *  or in the subquery that is unnested into the SEMI / ANTI JOIN.
 *
 *  Coverage:
 *    TC-2-01-01, 02:   SEMI JOIN and ANTI JOIN with USE_HASH and with NO_USE_HASH
 *    TC-2-01-03:       unnested NOT IN with USE_HASH
 *    TC-2-01-04, 05:   EXISTS / NOT EXISTS without a hint and with USE_HASH, USE_HASH(tb), NO_USE_HASH, NO_USE_HASH(tb)
 *                      in the outer query or in the subquery, with and without an index on tb.ca
 *
 *  CTP runs with test_mode=yes, so cost and cardinality in a --@queryplan output are masked.
 *  The plan lines assert the join method and join type.
 */

-- =====================================================================================================================
-- TC-2-01: USE_HASH / NO_USE_HASH hints and where they are written
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-01: SEMI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-01: SEMI JOIN';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL);
INSERT INTO tb VALUES (1, 5), (1, 15), (1, 25), (2, 100);
UPDATE STATISTICS ON ta, tb;

-- USE_HASH, plan
evaluate 'USE_HASH, plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;

-- NO_USE_HASH, plan
evaluate 'NO_USE_HASH, plan';
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
CREATE TABLE ta (ca INT, cb INT, cc INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta VALUES (1, 10, 1), (2, 20, 2), (3, 30, NULL);
INSERT INTO tb VALUES (1, 5), (1, 15), (1, 25), (2, 100);
UPDATE STATISTICS ON ta, tb;

-- USE_HASH, plan
evaluate 'USE_HASH, plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;

-- NO_USE_HASH, plan
evaluate 'NO_USE_HASH, plan';
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
CREATE TABLE ta (ca INT PRIMARY KEY, cb INT NOT NULL);
CREATE TABLE tb (ca INT PRIMARY KEY);
INSERT INTO ta VALUES (1, 1000), (2, 2000), (3, 1000), (4, 9999), (5, 1000);
INSERT INTO tb VALUES (1000), (2000);
UPDATE STATISTICS ON ta, tb;

-- USE_HASH, plan
evaluate 'USE_HASH, plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ ta.ca
FROM ta
WHERE ta.cb NOT IN (SELECT ca FROM tb);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-04: index on tb.ca
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-04: index on tb.ca';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 2000;
INSERT INTO tb SELECT MOD (ROWNUM, 500), ROWNUM FROM db_class a, db_class b LIMIT 2000;
CREATE INDEX i_tb_ca ON tb (ca);
UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- EXISTS, no hint, plan
evaluate 'EXISTS, no hint, plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- EXISTS, outer query USE_HASH, plan
evaluate 'EXISTS, outer query USE_HASH, plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- EXISTS, subquery USE_HASH, plan
evaluate 'EXISTS, subquery USE_HASH, plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT /*+ USE_HASH */ 1 FROM tb WHERE tb.ca = ta.ca);

-- EXISTS, subquery USE_HASH(tb), plan
evaluate 'EXISTS, subquery USE_HASH(tb), plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT /*+ USE_HASH(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- NOT EXISTS, no hint, plan
evaluate 'NOT EXISTS, no hint, plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- NOT EXISTS, outer query USE_HASH, plan
evaluate 'NOT EXISTS, outer query USE_HASH, plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- NOT EXISTS, subquery USE_HASH, plan
evaluate 'NOT EXISTS, subquery USE_HASH, plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ USE_HASH */ 1 FROM tb WHERE tb.ca = ta.ca);

-- NOT EXISTS, subquery USE_HASH(tb), plan
evaluate 'NOT EXISTS, subquery USE_HASH(tb), plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ USE_HASH(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-2-01-05: no index on tb.ca
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-2-01-05: no index on tb.ca';

DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO ta SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 2000;
INSERT INTO tb SELECT MOD (ROWNUM, 500), ROWNUM FROM db_class a, db_class b LIMIT 2000;
CREATE INDEX i_tb_ca ON tb (ca);
UPDATE STATISTICS ON ta, tb WITH FULLSCAN;
DROP INDEX i_tb_ca ON tb;

-- EXISTS, no hint, plan
evaluate 'EXISTS, no hint, plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- EXISTS, outer query NO_USE_HASH, plan
evaluate 'EXISTS, outer query NO_USE_HASH, plan';
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- EXISTS, subquery NO_USE_HASH, plan
evaluate 'EXISTS, subquery NO_USE_HASH, plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT /*+ NO_USE_HASH */ 1 FROM tb WHERE tb.ca = ta.ca);

-- EXISTS, subquery NO_USE_HASH(tb), plan
evaluate 'EXISTS, subquery NO_USE_HASH(tb), plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT /*+ NO_USE_HASH(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- NOT EXISTS, no hint, plan
evaluate 'NOT EXISTS, no hint, plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- NOT EXISTS, outer query NO_USE_HASH, plan
evaluate 'NOT EXISTS, outer query NO_USE_HASH, plan';
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca);

-- NOT EXISTS, subquery NO_USE_HASH, plan
evaluate 'NOT EXISTS, subquery NO_USE_HASH, plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ NO_USE_HASH */ 1 FROM tb WHERE tb.ca = ta.ca);

-- NOT EXISTS, subquery NO_USE_HASH(tb), plan
evaluate 'NOT EXISTS, subquery NO_USE_HASH(tb), plan';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT (*)
FROM ta
WHERE NOT EXISTS (SELECT /*+ NO_USE_HASH(tb) */ 1 FROM tb WHERE tb.ca = ta.ca);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

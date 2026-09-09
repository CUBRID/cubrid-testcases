/**
 * This test case verifies CBRD-25531: unreferenced select-list items of a
 * non-mergeable inline view are now pruned even when the view contains an
 * analytic function, matching the pruning already done for a plain view.
 * Each case runs as both an inline view and a named view (always
 * non-mergeable, pinning the pre-fix baseline).
 *
 * Coverage:
 * 1-2   analytic column referenced by main query or not
 * 3-7   OVER-clause reference shapes (main query, ordinal, missing,
 *       expression, scalar subquery)
 * 8-11  outer ORDER BY / GROUP BY vs the OVER-clause column
 * 12-14 join query, no_merge hint with/without an analytic function
 * 15    regression: row_number() must match between a view and its
 *       equivalent inline view (select-list reorder desyncing OVER)
 * 16-17 PREPARE/EXECUTE path, two analytic functions with only one used
 * 18-20 ORDER BY inside OVER: ordinal reference, regression vs a view,
 *       both PARTITION BY and ORDER BY ordinals hidden-appended at once
 */

DROP TABLE IF EXISTS tbla;
CREATE TABLE tbla(cola INT AUTO_INCREMENT, colb INT, colc INT, cold INT);
INSERT INTO tbla(colb, colc, cold) VALUES
(1,1,1),
(1,1,2),
(1,2,2),
(1,2,3);

DROP TABLE IF EXISTS tblb;
CREATE TABLE tblb(cola INT, colb INT);
INSERT INTO tblb VALUES (1,1),(2,1),(3,2),(4,2);

evaluate 'Case 1: the analytic column is not referenced by the main query';
SELECT /*+ recompile */ COUNT(*)
FROM (SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla);
CREATE OR REPLACE VIEW va AS SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla;
SELECT /*+ recompile */ COUNT(*) FROM va;

evaluate 'Case 2: the analytic column is referenced by the main query';
SELECT /*+ recompile */ rn
FROM (SELECT cola, colb, colc, ROW_NUMBER() OVER() AS rn, cold FROM tbla) ORDER BY 1;
CREATE OR REPLACE VIEW vb AS SELECT cola, colb, colc, ROW_NUMBER() OVER() AS rn, cold FROM tbla;
SELECT /*+ recompile */ rn FROM vb ORDER BY 1;

evaluate 'Case 3: the OVER-clause column is also referenced by the main query';
SELECT /*+ recompile */ rn, colc
FROM (SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla) ORDER BY 1, 2;
CREATE OR REPLACE VIEW vc AS SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla;
SELECT /*+ recompile */ rn, colc FROM vc ORDER BY 1, 2;

evaluate 'Case 4: the OVER-clause column is referenced by ordinal, not by the main query';
SELECT /*+ recompile */ rn
FROM (SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY 3) AS rn, cold FROM tbla) ORDER BY 1;
CREATE OR REPLACE VIEW vd AS SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY 3) AS rn, cold FROM tbla;
SELECT /*+ recompile */ rn FROM vd ORDER BY 1;

evaluate 'Case 5: the OVER-clause column is missing from the view select list';
SELECT /*+ recompile */ rn
FROM (SELECT cola, colb, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla) ORDER BY 1;
CREATE OR REPLACE VIEW ve AS SELECT cola, colb, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla;
SELECT /*+ recompile */ rn FROM ve ORDER BY 1;

evaluate 'Case 6: the OVER-clause column is an expression over another column';
SELECT /*+ recompile */ rn
FROM (SELECT cola, colb, NVL(colc, 0) AS nvl_colc, ROW_NUMBER() OVER(PARTITION BY 3) AS rn, cold FROM tbla) ORDER BY 1;
CREATE OR REPLACE VIEW vf AS SELECT cola, colb, NVL(colc, 0) AS nvl_colc, ROW_NUMBER() OVER(PARTITION BY 3) AS rn, cold FROM tbla;
SELECT /*+ recompile */ rn FROM vf ORDER BY 1;

evaluate 'Case 7: the OVER-clause column is a scalar subquery';
SELECT /*+ recompile */ rn
FROM (SELECT cola, colb, (SELECT MAX(colc) FROM tbla) AS max_colc, ROW_NUMBER() OVER(PARTITION BY 3) AS rn FROM tbla) ORDER BY 1;
CREATE OR REPLACE VIEW vg AS SELECT cola, colb, (SELECT MAX(colc) FROM tbla) AS max_colc, ROW_NUMBER() OVER(PARTITION BY 3) AS rn FROM tbla;
SELECT /*+ recompile */ rn FROM vg ORDER BY 1;

evaluate 'Case 8: outer ORDER BY column is also referenced by the analytic function';
SELECT /*+ recompile */ rn
FROM (SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla ORDER BY colc) ORDER BY 1;
CREATE OR REPLACE VIEW vh AS SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla ORDER BY colc;
SELECT /*+ recompile */ rn FROM vh ORDER BY 1;

evaluate 'Case 9: outer ORDER BY column is not referenced by the analytic function';
SELECT /*+ recompile */ rn
FROM (SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla ORDER BY cola) ORDER BY 1;
CREATE OR REPLACE VIEW vi AS SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla ORDER BY cola;
SELECT /*+ recompile */ rn FROM vi ORDER BY 1;

evaluate 'Case 10: outer GROUP BY column is also referenced by the analytic function';
SELECT /*+ recompile */ rn
FROM (SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla GROUP BY colc) ORDER BY 1;
CREATE OR REPLACE VIEW vj AS SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla GROUP BY colc;
SELECT /*+ recompile */ rn FROM vj ORDER BY 1;

evaluate 'Case 11: outer GROUP BY column is not referenced by the analytic function';
SELECT /*+ recompile */ rn
FROM (SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla GROUP BY cola) ORDER BY 1;
CREATE OR REPLACE VIEW vk AS SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla GROUP BY cola;
SELECT /*+ recompile */ rn FROM vk ORDER BY 1;

evaluate 'Case 12: join query';
SELECT /*+ recompile */ rn
FROM (SELECT tbla.cola AS tbla_cola, tblb.cola AS tblb_cola, ROW_NUMBER() OVER(PARTITION BY tblb.colb) AS rn FROM tbla, tblb WHERE tbla.cola = tblb.cola) ORDER BY 1;
CREATE OR REPLACE VIEW vl AS SELECT tbla.cola AS tbla_cola, tblb.cola AS tblb_cola, ROW_NUMBER() OVER(PARTITION BY tblb.colb) AS rn FROM tbla, tblb WHERE tbla.cola = tblb.cola;
SELECT /*+ recompile */ rn FROM vl ORDER BY 1;

evaluate 'Case 13: no_merge hint, view contains an analytic function';
SELECT /*+ recompile */ rn, colc
FROM (SELECT /*+ no_merge */ cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla) ORDER BY 1, 2;
CREATE OR REPLACE VIEW vm AS SELECT /*+ no_merge */ cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbla;
SELECT /*+ recompile */ rn, colc FROM vm ORDER BY 1, 2;

evaluate 'Case 14: no_merge hint, view has no analytic function -- no_merge disables list pruning outright, with or without an analytic function';
SELECT /*+ recompile */ cola
FROM (SELECT /*+ no_merge */ cola, colb, colc, cold FROM tbla) ORDER BY 1;
CREATE OR REPLACE VIEW vn AS SELECT /*+ no_merge */ cola, colb, colc, cold FROM tbla;
SELECT /*+ recompile */ cola FROM vn ORDER BY 1;

DROP VIEW va;
DROP VIEW vb;
DROP VIEW vc;
DROP VIEW vd;
DROP VIEW ve;
DROP VIEW vf;
DROP VIEW vg;
DROP VIEW vh;
DROP VIEW vi;
DROP VIEW vj;
DROP VIEW vk;
DROP VIEW vl;
DROP VIEW vm;
DROP VIEW vn;
DROP TABLE tbla, tblb;

evaluate 'Case 15: row_number() result must match between a named view and its equivalent inline view';
DROP TABLE IF EXISTS tblc;
CREATE TABLE tblc(cola INT AUTO_INCREMENT, colb INT, colc INT, cold INT);
INSERT INTO tblc(colb, colc, cold) VALUES
(1,1,1),
(1,1,2),
(1,1,3),
(1,1,4),
(1,1,5),
(1,2,1),
(1,2,2),
(1,2,3),
(1,2,4);

CREATE OR REPLACE VIEW vo AS SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tblc;

SELECT /*+ recompile */ rn FROM vo ORDER BY 1;
SELECT /*+ recompile */ rn
FROM (SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tblc) ORDER BY 1;

DROP VIEW vo;
DROP TABLE tblc;

DROP TABLE IF EXISTS tbld;
CREATE TABLE tbld(cola INT AUTO_INCREMENT, colb INT, colc INT, cold INT);
INSERT INTO tbld(colb, colc, cold) VALUES
(1,1,1),
(1,1,2),
(1,1,3),
(1,2,1),
(1,2,2);

evaluate 'Case 16: PREPARE/EXECUTE compiles and runs the pruned plan correctly';
PREPARE stmt1 FROM 'SELECT rn FROM (SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rn, cold FROM tbld) WHERE rn > ? ORDER BY 1';
EXECUTE stmt1 USING 0;
DEALLOCATE PREPARE stmt1;

evaluate 'Case 17: two analytic functions in the view, only one referenced by the main query';
SELECT /*+ recompile */ rna
FROM (SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rna, RANK() OVER(ORDER BY colb) AS rnb, cold FROM tbld) ORDER BY 1;
CREATE OR REPLACE VIEW vq AS SELECT cola, colb, colc, ROW_NUMBER() OVER(PARTITION BY colc) AS rna, RANK() OVER(ORDER BY colb) AS rnb, cold FROM tbld;
SELECT /*+ recompile */ rna FROM vq ORDER BY 1;

evaluate 'Case 18: ORDER BY inside the OVER clause, referenced by ordinal -- ROW_NUMBER would not catch a wrong ordinal (its value set is order-invariant), so use a running SUM whose value depends on the actual row order';
SELECT /*+ recompile */ cola, s
FROM (SELECT cola, colb, colc, SUM(cold) OVER(PARTITION BY colc ORDER BY 1) AS s, cold FROM tbld) ORDER BY 1;
CREATE OR REPLACE VIEW vr AS SELECT cola, colb, colc, SUM(cold) OVER(PARTITION BY colc ORDER BY 1) AS s, cold FROM tbld;
SELECT /*+ recompile */ cola, s FROM vr ORDER BY 1;

evaluate 'Case 19: regression -- the running SUM must match between a view and its equivalent inline view';
CREATE OR REPLACE VIEW vs AS SELECT cola, colb, colc, SUM(cold) OVER(PARTITION BY colc ORDER BY cola DESC) AS s, cold FROM tbld;
SELECT /*+ recompile */ cola, s FROM vs ORDER BY 1;
SELECT /*+ recompile */ cola, s
FROM (SELECT cola, colb, colc, SUM(cold) OVER(PARTITION BY colc ORDER BY cola DESC) AS s, cold FROM tbld) ORDER BY 1;

evaluate 'Case 20: both the PARTITION BY and ORDER BY ordinals reference columns the main query does not select -- both must be re-added as hidden columns at once';
SELECT /*+ recompile */ s
FROM (SELECT cola, colb, colc, cold, SUM(cold) OVER(PARTITION BY 3 ORDER BY 1) AS s FROM tbld) ORDER BY 1;
CREATE OR REPLACE VIEW vt AS SELECT cola, colb, colc, cold, SUM(cold) OVER(PARTITION BY 3 ORDER BY 1) AS s FROM tbld;
SELECT /*+ recompile */ s FROM vt ORDER BY 1;

DROP VIEW vq;
DROP VIEW vr;
DROP VIEW vs;
DROP VIEW vt;
DROP TABLE tbld;

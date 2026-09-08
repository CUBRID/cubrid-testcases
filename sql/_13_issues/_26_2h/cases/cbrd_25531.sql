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

DROP TABLE IF EXISTS t1;
CREATE TABLE t1(c1 INT AUTO_INCREMENT, c2 INT, c3 INT, c4 INT);
INSERT INTO t1(c2, c3, c4) VALUES
(1,1,1),
(1,1,2),
(1,2,2),
(1,2,3);

DROP TABLE IF EXISTS t2;
CREATE TABLE t2(c1 INT, c2 INT);
INSERT INTO t2 VALUES (1,1),(2,1),(3,2),(4,2);

evaluate 'Case 1: the analytic column is not referenced by the main query';
SELECT /*+ recompile */ COUNT(*)
FROM (SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1);
CREATE OR REPLACE VIEW v1 AS SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1;
SELECT /*+ recompile */ COUNT(*) FROM v1;

evaluate 'Case 2: the analytic column is referenced by the main query';
SELECT /*+ recompile */ rn
FROM (SELECT c1, c2, c3, ROW_NUMBER() OVER() AS rn, c4 FROM t1) ORDER BY 1;
CREATE OR REPLACE VIEW v2 AS SELECT c1, c2, c3, ROW_NUMBER() OVER() AS rn, c4 FROM t1;
SELECT /*+ recompile */ rn FROM v2 ORDER BY 1;

evaluate 'Case 3: the OVER-clause column is also referenced by the main query';
SELECT /*+ recompile */ rn, c3
FROM (SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1) ORDER BY 1, 2;
CREATE OR REPLACE VIEW v3 AS SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1;
SELECT /*+ recompile */ rn, c3 FROM v3 ORDER BY 1, 2;

evaluate 'Case 4: the OVER-clause column is referenced by ordinal, not by the main query';
SELECT /*+ recompile */ rn
FROM (SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY 3) AS rn, c4 FROM t1) ORDER BY 1;
CREATE OR REPLACE VIEW v4 AS SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY 3) AS rn, c4 FROM t1;
SELECT /*+ recompile */ rn FROM v4 ORDER BY 1;

evaluate 'Case 5: the OVER-clause column is missing from the view select list';
SELECT /*+ recompile */ rn
FROM (SELECT c1, c2, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1) ORDER BY 1;
CREATE OR REPLACE VIEW v5 AS SELECT c1, c2, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1;
SELECT /*+ recompile */ rn FROM v5 ORDER BY 1;

evaluate 'Case 6: the OVER-clause column is an expression over another column';
SELECT /*+ recompile */ rn
FROM (SELECT c1, c2, NVL(c3, 0) AS nvl_c3, ROW_NUMBER() OVER(PARTITION BY 3) AS rn, c4 FROM t1) ORDER BY 1;
CREATE OR REPLACE VIEW v6 AS SELECT c1, c2, NVL(c3, 0) AS nvl_c3, ROW_NUMBER() OVER(PARTITION BY 3) AS rn, c4 FROM t1;
SELECT /*+ recompile */ rn FROM v6 ORDER BY 1;

evaluate 'Case 7: the OVER-clause column is a scalar subquery';
SELECT /*+ recompile */ rn
FROM (SELECT c1, c2, (SELECT MAX(c3) FROM t1) AS max_c3, ROW_NUMBER() OVER(PARTITION BY 3) AS rn FROM t1) ORDER BY 1;
CREATE OR REPLACE VIEW v7 AS SELECT c1, c2, (SELECT MAX(c3) FROM t1) AS max_c3, ROW_NUMBER() OVER(PARTITION BY 3) AS rn FROM t1;
SELECT /*+ recompile */ rn FROM v7 ORDER BY 1;

evaluate 'Case 8: outer ORDER BY column is also referenced by the analytic function';
SELECT /*+ recompile */ rn
FROM (SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1 ORDER BY c3) ORDER BY 1;
CREATE OR REPLACE VIEW v8 AS SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1 ORDER BY c3;
SELECT /*+ recompile */ rn FROM v8 ORDER BY 1;

evaluate 'Case 9: outer ORDER BY column is not referenced by the analytic function';
SELECT /*+ recompile */ rn
FROM (SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1 ORDER BY c1) ORDER BY 1;
CREATE OR REPLACE VIEW v9 AS SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1 ORDER BY c1;
SELECT /*+ recompile */ rn FROM v9 ORDER BY 1;

evaluate 'Case 10: outer GROUP BY column is also referenced by the analytic function';
SELECT /*+ recompile */ rn
FROM (SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1 GROUP BY c3) ORDER BY 1;
CREATE OR REPLACE VIEW v10 AS SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1 GROUP BY c3;
SELECT /*+ recompile */ rn FROM v10 ORDER BY 1;

evaluate 'Case 11: outer GROUP BY column is not referenced by the analytic function';
SELECT /*+ recompile */ rn
FROM (SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1 GROUP BY c1) ORDER BY 1;
CREATE OR REPLACE VIEW v11 AS SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1 GROUP BY c1;
SELECT /*+ recompile */ rn FROM v11 ORDER BY 1;

evaluate 'Case 12: join query';
SELECT /*+ recompile */ rn
FROM (SELECT t1.c1 AS t1_c1, t2.c1 AS t2_c1, ROW_NUMBER() OVER(PARTITION BY t2.c2) AS rn FROM t1, t2 WHERE t1.c1 = t2.c1) ORDER BY 1;
CREATE OR REPLACE VIEW v12 AS SELECT t1.c1 AS t1_c1, t2.c1 AS t2_c1, ROW_NUMBER() OVER(PARTITION BY t2.c2) AS rn FROM t1, t2 WHERE t1.c1 = t2.c1;
SELECT /*+ recompile */ rn FROM v12 ORDER BY 1;

evaluate 'Case 13: no_merge hint, view contains an analytic function';
SELECT /*+ recompile */ rn, c3
FROM (SELECT /*+ no_merge */ c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1) ORDER BY 1, 2;
CREATE OR REPLACE VIEW v13 AS SELECT /*+ no_merge */ c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t1;
SELECT /*+ recompile */ rn, c3 FROM v13 ORDER BY 1, 2;

evaluate 'Case 14: no_merge hint, view has no analytic function -- no_merge disables list pruning outright, with or without an analytic function';
SELECT /*+ recompile */ c1
FROM (SELECT /*+ no_merge */ c1, c2, c3, c4 FROM t1) ORDER BY 1;
CREATE OR REPLACE VIEW v14 AS SELECT /*+ no_merge */ c1, c2, c3, c4 FROM t1;
SELECT /*+ recompile */ c1 FROM v14 ORDER BY 1;

DROP VIEW v1;
DROP VIEW v2;
DROP VIEW v3;
DROP VIEW v4;
DROP VIEW v5;
DROP VIEW v6;
DROP VIEW v7;
DROP VIEW v8;
DROP VIEW v9;
DROP VIEW v10;
DROP VIEW v11;
DROP VIEW v12;
DROP VIEW v13;
DROP VIEW v14;
DROP TABLE t1, t2;

evaluate 'Case 15: row_number() result must match between a named view and its equivalent inline view';
DROP TABLE IF EXISTS t3;
CREATE TABLE t3(c1 INT AUTO_INCREMENT, c2 INT, c3 INT, c4 INT);
INSERT INTO t3(c2, c3, c4) VALUES
(1,1,1),
(1,1,2),
(1,1,3),
(1,1,4),
(1,1,5),
(1,2,1),
(1,2,2),
(1,2,3),
(1,2,4);

CREATE OR REPLACE VIEW v15 AS SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t3;

SELECT /*+ recompile */ rn FROM v15 ORDER BY 1;
SELECT /*+ recompile */ rn
FROM (SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t3) ORDER BY 1;

DROP VIEW v15;
DROP TABLE t3;

DROP TABLE IF EXISTS t4;
CREATE TABLE t4(c1 INT AUTO_INCREMENT, c2 INT, c3 INT, c4 INT);
INSERT INTO t4(c2, c3, c4) VALUES
(1,1,1),
(1,1,2),
(1,1,3),
(1,2,1),
(1,2,2);

evaluate 'Case 16: PREPARE/EXECUTE compiles and runs the pruned plan correctly';
PREPARE stmt1 FROM 'SELECT rn FROM (SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn, c4 FROM t4) WHERE rn > ? ORDER BY 1';
EXECUTE stmt1 USING 0;
DEALLOCATE PREPARE stmt1;

evaluate 'Case 17: two analytic functions in the view, only one referenced by the main query';
SELECT /*+ recompile */ rn1
FROM (SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn1, RANK() OVER(ORDER BY c2) AS rn2, c4 FROM t4) ORDER BY 1;
CREATE OR REPLACE VIEW v17 AS SELECT c1, c2, c3, ROW_NUMBER() OVER(PARTITION BY c3) AS rn1, RANK() OVER(ORDER BY c2) AS rn2, c4 FROM t4;
SELECT /*+ recompile */ rn1 FROM v17 ORDER BY 1;

evaluate 'Case 18: ORDER BY inside the OVER clause, referenced by ordinal -- ROW_NUMBER would not catch a wrong ordinal (its value set is order-invariant), so use a running SUM whose value depends on the actual row order';
SELECT /*+ recompile */ c1, s
FROM (SELECT c1, c2, c3, SUM(c4) OVER(PARTITION BY c3 ORDER BY 1) AS s, c4 FROM t4) ORDER BY 1;
CREATE OR REPLACE VIEW v18 AS SELECT c1, c2, c3, SUM(c4) OVER(PARTITION BY c3 ORDER BY 1) AS s, c4 FROM t4;
SELECT /*+ recompile */ c1, s FROM v18 ORDER BY 1;

evaluate 'Case 19: regression -- the running SUM must match between a view and its equivalent inline view';
CREATE OR REPLACE VIEW v19 AS SELECT c1, c2, c3, SUM(c4) OVER(PARTITION BY c3 ORDER BY c1 DESC) AS s, c4 FROM t4;
SELECT /*+ recompile */ c1, s FROM v19 ORDER BY 1;
SELECT /*+ recompile */ c1, s
FROM (SELECT c1, c2, c3, SUM(c4) OVER(PARTITION BY c3 ORDER BY c1 DESC) AS s, c4 FROM t4) ORDER BY 1;

evaluate 'Case 20: both the PARTITION BY and ORDER BY ordinals reference columns the main query does not select -- both must be re-added as hidden columns at once';
SELECT /*+ recompile */ s
FROM (SELECT c1, c2, c3, c4, SUM(c4) OVER(PARTITION BY 3 ORDER BY 1) AS s FROM t4) ORDER BY 1;
CREATE OR REPLACE VIEW v20 AS SELECT c1, c2, c3, c4, SUM(c4) OVER(PARTITION BY 3 ORDER BY 1) AS s FROM t4;
SELECT /*+ recompile */ s FROM v20 ORDER BY 1;

DROP VIEW v17;
DROP VIEW v18;
DROP VIEW v19;
DROP VIEW v20;
DROP TABLE t4;

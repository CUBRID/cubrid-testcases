/**
 * This test case verifies CBRD-27442: Join order and term skipping ignore what
 * an outer join's ON clause requires, so its result comes out wrong
 *
 * The engine fix has two parts:
 *  (1) qo_analyze_term(): every node an outer join's ON-clause predicate reads
 *      now goes into that outer-join node's QO_NODE_OUTER_DEP_SET, so the
 *      planner can no longer join the outer-join node before it and lose the
 *      NULL-padded rows. Covers the two-table predicate (QO_TC_OTHER) and the
 *      one-table predicate (QO_TC_SARG).
 *  (2) qo_check_skip_term(): an outer join's ON equality no longer counts as
 *      connecting the eqclass, so a later outer join's term is not dropped.
 *
 * This TC extends sql/_35_fig_cake/cbrd_24044/cbrd_25214. Its queries -11 to
 * -14 and -11-1 to -14-1 already cover fix (2) when the supporting equality
 * comes from a LEFT OUTER JOIN's ON clause, and are not repeated here. This TC
 * adds fix (1) and the RIGHT-OUTER-JOIN-sourced shape of fix (2), using the
 * issue author's scenarios 1-12 (groups A-D) with their data and hints.
 *
 * The oracle is the result values only (no .queryPlan): a COUNT(*), or ordered
 * rows that the outer join must preserve. [D] = the issue author measured a
 * different result on a build without the fix, [G] = constraint guard, same
 * result on both builds, kept to catch a later regression.
 *
 * Coverage:
 * Group A - ta 100 rows, tb 10000, tc 1, and ta JOIN tb is 10000 rows. The one-row
 *   tc makes joining it before tb look cheapest, the row-losing order.
 * 1. [D] LEFT JOIN tc, ON also reads ta and tb (ta.cb = tb.cb), USE_NL
 * 2. [D] LEFT JOIN tc, ON also reads tb only (tb.cb = -1, never true), USE_NL
 * 3. [D] Case 1 with USE_MERGE
 * 4. [D] Case 1 with USE_HASH
 * 5. [D] Case 1 with LEADING(ta, tc, tb), the row-losing order: the ON-clause
 *        dependency must win over the hint
 * 6. [G] ta RIGHT JOIN tb, then LEFT JOIN tc whose ON also reads ta
 * Group B - tc 100 rows, preserved by a trailing RIGHT JOIN. Before the fix
 *   qo_optimize_helper() already made the right-outer node depend on the whole
 *   preceding explicit join, so 8-9 guard that constraint (they would drop
 *   to 0). Every tc row has a match in Case 7, so it guards only against its
 *   ta.cb = tb.cb term being dropped (the count would become 10000).
 * 7. [G] RIGHT JOIN tc, ON also reads ta and tb
 * 8. [G] RIGHT JOIN tc, ON also reads tb only
 * 9. [G] td JOIN ta JOIN tb RIGHT JOIN tc, ON also reads the first table td
 * Group C - two rows per table, ta.ca primary key.
 * 10. [D] LEFT JOIN tc ON ... AND tb.cb > 5, ORDER BY ta.ca: row (1, 3, NULL)
 *        must stay. The ORDER BY is the trigger, not only a sort: skipping the
 *        sort on the ta.ca PK made the pre-fix optimizer drive from ta and join
 *        tc before tb (issue author's pre-fix plan).
 * 11. [G] Case 10 with ORDER BY tb.cb (no index, no sort skip)
 * Group D - fix (2) with the supporting equality from a RIGHT OUTER JOIN.
 * 12. [D] tc RIGHT JOIN ta ON tc.ca = ta.ca AND tc.ca = ta.cb, then LEFT JOIN tb
 *        ON ta.ca = tb.ca AND ta.cb = tb.ca: both LEFT JOIN terms must be
 *        applied, so only ta row (1, 1) matches tb and the other three rows
 *        get d NULL.
 */

-- ============================================================================
-- Group A: LEFT OUTER JOIN must keep all 10000 rows of ta JOIN tb
-- ============================================================================

DROP TABLE IF EXISTS ta;
CREATE TABLE ta (ca INT, cb INT);
DROP TABLE IF EXISTS tb;
CREATE TABLE tb (ca INT, cb INT);
DROP TABLE IF EXISTS tc;
CREATE TABLE tc (ca INT);

INSERT INTO ta
WITH RECURSIVE cte (n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM cte WHERE n < 100)
SELECT ROWNUM, ROWNUM FROM cte;

INSERT INTO tb
WITH RECURSIVE cte (n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM cte WHERE n < 100)
SELECT (ROWNUM - 1) % 100 + 1, (ROWNUM - 1) / 100 + 1 FROM cte x, cte y;

INSERT INTO tc VALUES (1);

UPDATE STATISTICS ON ta, tb, tc;

evaluate 'Case 1: USE_NL, LEFT JOIN ON also reads ta and tb (ta.cb = tb.cb) - LEFT OUTER JOIN keeps all 10000 rows';
SELECT /*+ RECOMPILE USE_NL */ COUNT(*) FROM ta JOIN tb ON tb.ca = ta.ca
  LEFT JOIN tc ON tc.ca = ta.ca AND ta.cb = tb.cb;

evaluate 'Case 2: USE_NL, LEFT JOIN ON adds a tb-only predicate (tb.cb = -1, never true) - LEFT OUTER JOIN keeps all 10000 rows';
SELECT /*+ RECOMPILE USE_NL */ COUNT(*) FROM ta JOIN tb ON tb.ca = ta.ca
  LEFT JOIN tc ON tc.ca = ta.ca AND tb.cb = -1;

evaluate 'Case 3: USE_MERGE, same query as Case 1 - LEFT OUTER JOIN keeps all 10000 rows';
SELECT /*+ RECOMPILE USE_MERGE */ COUNT(*) FROM ta JOIN tb ON tb.ca = ta.ca
  LEFT JOIN tc ON tc.ca = ta.ca AND ta.cb = tb.cb;

-- note: the LEADING and USE_HASH hints exist from 11.4 only. On the 11.0 and
-- 11.3 backport branches they are ignored, so Cases 4-5 run as Case 1 with the
-- same answer, and Group D reproduces from 11.4 only (issue Test Build table).
evaluate 'Case 4: USE_HASH, same query as Case 1 - LEFT OUTER JOIN keeps all 10000 rows';
SELECT /*+ RECOMPILE USE_HASH */ COUNT(*) FROM ta JOIN tb ON tb.ca = ta.ca
  LEFT JOIN tc ON tc.ca = ta.ca AND ta.cb = tb.cb;

evaluate 'Case 5: USE_NL LEADING(ta, tc, tb) names the row-losing order, the ON dependency overrides it - all 10000 rows kept';
SELECT /*+ RECOMPILE USE_NL LEADING(ta, tc, tb) */ COUNT(*) FROM ta JOIN tb ON tb.ca = ta.ca
  LEFT JOIN tc ON tc.ca = ta.ca AND ta.cb = tb.cb;

evaluate 'Case 6: guard, ta RIGHT JOIN tb then LEFT JOIN tc whose ON also reads ta (ta.cb = -1) - all 10000 tb rows kept';
SELECT /*+ RECOMPILE USE_NL */ COUNT(*) FROM ta RIGHT JOIN tb ON tb.ca = ta.ca
  LEFT JOIN tc ON tc.ca = tb.ca AND ta.cb = -1;

-- ============================================================================
-- Group B: RIGHT OUTER JOIN must keep all 100 rows of tc
-- ============================================================================

DROP TABLE IF EXISTS ta;
CREATE TABLE ta (ca INT, cb INT);
DROP TABLE IF EXISTS tb;
CREATE TABLE tb (ca INT, cb INT);
DROP TABLE IF EXISTS tc;
CREATE TABLE tc (ca INT);
DROP TABLE IF EXISTS td;
CREATE TABLE td (ca INT, cb INT);

INSERT INTO ta
WITH RECURSIVE cte (n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM cte WHERE n < 100)
SELECT ROWNUM, ROWNUM FROM cte;

INSERT INTO tb
WITH RECURSIVE cte (n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM cte WHERE n < 100)
SELECT (ROWNUM - 1) % 100 + 1, (ROWNUM - 1) / 100 + 1 FROM cte x, cte y;

INSERT INTO tc
WITH RECURSIVE cte (n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM cte WHERE n < 100)
SELECT ROWNUM FROM cte;

INSERT INTO td
WITH RECURSIVE cte (n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM cte WHERE n < 100)
SELECT ROWNUM, ROWNUM FROM cte;

UPDATE STATISTICS ON ta, tb, tc, td;

evaluate 'Case 7: guard, USE_NL, RIGHT JOIN ON also reads ta and tb (ta.cb = tb.cb) - RIGHT OUTER JOIN keeps all 100 tc rows';
SELECT /*+ RECOMPILE USE_NL */ COUNT(*) FROM ta JOIN tb ON tb.ca = ta.ca
  RIGHT JOIN tc ON tc.ca = ta.ca AND ta.cb = tb.cb;

evaluate 'Case 8: guard, USE_NL, RIGHT JOIN ON adds a tb-only predicate (tb.cb = -1) - RIGHT OUTER JOIN keeps all 100 tc rows';
SELECT /*+ RECOMPILE USE_NL */ COUNT(*) FROM ta JOIN tb ON tb.ca = ta.ca
  RIGHT JOIN tc ON tc.ca = ta.ca AND tb.cb = -1;

evaluate 'Case 9: guard, USE_NL, td JOIN ta JOIN tb then RIGHT JOIN tc whose ON also reads the first table td - all 100 tc rows kept';
SELECT /*+ RECOMPILE USE_NL */ COUNT(*) FROM td JOIN ta ON ta.ca = td.ca JOIN tb ON tb.ca = ta.ca
  RIGHT JOIN tc ON tc.ca = ta.ca AND td.cb = -1;

-- ============================================================================
-- Group C: a sort skip on the ta.ca primary key must not change the result
-- ============================================================================

DROP TABLE IF EXISTS ta;
CREATE TABLE ta (ca INT PRIMARY KEY, cb INT);
DROP TABLE IF EXISTS tb;
CREATE TABLE tb (ca INT, cb INT);
DROP TABLE IF EXISTS tc;
CREATE TABLE tc (ca INT PRIMARY KEY);

INSERT INTO ta VALUES (1, 10), (2, 20);
INSERT INTO tb VALUES (1, 3), (2, 7);
INSERT INTO tc VALUES (1), (2);

UPDATE STATISTICS ON ta, tb, tc;

-- ORDER BY ta.ca is the trigger under test (sort skip on the PK), see header
evaluate 'Case 10: ORDER BY ta.ca (sort skip on PK), LEFT JOIN ON also reads tb (tb.cb > 5) - row 1, 3, NULL is kept';
SELECT /*+ RECOMPILE */ ta.ca, tb.cb, tc.ca FROM ta JOIN tb ON tb.ca = ta.ca
  LEFT JOIN tc ON tc.ca = ta.ca AND tb.cb > 5 ORDER BY ta.ca;

evaluate 'Case 11: guard, same query as Case 10 with ORDER BY tb.cb (no index, no sort skip) - same two rows';
SELECT /*+ RECOMPILE */ ta.ca, tb.cb, tc.ca FROM ta JOIN tb ON tb.ca = ta.ca
  LEFT JOIN tc ON tc.ca = ta.ca AND tb.cb > 5 ORDER BY tb.cb;

-- ============================================================================
-- Group D: an equality in a RIGHT OUTER JOIN's ON clause must not let a later
-- outer join's term be skipped
-- ============================================================================

DROP TABLE IF EXISTS ta;
CREATE TABLE ta (ca INT, cb INT);
DROP TABLE IF EXISTS tb;
CREATE TABLE tb (ca INT);
DROP TABLE IF EXISTS tc;
CREATE TABLE tc (ca INT);

-- ta holds all four (ca, cb) combinations, and only (1, 1) has ca = cb
INSERT INTO ta VALUES (1, 1), (1, 3), (2, 1), (2, 3);
INSERT INTO tb VALUES (1), (3), (5);
INSERT INTO tc VALUES (1), (5);

UPDATE STATISTICS ON ta, tb, tc;

evaluate 'Case 12: RIGHT JOIN ON equalities put ta.ca, ta.cb in one eqclass, both LEFT JOIN terms are kept - only row 1, 1 gets d';
SELECT /*+ RECOMPILE */ tc.ca AS c, ta.ca AS a, ta.cb AS b, tb.ca AS d
  FROM tc RIGHT JOIN ta ON tc.ca = ta.ca AND tc.ca = ta.cb
  LEFT JOIN tb ON ta.ca = tb.ca AND ta.cb = tb.ca
  ORDER BY 2, 3;

DROP TABLE ta;
DROP TABLE tb;
DROP TABLE tc;
DROP TABLE td;

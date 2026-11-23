/**
 *  This test case verifies CBRD-27483: Join graph has no edge to the tables that the ON clause of an outer, semi
 *  or anti join depends on, so the query fails or returns a wrong result
 *
 *  An outer join must come after every table that its ON reads. A CROSS JOIN, or a merged view whose FROM is a
 *  comma join, can leave such a table with no join edge to the others, and the planner then keeps a join order
 *  that puts the outer join first or finds no join order at all. The fix adds join edges to the tables that the
 *  ON reads. Each case prints the rows of the join, which must be the rows that the join defines.
 *  Cases 1 - 13 are scenarios 1 - 13 of the Jira attachment cbrd-27483_test_scenarios_20260929_1945.md.
 *  The cases that fail without the fix also print their plan, which shows the outer join after every table that
 *  its ON reads, and so do the cases with a join order hint, whose plan shows whether the hint was applied. Those
 *  queries carry RECOMPILE because a plan prints only when the query is compiled.
 *  The order of the two tables of a CROSS JOIN in a plan is decided by cost, not by a dependency, so a change of
 *  the cost model can change those plan lines.
 *
 *  Coverage:
 *    Case 1:   scenario 1 - a LEFT JOIN whose ON reads only the two tables of the CROSS JOIN
 *    Case 2:   scenario 2 - a LEFT JOIN whose ON joins the inner table to the second table and filters the first
 *    Case 3:   scenario 3 - a RIGHT JOIN pads the unmatched row of tc once, not once per row of the CROSS JOIN
 *    Case 4:   scenario 4 - two CROSS JOINs before a LEFT JOIN whose ON reads the first and the last table
 *    Case 5:   scenario 5 - a LEFT JOIN whose ON reads both tables of a merged comma-join view
 *    Case 6:   scenario 6 - a merged comma-join view and a CROSS JOIN before the LEFT JOIN
 *    Case 7:   scenario 7 - a LEFT JOIN whose ON reads both tables of a merged view with an inner join
 *    Case 8:   scenario 8 - two LEFT JOINs, each after a CROSS JOIN, the second ON reads both CROSS JOINs
 *    Case 9:   scenario 9 - two LEFT JOINs whose ONs read the same two tables of the CROSS JOIN
 *    Case 10:  scenario 10 - three LEFT JOINs whose ONs read the same two tables of the CROSS JOIN
 *    Case 11:  scenario 11 - a RIGHT JOIN after a comma, joined to the table before the comma in the WHERE
 *    Case 12:  scenario 12 - Case 11 with the ORDERED hint, which the planner ignores
 *    Case 13:  scenario 13 - Case 11 with a LEADING hint, which the planner ignores
 *    Case 14:  a LEFT JOIN whose ON joins the inner table to both tables of the CROSS JOIN
 *    Case 15:  Case 14 with an IS NULL filter on the NULL-padded table in the WHERE
 *    Case 16:  Case 14 with a WHERE that reads the NULL-padded table and the second table of the CROSS JOIN
 *    Case 17:  a RIGHT JOIN after a CROSS JOIN with a WHERE that reads the first table and the inner table
 */
DROP VIEW IF EXISTS va, vb;
DROP TABLE IF EXISTS ta, tb, tc, td, te;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
CREATE TABLE td (ca INT, cb INT);
CREATE TABLE te (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO tb VALUES (1, 1), (2, 9);
INSERT INTO tc VALUES (1, 1), (2, 2), (5, 5);
INSERT INTO td VALUES (1, 1), (2, 2), (5, 5);
INSERT INTO te VALUES (1, 1), (2, 2), (5, 5);
CREATE VIEW va AS SELECT a.ca ca, a.cb cb, b.ca cc FROM ta a, tb b;
CREATE VIEW vb AS SELECT a.ca ca, a.cb cb, b.ca cc FROM ta a JOIN tb b ON b.ca = a.ca;
UPDATE STATISTICS ON ta, tb, tc, td, te;

-- scenarios 1 - 10: a CROSS JOIN or a merged comma-join view leaves a table that the ON reads with no join edge
-- the ca of each table tells its rows apart
evaluate 'Case 1: scenario 1 - a LEFT JOIN whose ON reads only the two tables of the CROSS JOIN; result = 10 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON ta.ca = tb.ca ORDER BY 1, 2, 3;

evaluate 'Case 2: scenario 2 - a LEFT JOIN whose ON joins the inner table to the second table and filters the first; result = 6 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = tb.ca AND ta.ca = 1 ORDER BY 1, 2, 3;

evaluate 'Case 3: scenario 3 - a RIGHT JOIN pads the unmatched row of tc once, not once per row of the CROSS JOIN; result = 7 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca FROM ta CROSS JOIN tb RIGHT JOIN tc ON tb.ca = tc.ca ORDER BY 1, 2, 3;

evaluate 'Case 4: scenario 4 - two CROSS JOINs before a LEFT JOIN whose ON reads the first and the last table; result = 18 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb CROSS JOIN tc LEFT JOIN td ON td.ca = tc.ca AND ta.ca = 1 ORDER BY 1, 2, 3, 4;

evaluate 'Case 5: scenario 5 - a LEFT JOIN whose ON reads both tables of a merged comma-join view; result = 4 rows';
--@queryplan
SELECT /*+ RECOMPILE */ va.ca, va.cc, tb.ca, tc.ca FROM va JOIN tb ON tb.ca = va.ca LEFT JOIN tc ON tc.ca = va.cc AND va.cb = 1 ORDER BY 1, 2, 3, 4;

evaluate 'Case 6: scenario 6 - a merged comma-join view and a CROSS JOIN before the LEFT JOIN; result = 12 rows';
--@queryplan
SELECT /*+ RECOMPILE */ va.ca, va.cc, tb.ca, tc.ca FROM va CROSS JOIN tb LEFT JOIN tc ON tc.ca = tb.ca AND va.cb = 1 ORDER BY 1, 2, 3, 4;

-- unlike scenario 5, the view joins its tables with an ON, so the merged view keeps its join edge
evaluate 'Case 7: scenario 7 - a LEFT JOIN whose ON reads both tables of a merged view with an inner join; result = 2 rows';
SELECT vb.ca, vb.cc, tb.ca, tc.ca FROM vb JOIN tb ON tb.ca = vb.ca LEFT JOIN tc ON tc.ca = vb.cc AND vb.cb = 1 ORDER BY 1, 2, 3, 4;

evaluate 'Case 8: scenario 8 - two LEFT JOINs, each after a CROSS JOIN, the second ON reads both CROSS JOINs; result = 18 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca, te.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca CROSS JOIN td LEFT JOIN te ON te.ca = tb.ca AND te.cb = td.cb ORDER BY 1, 2, 3, 4, 5;

evaluate 'Case 9: scenario 9 - two LEFT JOINs whose ONs read the same two tables of the CROSS JOIN; result = 6 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb LEFT OUTER JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb LEFT OUTER JOIN td ON td.ca = ta.ca AND td.cb = tb.cb ORDER BY 1, 2, 3, 4;

evaluate 'Case 10: scenario 10 - three LEFT JOINs whose ONs read the same two tables of the CROSS JOIN; result = 6 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca, te.ca FROM ta CROSS JOIN tb LEFT OUTER JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb LEFT OUTER JOIN td ON td.ca = ta.ca AND td.cb = tb.cb LEFT OUTER JOIN te ON te.ca = ta.ca AND te.cb = tb.cb ORDER BY 1, 2, 3, 4, 5;

DROP VIEW IF EXISTS va, vb;
DROP TABLE IF EXISTS ta, tb, tc, td, te;
CREATE TABLE ta (ca INT PRIMARY KEY, cb INT);
CREATE TABLE tb (ca INT PRIMARY KEY, cb INT);
CREATE TABLE tc (ca INT PRIMARY KEY, cb INT);
INSERT INTO ta VALUES (1, 1);
INSERT INTO tb VALUES (2, 1), (3, 1);
INSERT INTO tc VALUES (2, 20), (4, 40);
UPDATE STATISTICS ON ta, tb, tc;

-- scenarios 11 - 13: a join order hint must not add a join edge that the query does not ask for
evaluate 'Case 11: scenario 11 - a RIGHT JOIN after a comma, joined to the table before the comma in the WHERE; result = 2 rows';
SELECT tb.cb, tc.cb FROM ta, tc RIGHT OUTER JOIN tb ON tc.ca = tb.ca WHERE tb.cb = ta.cb ORDER BY 1, 2;

evaluate 'Case 12: scenario 12 - Case 11 with the ORDERED hint, which the planner ignores; result = same rows as Case 11';
--@queryplan
SELECT /*+ RECOMPILE ORDERED */ tb.cb, tc.cb FROM ta, tc RIGHT OUTER JOIN tb ON tc.ca = tb.ca WHERE tb.cb = ta.cb ORDER BY 1, 2;

evaluate 'Case 13: scenario 13 - Case 11 with a LEADING hint, which the planner ignores; result = same rows as Case 11';
--@queryplan
SELECT /*+ RECOMPILE LEADING(ta,tb,tc) */ tb.cb, tc.cb FROM ta, tc RIGHT OUTER JOIN tb ON tc.ca = tb.ca WHERE tb.cb = ta.cb ORDER BY 1, 2;

DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3), (4, NULL);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb VALUES (1, 1), (2, 2), (3, NULL);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO tc VALUES (1, 1), (1, 2), (2, 3), (5, 1);
UPDATE STATISTICS ON ta, tb, tc;

-- the ON joins both tables of the CROSS JOIN, alone and with a WHERE on the NULL-padded table
evaluate 'Case 14: a LEFT JOIN whose ON joins the inner table to both tables of the CROSS JOIN; result = 12 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb ORDER BY 1, 2, 3, 4, 5, 6;

evaluate 'Case 15: Case 14 with an IS NULL filter on the NULL-padded table in the WHERE; result = 10 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE tc.cb IS NULL ORDER BY 1, 2, 3, 4, 5, 6;

-- NVL keeps the NULL-padded rows, so the rewriter does not turn the LEFT JOIN into an inner join
evaluate 'Case 16: Case 14 with a WHERE that reads the NULL-padded table and the second table of the CROSS JOIN; result = 11 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE NVL (tc.ca, tb.ca) = tb.ca ORDER BY 1, 2, 3, 4, 5, 6;

evaluate 'Case 17: a RIGHT JOIN after a CROSS JOIN with a WHERE that reads the first table and the inner table; result = 7 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb RIGHT JOIN tc ON tb.ca = tc.ca WHERE ta.cb = tc.cb OR ta.cb IS NULL ORDER BY 1, 2, 3, 4, 5, 6;

DROP TABLE ta, tb, tc;

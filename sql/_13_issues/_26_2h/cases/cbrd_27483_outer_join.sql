/**
 *  This test case verifies CBRD-27483: Join graph has no edge to the tables that the ON clause of an outer, semi
 *  or anti join depends on, so the query fails or returns a wrong result
 *
 *  The cases run a LEFT or RIGHT JOIN after a CROSS JOIN or after a merged view whose FROM is a comma join. An
 *  outer join comes after every table that its ON reads. The CROSS JOIN or the merged view can leave such a table
 *  with no join edge, and the planner then finds no join order or picks one that breaks the outer join. The fix
 *  adds join edges to the tables that the ON reads.
 *  Each case prints the result that its query defines.
 *  A case taken from an attached file names it at the end of its label: scenario N is scenario N of the Jira
 *  attachment cbrd-27483_test_scenarios_20260929_1945.md. Scenario 3 is in
 *  cbrd_27483_on_reads_across_cross_join.sql, and scenarios 11 - 13 are in cbrd_27483_right_join.sql.
 *  The SELECT statements with a join that fail or return a wrong result without the fix also print their plan. The
 *  plan of a LEFT JOIN puts its inner table after every table that its ON reads, and the plan of a RIGHT JOIN puts
 *  the whole join before it on the inner side. The queries with a plan carry RECOMPILE because a plan prints only
 *  when the query is compiled. In a plan, the cost picks the order and the nesting of the tables that no dependency
 *  orders, so a change of the cost model or of the statistics can change those lines.
 *
 *  Coverage:
 *    Case 1:   a LEFT JOIN whose ON reads only the two tables of the CROSS JOIN (scenario 1)
 *    Case 2:   a LEFT JOIN whose ON joins the inner table to the second table and filters the first (scenario 2)
 *    Case 3:   two CROSS JOINs before a LEFT JOIN whose ON reads the first and the last table (scenario 4)
 *    Case 4:   two LEFT JOINs, each after a CROSS JOIN, the second ON reads both CROSS JOINs (scenario 8)
 *    Case 5:   two LEFT JOINs whose ONs read the same two tables of the CROSS JOIN (scenario 9)
 *    Case 6:   three LEFT JOINs whose ONs read the same two tables of the CROSS JOIN (scenario 10)
 *    Case 7:   a second LEFT JOIN whose ON reads the second table and the NULL-padded table of the first LEFT JOIN
 *    Case 8:   a LEFT JOIN after a CROSS JOIN, and a later derived table that reads its inner table and joins the
 *              two tables of the CROSS JOIN in the WHERE
 *    Case 9:   a LEFT JOIN whose ON reads both tables of a merged comma-join view (scenario 5)
 *    Case 10:  a merged comma-join view and a CROSS JOIN before the LEFT JOIN (scenario 6)
 *    Case 11:  a RIGHT JOIN whose ON reads the inner table of a LEFT JOIN that follows a CROSS JOIN
 *    Case 12:  a RIGHT JOIN whose ON reads the first table, after an INNER JOIN that follows a CROSS JOIN
 *    Case 13:  a RIGHT JOIN whose ON reads the first table, after a LEFT JOIN that follows a CROSS JOIN
 *    Case 14:  a LEFT JOIN whose ON reads both tables of a merged view with an inner join (scenario 7)
 *    Case 15:  a LEFT JOIN whose ON reads only its own table, after a CROSS JOIN
 *    Case 16:  a LEFT JOIN whose ON joins the inner table to both tables of the CROSS JOIN
 *    Case 17:  Case 16 with an IS NULL filter on the NULL-padded table in the WHERE
 *    Case 18:  Case 16 with a WHERE that reads the NULL-padded table and the second table of the CROSS JOIN
 *    Case 19:  a RIGHT JOIN after a CROSS JOIN with a WHERE that reads the first table and the inner table
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

-- the select list holds the ca of each table, which tells its rows apart
-- Cases 1 - 8: a LEFT JOIN after a CROSS JOIN, whose ON reads a table on the other side of the CROSS JOIN
evaluate 'Case 1: a LEFT JOIN whose ON reads only the two tables of the CROSS JOIN (scenario 1); result = 10 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON ta.ca = tb.ca ORDER BY 1, 2, 3;

evaluate 'Case 2: a LEFT JOIN whose ON joins the inner table to the second table and filters the first (scenario 2); result = 6 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = tb.ca AND ta.ca = 1 ORDER BY 1, 2, 3;

evaluate 'Case 3: two CROSS JOINs before a LEFT JOIN whose ON reads the first and the last table (scenario 4); result = 18 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb CROSS JOIN tc LEFT JOIN td ON td.ca = tc.ca AND ta.ca = 1 ORDER BY 1, 2, 3, 4;

evaluate 'Case 4: two LEFT JOINs, each after a CROSS JOIN, the second ON reads both CROSS JOINs (scenario 8); result = 18 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca, te.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca CROSS JOIN td LEFT JOIN te ON te.ca = tb.ca AND te.cb = td.cb ORDER BY 1, 2, 3, 4, 5;

evaluate 'Case 5: two LEFT JOINs whose ONs read the same two tables of the CROSS JOIN (scenario 9); result = 6 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb LEFT OUTER JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb LEFT OUTER JOIN td ON td.ca = ta.ca AND td.cb = tb.cb ORDER BY 1, 2, 3, 4;

evaluate 'Case 6: three LEFT JOINs whose ONs read the same two tables of the CROSS JOIN (scenario 10); result = 6 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca, te.ca FROM ta CROSS JOIN tb LEFT OUTER JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb LEFT OUTER JOIN td ON td.ca = ta.ca AND td.cb = tb.cb LEFT OUTER JOIN te ON te.ca = ta.ca AND te.cb = tb.cb ORDER BY 1, 2, 3, 4, 5;

-- NVL keeps the NULL-padded rows, so the rewriter does not turn the first LEFT JOIN into an inner join
-- the WHERE term on tc and tb is then no join edge between the two tables that the second ON reads
evaluate 'Case 7: a second LEFT JOIN whose ON reads the second table and the NULL-padded table of the first LEFT JOIN; result = 3 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca LEFT JOIN td ON td.ca = tb.ca AND td.cb = tc.cb WHERE NVL (tc.cb, tb.cb) = tb.cb ORDER BY 1, 2, 3, 4;

-- d reads tc, so the planner places d after tc and cannot join ta and tb through d before the LEFT JOIN
evaluate 'Case 8: a LEFT JOIN after a CROSS JOIN, and a later derived table that reads its inner table and joins the two tables of the CROSS JOIN in the WHERE; result = 2 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, d.x FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.ca = tb.ca, TABLE({tc.ca + 1}) AS d(x) WHERE ta.ca < d.x AND tb.ca < d.x ORDER BY 1, 2, 3, 4;

-- Cases 9 - 10: a LEFT JOIN after a merged view, whose ON reads the tables of the view
evaluate 'Case 9: a LEFT JOIN whose ON reads both tables of a merged comma-join view (scenario 5); result = 4 rows';
--@queryplan
SELECT /*+ RECOMPILE */ va.ca, va.cc, tb.ca, tc.ca FROM va JOIN tb ON tb.ca = va.ca LEFT JOIN tc ON tc.ca = va.cc AND va.cb = 1 ORDER BY 1, 2, 3, 4;

evaluate 'Case 10: a merged comma-join view and a CROSS JOIN before the LEFT JOIN (scenario 6); result = 12 rows';
--@queryplan
SELECT /*+ RECOMPILE */ va.ca, va.cc, tb.ca, tc.ca FROM va CROSS JOIN tb LEFT JOIN tc ON tc.ca = tb.ca AND va.cb = 1 ORDER BY 1, 2, 3, 4;

-- Cases 11 - 13: a RIGHT JOIN after a LEFT or INNER JOIN that follows a CROSS JOIN
-- the RIGHT JOIN preserves its table against the whole join before it, so it depends on every table of that join
evaluate 'Case 11: a RIGHT JOIN whose ON reads the inner table of a LEFT JOIN that follows a CROSS JOIN; result = 5 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca RIGHT JOIN td ON td.ca = tc.ca ORDER BY 1, 2, 3, 4;

evaluate 'Case 12: a RIGHT JOIN whose ON reads the first table, after an INNER JOIN that follows a CROSS JOIN; result = 5 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb INNER JOIN tc ON tc.ca = tb.ca RIGHT JOIN td ON td.ca = ta.ca ORDER BY 1, 2, 3, 4;

evaluate 'Case 13: a RIGHT JOIN whose ON reads the first table, after a LEFT JOIN that follows a CROSS JOIN; result = 5 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = tb.ca RIGHT JOIN td ON td.ca = ta.ca ORDER BY 1, 2, 3, 4;

-- Cases 14 - 15 are controls: they return the same result without the fix
-- unlike Case 9, the view joins its tables with an ON, so the merged view keeps its join edge
evaluate 'Case 14: a LEFT JOIN whose ON reads both tables of a merged view with an inner join (scenario 7); result = 2 rows';
SELECT vb.ca, vb.cc, tb.ca, tc.ca FROM vb JOIN tb ON tb.ca = vb.ca LEFT JOIN tc ON tc.ca = vb.cc AND vb.cb = 1 ORDER BY 1, 2, 3, 4;

-- unlike Case 1, the ON reads no table but its own, so there are no two tables to connect
evaluate 'Case 15: a LEFT JOIN whose ON reads only its own table, after a CROSS JOIN; result = 6 rows';
SELECT ta.ca, tb.ca, tc.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = 1 ORDER BY 1, 2, 3;

DROP VIEW va, vb;
DROP TABLE ta, tb, tc, td, te;

-- Cases 16 - 19 use new data: cb has NULLs and tc has two rows for ca 1, so an ON that joins tc to both tables of
-- the CROSS JOIN matches only some pairs, and a WHERE on the NULL-padded columns keeps some rows and drops others
DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3), (4, NULL);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb VALUES (1, 1), (2, 2), (3, NULL);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO tc VALUES (1, 1), (1, 2), (2, 3), (5, 1);
UPDATE STATISTICS ON ta, tb, tc;

-- Cases 16 - 18: a LEFT JOIN without and with a WHERE
evaluate 'Case 16: a LEFT JOIN whose ON joins the inner table to both tables of the CROSS JOIN; result = 12 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb ORDER BY 1, 2, 3, 4, 5, 6;

evaluate 'Case 17: Case 16 with an IS NULL filter on the NULL-padded table in the WHERE; result = 10 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE tc.cb IS NULL ORDER BY 1, 2, 3, 4, 5, 6;

-- NVL keeps the NULL-padded rows, so the rewriter does not turn the LEFT JOIN into an inner join
evaluate 'Case 18: Case 16 with a WHERE that reads the NULL-padded table and the second table of the CROSS JOIN; result = 11 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE NVL (tc.ca, tb.ca) = tb.ca ORDER BY 1, 2, 3, 4, 5, 6;

-- Case 19: a RIGHT JOIN with a WHERE
evaluate 'Case 19: a RIGHT JOIN after a CROSS JOIN with a WHERE that reads the first table and the inner table; result = 7 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb RIGHT JOIN tc ON tb.ca = tc.ca WHERE ta.cb = tc.cb OR ta.cb IS NULL ORDER BY 1, 2, 3, 4, 5, 6;

DROP TABLE ta, tb, tc;

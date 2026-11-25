/**
 *  This test case verifies CBRD-27483: Join graph has no edge to the tables that the ON clause of an outer, semi
 *  or anti join depends on, so the query fails or returns a wrong result
 *
 *  The cases run an outer join after a CROSS JOIN or after a merged view whose FROM is a comma join. An outer join
 *  must come after every table that its ON reads. The CROSS JOIN or the merged view can leave such a table with no
 *  join edge, and the planner then picks a join order that puts the outer join first or finds no join order.
 *  The fix adds join edges to the tables that the ON reads. Each case prints the rows of its query, which must be
 *  the rows that the query defines. A case that repeats another case with a hint or a rewritten form must print
 *  the same rows.
 *  The cases labeled scenario N come from scenario N of the Jira attachment
 *  cbrd-27483_test_scenarios_20260929_1945.md.
 *  The SELECT cases that fail without the fix also print their plan. The plan of a LEFT JOIN puts its inner table
 *  after every table that its ON reads, and the plan of a RIGHT JOIN puts the whole join before it on the inner
 *  side. The cases with a join order hint also print their plan, which shows whether the planner applied the hint.
 *  Those queries carry RECOMPILE because a plan prints only when the query is compiled. In a plan, the cost picks
 *  the order and the nesting of the tables that no dependency orders, so a change of the cost model or of the
 *  statistics can change those lines.
 *  Cases 34 - 41 extend the same failure to an INNER JOIN whose ON condition reads three tables, which is no join
 *  edge, and to two LEFT JOIN chains that only the first table of a join order could start.
 *
 *  Coverage:
 *    Case 1:   scenario 1 - a LEFT JOIN whose ON reads only the two tables of the CROSS JOIN
 *    Case 2:   scenario 2 - a LEFT JOIN whose ON joins the inner table to the second table and filters the first
 *    Case 3:   scenario 4 - two CROSS JOINs before a LEFT JOIN whose ON reads the first and the last table
 *    Case 4:   scenario 8 - two LEFT JOINs, each after a CROSS JOIN, the second ON reads both CROSS JOINs
 *    Case 5:   scenario 9 - two LEFT JOINs whose ONs read the same two tables of the CROSS JOIN
 *    Case 6:   scenario 10 - three LEFT JOINs whose ONs read the same two tables of the CROSS JOIN
 *    Case 7:   a second LEFT JOIN whose ON reads the second table and the NULL-padded table of the first LEFT JOIN
 *    Case 8:   a LEFT JOIN after a CROSS JOIN, and a later derived table that reads its inner table and joins the
 *              two tables of the CROSS JOIN in the WHERE
 *    Case 9:   scenario 5 - a LEFT JOIN whose ON reads both tables of a merged comma-join view
 *    Case 10:   scenario 6 - a merged comma-join view and a CROSS JOIN before the LEFT JOIN
 *    Case 11:  scenario 7 - a LEFT JOIN whose ON reads both tables of a merged view with an inner join
 *    Case 12:  a LEFT JOIN whose ON reads only its own table, after a CROSS JOIN
 *    Case 13:  a LEFT JOIN whose ON reads only its own table, joined after a later CROSS JOIN table that another ON reads
 *    Case 14:  Case 13 with the ORDERED hint
 *    Case 15:  a LEFT JOIN whose ON joins the inner table to both tables of the CROSS JOIN
 *    Case 16:  Case 15 with an IS NULL filter on the NULL-padded table in the WHERE
 *    Case 17:  Case 15 with a WHERE that reads the NULL-padded table and the second table of the CROSS JOIN
 *    Case 18:  a RIGHT JOIN after a CROSS JOIN with a WHERE that reads the first table and the inner table
 *    Case 19:  scenario 3 - a RIGHT JOIN pads the unmatched row of tc once, not once per row of the CROSS JOIN
 *    Case 20:  a RIGHT JOIN whose ON reads the inner table of a LEFT JOIN that follows a CROSS JOIN
 *    Case 21:  a RIGHT JOIN whose ON reads the first table, after an INNER JOIN that follows a CROSS JOIN
 *    Case 22:  a RIGHT JOIN whose ON reads the first table, after a LEFT JOIN that follows a CROSS JOIN
 *    Case 23:  a RIGHT JOIN after a merged comma-join view and a CROSS JOIN
 *    Case 24:  a merged comma-join view, a CROSS JOIN and a RIGHT JOIN, then a LEFT JOIN whose ON reads the view
 *    Case 25:  Case 24 with the ORDERED hint
 *    Case 26:  a RIGHT JOIN after a filtered single-table view and a CROSS JOIN
 *    Case 27:  a RIGHT JOIN after a CROSS JOIN, with no view
 *    Case 28:  Case 27 with IS NOT NULL in the WHERE on a NOT NULL column of the first table
 *    Case 29:  Case 27 with a comma in place of the CROSS JOIN, which closes the join before the RIGHT JOIN
 *    Case 30:  the parser refuses a RIGHT JOIN ON after a comma that reads the table before the comma
 *    Case 31:  scenario 11 - a RIGHT JOIN after a comma, joined to the table before the comma in the WHERE
 *    Case 32:  scenario 12 - Case 31 with the ORDERED hint, which the planner ignores
 *    Case 33:  scenario 13 - Case 31 with a LEADING hint, which the planner ignores
 *    Case 34:  an INNER JOIN whose ON reads the NULL-padded table of a LEFT JOIN and the table after a CROSS JOIN
 *              in one condition
 *    Case 35:  Case 34 with a second condition that joins the inner table to the table after the CROSS JOIN
 *    Case 36:  Case 34 followed by a LEFT JOIN
 *    Case 37:  Case 34 with a table between the CROSS JOINs that no ON reads
 *    Case 38:  Case 34 with an INNER JOIN in place of the LEFT JOIN
 *    Case 39:  two LEFT JOIN chains around a CROSS JOIN, bridged by a later INNER JOIN and a LEFT JOIN
 *    Case 40:  Case 39 without the last LEFT JOIN
 *    Case 41:  Case 39 with a RIGHT JOIN in place of the last LEFT JOIN
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
-- Cases 1 - 8: a LEFT JOIN after a CROSS JOIN whose ON reads a table on the other side of the CROSS JOIN
evaluate 'Case 1: scenario 1 - a LEFT JOIN whose ON reads only the two tables of the CROSS JOIN; result = 10 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON ta.ca = tb.ca ORDER BY 1, 2, 3;

evaluate 'Case 2: scenario 2 - a LEFT JOIN whose ON joins the inner table to the second table and filters the first; result = 6 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = tb.ca AND ta.ca = 1 ORDER BY 1, 2, 3;

evaluate 'Case 3: scenario 4 - two CROSS JOINs before a LEFT JOIN whose ON reads the first and the last table; result = 18 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb CROSS JOIN tc LEFT JOIN td ON td.ca = tc.ca AND ta.ca = 1 ORDER BY 1, 2, 3, 4;

evaluate 'Case 4: scenario 8 - two LEFT JOINs, each after a CROSS JOIN, the second ON reads both CROSS JOINs; result = 18 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca, te.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca CROSS JOIN td LEFT JOIN te ON te.ca = tb.ca AND te.cb = td.cb ORDER BY 1, 2, 3, 4, 5;

evaluate 'Case 5: scenario 9 - two LEFT JOINs whose ONs read the same two tables of the CROSS JOIN; result = 6 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb LEFT OUTER JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb LEFT OUTER JOIN td ON td.ca = ta.ca AND td.cb = tb.cb ORDER BY 1, 2, 3, 4;

evaluate 'Case 6: scenario 10 - three LEFT JOINs whose ONs read the same two tables of the CROSS JOIN; result = 6 rows';
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

-- Cases 9 - 11: a LEFT JOIN after a merged view, whose ON reads the tables of the view
evaluate 'Case 9: scenario 5 - a LEFT JOIN whose ON reads both tables of a merged comma-join view; result = 4 rows';
--@queryplan
SELECT /*+ RECOMPILE */ va.ca, va.cc, tb.ca, tc.ca FROM va JOIN tb ON tb.ca = va.ca LEFT JOIN tc ON tc.ca = va.cc AND va.cb = 1 ORDER BY 1, 2, 3, 4;

evaluate 'Case 10: scenario 6 - a merged comma-join view and a CROSS JOIN before the LEFT JOIN; result = 12 rows';
--@queryplan
SELECT /*+ RECOMPILE */ va.ca, va.cc, tb.ca, tc.ca FROM va CROSS JOIN tb LEFT JOIN tc ON tc.ca = tb.ca AND va.cb = 1 ORDER BY 1, 2, 3, 4;

-- a control: it returns the same rows without the fix
-- unlike Case 9, the view joins its tables with an ON, so the merged view keeps its join edge
evaluate 'Case 11: scenario 7 - a LEFT JOIN whose ON reads both tables of a merged view with an inner join; result = 2 rows';
SELECT vb.ca, vb.cc, tb.ca, tc.ca FROM vb JOIN tb ON tb.ca = vb.ca LEFT JOIN tc ON tc.ca = vb.cc AND vb.cb = 1 ORDER BY 1, 2, 3, 4;

-- Cases 12 - 14: a LEFT JOIN whose ON reads only its own table
-- a control: it returns the same rows without the fix
-- the ON reads no table other than tc, so the LEFT JOIN depends on no table
evaluate 'Case 12: a LEFT JOIN whose ON reads only its own table, after a CROSS JOIN; result = 6 rows';
SELECT ta.ca, tb.ca, tc.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = 1 ORDER BY 1, 2, 3;

DROP VIEW va, vb;
DROP TABLE ta, tb, tc, td, te;

-- Cases 13 - 14 use new data: no row of tb meets ON tb.ca > tb.cb, and td and tg are empty, so each LEFT JOIN
-- NULL-pads the rows it keeps. ta, tb and tc are large and te is small, so the planner joins tb after te, ta and tc.
-- tb then has a dummy join term to ta for its own LEFT JOIN and one to tc for the ON of td.
DROP TABLE IF EXISTS ta, tb, tc, td, te, tf, tg;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
CREATE TABLE td (ca INT, cb INT);
CREATE TABLE te (ca INT, cb INT);
CREATE TABLE tf (ca INT, cb INT);
CREATE TABLE tg (ca INT, cb INT);
INSERT INTO ta SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 200;
INSERT INTO tb SELECT -ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 500;
INSERT INTO tc SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 200;
INSERT INTO te VALUES (1, 1);
INSERT INTO tf VALUES (1, 1);
CREATE INDEX i_tc_ca ON tc (ca);
CREATE INDEX i_te_ca ON te (ca);
UPDATE STATISTICS ON ta, tb, tc, td, te, tf, tg WITH FULLSCAN;

-- the dummy join term to tc must not turn the LEFT JOIN of tb into an inner join
evaluate 'Case 13: a LEFT JOIN whose ON reads only its own table, joined after a later CROSS JOIN table that another ON reads; result = 1 row';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca, te.ca, tf.ca, tg.ca FROM ta LEFT JOIN tb ON tb.ca > tb.cb CROSS JOIN tc LEFT JOIN td ON td.ca = tb.ca AND td.cb = tc.ca INNER JOIN te ON te.ca = ta.ca AND te.cb = tc.ca CROSS JOIN tf LEFT JOIN tg ON tg.ca = te.ca AND tg.cb = tf.ca ORDER BY 1, 2, 3, 4, 5, 6, 7;

-- a control: it returns the same rows without the fix
evaluate 'Case 14: Case 13 with the ORDERED hint; result = same rows as Case 13';
SELECT /*+ ORDERED */ ta.ca, tb.ca, tc.ca, td.ca, te.ca, tf.ca, tg.ca FROM ta LEFT JOIN tb ON tb.ca > tb.cb CROSS JOIN tc LEFT JOIN td ON td.ca = tb.ca AND td.cb = tc.ca INNER JOIN te ON te.ca = ta.ca AND te.cb = tc.ca CROSS JOIN tf LEFT JOIN tg ON tg.ca = te.ca AND tg.cb = tf.ca ORDER BY 1, 2, 3, 4, 5, 6, 7;

DROP TABLE ta, tb, tc, td, te, tf, tg;

-- Cases 15 - 18 use new data: cb has NULLs and tc has two rows for ca 1, so an ON that joins tc to both tables of
-- the CROSS JOIN matches only some pairs, and a WHERE on the NULL-padded columns keeps some rows and drops others
DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3), (4, NULL);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb VALUES (1, 1), (2, 2), (3, NULL);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO tc VALUES (1, 1), (1, 2), (2, 3), (5, 1);
UPDATE STATISTICS ON ta, tb, tc;

-- Cases 15 - 17: the ON joins tc to both tables of the CROSS JOIN, alone and with a WHERE on the NULL-padded table
evaluate 'Case 15: a LEFT JOIN whose ON joins the inner table to both tables of the CROSS JOIN; result = 12 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb ORDER BY 1, 2, 3, 4, 5, 6;

evaluate 'Case 16: Case 15 with an IS NULL filter on the NULL-padded table in the WHERE; result = 10 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE tc.cb IS NULL ORDER BY 1, 2, 3, 4, 5, 6;

-- NVL keeps the NULL-padded rows, so the rewriter does not turn the LEFT JOIN into an inner join
evaluate 'Case 17: Case 15 with a WHERE that reads the NULL-padded table and the second table of the CROSS JOIN; result = 11 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE NVL (tc.ca, tb.ca) = tb.ca ORDER BY 1, 2, 3, 4, 5, 6;

-- Case 18: a RIGHT JOIN on the same data, with a WHERE
evaluate 'Case 18: a RIGHT JOIN after a CROSS JOIN with a WHERE that reads the first table and the inner table; result = 7 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb RIGHT JOIN tc ON tb.ca = tc.ca WHERE ta.cb = tc.cb OR ta.cb IS NULL ORDER BY 1, 2, 3, 4, 5, 6;

DROP TABLE ta, tb, tc;

-- Cases 19 - 22 use the data of Cases 1 - 12 again, with no view
DROP TABLE IF EXISTS ta, tb, tc, td;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
CREATE TABLE td (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO tb VALUES (1, 1), (2, 9);
INSERT INTO tc VALUES (1, 1), (2, 2), (5, 5);
INSERT INTO td VALUES (1, 1), (2, 2), (5, 5);
UPDATE STATISTICS ON ta, tb, tc, td;

-- Cases 19 - 22: a RIGHT JOIN after a CROSS JOIN, alone and after a LEFT or INNER JOIN
-- the RIGHT JOIN keeps its table against the whole join before it, so it depends on every table of that join
evaluate 'Case 19: scenario 3 - a RIGHT JOIN pads the unmatched row of tc once, not once per row of the CROSS JOIN; result = 7 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca FROM ta CROSS JOIN tb RIGHT JOIN tc ON tb.ca = tc.ca ORDER BY 1, 2, 3;

evaluate 'Case 20: a RIGHT JOIN whose ON reads the inner table of a LEFT JOIN that follows a CROSS JOIN; result = 5 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca RIGHT JOIN td ON td.ca = tc.ca ORDER BY 1, 2, 3, 4;

evaluate 'Case 21: a RIGHT JOIN whose ON reads the first table, after an INNER JOIN that follows a CROSS JOIN; result = 5 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb INNER JOIN tc ON tc.ca = tb.ca RIGHT JOIN td ON td.ca = ta.ca ORDER BY 1, 2, 3, 4;

evaluate 'Case 22: a RIGHT JOIN whose ON reads the first table, after a LEFT JOIN that follows a CROSS JOIN; result = 5 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = tb.ca RIGHT JOIN td ON td.ca = ta.ca ORDER BY 1, 2, 3, 4;

DROP TABLE ta, tb, tc, td;

-- Cases 23 - 30 use new data and print counts, because their CROSS JOINs make hundreds of rows.
-- A RIGHT JOIN after a CROSS JOIN pads its unmatched row against the whole join before it, a view included.
-- Merging vc into the FROM of the query leaves its two tables apart, with a comma between them, and the
-- RIGHT JOIN then pads its row against tb alone. ta has 3 rows and tb 100, so the planner joins ta last when it may.
-- td.ca = 3 matches no row of tc, so each RIGHT JOIN keeps one NULL-padded row.
DROP VIEW IF EXISTS vc, vd;
DROP TABLE IF EXISTS ta, tb, tc, td, te;
CREATE TABLE ta (ca INT NOT NULL, cb INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
CREATE TABLE td (ca INT, cb INT);
CREATE TABLE te (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO tb SELECT 1, ROWNUM FROM db_class a, db_class b LIMIT 100;
INSERT INTO tc VALUES (1, 1);
INSERT INTO td VALUES (1, 1), (3, 3);
INSERT INTO te VALUES (1, 1);
CREATE VIEW vc AS SELECT ta.ca ca, tb.ca cb FROM ta, tb;
CREATE VIEW vd AS SELECT ca FROM ta WHERE ca > 1;
UPDATE STATISTICS ON ta, tb, tc, td, te WITH FULLSCAN;

-- Cases 23 - 26: a RIGHT JOIN after a merged view and a CROSS JOIN
evaluate 'Case 23: a RIGHT JOIN after a merged comma-join view and a CROSS JOIN; result = 301, 300';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(vc.ca) FROM vc CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca;

evaluate 'Case 24: a merged comma-join view, a CROSS JOIN and a RIGHT JOIN, then a LEFT JOIN whose ON reads the view; result = 301, 300, 100';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(vc.ca), COUNT(te.ca) FROM vc CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca LEFT OUTER JOIN te ON te.ca = vc.ca AND te.cb = td.ca;

evaluate 'Case 25: Case 24 with the ORDERED hint; result = same counts as Case 24';
--@queryplan
SELECT /*+ RECOMPILE ORDERED */ COUNT(*), COUNT(vc.ca), COUNT(te.ca) FROM vc CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca LEFT OUTER JOIN te ON te.ca = vc.ca AND te.cb = td.ca;

-- the WHERE of vd must filter ta inside the join that the RIGHT JOIN pads, not the padded row
evaluate 'Case 26: a RIGHT JOIN after a filtered single-table view and a CROSS JOIN; result = 3, 2';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(vd.ca) FROM vd CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca;

-- Cases 27 - 28: the RIGHT JOIN with no view, without and with IS NOT NULL in the WHERE
evaluate 'Case 27: a RIGHT JOIN after a CROSS JOIN, with no view; result = 4';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*) FROM ta CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca;

-- ta.ca is NOT NULL, but the RIGHT JOIN pads it with NULL, so the WHERE must not fold IS NOT NULL into true
evaluate 'Case 28: Case 27 with IS NOT NULL in the WHERE on a NOT NULL column of the first table; result = 3';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*) FROM ta CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca WHERE ta.ca IS NOT NULL;

-- Cases 29 - 30 are controls: a comma binds looser than a JOIN, so the RIGHT JOIN keeps td against tc alone,
-- and the padded row of td repeats once per row of ta
evaluate 'Case 29: Case 27 with a comma in place of the CROSS JOIN, which closes the join before the RIGHT JOIN; result = 6, 6, 3, 6';
SELECT COUNT(*), COUNT(ta.ca), COUNT(tc.ca), COUNT(td.ca) FROM ta, tc RIGHT OUTER JOIN td ON td.ca = tc.ca;

-- the parser refuses this ON with -494, and Outer join query optimization failed has the same code, so the
-- answer shows only that the query fails
evaluate 'Case 30: the parser refuses a RIGHT JOIN ON after a comma that reads the table before the comma; result = fails with an error';
SELECT COUNT(*) FROM ta, tc RIGHT OUTER JOIN td ON td.ca = ta.ca;

DROP VIEW vc, vd;
DROP TABLE ta, tb, tc, td, te;

-- Cases 31 - 33 use new data: a comma joins ta and no ON reads it, and the one row of ta matches every row of tb
-- in the WHERE, so an outer join dependency taken from a hint would NULL-pad ta and the WHERE would drop the rows
DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE ta (ca INT PRIMARY KEY, cb INT);
CREATE TABLE tb (ca INT PRIMARY KEY, cb INT);
CREATE TABLE tc (ca INT PRIMARY KEY, cb INT);
INSERT INTO ta VALUES (1, 1);
INSERT INTO tb VALUES (2, 1), (3, 1);
INSERT INTO tc VALUES (2, 20), (4, 40);
UPDATE STATISTICS ON ta, tb, tc;

-- Cases 31 - 33: a RIGHT JOIN after a comma, without and with a join order hint
-- a join order hint must not add a join edge that the query does not ask for
-- Cases 31 - 33 are controls: they return the same rows without the fix
evaluate 'Case 31: scenario 11 - a RIGHT JOIN after a comma, joined to the table before the comma in the WHERE; result = 2 rows';
SELECT tb.cb, tc.cb FROM ta, tc RIGHT OUTER JOIN tb ON tc.ca = tb.ca WHERE tb.cb = ta.cb ORDER BY 1, 2;

evaluate 'Case 32: scenario 12 - Case 31 with the ORDERED hint, which the planner ignores; result = same rows as Case 31';
--@queryplan
SELECT /*+ RECOMPILE ORDERED */ tb.cb, tc.cb FROM ta, tc RIGHT OUTER JOIN tb ON tc.ca = tb.ca WHERE tb.cb = ta.cb ORDER BY 1, 2;

evaluate 'Case 33: scenario 13 - Case 31 with a LEADING hint, which the planner ignores; result = same rows as Case 31';
--@queryplan
SELECT /*+ RECOMPILE LEADING(ta,tb,tc) */ tb.cb, tc.cb FROM ta, tc RIGHT OUTER JOIN tb ON tc.ca = tb.ca WHERE tb.cb = ta.cb ORDER BY 1, 2;

DROP TABLE ta, tb, tc;

-- Cases 34 - 38 use new data: tb misses the row 3 of ta, so the LEFT JOIN pads it, and tc has a row 0
DROP TABLE IF EXISTS ta, tb, tc, td, tx;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
CREATE TABLE td (ca INT, cb INT);
CREATE TABLE tx (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO tb VALUES (1, 1), (2, 2);
INSERT INTO tc VALUES (0, 0), (1, 1);
INSERT INTO td VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO tx VALUES (1, 1), (2, 2);
UPDATE STATISTICS ON ta, tb, tc, td, tx;

-- Cases 34 - 37: td reads the NULL-padded tb, so it comes after the LEFT JOIN, and its condition over tb and tc
-- joins them in no join edge; tb and tc then need a join edge of their own
evaluate 'Case 34: an INNER JOIN whose ON reads the NULL-padded table of a LEFT JOIN and the table after a CROSS JOIN in one condition; result = 4, 4';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tb.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca CROSS JOIN tc INNER JOIN td ON td.cb = tb.cb + tc.cb;

evaluate 'Case 35: Case 34 with a second condition that joins the inner table to the table after the CROSS JOIN; result = 2, 2';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tb.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca CROSS JOIN tc INNER JOIN td ON td.ca = tc.ca + 1 AND td.cb = tb.cb + tc.cb;

evaluate 'Case 36: Case 34 followed by a LEFT JOIN; result = 4, 4, 3';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tb.ca), COUNT(t2.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca CROSS JOIN tc INNER JOIN td ON td.cb = tb.cb + tc.cb LEFT JOIN tb t2 ON t2.ca = td.ca;

-- the plan keeps tx out of the join that tb, tc and td need, as no ON reads tx
evaluate 'Case 37: Case 34 with a table between the CROSS JOINs that no ON reads; result = 8, 8';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tb.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca CROSS JOIN tx CROSS JOIN tc INNER JOIN td ON td.cb = tb.cb + tc.cb;

-- Case 38 is a control: with an INNER JOIN, tb is not NULL-padded and td does not have to come after it
evaluate 'Case 38: Case 34 with an INNER JOIN in place of the LEFT JOIN; result = 4, 4';
SELECT COUNT(*), COUNT(tb.ca) FROM ta INNER JOIN tb ON tb.ca = ta.ca CROSS JOIN tc INNER JOIN td ON td.cb = tb.cb + tc.cb;

DROP TABLE ta, tb, tc, td, tx;

-- Cases 39 - 41 use new data with rows that the LEFT JOINs pad
DROP TABLE IF EXISTS ta, tb, tc, td, te, tf, tg, tx;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
CREATE TABLE td (ca INT, cb INT);
CREATE TABLE te (ca INT, cb INT);
CREATE TABLE tf (ca INT, cb INT);
CREATE TABLE tg (ca INT, cb INT);
CREATE TABLE tx (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO tb VALUES (1, 1), (2, 2), (2, 4);
INSERT INTO tc VALUES (1, 1), (2, 2), (4, 4);
INSERT INTO td VALUES (1, 1), (2, 2), (5, 5);
INSERT INTO te VALUES (1, 1), (2, 2), (5, 6);
INSERT INTO tf VALUES (1, 1), (2, 2), (6, 6);
INSERT INTO tg VALUES (1, 1), (2, 2), (2, 1);
INSERT INTO tx VALUES (1, 1), (2, 2), (1, 2);
UPDATE STATISTICS ON ta, tb, tc, td, te, tf, tg, tx;

-- Cases 39 - 41: ta and td each start a LEFT JOIN chain, and tx joins the two chains; a join order starts at one
-- table, so the CROSS JOIN between tc and td needs a join edge for td to follow tc
evaluate 'Case 39: two LEFT JOIN chains around a CROSS JOIN, bridged by a later INNER JOIN and a LEFT JOIN; result = 4, 3';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tg.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca INNER JOIN tc ON tc.ca = tb.ca CROSS JOIN td LEFT JOIN te ON te.ca = td.ca INNER JOIN tf ON tf.ca = te.ca INNER JOIN tx ON tx.ca = tc.cb AND tx.cb = tf.cb LEFT JOIN tg ON tg.ca = tc.cb AND tg.cb = tf.cb;

evaluate 'Case 40: Case 39 without the last LEFT JOIN; result = 4, 4';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tx.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca INNER JOIN tc ON tc.ca = tb.ca CROSS JOIN td LEFT JOIN te ON te.ca = td.ca INNER JOIN tf ON tf.ca = te.ca INNER JOIN tx ON tx.ca = tc.cb AND tx.cb = tf.cb;

evaluate 'Case 41: Case 39 with a RIGHT JOIN in place of the last LEFT JOIN; result = 4, 3, 4';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tc.ca), COUNT(tg.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca INNER JOIN tc ON tc.ca = tb.ca CROSS JOIN td LEFT JOIN te ON te.ca = td.ca INNER JOIN tf ON tf.ca = te.ca INNER JOIN tx ON tx.ca = tc.cb AND tx.cb = tf.cb RIGHT JOIN tg ON tg.ca = tc.cb AND tg.cb = tf.cb;

DROP TABLE ta, tb, tc, td, te, tf, tg, tx;

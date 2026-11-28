/**
 *  This test case verifies CBRD-27483: Join graph has no edge to the tables that the ON clause of an outer, semi
 *  or anti join depends on, so the query fails or returns a wrong result
 *
 *  The cases run a RIGHT JOIN after a CROSS JOIN or after a comma. A RIGHT JOIN preserves its table against the
 *  whole join expression before it. A CROSS JOIN keeps that expression, and a comma closes it. With the fix, the
 *  parser and the planner follow the expression through a CROSS JOIN. The parser then neither merges a view that
 *  the RIGHT JOIN NULL-pads nor folds IS NOT NULL on its columns, and the planner orders the RIGHT JOIN after every
 *  table of the expression. The rewriter keeps IS NULL on a derived table that the RIGHT JOIN NULL-pads in the outer
 *  query, and an UPDATE skips the NULL-padded row.
 *  Each case prints the result that its query defines. A case that repeats another case with a hint or in another
 *  form prints the same result.
 *  A case taken from an attached file names it at the end of its label: scenario N is scenario N of the Jira
 *  attachment cbrd-27483_test_scenarios_20260929_1945.md.
 *  The SELECT statements with a join that fail or return a wrong result without the fix also print their plan. The
 *  plan of a RIGHT JOIN puts the whole join before it on the inner side. The cases with a join order hint print
 *  their plan too, which shows whether the planner applied the hint. The queries with a plan carry RECOMPILE
 *  because a plan prints only when the query is compiled. In a plan, the cost picks the order and the nesting of
 *  the tables that no dependency orders, so a change of the cost model or of the statistics can change those lines.
 *
 *  Coverage:
 *    Case 1:   a RIGHT JOIN after a CROSS JOIN, with no view
 *    Case 2:   Case 1 with IS NOT NULL in the WHERE on a NOT NULL column of the first table
 *    Case 3:   a RIGHT JOIN after a comma-join view and a CROSS JOIN
 *    Case 4:   Case 3 with a LEFT JOIN at the end whose ON reads the view
 *    Case 5:   a RIGHT JOIN after a filtered single-table view and a CROSS JOIN
 *    Case 6:   Case 4 with the ORDERED hint
 *    Case 7:   Case 1 with a comma in place of the CROSS JOIN
 *    Case 8:   Case 1 with a derived table in place of ta and IS NULL in the WHERE on the derived table
 *    Case 9:   UPDATE through the join of Case 1, whose assignment fails on the NULL-padded row
 *    Case 10:  the rows of ta after the UPDATE of Case 9
 *    Case 11:  UPDATE through the join of Case 1, which assigns NULL to a NOT NULL column on the NULL-padded row
 *    Case 12:  the rows of ta after the UPDATE of Case 11
 *    Case 13:  a RIGHT JOIN after a comma, joined to the table before the comma in the WHERE (scenario 11)
 *    Case 14:  Case 13 with the ORDERED hint, which the planner ignores (scenario 12)
 *    Case 15:  Case 13 with a LEADING hint, which the planner ignores (scenario 13)
 */
-- Cases 3, 4 and 6 make hundreds of rows, so Cases 1 - 7 print counts
-- td.ca 3 matches no row of tc, so each RIGHT JOIN after a CROSS JOIN NULL-pads one row
-- ta has 3 rows and tb has 100, so a count grows when the NULL-padded row repeats for each row of a table
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

-- Cases 1 - 2: a RIGHT JOIN with no view
evaluate 'Case 1: a RIGHT JOIN after a CROSS JOIN, with no view; result = 4';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*) FROM ta CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca;

-- ta.ca is NOT NULL, but the RIGHT JOIN NULL-pads it, so the rewriter must not fold IS NOT NULL into true
-- the IS NOT NULL then drops the NULL-padded row, so the plan shows an inner join in place of the RIGHT JOIN
evaluate 'Case 2: Case 1 with IS NOT NULL in the WHERE on a NOT NULL column of the first table; result = 3';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*) FROM ta CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca WHERE ta.ca IS NOT NULL;

-- Cases 3 - 6: a RIGHT JOIN after a view and a CROSS JOIN
-- merging vc would leave a comma between ta and tb, and the RIGHT JOIN would preserve td without ta
evaluate 'Case 3: a RIGHT JOIN after a comma-join view and a CROSS JOIN; result = 301, 300';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(vc.ca) FROM vc CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca;

evaluate 'Case 4: Case 3 with a LEFT JOIN at the end whose ON reads the view; result = 301, 300, 100';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(vc.ca), COUNT(te.ca) FROM vc CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca LEFT OUTER JOIN te ON te.ca = vc.ca AND te.cb = td.ca;

-- the WHERE of vd must filter ta before the RIGHT JOIN, not the NULL-padded row
evaluate 'Case 5: a RIGHT JOIN after a filtered single-table view and a CROSS JOIN; result = 3, 2';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(vd.ca) FROM vd CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca;

evaluate 'Case 6: Case 4 with the ORDERED hint; result = same counts as Case 4';
--@queryplan
SELECT /*+ RECOMPILE ORDERED */ COUNT(*), COUNT(vc.ca), COUNT(te.ca) FROM vc CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca LEFT OUTER JOIN te ON te.ca = vc.ca AND te.cb = td.ca;

-- Case 7 is a control: it returns the same result without the fix
-- a comma binds looser than a JOIN, so the RIGHT JOIN preserves td against tc alone
-- and its NULL-padded row repeats for each row of ta
evaluate 'Case 7: Case 1 with a comma in place of the CROSS JOIN; result = 6, 6, 3, 6';
SELECT COUNT(*), COUNT(ta.ca), COUNT(tc.ca), COUNT(td.ca) FROM ta, tc RIGHT OUTER JOIN td ON td.ca = tc.ca;

-- GROUP BY keeps the derived table from being merged, so the rewriter must not copy IS NULL into it
-- the IS NULL must keep the NULL-padded row of td.ca 3
evaluate 'Case 8: Case 1 with a derived table in place of ta and IS NULL in the WHERE on the derived table; result = 1 row';
--@queryplan
SELECT /*+ RECOMPILE */ v.ca, tc.ca, td.ca FROM (SELECT ca FROM ta GROUP BY ca) v CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca WHERE v.ca IS NULL ORDER BY 1, 2, 3;

-- Cases 9 - 12 change ta, so they run after every case that reads it
-- the NULL-padded row of td.ca 3 has no row of ta to update, so the UPDATE must not divide by zero for it
evaluate 'Case 9: UPDATE through the join of Case 1, whose assignment fails on the NULL-padded row; result = 3 rows affected';
UPDATE ta CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca SET ta.cb = 10 / (td.ca - 3);

evaluate 'Case 10: the rows of ta after the UPDATE of Case 9; result = 3 rows with cb -5';
SELECT ca, cb FROM ta ORDER BY 1;

-- the NULL-padded row of td.ca 3 has no row of ta to update, so the UPDATE must not check NOT NULL for it
evaluate 'Case 11: UPDATE through the join of Case 1, which assigns NULL to a NOT NULL column on the NULL-padded row; result = 3 rows affected';
UPDATE ta CROSS JOIN tc RIGHT OUTER JOIN td ON td.ca = tc.ca SET ta.ca = ta.ca + tc.ca * 10;

evaluate 'Case 12: the rows of ta after the UPDATE of Case 11; result = 3 rows with ca 11, 12, 13';
SELECT ca, cb FROM ta ORDER BY 1;

DROP VIEW vc, vd;
DROP TABLE ta, tb, tc, td, te;

-- Cases 13 - 15 use new data: a comma joins ta and no ON reads it, and the one row of ta matches every row of tb
-- in the WHERE, so an outer join dependency taken from a hint would NULL-pad ta and the WHERE would drop the rows
DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE ta (ca INT PRIMARY KEY, cb INT);
CREATE TABLE tb (ca INT PRIMARY KEY, cb INT);
CREATE TABLE tc (ca INT PRIMARY KEY, cb INT);
INSERT INTO ta VALUES (1, 1);
INSERT INTO tb VALUES (2, 1), (3, 1);
INSERT INTO tc VALUES (2, 20), (4, 40);
UPDATE STATISTICS ON ta, tb, tc;

-- Cases 13 - 15 are controls: they return the same result without the fix
-- a join order hint must not add a join edge that the query does not ask for
evaluate 'Case 13: a RIGHT JOIN after a comma, joined to the table before the comma in the WHERE (scenario 11); result = 2 rows';
SELECT tb.cb, tc.cb FROM ta, tc RIGHT OUTER JOIN tb ON tc.ca = tb.ca WHERE tb.cb = ta.cb ORDER BY 1, 2;

evaluate 'Case 14: Case 13 with the ORDERED hint, which the planner ignores (scenario 12); result = same rows as Case 13';
--@queryplan
SELECT /*+ RECOMPILE ORDERED */ tb.cb, tc.cb FROM ta, tc RIGHT OUTER JOIN tb ON tc.ca = tb.ca WHERE tb.cb = ta.cb ORDER BY 1, 2;

evaluate 'Case 15: Case 13 with a LEADING hint, which the planner ignores (scenario 13); result = same rows as Case 13';
--@queryplan
SELECT /*+ RECOMPILE LEADING(ta,tb,tc) */ tb.cb, tc.cb FROM ta, tc RIGHT OUTER JOIN tb ON tc.ca = tb.ca WHERE tb.cb = ta.cb ORDER BY 1, 2;

DROP TABLE ta, tb, tc;

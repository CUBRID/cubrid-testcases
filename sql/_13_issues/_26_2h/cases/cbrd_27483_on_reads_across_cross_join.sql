/**
 *  This test case verifies CBRD-27483: Join graph has no edge to the tables that the ON clause of an outer, semi
 *  or anti join depends on, so the query fails or returns a wrong result
 *
 *  The cases run a LEFT, INNER or RIGHT JOIN after a CROSS JOIN, with an ON that reads a table on the other side of
 *  the CROSS JOIN. An outer join must come after every table that its ON reads. The CROSS JOIN can leave such a
 *  table with no join edge, and the planner then picks a join order that puts the outer join first or finds no join
 *  order.
 *  The fix adds join edges to the tables that the ON reads. Each case prints the rows of its query, which must be
 *  the rows that the query defines. A case that repeats another case with a hint or a rewritten form must print
 *  the same rows.
 *  Cases 1 - 26 come from the Jira attachment i17-outer-join-after-cross-join.sql, SQLancer defect 17 of CBRD-28029.
 *  The SELECT cases that fail without the fix also print their plan. The plan of a LEFT JOIN puts its inner table
 *  after every table that its ON reads, and the plan of a RIGHT JOIN puts the whole join before it on the inner
 *  side. The cases with a join order hint also print their plan, which shows whether the planner applied the hint.
 *  Those queries carry RECOMPILE because a plan prints only when the query is compiled. In a plan, the cost picks
 *  the order and the nesting of the tables that no dependency orders, so a change of the cost model or of the
 *  statistics can change those lines.
 *
 *  Coverage:
 *    Case 1:   i17 case 1 - the ON reads the table before the CROSS JOIN and the inner table, with no join term
 *    Case 2:   i17 case 2 - the ON reads only the table before the CROSS JOIN
 *    Case 3:   i17 case 3 - two CROSS JOINs between the table that the ON reads and the LEFT JOIN
 *    Case 4:   i17 case 4 - a comma before, the ON reads the table right after the comma, a CROSS JOIN in between
 *    Case 5:   i17 case 5 - no join term, a filter on each table
 *    Case 6:   i17 case 6 - a join term to each table of the CROSS JOIN
 *    Case 7:   i17 case 7 - a join term to the first table and a filter on the second
 *    Case 8:   i17 case 8 - Case 1 with a WHERE on the second table of the CROSS JOIN
 *    Case 9:   i17 case 9 - Case 1 with an IS NULL filter on the NULL-padded table in the WHERE
 *    Case 10:  i17 case 10 - a second LEFT JOIN whose ON reads the table before the CROSS JOIN
 *    Case 11:  i17 case 11 - Case 1 with a derived table in place of ta
 *    Case 12:  i17 case 12 - Case 1 with a filtered derived table in place of ta
 *    Case 13:  i17 case 13 - Case 1 with the ORDERED hint
 *    Case 14:  i17 case 14 - Case 1 with a LEADING hint on the second table
 *    Case 15:  i17 case 15 - an INNER JOIN in place of the LEFT JOIN of Case 1
 *    Case 16:  i17 case 16 - an INNER JOIN whose ON joins the inner table to the table before the CROSS JOIN
 *    Case 17:  i17 case 17 - a LEFT JOIN whose ON reads only the table right before it
 *    Case 18:  i17 case 18 - Case 1 with INNER JOIN ON 1 = 1 in place of the CROSS JOIN
 *    Case 19:  i17 case 19 - the parser refuses an ON after a comma that reads the table before the comma
 *    Case 20:  i17 case 20 - a RIGHT JOIN whose ON reads the second table of the CROSS JOIN
 *    Case 21:  i17 case 21 - Case 20 with the ORDERED hint
 *    Case 22:  i17 case 22 - Case 20 with a LEADING hint on the first table
 *    Case 23:  i17 case 30 - UPDATE through the join of Case 1, only the row with cb NULL has a NULL-padded row
 *    Case 24:  i17 case 31 - the rows of td after the UPDATE of Case 23
 *    Case 25:  i17 case 32 - DELETE through the join of Case 1
 *    Case 26:  i17 case 33 - the rows of td after the DELETE of Case 25
 */
DROP TABLE IF EXISTS ta, tb, tc, td;
CREATE TABLE ta (ca BIGINT, cb SMALLINT);
CREATE TABLE tb (ca VARCHAR(87));
CREATE TABLE tc (ca VARCHAR(10));
INSERT INTO ta VALUES (1, 1), (2, NULL);
INSERT INTO tb VALUES ('1'), ('a');
INSERT INTO tc VALUES ('1'), ('zz');
UPDATE STATISTICS ON ta, tb, tc;

evaluate 'Case 1: i17 case 1 - the ON reads the table before the CROSS JOIN and the inner table, with no join term; result = 4 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;

evaluate 'Case 2: i17 case 2 - the ON reads only the table before the CROSS JOIN; result = 6 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 ORDER BY 1, 2, 3;

evaluate 'Case 3: i17 case 3 - two CROSS JOINs between the table that the ON reads and the LEFT JOIN; result = 8 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, d.ca, c.ca FROM ta a CROSS JOIN tb b CROSS JOIN tb d LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3, 4;

evaluate 'Case 4: i17 case 4 - a comma before, the ON reads the table right after the comma, a CROSS JOIN in between; result = 8 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM ta a, tb b CROSS JOIN tb d LEFT JOIN tb c ON b.ca = '1' AND c.ca = 'a' ORDER BY 1, 2, 3;

-- Cases 5 - 7: the ON reads the tables on both sides of the CROSS JOIN
evaluate 'Case 5: i17 case 5 - no join term, a filter on each table; result = 4 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.ca = 1 AND b.ca = '1' AND c.ca = '1' ORDER BY 1, 2, 3;

evaluate 'Case 6: i17 case 6 - a join term to each table of the CROSS JOIN; result = 4 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON CAST(a.ca AS VARCHAR) = c.ca AND b.ca = c.ca ORDER BY 1, 2, 3;

evaluate 'Case 7: i17 case 7 - a join term to the first table and a filter on the second; result = 4 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON CAST(a.ca AS VARCHAR) = c.ca AND b.ca = '1' ORDER BY 1, 2, 3;

evaluate 'Case 8: i17 case 8 - Case 1 with a WHERE on the second table of the CROSS JOIN; result = 2 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' WHERE b.ca = 'a' ORDER BY 1, 2, 3;

evaluate 'Case 9: i17 case 9 - Case 1 with an IS NULL filter on the NULL-padded table in the WHERE; result = 2 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' WHERE c.ca IS NULL ORDER BY 1, 2, 3;

evaluate 'Case 10: i17 case 10 - a second LEFT JOIN whose ON reads the table before the CROSS JOIN; result = 4 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca, d.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON b.ca = c.ca LEFT JOIN tb d ON a.cb = 1 AND d.ca = 'a' ORDER BY 1, 2, 3, 4;

-- Cases 11 - 14: Case 1 through a derived table or with a join order hint
evaluate 'Case 11: i17 case 11 - Case 1 with a derived table in place of ta; result = same rows as Case 1';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM (SELECT ca, cb FROM ta) a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;

evaluate 'Case 12: i17 case 12 - Case 1 with a filtered derived table in place of ta; result = same rows as Case 1';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM (SELECT ca, cb FROM ta WHERE ca > 0) a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;

evaluate 'Case 13: i17 case 13 - Case 1 with the ORDERED hint; result = same rows as Case 1';
--@queryplan
SELECT /*+ RECOMPILE ORDERED */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;

evaluate 'Case 14: i17 case 14 - Case 1 with a LEADING hint on the second table; result = same rows as Case 1';
--@queryplan
SELECT /*+ RECOMPILE LEADING(b) */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;

-- Cases 15 - 18 are controls: they return the same rows without the fix
evaluate 'Case 15: i17 case 15 - an INNER JOIN in place of the LEFT JOIN of Case 1; result = 2 rows';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b INNER JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;

evaluate 'Case 16: i17 case 16 - an INNER JOIN whose ON joins the inner table to the table before the CROSS JOIN; result = 2 rows';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b INNER JOIN tb c ON CAST(a.ca AS VARCHAR) = c.ca ORDER BY 1, 2, 3;

evaluate 'Case 17: i17 case 17 - a LEFT JOIN whose ON reads only the table right before it; result = 4 rows';
SELECT a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b LEFT JOIN tb c ON b.ca = '1' AND c.ca = '1' ORDER BY 1, 2, 3;

evaluate 'Case 18: i17 case 18 - Case 1 with INNER JOIN ON 1 = 1 in place of the CROSS JOIN; result = same rows as Case 1';
SELECT a.ca, b.ca, c.ca FROM ta a INNER JOIN tb b ON 1 = 1 LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;

-- Case 19 is a control: it fails with the same error without the fix
-- the parser refuses this ON with -494, and Outer join query optimization failed has the same code, so the
-- answer shows only that the query fails
evaluate 'Case 19: i17 case 19 - the parser refuses an ON after a comma that reads the table before the comma; result = fails with an error';
SELECT a.ca, b.ca, c.ca FROM ta a, tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' ORDER BY 1, 2, 3;

-- Cases 20 - 22: a RIGHT JOIN after a CROSS JOIN, with and without a join order hint
evaluate 'Case 20: i17 case 20 - a RIGHT JOIN whose ON reads the second table of the CROSS JOIN; result = 3 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b RIGHT JOIN tc c ON b.ca = c.ca ORDER BY 1, 2, 3;

evaluate 'Case 21: i17 case 21 - Case 20 with the ORDERED hint; result = same rows as Case 20';
--@queryplan
SELECT /*+ RECOMPILE ORDERED */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b RIGHT JOIN tc c ON b.ca = c.ca ORDER BY 1, 2, 3;

evaluate 'Case 22: i17 case 22 - Case 20 with a LEADING hint on the first table; result = same rows as Case 20';
--@queryplan
SELECT /*+ RECOMPILE LEADING(a) */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b RIGHT JOIN tc c ON b.ca = c.ca ORDER BY 1, 2, 3;

-- Cases 23 - 26 use td, a copy of ta, so the UPDATE and the DELETE leave ta as the cases above read it
CREATE TABLE td AS SELECT * FROM ta;
UPDATE STATISTICS ON td;

-- Cases 23 - 26: UPDATE and DELETE with the join of Case 1, each followed by the rows left in td

evaluate 'Case 23: i17 case 30 - UPDATE through the join of Case 1, only the row with cb NULL has a NULL-padded row; result = 1 row affected';
UPDATE td a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' SET a.ca = a.ca + 10 WHERE c.ca IS NULL;

evaluate 'Case 24: i17 case 31 - the rows of td after the UPDATE of Case 23; result = 2 rows';
SELECT ca FROM td ORDER BY 1;

evaluate 'Case 25: i17 case 32 - DELETE through the join of Case 1; result = 1 row affected';
DELETE a FROM td a CROSS JOIN tb b LEFT JOIN tb c ON a.cb = 1 AND c.ca = '1' WHERE c.ca IS NULL;

evaluate 'Case 26: i17 case 33 - the rows of td after the DELETE of Case 25; result = 1 row';
SELECT ca FROM td ORDER BY 1;

DROP TABLE ta, tb, tc, td;

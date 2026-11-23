/**
 *  This test case verifies CBRD-27483: Join graph has no edge to the tables that the ON clause of an outer, semi
 *  or anti join depends on, so the query fails or returns a wrong result
 *
 *  An IN or EXISTS subquery after a CROSS JOIN turns into a SEMI JOIN whose ON may read the tables on both sides
 *  of the CROSS JOIN, and so may an explicit SEMI or ANTI JOIN. The fix adds join edges to the tables that the
 *  ON reads. Each case prints the rows of the query, which must be the rows that the query defines.
 *  Cases 1 - 28 come from the Jira attachment i03-cross-join-const-in-semijoin.sql, SQLancer defect 3 of
 *  CBRD-28029, without its cases 40 and 41, which have no CROSS JOIN.
 *  The SELECT cases that fail without the fix, except the ones with a join order hint, also print their plan,
 *  which shows the SEMI or ANTI JOIN after every table that its ON reads. Those queries carry RECOMPILE because a
 *  plan prints only when the query is compiled.
 *
 *  Coverage:
 *    Case 1:   i03 case 1 - an IN subquery after a CROSS JOIN, a VARCHAR constant on the left
 *    Case 2:   i03 case cb - Case 1 with a string literal on the left
 *    Case 3:   i03 case c2 - Case 1 without the CROSS JOIN
 *    Case 4:   i03 case 2 - Case 1 with a comma join in place of the CROSS JOIN
 *    Case 5:   i03 case 3 - the subquery result depends on the first table of the CROSS JOIN
 *    Case 6:   i03 case 4 - the subquery result depends on the second table of the CROSS JOIN
 *    Case 7:   i03 case 5 - one term reads the subquery table and the outer table together, with no OR
 *    Case 8:   i03 case 6 - Case 1 with a constant that no row of tb holds
 *    Case 9:   i03 case 7 - Case 1 with NOT IN
 *    Case 10:  i03 case 8 - Case 1 written as EXISTS
 *    Case 11:  i03 case 9 - Case 1 with a third table in the CROSS JOIN
 *    Case 12:  i03 case 10 - Case 1 with TO_CHAR on the left
 *    Case 13:  i03 case 11 - a BIGINT IN subquery whose OR reads the second table of the CROSS JOIN
 *    Case 14:  i03 case 12 - Case 1 with the constant bound to a host variable
 *    Case 15:  i03 case 13 - Case 14 with a value that no row of tb holds
 *    Case 16:  i03 case 14 - Case 1 with INNER JOIN ON 1 = 1 in place of the CROSS JOIN
 *    Case 17:  i03 case 15 - Case 1 with a LEFT JOIN in place of the CROSS JOIN
 *    Case 18:  i03 case 20 - Case 1 written as an explicit SEMI JOIN
 *    Case 19:  i03 case 21 - Case 18 with an ANTI JOIN
 *    Case 20:  i03 case 22 - an INNER JOIN after the CROSS JOIN and an IN subquery that reads the second table
 *    Case 21:  i03 case 23 - Case 1 with the ORDERED hint
 *    Case 22:  i03 case 24 - Case 1 with a LEADING hint on the second table
 *    Case 23:  i03 case 25 - Case 10 with NOT EXISTS
 *    Case 24:  i03 case 26 - an IN subquery with an outer column on the left and no correlation inside
 *    Case 25:  i03 case 27 - Case 1 with two tables in the subquery
 *    Case 26:  i03 case 28 - UPDATE through the join and the subquery of Case 1, each row of ta set to itself
 *    Case 27:  i03 case 29 - DELETE through the join of Case 8, no row matches
 *    Case 28:  i03 case 30 - the rows of ta after Cases 26 and 27
 *    Case 29:  a SEMI JOIN whose ON reads only the first table of the CROSS JOIN
 *    Case 30:  a SEMI JOIN whose ON joins the inner table to both tables of the CROSS JOIN
 *    Case 31:  Case 30 with a WHERE on the second table of the CROSS JOIN
 *    Case 32:  an ANTI JOIN whose ON reads only the first table of the CROSS JOIN
 *    Case 33:  an ANTI JOIN whose ON joins the inner table to both tables of the CROSS JOIN
 *    Case 34:  Case 33 with a WHERE on the second table of the CROSS JOIN
 */
DROP TABLE IF EXISTS ta, tb;
CREATE TABLE ta (ca BIGINT, cb SMALLINT);
CREATE TABLE tb (ca VARCHAR(87));
INSERT INTO ta VALUES (1, 1), (2, NULL);
INSERT INTO tb VALUES ('1'), ('a');

-- the subquery reads ta of the outer query, so the rewriter turns the IN into a SEMI JOIN whose ON reads ta
-- i.ca = i.ca holds for every row of tb, so the OR does not filter the subquery rows
evaluate 'Case 1: i03 case 1 - an IN subquery after a CROSS JOIN, a VARCHAR constant on the left; result = 4 rows';
--@queryplan
SELECT /*+ RECOMPILE */ b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 2: i03 case cb - Case 1 with a string literal on the left; result = same rows as Case 1';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE '1' IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 3: i03 case c2 - Case 1 without the CROSS JOIN; result = 2 rows';
SELECT a.ca FROM ta a WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 4: i03 case 2 - Case 1 with a comma join in place of the CROSS JOIN; result = 4 rows';
SELECT a.ca, b.ca FROM ta a, tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1, 2;

-- no row of tb has ca zz, so the subquery returns rows only for the outer rows with cb 1
evaluate 'Case 5: i03 case 3 - the subquery result depends on the first table of the CROSS JOIN; result = 2 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = 'zz') OR (a.cb = 1)) ORDER BY 1, 2;

evaluate 'Case 6: i03 case 4 - the subquery result depends on the second table of the CROSS JOIN; result = 2 rows';
SELECT a.ca, b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = 'zz') OR (b.ca = '1')) ORDER BY 1, 2;

evaluate 'Case 7: i03 case 5 - one term reads the subquery table and the outer table together, with no OR; result = 2 rows';
SELECT b.ca FROM tb b CROSS JOIN ta a WHERE CAST(1 AS BIGINT) IN (SELECT x.ca FROM ta x WHERE (CASE WHEN x.ca > 0 THEN b.ca ELSE '?' END) = '1') ORDER BY 1;

evaluate 'Case 8: i03 case 6 - Case 1 with a constant that no row of tb holds; result = no rows';
--@queryplan
SELECT /*+ RECOMPILE */ b.ca FROM ta a CROSS JOIN tb b WHERE CAST(2 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 9: i03 case 7 - Case 1 with NOT IN; result = no rows';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) NOT IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 10: i03 case 8 - Case 1 written as EXISTS; result = same rows as Case 1';
--@queryplan
SELECT /*+ RECOMPILE */ b.ca FROM ta a CROSS JOIN tb b WHERE EXISTS (SELECT 1 FROM tb i WHERE i.ca = CAST(1 AS VARCHAR) AND ((i.ca = i.ca) OR (a.cb = a.cb))) ORDER BY 1;

evaluate 'Case 11: i03 case 9 - Case 1 with a third table in the CROSS JOIN; result = 8 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, a2.ca FROM ta a CROSS JOIN tb b CROSS JOIN ta a2 WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1, 2, 3;

evaluate 'Case 12: i03 case 10 - Case 1 with TO_CHAR on the left; result = same rows as Case 1';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE TO_CHAR(1) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 13: i03 case 11 - a BIGINT IN subquery whose OR reads the second table of the CROSS JOIN; result = 4 rows';
SELECT a.ca FROM ta a CROSS JOIN tb b WHERE CAST('1' AS BIGINT) IN (SELECT x.ca FROM ta x WHERE (x.ca = x.ca) OR (b.ca = b.ca)) ORDER BY 1;

-- Cases 14 and 15 bind the left of the IN through a host variable
evaluate 'Case 14: i03 case 12 - Case 1 with the constant bound to a host variable; result = same rows as Case 1';
PREPARE p03 FROM 'SELECT b.ca FROM ta a CROSS JOIN tb b WHERE ? IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1';
EXECUTE p03 USING '1';

evaluate 'Case 15: i03 case 13 - Case 14 with a value that no row of tb holds; result = no rows';
EXECUTE p03 USING '2';

DEALLOCATE PREPARE p03;

evaluate 'Case 16: i03 case 14 - Case 1 with INNER JOIN ON 1 = 1 in place of the CROSS JOIN; result = same rows as Case 1';
SELECT b.ca FROM ta a INNER JOIN tb b ON 1 = 1 WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 17: i03 case 15 - Case 1 with a LEFT JOIN in place of the CROSS JOIN; result = 4 rows';
SELECT a.ca, b.ca FROM ta a LEFT OUTER JOIN tb b ON b.ca IS NOT NULL WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1, 2;

evaluate 'Case 18: i03 case 20 - Case 1 written as an explicit SEMI JOIN; result = same rows as Case 1';
--@queryplan
SELECT /*+ RECOMPILE */ b.ca FROM ta a CROSS JOIN tb b SEMI JOIN tb i ON i.ca = CAST(1 AS VARCHAR) AND ((i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 19: i03 case 21 - Case 18 with an ANTI JOIN; result = no rows';
SELECT b.ca FROM ta a CROSS JOIN tb b ANTI JOIN tb i ON i.ca = CAST(1 AS VARCHAR) AND ((i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 20: i03 case 22 - an INNER JOIN after the CROSS JOIN and an IN subquery that reads the second table; result = 2 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b INNER JOIN tb c ON CAST(a.ca AS VARCHAR) = c.ca WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (b.ca = '1')) ORDER BY 1, 2, 3;

evaluate 'Case 21: i03 case 23 - Case 1 with the ORDERED hint; result = same rows as Case 1';
SELECT /*+ ORDERED */ b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 22: i03 case 24 - Case 1 with a LEADING hint on the second table; result = same rows as Case 1';
SELECT /*+ LEADING(b) */ b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 23: i03 case 25 - Case 10 with NOT EXISTS; result = no rows';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE NOT EXISTS (SELECT 1 FROM tb i WHERE i.ca = CAST(1 AS VARCHAR) AND ((i.ca = i.ca) OR (a.cb = a.cb))) ORDER BY 1;

evaluate 'Case 24: i03 case 26 - an IN subquery with an outer column on the left and no correlation inside; result = 2 rows';
SELECT a.ca, b.ca FROM ta a CROSS JOIN tb b WHERE CAST(a.ca AS VARCHAR) IN (SELECT i.ca FROM tb i) ORDER BY 1, 2;

evaluate 'Case 25: i03 case 27 - Case 1 with two tables in the subquery; result = same rows as Case 1';
--@queryplan
SELECT /*+ RECOMPILE */ b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i, ta j WHERE ((i.ca = i.ca) OR (a.cb = a.cb)) AND j.ca = 1) ORDER BY 1;

-- Cases 26 - 28: UPDATE and DELETE with the subquery of Case 1, then the rows left in ta
evaluate 'Case 26: i03 case 28 - UPDATE through the join and the subquery of Case 1, each row of ta set to itself; result = 2 rows affected';
UPDATE ta a CROSS JOIN tb b SET a.ca = a.ca WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb));

evaluate 'Case 27: i03 case 29 - DELETE through the join of Case 8, no row matches; result = 0 rows affected';
DELETE a FROM ta a CROSS JOIN tb b WHERE CAST(2 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb));

evaluate 'Case 28: i03 case 30 - the rows of ta after Cases 26 and 27; result = 2 rows';
SELECT ca, cb FROM ta ORDER BY 1, 2;

DROP TABLE ta, tb;
DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3), (4, NULL);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb VALUES (1, 1), (2, 2), (3, NULL);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO tc VALUES (1, 1), (1, 2), (2, 3), (5, 1);
UPDATE STATISTICS ON ta, tb, tc;

-- an explicit SEMI or ANTI JOIN whose ON joins both tables of the CROSS JOIN, with and without a WHERE
evaluate 'Case 29: a SEMI JOIN whose ON reads only the first table of the CROSS JOIN; result = 6 rows';
SELECT ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb SEMI JOIN tc ON tc.ca = ta.ca ORDER BY 1, 2, 3, 4;

evaluate 'Case 30: a SEMI JOIN whose ON joins the inner table to both tables of the CROSS JOIN; result = 2 rows';
SELECT ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb SEMI JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb ORDER BY 1, 2, 3, 4;

-- tb.cb = 1 in the WHERE adds tc.cb = 1 to the ON through the equivalence of tc.cb and tb.cb
evaluate 'Case 31: Case 30 with a WHERE on the second table of the CROSS JOIN; result = 1 row';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb SEMI JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE tb.cb = 1 ORDER BY 1, 2, 3, 4;

evaluate 'Case 32: an ANTI JOIN whose ON reads only the first table of the CROSS JOIN; result = 6 rows';
SELECT ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb ANTI JOIN tc ON tc.ca = ta.ca ORDER BY 1, 2, 3, 4;

evaluate 'Case 33: an ANTI JOIN whose ON joins the inner table to both tables of the CROSS JOIN; result = 10 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb ANTI JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb ORDER BY 1, 2, 3, 4;

evaluate 'Case 34: Case 33 with a WHERE on the second table of the CROSS JOIN; result = 3 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb ANTI JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE tb.cb = 1 ORDER BY 1, 2, 3, 4;

DROP TABLE ta, tb, tc;

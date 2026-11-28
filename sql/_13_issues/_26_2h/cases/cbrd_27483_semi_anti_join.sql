/**
 *  This test case verifies CBRD-27483: Join graph has no edge to the tables that the ON clause of an outer, semi
 *  or anti join depends on, so the query fails or returns a wrong result
 *
 *  The cases run a SEMI or ANTI JOIN after a CROSS JOIN, written out or made by the rewriter from an IN or EXISTS
 *  subquery. A SEMI or ANTI JOIN comes after every table that its ON reads. The CROSS JOIN can leave such a table
 *  with no join edge, and the planner then finds no join order. The fix adds join edges to the tables that the ON
 *  reads.
 *  Each case prints the result that its query defines. A case that repeats another case with a hint or in another
 *  form prints the same result.
 *  A case taken from an attached file names it at the end of its label: i03 case N is case N of the Jira attachment
 *  i03-cross-join-const-in-semijoin.sql, SQLancer defect 3 of CBRD-28029. Its cases 40 - 43 and c40 have no CROSS
 *  JOIN and are left out.
 *  The SELECT statements with a join that fail or return a wrong result without the fix also print their plan. The
 *  plan of a SEMI or ANTI JOIN puts its inner table after every table that its ON reads. The cases with a join
 *  order hint print their plan too, which shows whether the planner applied the hint. The queries with a plan carry
 *  RECOMPILE because a plan prints only when the query is compiled. In a plan, the cost picks the order and the
 *  nesting of the tables that no dependency orders, so a change of the cost model or of the statistics can change
 *  those lines.
 *
 *  Coverage:
 *    Case 1:   an IN subquery after a CROSS JOIN, a VARCHAR constant on the left (i03 case 1)
 *    Case 2:   the subquery result depends on the first table of the CROSS JOIN (i03 case 3)
 *    Case 3:   Case 1 with a constant that no row of tb holds (i03 case 6)
 *    Case 4:   Case 1 with a third table in the CROSS JOIN (i03 case 9)
 *    Case 5:   Case 1 with two tables in the subquery (i03 case 27)
 *    Case 6:   an INNER JOIN after the CROSS JOIN and an IN subquery that reads the second table (i03 case 22)
 *    Case 7:   Case 1 with the constant bound to a host variable (i03 case 12)
 *    Case 8:   Case 7 with a value that no row of tb holds (i03 case 13)
 *    Case 9:   Case 1 written as EXISTS (i03 case 8)
 *    Case 10:  Case 1 written as an explicit SEMI JOIN (i03 case 20)
 *    Case 11:  Case 1 with the ORDERED hint (i03 case 23)
 *    Case 12:  Case 1 with a LEADING hint on the second table (i03 case 24)
 *    Case 13:  Case 1 with a string literal on the left (i03 case c1)
 *    Case 14:  Case 1 with TO_CHAR on the left (i03 case 10)
 *    Case 15:  Case 1 without the CROSS JOIN (i03 case c2)
 *    Case 16:  Case 1 with a comma join in place of the CROSS JOIN (i03 case 2)
 *    Case 17:  Case 1 with INNER JOIN ON 1 = 1 in place of the CROSS JOIN (i03 case 14)
 *    Case 18:  Case 1 with a LEFT JOIN in place of the CROSS JOIN (i03 case 15)
 *    Case 19:  the subquery result depends on the second table of the CROSS JOIN (i03 case 4)
 *    Case 20:  a BIGINT IN subquery whose OR reads the second table of the CROSS JOIN (i03 case 11)
 *    Case 21:  one term reads the subquery table and the outer table together, with no OR (i03 case 5)
 *    Case 22:  an IN subquery with an outer column on the left and no correlation inside (i03 case 26)
 *    Case 23:  Case 1 with NOT IN (i03 case 7)
 *    Case 24:  Case 9 with NOT EXISTS (i03 case 25)
 *    Case 25:  Case 10 with an ANTI JOIN (i03 case 21)
 *    Case 26:  UPDATE through the join and the subquery of Case 1 (i03 case 28)
 *    Case 27:  DELETE through the join and the subquery of Case 3 (i03 case 29)
 *    Case 28:  the rows of ta after Cases 26 and 27 (i03 case 30)
 *    Case 29:  a SEMI JOIN whose ON joins the inner table to both tables of the CROSS JOIN, with a WHERE on the
 *              second table
 *    Case 30:  an ANTI JOIN whose ON joins the inner table to both tables of the CROSS JOIN
 *    Case 31:  Case 30 with a WHERE on the second table of the CROSS JOIN
 *    Case 32:  a SEMI JOIN whose ON reads only the first table of the CROSS JOIN
 *    Case 33:  Case 29 without the WHERE
 *    Case 34:  Case 32 with an ANTI JOIN
 */
DROP TABLE IF EXISTS ta, tb;
CREATE TABLE ta (ca BIGINT, cb SMALLINT);
CREATE TABLE tb (ca VARCHAR(87));
INSERT INTO ta VALUES (1, 1), (2, NULL);
INSERT INTO tb VALUES ('1'), ('a');
UPDATE STATISTICS ON ta, tb;

-- Cases 1 - 8: an IN subquery
-- the subquery reads ta of the outer query, so the rewriter turns the IN into a SEMI JOIN whose ON reads ta
-- i.ca = i.ca holds for every row of tb, so the OR does not filter the subquery rows
evaluate 'Case 1: an IN subquery after a CROSS JOIN, a VARCHAR constant on the left (i03 case 1); result = 4 rows';
--@queryplan
SELECT /*+ RECOMPILE */ b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

-- no row of tb has ca zz, so only a.cb = 1 can make the subquery return a row
evaluate 'Case 2: the subquery result depends on the first table of the CROSS JOIN (i03 case 3); result = 2 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = 'zz') OR (a.cb = 1)) ORDER BY 1, 2;

evaluate 'Case 3: Case 1 with a constant that no row of tb holds (i03 case 6); result = no rows';
--@queryplan
SELECT /*+ RECOMPILE */ b.ca FROM ta a CROSS JOIN tb b WHERE CAST(2 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 4: Case 1 with a third table in the CROSS JOIN (i03 case 9); result = 8 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, a2.ca FROM ta a CROSS JOIN tb b CROSS JOIN ta a2 WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1, 2, 3;

evaluate 'Case 5: Case 1 with two tables in the subquery (i03 case 27); result = same rows as Case 1';
--@queryplan
SELECT /*+ RECOMPILE */ b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i, ta j WHERE ((i.ca = i.ca) OR (a.cb = a.cb)) AND j.ca = 1) ORDER BY 1;

evaluate 'Case 6: an INNER JOIN after the CROSS JOIN and an IN subquery that reads the second table (i03 case 22); result = 2 rows';
--@queryplan
SELECT /*+ RECOMPILE */ a.ca, b.ca, c.ca FROM ta a CROSS JOIN tb b INNER JOIN tb c ON CAST(a.ca AS VARCHAR) = c.ca WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (b.ca = '1')) ORDER BY 1, 2, 3;

-- Case 8 executes the statement that Case 7 prepared
evaluate 'Case 7: Case 1 with the constant bound to a host variable (i03 case 12); result = same rows as Case 1';
PREPARE p03 FROM 'SELECT b.ca FROM ta a CROSS JOIN tb b WHERE ? IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1';
EXECUTE p03 USING '1';

evaluate 'Case 8: Case 7 with a value that no row of tb holds (i03 case 13); result = no rows';
EXECUTE p03 USING '2';

DEALLOCATE PREPARE p03;

-- Cases 9 - 10: Case 1 in another form
evaluate 'Case 9: Case 1 written as EXISTS (i03 case 8); result = same rows as Case 1';
--@queryplan
SELECT /*+ RECOMPILE */ b.ca FROM ta a CROSS JOIN tb b WHERE EXISTS (SELECT 1 FROM tb i WHERE i.ca = CAST(1 AS VARCHAR) AND ((i.ca = i.ca) OR (a.cb = a.cb))) ORDER BY 1;

evaluate 'Case 10: Case 1 written as an explicit SEMI JOIN (i03 case 20); result = same rows as Case 1';
--@queryplan
SELECT /*+ RECOMPILE */ b.ca FROM ta a CROSS JOIN tb b SEMI JOIN tb i ON i.ca = CAST(1 AS VARCHAR) AND ((i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

-- Cases 11 - 12: Case 1 with a join order hint
evaluate 'Case 11: Case 1 with the ORDERED hint (i03 case 23); result = same rows as Case 1';
--@queryplan
SELECT /*+ RECOMPILE ORDERED */ b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 12: Case 1 with a LEADING hint on the second table (i03 case 24); result = same rows as Case 1';
--@queryplan
SELECT /*+ RECOMPILE LEADING(b) */ b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

-- Cases 13 - 25 are controls: they return the same result without the fix
evaluate 'Case 13: Case 1 with a string literal on the left (i03 case c1); result = same rows as Case 1';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE '1' IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 14: Case 1 with TO_CHAR on the left (i03 case 10); result = same rows as Case 1';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE TO_CHAR(1) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 15: Case 1 without the CROSS JOIN (i03 case c2); result = 2 rows';
SELECT a.ca FROM ta a WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 16: Case 1 with a comma join in place of the CROSS JOIN (i03 case 2); result = 4 rows';
SELECT a.ca, b.ca FROM ta a, tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1, 2;

evaluate 'Case 17: Case 1 with INNER JOIN ON 1 = 1 in place of the CROSS JOIN (i03 case 14); result = same rows as Case 1';
SELECT b.ca FROM ta a INNER JOIN tb b ON 1 = 1 WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 18: Case 1 with a LEFT JOIN in place of the CROSS JOIN (i03 case 15); result = 4 rows';
SELECT a.ca, b.ca FROM ta a LEFT OUTER JOIN tb b ON b.ca IS NOT NULL WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1, 2;

evaluate 'Case 19: the subquery result depends on the second table of the CROSS JOIN (i03 case 4); result = 2 rows';
SELECT a.ca, b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = 'zz') OR (b.ca = '1')) ORDER BY 1, 2;

evaluate 'Case 20: a BIGINT IN subquery whose OR reads the second table of the CROSS JOIN (i03 case 11); result = 4 rows';
SELECT a.ca FROM ta a CROSS JOIN tb b WHERE CAST('1' AS BIGINT) IN (SELECT x.ca FROM ta x WHERE (x.ca = x.ca) OR (b.ca = b.ca)) ORDER BY 1;

evaluate 'Case 21: one term reads the subquery table and the outer table together, with no OR (i03 case 5); result = 2 rows';
SELECT b.ca FROM tb b CROSS JOIN ta a WHERE CAST(1 AS BIGINT) IN (SELECT x.ca FROM ta x WHERE (CASE WHEN x.ca > 0 THEN b.ca ELSE '?' END) = '1') ORDER BY 1;

evaluate 'Case 22: an IN subquery with an outer column on the left and no correlation inside (i03 case 26); result = 2 rows';
SELECT a.ca, b.ca FROM ta a CROSS JOIN tb b WHERE CAST(a.ca AS VARCHAR) IN (SELECT i.ca FROM tb i) ORDER BY 1, 2;

evaluate 'Case 23: Case 1 with NOT IN (i03 case 7); result = no rows';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE CAST(1 AS VARCHAR) NOT IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

evaluate 'Case 24: Case 9 with NOT EXISTS (i03 case 25); result = no rows';
SELECT b.ca FROM ta a CROSS JOIN tb b WHERE NOT EXISTS (SELECT 1 FROM tb i WHERE i.ca = CAST(1 AS VARCHAR) AND ((i.ca = i.ca) OR (a.cb = a.cb))) ORDER BY 1;

evaluate 'Case 25: Case 10 with an ANTI JOIN (i03 case 21); result = no rows';
SELECT b.ca FROM ta a CROSS JOIN tb b ANTI JOIN tb i ON i.ca = CAST(1 AS VARCHAR) AND ((i.ca = i.ca) OR (a.cb = a.cb)) ORDER BY 1;

-- Cases 26 - 28: UPDATE and DELETE with the subquery of Case 1, followed by the rows left in ta
-- the UPDATE sets each row to itself and the DELETE matches no row, so Case 28 prints the rows that the setup inserted
evaluate 'Case 26: UPDATE through the join and the subquery of Case 1 (i03 case 28); result = 2 rows affected';
UPDATE ta a CROSS JOIN tb b SET a.ca = a.ca WHERE CAST(1 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb));

evaluate 'Case 27: DELETE through the join and the subquery of Case 3 (i03 case 29); result = 0 rows affected';
DELETE a FROM ta a CROSS JOIN tb b WHERE CAST(2 AS VARCHAR) IN (SELECT i.ca FROM tb i WHERE (i.ca = i.ca) OR (a.cb = a.cb));

evaluate 'Case 28: the rows of ta after Cases 26 and 27 (i03 case 30); result = 2 rows';
SELECT ca, cb FROM ta ORDER BY 1, 2;

DROP TABLE ta, tb;

-- Cases 29 - 34 use new data, the data of Cases 16 - 19 of cbrd_27483_outer_join.sql: cb has NULLs and tc has two
-- rows for ca 1, so an ON that joins tc to both tables of the CROSS JOIN matches only some pairs
DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3), (4, NULL);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb VALUES (1, 1), (2, 2), (3, NULL);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO tc VALUES (1, 1), (1, 2), (2, 3), (5, 1);
UPDATE STATISTICS ON ta, tb, tc;

-- Cases 29 - 31: an explicit SEMI or ANTI JOIN whose ON joins the inner table to both tables of the CROSS JOIN
-- tb.cb = 1 in the WHERE adds tc.cb = 1 through the equivalence of tc.cb and tb.cb
evaluate 'Case 29: a SEMI JOIN whose ON joins the inner table to both tables of the CROSS JOIN, with a WHERE on the second table; result = 1 row';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb SEMI JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE tb.cb = 1 ORDER BY 1, 2, 3, 4;

evaluate 'Case 30: an ANTI JOIN whose ON joins the inner table to both tables of the CROSS JOIN; result = 10 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb ANTI JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb ORDER BY 1, 2, 3, 4;

evaluate 'Case 31: Case 30 with a WHERE on the second table of the CROSS JOIN; result = 3 rows';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb ANTI JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE tb.cb = 1 ORDER BY 1, 2, 3, 4;

-- Cases 32 - 34 are controls: they return the same result without the fix
evaluate 'Case 32: a SEMI JOIN whose ON reads only the first table of the CROSS JOIN; result = 6 rows';
SELECT ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb SEMI JOIN tc ON tc.ca = ta.ca ORDER BY 1, 2, 3, 4;

evaluate 'Case 33: Case 29 without the WHERE; result = 2 rows';
SELECT ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb SEMI JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb ORDER BY 1, 2, 3, 4;

evaluate 'Case 34: Case 32 with an ANTI JOIN; result = 6 rows';
SELECT ta.ca, ta.cb, tb.ca, tb.cb FROM ta CROSS JOIN tb ANTI JOIN tc ON tc.ca = ta.ca ORDER BY 1, 2, 3, 4;

DROP TABLE ta, tb, tc;

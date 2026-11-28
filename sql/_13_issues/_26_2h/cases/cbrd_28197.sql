/**
 *  This test case verifies CBRD-28197: ORDER BY ... FOR orderby_num () was ignored on an aggregate query with no
 *  GROUP BY, and orderby_num () in its select list showed 0
 *
 *  An aggregate query without GROUP BY gives one row and runs as a BUILDVALUE XASL, which neither numbers that row
 *  nor evaluates an ORDERBY_NUM () predicate. So a false FOR condition still returned the row, and orderby_num () in
 *  the select list showed 0. LIMIT was right because the query is wrapped in a derived table for it. The fix folds
 *  ORDERBY_NUM () of such a query to 1: the FOR condition filters the one row like HAVING, and the select list shows
 *  1 under the title orderby_num(). Before the fix, cases 1 to 3, 5, 6, the first query of 8, and 9 to 13 kept
 *  the row (case 9 gave 2, not NULL, case 12 matched id 2, case 13 added 2), and the first query of 14 showed 0.
 *
 *  Coverage:
 *    Case 1:  COUNT with FOR orderby_num () = 0 returns no row
 *    Case 2:  COUNT with FOR orderby_num () > 1 returns no row
 *    Case 3:  SUM with FOR orderby_num () = 0 returns no row
 *    Case 4:  COUNT with FOR orderby_num () = 1 returns the row
 *    Case 5:  ORDER BY on the aggregate itself (the clause is dropped for one row) with a false FOR returns no row
 *    Case 6:  HAVING that holds and a false FOR returns no row
 *    Case 7:  HAVING that holds and a true FOR returns the row
 *    Case 8:  FOR orderby_num () <= ? with a bind value of 0 returns no row, with 1 returns the row
 *    Case 9:  a scalar subquery with a false FOR gives NULL
 *    Case 10: a derived table with a false FOR has no row
 *    Case 11: a view with a false FOR has no row, and the view keeps its definition as written
 *    Case 12: the aggregate inside IN with a false FOR matches nothing
 *    Case 13: an aggregate query with a false FOR inside UNION ALL adds no row
 *    Case 14: orderby_num () in the select list is 1, with and without LIMIT
 *    Case 15: orderby_num () of a subquery in the select list numbers the rows of the subquery
 *    Case 16: controls, unchanged by the fix: FOR on a GROUP BY query and on plain rows, and orderby_num () without
 *             ORDER BY, which is an error
 */
DROP VIEW IF EXISTS v28197;
DROP TABLE IF EXISTS t28197;
CREATE TABLE t28197 (id INT);
INSERT INTO t28197 VALUES (1), (2);

evaluate 'Case 1: COUNT with FOR orderby_num () = 0 returns no row';
SELECT COUNT (*) FROM t28197 ORDER BY 1 FOR orderby_num () = 0;

evaluate 'Case 2: COUNT with FOR orderby_num () > 1 returns no row';
SELECT COUNT (*) FROM t28197 ORDER BY 1 FOR orderby_num () > 1;

evaluate 'Case 3: SUM with FOR orderby_num () = 0 returns no row';
SELECT SUM (id) FROM t28197 ORDER BY 1 FOR orderby_num () = 0;

evaluate 'Case 4: COUNT with FOR orderby_num () = 1 returns the row';
SELECT COUNT (*) FROM t28197 ORDER BY 1 FOR orderby_num () = 1;

evaluate 'Case 5: ORDER BY on the aggregate itself with a false FOR returns no row';
SELECT COUNT (*) FROM t28197 ORDER BY COUNT (*) FOR orderby_num () = 0;

evaluate 'Case 6: HAVING that holds and a false FOR returns no row';
SELECT COUNT (*) FROM t28197 HAVING COUNT (*) > 0 ORDER BY 1 FOR orderby_num () = 0;

evaluate 'Case 7: HAVING that holds and a true FOR returns the row';
SELECT COUNT (*) FROM t28197 HAVING COUNT (*) > 0 ORDER BY 1 FOR orderby_num () = 1;

evaluate 'Case 8: FOR orderby_num () <= ? with a bind value of 0 returns no row, with 1 returns the row';
PREPARE s FROM 'SELECT COUNT (*) FROM t28197 ORDER BY 1 FOR orderby_num () <= ?';
EXECUTE s USING 0;
EXECUTE s USING 1;
DEALLOCATE PREPARE s;

evaluate 'Case 9: a scalar subquery with a false FOR gives NULL';
SELECT (SELECT COUNT (*) FROM t28197 ORDER BY 1 FOR orderby_num () = 0) AS c FROM db_root;

evaluate 'Case 10: a derived table with a false FOR has no row';
SELECT * FROM (SELECT COUNT (*) AS c FROM t28197 ORDER BY 1 FOR orderby_num () = 0) x;

evaluate 'Case 11: a view with a false FOR has no row, and the view keeps its definition as written';
CREATE VIEW v28197 AS SELECT COUNT (*) AS c FROM t28197 ORDER BY 1 FOR orderby_num () = 0;
SELECT * FROM v28197;
SELECT vclass_def FROM db_vclass WHERE vclass_name = 'v28197';

evaluate 'Case 12: the aggregate inside IN with a false FOR matches nothing';
SELECT id FROM t28197 WHERE id IN (SELECT COUNT (*) FROM t28197 ORDER BY 1 FOR orderby_num () = 0) ORDER BY id;

evaluate 'Case 13: an aggregate query with a false FOR inside UNION ALL adds no row';
SELECT c FROM ((SELECT COUNT (*) AS c FROM t28197 ORDER BY 1 FOR orderby_num () = 0) UNION ALL (SELECT 9)) u ORDER BY c;

evaluate 'Case 14: orderby_num () in the select list is 1, with and without LIMIT';
SELECT COUNT (*), orderby_num () FROM t28197 ORDER BY 1;
SELECT COUNT (*), orderby_num () FROM t28197 ORDER BY 1 LIMIT 5;

evaluate 'Case 15: orderby_num () of a subquery in the select list numbers the rows of the subquery';
SELECT COUNT (*), (SELECT id FROM t28197 ORDER BY id FOR orderby_num () = 2) AS second_id FROM t28197 ORDER BY 1;

evaluate 'Case 16: controls: FOR on a GROUP BY query and on plain rows, and orderby_num () without ORDER BY';
SELECT id, COUNT (*) FROM t28197 GROUP BY id ORDER BY 1 FOR orderby_num () = 2;
SELECT id FROM t28197 ORDER BY 1 FOR orderby_num () = 0;
SELECT COUNT (*), orderby_num () FROM t28197;

DROP VIEW v28197;
DROP TABLE t28197;

/**
 *  This test case verifies CBRD-27961: a statement that a driver prepares and runs with bind values failed with
 *  "Invalid XASL tree node content." when the WHERE of one arm of a UNION ALL folded to a constant false. The driver
 *  session compiles the statement text again for the types of the bound values, and it takes that text from the
 *  statement node. Folding the set operation put the arm that remains in place of the statement, and that arm did not
 *  carry the text. The remaining arm (or the derived table made around it) now carries it.
 *  The queries here run through the driver with the values on the $ lines bound to the ? marks.
 *
 *  Coverage:
 *    Case 1: the bind variable in the arm that folds away
 *    Case 2: the bind variable in the arm that remains
 *    Case 3: the remaining arm and the UNION ALL both have ORDER BY with LIMIT, so a derived table replaces them
 *    Case 4: the same text bound with another type (VARCHAR), which compiles it again
 *    Case 5: no arm folds (control)
 */

drop table if exists t_27961;

create table t_27961 (c0 int);
insert into t_27961 values (1), (2), (3);

evaluate 'Case 1: the bind variable in the arm that folds away';
$int, $1;
select c0 from t_27961 where (c0 = ?) and (1 = 0) union all select c0 from t_27961 where c0 = 1 order by 1;

evaluate 'Case 2: the bind variable in the arm that remains';
$int, $2;
select c0 from t_27961 where c0 = 1 and 1 = 0 union all select c0 from t_27961 where c0 >= ? order by 1;

evaluate 'Case 3: ORDER BY with LIMIT in the remaining arm and in the UNION ALL';
$int, $2;
(select c0 from t_27961 where c0 >= ? order by c0 desc limit 2) union all (select c0 from t_27961 where 1 = 0) order by 1 limit 1;

evaluate 'Case 4: the same text bound with a VARCHAR value';
$varchar, $2;
select c0 from t_27961 where c0 = 1 and 1 = 0 union all select c0 from t_27961 where c0 >= ? order by 1;

evaluate 'Case 5: no arm folds';
$int, $1;
select c0 from t_27961 where (c0 = ?) and (1 = 1) union all select c0 from t_27961 where c0 = 1 order by 1;

drop table t_27961;

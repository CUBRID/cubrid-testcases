/**
 *  This test case verifies CBRD-28066: a collection whose element is a string expression over a bound value
 *  failed with ER_QPROC_DOMAIN_UNRESOLVED when its plan was loaded, and a debug server aborted
 *
 *  Type checking left the element domains of such a collection to the values, and XASL generation kept them
 *  in the domain of the collection constructor - an IN list, = ANY {}, a row value, SET{} - so the load check
 *  of the plan refused it. XASL generation now lists the decided domains of the elements. The domain cache of
 *  the server also told such a collection domain from a decided one of the same shape only by type, so one
 *  statement could fail later statements of the same shape, or hide the failure of a later one, until the
 *  server restarted.
 *
 *  Coverage:
 *    Case 1:  the statement of the issue - NOT IN over NULLIF and CASE - returns its rows
 *    Case 2:  IN and NOT IN lists over NVL, IFNULL, NVL2 and COALESCE of a bound value return their rows
 *    Case 3:  = ANY over GREATEST and LEAST of a bound value returns its rows
 *    Case 4:  a row value IN over NULLIF of a bound value returns its rows
 *    Case 5:  SET and LIST constructors over a bound value in the select list, ORDER BY and GROUP BY
 *    Case 6:  a derived table column and a correlated subquery of a collection over a bound value
 *    Case 7:  INSERT and UPDATE with such a collection
 *    Case 8:  after Cases 1 to 7, collections of the same shapes without a bound value still load
 *    Case 9:  the IN list and = ANY of Cases 2 and 3 through driver bind values
 *    Case 10: SET, MULTISET and LIST of a subquery whose later column is a string over a bound value hold
 *             each column's values in its own type (an earlier commit of the engine PR read them as the first
 *             column's INTEGER)
 *    Case 11: SET{?, 1}, SET{(- ?), 1} and a SET or LIST of a subquery with such a column hold the bound value in
 *             its own type (develop read it in the other element's type, or crashed)
 *    Case 12: a SUBSETEQ that applies a collation to a set holding a NUMERIC literal (a debug build aborted)
 *    Case 13: LIST of a subquery with NVL of a bound value as its later, last or first column holds each column's
 *             values in their own types (an earlier commit of the engine PR read 'zz' as an INTEGER), and the
 *             values compared with the expected collection in WHERE
 *    Case 14: {1, NVL (?, 'x')} = {1, 'zz'} returns a logical value (a debug client aborted copying the result
 *             column's type, which carried the element's collation)
 *  The driver of the test prints a collection whose elements are of more than one type as null, so Cases 10, 11
 *  and 13 print null where the values keep their types, and a value read in another element's type prints as a number
 *  (41581056 for 'zz') and an unreadable one fails.
 */
drop table if exists t_str, t_set;
-- c0 holds digits, so that comparing it with the integer element 1 of a list does not fail
create table t_str (c0 varchar, c1 int);
insert into t_str values ('1', 1), ('7', 7), (null, null);
create table t_set (s set of varchar);

evaluate 'Case 1: the statement of the issue returns its rows';
prepare st from 'select c0 from t_str where (- nullif(?, ?)) not in (nullif(?, (case c0 when c0 then ? else ? end)), 1) order by c0';
execute st using -1865146421, -1051665807, 1055619571, 819713501, -117504885;
deallocate prepare st;

evaluate 'Case 2: IN and NOT IN lists over NVL, IFNULL, NVL2 and COALESCE';
prepare st from 'select c0 from t_str where c0 in (nvl(?, ''x''), 1) order by c0';
execute st using '7';
deallocate prepare st;
prepare st from 'select c0 from t_str where c0 in (ifnull(?, c0), 1) order by c0';
execute st using null;
deallocate prepare st;
prepare st from 'select c0 from t_str where c0 not in (nvl2(null, ?, c0), coalesce(?, ''x'')) order by c0';
execute st using '1', '7';
deallocate prepare st;

evaluate 'Case 3: = ANY over GREATEST and LEAST';
prepare st from 'select c0 from t_str where c0 = any {greatest(?, ''1''), least(?, c0)} order by c0';
execute st using '7', '9';
deallocate prepare st;

evaluate 'Case 4: a row value IN over NULLIF';
prepare st from 'select c0 from t_str where (c0, c1) in ((nullif(''1'', ?), 1), (''7'', 7)) order by c0';
execute st using 'z';
deallocate prepare st;

evaluate 'Case 5: SET and LIST over a bound value in the select list, ORDER BY and GROUP BY';
prepare st from 'select set{nvl(?, ''x''), c1} from t_str order by c1';
execute st using 'v';
deallocate prepare st;
prepare st from 'select list{greatest(?, c0), 1} from t_str where c0 is not null order by c0';
execute st using '5';
deallocate prepare st;
prepare st from 'select c0 from t_str where c0 is not null order by set{nullif(''x'', ?), c0}';
execute st using 'x';
deallocate prepare st;
prepare st from 'select count(*) from t_str group by set{nvl(?, ''x''), 1}';
execute st using 'g';
deallocate prepare st;

evaluate 'Case 6: a derived table column and a correlated subquery';
prepare st from 'select x.s from (select set{nvl(?, ''x''), c1} as s, c1 from t_str) x order by x.c1';
execute st using 'd';
deallocate prepare st;
prepare st from 'select (select set{greatest(?, ''x''), t_str.c1} from db_root) from t_str order by c1';
execute st using 'y';
deallocate prepare st;

evaluate 'Case 7: INSERT and UPDATE with such a collection';
prepare st from 'insert into t_set (s) values (set{nvl(?, ''x''), ''z''})';
execute st using 'w';
deallocate prepare st;
select s from t_set;
prepare st from 'update t_str set c1 = c1 + 100 where c0 in (nvl(?, ''x''), 1)';
execute st using '7';
deallocate prepare st;
select c0, c1 from t_str order by c0;

-- Case 8 runs after the statements above, whose collection domains the server has cached
evaluate 'Case 8: collections of the same shapes without a bound value still load';
select set{c0, 1} from t_str order by c0;
select c0 from t_str where c0 in (nvl(c0, '0'), 1) order by c0;

evaluate 'Case 9: the IN list and = ANY through driver bind values';
$varchar, $7
select c0 from t_str where c0 in (nvl(?, 'x'), 1) order by c0;
$varchar, $7, $varchar, $9
select c0 from t_str where c0 = any {greatest(?, '1'), least(?, c0)} order by c0;

evaluate 'Case 10: a collection of a subquery holds the values of every column in their own types';
prepare st from 'select list (select c1, nvl (?, ''x'') from t_str order by 1) from db_root';
execute st using 'zz';
deallocate prepare st;
prepare st from 'select set (select c1, nvl (?, ''x'') from t_str) from db_root';
execute st using 'zz';
deallocate prepare st;
prepare st from 'select multiset (select c1, c0, nvl (?, ''x'') from t_str) from db_root';
execute st using 'zz';
deallocate prepare st;

evaluate 'Case 11: a collection with an element whose type the bound value decides holds that value in its own type';
prepare st from 'select set {?, 1} from db_root';
execute st using 2.5;
execute st using 'ab';
deallocate prepare st;
prepare st from 'select set {(- ?), 1} from db_root';
execute st using 2.5;
deallocate prepare st;
prepare st from 'select list (select c1, (- ?) from t_str order by 1) from db_root';
execute st using 2.5;
deallocate prepare st;
prepare st from 'select set (select c0, (- ?) from t_str) from db_root';
execute st using 7;
deallocate prepare st;
prepare st from 'select list (select c1, to_char (?) from t_str order by 1) from db_root';
execute st using 2.5;
deallocate prepare st;

evaluate 'Case 12: SUBSETEQ of a collation-applied collection against a set holding a NUMERIC literal';
prepare st from 'select c0 from t_str where set (select nvl (?, c0 collate utf8_en_ci), c1 from t_str) subseteq set {''x'', 1, 2.5} order by 1';
execute st using 7;
deallocate prepare st;

evaluate 'Case 13: LIST of a subquery whose later or first column is NVL of a bound value (the shapes of the review)';
create table t2 (id int, v varchar(10));
insert into t2 values (1, 'a'), (2, 'b');
prepare s from 'select list (select id, nvl (?, ''x'') from t2 order by 1) from db_root';
execute s using 'zz';
deallocate prepare s;
prepare s from 'select list (select id, v, nvl (?, ''x'') from t2 order by 1) from db_root';
execute s using 'zz';
deallocate prepare s;
prepare s from 'select list (select nvl (?, ''x''), id from t2 order by 2) from db_root';
execute s using 'zz';
deallocate prepare s;
-- the values, by a comparison in WHERE (a row when they are the expected ones, none for 'yy'): the select list
-- above shows the regression (an element read in another's type), this the values the driver does not print
prepare s from 'select ''eq'' from db_root where list (select id, nvl (?, ''x'') from t2 order by 1) = {1, ''zz'', 2, ''zz''}';
execute s using 'zz';
execute s using 'yy';
deallocate prepare s;
prepare s from 'select ''eq'' from db_root where list (select id, v, nvl (?, ''x'') from t2 order by 1) = {1, ''a'', ''zz'', 2, ''b'', ''zz''}';
execute s using 'zz';
deallocate prepare s;
prepare s from 'select ''eq'' from db_root where list (select nvl (?, ''x''), id from t2 order by 2) = {''zz'', 1, ''zz'', 2}';
execute s using 'zz';
deallocate prepare s;
drop table t2;

evaluate 'Case 14: a comparison of collections whose element is a bound value has a logical result column';
prepare s from 'select {1, nvl (?, ''x'')} = {1, ''zz''} as eq from db_root';
execute s using 'zz';
execute s using 'yy';
deallocate prepare s;

drop table t_str, t_set;

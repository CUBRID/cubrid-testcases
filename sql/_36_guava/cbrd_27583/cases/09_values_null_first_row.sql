/**
 *  This test case verifies CBRD-27583: a VALUES column whose first row is NULL and a later
 *  row has a type is rejected with -494, so a bound value is never dropped.
 *
 *  With a plan per bind type signature a NULL bind has the NULL type.  Before the fix the
 *  first row's NULL typed the VALUES column NULL and the later rows' values were written as
 *  NULL, so (values (?), (?)) bound NULL, 5 answered NULL, NULL.  The same statement failed
 *  with -456 before PR 8022 and with -1383 after it.
 *  Now the column is rejected at compilation as union incompatible (-494).  A literal NULL
 *  first row with a bind row is rejected as well.  A literal NULL first row with literal
 *  rows is left to CBRD-27668 (cbrd_27668), which types the NULL row.
 *
 *  Judged by the error: every EXECUTE of Cases 1 and 2 fails with -494, while the EXECUTE
 *  statements of Case 3 answer rows.  Before the fix Cases 1 and 2 answered NULL rows.
 *
 *  Coverage:
 *    Case 1:  a NULL bind first row and a typed bind row, in SELECT and INSERT ... SELECT
 *    Case 2:  a NULL literal row with bind rows
 *    Case 3:  a typed first row, only NULL binds, a literal typed row, and INSERT VALUES answer rows
 */

drop table if exists t_vals;

create table t_vals (x int);


evaluate 'Case 1: a NULL bind first row and a typed bind row, in SELECT and INSERT ... SELECT';
prepare s_two from 'select x from (values (?), (?)) t(x) order by 1';
execute s_two using null, 5;
execute s_two using null, 'abc';
prepare s_three from 'select x from (values (?), (?), (?)) t(x) order by 1';
execute s_three using null, null, 5;
prepare s_insert from 'insert into t_vals (x) select * from (values (?), (?)) t(x)';
execute s_insert using null, 5;
select x from t_vals order by 1;


evaluate 'Case 2: a NULL literal row with bind rows';
prepare s_mid from 'select x from (values (?), (null), (?)) t(x) order by 1';
execute s_mid using null, 5;
prepare s_lit from 'select x from (values (null), (?)) t(x) order by 1';
execute s_lit using 5;


evaluate 'Case 3: a typed first row, only NULL binds, a literal typed row, and INSERT VALUES answer rows';
execute s_two using 5, null;
execute s_two using null, null;
prepare s_typed from 'select x from (values (?), (5)) t(x) order by 1';
execute s_typed using null;
prepare s_ins_values from 'insert into t_vals (x) values (?), (?)';
execute s_ins_values using null, 5;
select x from t_vals order by 1;

deallocate prepare s_two;
deallocate prepare s_three;
deallocate prepare s_insert;
deallocate prepare s_mid;
deallocate prepare s_lit;
deallocate prepare s_typed;
deallocate prepare s_ins_values;
drop table t_vals;

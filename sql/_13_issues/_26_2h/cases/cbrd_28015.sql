/**
 *  This test case verifies CBRD-28015: ABS of the minimum of SMALLINT, INTEGER and BIGINT returns that negative minimum
 *
 *  ABS keeps the type of its argument, and the absolute value of the minimum of a type is one past its maximum.
 *  Before the fix ABS returned the minimum itself in a select list, in a filter and in a folded constant,
 *  so a filter such as abs(i) > 0 dropped the row of the minimum without an error. With the fix the minimum
 *  raises a data overflow, as a CAST past the range does, and gives NULL with return_null_on_function_errors=yes.
 *
 *  Coverage:
 *    Case 1:  ABS of every value but the minimum keeps its value and its type
 *    Case 2:  ABS of the minimum in a select list fails with a data overflow
 *    Case 3:  a filter with ABS fails at the row of the minimum instead of dropping it
 *    Case 4:  ABS of a constant minimum, folded before the run, fails with a data overflow
 *    Case 5:  an UPDATE that stores ABS of the minimum fails and leaves the rows unchanged
 *    Case 6:  with return_null_on_function_errors=yes ABS of the minimum is NULL and the other values stay
 *    Case 7:  ABS of the minimum of NUMERIC, DOUBLE, FLOAT and of a numeric string is unchanged
 *    Case 8:  a function index and a partition key on ABS reject a row of the minimum and keep the others
 */

drop table if exists t_abs, t_abs_fidx, t_abs_part;
create table t_abs (id int primary key, s smallint, i int, b bigint);
insert into t_abs values (1, -32768, -2147483648, -9223372036854775808);
insert into t_abs values (2, -32767, -2147483647, -9223372036854775807);
insert into t_abs values (3, -1, -1, -1);
insert into t_abs values (4, 0, 0, 0);
insert into t_abs values (5, 32767, 2147483647, 9223372036854775807);
insert into t_abs values (6, null, null, null);

evaluate 'Case 1: ABS of every value but the minimum keeps its value and its type';
select id, abs (s), abs (i), abs (b), typeof (abs (s)), typeof (abs (i)), typeof (abs (b)) from t_abs where id > 1 order by id;

evaluate 'Case 2: ABS of the minimum in a select list fails with a data overflow';
select id, abs (s) from t_abs where id = 1;
select id, abs (i) from t_abs where id = 1;
select id, abs (b) from t_abs where id = 1;

evaluate 'Case 3: a filter with ABS fails at the row of the minimum instead of dropping it';
select id from t_abs where abs (s) > 0 order by id;
select id from t_abs where abs (i) > 0 order by id;
select id from t_abs where abs (b) > 0 order by id;

evaluate 'Case 4: ABS of a constant minimum fails with a data overflow, and of the next value does not';
select abs (cast (-32768 as smallint));
select abs (cast (-2147483648 as int));
select abs (cast (-9223372036854775808 as bigint));
select abs (cast (-32767 as smallint)), abs (cast (-2147483647 as int)), abs (cast (-9223372036854775807 as bigint));

evaluate 'Case 5: an UPDATE that stores ABS of the minimum fails and leaves the rows unchanged';
update t_abs set s = abs (s), i = abs (i), b = abs (b) where id <= 2;
select id, s, i, b from t_abs where id <= 2 order by id;

evaluate 'Case 6: with return_null_on_function_errors=yes ABS of the minimum is NULL and the other values stay';
set system parameters 'return_null_on_function_errors=yes';
select id, abs (s), abs (i), abs (b) from t_abs order by id;
select id from t_abs where abs (i) > 0 order by id;
select abs (cast (-32768 as smallint)), abs (cast (-2147483648 as int)), abs (cast (-9223372036854775808 as bigint));
set system parameters 'return_null_on_function_errors=default';

evaluate 'Case 7: ABS of the minimum of NUMERIC, DOUBLE, FLOAT and of a numeric string is unchanged';
select abs (cast (-99999999999999999999999999999999999999 as numeric (38, 0))), abs (cast (-1.7976931348623157e308 as double)), abs (cast (-3.4e38 as float));
select abs ('-2147483648'), abs ('-9223372036854775808');

evaluate 'Case 8: a function index and a partition key on ABS reject a row of the minimum and keep the others';
create table t_abs_fidx (id int primary key, i int);
create index i_abs_fidx on t_abs_fidx (abs (i));
insert into t_abs_fidx values (1, -2147483647);
insert into t_abs_fidx values (2, -2147483648);
select id, i from t_abs_fidx where abs (i) > 0 using index i_abs_fidx order by id;
create table t_abs_part (id int, i int) partition by range (abs (i)) (partition p_low values less than (100), partition p_high values less than maxvalue);
insert into t_abs_part values (1, -2147483647), (3, -5);
insert into t_abs_part values (2, -2147483648);
select id, i from t_abs_part__p__p_low order by id;
select id, i from t_abs_part__p__p_high order by id;

drop table t_abs, t_abs_fidx, t_abs_part;

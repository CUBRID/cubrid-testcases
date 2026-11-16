/**
 *  This test case verifies CBRD-27645: ADDDATE(date, days) with days equal to the INT minimum
 *  -2147483648 returns the out-of-range error and leaves the server and the client alive.
 *
 *  A day count whose result falls outside the DATE or DATETIME range is an error, and -2147483647
 *  already returns "Function called with missing or invalid arguments." The INT minimum must return
 *  the same error whether the day count comes from a column (evaluated by the server), a literal or a
 *  constant expression (folded while the statement is prepared), a host variable or a subquery.
 *
 *  Each tested query is followed by a query of the same shape with a day count in range, which must
 *  return a row (the session is alive), and by its twin with -2147483647, whose error block must equal
 *  the tested block. No twin exists for a value, so expected values are written literally. The build
 *  before the fix stops the server or the broker at Case 1, so every later block differs there.
 *
 *  Coverage:
 *    Case 1:  DATE column, INT column, as reported
 *    Case 2:  DATE literal, day literal
 *    Case 3:  INT minimum spelled as a cast and as a constant expression
 *    Case 4:  DATETIME column and literal
 *    Case 5:  TIMESTAMP column and literal
 *    Case 6:  date string column and literal
 *    Case 7:  NULL date or NULL day count gives NULL
 *    Case 8:  day count bound as a host variable
 *    Case 9:  day count from a subquery
 *    Case 10: ADDDATE and DATE_ADD with INTERVAL n DAY
 *    Case 11: DATE_SUB and SUBDATE with INTERVAL n DAY, SUBDATE with the INT maximum
 *    Case 12: other day counts keep their results
 *    Case 13: results at the first and the last valid day
 *    Case 14: the session still reads and writes after all errors
 */

drop table if exists ta, t_day, t_src, t_edge;

-- the table of the report: one row, 2024-02-29 and the INT minimum
create table ta (dt date, i int);
insert into ta values (date'2024-02-29', -2147483648);
-- day counts by label; low and high reach 0001-01-01 and 9999-12-30 from 2024-02-29
create table t_day (k varchar(16), n int);
insert into t_day values ('min', -2147483648), ('base', -2147483647), ('max', 2147483647), ('zero', 0), ('none', null), ('one', 1), ('minus', -1), ('low', -738944), ('high', 2913113);
-- the same day 2024-02-29 as DATE, DATETIME, TIMESTAMP and string, and a row of NULLs
create table t_src (k varchar(16), d date, dt datetime, ts timestamp, s varchar(32));
insert into t_src values ('day', date'2024-02-29', datetime'2024-02-29 10:20:30', timestamp'2024-02-29 10:20:30', '2024-02-29'), ('none', null, null, null, null);
-- the first and the last valid days and their neighbours
create table t_edge (k varchar(16), d date, dt datetime);
insert into t_edge values ('first', date'0001-01-02', datetime'0001-01-02 00:00:00'), ('last', date'9999-12-30', datetime'9999-12-30 23:59:59'), ('end', date'9999-12-31', datetime'9999-12-31 23:59:59');


evaluate 'Case 1: DATE column and INT column as reported; error, then a row, then the same error for -2147483647';
select adddate(dt, i) from ta;
select adddate(dt, 1), i from ta;
select adddate(s.d, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'base';


evaluate 'Case 2: DATE literal and day literal; error, then a row, then the same error for -2147483647';
select adddate(date'2024-02-29', -2147483648);
select adddate(date'2024-02-29', 1);
select adddate(date'2024-02-29', -2147483647);


evaluate 'Case 3: INT minimum as a cast and as a constant expression; error, then a row, then the same error';
select adddate(date'2024-02-29', cast(-2147483648 as int));
select adddate(date'2024-02-29', cast(1 as int));
select adddate(date'2024-02-29', cast(-2147483647 as int));
select adddate(date'2024-02-29', -2147483647-1);
select adddate(date'2024-02-29', 2-1);
select adddate(date'2024-02-29', -2147483646-1);


evaluate 'Case 4: DATETIME column and literal; error, then a row, then the same error for -2147483647';
select adddate(s.dt, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'min';
select adddate(s.dt, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'one';
select adddate(s.dt, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'base';
select adddate(datetime'2024-02-29 10:20:30', cast(-2147483648 as int));
select adddate(datetime'2024-02-29 10:20:30', cast(1 as int));
select adddate(datetime'2024-02-29 10:20:30', cast(-2147483647 as int));


evaluate 'Case 5: TIMESTAMP column and literal; error, then a row, then the same error for -2147483647';
select adddate(s.ts, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'min';
select adddate(s.ts, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'one';
select adddate(s.ts, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'base';
select adddate(timestamp'2024-02-29 10:20:30', cast(-2147483648 as int));
select adddate(timestamp'2024-02-29 10:20:30', cast(1 as int));
select adddate(timestamp'2024-02-29 10:20:30', cast(-2147483647 as int));


evaluate 'Case 6: date string column and literal; error, then a row, then the same error for -2147483647';
select adddate(s.s, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'min';
select adddate(s.s, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'one';
select adddate(s.s, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'base';
select adddate('2024-02-29', cast(-2147483648 as int));
select adddate('2024-02-29', cast(1 as int));
select adddate('2024-02-29', cast(-2147483647 as int));


evaluate 'Case 7: NULL date with the INT minimum and NULL day count give NULL';
select adddate(s.d, t.n), adddate(s.dt, t.n), adddate(s.ts, t.n), adddate(s.s, t.n) from t_src s, t_day t where s.k = 'none' and t.k = 'min';
select adddate(null, cast(-2147483648 as int)) as from_cast, adddate(null, -2147483647-1) as from_expr;
select adddate(s.d, t.n), adddate(s.dt, t.n), adddate(s.ts, t.n), adddate(s.s, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'none';


evaluate 'Case 8: day count bound as a host variable; error, then a row, then the same error for -2147483647';
prepare st from 'select adddate(?, ?)';
execute st using date'2024-02-29', -2147483648;
execute st using date'2024-02-29', 1;
execute st using date'2024-02-29', -2147483647;
prepare sq from 'select adddate(d, ?) from t_src where k = ''day''';
execute sq using -2147483648;
execute sq using 1;
execute sq using -2147483647;
deallocate prepare st;
deallocate prepare sq;


evaluate 'Case 9: day count from a subquery; error, then a row, then the same error for -2147483647';
select adddate(date'2024-02-29', (select i from ta));
select adddate(date'2024-02-29', (select n from t_day where k = 'one'));
select adddate(date'2024-02-29', (select n from t_day where k = 'base'));
select adddate(s.d, (select i from ta)) from t_src s where s.k = 'day';
select adddate(s.d, (select n from t_day where k = 'one')) from t_src s where s.k = 'day';
select adddate(s.d, (select n from t_day where k = 'base')) from t_src s where s.k = 'day';


evaluate 'Case 10: ADDDATE and DATE_ADD with INTERVAL n DAY; the INT minimum and -2147483647 give the same error';
select adddate(dt, interval i day) from ta;
select date_add(dt, interval i day) from ta;
select adddate(dt, interval 1 day), date_add(dt, interval 1 day) from ta;
select adddate(s.d, interval t.n day) from t_src s, t_day t where s.k = 'day' and t.k = 'base';
select date_add(s.d, interval t.n day) from t_src s, t_day t where s.k = 'day' and t.k = 'base';
select date_add(date'2024-02-29', interval cast(-2147483648 as int) day);
select date_add(date'2024-02-29', interval cast(-2147483647 as int) day);


evaluate 'Case 11: DATE_SUB and SUBDATE with INTERVAL n DAY, SUBDATE with the INT maximum; out of range, error';
select date_sub(dt, interval i day) from ta;
select subdate(dt, interval i day) from ta;
select date_sub(dt, interval 1 day), subdate(dt, interval 1 day), subdate(dt, 1) from ta;
select date_sub(s.d, interval t.n day) from t_src s, t_day t where s.k = 'day' and t.k = 'base';
select subdate(s.d, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'base';
select subdate(s.d, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'max';


evaluate 'Case 12: other day counts keep their results; the INT maximum is out of range';
select t.k, adddate(s.d, t.n), adddate(s.dt, t.n), adddate(s.s, t.n) from t_src s, t_day t where s.k = 'day' and t.k in ('zero', 'one', 'minus') order by t.n;
select adddate(s.d, t.n) from t_src s, t_day t where s.k = 'day' and t.k = 'max';
select adddate(date'2024-02-29', 2147483647);
select adddate(date'2024-02-29', 0), adddate(date'2024-02-29', -1), adddate(date'2024-02-29', null);


evaluate 'Case 13: results at the first and the last valid day; one day past the last day is an error';
select t.k, adddate(s.d, t.n), adddate(s.dt, t.n) from t_src s, t_day t where s.k = 'day' and t.k in ('low', 'high') order by t.n;
select k, adddate(d, -1), adddate(dt, -1) from t_edge where k = 'first';
select k, adddate(d, 1), adddate(dt, 1) from t_edge where k = 'last';
select adddate(d, 1) from t_edge where k = 'end';
select adddate(dt, 1) from t_edge where k = 'end';


evaluate 'Case 14: the session still reads and writes after all errors';
insert into ta values (date'2024-03-01', 1);
select dt, i, adddate(dt, 1) from ta order by dt;
select count(*) from t_day;

drop table ta, t_day, t_src, t_edge;

/**
 *  This test case verifies CBRD-27645 (spec revision 2): an INTERVAL value equal to the BIGINT
 *  minimum -9223372036854775808 in DATE_ADD, DATE_SUB, ADDDATE and SUBDATE returns the out-of-range
 *  error for every unit and leaves the server, the broker and the session alive, and SUBDATE(date,
 *  days) with the INT minimum returns the same out-of-range error as -2147483647.
 *
 *  Before the fix YEAR, QUARTER and MONTH stop the broker or the server, DATE_SUB returns a wrong
 *  date, and -9223372036854775807 and 9223372036854775807 also return wrong dates.
 *
 *  Each tested query is followed by its twin, the same form (literal, cast, column, host variable,
 *  subquery) with an interval far out of range that is already rejected: the blocks must be equal.
 *
 *  Coverage:
 *    Case 1:  DATE_ADD MONTH with the BIGINT minimum literal, as reported
 *    Case 2:  DATE_SUB DAY with the BIGINT minimum literal, as reported
 *    Case 3:  DATE_ADD and DATE_SUB over every unit with a literal
 *    Case 4:  the BIGINT minimum as a cast, a constant expression and a string
 *    Case 5:  ADDDATE and SUBDATE with INTERVAL
 *    Case 6:  DATE column and BIGINT column over every unit, evaluated by the server
 *    Case 7:  DATETIME, TIMESTAMP and string columns
 *    Case 8:  TIMESTAMP, string, DATETIMETZ and DATETIMELTZ literals, and NULL
 *    Case 9:  host variables and subqueries
 *    Case 10: composite units DAY_HOUR and YEAR_MONTH
 *    Case 11: -9223372036854775807 and 9223372036854775807 are errors too
 *    Case 12: results in range and the sign symmetry of DATE_ADD and DATE_SUB
 *    Case 13: SUBDATE(date, days) with the INT minimum
 *    Case 14: the session still reads and writes after all errors
 */

drop table if exists t_src, t_big, t_tw, t_int;

-- the same day 2024-02-29 as DATE, DATETIME, TIMESTAMP and string, and a row of NULLs
create table t_src (k varchar(16), d date, dt datetime, ts timestamp, s varchar(32));
insert into t_src values ('day', date'2024-02-29', datetime'2024-02-29 10:20:30', timestamp'2024-02-29 10:20:30', '2024-02-29'), ('none', null, null, null, null);
-- BIGINT extremes: the minimum, the minimum plus one and the maximum
create table t_big (k varchar(16), n bigint);
insert into t_big values ('bmin', -9223372036854775807-1), ('bbase', -9223372036854775807), ('bmax', 9223372036854775807);
-- twin values by unit: each moves 2024-02-29 far below 0001-01-01, and its negation far above 9999-12-31
create table t_tw (k varchar(16), n bigint);
insert into t_tw values ('year', -100000), ('quarter', -400000), ('month', -1200000), ('week', -600000), ('day', -40000000), ('hour', -1000000000), ('minute', -60000000000), ('second', -4000000000000), ('millisecond', -4000000000000000);
-- INT minimum and the existing out-of-range baseline for SUBDATE(date, days)
create table t_int (k varchar(16), i int);
insert into t_int values ('imin', -2147483648), ('ibase', -2147483647);


evaluate 'Case 1: DATE_ADD MONTH with the BIGINT minimum literal as reported; error equal to the twin, then a row';
select date_add(date'2024-02-29', interval -9223372036854775808 month);
select date_add(date'2024-02-29', interval -1200000 month);
select date_add(date'2024-02-29', interval 5 month);


evaluate 'Case 2: DATE_SUB DAY with the BIGINT minimum literal as reported; error equal to the twin, then a row';
select date_sub(date'2024-02-29', interval -9223372036854775808 day);
select date_sub(date'2024-02-29', interval -40000000 day);
select date_sub(date'2024-02-29', interval 5 day);


evaluate 'Case 3: DATE_ADD and DATE_SUB over every unit with the BIGINT minimum literal; each error equals its twin';
select date_add(date'2024-02-29', interval -9223372036854775808 year);
select date_add(date'2024-02-29', interval -100000 year);
select date_add(date'2024-02-29', interval -9223372036854775808 quarter);
select date_add(date'2024-02-29', interval -400000 quarter);
select date_add(date'2024-02-29', interval -9223372036854775808 month);
select date_add(date'2024-02-29', interval -1200000 month);
select date_add(date'2024-02-29', interval -9223372036854775808 week);
select date_add(date'2024-02-29', interval -600000 week);
select date_add(date'2024-02-29', interval -9223372036854775808 day);
select date_add(date'2024-02-29', interval -40000000 day);
select date_add(date'2024-02-29', interval -9223372036854775808 hour);
select date_add(date'2024-02-29', interval -1000000000 hour);
select date_add(date'2024-02-29', interval -9223372036854775808 minute);
select date_add(date'2024-02-29', interval -60000000000 minute);
select date_add(date'2024-02-29', interval -9223372036854775808 second);
select date_add(date'2024-02-29', interval -4000000000000 second);
select date_add(date'2024-02-29', interval -9223372036854775808 millisecond);
select date_add(date'2024-02-29', interval -4000000000000000 millisecond);
select date_sub(date'2024-02-29', interval -9223372036854775808 year);
select date_sub(date'2024-02-29', interval -100000 year);
select date_sub(date'2024-02-29', interval -9223372036854775808 quarter);
select date_sub(date'2024-02-29', interval -400000 quarter);
select date_sub(date'2024-02-29', interval -9223372036854775808 month);
select date_sub(date'2024-02-29', interval -1200000 month);
select date_sub(date'2024-02-29', interval -9223372036854775808 week);
select date_sub(date'2024-02-29', interval -600000 week);
select date_sub(date'2024-02-29', interval -9223372036854775808 day);
select date_sub(date'2024-02-29', interval -40000000 day);
select date_sub(date'2024-02-29', interval -9223372036854775808 hour);
select date_sub(date'2024-02-29', interval -1000000000 hour);
select date_sub(date'2024-02-29', interval -9223372036854775808 minute);
select date_sub(date'2024-02-29', interval -60000000000 minute);
select date_sub(date'2024-02-29', interval -9223372036854775808 second);
select date_sub(date'2024-02-29', interval -4000000000000 second);
select date_sub(date'2024-02-29', interval -9223372036854775808 millisecond);
select date_sub(date'2024-02-29', interval -4000000000000000 millisecond);


evaluate 'Case 4: the BIGINT minimum as a cast, a constant expression and a string; each error equals its twin';
select date_add(date'2024-02-29', interval cast(-9223372036854775808 as bigint) month);
select date_add(date'2024-02-29', interval cast(-1200000 as bigint) month);
select date_sub(date'2024-02-29', interval cast(-9223372036854775808 as bigint) day);
select date_sub(date'2024-02-29', interval cast(-40000000 as bigint) day);
select date_add(date'2024-02-29', interval -9223372036854775807-1 year);
select date_add(date'2024-02-29', interval -99999-1 year);
select date_sub(date'2024-02-29', interval -9223372036854775807-1 quarter);
select date_sub(date'2024-02-29', interval -399999-1 quarter);
select date_add(date'2024-02-29', interval '-9223372036854775808' month);
select date_add(date'2024-02-29', interval '-1200000' month);
select date_sub(date'2024-02-29', interval '-9223372036854775808' day);
select date_sub(date'2024-02-29', interval '-40000000' day);


evaluate 'Case 5: ADDDATE and SUBDATE with INTERVAL and the BIGINT minimum; each error equals its twin, then a row';
select adddate(date'2024-02-29', interval -9223372036854775808 year);
select adddate(date'2024-02-29', interval -100000 year);
select adddate(date'2024-02-29', interval -9223372036854775808 month);
select adddate(date'2024-02-29', interval -1200000 month);
select adddate(date'2024-02-29', interval -9223372036854775808 day);
select adddate(date'2024-02-29', interval -40000000 day);
select subdate(date'2024-02-29', interval -9223372036854775808 quarter);
select subdate(date'2024-02-29', interval -400000 quarter);
select subdate(date'2024-02-29', interval -9223372036854775808 month);
select subdate(date'2024-02-29', interval -1200000 month);
select subdate(date'2024-02-29', interval -9223372036854775808 day);
select subdate(date'2024-02-29', interval -40000000 day);
select subdate(date'2024-02-29', interval -9223372036854775808 second);
select subdate(date'2024-02-29', interval -4000000000000 second);
select adddate(date'2024-02-29', interval 5 month), subdate(date'2024-02-29', interval 5 day);


evaluate 'Case 6: DATE column and BIGINT column over every unit, evaluated by the server; each error equals its twin';
select date_add(s.d, interval t.n year) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_add(s.d, interval t.n year) from t_src s, t_tw t where s.k = 'day' and t.k = 'year';
select date_add(s.d, interval t.n quarter) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_add(s.d, interval t.n quarter) from t_src s, t_tw t where s.k = 'day' and t.k = 'quarter';
select date_add(s.d, interval t.n month) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_add(s.d, interval t.n month) from t_src s, t_tw t where s.k = 'day' and t.k = 'month';
select date_add(s.d, interval t.n week) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_add(s.d, interval t.n week) from t_src s, t_tw t where s.k = 'day' and t.k = 'week';
select date_add(s.d, interval t.n day) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_add(s.d, interval t.n day) from t_src s, t_tw t where s.k = 'day' and t.k = 'day';
select date_add(s.d, interval t.n hour) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_add(s.d, interval t.n hour) from t_src s, t_tw t where s.k = 'day' and t.k = 'hour';
select date_add(s.d, interval t.n minute) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_add(s.d, interval t.n minute) from t_src s, t_tw t where s.k = 'day' and t.k = 'minute';
select date_add(s.d, interval t.n second) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_add(s.d, interval t.n second) from t_src s, t_tw t where s.k = 'day' and t.k = 'second';
select date_add(s.d, interval t.n millisecond) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_add(s.d, interval t.n millisecond) from t_src s, t_tw t where s.k = 'day' and t.k = 'millisecond';
select date_sub(s.d, interval t.n year) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.d, interval t.n year) from t_src s, t_tw t where s.k = 'day' and t.k = 'year';
select date_sub(s.d, interval t.n quarter) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.d, interval t.n quarter) from t_src s, t_tw t where s.k = 'day' and t.k = 'quarter';
select date_sub(s.d, interval t.n month) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.d, interval t.n month) from t_src s, t_tw t where s.k = 'day' and t.k = 'month';
select date_sub(s.d, interval t.n week) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.d, interval t.n week) from t_src s, t_tw t where s.k = 'day' and t.k = 'week';
select date_sub(s.d, interval t.n day) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.d, interval t.n day) from t_src s, t_tw t where s.k = 'day' and t.k = 'day';
select date_sub(s.d, interval t.n hour) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.d, interval t.n hour) from t_src s, t_tw t where s.k = 'day' and t.k = 'hour';
select date_sub(s.d, interval t.n minute) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.d, interval t.n minute) from t_src s, t_tw t where s.k = 'day' and t.k = 'minute';
select date_sub(s.d, interval t.n second) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.d, interval t.n second) from t_src s, t_tw t where s.k = 'day' and t.k = 'second';
select date_sub(s.d, interval t.n millisecond) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.d, interval t.n millisecond) from t_src s, t_tw t where s.k = 'day' and t.k = 'millisecond';


evaluate 'Case 7: DATETIME, TIMESTAMP and string columns with the BIGINT minimum column; each error equals its twin';
select date_add(s.dt, interval t.n month) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_add(s.dt, interval t.n month) from t_src s, t_tw t where s.k = 'day' and t.k = 'month';
select date_sub(s.dt, interval t.n day) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.dt, interval t.n day) from t_src s, t_tw t where s.k = 'day' and t.k = 'day';
select date_sub(s.dt, interval t.n hour) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.dt, interval t.n hour) from t_src s, t_tw t where s.k = 'day' and t.k = 'hour';
select adddate(s.dt, interval t.n year) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select adddate(s.dt, interval t.n year) from t_src s, t_tw t where s.k = 'day' and t.k = 'year';
select subdate(s.dt, interval t.n second) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select subdate(s.dt, interval t.n second) from t_src s, t_tw t where s.k = 'day' and t.k = 'second';
select date_add(s.ts, interval t.n month) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_add(s.ts, interval t.n month) from t_src s, t_tw t where s.k = 'day' and t.k = 'month';
select date_sub(s.ts, interval t.n day) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.ts, interval t.n day) from t_src s, t_tw t where s.k = 'day' and t.k = 'day';
select date_add(s.s, interval t.n quarter) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_add(s.s, interval t.n quarter) from t_src s, t_tw t where s.k = 'day' and t.k = 'quarter';
select date_sub(s.s, interval t.n week) from t_src s, t_big t where s.k = 'day' and t.k = 'bmin';
select date_sub(s.s, interval t.n week) from t_src s, t_tw t where s.k = 'day' and t.k = 'week';


evaluate 'Case 8: TIMESTAMP, string, DATETIMETZ and DATETIMELTZ literals; each error equals its twin; NULL gives NULL';
select date_add(timestamp'2024-02-29 10:20:30', interval -9223372036854775808 month);
select date_add(timestamp'2024-02-29 10:20:30', interval -1200000 month);
select date_sub(timestamp'2024-02-29 10:20:30', interval -9223372036854775808 day);
select date_sub(timestamp'2024-02-29 10:20:30', interval -40000000 day);
select date_add('2024-02-29', interval -9223372036854775808 month);
select date_add('2024-02-29', interval -1200000 month);
select date_sub('2024-02-29', interval -9223372036854775808 day);
select date_sub('2024-02-29', interval -40000000 day);
select date_add(datetimetz'2024-02-29 10:20:30 +09:00', interval -9223372036854775808 month);
select date_add(datetimetz'2024-02-29 10:20:30 +09:00', interval -1200000 month);
select date_sub(datetimetz'2024-02-29 10:20:30 +09:00', interval -9223372036854775808 day);
select date_sub(datetimetz'2024-02-29 10:20:30 +09:00', interval -40000000 day);
select date_add(datetimeltz'2024-02-29 10:20:30', interval -9223372036854775808 month);
select date_add(datetimeltz'2024-02-29 10:20:30', interval -1200000 month);
select date_sub(datetimeltz'2024-02-29 10:20:30', interval -9223372036854775808 day);
select date_sub(datetimeltz'2024-02-29 10:20:30', interval -40000000 day);
select date_add(null, interval -9223372036854775808 month), date_sub(null, interval -9223372036854775808 day);
select date_add(d, interval -9223372036854775808 month), date_sub(dt, interval -9223372036854775808 day) from t_src where k = 'none';
select date_add(date'2024-02-29', interval null month), date_sub(date'2024-02-29', interval null day);


evaluate 'Case 9: host variables and subqueries with the BIGINT minimum; each error equals its twin, then a row';
prepare st from 'select date_add(?, interval ? month)';
execute st using date'2024-02-29', -9223372036854775808;
execute st using date'2024-02-29', -1200000;
execute st using date'2024-02-29', 5;
prepare su from 'select date_sub(?, interval ? day)';
execute su using date'2024-02-29', -9223372036854775808;
execute su using date'2024-02-29', -40000000;
execute su using date'2024-02-29', 5;
prepare sc from 'select date_add(d, interval ? year) from t_src where k = ''day''';
execute sc using -9223372036854775808;
execute sc using -100000;
execute sc using 5;
deallocate prepare st;
deallocate prepare su;
deallocate prepare sc;
select date_add(date'2024-02-29', interval (select n from t_big where k = 'bmin') month);
select date_add(date'2024-02-29', interval (select n from t_tw where k = 'month') month);
select date_sub(s.d, interval (select n from t_big where k = 'bmin') day) from t_src s where s.k = 'day';
select date_sub(s.d, interval (select n from t_tw where k = 'day') day) from t_src s where s.k = 'day';


evaluate 'Case 10: composite units DAY_HOUR and YEAR_MONTH with the BIGINT minimum; each error equals its twin';
select date_add(datetime'2024-02-29 10:20:30', interval '-9223372036854775808 0' day_hour);
select date_add(datetime'2024-02-29 10:20:30', interval '-40000000 0' day_hour);
select date_add(datetime'2024-02-29 10:20:30', interval '-9223372036854775808-0' year_month);
select date_add(datetime'2024-02-29 10:20:30', interval '-100000-0' year_month);
select date_sub(datetime'2024-02-29 10:20:30', interval '-9223372036854775808 0' day_hour);
select date_sub(datetime'2024-02-29 10:20:30', interval '-40000000 0' day_hour);
select date_sub(datetime'2024-02-29 10:20:30', interval '-9223372036854775808-0' year_month);
select date_sub(datetime'2024-02-29 10:20:30', interval '-100000-0' year_month);
select date_add(datetime'2024-02-29 10:20:30', interval '-1 2' day_hour), date_sub(datetime'2024-02-29 10:20:30', interval '-1 2' day_hour);
select date_add(datetime'2024-02-29 10:20:30', interval '-1-2' year_month), date_sub(datetime'2024-02-29 10:20:30', interval '-1-2' year_month);


evaluate 'Case 11: the values -9223372036854775807 and 9223372036854775807 are out of range; each error equals its twin';
select date_add(date'2024-02-29', interval 9223372036854775807 year);
select date_add(date'2024-02-29', interval 100000 year);
select date_sub(date'2024-02-29', interval -9223372036854775807 year);
select date_sub(date'2024-02-29', interval -100000 year);
select date_add(date'2024-02-29', interval -9223372036854775807 year);
select date_add(date'2024-02-29', interval -100000 year);
select date_add(date'2024-02-29', interval 9223372036854775807 month);
select date_add(date'2024-02-29', interval 1200000 month);
select date_sub(date'2024-02-29', interval -9223372036854775807 month);
select date_sub(date'2024-02-29', interval -1200000 month);
select date_add(date'2024-02-29', interval -9223372036854775807 month);
select date_add(date'2024-02-29', interval -1200000 month);
select date_add(date'2024-02-29', interval 9223372036854775807 week);
select date_add(date'2024-02-29', interval 600000 week);
select date_sub(date'2024-02-29', interval -9223372036854775807 week);
select date_sub(date'2024-02-29', interval -600000 week);
select date_add(date'2024-02-29', interval -9223372036854775807 week);
select date_add(date'2024-02-29', interval -600000 week);
select date_add(date'2024-02-29', interval 9223372036854775807 day);
select date_add(date'2024-02-29', interval 40000000 day);
select date_sub(date'2024-02-29', interval -9223372036854775807 day);
select date_sub(date'2024-02-29', interval -40000000 day);
select date_add(date'2024-02-29', interval -9223372036854775807 day);
select date_add(date'2024-02-29', interval -40000000 day);
select date_add(date'2024-02-29', interval 9223372036854775807 hour);
select date_add(date'2024-02-29', interval 1000000000 hour);
select date_sub(date'2024-02-29', interval -9223372036854775807 hour);
select date_sub(date'2024-02-29', interval -1000000000 hour);
select date_add(date'2024-02-29', interval -9223372036854775807 hour);
select date_add(date'2024-02-29', interval -1000000000 hour);
select date_add(date'2024-02-29', interval 9223372036854775807 second);
select date_add(date'2024-02-29', interval 4000000000000 second);
select date_sub(date'2024-02-29', interval -9223372036854775807 second);
select date_sub(date'2024-02-29', interval -4000000000000 second);
select date_add(date'2024-02-29', interval -9223372036854775807 second);
select date_add(date'2024-02-29', interval -4000000000000 second);
select date_add(s.d, interval t.n day) from t_src s, t_big t where s.k = 'day' and t.k = 'bmax';
select date_add(s.d, interval -t.n day) from t_src s, t_tw t where s.k = 'day' and t.k = 'day';
select date_add(s.d, interval t.n month) from t_src s, t_big t where s.k = 'day' and t.k = 'bmax';
select date_add(s.d, interval -t.n month) from t_src s, t_tw t where s.k = 'day' and t.k = 'month';
select date_sub(s.d, interval t.n day) from t_src s, t_big t where s.k = 'day' and t.k = 'bbase';
select date_sub(s.d, interval t.n day) from t_src s, t_tw t where s.k = 'day' and t.k = 'day';
select date_sub(s.d, interval t.n week) from t_src s, t_big t where s.k = 'day' and t.k = 'bbase';
select date_sub(s.d, interval t.n week) from t_src s, t_tw t where s.k = 'day' and t.k = 'week';
select date_add(s.d, interval t.n year) from t_src s, t_big t where s.k = 'day' and t.k = 'bbase';
select date_add(s.d, interval t.n year) from t_src s, t_tw t where s.k = 'day' and t.k = 'year';


evaluate 'Case 12: results in range are kept and DATE_SUB with -N equals DATE_ADD with N for every unit';
select date_add(dt, interval 5 year), date_sub(dt, interval -5 year), date_add(dt, interval -5 year), date_sub(dt, interval 5 year), date_add(d, interval 5 year) from t_src where k = 'day';
select date_add(dt, interval 5 quarter), date_sub(dt, interval -5 quarter), date_add(dt, interval -5 quarter), date_sub(dt, interval 5 quarter), date_add(d, interval 5 quarter) from t_src where k = 'day';
select date_add(dt, interval 5 month), date_sub(dt, interval -5 month), date_add(dt, interval -5 month), date_sub(dt, interval 5 month), date_add(d, interval 5 month) from t_src where k = 'day';
select date_add(dt, interval 5 week), date_sub(dt, interval -5 week), date_add(dt, interval -5 week), date_sub(dt, interval 5 week), date_add(d, interval 5 week) from t_src where k = 'day';
select date_add(dt, interval 5 day), date_sub(dt, interval -5 day), date_add(dt, interval -5 day), date_sub(dt, interval 5 day), date_add(d, interval 5 day) from t_src where k = 'day';
select date_add(dt, interval 5 hour), date_sub(dt, interval -5 hour), date_add(dt, interval -5 hour), date_sub(dt, interval 5 hour), date_add(d, interval 5 hour) from t_src where k = 'day';
select date_add(dt, interval 5 minute), date_sub(dt, interval -5 minute), date_add(dt, interval -5 minute), date_sub(dt, interval 5 minute), date_add(d, interval 5 minute) from t_src where k = 'day';
select date_add(dt, interval 5 second), date_sub(dt, interval -5 second), date_add(dt, interval -5 second), date_sub(dt, interval 5 second), date_add(d, interval 5 second) from t_src where k = 'day';
select date_add(dt, interval 5 millisecond), date_sub(dt, interval -5 millisecond), date_add(dt, interval -5 millisecond), date_sub(dt, interval 5 millisecond), date_add(d, interval 5 millisecond) from t_src where k = 'day';
select date_add(date'9999-11-30', interval 1 month), date_add(date'9998-12-31', interval 1 year), date_add(date'9999-12-24', interval 1 week), date_add(date'9999-12-30', interval 1 day);
select date_add(datetime'9999-12-31 22:59:59', interval 1 hour), date_add(datetime'9999-12-31 23:59:58', interval 1 second), date_add(datetime'9999-12-31 23:59:59.998', interval 1 millisecond);
select date_sub(date'0001-02-01', interval 1 month), date_sub(date'0002-01-01', interval 1 year), date_sub(date'0001-01-08', interval 1 week), date_sub(date'0001-01-02', interval 1 day);
select date_sub(datetime'0001-01-01 01:00:00', interval 1 hour), date_sub(datetime'0001-01-01 00:00:01', interval 1 second), date_sub(datetime'0001-01-01 00:00:00.001', interval 1 millisecond);
select date_add(date'2024-02-29', interval 7975 year), date_add(date'2024-02-29', interval -2023 year), date_add(date'2024-02-29', interval -24277 month), date_sub(date'2024-02-29', interval -95710 month);
select date_add(date'9999-12-01', interval 1 month);
select date_add(date'9999-12-31', interval 1 day);
select date_add(datetime'9999-12-31 23:59:59', interval 1 second);
select date_sub(date'9999-12-31', interval -1 day);


evaluate 'Case 13: SUBDATE with the INT minimum day count gives the error of -2147483647';
select subdate(s.d, t.i) from t_src s, t_int t where s.k = 'day' and t.k = 'imin';
select subdate(s.d, t.i) from t_src s, t_int t where s.k = 'day' and t.k = 'ibase';
select subdate(s.dt, t.i) from t_src s, t_int t where s.k = 'day' and t.k = 'imin';
select subdate(s.dt, t.i) from t_src s, t_int t where s.k = 'day' and t.k = 'ibase';
select subdate(s.s, t.i) from t_src s, t_int t where s.k = 'day' and t.k = 'imin';
select subdate(s.s, t.i) from t_src s, t_int t where s.k = 'day' and t.k = 'ibase';
select subdate(date'2024-02-29', -2147483648);
select subdate(date'2024-02-29', -2147483647);
select subdate(date'2024-02-29', cast(-2147483648 as int));
select subdate(date'2024-02-29', cast(-2147483647 as int));
select subdate(datetime'2024-02-29 10:20:30', cast(-2147483648 as int));
select subdate(datetime'2024-02-29 10:20:30', cast(-2147483647 as int));
prepare sd from 'select subdate(?, ?)';
execute sd using date'2024-02-29', -2147483648;
execute sd using date'2024-02-29', -2147483647;
execute sd using date'2024-02-29', 1;
deallocate prepare sd;
select subdate(d, 1), subdate(d, -1), subdate(d, 0), subdate(d, 738944) from t_src where k = 'day';


evaluate 'Case 14: the session still reads and writes after all errors';
insert into t_big values ('five', 5);
select k, n, date_add(date'2024-02-29', interval n day) from t_big where n between 0 and 10 order by k;
select count(*) from t_big;

drop table t_src, t_big, t_tw, t_int;

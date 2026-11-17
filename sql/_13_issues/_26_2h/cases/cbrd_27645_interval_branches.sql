/**
 *  This test case verifies CBRD-27645 (spec revision 2) on the branches of DATE_ADD and DATE_SUB
 *  with INTERVAL that cbrd_27645_interval.sql does not reach: the bound the amount is clamped to,
 *  the WEEK and QUARTER products, every composite unit, return_null_on_function_errors, more first
 *  argument types, and the index and DML contexts evaluated by the server.
 *
 *  The fix clamps an integer amount to the milliseconds of 10000 years before the negation and the
 *  products, and each number of a composite string to the same bound, so an amount beyond it gives
 *  the out-of-range error. Before the fix such amounts overflowed: the server or the broker stopped,
 *  or a wrong date came back.
 *
 *  Each tested statement is followed by its twin, the same form with an amount far out of range
 *  that is not clamped, and the blocks must be equal. Case 1 and Case 3 hold on the build before
 *  the fix too: they show that the clamp keeps the error at its bound and every amount in range.
 *
 *  Coverage:
 *    Case 1:  MILLISECOND amount one above the clamp bound gives the error of the bound
 *    Case 2:  WEEK and QUARTER amounts whose product with 7 or 3 leaves BIGINT
 *    Case 3:  the largest amount in range of every unit moves 0001-01-01 and 9999-12-31
 *    Case 4:  every composite unit with a number above the BIGINT maximum, or a BIGINT end as a string
 *    Case 5:  return_null_on_function_errors=yes gives NULL for the clamped amounts
 *    Case 6:  TIMESTAMPTZ, TIMESTAMPLTZ, CHAR and datetime string first arguments
 *    Case 7:  function index, filter index, UPDATE, INSERT and WHERE with the BIGINT minimum
 */

drop table if exists t_src, t_amt, t_span, t_tz, t_fix, t_fiy, t_fiz;

-- the day 2024-02-29 as DATE and DATETIME, and both ends of the DATETIME range
create table t_src (k varchar(16), d date, dt datetime, lo datetime, hi datetime);
insert into t_src values ('day', date'2024-02-29', datetime'2024-02-29 10:20:30', datetime'0001-01-01 00:00:00', datetime'9999-12-31 23:59:59.999');
-- amounts: BIGINT ends, the clamp bound 316224000000000 and one above it, the WEEK and QUARTER product limits, twins
create table t_amt (k varchar(16), n bigint);
insert into t_amt values ('bmin', -9223372036854775807-1), ('bmax', 9223372036854775807), ('cap', 316224000000000), ('over', 316224000000001), ('ncap', -316224000000000), ('nover', -316224000000001);
insert into t_amt values ('wover', 1317624576693539402), ('nwover', -1317624576693539402), ('qover', 3074457345618258603), ('nqover', -3074457345618258603);
insert into t_amt values ('week', 600000), ('nweek', -600000), ('quarter', 400000), ('nquarter', -400000), ('month', -1200000), ('day', -40000000), ('far', -300000000000000), ('pfar', 300000000000000), ('five', 5);
-- per unit: the largest amount in range down from the top and up from the bottom of the range
create table t_span (k varchar(16), hi datetime, lo datetime, back bigint, fwd bigint);
insert into t_span values ('year', datetime'9999-12-31 00:00:00', datetime'0001-01-01 00:00:00', 9998, 9998), ('quarter', datetime'9999-12-31 00:00:00', datetime'0001-01-01 00:00:00', 39995, 39995), ('month', datetime'9999-12-31 00:00:00', datetime'0001-01-31 00:00:00', 119987, 119987);
insert into t_span values ('week', datetime'9999-12-31 00:00:00', datetime'0001-01-01 00:00:00', 521722, 521722), ('day', datetime'9999-12-31 00:00:00', datetime'0001-01-01 00:00:00', 3652058, 3652057), ('hour', datetime'9999-12-31 23:00:00', datetime'0001-01-01 00:00:00', 87649415, 87649391);
insert into t_span values ('minute', datetime'9999-12-31 23:59:00', datetime'0001-01-01 00:00:00', 5258964959, 5258963519), ('second', datetime'9999-12-31 23:59:59', datetime'0001-01-01 00:00:00', 315537897599, 315537811199), ('millisecond', datetime'9999-12-31 23:59:59.999', datetime'0001-01-01 00:00:00', 315537897599999, 315537811199999);
-- the same instant as TIMESTAMPTZ and TIMESTAMPLTZ with an explicit offset, a CHAR date and datetime strings
create table t_tz (k varchar(16), tstz timestamptz, tsltz timestampltz, c char(10), st varchar(32), sz varchar(40));
insert into t_tz values ('day', timestamptz'2024-02-29 10:20:30 +09:00', timestamptz'2024-02-29 10:20:30 +09:00', '2024-02-29', '2024-02-29 10:20:30', '2024-02-29 10:20:30 +09:00');


evaluate 'Case 1: MILLISECOND amount one above the clamp bound; error = the amount at the bound';
select date_add(datetime'0001-01-01 00:00:00', interval 316224000000001 millisecond);
select date_add(datetime'0001-01-01 00:00:00', interval 316224000000000 millisecond);
select date_sub(datetime'9999-12-31 23:59:59.999', interval 316224000000001 millisecond);
select date_sub(datetime'9999-12-31 23:59:59.999', interval 316224000000000 millisecond);
select date_add(datetime'9999-12-31 23:59:59.999', interval -316224000000001 millisecond);
select date_add(datetime'9999-12-31 23:59:59.999', interval -316224000000000 millisecond);
select date_sub(datetime'0001-01-01 00:00:00', interval -316224000000001 millisecond);
select date_sub(datetime'0001-01-01 00:00:00', interval -316224000000000 millisecond);
select date_add(s.lo, interval t.n millisecond) from t_src s, t_amt t where t.k = 'over';
select date_add(s.lo, interval t.n millisecond) from t_src s, t_amt t where t.k = 'cap';
select date_sub(s.hi, interval t.n millisecond) from t_src s, t_amt t where t.k = 'over';
select date_sub(s.hi, interval t.n millisecond) from t_src s, t_amt t where t.k = 'cap';
select date_add(s.hi, interval t.n millisecond) from t_src s, t_amt t where t.k = 'nover';
select date_add(s.hi, interval t.n millisecond) from t_src s, t_amt t where t.k = 'ncap';
select date_sub(s.lo, interval t.n millisecond) from t_src s, t_amt t where t.k = 'nover';
select date_sub(s.lo, interval t.n millisecond) from t_src s, t_amt t where t.k = 'ncap';


evaluate 'Case 2: WEEK and QUARTER amounts whose product with 7 or 3 leaves BIGINT; error = twin';
select date_add(date'2024-02-29', interval 1317624576693539402 week);
select date_add(date'2024-02-29', interval 1317624576693539401 week);
select date_add(date'2024-02-29', interval 600000 week);
select date_sub(date'2024-02-29', interval -1317624576693539402 week);
select date_sub(date'2024-02-29', interval -600000 week);
select date_add(date'2024-02-29', interval -1317624576693539402 week);
select date_add(date'2024-02-29', interval -600000 week);
select date_add(date'2024-02-29', interval 3074457345618258603 quarter);
select date_add(date'2024-02-29', interval 3074457345618258602 quarter);
select date_add(date'2024-02-29', interval 400000 quarter);
select date_sub(date'2024-02-29', interval -3074457345618258603 quarter);
select date_sub(date'2024-02-29', interval -400000 quarter);
select date_add(date'2024-02-29', interval -3074457345618258603 quarter);
select date_add(date'2024-02-29', interval -400000 quarter);
select date_add(s.d, interval t.n week) from t_src s, t_amt t where t.k = 'wover';
select date_add(s.d, interval t.n week) from t_src s, t_amt t where t.k = 'week';
select date_sub(s.d, interval t.n week) from t_src s, t_amt t where t.k = 'nwover';
select date_sub(s.d, interval t.n week) from t_src s, t_amt t where t.k = 'nweek';
select date_add(s.d, interval t.n quarter) from t_src s, t_amt t where t.k = 'qover';
select date_add(s.d, interval t.n quarter) from t_src s, t_amt t where t.k = 'quarter';
select date_sub(s.d, interval t.n quarter) from t_src s, t_amt t where t.k = 'nqover';
select date_sub(s.d, interval t.n quarter) from t_src s, t_amt t where t.k = 'nquarter';


evaluate 'Case 3: the largest amount in range of every unit; DATE_SUB with N = DATE_ADD with -N';
select k, date_sub(hi, interval back year), date_add(hi, interval -back year), date_add(lo, interval fwd year), date_sub(lo, interval -fwd year) from t_span where k = 'year';
select k, date_sub(hi, interval back quarter), date_add(hi, interval -back quarter), date_add(lo, interval fwd quarter), date_sub(lo, interval -fwd quarter) from t_span where k = 'quarter';
select k, date_sub(hi, interval back month), date_add(hi, interval -back month), date_add(lo, interval fwd month), date_sub(lo, interval -fwd month) from t_span where k = 'month';
select k, date_sub(hi, interval back week), date_add(hi, interval -back week), date_add(lo, interval fwd week), date_sub(lo, interval -fwd week) from t_span where k = 'week';
select k, date_sub(hi, interval back day), date_add(hi, interval -back day), date_add(lo, interval fwd day), date_sub(lo, interval -fwd day) from t_span where k = 'day';
select k, date_sub(hi, interval back hour), date_add(hi, interval -back hour), date_add(lo, interval fwd hour), date_sub(lo, interval -fwd hour) from t_span where k = 'hour';
select k, date_sub(hi, interval back minute), date_add(hi, interval -back minute), date_add(lo, interval fwd minute), date_sub(lo, interval -fwd minute) from t_span where k = 'minute';
select k, date_sub(hi, interval back second), date_add(hi, interval -back second), date_add(lo, interval fwd second), date_sub(lo, interval -fwd second) from t_span where k = 'second';
select k, date_sub(hi, interval back millisecond), date_add(hi, interval -back millisecond), date_add(lo, interval fwd millisecond), date_sub(lo, interval -fwd millisecond) from t_span where k = 'millisecond';
select date_sub(datetime'9999-12-31 23:59:59.999', interval 315537897599999 millisecond), date_add(datetime'0001-01-01 00:00:00', interval 315537811199999 millisecond);


evaluate 'Case 4: every composite unit with a number above the BIGINT maximum in a first, middle or last position, and a BIGINT end cast to the string; error = twin';
select date_sub(datetime'2024-02-29 10:20:30', interval '-99999999999999999999.0' second_millisecond);
select date_sub(datetime'2024-02-29 10:20:30', interval '-4000000000000.0' second_millisecond);
select date_add(datetime'2024-02-29 10:20:30', interval '0.99999999999999999999' second_millisecond);
select date_add(datetime'2024-02-29 10:20:30', interval '0.300000000000000' second_millisecond);
select date_sub(datetime'2024-02-29 10:20:30', interval '-99999999999999999999:0.0' minute_millisecond);
select date_sub(datetime'2024-02-29 10:20:30', interval '-60000000000:0.0' minute_millisecond);
select date_add(datetime'2024-02-29 10:20:30', interval '0:0.99999999999999999999' minute_millisecond);
select date_add(datetime'2024-02-29 10:20:30', interval '0:0.300000000000000' minute_millisecond);
select date_sub(datetime'2024-02-29 10:20:30', interval '-99999999999999999999:0:0.0' hour_millisecond);
select date_sub(datetime'2024-02-29 10:20:30', interval '-1000000000:0:0.0' hour_millisecond);
select date_add(datetime'2024-02-29 10:20:30', interval '0:0:0.99999999999999999999' hour_millisecond);
select date_add(datetime'2024-02-29 10:20:30', interval '0:0:0.300000000000000' hour_millisecond);
select date_sub(datetime'2024-02-29 10:20:30', interval '-99999999999999999999 0:0:0.0' day_millisecond);
select date_sub(datetime'2024-02-29 10:20:30', interval '-40000000 0:0:0.0' day_millisecond);
select date_add(datetime'2024-02-29 10:20:30', interval '0 0:0:0.99999999999999999999' day_millisecond);
select date_add(datetime'2024-02-29 10:20:30', interval '0 0:0:0.300000000000000' day_millisecond);
select date_sub(datetime'2024-02-29 10:20:30', interval '-99999999999999999999:0' minute_second);
select date_sub(datetime'2024-02-29 10:20:30', interval '-60000000000:0' minute_second);
select date_add(datetime'2024-02-29 10:20:30', interval '0:99999999999999999999' minute_second);
select date_add(datetime'2024-02-29 10:20:30', interval '0:4000000000000' minute_second);
select date_sub(datetime'2024-02-29 10:20:30', interval '-99999999999999999999:0:0' hour_second);
select date_sub(datetime'2024-02-29 10:20:30', interval '-1000000000:0:0' hour_second);
select date_add(datetime'2024-02-29 10:20:30', interval '0:0:99999999999999999999' hour_second);
select date_add(datetime'2024-02-29 10:20:30', interval '0:0:4000000000000' hour_second);
select date_sub(datetime'2024-02-29 10:20:30', interval '-99999999999999999999 0:0:0' day_second);
select date_sub(datetime'2024-02-29 10:20:30', interval '-40000000 0:0:0' day_second);
select date_add(datetime'2024-02-29 10:20:30', interval '0 0:0:99999999999999999999' day_second);
select date_add(datetime'2024-02-29 10:20:30', interval '0 0:0:4000000000000' day_second);
select date_sub(datetime'2024-02-29 10:20:30', interval '-99999999999999999999:0' hour_minute);
select date_sub(datetime'2024-02-29 10:20:30', interval '-1000000000:0' hour_minute);
select date_add(datetime'2024-02-29 10:20:30', interval '0:99999999999999999999' hour_minute);
select date_add(datetime'2024-02-29 10:20:30', interval '0:60000000000' hour_minute);
select date_sub(datetime'2024-02-29 10:20:30', interval '-99999999999999999999 0:0' day_minute);
select date_sub(datetime'2024-02-29 10:20:30', interval '-40000000 0:0' day_minute);
select date_add(datetime'2024-02-29 10:20:30', interval '0 0:99999999999999999999' day_minute);
select date_add(datetime'2024-02-29 10:20:30', interval '0 0:60000000000' day_minute);
select date_sub(datetime'2024-02-29 10:20:30', interval '-99999999999999999999 0' day_hour);
select date_sub(datetime'2024-02-29 10:20:30', interval '-40000000 0' day_hour);
select date_add(datetime'2024-02-29 10:20:30', interval '0 99999999999999999999' day_hour);
select date_add(datetime'2024-02-29 10:20:30', interval '0 1000000000' day_hour);
select date_sub(datetime'2024-02-29 10:20:30', interval '-99999999999999999999-0' year_month);
select date_sub(datetime'2024-02-29 10:20:30', interval '-100000-0' year_month);
select date_add(datetime'2024-02-29 10:20:30', interval '0-99999999999999999999' year_month);
select date_add(datetime'2024-02-29 10:20:30', interval '0-1200000' year_month);
select date_add(datetime'2024-02-29 10:20:30', interval '0 99999999999999999999:0:0.0' day_millisecond);
select date_add(datetime'2024-02-29 10:20:30', interval '0 1000000000:0:0.0' day_millisecond);
select date_add(datetime'2024-02-29 10:20:30', interval '0 0:0:99999999999999999999.0' day_millisecond);
select date_add(datetime'2024-02-29 10:20:30', interval '0 0:0:4000000000000.0' day_millisecond);
select date_sub(s.dt, interval t.n day_hour) from t_src s, t_amt t where t.k = 'bmin';
select date_sub(s.dt, interval t.n day_hour) from t_src s, t_amt t where t.k = 'far';
select date_add(s.dt, interval t.n year_month) from t_src s, t_amt t where t.k = 'bmax';
select date_add(s.dt, interval t.n year_month) from t_src s, t_amt t where t.k = 'pfar';
select date_sub(datetime'2024-02-29 10:20:30', interval -9223372036854775808 day_hour);
select date_sub(datetime'2024-02-29 10:20:30', interval -300000000000000 day_hour);
select date_add(datetime'2024-02-29 10:20:30', interval '1.5' second_millisecond), date_add(datetime'2024-02-29 10:20:30', interval '1.05' second_millisecond), date_add(datetime'2024-02-29 10:20:30', interval '1.005' second_millisecond), date_sub(datetime'2024-02-29 10:20:30', interval '-1 2:3:4.5' day_millisecond);


evaluate 'Case 5: return_null_on_function_errors=yes gives NULL for the clamped amounts as for the twin';
set system parameters 'return_null_on_function_errors=yes';
select t.k, date_add(s.d, interval t.n month), date_sub(s.d, interval t.n day), date_add(s.d, interval t.n week), date_sub(s.dt, interval t.n quarter), date_add(s.dt, interval t.n year), date_sub(s.dt, interval t.n hour), date_add(s.dt, interval t.n millisecond) from t_src s, t_amt t where t.k in ('bmin', 'bmax', 'nover', 'far', 'five') order by t.n;
select date_add(date'2024-02-29', interval -9223372036854775808 month), date_sub(date'2024-02-29', interval -9223372036854775808 day), date_sub(datetime'2024-02-29 10:20:30', interval '-99999999999999999999 0' day_hour), date_add(datetime'2024-02-29 10:20:30', interval '99999999999999999999-0' year_month), date_add(date'2024-02-29', interval 5 month);
select date_add(date'2024-02-29', interval -300000000000000 month), date_sub(date'2024-02-29', interval -300000000000000 day), date_sub(datetime'2024-02-29 10:20:30', interval '-40000000 0' day_hour), date_add(datetime'2024-02-29 10:20:30', interval '100000-0' year_month), date_add(date'2024-02-29', interval 5 month);
set system parameters 'return_null_on_function_errors=default';


evaluate 'Case 6: TIMESTAMPTZ, TIMESTAMPLTZ, CHAR and datetime string first arguments with the BIGINT minimum; error = twin';
select date_add(x.tstz, interval t.n month) from t_tz x, t_amt t where t.k = 'bmin';
select date_add(x.tstz, interval t.n month) from t_tz x, t_amt t where t.k = 'month';
select date_sub(x.tstz, interval t.n day) from t_tz x, t_amt t where t.k = 'bmin';
select date_sub(x.tstz, interval t.n day) from t_tz x, t_amt t where t.k = 'day';
select date_add(x.tsltz, interval t.n month) from t_tz x, t_amt t where t.k = 'bmin';
select date_add(x.tsltz, interval t.n month) from t_tz x, t_amt t where t.k = 'month';
select date_sub(x.tsltz, interval t.n day) from t_tz x, t_amt t where t.k = 'bmin';
select date_sub(x.tsltz, interval t.n day) from t_tz x, t_amt t where t.k = 'day';
select date_add(x.c, interval t.n month) from t_tz x, t_amt t where t.k = 'bmin';
select date_add(x.c, interval t.n month) from t_tz x, t_amt t where t.k = 'month';
select date_sub(x.c, interval t.n day) from t_tz x, t_amt t where t.k = 'bmin';
select date_sub(x.c, interval t.n day) from t_tz x, t_amt t where t.k = 'day';
select date_add(x.st, interval t.n month) from t_tz x, t_amt t where t.k = 'bmin';
select date_add(x.st, interval t.n month) from t_tz x, t_amt t where t.k = 'month';
select date_sub(x.st, interval t.n day) from t_tz x, t_amt t where t.k = 'bmin';
select date_sub(x.st, interval t.n day) from t_tz x, t_amt t where t.k = 'day';
select date_add(x.sz, interval t.n month) from t_tz x, t_amt t where t.k = 'bmin';
select date_add(x.sz, interval t.n month) from t_tz x, t_amt t where t.k = 'month';
select date_sub(x.sz, interval t.n day) from t_tz x, t_amt t where t.k = 'bmin';
select date_sub(x.sz, interval t.n day) from t_tz x, t_amt t where t.k = 'day';
select date_add(tstz, interval 5 month), date_add(tsltz, interval 5 month) = date_add(tstz, interval 5 month), date_sub(c, interval 5 day), date_sub(st, interval 5 day), date_sub(sz, interval 5 day) from t_tz;


evaluate 'Case 7: function index, filter index, UPDATE, INSERT and WHERE with the BIGINT minimum; error = twin, rows kept, indexes built without that row';
create table t_fix (k varchar(16), d date, n bigint);
insert into t_fix values ('bmin', date'2024-02-29', -9223372036854775807-1), ('five', date'2024-02-29', 5);
create table t_fiy (k varchar(16), d date, n bigint);
insert into t_fiy values ('far', date'2024-02-29', -40000000), ('five', date'2024-02-29', 5);
create index i_fix on t_fix (date_add(d, interval n month));
create index i_fiy on t_fiy (date_add(d, interval n month));
create index i_filx on t_fix (d) where date_sub(d, interval n day) > date'2000-01-01';
create index i_fily on t_fiy (d) where date_sub(d, interval n day) > date'2000-01-01';
select class_name, index_name from db_index where class_name in ('t_fix', 't_fiy') order by 1, 2;
update t_fix set d = date_add(d, interval n month) where k = 'bmin';
update t_fiy set d = date_add(d, interval n month) where k = 'far';
update t_fix set d = date_sub(d, interval n day) where k = 'bmin';
update t_fiy set d = date_sub(d, interval n day) where k = 'far';
update t_fix set d = date_add(d, interval n week) where k = 'five';
update t_fiy set d = date_add(d, interval n week) where k = 'five';
insert into t_fix select 'copy', date_add(d, interval n quarter), n from t_fix where k = 'bmin';
insert into t_fiy select 'copy', date_add(d, interval n quarter), n from t_fiy where k = 'far';
select k, d, n from t_fix order by k;
select k, d, n from t_fiy order by k;
select k from t_fix where date_sub(d, interval n day) > date'2000-01-01' order by k;
select k from t_fiy where date_sub(d, interval n day) > date'2000-01-01' order by k;
select k, date_add(d, interval n day) from t_fix where k = 'five' order by k;
delete from t_fix where k = 'bmin';
create index i_fix on t_fix (date_add(d, interval n month));
create table t_fiz (k varchar(16), d date, n bigint);
insert into t_fiz values ('five', date'2024-02-29', 5);
create index i_filz on t_fiz (d) where date_sub(d, interval n day) > date'2000-01-01';
select class_name, index_name from db_index where class_name in ('t_fix', 't_fiy', 't_fiz') order by 1, 2;

drop table t_src, t_amt, t_span, t_tz, t_fix, t_fiy, t_fiz;

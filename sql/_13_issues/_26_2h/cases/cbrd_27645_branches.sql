/**
 *  This test case verifies CBRD-27645 on the branches of ADDDATE and SUBDATE with an integer day
 *  count that cbrd_27645.sql does not reach: SUBDATE with the INT minimum, the time zone types,
 *  CHAR, BIGINT and string day counts, return_null_on_function_errors, index and DML contexts.
 *
 *  The function took the size of the day count with abs() on an int, and abs(-2147483648) stays
 *  negative. ADDDATE then stopped the process that evaluated it, and SUBDATE returned 00/00/0000 or
 *  a date conversion error. After the fix both return the error that -2147483647 returns.
 *
 *  Each tested statement is followed by its twin with -2147483647, whose block must equal the
 *  tested block, and by a statement of the same shape with a day count in range, which must return
 *  a row. The build before the fix differs from Case 1 and stops the server at Case 3.
 *
 *  Coverage:
 *    Case 1:  SUBDATE on DATE, DATETIME, TIMESTAMP, date string and datetime string columns
 *    Case 2:  SUBDATE with a literal, a cast, a constant expression and a host variable
 *    Case 3:  ADDDATE on DATETIMETZ, DATETIMELTZ, TIMESTAMPTZ and TIMESTAMPLTZ columns
 *    Case 4:  SUBDATE on DATETIMETZ, DATETIMELTZ, TIMESTAMPTZ and TIMESTAMPLTZ columns
 *    Case 5:  ADDDATE and SUBDATE on CHAR columns with and without a time part
 *    Case 6:  day count from a BIGINT column and a string column, and one below the INT minimum
 *    Case 7:  return_null_on_function_errors=yes gives NULL for both values
 *    Case 8:  function index and filter index on ADDDATE over a row with the INT minimum
 *    Case 9:  UPDATE and WHERE with the INT minimum leave the rows as they were
 */

drop table if exists t_sub, t_tz, t_chr, t_big, t_fidx, t_base, t_upd;

-- day counts by label, each row with 2024-02-29 as DATE, DATETIME, TIMESTAMP, date and datetime strings
create table t_sub (k varchar(16), n int, d date, dt datetime, ts timestamp, s varchar(32), st varchar(32));
insert into t_sub values ('min', -2147483648, date'2024-02-29', datetime'2024-02-29 10:20:30', timestamp'2024-02-29 10:20:30', '2024-02-29', '2024-02-29 10:20:30'), ('base', -2147483647, date'2024-02-29', datetime'2024-02-29 10:20:30', timestamp'2024-02-29 10:20:30', '2024-02-29', '2024-02-29 10:20:30'), ('one', 1, date'2024-02-29', datetime'2024-02-29 10:20:30', timestamp'2024-02-29 10:20:30', '2024-02-29', '2024-02-29 10:20:30'), ('minus', -1, date'2024-02-29', datetime'2024-02-29 10:20:30', timestamp'2024-02-29 10:20:30', '2024-02-29', '2024-02-29 10:20:30');
-- the same instant in the four time zone types, with an explicit offset so no session time zone is printed
create table t_tz (k varchar(16), n int, dtz datetimetz, dltz datetimeltz, tstz timestamptz, tsltz timestampltz);
insert into t_tz select k, n, datetimetz'2024-02-29 10:20:30 +09:00', datetimetz'2024-02-29 10:20:30 +09:00', timestamptz'2024-02-29 10:20:30 +09:00', timestamptz'2024-02-29 10:20:30 +09:00' from t_sub;
-- CHAR keeps the string branch of the function on its fixed-length type
create table t_chr (k varchar(16), n int, c char(10), ct char(19));
insert into t_chr select k, n, '2024-02-29', '2024-02-29 10:20:30' from t_sub;
-- day counts that are cast to INT before the call; below is one less than the INT minimum
create table t_big (k varchar(16), b bigint, v varchar(16));
insert into t_big values ('min', -2147483648, '-2147483648'), ('base', -2147483647, '-2147483647'), ('below', -2147483649, '-2147483649'), ('one', 1, '1');


evaluate 'Case 1: SUBDATE with the INT minimum on DATE, DATETIME, TIMESTAMP and string columns; error = -2147483647';
select subdate(d, n) from t_sub where k = 'min';
select subdate(d, n) from t_sub where k = 'base';
select subdate(dt, n) from t_sub where k = 'min';
select subdate(dt, n) from t_sub where k = 'base';
select subdate(ts, n) from t_sub where k = 'min';
select subdate(ts, n) from t_sub where k = 'base';
select subdate(s, n) from t_sub where k = 'min';
select subdate(s, n) from t_sub where k = 'base';
select subdate(st, n) from t_sub where k = 'min';
select subdate(st, n) from t_sub where k = 'base';
select k, subdate(d, n), subdate(dt, n), subdate(ts, n), subdate(s, n), subdate(st, n) from t_sub where k in ('one', 'minus') order by n;


evaluate 'Case 2: SUBDATE with the INT minimum as a literal, a cast, a constant expression and a host variable; error = -2147483647';
select subdate(date'2024-02-29', -2147483648);
select subdate(date'2024-02-29', -2147483647);
select subdate(date'2024-02-29', cast(-2147483648 as int));
select subdate(date'2024-02-29', cast(-2147483647 as int));
select subdate(date'2024-02-29', -2147483647-1);
select subdate(date'2024-02-29', -2147483646-1);
select subdate(datetime'2024-02-29 10:20:30', cast(-2147483648 as int));
select subdate(datetime'2024-02-29 10:20:30', cast(-2147483647 as int));
select subdate(date'2024-02-29', 1), subdate(datetime'2024-02-29 10:20:30', -1);
prepare st from 'select subdate(?, ?)';
execute st using date'2024-02-29', -2147483648;
execute st using date'2024-02-29', -2147483647;
execute st using date'2024-02-29', 1;
deallocate prepare st;


evaluate 'Case 3: ADDDATE with the INT minimum on the time zone types; error = -2147483647';
select adddate(dtz, n) from t_tz where k = 'min';
select adddate(dtz, n) from t_tz where k = 'base';
select adddate(dltz, n) from t_tz where k = 'min';
select adddate(dltz, n) from t_tz where k = 'base';
select adddate(tstz, n) from t_tz where k = 'min';
select adddate(tstz, n) from t_tz where k = 'base';
select adddate(tsltz, n) from t_tz where k = 'min';
select adddate(tsltz, n) from t_tz where k = 'base';
select k, adddate(dtz, n), adddate(tstz, n), adddate(dltz, n) = adddate(dtz, n), adddate(tsltz, n) = adddate(tstz, n) from t_tz where k in ('one', 'minus') order by n;


evaluate 'Case 4: SUBDATE with the INT minimum on the time zone types; error = -2147483647';
select subdate(dtz, n) from t_tz where k = 'min';
select subdate(dtz, n) from t_tz where k = 'base';
select subdate(dltz, n) from t_tz where k = 'min';
select subdate(dltz, n) from t_tz where k = 'base';
select subdate(tstz, n) from t_tz where k = 'min';
select subdate(tstz, n) from t_tz where k = 'base';
select subdate(tsltz, n) from t_tz where k = 'min';
select subdate(tsltz, n) from t_tz where k = 'base';
select k, subdate(dtz, n), subdate(tstz, n), subdate(dltz, n) = subdate(dtz, n), subdate(tsltz, n) = subdate(tstz, n) from t_tz where k in ('one', 'minus') order by n;


evaluate 'Case 5: ADDDATE and SUBDATE with the INT minimum on CHAR columns; error = -2147483647';
select adddate(c, n) from t_chr where k = 'min';
select adddate(c, n) from t_chr where k = 'base';
select subdate(c, n) from t_chr where k = 'min';
select subdate(c, n) from t_chr where k = 'base';
select adddate(ct, n) from t_chr where k = 'min';
select adddate(ct, n) from t_chr where k = 'base';
select subdate(ct, n) from t_chr where k = 'min';
select subdate(ct, n) from t_chr where k = 'base';
select k, adddate(c, n), subdate(c, n), adddate(ct, n), subdate(ct, n) from t_chr where k in ('one', 'minus') order by n;


evaluate 'Case 6: day count from a BIGINT and a string column; error = -2147483647; one below the INT minimum is not an INT';
select adddate(date'2024-02-29', b) from t_big where k = 'min';
select adddate(date'2024-02-29', b) from t_big where k = 'base';
select subdate(date'2024-02-29', b) from t_big where k = 'min';
select subdate(date'2024-02-29', b) from t_big where k = 'base';
select adddate(date'2024-02-29', v) from t_big where k = 'min';
select adddate(date'2024-02-29', v) from t_big where k = 'base';
select adddate(date'2024-02-29', b), subdate(date'2024-02-29', b), adddate(date'2024-02-29', v) from t_big where k = 'one';
select adddate(date'2024-02-29', b) from t_big where k = 'below';
select adddate(date'2024-02-29', -2147483649);


evaluate 'Case 7: return_null_on_function_errors=yes gives NULL for the INT minimum as for -2147483647';
set system parameters 'return_null_on_function_errors=yes';
select k, adddate(d, n), subdate(d, n), adddate(dt, n), subdate(dt, n), adddate(s, n), subdate(s, n) from t_sub where k in ('min', 'base', 'one') order by n;
select adddate(date'2024-02-29', cast(-2147483648 as int)), subdate(date'2024-02-29', cast(-2147483648 as int)), adddate(date'2024-02-29', cast(-2147483647 as int)), subdate(date'2024-02-29', cast(-2147483647 as int));
set system parameters 'return_null_on_function_errors=default';


evaluate 'Case 8: function index and filter index on ADDDATE over a row with the INT minimum; error = -2147483647';
create table t_fidx (k varchar(16), d date, n int);
insert into t_fidx values ('min', date'2024-02-29', -2147483648), ('one', date'2024-02-29', 1);
create table t_base (k varchar(16), d date, n int);
insert into t_base values ('base', date'2024-02-29', -2147483647), ('one', date'2024-02-29', 1);
create index i_fidx on t_fidx (adddate(d, n));
create index i_base on t_base (adddate(d, n));
create index i_filt on t_fidx (d) where adddate(d, n) > date'2000-01-01';
create index i_filb on t_base (d) where adddate(d, n) > date'2000-01-01';
select class_name, index_name from db_index where class_name in ('t_fidx', 't_base') order by 1, 2;
delete from t_fidx where k = 'min';
delete from t_base where k = 'base';
create index i_fidx on t_fidx (adddate(d, n));
create index i_base on t_base (adddate(d, n));
select class_name, index_name from db_index where class_name in ('t_fidx', 't_base') order by 1, 2;
insert into t_fidx values ('min', date'2024-02-29', -2147483648);
insert into t_base values ('base', date'2024-02-29', -2147483647);
select k, d, n from t_fidx order by n;
select k, d, n from t_base order by n;


evaluate 'Case 9: UPDATE and WHERE with the INT minimum give the error and leave the rows as they were';
create table t_upd (k varchar(16), d date, n int);
insert into t_upd values ('min', date'2024-02-29', -2147483648), ('base', date'2024-02-29', -2147483647), ('one', date'2024-02-29', 1);
update t_upd set d = adddate(d, n) where k = 'min';
update t_upd set d = adddate(d, n) where k = 'base';
update t_upd set d = subdate(d, n) where k = 'min';
update t_upd set d = subdate(d, n) where k = 'base';
update t_upd set d = adddate(d, n) where k = 'one';
select k, d, n from t_upd order by n;
select k from t_upd where adddate(d, n) > date'2000-01-01' order by k;
select count(*) from t_upd;

drop table t_sub, t_tz, t_chr, t_big, t_fidx, t_base, t_upd;

/**
 *  This test case verifies CBRD-27504: TO_CHAR on a date or time value rejects a format argument
 *  bound to a value that is not a character string, and the server keeps running.
 *
 *  A host/session variable in the format is bound without a cast - the date/time branch of TO_CHAR
 *  reads it as a string whatever its type, so a BIGINT format crashed release (aborted debug). The
 *  fix matches the number branch's error - literal/query-text formats keep their pre-fix results.
 *
 *  Coverage:
 *    Case 1:  issue repro, a BIGINT bound to the format on a DATETIME column
 *    Case 2:  a BIGINT format on every date/time column type and with a date language
 *    Case 3:  the date value and the format both bound, a zero date and a NULL date included
 *    Case 4:  INT, NUMERIC, DOUBLE, DATE and BIT values bound to the format
 *    Case 5:  string formats keep their results, an empty string and NULL included
 *    Case 6:  formats in the query text are cast at compile time and keep their results
 *    Case 7:  a session variable, an expression of a host variable and a scalar subquery as the format
 *    Case 8:  INT, DOUBLE, DATE and VARCHAR values bound through the JDBC driver
 *    Case 9:  the format bound in WHERE, ORDER BY, UPDATE SET and INSERT SELECT, the row unchanged
 */

drop table if exists t_dt;

-- one row holding every date and time type, a number g for the number branch and a string format
create table t_dt (id int primary key, g int, dtt datetime, d date, t time, ts timestamp, dtz datetimetz,
    tsz timestamptz, tsl timestampltz, dtl datetimeltz, fmt varchar(16));
insert into t_dt values (1, 1, datetime'2024-01-02 10:00:01.500', date'2024-01-02', time'10:00:01', timestamp'2024-01-02 10:00:01', datetimetz'2024-01-02 10:00:01.500 +09:00',
    timestamptz'2024-01-02 10:00:01 +09:00', timestampltz'2024-01-02 10:00:01', datetimeltz'2024-01-02 10:00:01.500', 'YYYY-MM-DD');

prepare n from 'select to_char(g, ?) from t_dt where id = 1';


evaluate 'Case 1: issue repro, a BIGINT bound to the format on a DATETIME column';
prepare s from 'select to_char(dtt, ?) from t_dt where id = 1';
execute s using 'YYYY-MM-DD';
execute s using 9007199254740993;
execute s using 4294967297;
execute s using 2147483648;
execute n using 9007199254740993;


evaluate 'Case 2: a BIGINT format on every date and time type and with a date language';
prepare s from 'select to_char(d, ?) from t_dt where id = 1';
execute s using 9007199254740993;
prepare s from 'select to_char(t, ?) from t_dt where id = 1';
execute s using 9007199254740993;
prepare s from 'select to_char(ts, ?) from t_dt where id = 1';
execute s using 9007199254740993;
prepare s from 'select to_char(dtz, ?) from t_dt where id = 1';
execute s using 9007199254740993;
prepare s from 'select to_char(tsz, ?) from t_dt where id = 1';
execute s using 9007199254740993;
prepare s from 'select to_char(tsl, ?) from t_dt where id = 1';
execute s using 9007199254740993;
prepare s from 'select to_char(dtl, ?) from t_dt where id = 1';
execute s using 9007199254740993;
prepare s from 'select to_char(dtt, ?, ''en_US'') from t_dt where id = 1';
execute s using 9007199254740993;
execute s using 'DD MONTH YYYY';


evaluate 'Case 3: the date value and the format both bound, a zero date and a NULL date included';
prepare s from 'select to_char(?, ?) from db_root';
execute s using datetime'2024-01-02 10:00:01.500', 9007199254740993;
execute s using datetime'2024-01-02 10:00:01.500', 'YYYY-MM-DD';
execute s using datetime'0000-00-00 00:00:00', 9007199254740993;
execute s using datetime'0000-00-00 00:00:00', 'YYYY-MM-DD';
execute s using null, 9007199254740993;
execute s using 1, 9007199254740993;


evaluate 'Case 4: INT, NUMERIC, DOUBLE, DATE and BIT values bound to the format';
prepare s from 'select to_char(dtt, ?) from t_dt where id = 1';
execute s using 1;
execute n using 1;
execute s using 1.50;
execute n using 1.50;
execute s using 1.5e0;
execute n using 1.5e0;
execute s using date'2024-01-02';
execute n using date'2024-01-02';
execute s using X'59595959';
execute n using X'59595959';


evaluate 'Case 5: string formats keep their results, an empty string and NULL included';
execute s using 'YYYY-MM-DD HH24:MI:SS.FF';
execute s using '';
execute s using null;
execute n using '9999';
execute n using null;


evaluate 'Case 6: formats in the query text are cast at compile time and keep their results';
select to_char(dtt, 9007199254740993) from t_dt where id = 1;
select to_char(dtt, cast(9007199254740993 as bigint)) from t_dt where id = 1;
select to_char(dtt, fmt), to_char(dtt) from t_dt where id = 1;
select to_char(dtt, g) from t_dt where id = 1;


evaluate 'Case 7: a session variable, an expression of a host variable and a scalar subquery as the format';
set @fmt_bigint = 9007199254740993;
select to_char(dtt, @fmt_bigint) from t_dt where id = 1;
select to_char(g, @fmt_bigint) from t_dt where id = 1;
set @fmt_bigint = 'YYYY';
select to_char(dtt, @fmt_bigint) from t_dt where id = 1;
prepare s from 'select to_char(dtt, ? + 0) from t_dt where id = 1';
execute s using 1;
prepare s from 'select to_char(dtt, (select ? from db_root)) from t_dt where id = 1';
execute s using 9007199254740993;
deallocate variable @fmt_bigint;


evaluate 'Case 8: INT, DOUBLE, DATE and VARCHAR values bound through the JDBC driver';
$int, $1
select to_char(dtt, ?) from t_dt where id = 1;
$int, $1
select to_char(g, ?) from t_dt where id = 1;
$double, $1.5
select to_char(dtt, ?) from t_dt where id = 1;
-- the CTP CCI runner passes this $date text where CCI expects a date struct, so the bind
-- itself fails with -176 before TO_CHAR runs (see answer_cci: -176, not -621)
$date, $2024-01-02
select to_char(dtt, ?) from t_dt where id = 1;
$varchar, $YYYY-MM-DD
select to_char(dtt, ?) from t_dt where id = 1;


evaluate 'Case 9: the format bound in WHERE, ORDER BY, UPDATE SET and INSERT SELECT, the row unchanged';
prepare s from 'select id from t_dt where to_char(dtt, ?) = ''2024''';
execute s using 9007199254740993;
execute s using 'YYYY';
prepare s from 'select id from t_dt order by to_char(dtt, ?)';
execute s using 9007199254740993;
-- the failed UPDATE and INSERT must leave the table as it was
prepare s from 'update t_dt set fmt = to_char(dtt, ?) where id = 1';
execute s using 9007199254740993;
prepare s from 'insert into t_dt (id, fmt) select 2, to_char(dtt, ?) from t_dt where id = 1';
execute s using 9007199254740993;
select id, fmt from t_dt order by id;

drop prepare s;
drop prepare n;
drop table t_dt;

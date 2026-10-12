/**
 *  This test case verifies CBRD-27504: TO_CHAR on a date or time value rejects a format argument
 *  bound to a value that is not a character string, and the server keeps running.
 *
 *  A host variable or a session variable in the format argument of TO_CHAR is bound without a
 *  cast. The date and time branch of TO_CHAR read the bound value as a string whatever its type,
 *  so a BIGINT format made the debug build abort on an assert and the release build crash. The
 *  fix returns the error that the number branch of TO_CHAR already returns for such a format.
 *
 *  Each rejected format is also bound to the number branch, prepared statement n, which must give
 *  the same error. No hint or parameter selects another path, so the other expected values are
 *  literal: string, empty string and NULL formats, and formats written in the query text, keep the
 *  results they had before the fix. The pre-fix debug build aborts on Case 1.
 *
 *  Coverage:
 *    Case 1:  issue repro, a BIGINT bound to the format on a DATETIME column
 *    Case 2:  a BIGINT format on DATE, TIME, TIMESTAMP and DATETIMETZ columns and with a date language
 *    Case 3:  the date value and the format both bound, a zero date and a NULL date included
 *    Case 4:  INT, NUMERIC, DOUBLE, DATE and BIT values bound to the format
 *    Case 5:  string formats keep their results, an empty string and NULL included
 *    Case 6:  formats in the query text are cast at compile time and keep their results
 *    Case 7:  a session variable and an expression of a host variable as the format
 *    Case 8:  INT, DOUBLE, DATE and VARCHAR values bound through the JDBC driver
 */

drop table if exists t_dt;

-- one row holding every date and time type, a number g for the number branch and a string format
create table t_dt (id int primary key, g int, dtt datetime, d date, t time, ts timestamp, dtz datetimetz, fmt varchar(16));
insert into t_dt values (1, 1, datetime'2024-01-02 10:00:01.500', date'2024-01-02', time'10:00:01', timestamp'2024-01-02 10:00:01', datetimetz'2024-01-02 10:00:01.500 +09:00', 'YYYY-MM-DD');

prepare n from 'select to_char(g, ?) from t_dt where id = 1';


evaluate 'Case 1: issue repro, a BIGINT bound to the format on a DATETIME column';
prepare s from 'select to_char(dtt, ?) from t_dt where id = 1';
execute s using 'YYYY-MM-DD';
execute s using 9007199254740993;
execute s using 4294967297;
execute s using 2147483648;
execute n using 9007199254740993;


evaluate 'Case 2: a BIGINT format on DATE, TIME, TIMESTAMP and DATETIMETZ columns and with a date language';
prepare s from 'select to_char(d, ?) from t_dt where id = 1';
execute s using 9007199254740993;
prepare s from 'select to_char(t, ?) from t_dt where id = 1';
execute s using 9007199254740993;
prepare s from 'select to_char(ts, ?) from t_dt where id = 1';
execute s using 9007199254740993;
prepare s from 'select to_char(dtz, ?) from t_dt where id = 1';
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


evaluate 'Case 7: a session variable and an expression of a host variable as the format';
set @fmt_bigint = 9007199254740993;
select to_char(dtt, @fmt_bigint) from t_dt where id = 1;
select to_char(g, @fmt_bigint) from t_dt where id = 1;
set @fmt_bigint = 'YYYY';
select to_char(dtt, @fmt_bigint) from t_dt where id = 1;
prepare s from 'select to_char(dtt, ? + 0) from t_dt where id = 1';
execute s using 1;
deallocate variable @fmt_bigint;


evaluate 'Case 8: INT, DOUBLE, DATE and VARCHAR values bound through the JDBC driver';
$int, $1
select to_char(dtt, ?) from t_dt where id = 1;
$int, $1
select to_char(g, ?) from t_dt where id = 1;
$double, $1.5
select to_char(dtt, ?) from t_dt where id = 1;
$date, $2024-01-02
select to_char(dtt, ?) from t_dt where id = 1;
$varchar, $YYYY-MM-DD
select to_char(dtt, ?) from t_dt where id = 1;


drop prepare s;
drop prepare n;
drop table t_dt;

/**
 *  This test case verifies CBRD-27510: the conversion cells keep develop's conversion contracts.
 *
 *  CBRD-27510 moved the type-pair bodies of tp_value_cast and tp_value_coerce into cell functions, which the casts
 *  and the planned converters of the row paths call. This case pins the contracts those cells keep - truncation of
 *  a string cast to CHAR under both allow_truncated_string settings, date arithmetic with real and string operands
 *  (the operand becomes a rounded BIGINT), equality between INT and TIME values and between an INT column and other
 *  numbers on a sequential and an index scan, index keys whose parse sets an error, results that depend on a
 *  value's content, a bound VARCHAR under a CAST and timestamp encodings that fail.
 *
 *  Every answer here is the develop answer except two statements of Case 5. MEDIAN over a VARCHAR column that holds
 *  date-time or time strings is -1118, because the MEDIAN of a string column is DOUBLE by its type. develop
 *  classified the first value and answered a DATETIME (2024-01-02 10:00:00.0) and a TIME (02:00:00). The column of
 *  numeric strings and the session variables keep develop's answers.
 *
 *  Coverage:
 *    Case 1: a VARCHAR cast to CHAR(3) with truncation, under both allow_truncated_string settings
 *    Case 2: date arithmetic with real and string operands
 *    Case 3: INT against TIME and against other numbers, sequential and index scan
 *    Case 4: index keys whose parse fails - a date that does not parse, a NUMERIC overflow
 *    Case 5: results that depend on a value's content - MEDIAN, STR_TO_DATE, ADDTIME
 *    Case 6: a VARCHAR bind under a CAST to CHAR(3)
 *    Case 7: timestamp encodings that fail
 */
--+ holdcas on;
drop table if exists tc;
create table tc (i int, c3 char(3), v varchar(10), d date, t time, n numeric(5,2), dt datetime);
insert into tc values (1, 'ab', 'ab', date'2024-01-01', time'01:00:00', 123.45, datetime'2024-01-01 10:00:00');
insert into tc values (2, 'abc', 'abc', date'2024-01-02', time'02:00:00', 1.5, datetime'2024-01-02 10:00:00');
create index it on tc(t);
create index id on tc(d);
create index inn on tc(n);
create index ii on tc(i);

-- Case 1. A VARCHAR session variable cast to CHAR(3) and VARCHAR(3), inserted into a CHAR(3) column and compared
-- with it, under allow_truncated_string=no and yes.
evaluate 'Case 1: VARCHAR to CHAR(3) with truncation';
SET @s = 'abcdef';
SELECT CAST(@s AS CHAR(3)), typeof(CAST(@s AS CHAR(3)));
SELECT CAST(@s AS VARCHAR(3));
INSERT INTO tc (i, c3) VALUES (10, @s);
SELECT i, c3, length(c3) FROM tc WHERE i = 10;
DELETE FROM tc WHERE i = 10;
SET SYSTEM PARAMETERS 'allow_truncated_string=yes';
SELECT CAST(@s AS CHAR(3)), typeof(CAST(@s AS CHAR(3)));
INSERT INTO tc (i, c3) VALUES (10, @s);
SELECT i, c3, length(c3) FROM tc WHERE i = 10;
DELETE FROM tc WHERE i = 10;
SET SYSTEM PARAMETERS 'allow_truncated_string=no';
SET @s = 'ab';
SELECT i FROM tc WHERE c3 = @s;
SET @s = 'ab ';
SELECT i FROM tc WHERE c3 = @s;
SET @s = 'abcd';
SELECT i FROM tc WHERE c3 = @s;

-- Case 2. A date, a datetime and a time plus or minus a real or string operand, which becomes a rounded BIGINT, and
-- a string that does not convert with return_null_on_function_errors off and on.
evaluate 'Case 2: date arithmetic with real and string operands';
SET @r = 1.5;
SELECT date'2024-01-01' + @r, date'2024-01-01' - @r, typeof(date'2024-01-01' + @r);
SET @r = 2.5;
SELECT date'2024-01-01' + @r;
SET @r = 0.4;
SELECT date'2024-01-01' + @r;
SET @r = '1.5';
SELECT date'2024-01-01' + @r;
SET @r = 1.5;
SELECT d, d + @r FROM tc;
SELECT datetime'2024-01-01 10:00:00' + @r, time'10:00:00' + @r;
SET @r = 'abc';
SELECT date'2024-01-01' + @r;
SET SYSTEM PARAMETERS 'return_null_on_function_errors=yes';
SELECT date'2024-01-01' + @r;
SET @r = 1.5;
SELECT date'2024-01-01' + @r;
SET SYSTEM PARAMETERS 'return_null_on_function_errors=no';

-- Case 3. A TIME column against an INT, and an INT column against a decimal or a string, each on a sequential scan
-- (USING INDEX NONE) and an index scan.
evaluate 'Case 3: INT against TIME and other numbers';
SET @k = 3600;
SELECT i, t FROM tc WHERE t = @k USING INDEX NONE;
SELECT i, t FROM tc WHERE t = @k USING INDEX it(+);
SET @k = 90000;
SELECT i, t FROM tc WHERE t = @k USING INDEX NONE;
SELECT i, t FROM tc WHERE t = @k USING INDEX it(+);
SELECT 3600 = time'01:00:00', 90000 = time'01:00:00';
SET @k = 1.5;
SELECT i FROM tc WHERE i = @k USING INDEX NONE;
SELECT i FROM tc WHERE i = @k USING INDEX ii(+);
SET @k = 1.0;
SELECT i FROM tc WHERE i = @k USING INDEX NONE;
SELECT i FROM tc WHERE i = @k USING INDEX ii(+);
SET @k = '1.5';
SELECT i FROM tc WHERE i = @k USING INDEX NONE;
SELECT i FROM tc WHERE i = @k USING INDEX ii(+);
SET @k = '2';
SELECT i FROM tc WHERE i = @k USING INDEX NONE;
SELECT i FROM tc WHERE i = @k USING INDEX ii(+);
SET @k = 3600;
SELECT i FROM tc WHERE t > @k USING INDEX NONE;
SELECT i FROM tc WHERE t > @k USING INDEX it(+);

-- Case 4. An index key whose parse sets an error - a date string that does not parse, a NUMERIC string and a double
-- beyond the column's range - on a sequential and an index scan, then the same values from a correlated column.
evaluate 'Case 4: index keys whose parse fails';
SET @g = 'garbage';
SELECT i FROM tc WHERE d = @g USING INDEX NONE;
SELECT i FROM tc WHERE d = @g USING INDEX id(+);
SET @g = '2024-01-02';
SELECT i FROM tc WHERE d = @g USING INDEX id(+);
SELECT i FROM tc WHERE d = @g USING INDEX NONE;
SET @g = '123456789012345678901234567890123456789012.5';
SELECT i FROM tc WHERE n = @g USING INDEX NONE;
SELECT i FROM tc WHERE n = @g USING INDEX inn(+);
SET @g = 1e30;
SELECT i FROM tc WHERE n = @g USING INDEX NONE;
SELECT i FROM tc WHERE n = @g USING INDEX inn(+);
SET @g = '1.5';
SELECT i FROM tc WHERE n = @g USING INDEX inn(+);
SELECT i FROM tc WHERE n = @g USING INDEX NONE;
SET @g = 1.5;
SELECT i FROM tc WHERE n = @g USING INDEX inn(+);
SELECT i FROM tc WHERE n = @g USING INDEX NONE;
drop table if exists ts;
create table ts (s varchar(50));
insert into ts values ('2024-01-02'), ('garbage'), ('2024-01-03');
SELECT s, (SELECT count(*) FROM tc WHERE tc.d = ts.s USING INDEX id(+)) FROM ts;
SELECT s, (SELECT count(*) FROM tc WHERE tc.d = ts.s USING INDEX NONE) FROM ts;
insert into ts values ('123456789012345678901234567890123456789012.5');
SELECT s, (SELECT count(*) FROM tc WHERE tc.n = ts.s USING INDEX inn(+)) FROM ts;
SELECT s, (SELECT count(*) FROM tc WHERE tc.n = ts.s USING INDEX NONE) FROM ts;

-- Case 5. Results that depend on a value's content - MEDIAN over string columns and session variables, STR_TO_DATE
-- with a format variable, ADDTIME over date-time and time strings.
evaluate 'Case 5: results that depend on a value content';
drop table if exists tm;
create table tm (s varchar(30));
insert into tm values ('1.5'), ('2.5'), ('3.5');
SELECT median(s), typeof(median(s)) FROM tm;
delete from tm;
insert into tm values ('2024-01-01 10:00:00'), ('2024-01-03 10:00:00');
SELECT median(s), typeof(median(s)) FROM tm;
delete from tm;
insert into tm values ('01:00:00'), ('03:00:00');
SELECT median(s), typeof(median(s)) FROM tm;
delete from tm;
insert into tm values ('1.5'), ('01:00:00');
SELECT median(s), typeof(median(s)) FROM tm;
delete from tm;
insert into tm values ('abc'), ('def');
SELECT median(s) FROM tm;
SET @m = '1.5';
SELECT median(@m), typeof(median(@m)) FROM tc;
SET @m = '01:00:00';
SELECT median(@m), typeof(median(@m)) FROM tc;
SET @m = 'abc';
SELECT median(@m) FROM tc;
SET @f = '%H:%i:%s';
SELECT str_to_date('10:11:12', @f), typeof(str_to_date('10:11:12', @f));
SET @f = '%Y-%m-%d';
SELECT str_to_date('2024-01-02', @f), typeof(str_to_date('2024-01-02', @f));
SET @f = '%Y-%m-%d %H:%i:%s';
SELECT typeof(str_to_date('2024-01-02 10:11:12', @f));
SET @a = '2024-01-01 10:00:00';
SELECT addtime(@a, time'01:00:00'), typeof(addtime(@a, time'01:00:00'));
SET @a = '10:00:00';
SELECT addtime(@a, time'01:00:00'), typeof(addtime(@a, time'01:00:00'));
SET @a = '2024-01-01 10:00:00 Asia/Seoul';
SELECT addtime(@a, time'01:00:00'), typeof(addtime(@a, time'01:00:00'));
SET @a = 'abc';
SELECT addtime(@a, time'01:00:00');
SELECT addtime(datetime'2024-01-01 10:00:00', time'01:00:00'), typeof(addtime(datetime'2024-01-01 10:00:00', time'01:00:00'));
SELECT typeof(addtime(time'10:00:00', time'01:00:00'));

-- Case 6. A VARCHAR bind under a CAST to CHAR(3) follows the bind conversion of allow_truncated_string.
evaluate 'Case 6: a VARCHAR bind under a CAST to CHAR(3)';
set system parameters 'allow_truncated_string=no';
$varchar, $abcdef;
select cast(? as char(3)) as bound_char;
set system parameters 'allow_truncated_string=yes';
$varchar, $abcdef;
select cast(? as char(3)) as bound_char;
set system parameters 'allow_truncated_string=no';

-- Case 7. A timestamp encoding that fails keeps develop's statement error.
evaluate 'Case 7: timestamp encodings that fail';
select cast(datetime'2041-01-01 00:00:00' as timestamp);
select cast('2041-01-01 00:00:00' as timestamp);
select cast('2024-01-01 00:00:00 Not/A_Timezone' as timestamptz);
select cast('2024-01-01 00:00:00 Asia/Seoul' as timestamptz);

drop table tm;
drop table ts;
drop table tc;
drop variable @s, @r, @k, @g, @m, @f, @a;
--+ holdcas off;

--+ holdcas on;
-- D-328-02..07: preserve the existing conversion contracts.
drop table if exists tc;
create table tc (i int, c3 char(3), v varchar(10), d date, t time, n numeric(5,2), dt datetime);
insert into tc values (1, 'ab', 'ab', date'2024-01-01', time'01:00:00', 123.45, datetime'2024-01-01 10:00:00');
insert into tc values (2, 'abc', 'abc', date'2024-01-02', time'02:00:00', 1.5, datetime'2024-01-02 10:00:00');
create index it on tc(t);
create index id on tc(d);
create index inn on tc(n);
create index ii on tc(i);

-- ===== R1: CAST VARCHAR -> CHAR(3) with truncation, both allow_truncated_string settings
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

-- ===== R3: GATE date arithmetic with real / string operands (today: tp_value_auto_cast -> BIGINT, ROUND)
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

-- ===== R4: mixed-type equality after keep (INT vs TIME), sequential vs index
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

-- ===== R6: KEEP path with parsers that er_set (date key parsing, numeric overflow) - residual error / assert check
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

-- ===== R5: value-content dependent results
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

-- JDBC bound VARCHAR below CAST follows the bind conversion policy.
set system parameters 'allow_truncated_string=no';
$varchar, $abcdef;
select cast(? as char(3)) as bound_char;
set system parameters 'allow_truncated_string=yes';
$varchar, $abcdef;
select cast(? as char(3)) as bound_char;
set system parameters 'allow_truncated_string=no';

-- Timestamp encoding failure must preserve the existing statement error result.
select cast(datetime'2041-01-01 00:00:00' as timestamp);
select cast('2041-01-01 00:00:00' as timestamp);
select cast('2024-01-01 00:00:00 Not/A_Timezone' as timestamptz);
select cast('2024-01-01 00:00:00 Asia/Seoul' as timestamptz);

drop table tm;
drop table ts;
drop table tc;
drop variable @s, @r, @k, @g, @m, @f, @a;
--+ holdcas off;

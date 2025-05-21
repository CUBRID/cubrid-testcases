--cases form dev


select repeat('cubrid',3);
select repeat('cubrid',32000000);
select repeat('cubrid',-1);
select repeat('cubrid','a');


--1. Test string types
select if(repeat(cast('cubrid' as char(8)), 3) = 'cubrid  cubrid  cubrid  ', 'ok', 'nok');
select if(repeat(cast('cubrid' as varchar(8)), 3) = 'cubridcubridcubrid', 'ok', 'nok');
select if(repeat(cast(n'cubrid' as nchar(8)), 3) = n'cubrid  cubrid  cubrid  ', 'ok', 'nok');
select if(repeat(cast(n'cubrid' as nchar varying(8)), 3) = n'cubridcubridcubrid', 'ok', 'nok');

-- return an empty string
select if(repeat(cast('' as char(8)), 3) = '', 'ok', 'nok');
select if(repeat(cast('' as varchar(8)), 3) = '', 'ok', 'nok');
select if(repeat(cast(n'' as nchar(8)), 3) = n'', 'ok', 'nok');
select if(repeat(cast(n'' as nchar varying(8)), 3) = n'', 'ok', 'nok');

-- server side
create table t (c char(32), vc varchar(32), nc nchar(32), vnc nchar varying(32));
insert into t values('abcde', 'ABCDE', n'vwxyz', n'VWXYZ');
select if(repeat(c, 3) = repeat(cast('abcde' as char(32)), 3), 'ok', 'nok') from t;
select if(repeat(vc, 3) = repeat(cast('ABCDE' as varchar(32)), 3), 'ok', 'nok') from t;
select if(repeat(nc, 3) = repeat(cast(n'vwxyz' as nchar(32)), 3), 'ok', 'nok') from t;
select if(repeat(vnc, 3) = repeat(cast(n'VWXYZ' as nchar varying(32)), 3), 'ok', 'nok') from t;
drop table t;


--2. Test numeric types
select if(repeat(cast(12345 as short), 3) = repeat('12345', 3), 'ok', 'nok');
select if(repeat(cast(12345 as integer), 3) = repeat('12345', 3), 'ok', 'nok');
select if(repeat(cast(12345 as bigint), 3) = repeat('12345', 3), 'ok', 'nok');

select if(repeat(cast(12345.123 as float), 3) = repeat('12345.12', 3), 'ok', 'nok');
select if(repeat(cast(12345.123 as double), 3) = repeat('12345.123', 3), 'ok', 'nok');
select if(repeat(cast(12345.123 as monetary), 3) = repeat('$12345.12', 3), 'ok', 'nok');

select if(repeat(12345.123F, 3) = repeat('12345.123', 3), 'ok', 'nok');
select if(repeat(12345.123E0, 3) = repeat('12345.123', 3), 'ok', 'nok');

-- server side
create table t (s short, i integer, bi bigint, f float, d double, m monetary);
insert into t values(12345, 12345, 12345, 12345, 12345, 12345);
select if(repeat(s, 3) = repeat('12345', 3), 'ok', 'nok') from t;
select if(repeat(i, 3) = repeat('12345', 3), 'ok', 'nok') from t;
select if(repeat(bi, 3) = repeat('12345', 3), 'ok', 'nok') from t;
select if(repeat(f, 3) = repeat('12345', 3), 'ok', 'nok') from t;
select if(repeat(d, 3) = repeat('12345', 3), 'ok', 'nok') from t;
select if(repeat(m, 3) = repeat('$12345', 3), 'ok', 'nok') from t;
drop table t;

--3. Test date/time types
select if(repeat(date'2010-08-02', 3) = repeat('08/02/2010', 3), 'ok', 'nok');
select if(repeat(time'09:30:30 AM', 3) = repeat('09:30:30 AM', 3), 'ok', 'nok');
select if(repeat(datetime'09:30:30 AM 08/02/2010', 3) = repeat('09:30:30.000 AM 08/02/2010', 3), 'ok', 'nok');
select if(repeat(timestamp'09:30:30 AM 08/02/2010', 3) = repeat('09:30:30 AM 08/02/2010', 3), 'ok', 'nok');

-- server side
create table t (d date, t time, dt datetime, ts timestamp);
insert into t values(date'2010-07-30', time'09:30:30', datetime'2010-07-30 09:30:30', timestamp'2010-07-30 09:30:30');
select if(repeat(d, 3) = repeat('07/30/2010', 3), 'ok', 'nok') from t;
select if(repeat(t, 3) = repeat('09:30:30 AM', 3), 'ok', 'nok') from t;
select if(repeat(dt, 3) = repeat('09:30:30.000 AM 07/30/2010', 3), 'ok', 'nok') from t;
select if(repeat(ts, 3) = repeat('09:30:30 AM 07/30/2010', 3), 'ok', 'nok') from t;
drop table t;

--4. Test host variables
-- success
prepare s from 'select if(repeat(?, ?) = ?, ''ok'', ''nok'')';
execute s using 'cubrid', 3, 'cubridcubridcubrid';
execute s using '', 3, '';
execute s using 'a', 1.5, 'aa';
execute s using 'a', 1.4, 'a';
execute s using 'a', 1.5f, 'aa';
execute s using 'a', 1.4f, 'a';
execute s using 'a', 1.5e0, 'aa';
execute s using 'a', 1.4e0, 'a';
deallocate prepare s;

prepare s from 'select if(repeat(?, 3) = repeat(?, 3), ''ok'', ''nok'')';
execute s using 12345, '12345';
execute s using 12345.123, '12345.123';
execute s using 12345.123f, '12345.12';
execute s using 12345.123e0, '12345.123';
execute s using $12345.123, '$12345.12';
execute s using date'2010-08-02', '08/02/2010';
execute s using time'09:30:30 AM', '09:30:30 AM';
execute s using datetime'09:30:30 AM 08/02/2010', '09:30:30.000 AM 08/02/2010';
execute s using timestamp'09:30:30 AM 08/02/2010', '09:30:30 AM 08/02/2010';
execute s using 0b00010001, '11';
deallocate prepare s;

-- failure
prepare s from 'select repeat(?, ?)';
execute s using 'a', date'2010-09-02';
execute s using 'a', datetime'2010-09-02 17:30:30';
execute s using 'a', timestamp'2010-09-02 17:30:30';
execute s using 'a', time'17:30:30';
execute s using 'a', 0b00110001;
-- cannot coerce nchar to varchar
execute s using n'a', 2;
deallocate prepare s;

--5. Test the range of count
-- return NULL
select if(repeat(null, 3) is null, 'ok', 'nok');
select if(repeat('cubrid', null) is null, 'ok', 'nok');

select if(repeat('cubrid', 0) = '', 'ok', 'nok');
select if(repeat('cubrid', -1) = '', 'ok', 'nok');

-- rounding (TBD)
select if(repeat('cubrid', 1.5) = repeat('cubrid', 2), 'ok', 'nok');
select if(repeat('cubrid', 1.4) = repeat('cubrid', 1), 'ok', 'nok');
select if(repeat('cubrid', 0.4) = repeat('cubrid', 0), 'ok', 'nok');


--6. Test the range of return string
-- TBD
select if(char_length(repeat('x', cast(1073741823 as int))) = 1073741823, 'ok', 'nok');

--7. Test unsupported types
-- error
select repeat(cast(B'1' as bit(8)), 2);
select repeat(cast(B'1' as bit varying(8)), 2);


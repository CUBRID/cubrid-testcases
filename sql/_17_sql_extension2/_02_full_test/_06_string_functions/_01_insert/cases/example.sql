--cases from dev

select insert('cubrid',2,2,'dbsql');
select insert('cubrid',0,3,'db');
select insert('cubrid',-3,3,'db');
select insert('cubrid',3,100,'db');
select insert('cubrid',7,100,'db');
select insert('cubrid',3,-1,'db');

SELECT INSERT('Quadratic', 3, 4, 'What');
SELECT INSERT('Quadratic', -1, 4, 'What');
SELECT INSERT('Quadratic', 3, 100, 'What');

--1. Test string types
select if(insert(cast('abcdefghijk' as varchar(32)), 5, 3, 'XXX') = 'abcdXXXhijk', 'ok', 'nok');
select if(insert(cast('abcdefghijk' as char(32)), 5, 3, 'XXX') = 'abcdXXXhijk', 'ok', 'nok');
select if(insert(cast(n'abcdefghijk' as nchar varying(32)), 5, 3, n'XXX') = n'abcdXXXhijk', 'ok', 'nok');
select if(insert(cast(n'abcdefghijk' as nchar(32)), 5, 3, n'XXX') = n'abcdXXXhijk', 'ok', 'nok');

-- server side
create table t (c char(32), vc varchar(32), nc nchar(32), vnc nchar varying(32));
insert into t values('abcde', 'ABCDE', n'vwxyz', n'VWXYZ');
select if(insert(c, 2, 3, c) = insert(cast('abcde' as char(32)), 2, 3, cast('abcde' as char(32))), 'ok', 'nok') from t;
select if(insert(vc, 2, 3, vc) = insert(cast('ABCDE' as varchar(32)), 2, 3, cast('ABCDE' as varchar(32))), 'ok', 'nok') from t;
select if(insert(nc, 2, 3, nc) = insert(cast(n'vwxyz' as nchar(32)), 2, 3, cast(n'vwxyz' as nchar(32))), 'ok', 'nok') from t;
select if(insert(vnc, 2, 3, vnc) = insert(cast(n'VWXYZ' as nchar varying(32)), 2, 3, cast(n'VWXYZ' as nchar varying(32))), 'ok', 'nok') from t;
drop table t;

-- error
select insert(cast(n'abcdefghijk' as nchar varying(32)), 5, 3, 'XXX');
select insert(cast(n'abcdefghijk' as nchar(32)), 5, 3, 'XXX');
select insert(cast('abcdefghijk' as char varying(32)), 5, 3, n'XXX');
select insert(cast('abcdefghijk' as char(32)), 5, 3, n'XXX');


--2. Test numeric types
select if(insert(cast(12345 as short), 3, 2, cast(99 as short)) = '12995', 'ok', 'nok');
select if(insert(cast(12345 as integer), 3, 2, cast(99 as integer)) = '12995', 'ok', 'nok');
select if(insert(cast(12345 as bigint), 3, 2, cast(99 as bigint)) = '12995', 'ok', 'nok');

select if(insert(cast(12345.123 as float), 3, 2, cast(9.9 as float)) = '129.95.12', 'ok', 'nok');
select if(insert(cast(12345.123 as double), 3, 2, cast(9.9 as double)) = '129.95.123', 'ok', 'nok');
select if(insert(cast(12345.12345 as monetary), 3, 2, cast(9.9 as monetary)) = '$1$9.945.12', 'ok', 'nok');

select if(insert(12345.123F, 3, 2, 9.9F) = '129.95.12', 'ok', 'nok');
select if(insert(12345.123E0, 3, 2, 9.9E0) = '129.95.123', 'ok', 'nok');
select if(insert($12345.12345, 3, 2, $9.9) = '$1$9.945.12', 'ok', 'nok');

-- server side
create table t (s short, i integer, bi bigint, f float, d double, m monetary);
insert into t values(12345, 12345, 12345, 12345, 12345, 12345);
select if(insert(s, 2, 3, s) = insert(cast(12345 as short), 2, 3, cast(12345 as short)), 'ok', 'nok') from t;
select if(insert(i, 2, 3, i) = insert(cast(12345 as int), 2, 3, cast(12345 as int)), 'ok', 'nok') from t;
select if(insert(bi, 2, 3, bi) = insert(cast(12345 as bigint), 2, 3, cast(12345 as bigint)), 'ok', 'nok') from t;
select if(insert(f, 2, 3, f) = insert(cast(12345 as float), 2, 3, cast(12345 as float)), 'ok', 'nok') from t;
select if(insert(d, 2, 3, d) = insert(cast(12345 as double), 2, 3, cast(12345 as double)), 'ok', 'nok') from t;
select if(insert(m, 2, 3, m) = insert(cast(12345 as monetary), 2, 3, cast(12345 as monetary)), 'ok', 'nok') from t;
drop table t;


--3. Test date/time types
select if(insert(date'2010-07-30', 4, 2, date'2010-08-01') = '07/08/01/2010/2010', 'ok', 'nok');
select if(insert(time'09:30:30', 4, 2, time'15:40:40') = '09:03:40:40 PM:30 AM', 'ok', 'nok');
select if(insert(datetime'2010-07-30 09:30:30', 4, 2, datetime'2010-08-01 15:40:40') = '09:03:40:40.000 PM 08/01/2010:30.000 AM 07/30/2010', 'ok', 'nok');
select if(insert(timestamp'2010-07-30 09:30:30', 4, 2, timestamp'2010-08-01 15:40:40') = '09:03:40:40 PM 08/01/2010:30 AM 07/30/2010', 'ok', 'nok');

-- server side
create table t (d date, t time, dt datetime, ts timestamp);
insert into t values(date'2010-07-30', time'09:30:30', datetime'2010-07-30 09:30:30', timestamp'2010-07-30 09:30:30');
select if(insert(d, 4, 2, d) = insert(date'2010-07-30', 4, 2, date'2010-07-30'), 'ok', 'nok') from t;
select if(insert(t, 4, 2, t) = insert(time'09:30:30', 4, 2, time'09:30:30'), 'ok', 'nok') from t;
select if(insert(dt, 4, 2, dt) = insert(datetime'2010-07-30 09:30:30', 4, 2, datetime'2010-07-30 09:30:30'), 'ok', 'nok') from t;
select if(insert(ts, 4, 2, ts) = insert(timestamp'2010-07-30 09:30:30', 4, 2, timestamp'2010-07-30 09:30:30'), 'ok', 'nok') from t;
drop table t;

--4. Test bit types
-- TBD

--5. Test the range of pos and len
-- out of range of pos
select if(insert('abcde', 0, 3, 'X') = insert('abcde', 7, 3, 'X'), 'ok', 'nok');

select if(insert('abcde', 6, 3, 'xxxxx') = 'abcdexxxxx', 'ok', 'nok');

-- a negative value of len
select if(insert('abcde', 2, -1, 'x') = insert('abcde', 2, 4, 'x'), 'ok', 'nok'); 

-- floating-point number
select if(insert('abcde', 1.5, 3, 'xxxxx') = insert('abcde', 2.4, 3, 'xxxxx'), 'ok', 'nok');
select if(insert('abcde', 2, 2.5, 'xxxxx') = insert('abcde', 2, 3.4, 'xxxxx'), 'ok', 'nok');
select if(insert('abcde', 2, -0.5, 'x') = insert('abcde', 2, -1, 'x'), 'ok', 'nok'); 
select if(insert('abcde', 2, -0.4, 'x') = insert('abcde', 2, 0, 'x'), 'ok', 'nok'); 

-- other types - TBD
select insert('abcde', '1', 3, 'x');
select insert('abcde', n'1', 3, 'x');
select insert('abcde', $1, 3, 'x');

-- wrong types
select insert('abcde', current_date, 3, 'x');
select insert('abcde', current_time, 3, 'x');
select insert('abcde', current_datetime, 3, 'x');
select insert('abcde', current_timestamp, 3, 'x');
select insert('abcde', cast(B'1' as bit(1)), 3, 'x');
select insert('abcde', cast(B'1' as bit varying(1)), 3, 'x');

select insert('abcde', 1, current_date, 'x');
select insert('abcde', 1, current_time, 'x');
select insert('abcde', 1, current_datetime, 'x');
select insert('abcde', 1, current_timestamp, 'x');
select insert('abcde', 1, cast(B'1' as bit(1)), 'x');
select insert('abcde', 1, cast(B'1' as bit varying(1)), 'x');

-- NULL is given
select if(insert(null, 1, 3, 'x') is null, 'ok', 'nok');
select if(insert('abcde', null, 3, 'x') is null, 'ok', 'nok');
select if(insert('abcde', 1, null, 'x') is null, 'ok', 'nok');
select if(insert('abcde', 1, 3, null) is null, 'ok', 'nok');

--6. Test host variables
-- success
prepare s from 'select if(insert(?, ?, ?, ?) = ?, ''ok'', ''nok'')';
execute s using 'abcdefghijk', 5, 3, 'XXX', 'abcdXXXhijk';
execute s using 12345, 3, 2, 99, '12995';
execute s using 12345.123, 3, 2, 9.9, '129.95.123';
execute s using 12345.123f, 3, 2, 9.9, '129.95.12';
execute s using 12345.123e0, 3, 2, 9.9, '129.95.123';
execute s using $12345.12345, 3, 2, $9.9, '$1$9.945.12';
execute s using date'2010-07-30', 4, 2, date'2010-08-01', '07/08/01/2010/2010';
execute s using time'09:30:30', 4, 2, time'15:40:40', '09:03:40:40 PM:30 AM';
execute s using datetime'2010-07-30 09:30:30', 4, 2, datetime'2010-08-01 15:40:40', '09:03:40:40.000 PM 08/01/2010:30.000 AM 07/30/2010';
execute s using timestamp'2010-07-30 09:30:30', 4, 2, timestamp'2010-08-01 15:40:40', '09:03:40:40 PM 08/01/2010:30 AM 07/30/2010';
execute s using 'abcde', 6, 3, 'xxxxx', 'abcdexxxxx';
execute s using 0b0001001000110100, 1, 2, 'x', 'x34';
execute s using 0b0001001000110100, 1, 2, 0b10001000, '8834';
deallocate prepare s;

prepare s from 'select if(insert(''abcde'', ?, ?, ?) = insert(''abcde'', ?, ?, ?), ''ok'', ''nok'')';
execute s using 0, 3, 'X', 7, 3, 'X';
execute s using 2, -1, 'x', 2, 4, 'x';
execute s using 1.5, 3, 'xxxxx', 2.4, 3, 'xxxxx';
execute s using 2, 2.5, 'xxxxx', 2, 3.4, 'xxxxx';
execute s using 2, -0.5, 'x', 2, -1, 'x';
execute s using 2, -0.4, 'x', 2, 0, 'x';
execute s using 1.5f, 3, 'xxxxx', 2.4f, 3, 'xxxxx';
execute s using 2, 2.5f, 'xxxxx', 2, 3.4f, 'xxxxx';
execute s using 2, -0.5e0, 'x', 2, -1, 'x';
execute s using 2, -0.4e0, 'x', 2, 0, 'x';
deallocate prepare s;

-- failure
prepare s from 'select insert(?, ?, ?, ?)';
execute s using 'abcde', 'a', 2, 'x';
execute s using 'abcde', 1, 'a', 'x';
execute s using 'abcde', n'a', 2, 'x';
execute s using 'abcde', 1, n'a', 'x';
execute s using n'abcde', 1, 2, 'x';
execute s using 'abcde', 1, 2, n'x';
execute s using 'abcde', date'2010-09-02', 1, 'x';
execute s using 'abcde', 1, date'2010-09-02', 'x';
execute s using 'abcde', datetime'2010-09-02 16:30:30', 1, 'x';
execute s using 'abcde', 1, datetime'2010-09-02 16:30:30', 'x';
execute s using 'abcde', timestamp'2010-09-02 16:30:30', 1, 'x';
execute s using 'abcde', 1, timestamp'2010-09-02 16:30:30', 'x';
execute s using 'abcde', time'16:30:30', 1, 'x';
execute s using 'abcde', 1, time'16:30:30', 'x';
execute s using 'abcde', 1, 0b0001, 'x';
execute s using 'abcde', 0b0001, 1, 'x';
-- failure, cannot coerce nchar to varchar;
execute s using n'abcde', 1, 2, n'x';
deallocate prepare s;


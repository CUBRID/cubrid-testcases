--cases from dev


select substring_index('www.cubrid.org','.','2');
select substring_index('www.cubrid.org','.','2.3');
select substring_index('www.cubrid.org',':','2.3');
select substring_index('www.cubrid.org','cubrid',1);
select substring_index('www.cubrid.org','.',100);


--1. Test string types
select if(substring_index(cast('abc.def.ghi.jkl' as char(64)), cast('.' as char(1)), 2) = 'abc.def', 'ok', 'nok');
select if(substring_index(cast('abc.def.ghi.jkl' as char varying(64)), cast('.' as char varying(32)), 2) = 'abc.def', 'ok', 'nok');
select if(substring_index(cast(n'abc.def.ghi.jkl' as nchar(64)), cast(n'.' as nchar(1)), 2) = n'abc.def', 'ok', 'nok');
select if(substring_index(cast(n'abc.def.ghi.jkl' as nchar varying(64)), cast(n'.' as nchar varying(32)), 2) = n'abc.def', 'ok', 'nok');
select if(substring_index(cast('abc.def.ghi.jkl' as char(64)), cast('.' as char(1)), -2) = 'ghi.jkl', 'ok', 'nok');
select if(substring_index(cast('abc.def.ghi.jkl' as char varying(64)), cast('.' as char varying(32)), -2) = 'ghi.jkl', 'ok', 'nok');
select if(substring_index(cast(n'abc.def.ghi.jkl' as nchar(64)), cast(n'.' as nchar(1)), -2) = n'ghi.jkl', 'ok', 'nok');
select if(substring_index(cast(n'abc.def.ghi.jkl' as nchar varying(64)), cast(n'.' as nchar varying(32)), -2) = n'ghi.jkl', 'ok', 'nok');

-- error
select substring_index(cast(n'abc.def.ghi.jkl' as nchar varying(64)), cast('.' as char varying(32)), 2);
select substring_index(cast('abc.def.ghi.jkl' as char varying(64)), cast(n'.' as nchar varying(32)), 2);
select substring_index(cast(n'abc.def.ghi.jkl' as nchar(64)), cast('.' as char(32)), 2);
select substring_index(cast('abc.def.ghi.jkl' as char(64)), cast(n'.' as nchar(32)), 2);
select substring_index(cast(n'abc.def.ghi.jkl' as nchar(64)), cast('.' as char varying(32)), 2);
select substring_index(cast('abc.def.ghi.jkl' as char varying(64)), cast(n'.' as nchar(32)), 2);
select substring_index(cast(n'abc.def.ghi.jkl' as nchar varying(64)), cast('.' as char(32)), 2);
select substring_index(cast('abc.def.ghi.jkl' as char(64)), cast(n'.' as nchar varying(32)), 2);

-- server side
create table t (c char(32), vc varchar(32), nc nchar(32), vnc nchar varying(32));
insert into t values('abc.def.ghi.jkl', 'ABC.DEF.GHI.JKL', n'abc.def.ghi.jkl', n'ABC.DEF.GHI.JKL');
select if(substring_index(c, '.', 2) = substring_index('abc.def.ghi.jkl', '.', 2), 'ok', 'nok') from t;
select if(substring_index(vc, '.', 2) = substring_index('ABC.DEF.GHI.JKL', '.', 2), 'ok', 'nok') from t;
select if(substring_index(nc, n'.', 2) = substring_index(n'abc.def.ghi.jkl', n'.', 2), 'ok', 'nok') from t;
select if(substring_index(vnc, n'.', 2) = substring_index(n'ABC.DEF.GHI.JKL', n'.', 2), 'ok', 'nok') from t;
select if(substring_index(c, '.', -2) = substring_index('abc.def.ghi.jkl', '.', -2), 'ok', 'nok') from t;
select if(substring_index(vc, '.', -2) = substring_index('ABC.DEF.GHI.JKL', '.', -2), 'ok', 'nok') from t;
select if(substring_index(nc, n'.', -2) = substring_index(n'abc.def.ghi.jkl', n'.', -2), 'ok', 'nok') from t;
select if(substring_index(vnc, n'.', -2) = substring_index(n'ABC.DEF.GHI.JKL', n'.', -2), 'ok', 'nok') from t;
drop table t;

-- long separator
select if(substring_index('abcdefghijkabcdefghijkabcdefghijk', 'defg', 2) = 'abcdefghijkabc', 'ok', 'nok');
select if(substring_index('abcdefghijkabcdefghijkabcdefghijk', 'defghij', 2) = 'abcdefghijkabc', 'ok', 'nok');


--2. Test numeric types
select if(substring_index(cast(12123 as short), cast(2 as short), 2) = '121', 'ok', 'nok');
select if(substring_index(cast(12123 as integer), cast(2 as integer), 2) = '121', 'ok', 'nok');
select if(substring_index(cast(12123 as bigint), cast(2 as bigint), 2) = '121', 'ok', 'nok');
select if(substring_index(cast(12123.456 as float), cast(2 as float), 2) = '121', 'ok', 'nok');
select if(substring_index(cast(12123.456 as double), cast(2 as double), 2) = '121', 'ok', 'nok');
select if(substring_index(cast(12123.456 as numeric(10,5)), cast(2 as numeric(10,0)), 2) = '121', 'ok', 'nok');
select if(substring_index(cast(12123.456 as monetary), '2', 2) = '$121', 'ok', 'nok');

--select if(substring_index(12121.121F, 2F, 2) = '121', 'ok', 'nok');
--select if(substring_index(12121.121E0, 2E0, 2) = '121', 'ok', 'nok');

select if(substring_index(cast(12123 as short), cast(2 as short), -2) = '123', 'ok', 'nok');
select if(substring_index(cast(12123 as integer), cast(2 as integer), -2) = '123', 'ok', 'nok');
select if(substring_index(cast(12123 as bigint), cast(2 as bigint), -2) = '123', 'ok', 'nok');
select if(substring_index(cast(12123.456 as float), cast(2 as float), -2) = '123.456', 'ok', 'nok');
select if(substring_index(cast(12123.456 as double), cast(2 as double), -2) = '123.456', 'ok', 'nok');
select if(substring_index(cast(12123.456 as numeric(10,3)), cast(2 as numeric(10,0)), -2) = '123.456', 'ok', 'nok');
select if(substring_index(cast(12123.456 as monetary), '2', -2) = '123.46', 'ok', 'nok');

-- server side
create table t (s short, i integer, bi bigint, f float, d double, m monetary, n numeric(10,3));
insert into t values(12123, 12123, 12123, 12123.456, 12123.456, 12123.456, 12123.456);
select if(substring_index(s, 2, 2) = '121', 'ok', 'nok') from t;
select if(substring_index(i, 2, 2) = '121', 'ok', 'nok') from t;
select if(substring_index(bi, 2, 2) = '121', 'ok', 'nok') from t;
select if(substring_index(f, 2, 2) = '121', 'ok', 'nok') from t;
select if(substring_index(d, 2, 2) = '121', 'ok', 'nok') from t;
select if(substring_index(n, 2, 2) = '121', 'ok', 'nok') from t;
select if(substring_index(m, 2, 2) = '$121', 'ok', 'nok') from t;
select if(substring_index(s, 2, -2) = '123', 'ok', 'nok') from t;
select if(substring_index(i, 2, -2) = '123', 'ok', 'nok') from t;
select if(substring_index(bi, 2, -2) = '123', 'ok', 'nok') from t;
select if(substring_index(f, 2, -2) = '123.456', 'ok', 'nok') from t;
select if(substring_index(d, 2, -2) = '123.456', 'ok', 'nok') from t;
select if(substring_index(n, 2, -2) = '123.456', 'ok', 'nok') from t;
select if(substring_index(m, 2, -2) = '123.46', 'ok', 'nok') from t;
drop table t;


--3. Test date/time types
select if(substring_index(date'08/02/2010', '/', 2) = '08/02', 'ok', 'nok');
select if(substring_index(time'09:30:30 AM', ':', 2) = '09:30', 'ok', 'nok');
select if(substring_index(datetime'09:30:30.000 AM 08/02/2010', ' ', 2) = '09:30:30.000 AM', 'ok', 'nok');
select if(substring_index(timestamp'09:30:30 AM 08/02/2010', ' ', 2) = '09:30:30 AM', 'ok', 'nok');

select if(substring_index(date'08/02/2010', '/', -2) = '02/2010', 'ok', 'nok');
select if(substring_index(time'09:30:30 AM', ':', -2) = '30:30 AM', 'ok', 'nok');
select if(substring_index(datetime'09:30:30.000 AM 08/02/2010', ' ', -2) = 'AM 08/02/2010', 'ok', 'nok');
select if(substring_index(timestamp'09:30:30 AM 08/02/2010', ' ', -2) = 'AM 08/02/2010', 'ok', 'nok');

-- server side
create table t (d date, t time, dt datetime, ts timestamp);
insert into t values(date'2010-07-30', time'09:30:30', datetime'2010-07-30 09:30:30', timestamp'2010-07-30 09:30:30');
select if(substring_index(d, '/', 2) = '07/30', 'ok', 'nok') from t;
select if(substring_index(t, ':', 2) = '09:30', 'ok', 'nok') from t;
select if(substring_index(dt, ' ', 2) = '09:30:30.000 AM', 'ok', 'nok') from t;
select if(substring_index(ts, ' ', 2) = '09:30:30 AM', 'ok', 'nok') from t;
select if(substring_index(d, '/', -2) = '30/2010', 'ok', 'nok') from t;
select if(substring_index(t, ':', -2) = '30:30 AM', 'ok', 'nok') from t;
select if(substring_index(dt, ' ', -2) = 'AM 07/30/2010', 'ok', 'nok') from t;
select if(substring_index(ts, ' ', -2) = 'AM 07/30/2010', 'ok', 'nok') from t;
drop table t;

--4. Check the range of count
select if(substring_index('abc.def.ghi.jkl', '.', 4) = substring_index('abc.def.ghi.jkl', '.', 5), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', -4) = substring_index('abc.def.ghi.jkl', '.', -5), 'ok', 'nok');
select if(length(substring_index('abc.def.ghi.jkl', '.', 0)) = 0, 'ok', 'nok');
select if(substring_index(n'abc.def.ghi.jkl', n'.', 4) = substring_index(n'abc.def.ghi.jkl', n'.', 5), 'ok', 'nok');
select if(substring_index(n'abc.def.ghi.jkl', n'.', -4) = substring_index(n'abc.def.ghi.jkl', n'.', -5), 'ok', 'nok');
select if(length(substring_index(n'abc.def.ghi.jkl', n'.', 0)) = 0, 'ok', 'nok');

-- should be no assertion
select substring_index(n'123123', n'2', 0);

-- rounding
select if(substring_index('abc.def.ghi.jkl', '.', cast(1.5 as float)) = substring_index('abc.def.ghi.jkl', '.', 2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(1.5 as double)) = substring_index('abc.def.ghi.jkl', '.', 2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(-1.5 as float)) = substring_index('abc.def.ghi.jkl', '.', -2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(-1.5 as double)) = substring_index('abc.def.ghi.jkl', '.', -2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(2.4 as float)) = substring_index('abc.def.ghi.jkl', '.', 2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(2.4 as double)) = substring_index('abc.def.ghi.jkl', '.', 2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(-2.4 as float)) = substring_index('abc.def.ghi.jkl', '.', -2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(-2.4 as double)) = substring_index('abc.def.ghi.jkl', '.', -2), 'ok', 'nok');

-- error on numeric/monetary
--TBD

--5. Exceptions
-- return NULL
select if(substring_index(null, '.', -1) is null, 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', null, -1) is null, 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', null) is null, 'ok', 'nok');

-- empty separator
select if(length(substring_index('abc.def.ghi.jkl', '', 2)) = 0, 'ok', 'nok');
-- should be no assertion
select substring_index('abc.def.ghi.jkl', '', 2);

--6. Test host variable
-- success
prepare s from 'select if(substring_index(?, ?, ?) = ?, ''ok'', ''nok'')';
execute s using 'abc.def.ghi.jkl', '.', 2, 'abc.def';
execute s using 'abc.def.ghi.jkl', '.', -2, 'ghi.jkl';
execute s using 'abcdefghijkabcdefghijkabcdefghijk', 'defg', 2, 'abcdefghijkabc';
execute s using 'abcdefghijkabcdefghijkabcdefghijk', 'defghij', 2, 'abcdefghijkabc';
execute s using 12123, 2, 2, '121';
execute s using 12123.456, 2, 2, '121';
execute s using 12123.456f, 2, 2, '121';
execute s using 12123.456e0, 2, 2, '121';
execute s using $12123.456, 2, 2, '$121';
execute s using 12123, 2, -2, '123';
execute s using 12123.456, 2, -2, '123.456';
execute s using 12123.456f, 2, -2, '123.456';
execute s using 12123.456e0, 2, -2, '123.456';
execute s using $12123.456, 2, -2, '123.46';
execute s using date'08/02/2010', '/', 2, '08/02';
execute s using time'09:30:30 AM', ':', 2, '09:30';
execute s using datetime'09:30:30.000 AM 08/02/2010', ' ', 2, '09:30:30.000 AM';
execute s using timestamp'09:30:30 AM 08/02/2010', ' ', 2, '09:30:30 AM';
execute s using date'08/02/2010', '/', -2, '02/2010';
execute s using time'09:30:30 AM', ':', -2, '30:30 AM';
execute s using datetime'09:30:30.000 AM 08/02/2010', ' ', -2, 'AM 08/02/2010';
execute s using timestamp'09:30:30 AM 08/02/2010', ' ', -2, 'AM 08/02/2010';
deallocate prepare s;

prepare s from 'select if(length(substring_index(?, ?, ?)) = ?, ''ok'', ''nok'')';
execute s using 'abc.def.ghi.jkl', '.', 0, 0;
deallocate prepare s;

prepare s from 'select if(substring_index(''abc.def.ghi.jkl'', ''.'', ?) = substring_index(''abc.def.ghi.jkl'', ''.'', ?), ''ok'', ''nok'')';
execute s using 4, 5;
execute s using -4, -5;
execute s using 1.5, 2.0; 
execute s using 1.5f, 2.0f;
execute s using 1.5e0, 2e0;
execute s using 2.4, 2.0 ;
execute s using 2.4f, 2.0f;
execute s using 2.4e0, 2e0;
execute s using -1.5, -2.0 ;
execute s using -1.5f, -2.0f;
execute s using -1.5e0, -2e0;
execute s using -2.4, -2.0 ;
execute s using -2.4f, -2.0f;
execute s using -2.4e0, -2e0;
deallocate prepare s;

-- failure
prepare s from 'select substring_index(?, ?, ?)';
execute s using n'abc.def.ghi.jkl', n'.', 2;
execute s using 'abc.def.ghi.jkl', '.', 'a';
execute s using 'abc.def.ghi.jkl', '.', 0b1111;
execute s using 'abc.def.ghi.jkl', '.', date'08/02/2010';
execute s using 'abc.def.ghi.jkl', '.', time'09:30:30 AM';
execute s using 'abc.def.ghi.jkl', '.', datetime'09:30:30.000 AM 08/02/2010';
execute s using 'abc.def.ghi.jkl', '.', timestamp'09:30:30 AM 08/02/2010';
deallocate prepare s;


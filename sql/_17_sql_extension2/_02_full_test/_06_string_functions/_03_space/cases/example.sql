--+ holdcas on;
--cases from dev

set system parameters 'string_max_size_bytes=1048576';

select space(8);
select length(space(1048576));
select length(space(1048577));

set system parameters 'string_max_size_bytes=33554432';
select length(space('33554432'));
select length(space('33554433'));

select space('aaa');



--1. test numeric types
select if(length(space(cast(12345 as short))) = 12345, 'ok', 'nok');
select if(length(space(cast(12345 as integer))) = 12345, 'ok', 'nok');
select if(length(space(cast(12345 as bigint))) = 12345, 'ok', 'nok');
select if(length(space(cast(12345.5 as float))) = 12346, 'ok', 'nok');
select if(length(space(cast(12345.4 as float))) = 12345, 'ok', 'nok');
select if(length(space(cast(12345.5 as double))) = 12346, 'ok', 'nok');
select if(length(space(cast(12345.4 as double))) = 12345, 'ok', 'nok');
select if(length(space(cast(12345.5 as numeric(10,5)))) = 12346, 'ok', 'nok');
select if(length(space(cast(12345.4 as numeric(10,5)))) = 12345, 'ok', 'nok');

-- server side
create table t (s short, i integer, bi bigint, f float, d double, m monetary, n numeric(10,5));
insert into t values(12345, 12345, 12345, 12345.5, 12345.5, 12345.5, 12345.5);
select if(length(space(s)) = s, 'ok', 'nok') from t;
select if(length(space(i)) = i, 'ok', 'nok') from t;
select if(length(space(bi)) = bi, 'ok', 'nok') from t;
insert into t values(12345, 12345, 12345, 12345.4, 12345.4, 12345.4, 12345.4);
select if(length(space(f)) = round(f), 'ok', 'nok') from t;
select if(length(space(d)) = round(d), 'ok', 'nok') from t;
select if(length(space(m)) = round(m), 'ok', 'nok') from t;
select if(length(space(n)) = round(n), 'ok', 'nok') from t;
drop table t;

--2. Test unsupported types
-- TBD
select space(cast('1' as char(8)));
select space(cast('1' as varchar(8)));
select space(cast(n'1' as nchar(8)));
select space(cast(n'1' as nchar varying(8)));
select space(cast(B'1' as bit(8)));
select space(cast(B'1' as bit varying(8)));
select space(current_date);
select space(current_time);
select space(current_datetime);
select space(current_timestamp);

--3. Check the result
-- check whether the result includes only space character
select if(length(trim(space(cast(12345 as short)))) = 0, 'ok', 'nok'); 
-- check the length
select if(length(space(1073741823)) = 1073741823, 'ok', 'nok');

--4. Test host variables
-- success
prepare s from 'select if(length(space(?)) = ?, ''ok'', ''nok'')';
execute s using 12345, 12345;
execute s using 12345.5, 12346;
execute s using 12345.5f, 12346;
execute s using 12345.5e0, 12346;
execute s using 12345.4, 12345;
execute s using 12345.4f, 12345;
execute s using 12345.4e0, 12345;
deallocate prepare s;

-- failure
prepare s from 'select space(?)';
execute s using b'1';
execute s using 0b1;
execute s using date'2010-09-02';
execute s using time'17:30:30';
execute s using datetime'2010-09-02 17:30:30';
execute s using timestamp'2010-09-02 17:30:30';
-- the following queries should be succeeded when implicit type conversion is introduced
execute s using '1';
execute s using n'1';
deallocate prepare s;


set system parameters 'string_max_size_bytes=1048576';
commit;
--+ holdcas off;

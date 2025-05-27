--+ holdcas on;
-- all hostvars in case
prepare s from 'select case ? when ? then ? when ? then ? else ? end';

-- hostvars of different types
select cast(10 as smallint)          into :_smallint;
select cast(100 as int)              into :_int;
select cast(1000 as bigint)          into :_bigint;
select cast(123.45 as numeric(5, 2)) into :_numeric;
select cast(123.45 as float)         into :_float;
select cast(123.45 as double)        into :_double;
select cast(123.45 as monetary)      into :_monetary;

select cast('2012-02-24' as date)                 into :_date;
select cast('11:28:03' as time)                   into :_time;
select cast('2012-02-24 11:28:03.82' as datetime) into :_datetime;
select cast('2012-02-24 11:28:03.0' as timestamp) into :_timestamp;

select cast('abc' as char(10))           into :_char;
select cast('abc' as char varying(10))   into :_varchar;
select cast(N'abc' as nchar(10))         into :_nchar;
select cast(N'abc' as nchar varying(10)) into :_varnchar;

select cast(B'101' as bit(10))           into :_bit;
select cast(B'101' as bit varying(10))   into :_varbit;

-- all null
execute s using null, null, null, null, null, null;

-- check type coercion for arguments
execute s using 1, 1, :_smallint, 2, :_int, :_bigint;
execute s using 2, 1, :_smallint, 2, :_int, :_bigint;
execute s using 3, 1, :_smallint, 2, :_int, :_bigint;

execute s using 1, 1, :_int, 2, :_bigint, :_numeric;
execute s using 2, 1, :_int, 2, :_bigint, :_numeric;
execute s using 3, 1, :_int, 2, :_bigint, :_numeric;

execute s using 1, 1, :_bigint, 2, :_float, :_numeric;
execute s using 2, 1, :_bigint, 2, :_float, :_numeric;
execute s using 3, 1, :_bigint, 2, :_float, :_numeric;

execute s using 1, 1, :_monetary, 2, :_float, :_numeric;
execute s using 2, 1, :_monetary, 2, :_float, :_numeric;
execute s using 3, 1, :_monetary, 2, :_float, :_numeric;

execute s using 1, 1, :_date, 2, :_float, :_char;
execute s using 2, 1, :_date, 2, :_float, :_char;
execute s using 3, 1, :_date, 2, :_float, :_char;

execute s using 1, 1, :_time, 2, :_datetime, :_char;
execute s using 2, 1, :_time, 2, :_datetime, :_char;
execute s using 3, 1, :_time, 2, :_datetime, :_char;

execute s using 1, 1, :_timestamp, 2, :_bit, :_varchar;
execute s using 2, 1, :_timestamp, 2, :_bit, :_varchar;
execute s using 3, 1, :_timestamp, 2, :_bit, :_varchar;

execute s using 1, 1, :_numeric, 2, :_varbit, :_varchar;
execute s using 2, 1, :_numeric, 2, :_varbit, :_varchar;
execute s using 3, 1, :_numeric, 2, :_varbit, :_varchar;

-- nchar cannot be coerced to varchar
execute s using 1, 1, _nchar, 2, _nchar, 3, _nchar;
execute s using 1, 1, _varnchar, 2, _varnchar, 3, _varnchar;

-- check logical expressions with compatible types
execute s using :_int, :_int, 'first', :_bigint, 'second', 'else';
execute s using :_bigint, :_int, 'first', :_bigint, 'second', 'else';

execute s using :_numeric, :_numeric, 'first', null, 'second', 'else';
execute s using :_float, :_numeric, 'first', null, 'second', 'else';
execute s using :_double, :_numeric, 'first', null, 'second', 'else';
execute s using :_monetary, :_numeric, 'first', null, 'second', 'else';

execute s using :_date, :_date, 'first', :_datetime, 'second', 'else';
execute s using :_datetime, :_date, 'first', :_datetime, 'second', 'else';

execute s using :_char, :_nchar, 'first', :_varnchar, 'second', 'else';
execute s using :_char, :_int, 'first', :_varnchar, 'second', 'else';
execute s using :_char, :_bit, 'first', :_varbit, 'second', 'else';

-- check logical expressions with weird types
execute s using :_smallint, :_bit, 'first', :_date, 'second', 'else';
execute s using :_double, :_char, 'first', :_time, 'second', 'else';
execute s using :_timestamp, :_monetary, 'first', :_numeric, 'second', 'else';

deallocate prepare s;


-- one type in case (will force expected domain for hostvars)
prepare s from 'select case ? when ? then ? when ? then ? when 3 then ? else cast(1 as smallint) end';
execute s using 2, 1, :_smallint, 2, :_int, :_bigint;
execute s using 2, 1, :_int, 2, :_bigint, :_numeric;
execute s using 2, 1, :_bigint, 2, :_float, :_numeric;
execute s using 2, 1, :_monetary, 2, :_float, :_numeric;
execute s using 2, 1, :_date, 2, :_float, :_char;
execute s using 2, 1, :_time, 2, :_datetime, :_char;
execute s using 2, 1, :_timestamp, 2, :_bit, :_varchar;
execute s using 2, 1, :_numeric, 2, :_varbit, :_varchar;
deallocate prepare s;

prepare s from 'select case ? when ? then ? when ? then ? when 3 then ? else cast(''101'' as char(10)) end';
execute s using 2, 1, :_smallint, 2, :_int, :_bigint;
execute s using 2, 1, :_int, 2, :_bigint, :_numeric;
execute s using 2, 1, :_bigint, 2, :_float, :_numeric;
execute s using 2, 1, :_monetary, 2, :_float, :_numeric;
execute s using 2, 1, :_date, 2, :_float, :_char;
execute s using 2, 1, :_time, 2, :_datetime, :_char;
execute s using 2, 1, :_timestamp, 2, :_bit, :_varchar;
execute s using 2, 1, :_numeric, 2, :_varbit, :_varchar;
deallocate prepare s;

prepare s from 'select case ? when ? then ? when ? then ? when 3 then ? else cast(''2012-01-01'' as date) end';
execute s using 2, 1, :_smallint, 2, :_int, :_bigint;
execute s using 2, 1, :_int, 2, :_bigint, :_numeric;
execute s using 2, 1, :_bigint, 2, :_float, :_numeric;
execute s using 2, 1, :_monetary, 2, :_float, :_numeric;
execute s using 2, 1, :_date, 2, :_float, :_char;
execute s using 2, 1, :_time, 2, :_datetime, :_timestamp;
execute s using 2, 1, :_date, 2, :_datetime, :_timestamp;
execute s using 2, 1, :_numeric, 2, :_varbit, :_varchar;
deallocate prepare s;

commit;
--+ holdcas off;

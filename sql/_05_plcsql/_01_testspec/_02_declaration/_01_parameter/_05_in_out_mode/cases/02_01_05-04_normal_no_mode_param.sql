--+ server-message on

-- normal: IN can be used for each parameter


create or replace procedure t(
    p_short short,
    p_smallint smallint,
    p_integer integer,
    p_int int,
    p_bigint bigint,
    p_numeric numeric,
    p_decimal decimal,
    p_float float,
    p_real real,
    p_double double,
    p_double_precision double precision,
    p_date date,
    p_time time,
    p_timestamp timestamp,
    p_datetime datetime,
    p_char char,
    p_varchar varchar,
    p_string string,
    p_char_varying char varying) as
begin
    dbms_output.put_line('p_short '              || p_short);
    dbms_output.put_line('p_smallint '           || p_smallint);
    dbms_output.put_line('p_integer '            || p_integer);
    dbms_output.put_line('p_int '                || p_int);
    dbms_output.put_line('p_bigint '             || p_bigint);
    dbms_output.put_line('p_numeric '            || p_numeric);
    dbms_output.put_line('p_decimal '            || p_decimal);
    dbms_output.put_line('p_float '              || p_float);
    dbms_output.put_line('p_real '               || p_real);
    dbms_output.put_line('p_double '             || p_double);
    dbms_output.put_line('p_double_precision '   || p_double_precision);
    dbms_output.put_line('p_date '               || p_date);
    dbms_output.put_line('p_time '               || p_time);
    dbms_output.put_line('p_timestamp '          || p_timestamp);
    dbms_output.put_line('p_datetime '           || p_datetime);
    dbms_output.put_line('p_char '               || p_char);
    dbms_output.put_line('p_varchar '            || p_varchar);
    dbms_output.put_line('p_string '             || p_string);
    dbms_output.put_line('p_char_varying '       || p_char_varying);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(
    cast(1 as short),
    cast(2 as smallint),
    cast(3 as integer),
    cast(4 as int),
    cast(5 as bigint),
    cast(6 as numeric),
    cast(7 as decimal),
    cast(1.1 as float),
    cast(2.2 as real),
    cast(3.3 as double),
    cast(4.4 as double precision),
    date'2002-10-09',
    time'23:11:11',
    timestamp'2002-10-09 23:11:11',
    datetime'2002-10-09 23:11:11.123',
    cast('a' as char),
    cast('b' as varchar),
    cast('c' as string),
    cast('d' as char varying));

drop procedure t;


--+ server-message off

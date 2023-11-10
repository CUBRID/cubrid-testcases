--+ server-message on

-- normal: IN can be used for each parameter


create or replace procedure t(
    p_short IN short,
    p_smallint IN smallint,
    p_integer IN integer,
    p_int IN int,
    p_bigint IN bigint,
    p_numeric IN numeric,
    p_decimal IN decimal,
    p_float IN float,
    p_real IN real,
    p_double IN double,
    p_double_precision IN double precision,
    p_date IN date,
    p_time IN time,
    p_timestamp IN timestamp,
    p_datetime IN datetime,
    p_char IN char,
    p_varchar IN varchar,
    p_string IN string,
    p_char_varying IN char varying) as
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

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

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


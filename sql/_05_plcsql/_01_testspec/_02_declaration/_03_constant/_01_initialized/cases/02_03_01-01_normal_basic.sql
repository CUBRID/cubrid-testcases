--+ server-message on

-- normal: basic constant declarations


create or replace procedure t(i int) as
    p_boolean constant boolean := true;
    p_sys_refcursor constant sys_refcursor := null;
    p_short constant short := 1;
    p_smallint constant smallint := 2;
    p_integer constant integer := 3;
    p_int constant int := 4;
    p_bigint constant bigint := 5;
    p_numeric constant numeric := 6;
    p_decimal constant decimal := 7;
    p_float constant float := 1.1;
    p_real constant real := 2.2;
    p_double constant double := 3.3;
    p_double_precision constant double precision := 4.4;
    p_date constant date := date'2002-10-09';
    p_time constant time := time'23:11:11';
    p_timestamp constant timestamp := timestamp'2002-10-09 23:11:11';
    p_datetime constant datetime := datetime'2002-10-09 23:11:11.123';
    p_char constant char := 'a';
    p_varchar constant varchar := 'b';
    p_string constant string := 'c';
    p_char_varying constant char varying := 'd';
begin
    dbms_output.put_line('p_boolean is ' || case when p_boolean then 'true' else 'false' end);
    dbms_output.put_line('p_sys_refcursor is ' || case when p_sys_refcursor is null then 'null' else 'non-null' end);
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

call t(7);

drop procedure t;

--+ server-message off

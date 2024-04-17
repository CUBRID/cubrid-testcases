--+ server-message on

-- normal: basic constant declarations


create or replace procedure t(i int) as
    p_boolean constant boolean default true;
    p_sys_refcursor constant sys_refcursor default null;
    p_short constant short default 1;
    p_smallint constant smallint default 2;
    p_integer constant integer default 3;
    p_int constant int default 4;
    p_bigint constant bigint default 5;
    p_numeric constant numeric default 6;
    p_decimal constant decimal default 7;
    p_float constant float default 1.1;
    p_real constant real default 2.2;
    p_double constant double default 3.3;
    p_double_precision constant double precision default 4.4;
    p_date constant date default date'2002-10-09';
    p_time constant time default time'23:11:11';
    p_timestamp constant timestamp default timestamp'2002-10-09 23:11:11';
    p_datetime constant datetime default datetime'2002-10-09 23:11:11.123';
    p_char constant char default 'a';
    p_varchar constant varchar default 'b';
    p_string constant string default 'c';
    p_char_varying constant char varying default 'd';
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

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

--+ server-message off

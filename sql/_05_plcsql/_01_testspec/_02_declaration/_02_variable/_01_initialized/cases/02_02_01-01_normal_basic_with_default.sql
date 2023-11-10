--+ server-message on

-- normal: basic variable declarations with DEFAULT keyword


create or replace procedure t(i int) as
    p_boolean boolean default true;
    p_sys_refcursor sys_refcursor default null;
    p_short short default 1;
    p_smallint smallint default 2;
    p_integer integer default 3;
    p_int int default 4;
    p_bigint bigint default 5;
    p_numeric numeric default 6;
    p_decimal decimal default 7;
    p_float float default 1.1;
    p_real real default 2.2;
    p_double double default 3.3;
    p_double_precision double precision default 4.4;
    p_date date default date'2002-10-09';
    p_time time default time'23:11:11';
    p_timestamp timestamp default timestamp'2002-10-09 23:11:11';
    p_datetime datetime default datetime'2002-10-09 23:11:11.123';
    p_char char default 'a';
    p_varchar varchar default 'b';
    p_string string default 'c';
    p_char_varying char varying default 'd';
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

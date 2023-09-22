--+ server-message on

-- normal: basic variable declarations


create or replace procedure t(i int) as
    p_boolean boolean;
    p_sys_refcursor sys_refcursor;
    p_short short;
    p_smallint smallint;
    p_integer integer;
    p_int int;
    p_bigint bigint;
    p_numeric numeric;
    p_decimal decimal;
    p_float float;
    p_real real;
    p_double double;
    p_double_precision double precision;
    p_date date;
    p_time time;
    p_timestamp timestamp;
    p_datetime datetime;
    p_char char;
    p_varchar varchar;
    p_string string;
    p_char_varying char varying;
begin
    dbms_output.put_line('p_boolean is '            || case when p_boolean is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_sys_refcursor is '      || case when p_sys_refcursor is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_short is '              || case when p_short is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_smallint is '           || case when p_smallint is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_integer is '            || case when p_integer is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_int is '                || case when p_int is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_bigint is '             || case when p_bigint is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_numeric is '            || case when p_numeric is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_decimal is '            || case when p_decimal is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_float is '              || case when p_float is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_real is '               || case when p_real is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_double is '             || case when p_double is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_double_precision is '   || case when p_double_precision is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_date is '               || case when p_date is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_time is '               || case when p_time is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_timestamp is '          || case when p_timestamp is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_datetime is '           || case when p_datetime is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_char is '               || case when p_char is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_varchar is '            || case when p_varchar is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_string is '             || case when p_string is null then 'null' else 'non-null' end);
    dbms_output.put_line('p_char_varying is '       || case when p_char_varying is null then 'null' else 'non-null' end);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

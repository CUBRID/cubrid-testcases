--+ server-message on

-- normal: basic usage of the null literal


create or replace procedure t(i int) as
    p_boolean boolean := null;
    p_sys_refcursor sys_refcursor := null;
    p_short short := null;
    p_smallint smallint := null;
    p_integer integer := null;
    p_int int := null;
    p_bigint bigint := null;
    p_numeric numeric := null;
    p_decimal decimal := null;
    p_float float := null;
    p_real real := null;
    p_double double := null;
    p_double_precision double precision := null;
    p_date date := null;
    p_time time := null;
    p_timestamp timestamp := null;
    p_datetime datetime := null;
    p_char char := null;
    p_varchar varchar := null;
    p_string string := null;
    p_char_varying char varying := null;

begin
    dbms_output.put_line('OK');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


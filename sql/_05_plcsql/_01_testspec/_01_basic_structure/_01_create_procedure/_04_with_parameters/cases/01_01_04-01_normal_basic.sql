--+ server-message on

-- basic CREATE PROCEDURE with a parameter


create or replace procedure t(
    p_short short, p_smallint smallint,
    p_integer integer, p_int int,
    p_bigint bigint,
    p_numeric numeric, p_decimal decimal,
    p_float float, p_real real,
    p_double double, p_double_precision double precision,
    p_date date,
    p_time time,
    p_timestamp timestamp,
    p_datetime datetime,
    p_char char,
    p_varchar varchar,
    p_string string,
    p_char_varying char varying) as
begin
    dbms_output.put_line('OK');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(
    null, null,
    null, null,
    null,
    null, null,
    null, null,
    null, null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null);

drop procedure t;


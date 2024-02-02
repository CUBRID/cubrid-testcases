--+ server-message on

-- normal: parameters with all supported types can be referenced in the declarations and the body


create or replace procedure t(i int) as
    procedure tt(
        p_boolean boolean,
        p_sys_refcursor sys_refcursor,
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

        v_boolean boolean := p_boolean;
        v_sys_refcursor sys_refcursor := p_sys_refcursor;
        v_short short := p_short;
        v_smallint smallint := p_smallint;
        v_integer integer := p_integer;
        v_int int := p_int;
        v_bigint bigint := p_bigint;
        v_numeric numeric := p_numeric;
        v_decimal decimal := p_decimal;
        v_float float := p_float;
        v_real real := p_real;
        v_double double := p_double;
        v_double_precision double precision := p_double_precision;
        v_date date := p_date;
        v_time time := p_time;
        v_timestamp timestamp := p_timestamp;
        v_datetime datetime := p_datetime;
        v_char char := p_char;
        v_varchar varchar := p_varchar;
        v_string string := p_string;
        v_char_varying char varying := p_char_varying;
    begin
        v_boolean := p_boolean;
        v_sys_refcursor := p_sys_refcursor;
        v_short := p_short;
        v_smallint := p_smallint;
        v_integer := p_integer;
        v_int := p_int;
        v_bigint := p_bigint;
        v_numeric := p_numeric;
        v_decimal := p_decimal;
        v_float := p_float;
        v_real := p_real;
        v_double := p_double;
        v_double_precision := p_double_precision;
        v_date := p_date;
        v_time := p_time;
        v_timestamp := p_timestamp;
        v_datetime := p_datetime;
        v_char := p_char;
        v_varchar := p_varchar;
        v_string := p_string;
        v_char_varying := p_char_varying;

        dbms_output.put_line('OK');
    end;
begin
    tt(null,
        null,
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
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

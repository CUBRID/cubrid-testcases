--+ server-message on

-- normal: IN can be used for each parameter


create or replace procedure t(
    p_short INOUT short,
    p_smallint INOUT smallint,
    p_integer INOUT integer,
    p_int INOUT int,
    p_bigint INOUT bigint,
    p_numeric INOUT numeric,
    p_decimal INOUT decimal,
    p_float INOUT float,
    p_real INOUT real,
    p_double INOUT double,
    p_double_precision INOUT double precision,
    p_date INOUT date,
    p_time INOUT time,
    p_timestamp INOUT timestamp,
    p_datetime INOUT datetime,
    p_char INOUT char,
    p_varchar INOUT varchar,
    p_string INOUT string,
    p_char_varying INOUT char varying) as
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

    p_short := 10;
    p_smallint := 20;
    p_integer := 30;
    p_int := 40;
    p_bigint := 50;
    p_numeric := 60;
    p_decimal := 70;
    p_float := 11.1;
    p_real := 22.2;
    p_double := 33.3;
    p_double_precision := 44.4;
    p_date := date'2002-10-11';
    p_time := time'03:01:01';
    p_timestamp := timestamp'2002-10-11 03:01:01';
    p_datetime := datetime'2002-10-11 03:01:01.123';
    p_char := 'A';
    p_varchar := 'B';
    p_string := 'C';
    p_char_varying := 'D';
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

select cast(1 as short) into :a from dual;
select cast(2 as smallint) into :b from dual;
select cast(3 as integer) into :c from dual;
select cast(4 as int) into :d from dual;
select cast(5 as bigint) into :e from dual;
select cast(6 as numeric) into :f from dual;
select cast(7 as decimal) into :g from dual;
select cast(1.1 as float) into :h from dual;
select cast(2.2 as real) into :i from dual;
select cast(3.3 as double) into :j from dual;
select cast(4.4 as double precision) into :k from dual;
select date'2002-10-09' into :l from dual;
select time'23:11:11' into :m from dual;
select timestamp'2002-10-09 23:11:11' into :n from dual;
select datetime'2002-10-09 23:11:11.123' into :o from dual;
select cast('a' as char) into :p from dual;
select cast('b' as varchar) into :q from dual;
select cast('c' as string) into :r from dual;
select cast('d' as char varying) into :s from dual;

call t(:a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k, :l, :m, :n, :o, :p, :q, :r, :s);

select :a from dual;
select :b from dual;
select :c from dual;
select :d from dual;
select :e from dual;
select :f from dual;
select :g from dual;
select :h from dual;
select :i from dual;
select :j from dual;
select :k from dual;
select :l from dual;
select :m from dual;
select :n from dual;
select :o from dual;
select :p from dual;
select :q from dual;
select :r from dual;
select :s from dual;

drop procedure t;


--+ server-message off

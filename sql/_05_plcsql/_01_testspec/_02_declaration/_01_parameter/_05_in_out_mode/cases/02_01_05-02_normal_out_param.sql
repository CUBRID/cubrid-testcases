--+ server-message on

-- normal: OUT can be used for each parameter


create or replace procedure t(
    p_short OUT short,
    p_smallint OUT smallint,
    p_integer OUT integer,
    p_int OUT int,
    p_bigint OUT bigint,
    p_numeric OUT numeric,
    p_decimal OUT decimal,
    p_float OUT float,
    p_real OUT real,
    p_double OUT double,
    p_double_precision OUT double precision,
    p_date OUT date,
    p_time OUT time,
    p_timestamp OUT timestamp,
    p_datetime OUT datetime,
    p_char OUT char,
    p_varchar OUT varchar,
    p_string OUT string,
    p_char_varying OUT char varying) as
begin
    dbms_output.put_line(case when p_short is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_smallint is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_integer is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_int is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_bigint is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_numeric is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_decimal is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_float is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_real is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_double is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_double_precision is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_date is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_time is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_timestamp is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_datetime is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_char is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_varchar is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_string is null then 'null' else 'non-null' end);
    dbms_output.put_line(case when p_char_varying is null then 'null' else 'non-null' end);

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


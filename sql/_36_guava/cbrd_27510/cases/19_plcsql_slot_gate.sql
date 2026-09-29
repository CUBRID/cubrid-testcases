--+ server-message on
-- workspace#339 (map #312, dpin-13): a PL/CSQL static SQL ? is a slot like a JDBC ? (D-336-B)
-- The gate takes the domain of the value PL sends, not the declared type, and every answer is the develop answer.
-- PL sends CHAR as VARCHAR, TIMESTAMP as DATETIME, NUMERIC as the digits of the value, and NULL without a type.
drop table if exists dps_t;
create table dps_t (i int, s varchar(10), c char(5), n numeric(10,2), d date);
insert into dps_t values (1, '1', 'ab', 1.50, date'2024-01-02');
insert into dps_t values (2, '2', 'cd', 2.25, date'2024-01-03');

-- A. the domain the gate sees for a bare ? is the type of the value PL sends
create or replace procedure dps_a () as
    v_int int := 1;
    v_num numeric(10,5) := 12.34568;
    v_chr char(5) := 'ab';
    v_str varchar(10) := 'ab';
    v_dat date := date'2024-01-02';
    v_dtm datetime := datetime'2024-01-02 03:04:05.678';
    v_tms timestamp := timestamp'2024-01-02 03:04:05';
    v_big bigint := 9007199254740993;
    r varchar;
begin
    select typeof(v_int) into r from dual;
    dbms_output.put_line('A1 int: ' || r);
    select typeof(v_num) into r from dual;
    dbms_output.put_line('A2 numeric(10,5): ' || r);
    select typeof(v_chr) into r from dual;
    dbms_output.put_line('A3 char(5): ' || r);
    select typeof(v_str) into r from dual;
    dbms_output.put_line('A4 varchar(10): ' || r);
    select typeof(v_dat) into r from dual;
    dbms_output.put_line('A5 date: ' || r);
    select typeof(v_dtm) into r from dual;
    dbms_output.put_line('A6 datetime: ' || r);
    select typeof(v_tms) into r from dual;
    dbms_output.put_line('A7 timestamp: ' || r);
    select typeof(v_big) into r from dual;
    dbms_output.put_line('A8 bigint: ' || r);
end;
call dps_a();

-- B. NULL values reach the gate without a type
create or replace procedure dps_b () as
    v_int int := null;
    v_num numeric(10,2) := null;
    v_str varchar := null;
    r varchar;
begin
    select nvl(typeof(v_int), 'NULL') into r from dual;
    dbms_output.put_line('B1 typeof(null int): ' || r);
    select ifnull(v_int, 0) into r from dual;
    dbms_output.put_line('B2 ifnull(null int, 0): ' || r);
    select coalesce(v_num, 'a') into r from dual;
    dbms_output.put_line('B3 coalesce(null numeric, a): ' || r);
    select nvl(v_str, 'x') into r from dual;
    dbms_output.put_line('B4 nvl(null varchar, x): ' || r);
    select nvl(cast(v_num as numeric(10,2)), -1) into r from dual;
    dbms_output.put_line('B5 cast(null numeric): ' || r);
    select decode(v_int, null, 'n', 'x') into r from dual;
    dbms_output.put_line('B6 decode(null int): ' || r);
    select nvl(v_int + 1, -1) into r from dual;
    dbms_output.put_line('B7 null int + 1: ' || r);
end;
call dps_b();

-- C. arithmetic, functions and common values over slots are decided at the gate from the value
create or replace procedure dps_c () as
    v_int int := 2;
    v_num numeric(10,5) := 12.34568;
    v_str varchar := '1';
    v_dst varchar := '2024-01-02';
    v_dat date := date'2024-01-02';
    v_chr char(5) := 'ab';
    r varchar;
begin
    select v_int + 1 into r from dual;
    dbms_output.put_line('C1 int + 1: ' || r);
    select v_str + 1 into r from dual;
    dbms_output.put_line('C2 varchar + 1: ' || r);
    select typeof(v_str + 1) into r from dual;
    dbms_output.put_line('C3 typeof(varchar + 1): ' || r);
    select v_dat + 1 into r from dual;
    dbms_output.put_line('C4 date + 1: ' || r);
    select to_char(trunc(v_num, 2)) into r from dual;
    dbms_output.put_line('C5 to_char(trunc(numeric, 2)): ' || r);
    select v_num * 2 into r from dual;
    dbms_output.put_line('C6 numeric * 2: ' || r);
    select typeof(v_num * 2) into r from dual;
    dbms_output.put_line('C7 typeof(numeric * 2): ' || r);
    select str_to_date(v_dst, '%Y-%m-%d') into r from dual;
    dbms_output.put_line('C8 str_to_date(varchar): ' || r);
    select concat('[', v_chr, ']') into r from dual;
    dbms_output.put_line('C9 concat(char(5)): ' || r);
    select typeof(coalesce(v_int, v_num)) into r from dual;
    dbms_output.put_line('C10 typeof(coalesce(int, numeric)): ' || r);
    select greatest(v_int, v_str) into r from dual;
    dbms_output.put_line('C11 greatest(int, varchar): ' || r);
    select case when v_int > 1 then v_int else v_num end into r from dual;
    dbms_output.put_line('C12 case int else numeric: ' || r);
    select abs(v_int) + v_num into r from dual;
    dbms_output.put_line('C13 abs(int) + numeric: ' || r);
end;
call dps_c();

-- D. comparison and assignment next to a column keep the develop client cast
create or replace procedure dps_d () as
    v_str varchar := '1';
    v_num numeric(10,5) := 1.5;
    v_chr char(5) := 'ab';
    v_dst varchar := '2024-01-03';
    k int;
    r varchar;
begin
    select count(*) into k from dps_t where i = v_str;
    dbms_output.put_line('D1 int_col = varchar: ' || k);
    select count(*) into k from dps_t where s = v_num;
    dbms_output.put_line('D2 varchar_col = numeric: ' || k);
    select count(*) into k from dps_t where c = v_chr;
    dbms_output.put_line('D3 char_col = char(5): ' || k);
    select count(*) into k from dps_t where n = v_num;
    dbms_output.put_line('D4 numeric_col = numeric: ' || k);
    select count(*) into k from dps_t where d = v_dst;
    dbms_output.put_line('D5 date_col = varchar: ' || k);
    update dps_t set n = v_num where i = 2;
    select n into r from dps_t where i = 2;
    dbms_output.put_line('D6 numeric(10,2) := numeric: ' || r);
end;
call dps_d();

-- E. aggregates and set operations over slots
create or replace procedure dps_e () as
    v_int int := 3;
    v_str varchar := '2.5';
    r varchar;
begin
    select sum(v_int) into r from dps_t;
    dbms_output.put_line('E1 sum(int): ' || r);
    select sum(v_str) into r from dps_t;
    dbms_output.put_line('E2 sum(varchar): ' || r);
    select max(v_str) into r from dps_t;
    dbms_output.put_line('E3 max(varchar): ' || r);
    for t in (select v_int as a from dual union all select v_int + 1 from dual) loop
        dbms_output.put_line('E4 union all int: ' || t.a);
    end loop;
    for t in (select v_int as a from dual union all select v_str from dual) loop
        dbms_output.put_line('E5 union all int and varchar: ' || t.a);
    end loop;
end;
call dps_e();

-- F. built-in function calls in PL expressions run as SQL with ? arguments
create or replace procedure dps_f () as
    v_int int := 1;
    v_num numeric(10,5) := 12.34568;
    v_nul int := null;
    v_str varchar := 'CUBRID';
begin
    dbms_output.put_line('F1 abs(int): ' || abs(v_int));
    dbms_output.put_line('F2 trunc(numeric, 2): ' || trunc(v_num, 2));
    dbms_output.put_line('F3 field(int, 1, 2, 3): ' || field(v_int, 1, 2, 3));
    dbms_output.put_line('F4 nvl(null int, 0): ' || nvl(v_nul, 0));
    dbms_output.put_line('F5 left(varchar, int): ' || left(v_str, v_int + 1));
end;
call dps_f();

-- G. LIMIT over a slot at the top level (a slot LIMIT inside a derived table and a slot FIELD argument
-- fail in develop PL static SQL with -889 before reaching the server, so they stay out of this case)
create or replace procedure dps_g () as
    v_lim int := 1;
    k int;
begin
    select i into k from dps_t order by i limit v_lim;
    dbms_output.put_line('G1 limit int: ' || k);
    for t in (select i from dps_t order by i desc limit v_lim) loop
        dbms_output.put_line('G2 limit int in a loop: ' || t.i);
    end loop;
end;
call dps_g();

drop procedure dps_a;
drop procedure dps_b;
drop procedure dps_c;
drop procedure dps_d;
drop procedure dps_e;
drop procedure dps_f;
drop procedure dps_g;
drop table dps_t;
--+ server-message off

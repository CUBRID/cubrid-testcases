--+ server-message on
-- Verified for CBRD-25008

create or replace procedure test_int as
    i int := 3;
    j int;
begin
    select i into j from dual;
    dbms_output.put_line('int: ' || j);
end;

create or replace procedure test_char as
    i char(3) := 'abc';
    j char(3);
begin
    select i into j from dual;
    dbms_output.put_line('char: ' || j);
end;

create or replace procedure test_int_to_char as
    i int := 3;
    j char(1);
begin
    select i into j from dual;
    dbms_output.put_line('int to char: ' || j);
end;

create or replace procedure test_char_to_int as
    i char(1) := '3';
    j int;
begin
    select i into j from dual;
    dbms_output.put_line('char to int: ' || j);
end;

call test_int();
call test_char();
call test_int_to_char();
call test_char_to_int();

drop procedure test_int;
drop procedure test_char;
drop procedure test_int_to_char;
drop procedure test_char_to_int;

--+ server-message off

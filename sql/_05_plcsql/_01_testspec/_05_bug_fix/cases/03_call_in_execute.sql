--+ server-message on
-- Verified for CBRD-24954
-- internal error on EXECUTE IMMEDIATE 'call ...'

create or replace procedure poo(a int, b int, c int, d int, e int) as
begin
    dbms_output.put_line(a || ', ' || b || ', ' || c || ', ' || d || ', ' || e);
end;

create or replace procedure t() as
    a int := 1;
    b int := 2;
    c int := 3;
    d int := 4;
    e int := 5;
begin
    execute immediate 'call poo(?, ?, ?, ?, ?)' using a, b, c, d, e;
end;

call t();

drop procedure poo;
drop procedure t;

--+ server-message off
-- verified the CBRD-25757
-- arbitrary precision and scale.

--+ server-message on

-- NUMERIC case
create or replace procedure poo(n numeric := 10.1) as
begin
    dbms_output.put_line(n);
end;

call poo();

-- CHAR case
create or replace procedure boo(c char := 'abc') as
begin
    dbms_output.put_line(c);
end;

call boo();

drop procedure poo;
drop procedure boo;


--+ server-message off

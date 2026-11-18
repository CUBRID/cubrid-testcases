--+ server-message on
-- error: OUT and IN OUT arguments of calls in PL/CSQL (CBRD-25140)
-- A static call still updates the variable. EXECUTE IMMEDIATE with a constant fails, and an exception
-- handler catches it. EXECUTE IMMEDIATE ... USING is not changed: the variable keeps its value.

create or replace procedure t25140_out (a OUT int) as begin a := 7; end;
create or replace procedure t25140_inout (a INOUT int) as begin a := nvl (a, -1) + 100; end;

create or replace procedure t25140_p13 as
    j int := 0;
    k int := 1;
    m int := 3;
begin
    t25140_out (j);
    t25140_inout (k);
    dbms_output.put_line ('static j=' || j || ' k=' || k);
    execute immediate 'call t25140_out(?)' using m;
    dbms_output.put_line ('using m=' || m);
end;
call t25140_p13 ();

create or replace procedure t25140_p13b as
begin
    execute immediate 'call t25140_out(7)';
    dbms_output.put_line ('after');
end;
call t25140_p13b ();

create or replace procedure t25140_p13c as
begin
    execute immediate 'call t25140_out(7)';
    dbms_output.put_line ('after');
exception
    when others then
        dbms_output.put_line ('caught');
end;
call t25140_p13c ();

drop procedure t25140_p13;
drop procedure t25140_p13b;
drop procedure t25140_p13c;
drop procedure t25140_out;
drop procedure t25140_inout;

--+ server-message off

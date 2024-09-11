--+ server-message on
-- Verified for CBRD-25012, CBRD-25013


-- CBRD-25012
create or replace procedure p(i OUT int) as
begin
    i := 7;
end;

create or replace procedure poo as
    j int := 3;
begin
    p(j);
    dbms_output.put_line('j=' || j);
end;
CALL poo();

create or replace procedure p(i INOUT int) as
begin
    i := 5;
end;

create or replace procedure poo as
    j int := 4;
begin
    p(j);
    dbms_output.put_line('j=' || j);
end;

CALL poo();


-- CBRD-25013
create or replace procedure poo as
    t varchar := '2';
    
    procedure p(s OUT int) as
    begin
        s := 1;
    end;
begin
    p(t);
    dbms_output.put_line('t=' || t);
end;
CALL poo();

drop procedure p;
drop procedure poo;

--+ server-message off

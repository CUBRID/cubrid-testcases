
--+ server-message on

-- Check if the ON and INOUT parameter names are used properly. Check if an error occurs.

create or replace procedure t( ON int ) as
begin
    dbms_output.put_line('ON=' || ON );
end;

create or replace procedure t( INOUT int ) as
begin
    dbms_output.put_line('INOUT=' || INOUT );
end;


drop procedure t;


--+ server-message off



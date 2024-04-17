
--+ server-message on

-- Check if the ON and INOUT parameter names are used properly. Surround the name with the "" character.

create or replace procedure t( "ON" int ) as
begin
    dbms_output.put_line('ON=' || "ON" );
end;

call t( 123 );


create or replace procedure t( "INOUT" int ) as
begin
    dbms_output.put_line('INOUT=' || "INOUT" );
end;

call t( 456 );

drop procedure t;


--+ server-message off



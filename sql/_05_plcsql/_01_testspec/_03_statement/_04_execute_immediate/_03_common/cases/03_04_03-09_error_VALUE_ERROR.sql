--+ server-message on


-- Verified for CBRD-25016

create or replace procedure poo as 
    function str return string as
    begin
        return null;
    end;
begin
    execute immediate str;


    exception
        when VALUE_ERROR then
                dbms_output.put_line('VALUE_ERROR ouccers');
end;

call poo();

drop procedure poo;

--+ server-message off

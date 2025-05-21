--+ server-message on

-- Verified for CBRD-25014
create or replace procedure poo as
    t varchar NOT NULL := '2';

    procedure p(s OUT varchar) as
    begin
        s := null;
    end;
begin
    p(t);

    exception
        when VALUE_ERROR then
            dbms_output.put_line('VALUE_ERROR ouccers');
end;

CALL poo();

drop procedure poo;

--+ server-message off



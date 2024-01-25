--+ server-message on

--If a reserved word is used in the exception name, check whether it is processed properly.

create or replace procedure t() as
    "exception" exception;
begin
    raise "exception";
exception
when "exception" then
    dbms_output.put_line('OK');
end;
call t();

--+ server-message off


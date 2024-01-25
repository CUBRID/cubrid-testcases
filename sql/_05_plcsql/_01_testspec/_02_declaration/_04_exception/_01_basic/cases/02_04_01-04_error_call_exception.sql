--+ server-message on

-- Check whether an error occurs when calling an exception that is different from the declared exception name.

create or replace procedure t(i int) as
    my_exception exception;
begin
    raise your_exception;

    exception
    when my_exception then
        dbms_output.put_line('OK');
end;


create or replace procedure t(i int) as
    my_exception exception;
begin
    raise my_exception;

    exception
    when your_exception then
        dbms_output.put_line('OK');
end;


--+ server-message off


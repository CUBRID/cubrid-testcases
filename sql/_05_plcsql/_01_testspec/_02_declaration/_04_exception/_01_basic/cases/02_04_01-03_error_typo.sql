--+ server-message on

--EXCEPTION When using grammar, check whether an error occurs normally when you write a typo. 

create or replace procedure t(i int) as
    my_exception exceptions;
begin
    raise my_exception;

    exception
    when my_exception then
        dbms_output.put_line('OK');
end;


create or replace procedure t(i int) as
    my_exception exception;
begin
    raise my_exception;

    exceptions
    when my_exception then
        dbms_output.put_line('OK');
end;


create or replace procedure t(i int) as
    my_exception exceptions;
begin
    raise my_exception;

    exceptions
    when my_exception then
        dbms_output.put_line('OK');
end;



--+ server-message off


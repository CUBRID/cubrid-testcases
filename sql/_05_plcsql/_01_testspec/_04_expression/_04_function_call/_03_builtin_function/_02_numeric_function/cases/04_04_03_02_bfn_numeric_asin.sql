--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(ASIN(1));
    dbms_output.put_line(ASIN(0));
    dbms_output.put_line(ASIN(-1));
    --dbms_output.put_line(ASIN(NULL));  -- warning: non-varargs call of varargs method with inexact argument type for last parameter
    --dbms_output.put_line(ASIN(0.2)); -- parse error param value caused by dot? 2.013579207903308e-01
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

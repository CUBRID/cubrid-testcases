--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(ABS(12.3));
    dbms_output.put_line(ABS(-12.3));
    dbms_output.put_line(ABS(-12.3000));
    dbms_output.put_line(ABS(-0.0));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

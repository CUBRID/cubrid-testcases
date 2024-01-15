--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(TO_DAYS(NULL)); -- parse NULL param error
    dbms_output.put_line(TO_DAYS('1999-01-10'));
    dbms_output.put_line(TO_DAYS('1999-01-10 12:34:52.533'));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

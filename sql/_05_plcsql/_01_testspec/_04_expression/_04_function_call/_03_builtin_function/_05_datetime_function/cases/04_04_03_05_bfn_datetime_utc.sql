--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- UTC_TIME/DATE() not works
    dbms_output.put_line(UTC_DATE());
    dbms_output.put_line(UTC_TIME());
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

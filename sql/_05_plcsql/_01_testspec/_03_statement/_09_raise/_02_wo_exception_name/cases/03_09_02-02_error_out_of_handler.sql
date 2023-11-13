--+ server-message on

-- error: raise without an exception name outside of an exception handler

create or replace procedure t(i int) as
begin
    raise;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off

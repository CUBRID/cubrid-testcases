--+ server-message on

-- error: return statement in a procedure has a value

create or replace procedure t(i int) as
begin
    return 3;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off

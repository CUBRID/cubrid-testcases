--+ server-message on

-- error: boolean cannot be a prameter type of create procedure/function statements

create or replace procedure t(a boolean) as
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off

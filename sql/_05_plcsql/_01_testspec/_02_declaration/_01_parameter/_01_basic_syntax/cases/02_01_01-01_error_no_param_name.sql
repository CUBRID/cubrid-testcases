--+ server-message on

-- error: no parameter name

create or replace procedure t(varchar) as
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off

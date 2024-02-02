--+ server-message on

-- error: using undeclared id

create or replace procedure t(i int) as
    j int := k
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off

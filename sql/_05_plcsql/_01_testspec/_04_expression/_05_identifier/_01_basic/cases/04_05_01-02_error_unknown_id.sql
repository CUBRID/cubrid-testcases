--+ server-message on

-- error: using undeclared id

create or replace procedure t(i int) as
    j int := k
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


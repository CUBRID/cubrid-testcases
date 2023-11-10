--+ server-message on

-- error: continue must be in a loop

create or replace procedure t(i int) as
begin
    continue;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


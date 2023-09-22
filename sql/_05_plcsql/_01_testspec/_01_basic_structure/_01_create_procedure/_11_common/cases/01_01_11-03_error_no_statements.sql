--+ server-message on

-- error: no statements in the body

create or replace procedure t(i int) as
begin
    -- error: no statements
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


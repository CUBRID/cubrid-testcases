--+ server-message on

-- error: assigning to an unupdatable identifier

create or replace procedure t(i int) as
begin
    i := 7;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off

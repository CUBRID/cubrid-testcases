--+ server-message on

-- error: assigning to an unupdatable identifier

create or replace procedure t(i int) as
begin
    i := 7;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

--+ server-message off

--+ server-message on

-- error: condition is not boolean

create or replace procedure t(i int) as
begin
    if 'true' then
        null;
    else
        null;
    end if;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off

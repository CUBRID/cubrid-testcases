--+ server-message on

-- error: undefined cursor in for-cursor loop


create or replace procedure t(i int) as
begin
    for r in c loop
        null;
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off

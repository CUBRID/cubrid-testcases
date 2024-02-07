--+ server-message on

-- error: upper bound incomapatible with integer

create or replace procedure t(i int) as
begin
    for i in 1 .. false loop
        null;
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off

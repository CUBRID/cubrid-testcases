--+ server-message on

-- error: lower bound incomapatible with integer

create or replace procedure t(i int) as
begin
    for i in true .. 10 loop
        null;
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

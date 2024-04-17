--+ server-message on

-- error: unknown procedure;

create or replace procedure t(i int) as
begin
    poo;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';



--+ server-message off

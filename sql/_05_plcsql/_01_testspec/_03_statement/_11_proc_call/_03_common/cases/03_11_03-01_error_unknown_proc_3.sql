--+ server-message on

-- error: unknown procedure;

create or replace procedure t(i int) as
begin
    poo(1);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';



--+ server-message off

--+ server-message on

-- error: return statement cannot have a value in a procedure


create or replace procedure t(i int) as
begin
    return i - 1;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

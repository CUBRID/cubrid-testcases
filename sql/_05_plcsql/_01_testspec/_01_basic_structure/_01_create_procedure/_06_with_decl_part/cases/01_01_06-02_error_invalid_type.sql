--+ server-message on

-- error: not a type name in the declaration part

create or replace procedure t(i int) as
    o object;   -- object is not a type name
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';



--+ server-message off

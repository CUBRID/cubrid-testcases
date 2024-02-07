--+ server-message on

-- error: assigning to a variable of incompatible type

create or replace procedure t(i int) as
    j int;
begin
    j := true;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off

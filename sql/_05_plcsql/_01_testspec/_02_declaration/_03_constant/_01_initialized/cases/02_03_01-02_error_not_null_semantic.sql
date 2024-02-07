--+ server-message on

-- error: null value at runtime for a not null constant (runtime exception VALUE_ERROR)

create or replace procedure t(i int) as
    p_int constant int not null := null;
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off

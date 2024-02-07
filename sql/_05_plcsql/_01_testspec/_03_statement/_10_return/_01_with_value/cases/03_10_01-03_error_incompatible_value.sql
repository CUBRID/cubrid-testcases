--+ server-message on

-- error: returning a value of an incompatible type


create or replace function t(i int) return int as
begin
    return true;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off

--+ server-message on

-- error: no return type spec before is or as

create or replace function t(i int) as
begin
    return i;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


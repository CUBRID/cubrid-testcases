--+ server-message on

-- error: boolean value cannot be used in a using clause

create or replace procedure t(i int) as
    b boolean := true;
begin
    execute immediate 'select charset_name from db_collation where coll_name = ?' using b;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off

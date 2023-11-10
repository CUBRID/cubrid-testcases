--+ server-message on

-- normal: if SQL is the null, then the execute immediate raises VALUE_ERROR


create or replace procedure t(i int) as
    s varchar := null;
begin
    execute immediate s;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


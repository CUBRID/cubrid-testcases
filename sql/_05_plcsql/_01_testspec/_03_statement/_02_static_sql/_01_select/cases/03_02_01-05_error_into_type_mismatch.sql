--+ server-message on

-- error: into clause variables of a select statement must have a compatible type

create or replace procedure t(i int) as
    b boolean;
begin
    select dummy into b from dual;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off

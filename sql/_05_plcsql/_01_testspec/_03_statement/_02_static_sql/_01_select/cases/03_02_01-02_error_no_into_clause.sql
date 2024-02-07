--+ server-message on

-- error: static sql select statement must have an into clause

create or replace procedure t(i int) as
begin
    select dummy from dual;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off

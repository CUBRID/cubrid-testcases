--+ server-message on

-- error: static sql select statement must have an into clause

create or replace procedure t(i int) as
begin
    select dummy from dual;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


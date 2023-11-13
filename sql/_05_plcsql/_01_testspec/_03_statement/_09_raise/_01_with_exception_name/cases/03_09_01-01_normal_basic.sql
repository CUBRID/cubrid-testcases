--+ server-message on

-- normal: basic usage of a raise statement.


create or replace procedure t(i int) as
    e exception;
begin
    raise e;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

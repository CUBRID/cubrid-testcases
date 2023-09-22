--+ server-message on

-- error: no initialization syntax error

create or replace procedure t(i int) as
    j constant int;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


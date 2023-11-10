--+ server-message on

-- error: no parameter type

create or replace procedure t(i) as
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


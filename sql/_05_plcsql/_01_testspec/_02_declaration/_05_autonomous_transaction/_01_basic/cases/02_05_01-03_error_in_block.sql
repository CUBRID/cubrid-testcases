--+ server-message on

-- error: declared in a block

create or replace procedure t(i int) as
begin
    declare
        pragma autonomous_transaction;
    begin
        null;
    end;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off

--+ server-message on

-- error: integer literal with more than 38 digits cause an semantic error

create or replace procedure t(j int) as
    bbi numeric := 100000000000000000000000000000000000000;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

--+ server-message off

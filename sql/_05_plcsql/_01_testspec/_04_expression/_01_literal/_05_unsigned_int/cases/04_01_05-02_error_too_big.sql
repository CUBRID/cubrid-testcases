--+ server-message on

-- guava(11.5): 39-digit numeric literal succeeds with float numeric

create or replace procedure t(j int) as
    bbi numeric := 100000000000000000000000000000000000000;
begin
    null;
end;

select 'guava(11.5) float numeric: 39 digit success' from dual;
select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off

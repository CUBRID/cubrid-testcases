--+ server-message on

-- error: parameter with the same name

create or replace procedure t(i int) as
    function i return int as
    begin
        return null;
    end;
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off

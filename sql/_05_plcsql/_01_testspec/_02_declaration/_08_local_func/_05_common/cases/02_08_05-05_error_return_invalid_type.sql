--+ server-message on

-- error: local function must return a value of a valid type

create or replace procedure t(i int) as
    function foo return int as
    begin
        return true;
    end;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off

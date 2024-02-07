--+ server-message on

-- error: local function returns without a value

create or replace procedure t(i int) as
    function poo return int as
    begin
        return;
    end;
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off

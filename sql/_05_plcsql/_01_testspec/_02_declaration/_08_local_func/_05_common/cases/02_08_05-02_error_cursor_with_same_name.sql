--+ server-message on

-- error: cursor with the same name

create or replace procedure t(i int) as
    cursor j is select * from dual;
    function j return int as
    begin
        return null;
    end;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


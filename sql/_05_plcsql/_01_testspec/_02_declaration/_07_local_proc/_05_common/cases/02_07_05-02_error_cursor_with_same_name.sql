--+ server-message on

-- error: cursor with the same name

create or replace procedure t(i int) as
    cursor j is select * from dual;
    procedure j as
    begin
        null;
    end;
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off

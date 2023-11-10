--+ server-message on

-- error: procedure with the same name

create or replace procedure t(i int) as
    procedure j as
    begin
        null;
    end;
    cursor j is select * from dual;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


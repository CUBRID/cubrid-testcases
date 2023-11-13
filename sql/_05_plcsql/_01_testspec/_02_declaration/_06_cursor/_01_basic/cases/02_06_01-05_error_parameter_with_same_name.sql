--+ server-message on

-- error: parameter with the same name

create or replace procedure t(i int) as
    cursor i is select * from dual;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off

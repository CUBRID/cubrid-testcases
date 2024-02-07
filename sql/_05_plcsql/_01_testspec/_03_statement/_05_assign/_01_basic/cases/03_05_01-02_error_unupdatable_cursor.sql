--+ server-message on

-- error: assigning to an unupdatable cursor

create or replace procedure t(i int) as
    cursor c is select * from dual;
begin
    c := 7;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off

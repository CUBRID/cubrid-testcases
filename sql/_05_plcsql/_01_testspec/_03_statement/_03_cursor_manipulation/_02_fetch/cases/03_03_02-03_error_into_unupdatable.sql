--+ server-message on

-- error: fetching a value into an unupdatable

create or replace procedure t(r varchar) as
    cursor c is select dummy from dual;
begin
    open c;
    fetch c into r;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';



--+ server-message off

--+ server-message on

-- error: fetching a value into an unupdatable

create or replace procedure t(r varchar(1)) as
    cursor c is select dummy from dual;
begin
    open c;
    fetch c into r;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';



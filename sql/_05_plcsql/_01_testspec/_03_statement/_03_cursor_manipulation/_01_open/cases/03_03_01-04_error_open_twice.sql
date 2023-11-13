--+ server-message on

-- normal: opening the same cursor twice


create or replace procedure t(i int) as
    cursor c is select * from dual;
begin
    open c;
    open c;
    dbms_output.put_line('unreachable');
exception
when cursor_already_open then
    dbms_output.put_line('OK');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

--+ server-message on

-- normal: closing an unopen cursor or cursor variable raises INVALID_CURSOR

create or replace procedure t(i int) as
    c sys_refcursor;
begin
    close c;
    dbms_output.put_line('unreachable');
exception
when invalid_cursor then
    dbms_output.put_line('OK');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

--+ server-message on

-- normal: closing an unopen cursor or cursor variable raises INVALID_CURSOR

create or replace procedure t(i int) as
    cursor c(cs varchar(32), b int) is select coll_name from db_collation where charset_name = cs and coll_id > b;
begin
    close c;
    dbms_output.put_line('unreachable');
exception
when invalid_cursor then
    dbms_output.put_line('OK');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

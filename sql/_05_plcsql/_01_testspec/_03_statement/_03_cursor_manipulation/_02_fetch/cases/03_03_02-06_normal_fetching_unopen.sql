--+ server-message on

-- normal: fetching unopen cursor raises INVALID_CURSOR
-- Verified for CBRD-24951


create or replace procedure t(i int) as
    cursor c(cs varchar, b int) is select coll_name from db_collation where charset_name = cs and coll_id > b;
    r varchar(1);
begin
    fetch c into r;
exception
when invalid_cursor then
    dbms_output.put_line('OK');
    raise;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

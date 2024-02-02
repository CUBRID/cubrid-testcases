--+ server-message on

-- normal: using opened cursor in a for-cursor loop raises CURSOR_ALREADY_OPEN exception


create or replace procedure t(i int) as
    cursor c is select coll_name from db_collation;
begin
    open c;
    for r in c loop
        dbms_output.put_line(r.coll_name);
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;



--+ server-message off

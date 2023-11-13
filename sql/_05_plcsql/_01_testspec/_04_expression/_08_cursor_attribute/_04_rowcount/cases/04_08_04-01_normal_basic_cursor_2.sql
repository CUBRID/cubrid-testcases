--+ server-message on

-- normal: using %notfound on a cursor with for cursor loop


create or replace procedure t(i int) as
    cursor c is select coll_id, coll_name from db_collation limit 10;
begin
    for r in c loop
        dbms_output.put_line('in loop body: ' || c%rowcount);
    end loop;

    dbms_output.put_line('after loop: ' || c%rowcount);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;



--+ server-message off

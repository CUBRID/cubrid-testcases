--+ server-message on

-- error: the value in the using clause has an incompatible type


create or replace procedure t(i int) as
begin
    for r in (execute immediate 'select * from db_collation where coll_id > ?' using true) loop
        dbms_output.put_line('unreachable');
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

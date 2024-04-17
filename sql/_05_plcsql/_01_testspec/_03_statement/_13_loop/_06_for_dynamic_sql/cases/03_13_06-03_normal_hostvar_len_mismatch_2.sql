--+ server-message on

-- normal: the number of host variables (?'s) and the length of using clause do not match


create or replace procedure t(i int) as
begin
    for r in (execute immediate 'select * from db_collation where coll_id > ?') loop
        dbms_output.put_line('unreachable');
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

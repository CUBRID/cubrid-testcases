--+ server-message on

-- normal: the number of host variables (?'s) and the length of using clause do not match


create or replace procedure t(i int) as
begin
    for r in (execute immediate 'select * from db_collation where coll_id > ?' using 3, 4) loop
        dbms_output.put_line('unreachable');
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


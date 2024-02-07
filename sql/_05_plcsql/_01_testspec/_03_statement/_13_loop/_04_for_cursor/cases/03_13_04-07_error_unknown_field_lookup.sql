--+ server-message on

-- error: cursor arguments type

create or replace procedure t(i int) as
    cursor c(i int) is select coll_name from db_collation where coll_id > i;
begin
    for r in c(3) loop
        dbms_output.put_line('name=' || r.name);
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off

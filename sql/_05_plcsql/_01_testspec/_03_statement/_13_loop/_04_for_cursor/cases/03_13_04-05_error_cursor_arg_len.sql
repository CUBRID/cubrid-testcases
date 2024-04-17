--+ server-message on

-- error: cursor arguments length

create or replace procedure t(i int) as
    cursor c(i int) is select coll_name from db_collation where coll_id > i;
begin
    for r in c(3, 4) loop
        null;
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off

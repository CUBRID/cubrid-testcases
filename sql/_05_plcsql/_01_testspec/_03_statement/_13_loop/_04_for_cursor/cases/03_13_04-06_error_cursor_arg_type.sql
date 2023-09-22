--+ server-message on

-- error: cursor arguments type

create or replace procedure t(i int) as
    cursor c(i int) is select coll_name from db_collation where coll_id > i;
begin
    for r in c(true) loop
        null;
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

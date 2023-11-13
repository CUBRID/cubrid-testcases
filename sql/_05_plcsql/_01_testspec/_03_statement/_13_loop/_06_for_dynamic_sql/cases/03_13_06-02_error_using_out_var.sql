--+ server-message on

-- error: specifying OUT, INOUT, or IN OUT in using clause

create or replace procedure t(i int) as
    j int := 3;
begin
    for r in (execute immediate 'select * from db_collation where coll_id > ?' using OUT j) loop
        null;
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

--+ server-message off

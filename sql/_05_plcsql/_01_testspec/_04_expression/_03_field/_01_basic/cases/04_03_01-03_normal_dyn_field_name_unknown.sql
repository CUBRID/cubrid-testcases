--+ server-message on

-- normal: field name is wrong for a dynamic sql. compilation succeeds, but SQLException at runtime


create or replace procedure t(i int) as
begin
    for r in (execute immediate 'select coll_Id from db_collation') loop
        dbms_output.put_line('abcdef=' || r.abcdef);
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

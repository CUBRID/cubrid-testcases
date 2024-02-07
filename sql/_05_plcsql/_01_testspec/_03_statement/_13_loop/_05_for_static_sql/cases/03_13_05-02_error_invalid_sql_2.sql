--+ server-message on

-- error: static sql is a select statement with an into-clause

create or replace procedure t(i int) as
    v varchar;
begin
    for r in (select coll_name into v from db_collation) loop
        null;
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off

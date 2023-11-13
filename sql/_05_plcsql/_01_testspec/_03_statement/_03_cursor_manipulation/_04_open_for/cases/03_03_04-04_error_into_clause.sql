--+ server-message on

-- error: open-for cannot have an into-clause

create or replace procedure t(i int) as
    rc sys_refcursor;
    v varchar;
begin
    open rc for select coll_name into v from db_collation;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off

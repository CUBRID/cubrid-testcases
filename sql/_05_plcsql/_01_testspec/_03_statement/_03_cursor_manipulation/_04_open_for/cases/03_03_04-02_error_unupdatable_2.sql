--+ server-message on

-- error: the sys_refcursor must be updatable

create or replace procedure t(i int) as
    rc constant sys_refcursor := null;
begin
    open rc for select coll_name, charset_name from db_collation;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off

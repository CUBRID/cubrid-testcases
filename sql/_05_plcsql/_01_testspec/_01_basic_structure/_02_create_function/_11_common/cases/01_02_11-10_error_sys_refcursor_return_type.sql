--+ server-message on

-- error: SYS_REFCURSOR may not be the return type of stored functions

create or replace function t(i int) return sys_refcursor as
begin
    return null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off

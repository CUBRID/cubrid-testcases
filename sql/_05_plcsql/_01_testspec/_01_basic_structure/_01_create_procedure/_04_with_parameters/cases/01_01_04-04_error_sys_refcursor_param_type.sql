--+ server-message on

-- error: sys_refcursor cannot be a prameter type of create procedure/function statements

create or replace procedure t(a sys_refcursor) as
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

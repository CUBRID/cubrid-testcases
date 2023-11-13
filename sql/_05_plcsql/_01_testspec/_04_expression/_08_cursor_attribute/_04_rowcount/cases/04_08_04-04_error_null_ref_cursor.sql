--+ server-message on

-- normal: %notfound on a null sys_refcursor

create or replace procedure t(i int) as
    function helper(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;

    rc sys_refcursor;
begin
    dbms_output.put_line(helper(rc%notfound));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

--+ server-message off

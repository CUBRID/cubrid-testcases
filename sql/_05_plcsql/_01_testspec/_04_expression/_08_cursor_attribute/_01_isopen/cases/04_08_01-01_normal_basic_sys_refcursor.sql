--+ server-message on

-- normal: using %isopen on a cursor with open and close statements


create or replace procedure t(i int) as
    rc sys_refcursor;

    function helper(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    open rc for  select * from db_collation;
    dbms_output.put_line('after open: ' || helper(rc%isopen));
    close rc;
    dbms_output.put_line('after close: ' || helper(rc%isopen));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

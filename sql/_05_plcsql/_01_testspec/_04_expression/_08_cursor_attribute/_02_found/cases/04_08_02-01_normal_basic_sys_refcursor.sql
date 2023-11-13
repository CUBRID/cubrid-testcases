--+ server-message on

-- normal: using %found on a cursor with open and close statements


create or replace procedure t(i int) as
    id int;
    name varchar(32);

    rc sys_refcursor;

    function helper(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    open rc for select coll_id, coll_name from db_collation limit 10;
    dbms_output.put_line('after open-for: ' || helper(rc%found));
    loop
        fetch rc into id, name;
        dbms_output.put_line('after fetch: ' || helper(rc%found));
        exit when not rc%found;
    end loop;
    close rc;
    dbms_output.put_line('after close: ' || helper(rc%found));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

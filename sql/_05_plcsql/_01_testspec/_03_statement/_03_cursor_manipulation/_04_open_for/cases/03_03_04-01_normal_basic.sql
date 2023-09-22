--+ server-message on

-- normal: basic usage of open-for


create or replace procedure t(i int) as
    rc sys_refcursor;
    coll varchar(32);
    charset varchar(32);
begin
    open rc for select coll_name, charset_name from db_collation;
    loop
        fetch rc into coll, charset;
        exit when rc%notfound;
        dbms_output.put_line('(' || coll || ', ' || charset || ')');
    end loop;
    close rc;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


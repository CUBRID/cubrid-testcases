--+ server-message on

-- normal: basic usage of open-for


create or replace procedure t(i int) as
    rc sys_refcursor;
    id int;
    charset varchar(32);
begin
    open rc for select charset_id, charset_name from db_charset;
    loop
        fetch rc into id, charset;
        exit when rc%notfound;
        dbms_output.put_line('(' || id || ', ' || charset || ')');
    end loop;
    close rc;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

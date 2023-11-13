--+ server-message on

-- normal: iterate cursor without arguments


create or replace procedure t(i int) as
    cursor c is select charset_name from db_charset;
begin
    for r in c loop
        dbms_output.put_line(r.charset_name);
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;



--+ server-message off

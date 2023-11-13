--+ server-message on

-- normal: iterate cursor with arguments


create or replace procedure t(i int) as
    cursor c(bbb int) is select charset_name from db_charset where charset_id > bbb;
begin
    for r in c(3) loop
        dbms_output.put_line(r.charset_name);
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;



--+ server-message off

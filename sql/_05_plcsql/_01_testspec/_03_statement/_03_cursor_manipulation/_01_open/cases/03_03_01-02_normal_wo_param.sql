--+ server-message on

-- normal: opening a cursor without parameters


create or replace procedure t(i int) as
    cs varchar(32) := 'utf8';
    bbb int := 3;
    cursor c is select charset_name from db_charset where charset_name = cs and charset_id > bbb;
    r varchar(32);
begin
    open c;
    loop
        fetch c into r;
        exit when c%notfound;
        dbms_output.put_line('r=' || r);
    end loop;
    close c;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

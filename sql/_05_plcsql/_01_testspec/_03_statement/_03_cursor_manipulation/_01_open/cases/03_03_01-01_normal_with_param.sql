--+ server-message on

-- normal: opening of a parameterized cursor


create or replace procedure t(i int) as
    cursor c(cs varchar, bbb int) is
        select charset_name from db_charset where charset_name = cs and charset_id > bbb;
    r varchar(32);
begin
    open c('utf8', 3);
    loop
        fetch c into r;
        exit when c%notfound;
        dbms_output.put_line('r=' || r);
    end loop;
    close c;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

--+ server-message on

-- normal: opening of a parameterized cursor


create or replace procedure t(i int) as
    cursor c(cs varchar(32), bbb int) is select coll_name from db_collation where charset_name = cs and coll_id > bbb;
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

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


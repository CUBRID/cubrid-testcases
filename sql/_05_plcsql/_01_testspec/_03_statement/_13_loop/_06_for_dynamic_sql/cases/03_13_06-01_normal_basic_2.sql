--+ server-message on

-- normal: basic usage of a for loop using dynamic sql (specifying IN in using-clause)


create or replace procedure t(i int) as
begin
    for r in (execute immediate 'select * from db_charset where charset_id > ?' using IN 3) loop
        dbms_output.put_line('charset_id=' || r.charset_id);
        dbms_output.put_line('charset_name=' || r.charset_name);
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


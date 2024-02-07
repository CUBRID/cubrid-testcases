--+ server-message on

-- normal: basic usage of exit with when clause


create or replace procedure t(i int) as
begin
    for i in 1 .. 5 loop
        exit when i % 2 = 0;
        dbms_output.put_line('i=' || i);
    end loop;
    dbms_output.put_line('done');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

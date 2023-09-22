--+ server-message on

-- normal: basic usage of continue with when clause


create or replace procedure t(i int) as
begin
    for i in 1 .. 5 loop
        continue when i % 2 = 0;
        dbms_output.put_line('i=' || i);
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


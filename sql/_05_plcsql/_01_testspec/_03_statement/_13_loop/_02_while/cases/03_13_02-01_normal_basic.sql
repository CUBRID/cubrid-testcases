--+ server-message on

-- normal: basic usage of a while-loop


create or replace procedure t(i int) as
    j int;
begin
    j := 0;
    while j < 5 loop
        dbms_output.put_line('j=' || j);
        j := j + 1;
    end loop;
    dbms_output.put_line('OK');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

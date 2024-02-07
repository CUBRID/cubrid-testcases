--+ server-message on

-- normal: basic usage of a loop


create or replace procedure t(i int) as
    j int;
begin
    j := 0;
    loop
        dbms_output.put_line('j=' || j);
        j := j + 1;
        exit when j >= 5;
    end loop;
    dbms_output.put_line('OK');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

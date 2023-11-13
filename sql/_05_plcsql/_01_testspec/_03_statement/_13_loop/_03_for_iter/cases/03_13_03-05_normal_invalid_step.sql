--+ server-message on

-- normal: invalid step (step < 1) raise a VALUE_ERROR


create or replace procedure t(i int) as
begin
    for i in 1 .. 10 by -1 loop
        dbms_output.put_line('unreachable');
        exit;   -- to avoid infinite loop when erroneously reached
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

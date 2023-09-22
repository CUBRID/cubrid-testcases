--+ server-message on

-- normal: compiler counter-intuitively judges statements reachable after while with TRUE condition


create or replace procedure t(i int) as
begin
    while true loop
        dbms_output.put_line('OK');
        return; -- to prevent infinite loop
    end loop;

    null;   -- deemed reachable
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


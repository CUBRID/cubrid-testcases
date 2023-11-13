--+ server-message on

-- normal: procecures can call themselves recursively


create or replace procedure t(i int) as
begin
    if i <= 0 then
        dbms_output.put_line('i=' || i);
        return;
    else
        dbms_output.put_line('i=' || i);
        t(i - 1);
    end if;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(5);

drop procedure t;



--+ server-message off

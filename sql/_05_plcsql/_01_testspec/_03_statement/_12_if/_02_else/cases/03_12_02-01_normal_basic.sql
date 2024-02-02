--+ server-message on

-- normal: basic usage of an if statement with an else clause


create or replace procedure t(i int) as
begin
    if 2 = 3 then
        dbms_output.put_line('then');
    else
        dbms_output.put_line('else');
    end if;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

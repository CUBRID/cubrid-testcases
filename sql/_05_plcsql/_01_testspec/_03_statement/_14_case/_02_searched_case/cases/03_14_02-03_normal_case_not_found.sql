--+ server-message on

-- normal: basic usage of a searched case statement


create or replace procedure t(i int) as
begin
    case
    when i = 6 then
        dbms_output.put_line('6');
    when i = 7 then
        dbms_output.put_line('7');
    end case;

    case
    when i = 6 then
        dbms_output.put_line('6');
    when i = 7 then
        dbms_output.put_line('7');
    else
        dbms_output.put_line('other');
    end case;

    case
    when i = 5 then
        dbms_output.put_line('5');
    when i = 6 then
        dbms_output.put_line('6');
    else
        dbms_output.put_line('other');
    end case;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;



--+ server-message off

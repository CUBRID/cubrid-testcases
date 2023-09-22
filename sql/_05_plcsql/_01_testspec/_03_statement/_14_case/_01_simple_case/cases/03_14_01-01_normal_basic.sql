--+ server-message on

-- normal: basic usage of a simple case statement


create or replace procedure t(i int) as
begin
    case i
    when 6 then
        dbms_output.put_line('6');
    when 7 then
        dbms_output.put_line('7');
    end case;

    case i
    when 6 then
        dbms_output.put_line('6');
    when 7 then
        dbms_output.put_line('7');
    else
        dbms_output.put_line('other');
    end case;

    case i
    when 5 then
        dbms_output.put_line('5');
    when 6 then
        dbms_output.put_line('6');
    else
        dbms_output.put_line('other');
    end case;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


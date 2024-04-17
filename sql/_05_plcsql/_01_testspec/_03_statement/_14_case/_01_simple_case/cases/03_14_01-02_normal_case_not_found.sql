--+ server-message on

-- normal: when no matching case, CASE_NOT_FOUND is raised.


create or replace procedure t(i int) as
begin
    case i
    when 5 then
        dbms_output.put_line('5');
    when 6 then
        dbms_output.put_line('6');
    end case;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

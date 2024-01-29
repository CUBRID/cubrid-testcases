--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(RADIANS(15));
    dbms_output.put_line(RADIANS(30));
    dbms_output.put_line(RADIANS(45));
    dbms_output.put_line(RADIANS(60));
    dbms_output.put_line(RADIANS(90));
    dbms_output.put_line(RADIANS(120));
    dbms_output.put_line(RADIANS(180));
    dbms_output.put_line(RADIANS(360));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

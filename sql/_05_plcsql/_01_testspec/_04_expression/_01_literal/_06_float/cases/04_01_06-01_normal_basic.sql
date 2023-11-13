--+ server-message on

-- normal: basic usage of floating point number literals


create or replace procedure t(i int) as
begin
    dbms_output.put_line(1.1);
    dbms_output.put_line(.1);
    dbms_output.put_line(.12345678901234567890123456789012345678);
    dbms_output.put_line(1234567890123456789012345678901234567.0);
    dbms_output.put_line(1234567890123456789.0123456789012345678);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

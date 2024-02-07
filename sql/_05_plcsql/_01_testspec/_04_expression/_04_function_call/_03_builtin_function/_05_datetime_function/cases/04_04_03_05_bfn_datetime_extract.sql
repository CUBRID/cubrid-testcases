--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- parse error about EXTRACT()
    dbms_output.put_line(EXTRACT(NULL));
    dbms_output.put_line(EXTRACT(MILLISECOND FROM DATETIME '1999-01-11 12:34:52.333'));
    dbms_output.put_line(EXTRACT(SECOND FROM DATETIME '1999-01-11 12:34:52'));
    dbms_output.put_line(EXTRACT(MINUTE FROM DATETIME '1999-01-11'));
    dbms_output.put_line(EXTRACT(HOUR FROM DATETIME '1999-01-11'));
    dbms_output.put_line(EXTRACT(DAY FROM DATETIME '1999-01-11'));
    dbms_output.put_line(EXTRACT(MONTH FROM DATETIME '1999-01-11'));
    dbms_output.put_line(EXTRACT(YEAR FROM DATETIME '1999-01-11'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

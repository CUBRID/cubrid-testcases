--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- function not work and skip NULLIF()
    dbms_output.put_line(NULLIF(NULL,  NULL));
    dbms_output.put_line(NULLIF(1, 1));
    dbms_output.put_line(NULLIF(NULL, 1));
    dbms_output.put_line(NULLIF('0', '0'));
    dbms_output.put_line(NULLIF(TO_DATE('0000-00-00'), TO_DATE('0000-00-00')));
    dbms_output.put_line(NULLIF(TO_DATETIME('0000-00-00'), TO_DATETIME('0000-00-00')));
    dbms_output.put_line(NULLIF(TIMESTAMP('1999-01-10'), TIMESTAMP('1999-1-11')));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

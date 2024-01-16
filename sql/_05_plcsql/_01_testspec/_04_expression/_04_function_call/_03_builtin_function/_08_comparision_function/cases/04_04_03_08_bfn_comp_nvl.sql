--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(NVL(NULL,  NULL));
    dbms_output.put_line(NVL(NULL, 'ok'));
    dbms_output.put_line(NVL(1, 'ok'));
    dbms_output.put_line(NVL(0, NULL));
    dbms_output.put_line(NVL(NULL, 1));
    dbms_output.put_line(NVL('1', 'ok'));
    dbms_output.put_line(NVL('1', 'ok'));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

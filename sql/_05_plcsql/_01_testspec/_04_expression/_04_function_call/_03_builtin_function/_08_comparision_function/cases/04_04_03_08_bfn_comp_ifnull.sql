--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(IFNULL(NULL,  NULL));
    dbms_output.put_line(IFNULL(NULL, 'ok'));
    dbms_output.put_line(IFNULL(1, 'ok'));
    dbms_output.put_line(IFNULL(0, NULL));
    dbms_output.put_line(IFNULL(NULL, 1));
    dbms_output.put_line(IFNULL('1', 'ok'));
    dbms_output.put_line(IFNULL('1', 'ok'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

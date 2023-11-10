--+ server-message on

-- normal: basic usage of string literals


create or replace procedure t(i int) as
begin
    dbms_output.put_line('OK');
    dbms_output.put_line('');
    dbms_output.put_line('line breaks
    here');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


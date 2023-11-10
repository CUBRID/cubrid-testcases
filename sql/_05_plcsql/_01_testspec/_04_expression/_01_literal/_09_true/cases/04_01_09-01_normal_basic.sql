--+ server-message on

-- normal: basic usage of TRUE literal


create or replace procedure t(i int) as
    b boolean;
begin
    b := true;
    dbms_output.put_line('OK');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


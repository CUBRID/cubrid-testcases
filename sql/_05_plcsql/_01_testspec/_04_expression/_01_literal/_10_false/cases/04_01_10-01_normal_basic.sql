--+ server-message on

-- normal: basic usage of FALSE literal


create or replace procedure t(i int) as
    b boolean;
begin
    b := false;
    dbms_output.put_line('OK');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

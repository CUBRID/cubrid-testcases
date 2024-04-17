--+ server-message on

-- normal: basic case with no declaration in the declaration part


create or replace procedure t(i int) as
    -- no declarations
begin
    dbms_output.put_line('OK');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

--+ server-message off

--+ server-message on

-- error: field lookup from a non-record

create or replace procedure t(i int) as
begin
    dbms_output.put_line('error: ' || i.f);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

--+ server-message off

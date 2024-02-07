--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(FLOOR(34567.900));
    dbms_output.put_line(FLOOR(-34567.900));
    dbms_output.put_line(FLOOR(34567.5678));
    dbms_output.put_line(FLOOR(-34567.5678));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

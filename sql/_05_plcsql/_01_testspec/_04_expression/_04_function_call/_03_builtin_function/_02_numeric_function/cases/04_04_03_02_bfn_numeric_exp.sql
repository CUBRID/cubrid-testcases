--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(EXP(1));
    dbms_output.put_line(EXP(0));
    dbms_output.put_line(EXP(-1));
    dbms_output.put_line(EXP(2.00));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

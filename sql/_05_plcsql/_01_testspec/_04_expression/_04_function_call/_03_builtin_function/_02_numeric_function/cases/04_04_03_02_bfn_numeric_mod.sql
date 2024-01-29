--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(MOD(11,4));
    dbms_output.put_line(MOD(11,-4));
    dbms_output.put_line(MOD(11,4));
    dbms_output.put_line(MOD(-11,4));
    dbms_output.put_line(MOD(-11,4));
    dbms_output.put_line(MOD(11.0,4));
    dbms_output.put_line(MOD(-11.000,4));
    dbms_output.put_line(MOD(-11,4.0));
    dbms_output.put_line(MOD(11,4.000));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

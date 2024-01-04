--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(CONV('f',16,2));
    dbms_output.put_line(CONV('6H',20,8));
    dbms_output.put_line(CONV(-30,10,-20));
    dbms_output.put_line(CONV(CONV('-1', 36, 36), 36,36));
    -- dbms_output.put_line(CONV(b'10', 36, 10); -- parse error bit string
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off

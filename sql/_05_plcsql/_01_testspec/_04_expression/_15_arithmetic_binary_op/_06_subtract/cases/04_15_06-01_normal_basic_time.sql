--+ server-message on

-- normal: basic usage of operator '-' with time values


create or replace procedure t(i int) as
    a time := time'01:02:03';
    b time := time'01:02:04';
begin
    dbms_output.put_line(a - b);
    dbms_output.put_line(b - a);
    dbms_output.put_line(null - b);
    dbms_output.put_line(a - null);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


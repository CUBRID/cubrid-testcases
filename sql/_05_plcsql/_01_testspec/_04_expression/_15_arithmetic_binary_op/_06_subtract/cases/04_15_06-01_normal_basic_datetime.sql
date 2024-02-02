--+ server-message on

-- normal: basic usage of operator '-' with datetime values


create or replace procedure t(i int) as
    a datetime := datetime'2013-10-09 01:02:03.456';
    b datetime := datetime'2013-10-09 01:02:04.456';
begin
    dbms_output.put_line(a - b);
    dbms_output.put_line(b - a);
    dbms_output.put_line(null - b);
    dbms_output.put_line(a - null);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

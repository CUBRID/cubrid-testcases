--+ server-message on

-- normal: basic usage of unary operator '+' with datetime values


create or replace procedure t(i int) as
    a datetime := datetime'2013-10-09 01:02:03.456';
    b datetime := +a;
begin
    dbms_output.put_line(a);
    dbms_output.put_line(b);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

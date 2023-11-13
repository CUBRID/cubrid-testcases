--+ server-message on

-- normal: basic usage of operator '+' with datetime and bigint values


create or replace procedure t(i int) as
    a datetime := datetime'2013-10-09 01:02:03.456';
    b bigint := 5;
begin
    dbms_output.put_line(a + b);
    dbms_output.put_line(null + b);
    dbms_output.put_line(a + null);

    dbms_output.put_line(b + a);
    dbms_output.put_line(b + null);
    dbms_output.put_line(null + a);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

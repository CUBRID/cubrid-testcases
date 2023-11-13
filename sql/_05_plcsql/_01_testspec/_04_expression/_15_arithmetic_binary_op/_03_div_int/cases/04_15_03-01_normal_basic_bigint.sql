--+ server-message on

-- normal: basic usage of operator 'div' with bigint values


create or replace procedure t(i int) as
    a bigint := 3;
    b bigint := 5;
begin
    dbms_output.put_line(a div b);
    dbms_output.put_line(null div b);
    dbms_output.put_line(a div null);
    dbms_output.put_line(null div null);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

--+ server-message on

-- normal: basic usage of operator '*' with bigint values


create or replace procedure t(i int) as
    a bigint := 3;
    b bigint := 5;
begin
    dbms_output.put_line(a * b);
    dbms_output.put_line(null * b);
    dbms_output.put_line(a * null);
    dbms_output.put_line(null * null);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

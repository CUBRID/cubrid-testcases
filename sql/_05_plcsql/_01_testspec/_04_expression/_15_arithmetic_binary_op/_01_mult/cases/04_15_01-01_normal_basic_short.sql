--+ server-message on

-- normal: basic usage of operator '*' with short values


create or replace procedure t(i int) as
    a short := 3;
    b short := 5;
begin
    dbms_output.put_line(a * b);
    dbms_output.put_line(null * b);
    dbms_output.put_line(a * null);
    dbms_output.put_line(null * null);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


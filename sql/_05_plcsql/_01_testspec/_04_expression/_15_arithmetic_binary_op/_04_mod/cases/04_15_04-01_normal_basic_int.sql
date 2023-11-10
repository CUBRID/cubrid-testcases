--+ server-message on

-- normal: basic usage of operator 'mod' with int values


create or replace procedure t(i int) as
    a int := 3;
    b int := 5;
begin
    dbms_output.put_line(a mod b);
    dbms_output.put_line(null mod b);
    dbms_output.put_line(a mod null);
    dbms_output.put_line(null mod null);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


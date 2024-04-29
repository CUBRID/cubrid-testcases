--+ server-message on
-- Verified for CBRD-24565

-- normal: basic usage of unary operator '+' with int values


create or replace procedure t(i int) as
    a int := 3;
    b int := +a;
begin
    dbms_output.put_line(a);
    dbms_output.put_line(b);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

--+ server-message on
-- Verified for CBRD-24565

-- normal: basic usage of operator '+' with float values


create or replace procedure t(i int) as
    a float := 3.5;
    b float := 5.7;
begin
    dbms_output.put_line(a + b);
    dbms_output.put_line(null + b);
    dbms_output.put_line(a + null);
    dbms_output.put_line(null + null);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

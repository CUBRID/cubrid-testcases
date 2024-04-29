--+ server-message on
-- Verified for CBRD-24565

-- normal: basic usage of operator 'div' with short values


create or replace procedure t(i int) as
    a short := 3;
    b short := 5;
begin
    dbms_output.put_line(a div b);
    dbms_output.put_line(null div b);
    dbms_output.put_line(a div null);
    dbms_output.put_line(null div null);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

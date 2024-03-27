--+ server-message on
-- Verified for CBRD-24565

-- normal: basic usage of operator 'mod' with bigint values


create or replace procedure t(i int) as
    a bigint := 3;
    b bigint := 5;
begin
    dbms_output.put_line(a mod b);
    dbms_output.put_line(null mod b);
    dbms_output.put_line(a mod null);
    dbms_output.put_line(null mod null);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

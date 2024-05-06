--+ server-message on
-- Verified for CBRD-24565

-- extended usage of unary operator '+' with char values

create or replace procedure t(i int) as
    a char(2) := 'a';
    b char(2) := 'b';
begin
    -- b := b+a; -- error: not in a DOUBLE format even value is string
    dbms_output.put_line(a || 'a');
    dbms_output.put_line(b || 'b');
    -- dbms_output.put_line(b + 'b'); -- error: not in a DOUBLE format even value is string
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

--+ server-message off

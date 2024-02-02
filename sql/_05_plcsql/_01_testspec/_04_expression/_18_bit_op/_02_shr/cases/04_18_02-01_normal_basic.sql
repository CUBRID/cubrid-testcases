--+ server-message on

-- normal: basic usage of operator '>>'


create or replace procedure t(i int) as
begin
    dbms_output.put_line(20 >> 1);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off

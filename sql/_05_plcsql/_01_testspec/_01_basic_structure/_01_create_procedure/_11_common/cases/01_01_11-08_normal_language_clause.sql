--+ server-message on

-- normal: it is OK to use nor not the LANGUAGE PLCSQL clause


create or replace procedure t(i int) as language plcsql
begin
    dbms_output.put_line('OK');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

create or replace procedure t(i int) as
begin
    dbms_output.put_line('OK');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
